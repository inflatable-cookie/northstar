use crate::{DiscoveryRecord, Scope};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::{BTreeMap, BTreeSet};
use std::path::{Component, Path};

const CONTEXT_RELATIONS: [&str; 7] = [
    "owning_manifest",
    "caller",
    "implementation",
    "focused_test",
    "governed_documentation",
    "architecture_contract",
    "tool_configuration",
];

#[derive(Debug, Deserialize)]
pub struct ScopePlanInput {
    pub audit_id: String,
    pub units: Vec<ScopeUnitInput>,
    #[serde(default)]
    pub excluded_dirty_files: Vec<ExcludedDirtyFile>,
    pub repository_coverage: Option<RepositoryCoverage>,
}

#[derive(Debug, Deserialize)]
pub struct ScopeUnitInput {
    pub unit_id: String,
    pub anchors: Vec<String>,
    #[serde(default)]
    pub context: Vec<ContextInput>,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct ContextInput {
    pub path: String,
    pub anchor: String,
    pub relation: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct ExcludedDirtyFile {
    pub path: String,
    pub reason: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RepositoryCoverage {
    pub claim: String,
    pub workspaces: Vec<String>,
    pub packages: Vec<String>,
    pub targets: Vec<String>,
    pub features: Vec<String>,
    pub public_api_surfaces: Vec<String>,
    pub risk_boundaries: Vec<String>,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct ScopePlan {
    pub schema_version: String,
    pub audit_id: String,
    pub repository_root: String,
    pub scope: Scope,
    pub discovery_sha256: String,
    pub units: Vec<ScopeUnit>,
    pub excluded_dirty_files: Vec<ExcludedDirtyFile>,
    pub repository_coverage: Option<RepositoryCoverage>,
    pub plan_sha256: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct ScopeUnit {
    pub unit_id: String,
    pub anchors: Vec<String>,
    pub mutable_files: Vec<String>,
    pub read_only_context: Vec<ContextInput>,
}

/// Validates ownership and coverage claims against an immutable discovery record.
///
/// # Errors
///
/// Returns an error when paths are unsafe, dirty files lack dispositions,
/// ownership overlaps, context lacks an anchor relation, or repository coverage
/// does not exactly match Cargo discovery.
pub fn build_scope_plan(
    discovery: &DiscoveryRecord,
    input: ScopePlanInput,
) -> Result<ScopePlan, String> {
    validate_identifier(&input.audit_id, "scope.audit_id")?;
    if input.units.is_empty() {
        return Err("scope.units_empty: at least one assessed unit is required".to_owned());
    }

    let dirty_anchors: BTreeSet<String> = discovery
        .rust_anchors
        .iter()
        .map(|anchor| anchor.path.clone())
        .collect();
    let (units, owners) = build_units(discovery.scope, input.units, &dirty_anchors)?;
    let excluded = validate_dirty_dispositions(
        discovery,
        input.excluded_dirty_files,
        &owners,
        &dirty_anchors,
    )?;
    if discovery.scope == Scope::Worktree {
        if input.repository_coverage.is_some() {
            return Err(
                "scope.worktree_full_claim: worktree cannot claim repository coverage".to_owned(),
            );
        }
    } else {
        validate_repository_coverage(discovery, input.repository_coverage.as_ref(), &owners)?;
    }

    let mut plan = ScopePlan {
        schema_version: "northstar.rust-quality.scope-plan.v1".to_owned(),
        audit_id: input.audit_id,
        repository_root: discovery.repository_root.clone(),
        scope: discovery.scope,
        discovery_sha256: discovery.snapshot_sha256.clone(),
        units,
        excluded_dirty_files: excluded,
        repository_coverage: input.repository_coverage,
        plan_sha256: String::new(),
    };
    let canonical = serde_json::to_vec(&plan).map_err(|error| error.to_string())?;
    plan.plan_sha256 = format!("{:x}", Sha256::digest(canonical));
    Ok(plan)
}

fn build_units(
    scope: Scope,
    inputs: Vec<ScopeUnitInput>,
    dirty_anchors: &BTreeSet<String>,
) -> Result<(Vec<ScopeUnit>, BTreeMap<String, String>), String> {
    let mut owners = BTreeMap::new();
    let mut units = Vec::new();
    for input in inputs {
        validate_identifier(&input.unit_id, "scope.unit_id")?;
        if input.anchors.is_empty() {
            return Err(format!(
                "scope.unit_anchor_missing: {} has no anchor",
                input.unit_id
            ));
        }
        let anchors = normalized_unique(input.anchors, "scope.anchor")?;
        for anchor in &anchors {
            if scope == Scope::Worktree && !dirty_anchors.contains(anchor) {
                return Err(format!(
                    "scope.anchor_not_dirty: {anchor} is not a discovered dirty Rust anchor"
                ));
            }
            claim_owner(&mut owners, anchor, &input.unit_id)?;
        }
        let contexts = validate_context(input.context, &anchors, &input.unit_id, &mut owners)?;
        units.push(ScopeUnit {
            unit_id: input.unit_id,
            mutable_files: anchors.clone(),
            anchors,
            read_only_context: contexts,
        });
    }
    units.sort_by(|left, right| left.unit_id.cmp(&right.unit_id));
    Ok((units, owners))
}

fn validate_context(
    mut contexts: Vec<ContextInput>,
    anchors: &[String],
    unit_id: &str,
    owners: &mut BTreeMap<String, String>,
) -> Result<Vec<ContextInput>, String> {
    contexts.sort_by(|left, right| left.path.cmp(&right.path));
    let mut seen = BTreeSet::new();
    for context in &contexts {
        validate_relative_path(&context.path, "scope.context")?;
        validate_relative_path(&context.anchor, "scope.context_anchor")?;
        if !anchors.contains(&context.anchor) {
            return Err(format!(
                "scope.context_anchor_foreign: {} does not belong to {unit_id}",
                context.anchor
            ));
        }
        if !CONTEXT_RELATIONS.contains(&context.relation.as_str()) {
            return Err(format!(
                "scope.context_relation_invalid: {} has relation {}",
                context.path, context.relation
            ));
        }
        if !seen.insert(context.path.clone()) {
            return Err(format!("scope.context_duplicate: {}", context.path));
        }
        claim_owner(owners, &context.path, unit_id)?;
    }
    Ok(contexts)
}

fn validate_dirty_dispositions(
    discovery: &DiscoveryRecord,
    mut excluded: Vec<ExcludedDirtyFile>,
    owners: &BTreeMap<String, String>,
    dirty_anchors: &BTreeSet<String>,
) -> Result<Vec<ExcludedDirtyFile>, String> {
    let dirty: BTreeSet<_> = discovery
        .dirty_files
        .iter()
        .map(|file| file.path.as_str())
        .collect();
    excluded.sort_by(|left, right| left.path.cmp(&right.path));
    let mut excluded_paths = BTreeSet::new();
    for item in &excluded {
        validate_relative_path(&item.path, "scope.excluded")?;
        if item.reason.trim().is_empty() {
            return Err(format!("scope.excluded_reason_empty: {}", item.path));
        }
        if !dirty.contains(item.path.as_str()) {
            return Err(format!("scope.excluded_not_dirty: {}", item.path));
        }
        if owners.contains_key(&item.path) || !excluded_paths.insert(item.path.clone()) {
            return Err(format!("scope.dirty_disposition_duplicate: {}", item.path));
        }
    }
    for path in dirty {
        if !owners.contains_key(path) && !excluded_paths.contains(path) {
            return Err(format!("scope.dirty_undisposed: {path}"));
        }
    }
    if discovery.scope == Scope::Worktree {
        for anchor in dirty_anchors {
            if !owners.contains_key(anchor) {
                return Err(format!("scope.anchor_unowned: {anchor}"));
            }
        }
    }
    Ok(excluded)
}

fn validate_repository_coverage(
    discovery: &DiscoveryRecord,
    coverage: Option<&RepositoryCoverage>,
    owners: &BTreeMap<String, String>,
) -> Result<(), String> {
    let coverage = coverage.ok_or_else(|| {
        "scope.repository_coverage_missing: repository scope requires a full coverage claim"
            .to_owned()
    })?;
    if coverage.claim != "full_repository" {
        return Err("scope.repository_claim_invalid: expected full_repository".to_owned());
    }

    let expected_workspaces = discovery
        .workspaces
        .iter()
        .map(|workspace| workspace.root.clone())
        .collect();
    let expected_packages = discovery
        .workspaces
        .iter()
        .flat_map(|workspace| workspace.packages.iter())
        .map(|package| package.manifest_path.clone())
        .collect();
    let expected_targets = discovery
        .workspaces
        .iter()
        .flat_map(|workspace| workspace.packages.iter())
        .flat_map(|package| package.targets.iter())
        .map(|target| target.source_path.clone())
        .collect();
    let expected_features = discovery
        .workspaces
        .iter()
        .flat_map(|workspace| workspace.packages.iter())
        .flat_map(|package| {
            package
                .features
                .iter()
                .map(|feature| format!("{}:{feature}", package.name))
        })
        .collect();

    require_exact(&coverage.workspaces, &expected_workspaces, "workspaces")?;
    require_exact(&coverage.packages, &expected_packages, "packages")?;
    require_exact(&coverage.targets, &expected_targets, "targets")?;
    require_exact(&coverage.features, &expected_features, "features")?;
    if coverage.public_api_surfaces.is_empty() || coverage.risk_boundaries.is_empty() {
        return Err(
            "scope.repository_risk_inventory_empty: public API and risk inventories require evidence"
                .to_owned(),
        );
    }
    for required in coverage.packages.iter().chain(&coverage.targets) {
        if !owners.contains_key(required) {
            return Err(format!("scope.repository_surface_unowned: {required}"));
        }
    }
    Ok(())
}

fn require_exact(
    actual: &[String],
    expected: &BTreeSet<String>,
    label: &str,
) -> Result<(), String> {
    let actual: BTreeSet<_> = actual.iter().cloned().collect();
    if &actual != expected {
        return Err(format!(
            "scope.repository_coverage_mismatch: {label} inventory differs from Cargo discovery"
        ));
    }
    Ok(())
}

fn normalized_unique(mut paths: Vec<String>, code: &str) -> Result<Vec<String>, String> {
    paths.sort();
    let mut seen = BTreeSet::new();
    for path in &paths {
        validate_relative_path(path, code)?;
        if !seen.insert(path.clone()) {
            return Err(format!("{code}_duplicate: {path}"));
        }
    }
    Ok(paths)
}

fn claim_owner(
    owners: &mut BTreeMap<String, String>,
    path: &str,
    unit_id: &str,
) -> Result<(), String> {
    if let Some(owner) = owners.insert(path.to_owned(), unit_id.to_owned()) {
        return Err(format!(
            "scope.ownership_overlap: {path} belongs to {owner} and {unit_id}"
        ));
    }
    Ok(())
}

fn validate_identifier(value: &str, code: &str) -> Result<(), String> {
    if value.is_empty()
        || !value
            .bytes()
            .all(|byte| byte.is_ascii_alphanumeric() || matches!(byte, b'-' | b'_' | b'.'))
    {
        return Err(format!("{code}_invalid: {value}"));
    }
    Ok(())
}

fn validate_relative_path(value: &str, code: &str) -> Result<(), String> {
    let path = Path::new(value);
    if value.is_empty()
        || path.is_absolute()
        || path.components().any(|component| {
            matches!(
                component,
                Component::ParentDir | Component::RootDir | Component::Prefix(_)
            )
        })
    {
        return Err(format!("{code}_invalid_path: {value}"));
    }
    Ok(())
}
