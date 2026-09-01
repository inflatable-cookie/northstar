use crate::{Scope, inspect};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sha2::{Digest, Sha256};
use std::collections::{BTreeMap, BTreeSet};
use std::fs::{self, OpenOptions};
use std::io::Write;
use std::path::{Component, Path, PathBuf};
use std::process::Command;

const MAPPING: &str = include_str!("../assets/diagnostic-mapping.json");
const CLASSES: [&str; 6] = ["compiler", "lint", "docs", "test", "graph", "scanner"];
const FAILURE_STAGES: [&str; 7] = [
    "none",
    "routing",
    "startup",
    "configuration",
    "collection",
    "source",
    "not_run",
];

#[derive(Debug, Deserialize)]
pub struct EvidencePlan {
    pub applicable_classes: Vec<String>,
    #[serde(default)]
    pub requests: Vec<EvidenceRequest>,
}

#[derive(Debug, Deserialize)]
pub struct EvidenceRequest {
    pub evidence_id: String,
    #[serde(default)]
    pub unit_id: Option<String>,
    pub evidence_class: String,
    pub selector: String,
    pub origin: String,
    pub package_cwd: String,
    pub environment: String,
    pub execution: Execution,
}

#[derive(Debug, Deserialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum Execution {
    Command {
        program: String,
        #[serde(default)]
        args: Vec<String>,
        #[serde(default = "generic_format")]
        format: String,
    },
    Unavailable {
        failure_stage: String,
        diagnostics: Vec<String>,
    },
    Unrun {
        reason: String,
    },
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct EvidenceRecord {
    pub schema_version: String,
    pub evidence_id: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub unit_id: Option<String>,
    pub evidence_class: String,
    pub selector: String,
    pub origin: String,
    pub package_cwd: String,
    pub environment: String,
    pub status: String,
    pub exit_status: Option<i32>,
    pub warning_count: usize,
    pub failure_stage: String,
    pub diagnostics: Vec<Diagnostic>,
    pub raw_artifacts: Vec<Artifact>,
    pub record_sha256: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct Diagnostic {
    pub level: String,
    pub message: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub identifier: Option<String>,
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub catalogue_evidence: Vec<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub mapping_disposition: Option<String>,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct Artifact {
    pub stream: String,
    pub path: String,
    pub sha256: String,
    pub bytes: usize,
}

#[derive(Debug, Serialize)]
pub struct CollectionReceipt {
    pub schema_version: &'static str,
    pub record_root: String,
    pub records: Vec<EvidenceRecord>,
    pub limitations: Vec<Limitation>,
}

#[derive(Debug, Serialize)]
pub struct Closeout {
    pub schema_version: &'static str,
    pub repository_root: String,
    pub snapshot_sha256: String,
    pub changed_files: Vec<String>,
    pub rust_anchors: Vec<String>,
    pub applicable_rules: Vec<String>,
    pub evidence: Vec<CompactEvidence>,
    pub limitations: Vec<Limitation>,
    pub artifact_root: String,
}

#[derive(Debug, Serialize)]
pub struct CompactEvidence {
    pub evidence_id: String,
    pub evidence_class: String,
    pub status: String,
    pub warning_count: usize,
    pub diagnostic_identifiers: Vec<String>,
    pub catalogue_evidence: Vec<String>,
    pub mapping_dispositions: Vec<String>,
}

#[derive(Clone, Debug, Serialize)]
pub struct Limitation {
    pub key: String,
    pub kind: String,
    pub evidence: Vec<String>,
}

#[derive(Debug, Deserialize)]
struct Mapping {
    schema_version: String,
    role: String,
    mappings: BTreeMap<String, MappingItem>,
}

#[derive(Debug, Deserialize)]
struct MappingItem {
    catalogue_evidence: Vec<String>,
    qualification: String,
}

struct ExecutionOutcome {
    status: String,
    exit_status: Option<i32>,
    failure_stage: String,
    diagnostics: Vec<Diagnostic>,
    artifacts: Vec<Artifact>,
}

fn generic_format() -> String {
    "generic".to_owned()
}

/// Runs an explicit evidence plan and writes immutable records below `record_root`.
///
/// Synthetic `unrun` records cover only applicable classes that remain
/// unrepresented for the call's resolved unit scope after consulting sealed
/// on-disk coverage. Existing unit/class evidence stays authoritative.
///
/// # Errors
///
/// Returns an error for malformed plans, unsafe paths, duplicate records,
/// contradictory coverage, or records that cannot be persisted. Validation and
/// coverage conflicts fail before any new record is written. Command failures
/// become evidence records.
pub fn collect(
    repository_root: &Path,
    record_root: &Path,
    plan: EvidencePlan,
    audit_units: Option<&BTreeSet<String>>,
) -> Result<CollectionReceipt, String> {
    let mapping = mapping()?;
    validate_plan(&plan, audit_units)?;
    fs::create_dir_all(record_root).map_err(|error| format!("evidence.record_create: {error}"))?;

    let existing = index_existing_coverage(record_root)?;
    let scope = resolve_collection_scope(&plan, audit_units)?;
    let mut planned = BTreeSet::new();
    let mut request_paths = Vec::new();
    for request in &plan.requests {
        let key = coverage_key(request.unit_id.clone(), &request.evidence_class);
        if let Some(existing_id) = existing.get(&key)
            && existing_id != &request.evidence_id
        {
            return Err(format!(
                "evidence.coverage_exists: {}/{} via {existing_id}",
                request.unit_id.as_deref().unwrap_or("-"),
                request.evidence_class
            ));
        }
        let path = record_root.join(format!("{}.json", request.evidence_id));
        if path.exists() {
            return Err(format!("evidence.record_exists: {}", request.evidence_id));
        }
        if !planned.insert(key) {
            return Err(format!(
                "evidence.coverage_duplicate: {}/{}",
                request.unit_id.as_deref().unwrap_or("-"),
                request.evidence_class
            ));
        }
        request_paths.push(path);
    }

    let mut unrun_plans = Vec::new();
    for class in &plan.applicable_classes {
        for unit_id in &scope {
            let key = coverage_key(unit_id.clone(), class);
            if planned.contains(&key) || existing.contains_key(&key) {
                continue;
            }
            let suffix = unit_id
                .as_ref()
                .map_or_else(String::new, |unit| format!("-{unit}"));
            let id = format!("unrun-{class}{suffix}");
            let path = record_root.join(format!("{id}.json"));
            if path.exists() {
                return Err(format!("evidence.record_exists: {id}"));
            }
            unrun_plans.push((id, unit_id.clone(), class.clone(), path));
            planned.insert(key);
        }
    }

    let mut records = Vec::new();
    for (request, path) in plan.requests.into_iter().zip(request_paths) {
        let record = run_request(repository_root, record_root, request, &mapping)?;
        write_new_json(&path, &record)?;
        records.push(record);
    }
    for (id, unit_id, class, path) in unrun_plans {
        let mut record = unrun_record(id, unit_id, &class);
        seal(&mut record)?;
        write_new_json(&path, &record)?;
        records.push(record);
    }
    records.sort_by(|left, right| left.evidence_id.cmp(&right.evidence_id));
    let limitations = limitations(&records);
    Ok(CollectionReceipt {
        schema_version: "northstar.rust-quality.collection.v1",
        record_root: slash(record_root),
        records,
        limitations,
    })
}

type CoverageKey = (Option<String>, String);

fn coverage_key(unit_id: Option<String>, class: &str) -> CoverageKey {
    (unit_id, class.to_owned())
}

fn index_existing_coverage(record_root: &Path) -> Result<BTreeMap<CoverageKey, String>, String> {
    let mut coverage = BTreeMap::new();
    let entries = match fs::read_dir(record_root) {
        Ok(entries) => entries,
        Err(error) if error.kind() == std::io::ErrorKind::NotFound => return Ok(coverage),
        Err(error) => return Err(format!("evidence.record_list: {error}")),
    };
    for entry in entries {
        let entry = entry.map_err(|error| format!("evidence.record_list: {error}"))?;
        let path = entry.path();
        if path.extension().and_then(|ext| ext.to_str()) != Some("json") {
            continue;
        }
        let record = read_verified(&path)?;
        let key = coverage_key(record.unit_id.clone(), &record.evidence_class);
        if let Some(prior) = coverage.insert(key, record.evidence_id.clone()) {
            return Err(format!(
                "evidence.coverage_ambiguous: {}/{} via {prior} and {}",
                record.unit_id.as_deref().unwrap_or("-"),
                record.evidence_class,
                record.evidence_id
            ));
        }
    }
    Ok(coverage)
}

fn resolve_collection_scope(
    plan: &EvidencePlan,
    audit_units: Option<&BTreeSet<String>>,
) -> Result<Vec<Option<String>>, String> {
    match audit_units {
        None => Ok(vec![None]),
        Some(units) => {
            let mut scoped = BTreeSet::new();
            for request in &plan.requests {
                let unit = request
                    .unit_id
                    .clone()
                    .ok_or_else(|| "evidence.unit_required".to_owned())?;
                if !units.contains(&unit) {
                    return Err(format!("evidence.unit_unknown: {unit}"));
                }
                scoped.insert(unit);
            }
            if scoped.is_empty() {
                Ok(units.iter().cloned().map(Some).collect())
            } else {
                Ok(scoped.into_iter().map(Some).collect())
            }
        }
    }
}

fn unrun_record(evidence_id: String, unit_id: Option<String>, class: &str) -> EvidenceRecord {
    EvidenceRecord {
        schema_version: "northstar.rust-quality.evidence.v1".to_owned(),
        evidence_id,
        unit_id,
        evidence_class: class.to_owned(),
        selector: format!("unresolved:{class}"),
        origin: "unresolved".to_owned(),
        package_cwd: ".".to_owned(),
        environment: "not resolved".to_owned(),
        status: "unrun".to_owned(),
        exit_status: None,
        warning_count: 0,
        failure_stage: "not_run".to_owned(),
        diagnostics: vec![Diagnostic {
            level: "limitation".to_owned(),
            message: format!("no selector was declared or resolved for {class}"),
            identifier: None,
            catalogue_evidence: Vec::new(),
            mapping_disposition: None,
        }],
        raw_artifacts: Vec::new(),
        record_sha256: String::new(),
    }
}

/// Runs a compact worktree closeout without creating an audit ledger.
///
/// # Errors
///
/// Returns an error when discovery, plan validation, collection, or persistence fails.
pub fn closeout(
    repository: &Path,
    applicable_rules: Vec<String>,
    plan: EvidencePlan,
    artifact_root: &Path,
) -> Result<Closeout, String> {
    let discovery = inspect(repository, Scope::Worktree)?;
    let root = PathBuf::from(&discovery.repository_root);
    let root_for_snapshot = artifact_root.join(&discovery.snapshot_sha256);
    if root_for_snapshot.exists() {
        return Err(format!(
            "evidence.closeout_exists: {}",
            discovery.snapshot_sha256
        ));
    }
    let receipt = collect(&root, &root_for_snapshot.join("evidence"), plan, None)?;
    let evidence = receipt.records.iter().map(compact).collect();
    Ok(Closeout {
        schema_version: "northstar.rust-quality.closeout.v1",
        repository_root: discovery.repository_root,
        snapshot_sha256: discovery.snapshot_sha256,
        changed_files: discovery
            .dirty_files
            .into_iter()
            .map(|item| item.path)
            .collect(),
        rust_anchors: discovery
            .rust_anchors
            .into_iter()
            .map(|item| item.path)
            .collect(),
        applicable_rules,
        evidence,
        limitations: receipt.limitations,
        artifact_root: slash(&root_for_snapshot),
    })
}

pub(crate) fn read_verified(path: &Path) -> Result<EvidenceRecord, String> {
    let bytes = fs::read(path).map_err(|error| format!("evidence.record_read: {error}"))?;
    let mut record: EvidenceRecord = serde_json::from_slice(&bytes)
        .map_err(|error| format!("evidence.record_parse: {error}"))?;
    let claimed = std::mem::take(&mut record.record_sha256);
    let actual = record_digest(&record)?;
    record.record_sha256.clone_from(&claimed);
    if claimed != actual {
        return Err(format!(
            "evidence.record_hash_mismatch: {}",
            record.evidence_id
        ));
    }
    for artifact in &record.raw_artifacts {
        let artifact_path = path
            .parent()
            .ok_or_else(|| "evidence.record_parent_missing".to_owned())?
            .join(&artifact.path);
        let payload =
            fs::read(&artifact_path).map_err(|error| format!("evidence.artifact_read: {error}"))?;
        if payload.len() != artifact.bytes || digest(&payload) != artifact.sha256 {
            return Err(format!(
                "evidence.artifact_hash_mismatch: {}",
                artifact.path
            ));
        }
    }
    Ok(record)
}

fn validate_plan(
    plan: &EvidencePlan,
    audit_units: Option<&BTreeSet<String>>,
) -> Result<(), String> {
    let mut classes = BTreeSet::new();
    for class in &plan.applicable_classes {
        require_member(class, &CLASSES, "evidence.class_invalid")?;
        if !classes.insert(class) {
            return Err(format!("evidence.class_duplicate: {class}"));
        }
    }
    let mut ids = BTreeSet::new();
    let mut coverage = BTreeSet::new();
    for request in &plan.requests {
        require_id(&request.evidence_id)?;
        if !ids.insert(request.evidence_id.as_str()) {
            return Err(format!("evidence.id_duplicate: {}", request.evidence_id));
        }
        require_member(&request.evidence_class, &CLASSES, "evidence.class_invalid")?;
        if !classes.contains(&request.evidence_class) {
            return Err(format!(
                "evidence.class_not_applicable: {}",
                request.evidence_class
            ));
        }
        let key = coverage_key(request.unit_id.clone(), &request.evidence_class);
        if !coverage.insert(key) {
            return Err(format!(
                "evidence.coverage_duplicate: {}/{}",
                request.unit_id.as_deref().unwrap_or("-"),
                request.evidence_class
            ));
        }
        require_text(&request.selector, "evidence.selector_empty")?;
        require_text(&request.origin, "evidence.origin_empty")?;
        require_text(&request.environment, "evidence.environment_empty")?;
        safe_relative(&request.package_cwd)?;
        match (audit_units, request.unit_id.as_ref()) {
            (Some(units), Some(unit)) if units.contains(unit) => {}
            (Some(_), Some(unit)) => return Err(format!("evidence.unit_unknown: {unit}")),
            (Some(_), None) => return Err("evidence.unit_required".to_owned()),
            (None, Some(_)) => return Err("evidence.unit_forbidden_in_closeout".to_owned()),
            (None, None) => {}
        }
        if let Execution::Command {
            program, format, ..
        } = &request.execution
        {
            require_text(program, "evidence.program_empty")?;
            if !matches!(format.as_str(), "cargo_json" | "generic" | "stopslop_json") {
                return Err(format!("evidence.format_invalid: {format}"));
            }
        }
        if let Execution::Unavailable {
            failure_stage,
            diagnostics,
        } = &request.execution
        {
            require_member(
                failure_stage,
                &FAILURE_STAGES[1..5],
                "evidence.failure_stage_invalid",
            )?;
            if diagnostics.is_empty() || diagnostics.iter().any(|item| item.trim().is_empty()) {
                return Err("evidence.unavailable_diagnostics_empty".to_owned());
            }
        }
        if let Execution::Unrun { reason } = &request.execution {
            require_text(reason, "evidence.unrun_reason_empty")?;
        }
    }
    Ok(())
}

fn run_request(
    repository_root: &Path,
    record_root: &Path,
    request: EvidenceRequest,
    mapping: &Mapping,
) -> Result<EvidenceRecord, String> {
    let package_cwd = repository_root.join(&request.package_cwd);
    if !package_cwd.is_dir() {
        return Err(format!(
            "evidence.package_cwd_missing: {}",
            request.package_cwd
        ));
    }
    let canonical_root = fs::canonicalize(repository_root)
        .map_err(|error| format!("evidence.repository_root: {error}"))?;
    let package_cwd =
        fs::canonicalize(package_cwd).map_err(|error| format!("evidence.package_cwd: {error}"))?;
    if !package_cwd.starts_with(&canonical_root) {
        return Err(format!(
            "evidence.package_cwd_outside_repository: {}",
            request.package_cwd
        ));
    }
    let outcome = execute(
        &package_cwd,
        record_root,
        &request.evidence_id,
        request.execution,
        mapping,
    )?;
    let warning_count = outcome
        .diagnostics
        .iter()
        .filter(|item| item.level == "warning")
        .count();
    let mut record = EvidenceRecord {
        schema_version: "northstar.rust-quality.evidence.v1".to_owned(),
        evidence_id: request.evidence_id,
        unit_id: request.unit_id,
        evidence_class: request.evidence_class,
        selector: request.selector,
        origin: request.origin,
        package_cwd: request.package_cwd,
        environment: request.environment,
        status: outcome.status,
        exit_status: outcome.exit_status,
        warning_count,
        failure_stage: outcome.failure_stage,
        diagnostics: outcome.diagnostics,
        raw_artifacts: outcome.artifacts,
        record_sha256: String::new(),
    };
    seal(&mut record)?;
    Ok(record)
}

fn execute(
    package_cwd: &Path,
    record_root: &Path,
    evidence_id: &str,
    execution: Execution,
    mapping: &Mapping,
) -> Result<ExecutionOutcome, String> {
    match execution {
        Execution::Command {
            program,
            args,
            format,
        } => {
            match Command::new(&program)
                .args(&args)
                .current_dir(package_cwd)
                .output()
            {
                Ok(output) => {
                    let artifact_dir = record_root.join(evidence_id);
                    fs::create_dir_all(&artifact_dir)
                        .map_err(|error| format!("evidence.artifact_create: {error}"))?;
                    let artifacts = vec![
                        write_artifact(record_root, &artifact_dir, "stdout", &output.stdout)?,
                        write_artifact(record_root, &artifact_dir, "stderr", &output.stderr)?,
                    ];
                    let diagnostics =
                        parse_diagnostics(&format, &output.stdout, &output.stderr, mapping);
                    let warnings = diagnostics
                        .iter()
                        .filter(|item| item.level == "warning")
                        .count();
                    let code = output.status.code();
                    let successful = output.status.success();
                    let status = if successful && warnings == 0 {
                        "passed"
                    } else if successful {
                        "warning"
                    } else {
                        "failed"
                    };
                    Ok(ExecutionOutcome {
                        status: status.to_owned(),
                        exit_status: code,
                        failure_stage: if successful && warnings == 0 {
                            "none"
                        } else {
                            "source"
                        }
                        .to_owned(),
                        diagnostics,
                        artifacts,
                    })
                }
                Err(error) => Ok(ExecutionOutcome {
                    status: "unavailable".to_owned(),
                    exit_status: None,
                    failure_stage: "startup".to_owned(),
                    diagnostics: vec![Diagnostic {
                        level: "error".to_owned(),
                        message: error.to_string(),
                        identifier: None,
                        catalogue_evidence: Vec::new(),
                        mapping_disposition: None,
                    }],
                    artifacts: Vec::new(),
                }),
            }
        }
        Execution::Unavailable {
            failure_stage,
            diagnostics,
        } => Ok(ExecutionOutcome {
            status: "unavailable".to_owned(),
            exit_status: None,
            failure_stage,
            diagnostics: diagnostics
                .into_iter()
                .map(|message| Diagnostic {
                    level: "error".to_owned(),
                    message,
                    identifier: None,
                    catalogue_evidence: Vec::new(),
                    mapping_disposition: None,
                })
                .collect(),
            artifacts: Vec::new(),
        }),
        Execution::Unrun { reason } => Ok(ExecutionOutcome {
            status: "unrun".to_owned(),
            exit_status: None,
            failure_stage: "not_run".to_owned(),
            diagnostics: vec![Diagnostic {
                level: "limitation".to_owned(),
                message: reason,
                identifier: None,
                catalogue_evidence: Vec::new(),
                mapping_disposition: None,
            }],
            artifacts: Vec::new(),
        }),
    }
}

fn parse_diagnostics(
    format: &str,
    stdout: &[u8],
    stderr: &[u8],
    mapping: &Mapping,
) -> Vec<Diagnostic> {
    let mut diagnostics = Vec::new();
    if format == "stopslop_json" {
        return parse_stopslop_diagnostics(stdout, stderr, mapping);
    }
    if format == "cargo_json" {
        for line in String::from_utf8_lossy(stdout).lines() {
            let Ok(value) = serde_json::from_str::<Value>(line) else {
                continue;
            };
            if value["reason"] != "compiler-message" {
                continue;
            }
            let message = &value["message"];
            let identifier = message["code"]["code"].as_str().map(str::to_owned);
            let mapped = identifier
                .as_ref()
                .and_then(|code| mapping.mappings.get(code));
            diagnostics.push(Diagnostic {
                level: message["level"].as_str().unwrap_or("unknown").to_owned(),
                message: message["message"]
                    .as_str()
                    .unwrap_or("compiler diagnostic")
                    .to_owned(),
                catalogue_evidence: mapped
                    .map(|item| item.catalogue_evidence.clone())
                    .unwrap_or_default(),
                mapping_disposition: mapped.map(|item| item.qualification.clone()),
                identifier,
            });
        }
    }
    if diagnostics.is_empty() {
        let combined = [stdout, stderr].concat();
        let text = String::from_utf8_lossy(&combined);
        for line in text.lines().filter(|line| !line.trim().is_empty()) {
            let level = if line.to_ascii_lowercase().contains("warning") {
                "warning"
            } else {
                "note"
            };
            diagnostics.push(Diagnostic {
                level: level.to_owned(),
                message: line.to_owned(),
                identifier: None,
                catalogue_evidence: Vec::new(),
                mapping_disposition: None,
            });
        }
    }
    diagnostics
}

fn parse_stopslop_diagnostics(stdout: &[u8], stderr: &[u8], mapping: &Mapping) -> Vec<Diagnostic> {
    let Ok(values) = serde_json::from_slice::<Vec<Value>>(stdout) else {
        return vec![Diagnostic {
            level: "warning".to_owned(),
            message: "stopslop emitted invalid JSON evidence".to_owned(),
            identifier: None,
            catalogue_evidence: Vec::new(),
            mapping_disposition: None,
        }];
    };
    let mut diagnostics: Vec<_> = values
        .into_iter()
        .map(|value| {
            let code = value["code"].as_str().unwrap_or("unknown");
            let identifier = format!("stopslop::{code}");
            let mapped = mapping.mappings.get(&identifier);
            let path = value["path"].as_str().unwrap_or("unknown path");
            let line = value["line"].as_u64().unwrap_or(0);
            let column = value["col"].as_u64().unwrap_or(0);
            let message = value["message"].as_str().unwrap_or("stopslop finding");
            Diagnostic {
                level: if value["tier"] == "A" {
                    "error"
                } else {
                    "warning"
                }
                .to_owned(),
                message: format!("{path}:{line}:{column}: {message}"),
                identifier: Some(identifier),
                catalogue_evidence: mapped
                    .map(|item| item.catalogue_evidence.clone())
                    .unwrap_or_default(),
                mapping_disposition: mapped.map(|item| item.qualification.clone()),
            }
        })
        .collect();
    diagnostics.extend(
        String::from_utf8_lossy(stderr)
            .lines()
            .filter(|line| !line.trim().is_empty())
            .map(|line| Diagnostic {
                level: "warning".to_owned(),
                message: line.to_owned(),
                identifier: None,
                catalogue_evidence: Vec::new(),
                mapping_disposition: None,
            }),
    );
    diagnostics
}

fn mapping() -> Result<Mapping, String> {
    let value: Mapping = serde_json::from_str(MAPPING)
        .map_err(|error| format!("evidence.mapping_parse: {error}"))?;
    if value.schema_version != "northstar.rust-quality.diagnostic-mapping.v2"
        || value.role != "evidence_only"
    {
        return Err("evidence.mapping_identity_invalid".to_owned());
    }
    let allowed_qualifications = [
        "promote_enforcement",
        "promote_evidence",
        "evaluation_only",
        "retain_manual",
    ];
    if value.mappings.values().any(|item| {
        item.catalogue_evidence.is_empty()
            || !allowed_qualifications.contains(&item.qualification.as_str())
    }) {
        return Err("evidence.mapping_item_invalid".to_owned());
    }
    Ok(value)
}

fn compact(record: &EvidenceRecord) -> CompactEvidence {
    CompactEvidence {
        evidence_id: record.evidence_id.clone(),
        evidence_class: record.evidence_class.clone(),
        status: record.status.clone(),
        warning_count: record.warning_count,
        diagnostic_identifiers: record
            .diagnostics
            .iter()
            .filter_map(|item| item.identifier.clone())
            .collect::<BTreeSet<_>>()
            .into_iter()
            .collect(),
        catalogue_evidence: record
            .diagnostics
            .iter()
            .flat_map(|item| item.catalogue_evidence.iter().cloned())
            .collect::<BTreeSet<_>>()
            .into_iter()
            .collect(),
        mapping_dispositions: record
            .diagnostics
            .iter()
            .filter_map(|item| item.mapping_disposition.clone())
            .collect::<BTreeSet<_>>()
            .into_iter()
            .collect(),
    }
}

pub(crate) fn limitations(records: &[EvidenceRecord]) -> Vec<Limitation> {
    records
        .iter()
        .filter(|record| record.status != "passed")
        .map(|record| Limitation {
            key: format!("evidence:{}", record.evidence_id),
            kind: format!("evidence_{}", record.status),
            evidence: record
                .diagnostics
                .iter()
                .map(|item| item.message.clone())
                .collect(),
        })
        .collect()
}

fn write_artifact(
    record_root: &Path,
    directory: &Path,
    stream: &str,
    bytes: &[u8],
) -> Result<Artifact, String> {
    let path = directory.join(format!("{stream}.bin"));
    write_new(&path, bytes)?;
    Ok(Artifact {
        stream: stream.to_owned(),
        path: slash(
            path.strip_prefix(record_root)
                .map_err(|_| "evidence.artifact_outside_root".to_owned())?,
        ),
        sha256: digest(bytes),
        bytes: bytes.len(),
    })
}

fn seal(record: &mut EvidenceRecord) -> Result<(), String> {
    record.record_sha256 = record_digest(record)?;
    Ok(())
}

fn record_digest(record: &EvidenceRecord) -> Result<String, String> {
    let mut unhashed = record.clone();
    unhashed.record_sha256.clear();
    serde_json::to_vec(&unhashed)
        .map(|bytes| digest(&bytes))
        .map_err(|error| error.to_string())
}

fn write_new_json<T: Serialize>(path: &Path, value: &T) -> Result<(), String> {
    let mut bytes = serde_json::to_vec_pretty(value).map_err(|error| error.to_string())?;
    bytes.push(b'\n');
    write_new(path, &bytes)
}

fn write_new(path: &Path, bytes: &[u8]) -> Result<(), String> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).map_err(|error| format!("evidence.parent_create: {error}"))?;
    }
    let mut file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(path)
        .map_err(|error| format!("evidence.write_new: {}: {error}", path.display()))?;
    file.write_all(bytes)
        .map_err(|error| format!("evidence.write: {error}"))
}

fn safe_relative(value: &str) -> Result<(), String> {
    let path = Path::new(value);
    if value.is_empty()
        || path.is_absolute()
        || path
            .components()
            .any(|part| !matches!(part, Component::Normal(_) | Component::CurDir))
    {
        Err(format!("evidence.path_invalid: {value}"))
    } else {
        Ok(())
    }
}

fn require_id(value: &str) -> Result<(), String> {
    if value.is_empty()
        || !value
            .bytes()
            .all(|byte| byte.is_ascii_alphanumeric() || matches!(byte, b'-' | b'_'))
    {
        Err(format!("evidence.id_invalid: {value}"))
    } else {
        Ok(())
    }
}

fn require_text(value: &str, code: &str) -> Result<(), String> {
    if value.trim().is_empty() {
        Err(code.to_owned())
    } else {
        Ok(())
    }
}

fn require_member(value: &str, allowed: &[&str], code: &str) -> Result<(), String> {
    if allowed.contains(&value) {
        Ok(())
    } else {
        Err(format!("{code}: {value}"))
    }
}

fn digest(bytes: &[u8]) -> String {
    format!("{:x}", Sha256::digest(bytes))
}

fn slash(path: &Path) -> String {
    path.to_string_lossy().replace('\\', "/")
}

#[cfg(test)]
mod tests {
    use super::{
        EvidencePlan, EvidenceRequest, Execution, collect, mapping, parse_diagnostics, seal,
        unrun_record, write_new_json,
    };
    use std::collections::BTreeSet;
    use std::fs;
    use std::time::{SystemTime, UNIX_EPOCH};

    #[test]
    fn maps_stopslop_forwarders_to_evaluation_only_evidence() {
        let output = br#"[{"code":"SLOP039","tier":"B","path":"src/lib.rs","line":4,"col":1,"message":"`wrapper` only forwards to `inner`"}]"#;
        let diagnostics = parse_diagnostics(
            "stopslop_json",
            output,
            &[],
            &mapping().expect("valid diagnostic mapping"),
        );
        assert_eq!(diagnostics.len(), 1);
        assert_eq!(diagnostics[0].level, "warning");
        assert_eq!(
            diagnostics[0].identifier.as_deref(),
            Some("stopslop::SLOP039")
        );
        assert_eq!(diagnostics[0].catalogue_evidence, ["RUST-SLOP-001"]);
        assert_eq!(
            diagnostics[0].mapping_disposition.as_deref(),
            Some("evaluation_only")
        );
    }

    #[test]
    fn rejects_malformed_stopslop_output_as_warning_evidence() {
        let diagnostics = parse_diagnostics(
            "stopslop_json",
            b"not-json",
            &[],
            &mapping().expect("valid diagnostic mapping"),
        );
        assert_eq!(diagnostics.len(), 1);
        assert_eq!(diagnostics[0].level, "warning");
        assert!(diagnostics[0].message.contains("invalid JSON"));
    }

    #[test]
    fn retains_stopslop_stderr_as_warning_evidence() {
        let diagnostics = parse_diagnostics(
            "stopslop_json",
            b"[]",
            b"stopslop: warning: dead suppression\n",
            &mapping().expect("valid diagnostic mapping"),
        );
        assert_eq!(diagnostics.len(), 1);
        assert_eq!(diagnostics[0].level, "warning");
        assert!(diagnostics[0].message.contains("dead suppression"));
    }

    #[test]
    fn ambiguous_unit_class_coverage_fails_before_write() {
        let nonce = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("clock")
            .as_nanos();
        let root = std::env::temp_dir().join(format!(
            "northstar-ambiguous-coverage-{}-{nonce}",
            std::process::id()
        ));
        let evidence = root.join("evidence");
        fs::create_dir_all(&evidence).expect("evidence root");
        fs::write(root.join("Cargo.toml"), "[package]\nname=\"t\"\nversion=\"0.1.0\"\nedition=\"2024\"\n")
            .expect("manifest");
        fs::create_dir_all(root.join("src")).expect("src");
        fs::write(root.join("src/lib.rs"), "pub fn x() {}\n").expect("lib");

        for (id, unit) in [("test-a", "core"), ("test-b", "core")] {
            let mut record = unrun_record(id.to_owned(), Some(unit.to_owned()), "test");
            record.evidence_id = id.to_owned();
            seal(&mut record).expect("seal");
            write_new_json(&evidence.join(format!("{id}.json")), &record).expect("plant");
        }
        let before = fs::read(evidence.join("test-a.json")).expect("before");
        let units = BTreeSet::from(["core".to_owned()]);
        let error = collect(
            &root,
            &evidence,
            EvidencePlan {
                applicable_classes: vec!["lint".to_owned()],
                requests: vec![EvidenceRequest {
                    evidence_id: "lint-core".to_owned(),
                    unit_id: Some("core".to_owned()),
                    evidence_class: "lint".to_owned(),
                    selector: "true".to_owned(),
                    origin: "agent_resolved".to_owned(),
                    package_cwd: ".".to_owned(),
                    environment: "fixture".to_owned(),
                    execution: Execution::Command {
                        program: "true".to_owned(),
                        args: Vec::new(),
                        format: "generic".to_owned(),
                    },
                }],
            },
            Some(&units),
        )
        .expect_err("ambiguous coverage");
        assert!(
            error.contains("evidence.coverage_ambiguous"),
            "unexpected error: {error}"
        );
        assert!(!evidence.join("lint-core.json").exists());
        assert_eq!(fs::read(evidence.join("test-a.json")).expect("after"), before);
        let _ = fs::remove_dir_all(&root);
    }
}
