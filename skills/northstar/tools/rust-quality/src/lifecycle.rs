use crate::evidence::{
    EvidenceRecord, collect, limitations as evidence_limitations, read_verified,
};
use crate::{
    Assessment, AssessmentInput, CollectionReceipt, DiscoveryRecord, EvidencePlan, Scope,
    ScopePlan, StrictProjection, validate_assessment,
};
use serde::{Deserialize, Serialize};
use serde_json::{Value, json};
use sha2::{Digest, Sha256};
use std::collections::{BTreeMap, BTreeSet};
use std::fmt::Write as _;
use std::fs::{self, OpenOptions};
use std::io::Write as _;
use std::path::{Component, Path, PathBuf};
use std::process::Command;

const CONTEXT_RELATIONS: [&str; 7] = [
    "owning_manifest",
    "caller",
    "implementation",
    "focused_test",
    "governed_documentation",
    "architecture_contract",
    "tool_configuration",
];

#[derive(Debug, Deserialize, Serialize)]
pub struct ExtensionInput {
    pub unit_id: String,
    pub reason: String,
    pub files: Vec<ExtensionFile>,
    pub plan_extensions: Vec<PlanExtension>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct ExtensionFile {
    pub path: String,
    pub anchor: String,
    pub relation: String,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct PlanExtension {
    pub plan_id: String,
    pub files: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct CompletionInput {
    pub unit_id: String,
    pub repairs: Vec<RepairCompletion>,
    #[serde(default)]
    pub evidence_ids: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct RepairCompletion {
    pub plan_id: String,
    pub status: String,
    pub changed_files: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize)]
struct AuditManifest {
    schema_version: String,
    audit_id: String,
    repository_root: String,
    scope: Scope,
    discovery_sha256: String,
    plan_sha256: String,
    policy_sha256: String,
    profile_sha256: String,
    deviations_sha256: String,
    units: Vec<UnitState>,
    excluded_files: Vec<String>,
    baseline_sha256: BTreeMap<String, String>,
}

#[derive(Debug, Deserialize, Serialize)]
struct UnitState {
    unit_id: String,
    anchors: Vec<String>,
    mutable_files: Vec<String>,
    read_only_files: Vec<String>,
    extensions: Vec<ExtensionInput>,
}

#[derive(Debug, Serialize)]
pub struct OperationReceipt {
    pub schema_version: &'static str,
    pub audit_id: String,
    pub operation: &'static str,
    pub record_root: String,
}

/// Initializes an audit from checked discovery and scope records.
///
/// # Errors
///
/// Returns an error if discovery is stale, records disagree, paths are unsafe,
/// or the audit identifier already exists in repository Git metadata.
pub fn initialize_audit(
    repository: &Path,
    discovery: &DiscoveryRecord,
    plan: &ScopePlan,
    policy_path: &Path,
    profile_path: &Path,
    deviations_path: &Path,
) -> Result<OperationReceipt, String> {
    require_id(&plan.audit_id, "lifecycle.audit_id_invalid")?;
    let root = canonical_git_root(repository)?;
    if discovery.repository_root != slash(&root)
        || plan.repository_root != discovery.repository_root
    {
        return Err("lifecycle.repository_mismatch: discovery, plan, and target differ".to_owned());
    }
    if plan.discovery_sha256 != discovery.snapshot_sha256 || plan.scope != discovery.scope {
        return Err(
            "lifecycle.plan_discovery_mismatch: scope plan does not bind discovery".to_owned(),
        );
    }
    verify_plan_hash(plan)?;
    let live = crate::inspect(&root, discovery.scope)?;
    if live.snapshot_sha256 != discovery.snapshot_sha256 {
        return Err("lifecycle.discovery_stale: repository changed after discovery".to_owned());
    }

    let record_root = audit_root(&root, &plan.audit_id)?;
    if record_root.exists() {
        return Err(format!("lifecycle.audit_exists: {}", plan.audit_id));
    }
    let policy =
        fs::read(policy_path).map_err(|error| format!("lifecycle.policy_read: {error}"))?;
    let _: StrictProjection = serde_json::from_slice(&policy)
        .map_err(|error| format!("lifecycle.policy_parse: {error}"))?;
    let profile =
        fs::read(profile_path).map_err(|error| format!("lifecycle.profile_read: {error}"))?;
    let profile_record: Value = serde_json::from_slice(&profile)
        .map_err(|error| format!("lifecycle.profile_parse: {error}"))?;
    if profile_record["schema_version"] != "1.0.0"
        || profile_record["language"] != "rust"
        || profile_record["profile"] != "strict"
    {
        return Err("lifecycle.profile_invalid: expected Rust strict profile v1".to_owned());
    }
    let deviations =
        fs::read(deviations_path).map_err(|error| format!("lifecycle.deviations_read: {error}"))?;
    validate_deviations_document(&deviations)?;

    let mut baseline = BTreeMap::new();
    let mut units = Vec::new();
    for unit in &plan.units {
        require_id(&unit.unit_id, "lifecycle.unit_id_invalid")?;
        let read_only_files = unit
            .read_only_context
            .iter()
            .map(|context| context.path.clone())
            .collect::<Vec<_>>();
        for path in unit.mutable_files.iter().chain(&read_only_files) {
            record_baseline(&root, path, &mut baseline)?;
        }
        units.push(UnitState {
            unit_id: unit.unit_id.clone(),
            anchors: unit.anchors.clone(),
            mutable_files: unit.mutable_files.clone(),
            read_only_files,
            extensions: Vec::new(),
        });
    }
    let excluded_files = plan
        .excluded_dirty_files
        .iter()
        .map(|item| item.path.clone())
        .collect::<Vec<_>>();
    for path in &excluded_files {
        record_baseline(&root, path, &mut baseline)?;
    }
    let manifest = AuditManifest {
        schema_version: "northstar.rust-quality.audit-manifest.v2".to_owned(),
        audit_id: plan.audit_id.clone(),
        repository_root: slash(&root),
        scope: plan.scope,
        discovery_sha256: discovery.snapshot_sha256.clone(),
        plan_sha256: plan.plan_sha256.clone(),
        policy_sha256: digest(&policy),
        profile_sha256: digest(&profile),
        deviations_sha256: digest(&deviations),
        units,
        excluded_files,
        baseline_sha256: baseline,
    };

    fs::create_dir_all(record_root.join("units"))
        .map_err(|error| format!("lifecycle.record_create: {error}"))?;
    write_new_json(&record_root.join("manifest.json"), &manifest)?;
    write_new_json(&record_root.join("discovery.json"), discovery)?;
    write_new_json(&record_root.join("scope-plan.json"), plan)?;
    write_new(&record_root.join("strict-audit.json"), &policy)?;
    write_new(&record_root.join("rust-quality-profile.json"), &profile)?;
    write_new(
        &record_root.join("rust-quality-deviations.json"),
        &deviations,
    )?;
    Ok(receipt(&manifest, "init", &record_root))
}

/// Validates and records one complete unit-rule assessment before mutation.
///
/// # Errors
///
/// Returns an error for stale files, unknown ownership, invalid ledger content,
/// repair plans outside mutable scope, or a repeated assessment.
pub fn assess_unit(
    repository: &Path,
    audit_id: &str,
    input: AssessmentInput,
) -> Result<OperationReceipt, String> {
    let (root, record_root, manifest) = load_audit(repository, audit_id)?;
    let unit = find_unit(&manifest, &input.unit_id)?;
    require_unchanged(
        &root,
        unit_files(unit),
        &manifest.baseline_sha256,
        "assessment",
    )?;
    let projection: StrictProjection = read_json(&record_root.join("strict-audit.json"))?;
    verify_policy(&record_root, &manifest)?;
    let assessment = validate_assessment(&projection, input)?;
    validate_assessment_ownership(unit, &assessment)?;
    validate_deviation_findings(&record_root, &assessment)?;
    let path = unit_path(&record_root, &assessment.unit_id, "assessment.json");
    write_new_json(&path, &assessment)?;
    Ok(receipt(&manifest, "assess", &record_root))
}

/// Extends one assessed unit and its repair plans before any new file changes.
///
/// # Errors
///
/// Returns an error for missing assessment, stale state, cross-unit ownership,
/// unrelated paths, or extension files not attributed to exactly one plan.
pub fn extend_unit(
    repository: &Path,
    audit_id: &str,
    input: ExtensionInput,
) -> Result<OperationReceipt, String> {
    require_text(&input.reason, "lifecycle.extension_reason_empty")?;
    if input.files.is_empty() {
        return Err("lifecycle.extension_files_empty".to_owned());
    }
    let (root, record_root, mut manifest) = load_audit(repository, audit_id)?;
    ensure_not_completed(&record_root, &input.unit_id)?;
    let assessment_path = unit_path(&record_root, &input.unit_id, "assessment.json");
    let mut assessment: Assessment = read_json(&assessment_path)?;
    let unit_index = manifest
        .units
        .iter()
        .position(|unit| unit.unit_id == input.unit_id)
        .ok_or_else(|| format!("lifecycle.unit_unknown: {}", input.unit_id))?;
    require_all_unchanged(&root, &manifest)?;

    let all_owned = manifest
        .units
        .iter()
        .flat_map(|unit| unit.mutable_files.iter().chain(&unit.read_only_files))
        .cloned()
        .collect::<BTreeSet<_>>();
    let anchors = manifest.units[unit_index]
        .anchors
        .iter()
        .cloned()
        .collect::<BTreeSet<_>>();
    let mut extension_paths = BTreeSet::new();
    for file in &input.files {
        require_relative(&file.path, "lifecycle.extension_path_invalid")?;
        if all_owned.contains(&file.path) || !extension_paths.insert(file.path.clone()) {
            return Err(format!(
                "lifecycle.extension_owned_or_duplicate: {}",
                file.path
            ));
        }
        if !anchors.contains(&file.anchor) || !CONTEXT_RELATIONS.contains(&file.relation.as_str()) {
            return Err(format!(
                "lifecycle.extension_relation_invalid: {}",
                file.path
            ));
        }
    }
    let mut attributed = BTreeSet::new();
    for extension in &input.plan_extensions {
        require_id(&extension.plan_id, "lifecycle.extension_plan_id_invalid")?;
        let plan = assessment
            .repair_plans
            .iter_mut()
            .find(|plan| plan.plan_id == extension.plan_id)
            .ok_or_else(|| format!("lifecycle.extension_plan_unknown: {}", extension.plan_id))?;
        for path in &extension.files {
            if !extension_paths.contains(path) || !attributed.insert(path.clone()) {
                return Err(format!("lifecycle.extension_plan_file_invalid: {path}"));
            }
            plan.owned_files.push(path.clone());
            plan.owned_files.sort();
            plan.owned_files.dedup();
        }
    }
    if attributed != extension_paths {
        return Err(
            "lifecycle.extension_unattributed: every extension needs one repair plan".to_owned(),
        );
    }
    for path in &extension_paths {
        record_baseline(&root, path, &mut manifest.baseline_sha256)?;
    }
    manifest.units[unit_index]
        .mutable_files
        .extend(extension_paths.iter().cloned());
    manifest.units[unit_index].mutable_files.sort();
    manifest.units[unit_index].extensions.push(input);
    write_json(&assessment_path, &assessment)?;
    write_json(&record_root.join("manifest.json"), &manifest)?;
    Ok(receipt(&manifest, "extend", &record_root))
}

/// Attributes final file changes to authorized repair plans for one unit.
///
/// # Errors
///
/// Returns an error for missing plans, hidden mutation, read-only changes,
/// false attribution, or applied repairs without passing validation.
pub fn complete_unit(
    repository: &Path,
    audit_id: &str,
    input: &CompletionInput,
) -> Result<OperationReceipt, String> {
    let (root, record_root, manifest) = load_audit(repository, audit_id)?;
    ensure_not_completed(&record_root, &input.unit_id)?;
    let unit = find_unit(&manifest, &input.unit_id)?;
    let assessment: Assessment =
        read_json(&unit_path(&record_root, &input.unit_id, "assessment.json"))?;
    require_unchanged(
        &root,
        unit.read_only_files.iter().chain(&manifest.excluded_files),
        &manifest.baseline_sha256,
        "read-only",
    )?;
    validate_completion(&root, &record_root, unit, &manifest, &assessment, input)?;
    write_new_json(
        &unit_path(&record_root, &input.unit_id, "completion.json"),
        input,
    )?;
    Ok(receipt(&manifest, "complete", &record_root))
}

/// Finalizes all unit records into deterministic JSON and Markdown reports.
///
/// # Errors
///
/// Returns an error for incomplete units, changed policy, hidden mutation,
/// changed excluded/read-only files, or an existing result.
pub fn finalize_audit(repository: &Path, audit_id: &str) -> Result<Value, String> {
    let (root, record_root, manifest) = load_audit(repository, audit_id)?;
    let result_path = record_root.join("result.json");
    if result_path.exists() {
        return Err(format!("lifecycle.already_finalized: {audit_id}"));
    }
    verify_policy(&record_root, &manifest)?;
    require_all_unchanged_except_mutable(&root, &manifest)?;

    let mut units = Vec::new();
    let mut changed_files = BTreeSet::new();
    let mut limitations = BTreeMap::new();
    let mut operator_action = false;
    for unit in &manifest.units {
        let assessment_path = unit_path(&record_root, &unit.unit_id, "assessment.json");
        let completion_path = unit_path(&record_root, &unit.unit_id, "completion.json");
        if !assessment_path.is_file() {
            return Err(format!("lifecycle.unit_not_assessed: {}", unit.unit_id));
        }
        if !completion_path.is_file() {
            return Err(format!("lifecycle.unit_not_completed: {}", unit.unit_id));
        }
        let assessment: Assessment = read_json(&assessment_path)?;
        let completion: CompletionInput = read_json(&completion_path)?;
        let evidence = validate_completion(
            &root,
            &record_root,
            unit,
            &manifest,
            &assessment,
            &completion,
        )?;
        let unit_changed = changed_paths(&root, &unit.mutable_files, &manifest.baseline_sha256)?;
        changed_files.extend(unit_changed.iter().cloned());
        derive_limitations(
            &assessment,
            &completion,
            &evidence,
            &mut limitations,
            &mut operator_action,
        )?;
        units.push(json!({
            "unit_id": unit.unit_id,
            "changed_files": unit_changed,
            "assessment": assessment,
            "completion": completion,
            "evidence": evidence
        }));
    }
    let status = if operator_action {
        "operator_action_required"
    } else if limitations.is_empty() {
        "clean"
    } else {
        "degraded"
    };
    let limitations = limitations.into_values().collect::<Vec<_>>();
    let result = json!({
        "schema_version": "northstar.rust-quality.audit-result.v2",
        "audit_id": manifest.audit_id,
        "scope": manifest.scope,
        "status": status,
        "discovery_sha256": manifest.discovery_sha256,
        "plan_sha256": manifest.plan_sha256,
        "policy_sha256": manifest.policy_sha256,
        "profile_sha256": manifest.profile_sha256,
        "deviations_sha256": manifest.deviations_sha256,
        "changed_files": changed_files,
        "limitations": limitations,
        "units": units
    });
    write_new_json(&result_path, &result)?;
    write_new(
        &record_root.join("report.md"),
        render_report(&result).as_bytes(),
    )?;
    Ok(result)
}

fn validate_assessment_ownership(unit: &UnitState, assessment: &Assessment) -> Result<(), String> {
    let owned = unit
        .mutable_files
        .iter()
        .chain(&unit.read_only_files)
        .collect::<BTreeSet<_>>();
    let mutable = unit.mutable_files.iter().collect::<BTreeSet<_>>();
    for finding in &assessment.findings {
        if !owned.contains(&finding.file) {
            return Err(format!("lifecycle.finding_cross_unit: {}", finding.file));
        }
    }
    for plan in &assessment.repair_plans {
        if plan.owned_files.iter().any(|path| !mutable.contains(path)) {
            return Err(format!("lifecycle.plan_cross_unit: {}", plan.plan_id));
        }
    }
    Ok(())
}

fn validate_completion(
    root: &Path,
    record_root: &Path,
    unit: &UnitState,
    manifest: &AuditManifest,
    assessment: &Assessment,
    input: &CompletionInput,
) -> Result<Vec<EvidenceRecord>, String> {
    if input.unit_id != unit.unit_id {
        return Err("lifecycle.completion_unit_mismatch".to_owned());
    }
    let plans = assessment
        .repair_plans
        .iter()
        .map(|plan| (plan.plan_id.as_str(), plan))
        .collect::<BTreeMap<_, _>>();
    let mut seen = BTreeSet::new();
    let mut attributed = BTreeSet::new();
    let mut applied = false;
    for repair in &input.repairs {
        let plan = plans
            .get(repair.plan_id.as_str())
            .ok_or_else(|| format!("lifecycle.completion_plan_unknown: {}", repair.plan_id))?;
        if !seen.insert(repair.plan_id.as_str()) {
            return Err(format!(
                "lifecycle.completion_plan_duplicate: {}",
                repair.plan_id
            ));
        }
        match repair.status.as_str() {
            "applied" => {
                applied = true;
                if repair.changed_files.is_empty()
                    || repair.changed_files.iter().any(|path| {
                        !plan.owned_files.contains(path) || !attributed.insert(path.clone())
                    })
                {
                    return Err(format!(
                        "lifecycle.repair_attribution_invalid: {}",
                        repair.plan_id
                    ));
                }
            }
            "not_applied" if repair.changed_files.is_empty() => {}
            _ => {
                return Err(format!(
                    "lifecycle.repair_status_invalid: {}",
                    repair.plan_id
                ));
            }
        }
    }
    if seen != plans.keys().copied().collect() {
        return Err("lifecycle.completion_plan_inventory_mismatch".to_owned());
    }
    let changed = changed_paths(root, &unit.mutable_files, &manifest.baseline_sha256)?;
    if attributed != changed {
        return Err(
            "lifecycle.hidden_or_false_mutation: changed files do not match repairs".to_owned(),
        );
    }
    let mut evidence = Vec::new();
    let mut evidence_ids = BTreeSet::new();
    for evidence_id in &input.evidence_ids {
        require_id(evidence_id, "lifecycle.evidence_id_invalid")?;
        if !evidence_ids.insert(evidence_id.clone()) {
            return Err(format!("lifecycle.evidence_id_duplicate: {evidence_id}"));
        }
        let record = read_verified(
            &record_root
                .join("evidence")
                .join(format!("{evidence_id}.json")),
        )?;
        if record.unit_id.as_deref() != Some(&input.unit_id) {
            return Err(format!("lifecycle.evidence_unit_mismatch: {evidence_id}"));
        }
        evidence.push(record);
    }
    let available = unit_evidence_ids(record_root, &input.unit_id)?;
    if available.is_empty() {
        return Err("lifecycle.evidence_required".to_owned());
    }
    if evidence_ids != available {
        return Err("lifecycle.evidence_inventory_mismatch".to_owned());
    }
    if applied && !evidence.iter().any(|item| item.status == "passed") {
        return Err("lifecycle.applied_without_validation".to_owned());
    }
    Ok(evidence)
}

fn unit_evidence_ids(record_root: &Path, unit_id: &str) -> Result<BTreeSet<String>, String> {
    let evidence_root = record_root.join("evidence");
    if !evidence_root.is_dir() {
        return Ok(BTreeSet::new());
    }
    let mut ids = BTreeSet::new();
    let entries = fs::read_dir(&evidence_root)
        .map_err(|error| format!("lifecycle.evidence_scan: {error}"))?;
    for entry in entries {
        let entry = entry.map_err(|error| format!("lifecycle.evidence_scan: {error}"))?;
        let path = entry.path();
        if path.extension().and_then(|value| value.to_str()) != Some("json") {
            continue;
        }
        let record = read_verified(&path)?;
        if record.unit_id.as_deref() == Some(unit_id) {
            ids.insert(record.evidence_id);
        }
    }
    Ok(ids)
}

fn derive_limitations(
    assessment: &Assessment,
    completion: &CompletionInput,
    evidence: &[EvidenceRecord],
    output: &mut BTreeMap<String, Value>,
    operator_action: &mut bool,
) -> Result<(), String> {
    for limitation in &assessment.limitations {
        insert_limitation(
            output,
            &limitation.key,
            json!({"key": limitation.key, "kind": limitation.kind, "evidence": limitation.evidence}),
        )?;
    }
    for finding in &assessment.findings {
        if finding.disposition != "repair_planned" {
            let key = format!("finding:{}", finding.id);
            insert_limitation(
                output,
                &key,
                json!({"key": key, "kind": "retained_finding", "evidence": [finding.evidence]}),
            )?;
        }
        *operator_action |= finding.disposition == "operator_decision";
    }
    for repair in &completion.repairs {
        if repair.status == "not_applied" {
            let key = format!("repair:{}", repair.plan_id);
            insert_limitation(
                output,
                &key,
                json!({"key": key, "kind": "repair_not_applied", "evidence": ["Authorized repair was retained"]}),
            )?;
        }
    }
    for limitation in evidence_limitations(evidence) {
        let key = limitation.key.clone();
        insert_limitation(
            output,
            &key,
            serde_json::to_value(limitation).map_err(|error| error.to_string())?,
        )?;
    }
    Ok(())
}

fn insert_limitation(
    output: &mut BTreeMap<String, Value>,
    key: &str,
    value: Value,
) -> Result<(), String> {
    if output.insert(key.to_owned(), value).is_some() {
        Err(format!("lifecycle.limitation_key_duplicate: {key}"))
    } else {
        Ok(())
    }
}

fn render_report(result: &Value) -> String {
    let mut report = format!(
        "# Rust quality audit {}\n\nStatus: `{}`  \nScope: `{}`  \nDiscovery: `{}`  \nPlan: `{}`  \nPolicy: `{}`\n\n## Units\n",
        result["audit_id"].as_str().unwrap_or("unknown"),
        result["status"].as_str().unwrap_or("unknown"),
        result["scope"].as_str().unwrap_or("unknown"),
        result["discovery_sha256"].as_str().unwrap_or("unknown"),
        result["plan_sha256"].as_str().unwrap_or("unknown"),
        result["policy_sha256"].as_str().unwrap_or("unknown")
    );
    if let Some(units) = result["units"].as_array() {
        for unit in units {
            render_unit(&mut report, unit);
        }
    }
    report.push_str("\n## Changed files\n");
    let changed = result["changed_files"]
        .as_array()
        .map_or(&[][..], Vec::as_slice);
    if changed.is_empty() {
        report.push_str("\n- None\n");
    } else {
        for path in changed {
            let _ = write!(report, "\n- `{}`\n", path.as_str().unwrap_or("invalid"));
        }
    }
    report.push_str("\n## Limitations\n");
    let limitations = result["limitations"]
        .as_array()
        .map_or(&[][..], Vec::as_slice);
    if limitations.is_empty() {
        report.push_str("\n- None\n");
    } else {
        for limitation in limitations {
            let evidence = limitation["evidence"].as_array().map_or_else(
                || "No evidence".to_owned(),
                |items| {
                    items
                        .iter()
                        .filter_map(Value::as_str)
                        .collect::<Vec<_>>()
                        .join("; ")
                },
            );
            let _ = write!(
                report,
                "\n- `{}`: {}\n",
                limitation["key"].as_str().unwrap_or("invalid"),
                evidence
            );
        }
    }
    report
}

fn render_unit(report: &mut String, unit: &Value) {
    let _ = write!(
        report,
        "\n### {}\n\nFindings:\n",
        unit["unit_id"].as_str().unwrap_or("unknown")
    );
    let findings = unit["assessment"]["findings"]
        .as_array()
        .map_or(&[][..], Vec::as_slice);
    if findings.is_empty() {
        report.push_str("\n- None\n");
    } else {
        for finding in findings {
            let _ = write!(
                report,
                "\n- `{}` / `{}` / `{}` in `{}`: {}\n",
                finding["finding_id"].as_str().unwrap_or("invalid"),
                finding["rule_id"].as_str().unwrap_or("invalid"),
                finding["disposition"].as_str().unwrap_or("invalid"),
                finding["file"].as_str().unwrap_or("invalid"),
                finding["evidence"].as_str().unwrap_or("No evidence")
            );
        }
    }
    report.push_str("\nRepairs:\n");
    let repairs = unit["completion"]["repairs"]
        .as_array()
        .map_or(&[][..], Vec::as_slice);
    if repairs.is_empty() {
        report.push_str("\n- None\n");
    } else {
        for repair in repairs {
            let changed = repair["changed_files"]
                .as_array()
                .map(|paths| {
                    paths
                        .iter()
                        .filter_map(Value::as_str)
                        .collect::<Vec<_>>()
                        .join(", ")
                })
                .unwrap_or_default();
            let _ = write!(
                report,
                "\n- `{}`: `{}`; changed: {}\n",
                repair["plan_id"].as_str().unwrap_or("invalid"),
                repair["status"].as_str().unwrap_or("invalid"),
                if changed.is_empty() { "none" } else { &changed }
            );
        }
    }
    report.push_str("\nEvidence:\n");
    let evidence = unit["evidence"].as_array().map_or(&[][..], Vec::as_slice);
    if evidence.is_empty() {
        report.push_str("\n- None recorded\n");
    } else {
        for item in evidence {
            let _ = write!(
                report,
                "\n- `{}`: `{}` — {}\n",
                item["evidence_id"].as_str().unwrap_or("invalid"),
                item["status"].as_str().unwrap_or("invalid"),
                item["selector"].as_str().unwrap_or("No selector")
            );
        }
    }
}

/// Runs and persists an explicit evidence plan for an active audit.
///
/// # Errors
///
/// Returns an error when the audit is unknown or the plan references unknown units.
pub fn collect_audit_evidence(
    repository: &Path,
    audit_id: &str,
    plan: EvidencePlan,
) -> Result<CollectionReceipt, String> {
    let (root, record_root, manifest) = load_audit(repository, audit_id)?;
    let units = manifest
        .units
        .iter()
        .map(|unit| unit.unit_id.clone())
        .collect::<BTreeSet<_>>();
    collect(&root, &record_root.join("evidence"), plan, Some(&units))
}

fn load_audit(
    repository: &Path,
    audit_id: &str,
) -> Result<(PathBuf, PathBuf, AuditManifest), String> {
    require_id(audit_id, "lifecycle.audit_id_invalid")?;
    let root = canonical_git_root(repository)?;
    let record_root = audit_root(&root, audit_id)?;
    let manifest: AuditManifest = read_json(&record_root.join("manifest.json"))?;
    if manifest.repository_root != slash(&root) || manifest.audit_id != audit_id {
        return Err("lifecycle.audit_identity_mismatch".to_owned());
    }
    Ok((root, record_root, manifest))
}

fn canonical_git_root(repository: &Path) -> Result<PathBuf, String> {
    let output = Command::new("git")
        .arg("-C")
        .arg(repository)
        .args(["rev-parse", "--show-toplevel"])
        .output()
        .map_err(|error| format!("lifecycle.git_startup: {error}"))?;
    if !output.status.success() {
        return Err(format!(
            "lifecycle.git_failed: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        ));
    }
    fs::canonicalize(String::from_utf8_lossy(&output.stdout).trim())
        .map_err(|error| format!("lifecycle.git_root: {error}"))
}

fn audit_root(repository: &Path, audit_id: &str) -> Result<PathBuf, String> {
    let output = Command::new("git")
        .arg("-C")
        .arg(repository)
        .args(["rev-parse", "--git-path", "northstar/rust-quality/audits"])
        .output()
        .map_err(|error| format!("lifecycle.git_path_startup: {error}"))?;
    if !output.status.success() {
        return Err("lifecycle.git_path_failed".to_owned());
    }
    let path = PathBuf::from(String::from_utf8_lossy(&output.stdout).trim());
    let base = if path.is_absolute() {
        path
    } else {
        repository.join(path)
    };
    Ok(base.join(audit_id))
}

fn verify_plan_hash(plan: &ScopePlan) -> Result<(), String> {
    let mut unhashed = plan.clone();
    unhashed.plan_sha256.clear();
    let calculated = digest(&serde_json::to_vec(&unhashed).map_err(|error| error.to_string())?);
    if calculated == plan.plan_sha256 {
        Ok(())
    } else {
        Err("lifecycle.plan_hash_mismatch".to_owned())
    }
}

fn verify_policy(record_root: &Path, manifest: &AuditManifest) -> Result<(), String> {
    for (name, expected) in [
        ("strict-audit.json", &manifest.policy_sha256),
        ("rust-quality-profile.json", &manifest.profile_sha256),
        ("rust-quality-deviations.json", &manifest.deviations_sha256),
    ] {
        let bytes = fs::read(record_root.join(name))
            .map_err(|error| format!("lifecycle.policy_read: {error}"))?;
        if digest(&bytes) != *expected {
            return Err(format!("lifecycle.policy_changed: {name}"));
        }
    }
    Ok(())
}

fn validate_deviations_document(bytes: &[u8]) -> Result<Value, String> {
    let document: Value = serde_json::from_slice(bytes)
        .map_err(|error| format!("lifecycle.deviations_parse: {error}"))?;
    if document["schema_version"] != "1.0.0"
        || document["language"] != "rust"
        || !document["deviations"].is_array()
    {
        return Err("lifecycle.deviations_invalid: expected Rust deviations v1".to_owned());
    }
    Ok(document)
}

fn validate_deviation_findings(record_root: &Path, assessment: &Assessment) -> Result<(), String> {
    let bytes = fs::read(record_root.join("rust-quality-deviations.json"))
        .map_err(|error| format!("lifecycle.deviations_read: {error}"))?;
    let document = validate_deviations_document(&bytes)?;
    let deviations = document["deviations"]
        .as_array()
        .ok_or_else(|| "lifecycle.deviations_invalid".to_owned())?;
    for finding in assessment
        .findings
        .iter()
        .filter(|finding| finding.disposition == "deviation")
    {
        let covered = deviations.iter().any(|deviation| {
            deviation["rule_id"] == finding.rule_id
                && deviation["scope"]
                    .as_array()
                    .is_some_and(|scope| scope.iter().any(|path| path == &finding.file))
                && ["reason", "accepted_by", "recheck"].iter().all(|key| {
                    deviation[*key]
                        .as_str()
                        .is_some_and(|value| !value.trim().is_empty())
                })
                && deviation["evidence"]
                    .as_array()
                    .is_some_and(|items| !items.is_empty())
        });
        if !covered {
            return Err(format!("lifecycle.deviation_unaccepted: {}", finding.id));
        }
    }
    Ok(())
}

fn record_baseline(
    root: &Path,
    relative: &str,
    baseline: &mut BTreeMap<String, String>,
) -> Result<(), String> {
    require_relative(relative, "lifecycle.path_invalid")?;
    if baseline
        .insert(relative.to_owned(), fingerprint(&root.join(relative))?)
        .is_some()
    {
        return Err(format!("lifecycle.path_overlap: {relative}"));
    }
    Ok(())
}

fn fingerprint(path: &Path) -> Result<String, String> {
    match fs::symlink_metadata(path) {
        Ok(metadata) if metadata.file_type().is_symlink() => {
            Err(format!("lifecycle.symlink_unsupported: {}", path.display()))
        }
        Ok(metadata) if metadata.is_file() => fs::read(path)
            .map(|bytes| digest(&bytes))
            .map_err(|error| format!("lifecycle.file_read {}: {error}", path.display())),
        Ok(_) => Err(format!("lifecycle.not_file: {}", path.display())),
        Err(error) if error.kind() == std::io::ErrorKind::NotFound => Ok("missing".to_owned()),
        Err(error) => Err(format!("lifecycle.file_state {}: {error}", path.display())),
    }
}

fn changed_paths(
    root: &Path,
    paths: &[String],
    baseline: &BTreeMap<String, String>,
) -> Result<BTreeSet<String>, String> {
    paths
        .iter()
        .filter_map(|path| match fingerprint(&root.join(path)) {
            Ok(current) if baseline.get(path) != Some(&current) => Some(Ok(path.clone())),
            Ok(_) => None,
            Err(error) => Some(Err(error)),
        })
        .collect()
}

fn require_all_unchanged(root: &Path, manifest: &AuditManifest) -> Result<(), String> {
    require_unchanged(
        root,
        manifest.baseline_sha256.keys(),
        &manifest.baseline_sha256,
        "extension",
    )
}

fn require_all_unchanged_except_mutable(
    root: &Path,
    manifest: &AuditManifest,
) -> Result<(), String> {
    let mutable = manifest
        .units
        .iter()
        .flat_map(|unit| unit.mutable_files.iter())
        .collect::<BTreeSet<_>>();
    require_unchanged(
        root,
        manifest
            .baseline_sha256
            .keys()
            .filter(|path| !mutable.contains(path)),
        &manifest.baseline_sha256,
        "finalization",
    )
}

fn require_unchanged<'a>(
    root: &Path,
    paths: impl IntoIterator<Item = &'a String>,
    baseline: &BTreeMap<String, String>,
    phase: &str,
) -> Result<(), String> {
    for path in paths {
        if baseline.get(path) != Some(&fingerprint(&root.join(path))?) {
            return Err(format!("lifecycle.{phase}_file_changed: {path}"));
        }
    }
    Ok(())
}

fn unit_files(unit: &UnitState) -> impl Iterator<Item = &String> {
    unit.mutable_files.iter().chain(&unit.read_only_files)
}

fn find_unit<'a>(manifest: &'a AuditManifest, unit_id: &str) -> Result<&'a UnitState, String> {
    manifest
        .units
        .iter()
        .find(|unit| unit.unit_id == unit_id)
        .ok_or_else(|| format!("lifecycle.unit_unknown: {unit_id}"))
}

fn ensure_not_completed(record_root: &Path, unit_id: &str) -> Result<(), String> {
    if unit_path(record_root, unit_id, "completion.json").exists() {
        Err(format!("lifecycle.unit_completed: {unit_id}"))
    } else {
        Ok(())
    }
}

fn unit_path(record_root: &Path, unit_id: &str, name: &str) -> PathBuf {
    record_root.join("units").join(unit_id).join(name)
}

fn receipt(
    manifest: &AuditManifest,
    operation: &'static str,
    record_root: &Path,
) -> OperationReceipt {
    OperationReceipt {
        schema_version: "northstar.rust-quality.operation.v1",
        audit_id: manifest.audit_id.clone(),
        operation,
        record_root: slash(record_root),
    }
}

fn read_json<T: serde::de::DeserializeOwned>(path: &Path) -> Result<T, String> {
    let bytes =
        fs::read(path).map_err(|error| format!("lifecycle.read {}: {error}", path.display()))?;
    serde_json::from_slice(&bytes)
        .map_err(|error| format!("lifecycle.parse {}: {error}", path.display()))
}

fn write_new_json<T: Serialize>(path: &Path, value: &T) -> Result<(), String> {
    let mut bytes = serde_json::to_vec_pretty(value).map_err(|error| error.to_string())?;
    bytes.push(b'\n');
    write_new(path, &bytes)
}

fn write_json<T: Serialize>(path: &Path, value: &T) -> Result<(), String> {
    let mut bytes = serde_json::to_vec_pretty(value).map_err(|error| error.to_string())?;
    bytes.push(b'\n');
    fs::write(path, bytes).map_err(|error| format!("lifecycle.write {}: {error}", path.display()))
}

fn write_new(path: &Path, bytes: &[u8]) -> Result<(), String> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).map_err(|error| format!("lifecycle.mkdir: {error}"))?;
    }
    let mut file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(path)
        .map_err(|error| format!("lifecycle.create {}: {error}", path.display()))?;
    file.write_all(bytes)
        .map_err(|error| format!("lifecycle.write {}: {error}", path.display()))
}

fn digest(bytes: &[u8]) -> String {
    format!("{:x}", Sha256::digest(bytes))
}

fn require_id(value: &str, code: &str) -> Result<(), String> {
    if !value.is_empty()
        && value
            .bytes()
            .all(|byte| byte.is_ascii_alphanumeric() || matches!(byte, b'-' | b'_'))
    {
        Ok(())
    } else {
        Err(format!("{code}: {value}"))
    }
}

fn require_text(value: &str, code: &str) -> Result<(), String> {
    if value.trim().is_empty() {
        Err(code.to_owned())
    } else {
        Ok(())
    }
}

fn require_relative(value: &str, code: &str) -> Result<(), String> {
    let path = Path::new(value);
    if value.is_empty()
        || path.is_absolute()
        || path
            .components()
            .any(|part| !matches!(part, Component::Normal(_)))
    {
        Err(format!("{code}: {value}"))
    } else {
        Ok(())
    }
}

fn slash(path: &Path) -> String {
    path.to_string_lossy().replace('\\', "/")
}
