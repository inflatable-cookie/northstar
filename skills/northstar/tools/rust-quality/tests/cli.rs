use serde_json::Value;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::time::{SystemTime, UNIX_EPOCH};

struct Fixture {
    root: PathBuf,
}

impl Fixture {
    fn new(name: &str) -> Self {
        let nonce = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("clock after epoch")
            .as_nanos();
        let root = std::env::temp_dir().join(format!(
            "northstar-rust-{name}-{}-{nonce}",
            std::process::id()
        ));
        fs::create_dir_all(&root).expect("create fixture root");
        command(&root, "git", &["init", "--quiet"]);
        Self { root }
    }

    fn write(&self, relative: &str, contents: &str) {
        let path = self.root.join(relative);
        fs::create_dir_all(path.parent().expect("fixture file parent")).expect("create parent");
        fs::write(path, contents).expect("write fixture file");
    }

    fn commit(&self) {
        command(&self.root, "git", &["add", "."]);
        command(
            &self.root,
            "git",
            &[
                "-c",
                "user.name=Northstar Test",
                "-c",
                "user.email=northstar@example.invalid",
                "commit",
                "--quiet",
                "-m",
                "fixture",
            ],
        );
    }

    fn inspect(&self) -> Value {
        self.inspect_scope("worktree")
    }

    fn inspect_scope(&self, scope: &str) -> Value {
        let output = Command::new(env!("CARGO_BIN_EXE_northstar-rust-quality"))
            .args(["inspect", "--repo"])
            .arg(&self.root)
            .args(["--scope", scope])
            .output()
            .expect("run prototype");
        assert!(
            output.status.success(),
            "prototype failed: {}",
            String::from_utf8_lossy(&output.stderr)
        );
        serde_json::from_slice(&output.stdout).expect("parse prototype output")
    }

    fn plan(&self, discovery: &Value, input: &Value) -> std::process::Output {
        let scratch = self.root.join(".git/northstar-test-inputs");
        fs::create_dir_all(&scratch).expect("create plan scratch");
        let discovery_path = scratch.join("discovery.json");
        let input_path = scratch.join("plan-input.json");
        fs::write(
            &discovery_path,
            serde_json::to_vec(discovery).expect("serialize discovery"),
        )
        .expect("write discovery");
        fs::write(
            &input_path,
            serde_json::to_vec(input).expect("serialize plan input"),
        )
        .expect("write plan input");
        Command::new(env!("CARGO_BIN_EXE_northstar-rust-quality"))
            .args(["plan", "--discovery"])
            .arg(discovery_path)
            .args(["--input"])
            .arg(input_path)
            .output()
            .expect("run scope planner")
    }

    fn plan_value(&self, discovery: &Value, input: &Value) -> Value {
        let output = self.plan(discovery, input);
        assert_success(&output, "plan")
    }

    fn init_audit(&self, discovery: &Value, plan: &Value) -> std::process::Output {
        let scratch = self.root.join(".git/northstar-test-inputs");
        fs::create_dir_all(&scratch).expect("create lifecycle scratch");
        let discovery_path = scratch.join("lifecycle-discovery.json");
        let plan_path = scratch.join("lifecycle-plan.json");
        let profile_path = scratch.join("rust-quality-profile.json");
        let deviations_path = scratch.join("rust-quality-deviations.json");
        fs::write(
            &discovery_path,
            serde_json::to_vec(discovery).expect("discovery json"),
        )
        .expect("write discovery");
        fs::write(&plan_path, serde_json::to_vec(plan).expect("plan json")).expect("write plan");
        fs::write(
            &profile_path,
            br#"{"schema_version":"1.0.0","language":"rust","profile":"strict"}"#,
        )
        .expect("write profile");
        fs::write(
            &deviations_path,
            br#"{"schema_version":"1.0.0","language":"rust","deviations":[]}"#,
        )
        .expect("write deviations");
        Command::new(env!("CARGO_BIN_EXE_northstar-rust-quality"))
            .args(["init", "--repo"])
            .arg(&self.root)
            .args(["--discovery"])
            .arg(discovery_path)
            .args(["--plan"])
            .arg(plan_path)
            .args(["--rules"])
            .arg(strict_projection_path())
            .args(["--profile"])
            .arg(profile_path)
            .args(["--deviations"])
            .arg(deviations_path)
            .output()
            .expect("initialize audit")
    }

    fn audit_operation(
        &self,
        operation: &str,
        audit_id: &str,
        input: &Value,
    ) -> std::process::Output {
        let input_path = self
            .root
            .join(".git/northstar-test-inputs")
            .join(format!("{operation}-input.json"));
        fs::write(
            &input_path,
            serde_json::to_vec(input).expect("operation json"),
        )
        .expect("write operation input");
        Command::new(env!("CARGO_BIN_EXE_northstar-rust-quality"))
            .arg(operation)
            .args(["--repo"])
            .arg(&self.root)
            .args(["--audit", audit_id, "--input"])
            .arg(input_path)
            .output()
            .expect("run audit operation")
    }

    fn finalize(&self, audit_id: &str) -> std::process::Output {
        Command::new(env!("CARGO_BIN_EXE_northstar-rust-quality"))
            .args(["finalize", "--repo"])
            .arg(&self.root)
            .args(["--audit", audit_id])
            .output()
            .expect("finalize audit")
    }

    fn closeout(&self, input: &Value) -> std::process::Output {
        let input_path = self.root.join(".git/northstar-test-inputs/closeout.json");
        fs::create_dir_all(input_path.parent().expect("closeout input parent"))
            .expect("create closeout input parent");
        fs::write(
            &input_path,
            serde_json::to_vec(input).expect("closeout json"),
        )
        .expect("write closeout input");
        Command::new(env!("CARGO_BIN_EXE_northstar-rust-quality"))
            .args(["closeout", "--repo"])
            .arg(&self.root)
            .args(["--input"])
            .arg(input_path)
            .output()
            .expect("run closeout")
    }

    fn validate_ledger(&self, input: &Value) -> std::process::Output {
        let input_path = self.root.join("assessment-input.json");
        fs::write(
            &input_path,
            serde_json::to_vec(input).expect("serialize assessment input"),
        )
        .expect("write assessment input");
        Command::new(env!("CARGO_BIN_EXE_northstar-rust-quality"))
            .args(["validate-ledger", "--rules"])
            .arg(strict_projection_path())
            .args(["--input"])
            .arg(input_path)
            .output()
            .expect("run ledger validation")
    }
}

impl Drop for Fixture {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.root);
    }
}

#[test]
fn discovers_root_workspace() {
    let fixture = Fixture::new("root");
    fixture.write(
        "Cargo.toml",
        "[package]\nname = \"root-fixture\"\nversion = \"0.1.0\"\nedition = \"2024\"\nrust-version = \"1.95\"\n",
    );
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 41 }\n");
    fixture.commit();
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 42 }\n");

    let record = fixture.inspect();
    assert_eq!(record["scope"], "worktree");
    assert_eq!(
        record["workspaces"].as_array().expect("workspaces").len(),
        1
    );
    assert_eq!(
        record["workspaces"][0]["packages"][0]["name"],
        "root-fixture"
    );
    assert_eq!(record["workspaces"][0]["root"], ".");
    assert_eq!(record["workspaces"][0]["manifest_path"], "Cargo.toml");
    assert_eq!(record["rust_anchors"][0]["path"], "src/lib.rs");
}

#[test]
fn discovers_nested_rust_in_mixed_repository() {
    let fixture = Fixture::new("mixed");
    fixture.write("package.json", "{\"private\":true}\n");
    fixture.write(
        "services/engine/Cargo.toml",
        "[package]\nname = \"nested-engine\"\nversion = \"0.1.0\"\nedition = \"2024\"\nrust-version = \"1.95\"\n",
    );
    fixture.write(
        "services/engine/src/lib.rs",
        "pub fn ready() -> bool { false }\n",
    );
    fixture.write("apps/site/package.json", "{\"private\":true}\n");
    fixture.commit();
    fixture.write(
        "services/engine/src/lib.rs",
        "pub fn ready() -> bool { true }\n",
    );

    let record = fixture.inspect();
    let canonical_root = fs::canonicalize(&fixture.root).expect("canonical fixture root");
    assert_eq!(
        record["repository_root"],
        canonical_root.to_string_lossy().as_ref()
    );
    assert_eq!(
        record["workspaces"].as_array().expect("workspaces").len(),
        1
    );
    assert_eq!(
        record["workspaces"][0]["packages"][0]["name"],
        "nested-engine"
    );
    assert_eq!(
        record["rust_anchors"][0]["path"],
        "services/engine/src/lib.rs"
    );
}

#[test]
fn rejects_anchorless_worktree_scope() {
    let fixture = Fixture::new("anchorless");
    fixture.write(
        "crates/core/Cargo.toml",
        "[package]\nname = \"core-fixture\"\nversion = \"0.1.0\"\nedition = \"2024\"\n",
    );
    fixture.write("crates/core/src/lib.rs", "pub fn stable() {}\n");
    fixture.write("README.md", "initial\n");
    fixture.commit();
    fixture.write("README.md", "changed\n");

    let output = Command::new(env!("CARGO_BIN_EXE_northstar-rust-quality"))
        .args(["inspect", "--repo"])
        .arg(&fixture.root)
        .args(["--scope", "worktree"])
        .output()
        .expect("run prototype");
    assert_eq!(output.status.code(), Some(2));
    assert!(String::from_utf8_lossy(&output.stderr).contains("scope.no_worktree_anchor"));
}

#[test]
fn verifies_its_source_payload() {
    let crate_root = Path::new(env!("CARGO_MANIFEST_DIR"));
    let output = Command::new(env!("CARGO_BIN_EXE_northstar-rust-quality"))
        .args(["verify-install", "--source-root"])
        .arg(crate_root)
        .output()
        .expect("run install verification");
    assert!(
        output.status.success(),
        "verification failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );
    let record: Value = serde_json::from_slice(&output.stdout).expect("parse receipt");
    assert_eq!(record["current"], true);
    assert_eq!(
        record["embedded_payload_sha256"],
        record["source_payload_sha256"]
    );
}

#[test]
fn plans_owned_worktree_scope_with_related_context() {
    let fixture = Fixture::new("worktree-plan");
    fixture.write(
        "Cargo.toml",
        "[package]\nname = \"plan-fixture\"\nversion = \"0.1.0\"\nedition = \"2024\"\n",
    );
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 41 }\n");
    fixture.write("README.md", "answer: 41\n");
    fixture.commit();
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 42 }\n");
    fixture.write("README.md", "answer: 42\n");
    let discovery = fixture.inspect();
    let input = serde_json::json!({
        "audit_id": "worktree-plan",
        "units": [{
            "unit_id": "answer",
            "anchors": ["src/lib.rs"],
            "context": [{
                "path": "README.md",
                "anchor": "src/lib.rs",
                "relation": "governed_documentation"
            }]
        }],
        "excluded_dirty_files": [],
        "repository_coverage": null
    });
    let output = fixture.plan(&discovery, &input);
    assert!(
        output.status.success(),
        "plan failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );
    let plan: Value = serde_json::from_slice(&output.stdout).expect("parse scope plan");
    assert_eq!(plan["units"][0]["mutable_files"][0], "src/lib.rs");
    assert_eq!(
        plan["units"][0]["read_only_context"][0]["path"],
        "README.md"
    );
}

#[test]
fn rejects_undisposed_dirty_context() {
    let fixture = Fixture::new("undisposed");
    fixture.write(
        "Cargo.toml",
        "[package]\nname = \"undisposed-fixture\"\nversion = \"0.1.0\"\nedition = \"2024\"\n",
    );
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 41 }\n");
    fixture.write("README.md", "answer: 41\n");
    fixture.commit();
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 42 }\n");
    fixture.write("README.md", "answer: 42\n");
    let discovery = fixture.inspect();
    let input = serde_json::json!({
        "audit_id": "undisposed",
        "units": [{"unit_id": "answer", "anchors": ["src/lib.rs"], "context": []}],
        "excluded_dirty_files": [],
        "repository_coverage": null
    });
    let output = fixture.plan(&discovery, &input);
    assert_eq!(output.status.code(), Some(2));
    assert!(String::from_utf8_lossy(&output.stderr).contains("scope.dirty_undisposed"));
}

#[test]
fn proves_full_repository_coverage_from_cargo_inventory() {
    let fixture = Fixture::new("repository-plan");
    fixture.write(
        "Cargo.toml",
        "[package]\nname = \"repository-fixture\"\nversion = \"0.1.0\"\nedition = \"2024\"\n[features]\nstrict = []\n",
    );
    fixture.write("src/lib.rs", "pub fn stable() {}\n");
    fixture.commit();
    let discovery = fixture.inspect_scope("repository");
    let input = serde_json::json!({
        "audit_id": "repository-plan",
        "units": [{
            "unit_id": "repository-fixture",
            "anchors": ["Cargo.toml", "src/lib.rs"],
            "context": []
        }],
        "excluded_dirty_files": [],
        "repository_coverage": {
            "claim": "full_repository",
            "workspaces": ["."],
            "packages": ["Cargo.toml"],
            "targets": ["src/lib.rs"],
            "features": ["repository-fixture:strict"],
            "public_api_surfaces": ["src/lib.rs"],
            "risk_boundaries": ["none: fixture has no unsafe, async, or FFI boundary"]
        }
    });
    let output = fixture.plan(&discovery, &input);
    assert!(
        output.status.success(),
        "repository plan failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );
}

#[test]
fn accepts_complete_strict_assessment() {
    let fixture = Fixture::new("ledger-complete");
    let output = fixture.validate_ledger(&complete_assessment());
    assert!(
        output.status.success(),
        "ledger failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );
    let assessment: Value = serde_json::from_slice(&output.stdout).expect("parse assessment");
    assert_eq!(
        assessment["schema_version"],
        "northstar.rust-quality.assessment.v1"
    );
    assert_eq!(
        assessment["verdicts"].as_array().expect("verdicts").len(),
        6
    );
}

#[test]
fn rejects_incomplete_or_hollow_assessments() {
    let fixture = Fixture::new("ledger-hollow");
    let mut missing_rule = complete_assessment();
    missing_rule["verdicts"]
        .as_array_mut()
        .expect("verdicts")
        .pop();
    assert_ledger_error(
        &fixture.validate_ledger(&missing_rule),
        "ledger.verdict_inventory_mismatch",
    );

    let mut empty_attestation = complete_assessment();
    empty_attestation["attestations"][0]["evidence"] = serde_json::json!([]);
    assert_ledger_error(
        &fixture.validate_ledger(&empty_attestation),
        "ledger.attestation_evidence_empty",
    );

    let mut duplicate_rule = complete_assessment();
    let duplicate = duplicate_rule["verdicts"][0].clone();
    duplicate_rule["verdicts"]
        .as_array_mut()
        .expect("verdicts")
        .push(duplicate);
    assert_ledger_error(
        &fixture.validate_ledger(&duplicate_rule),
        "ledger.verdict_duplicate",
    );
}

#[test]
fn rejects_orphan_records_and_unauthorized_repairs() {
    let fixture = Fixture::new("ledger-authority");
    let mut orphan = complete_assessment();
    orphan["limitations"] = serde_json::json!([{
        "key": "service-unavailable",
        "kind": "external_service",
        "evidence": ["S3 was unavailable"]
    }]);
    assert_ledger_error(
        &fixture.validate_ledger(&orphan),
        "ledger.limitation_orphan_or_duplicate",
    );

    let mut unauthorized = complete_assessment();
    let unsafe_index = unauthorized["verdicts"]
        .as_array()
        .expect("verdicts")
        .iter()
        .position(|verdict| verdict["rule_id"] == "RUST-UNSAFE-001")
        .expect("unsafe verdict");
    unauthorized["verdicts"][unsafe_index]["verdict"] = serde_json::json!("finding");
    unauthorized["verdicts"][unsafe_index]["finding_ids"] = serde_json::json!(["unsafe-1"]);
    unauthorized["findings"] = serde_json::json!([{
        "finding_id": "unsafe-1",
        "rule_id": "RUST-UNSAFE-001",
        "action": "change_unsafe_boundary",
        "file": "src/lib.rs",
        "evidence": "Safety invariant is incomplete",
        "disposition": "repair_planned"
    }]);
    unauthorized["repair_plans"] = serde_json::json!([{
        "plan_id": "unsafe-repair",
        "finding_ids": ["unsafe-1"],
        "owned_files": ["src/lib.rs"],
        "preserved_behavior": ["Public API remains stable"]
    }]);
    assert_ledger_error(
        &fixture.validate_ledger(&unauthorized),
        "ledger.plan_authority_invalid",
    );
}

#[test]
fn runs_checked_repair_lifecycle_with_pre_mutation_extension() {
    let fixture = Fixture::new("lifecycle-repair");
    fixture.write(
        "Cargo.toml",
        "[package]\nname = \"lifecycle-fixture\"\nversion = \"0.1.0\"\nedition = \"2024\"\nrust-version = \"1.95\"\n",
    );
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 41 }\n");
    fixture.write("tests/answer.rs", "#[test]\nfn answer_is_stable() {}\n");
    fixture.commit();
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 42 }\n");
    let discovery = fixture.inspect();
    let plan = fixture.plan_value(
        &discovery,
        &serde_json::json!({
            "audit_id": "repair-wave",
            "units": [{"unit_id": "core", "anchors": ["src/lib.rs"], "context": []}],
            "excluded_dirty_files": [],
            "repository_coverage": null
        }),
    );
    assert_success(&fixture.init_audit(&discovery, &plan), "init");
    assert_success(
        &fixture.audit_operation(
            "assess",
            "repair-wave",
            &assessment_with_readability_repair(),
        ),
        "assess",
    );
    assert_success(
        &fixture.audit_operation(
            "extend",
            "repair-wave",
            &serde_json::json!({
                "unit_id": "core",
                "reason": "focused regression coverage for the repair",
                "files": [{"path": "tests/answer.rs", "anchor": "src/lib.rs", "relation": "focused_test"}],
                "plan_extensions": [{"plan_id": "readability-repair", "files": ["tests/answer.rs"]}]
            }),
        ),
        "extend",
    );
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 43 }\n");
    fixture.write(
        "tests/answer.rs",
        "#[test]\nfn answer_is_stable() { assert_eq!(43, 43); }\n",
    );
    let evidence = assert_success(
        &fixture.audit_operation(
            "collect",
            "repair-wave",
            &serde_json::json!({
                "applicable_classes": ["test"],
                "requests": [{
                    "evidence_id": "focused-tests",
                    "unit_id": "core",
                    "evidence_class": "test",
                    "selector": "cargo test",
                    "origin": "cargo_native",
                    "package_cwd": ".",
                    "environment": "fixture; Rust 1.95+",
                    "execution": {
                        "kind": "command",
                        "program": "cargo",
                        "args": ["test", "--message-format=json-diagnostic-rendered-ansi"],
                        "format": "cargo_json"
                    }
                }]
            }),
        ),
        "collect evidence",
    );
    assert_eq!(evidence["records"][0]["status"], "passed");
    assert_success(
        &fixture.audit_operation(
            "complete",
            "repair-wave",
            &serde_json::json!({
                "unit_id": "core",
                "repairs": [{
                    "plan_id": "readability-repair",
                    "status": "applied",
                    "changed_files": ["src/lib.rs", "tests/answer.rs"]
                }],
                "evidence_ids": ["focused-tests"]
            }),
        ),
        "complete",
    );
    let result = assert_success(&fixture.finalize("repair-wave"), "finalize");
    assert_eq!(result["status"], "clean");
    assert_eq!(
        result["changed_files"].as_array().expect("changed").len(),
        2
    );
    assert!(
        fixture
            .root
            .join(".git/northstar/rust-quality/audits/repair-wave/report.md")
            .is_file()
    );
}

#[test]
fn distinguishes_warning_unavailable_and_unrun_evidence() {
    let fixture = initialized_lifecycle_fixture("evidence-wave", false);
    fixture.write(
        "src/lib.rs",
        "#![warn(missing_debug_implementations)]\npub struct Public;\n",
    );
    let result = assert_success(
        &fixture.audit_operation(
            "collect",
            "evidence-wave",
            &serde_json::json!({
                "applicable_classes": ["compiler", "lint", "test"],
                "requests": [
                    {
                        "evidence_id": "compiler-warning",
                        "unit_id": "core",
                        "evidence_class": "compiler",
                        "selector": "cargo check",
                        "origin": "cargo_native",
                        "package_cwd": ".",
                        "environment": "fixture; Rust 1.95+",
                        "execution": {
                            "kind": "command",
                            "program": "cargo",
                            "args": ["check", "--message-format=json-diagnostic-rendered-ansi"],
                            "format": "cargo_json"
                        }
                    },
                    {
                        "evidence_id": "lint-runner",
                        "unit_id": "core",
                        "evidence_class": "lint",
                        "selector": "missing lint runner",
                        "origin": "repository_task",
                        "package_cwd": ".",
                        "environment": "fixture",
                        "execution": {
                            "kind": "command",
                            "program": "northstar-definitely-missing-command",
                            "args": [],
                            "format": "generic"
                        }
                    }
                ]
            }),
        ),
        "collect warning evidence",
    );
    let records = result["records"].as_array().expect("records");
    let warning = records
        .iter()
        .find(|record| record["evidence_id"] == "compiler-warning")
        .expect("warning record");
    assert_eq!(warning["status"], "warning");
    assert_eq!(warning["exit_status"], 0);
    assert_eq!(warning["failure_stage"], "source");
    assert!(
        warning["diagnostics"]
            .as_array()
            .expect("diagnostics")
            .iter()
            .any(
                |diagnostic| diagnostic["identifier"] == "missing_debug_implementations"
                    && diagnostic["catalogue_evidence"] == serde_json::json!(["RUST-API-001"])
                    && diagnostic["mapping_disposition"] == "promote_evidence"
            )
    );
    assert_eq!(
        records
            .iter()
            .find(|record| record["evidence_id"] == "lint-runner")
            .expect("unavailable")["failure_stage"],
        "startup"
    );
    assert_eq!(
        records
            .iter()
            .find(|record| record["evidence_id"] == "unrun-test-core")
            .expect("unrun")["status"],
        "unrun"
    );
    assert_eq!(
        result["limitations"].as_array().expect("limitations").len(),
        3
    );
    assert!(result.get("findings").is_none());
    assert!(result.get("repair_plans").is_none());
}

#[test]
fn partial_later_collect_does_not_fabricate_unrun_for_sealed_classes() {
    let fixture = initialized_multi_unit_fixture("partial-collect-wave");
    let evidence_root = fixture
        .root
        .join(".git/northstar/rust-quality/audits/partial-collect-wave/evidence");

    let first = assert_success(
        &fixture.audit_operation(
            "collect",
            "partial-collect-wave",
            &serde_json::json!({
                "applicable_classes": ["test"],
                "requests": [{
                    "evidence_id": "test-core",
                    "unit_id": "core",
                    "evidence_class": "test",
                    "selector": "true",
                    "origin": "agent_resolved",
                    "package_cwd": ".",
                    "environment": "fixture",
                    "execution": {
                        "kind": "command",
                        "program": "true",
                        "args": [],
                        "format": "generic"
                    }
                }]
            }),
        ),
        "first collect seals test/core",
    );
    assert_eq!(first["records"][0]["status"], "passed");
    let sealed_path = evidence_root.join("test-core.json");
    let sealed_before = fs::read(&sealed_path).expect("read sealed record");
    let inventory_before = evidence_inventory(&evidence_root);

    let second = assert_success(
        &fixture.audit_operation(
            "collect",
            "partial-collect-wave",
            &serde_json::json!({
                "applicable_classes": ["lint", "test"],
                "requests": [{
                    "evidence_id": "lint-core",
                    "unit_id": "core",
                    "evidence_class": "lint",
                    "selector": "true",
                    "origin": "agent_resolved",
                    "package_cwd": ".",
                    "environment": "fixture",
                    "execution": {
                        "kind": "command",
                        "program": "true",
                        "args": [],
                        "format": "generic"
                    }
                }]
            }),
        ),
        "partial later collect omits sealed test request",
    );
    let second_ids: Vec<_> = second["records"]
        .as_array()
        .expect("second records")
        .iter()
        .map(|record| record["evidence_id"].as_str().expect("id").to_owned())
        .collect();
    assert!(
        !second_ids.iter().any(|id| id == "unrun-test-core"),
        "fabricated unrun-test-core contradicting sealed evidence: {second_ids:?}"
    );
    assert!(
        !second_ids.iter().any(|id| id == "unrun-test-extra"),
        "audit-wide unrun expansion outside call scope: {second_ids:?}"
    );
    assert!(
        second_ids.iter().any(|id| id == "lint-core"),
        "expected lint-core in second receipt: {second_ids:?}"
    );
    assert_eq!(
        fs::read(&sealed_path).expect("reread sealed record"),
        sealed_before,
        "sealed record bytes must stay immutable"
    );
    let inventory_after = evidence_inventory(&evidence_root);
    for id in &inventory_before {
        assert!(
            inventory_after.contains(id),
            "pre-existing evidence disappeared: {id}"
        );
    }
    assert!(
        !inventory_after.iter().any(|id| id == "unrun-test-core"),
        "unrun-test-core must not appear on disk"
    );
    assert!(
        !inventory_after.iter().any(|id| id == "unrun-test-extra"),
        "unrun-test-extra must not appear on disk"
    );
}

#[test]
fn scoped_missing_coverage_still_emits_unrun() {
    let fixture = initialized_multi_unit_fixture("missing-coverage-wave");
    let evidence_root = fixture
        .root
        .join(".git/northstar/rust-quality/audits/missing-coverage-wave/evidence");
    assert_success(
        &fixture.audit_operation(
            "collect",
            "missing-coverage-wave",
            &serde_json::json!({
                "applicable_classes": ["test"],
                "requests": [{
                    "evidence_id": "test-core",
                    "unit_id": "core",
                    "evidence_class": "test",
                    "selector": "true",
                    "origin": "agent_resolved",
                    "package_cwd": ".",
                    "environment": "fixture",
                    "execution": {
                        "kind": "command",
                        "program": "true",
                        "args": [],
                        "format": "generic"
                    }
                }]
            }),
        ),
        "seal test/core",
    );
    let sealed_before = fs::read(evidence_root.join("test-core.json")).expect("sealed");
    let result = assert_success(
        &fixture.audit_operation(
            "collect",
            "missing-coverage-wave",
            &serde_json::json!({
                "applicable_classes": ["lint", "test"],
                "requests": [{
                    "evidence_id": "lint-extra",
                    "unit_id": "extra",
                    "evidence_class": "lint",
                    "selector": "true",
                    "origin": "agent_resolved",
                    "package_cwd": ".",
                    "environment": "fixture",
                    "execution": {
                        "kind": "command",
                        "program": "true",
                        "args": [],
                        "format": "generic"
                    }
                }]
            }),
        ),
        "collect scoped missing test for extra",
    );
    let ids: Vec<_> = result["records"]
        .as_array()
        .expect("records")
        .iter()
        .map(|record| record["evidence_id"].as_str().expect("id").to_owned())
        .collect();
    assert!(ids.iter().any(|id| id == "lint-extra"), "{ids:?}");
    assert!(ids.iter().any(|id| id == "unrun-test-extra"), "{ids:?}");
    assert!(!ids.iter().any(|id| id == "unrun-test-core"), "{ids:?}");
    assert!(!ids.iter().any(|id| id == "unrun-lint-core"), "{ids:?}");
    assert_eq!(
        fs::read(evidence_root.join("test-core.json")).expect("reread"),
        sealed_before
    );
}

#[test]
fn colliding_unit_class_request_fails_before_write() {
    let fixture = initialized_multi_unit_fixture("collision-wave");
    let evidence_root = fixture
        .root
        .join(".git/northstar/rust-quality/audits/collision-wave/evidence");
    assert_success(
        &fixture.audit_operation(
            "collect",
            "collision-wave",
            &serde_json::json!({
                "applicable_classes": ["test"],
                "requests": [{
                    "evidence_id": "test-core",
                    "unit_id": "core",
                    "evidence_class": "test",
                    "selector": "true",
                    "origin": "agent_resolved",
                    "package_cwd": ".",
                    "environment": "fixture",
                    "execution": {
                        "kind": "command",
                        "program": "true",
                        "args": [],
                        "format": "generic"
                    }
                }]
            }),
        ),
        "seal test/core",
    );
    let before = evidence_inventory(&evidence_root);
    let sealed_before = fs::read(evidence_root.join("test-core.json")).expect("sealed");
    let output = fixture.audit_operation(
        "collect",
        "collision-wave",
        &serde_json::json!({
            "applicable_classes": ["test"],
            "requests": [{
                "evidence_id": "test-core-again",
                "unit_id": "core",
                "evidence_class": "test",
                "selector": "true",
                "origin": "agent_resolved",
                "package_cwd": ".",
                "environment": "fixture",
                "execution": {
                    "kind": "command",
                    "program": "true",
                    "args": [],
                    "format": "generic"
                }
            }]
        }),
    );
    assert_lifecycle_error(&output, "evidence.coverage_exists");
    assert_eq!(evidence_inventory(&evidence_root), before);
    assert_eq!(
        fs::read(evidence_root.join("test-core.json")).expect("reread"),
        sealed_before
    );
}

#[test]
fn duplicate_unit_class_requests_fail_before_execution() {
    let fixture = initialized_multi_unit_fixture("duplicate-coverage-wave");
    let evidence_root = fixture
        .root
        .join(".git/northstar/rust-quality/audits/duplicate-coverage-wave/evidence");
    let marker = fixture.root.join("side-effect-marker");
    let output = fixture.audit_operation(
        "collect",
        "duplicate-coverage-wave",
        &serde_json::json!({
            "applicable_classes": ["test"],
            "requests": [
                {
                    "evidence_id": "test-core-a",
                    "unit_id": "core",
                    "evidence_class": "test",
                    "selector": "touch marker",
                    "origin": "agent_resolved",
                    "package_cwd": ".",
                    "environment": "fixture",
                    "execution": {
                        "kind": "command",
                        "program": "touch",
                        "args": ["side-effect-marker"],
                        "format": "generic"
                    }
                },
                {
                    "evidence_id": "test-core-b",
                    "unit_id": "core",
                    "evidence_class": "test",
                    "selector": "touch marker again",
                    "origin": "agent_resolved",
                    "package_cwd": ".",
                    "environment": "fixture",
                    "execution": {
                        "kind": "command",
                        "program": "touch",
                        "args": ["side-effect-marker"],
                        "format": "generic"
                    }
                }
            ]
        }),
    );
    assert_lifecycle_error(&output, "evidence.coverage_duplicate");
    assert!(!evidence_root.exists() || evidence_inventory(&evidence_root).is_empty());
    assert!(!evidence_root.join("test-core-a.json").exists());
    assert!(!evidence_root.join("test-core-b.json").exists());
    assert!(
        !marker.exists(),
        "duplicate coverage must fail before command side effects"
    );
}

#[test]
fn records_compiler_source_failure_without_losing_raw_output() {
    let fixture = initialized_lifecycle_fixture("source-failure-wave", false);
    fixture.write("src/lib.rs", "pub fn broken( {\n");
    let result = assert_success(
        &fixture.audit_operation(
            "collect",
            "source-failure-wave",
            &serde_json::json!({
                "applicable_classes": ["compiler"],
                "requests": [{
                    "evidence_id": "compiler-failure",
                    "unit_id": "core",
                    "evidence_class": "compiler",
                    "selector": "cargo check",
                    "origin": "cargo_native",
                    "package_cwd": ".",
                    "environment": "fixture; Rust 1.95+",
                    "execution": {
                        "kind": "command",
                        "program": "cargo",
                        "args": ["check", "--message-format=json-diagnostic-rendered-ansi"],
                        "format": "cargo_json"
                    }
                }]
            }),
        ),
        "collect source failure",
    );
    let record = &result["records"][0];
    assert_eq!(record["status"], "failed");
    assert_eq!(record["failure_stage"], "source");
    assert_ne!(record["exit_status"], 0);
    assert_eq!(
        record["raw_artifacts"].as_array().expect("artifacts").len(),
        2
    );
}

#[test]
fn closes_out_nested_rust_with_compact_evidence_only() {
    let fixture = Fixture::new("nested-closeout");
    fixture.write("package.json", "{\"private\":true}\n");
    fixture.write(
        "packages/engine/Cargo.toml",
        "[package]\nname = \"engine\"\nversion = \"0.1.0\"\nedition = \"2024\"\nrust-version = \"1.95\"\n",
    );
    fixture.write(
        "packages/engine/src/lib.rs",
        "pub fn answer() -> u8 { 41 }\n",
    );
    fixture.commit();
    fixture.write(
        "packages/engine/src/lib.rs",
        "pub fn answer() -> u8 { 42 }\n",
    );
    let result = assert_success(
        &fixture.closeout(&serde_json::json!({
            "applicable_rules": ["RUST-READ-001", "RUST-ERR-001"],
            "evidence_plan": {
                "applicable_classes": ["compiler"],
                "requests": [{
                    "evidence_id": "nested-check",
                    "evidence_class": "compiler",
                    "selector": "cargo check --manifest-path packages/engine/Cargo.toml",
                    "origin": "agent_resolved",
                    "package_cwd": "packages/engine",
                    "environment": "mixed repository; Rust 1.95+",
                    "execution": {
                        "kind": "command",
                        "program": "cargo",
                        "args": ["check", "--message-format=json-diagnostic-rendered-ansi"],
                        "format": "cargo_json"
                    }
                }]
            }
        })),
        "nested closeout",
    );
    assert_eq!(result["evidence"][0]["status"], "passed");
    assert_eq!(
        result["rust_anchors"],
        serde_json::json!(["packages/engine/src/lib.rs"])
    );
    assert!(result["evidence"][0].get("raw_artifacts").is_none());
    assert!(result.get("units").is_none());
    assert!(result.get("assessments").is_none());
}

#[test]
fn rejects_hidden_mutation_and_changed_exclusions() {
    let hidden = initialized_lifecycle_fixture("hidden-wave", false);
    assert_success(
        &hidden.audit_operation("assess", "hidden-wave", &complete_assessment()),
        "assess hidden",
    );
    hidden.write("src/lib.rs", "pub fn answer() -> u8 { 99 }\n");
    assert_lifecycle_error(
        &hidden.audit_operation(
            "complete",
            "hidden-wave",
            &serde_json::json!({"unit_id": "core", "repairs": [], "evidence_ids": []}),
        ),
        "lifecycle.hidden_or_false_mutation",
    );

    let excluded = initialized_lifecycle_fixture("excluded-wave", true);
    assert_success(
        &excluded.audit_operation("assess", "excluded-wave", &complete_assessment()),
        "assess excluded",
    );
    excluded.write("README.md", "changed during audit\n");
    assert_lifecycle_error(
        &excluded.audit_operation(
            "complete",
            "excluded-wave",
            &serde_json::json!({"unit_id": "core", "repairs": [], "evidence_ids": []}),
        ),
        "lifecycle.read-only_file_changed",
    );
}

#[test]
fn finalization_rejects_incomplete_changed_and_repeated_records() {
    let incomplete = initialized_lifecycle_fixture("incomplete-wave", false);
    assert_lifecycle_error(
        &incomplete.finalize("incomplete-wave"),
        "lifecycle.unit_not_assessed",
    );

    let post_complete = initialized_lifecycle_fixture("post-complete-wave", false);
    complete_unchanged_unit(&post_complete, "post-complete-wave");
    post_complete.write("src/lib.rs", "pub fn answer() -> u8 { 100 }\n");
    assert_lifecycle_error(
        &post_complete.finalize("post-complete-wave"),
        "lifecycle.hidden_or_false_mutation",
    );

    let changed_policy = initialized_lifecycle_fixture("policy-wave", false);
    complete_unchanged_unit(&changed_policy, "policy-wave");
    changed_policy.write(
        ".git/northstar/rust-quality/audits/policy-wave/strict-audit.json",
        "{}\n",
    );
    assert_lifecycle_error(
        &changed_policy.finalize("policy-wave"),
        "lifecycle.policy_changed",
    );

    let repeated = initialized_lifecycle_fixture("repeated-wave", false);
    complete_unchanged_unit(&repeated, "repeated-wave");
    assert_success(&repeated.finalize("repeated-wave"), "first finalize");
    assert_lifecycle_error(
        &repeated.finalize("repeated-wave"),
        "lifecycle.already_finalized",
    );
}

#[test]
fn rejects_unaccepted_deviation_disposition() {
    let fixture = initialized_lifecycle_fixture("deviation-wave", false);
    assert_lifecycle_error(
        &fixture.audit_operation(
            "assess",
            "deviation-wave",
            &assessment_with_unaccepted_deviation(),
        ),
        "lifecycle.deviation_unaccepted",
    );
}

fn complete_assessment() -> Value {
    let projection: Value = serde_json::from_slice(
        &fs::read(strict_projection_path()).expect("read strict projection"),
    )
    .expect("parse strict projection");
    let verdicts: Vec<_> = projection["rules"]
        .as_array()
        .expect("rules")
        .iter()
        .filter(|rule| rule["maturity"] == "approved" && rule["enforcement"] != "evaluation_only")
        .map(|rule| {
            serde_json::json!({
                "rule_id": rule["id"],
                "verdict": "pass",
                "inspected_surfaces": ["src/lib.rs"],
                "evidence": ["Reviewed against the rule contract"]
            })
        })
        .collect();
    serde_json::json!({
        "unit_id": "core",
        "verdicts": verdicts,
        "attestations": [
            {"dimension": "correctness_assurance", "inspected_surfaces": ["src/lib.rs"], "evidence": ["Behavior checked"]},
            {"dimension": "architecture", "inspected_surfaces": ["src/lib.rs"], "evidence": ["Boundary checked"]},
            {"dimension": "human_quality", "inspected_surfaces": ["src/lib.rs"], "evidence": ["Naming and flow checked"]}
        ],
        "findings": [],
        "repair_plans": [],
        "limitations": []
    })
}

fn assessment_with_readability_repair() -> Value {
    let mut assessment = complete_assessment();
    let index = assessment["verdicts"]
        .as_array()
        .expect("verdicts")
        .iter()
        .position(|verdict| verdict["rule_id"] == "RUST-READ-001")
        .expect("readability verdict");
    assessment["verdicts"][index]["verdict"] = serde_json::json!("finding");
    assessment["verdicts"][index]["finding_ids"] = serde_json::json!(["readability-1"]);
    assessment["findings"] = serde_json::json!([{
        "finding_id": "readability-1",
        "rule_id": "RUST-READ-001",
        "action": "flatten_control_flow",
        "file": "src/lib.rs",
        "evidence": "Control flow obscures the invariant",
        "disposition": "repair_planned"
    }]);
    assessment["repair_plans"] = serde_json::json!([{
        "plan_id": "readability-repair",
        "finding_ids": ["readability-1"],
        "owned_files": ["src/lib.rs"],
        "preserved_behavior": ["Public return contract remains stable"]
    }]);
    assessment
}

fn assessment_with_unaccepted_deviation() -> Value {
    let mut assessment = complete_assessment();
    let index = assessment["verdicts"]
        .as_array()
        .expect("verdicts")
        .iter()
        .position(|verdict| verdict["rule_id"] == "RUST-READ-001")
        .expect("readability verdict");
    assessment["verdicts"][index]["verdict"] = serde_json::json!("finding");
    assessment["verdicts"][index]["finding_ids"] = serde_json::json!(["deviation-1"]);
    assessment["findings"] = serde_json::json!([{
        "finding_id": "deviation-1",
        "rule_id": "RUST-READ-001",
        "action": "retain_complex_flow",
        "file": "src/lib.rs",
        "evidence": "Repository contract requires the state-machine shape",
        "disposition": "deviation"
    }]);
    assessment
}

fn initialized_multi_unit_fixture(audit_id: &str) -> Fixture {
    let fixture = Fixture::new(audit_id);
    fixture.write(
        "Cargo.toml",
        "[package]\nname = \"partial-collect\"\nversion = \"0.1.0\"\nedition = \"2024\"\nrust-version = \"1.95\"\n",
    );
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 41 }\n");
    fixture.write("src/extra.rs", "pub fn extra() -> u8 { 1 }\n");
    fixture.write("README.md", "baseline\n");
    fixture.commit();
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 42 }\n");
    fixture.write("src/extra.rs", "pub fn extra() -> u8 { 2 }\n");
    let discovery = fixture.inspect();
    let plan = fixture.plan_value(
        &discovery,
        &serde_json::json!({
            "audit_id": audit_id,
            "units": [
                {"unit_id": "core", "anchors": ["src/lib.rs"], "context": []},
                {"unit_id": "extra", "anchors": ["src/extra.rs"], "context": []}
            ],
            "excluded_dirty_files": [],
            "repository_coverage": null
        }),
    );
    assert_success(
        &fixture.init_audit(&discovery, &plan),
        "init multi-unit fixture",
    );
    fixture
}

fn evidence_inventory(evidence_root: &Path) -> Vec<String> {
    let mut ids = fs::read_dir(evidence_root)
        .expect("read evidence root")
        .filter_map(|entry| {
            let entry = entry.ok()?;
            let name = entry.file_name().into_string().ok()?;
            name.strip_suffix(".json").map(str::to_owned)
        })
        .collect::<Vec<_>>();
    ids.sort();
    ids
}

fn initialized_lifecycle_fixture(audit_id: &str, exclude_readme: bool) -> Fixture {
    let fixture = Fixture::new(audit_id);
    fixture.write(
        "Cargo.toml",
        "[package]\nname = \"lifecycle-negative\"\nversion = \"0.1.0\"\nedition = \"2024\"\nrust-version = \"1.95\"\n",
    );
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 41 }\n");
    fixture.write("README.md", "baseline\n");
    fixture.commit();
    fixture.write("src/lib.rs", "pub fn answer() -> u8 { 42 }\n");
    if exclude_readme {
        fixture.write("README.md", "dirty before audit\n");
    }
    let discovery = fixture.inspect();
    let exclusions = if exclude_readme {
        serde_json::json!([{"path": "README.md", "reason": "outside Rust repair scope"}])
    } else {
        serde_json::json!([])
    };
    let plan = fixture.plan_value(
        &discovery,
        &serde_json::json!({
            "audit_id": audit_id,
            "units": [{"unit_id": "core", "anchors": ["src/lib.rs"], "context": []}],
            "excluded_dirty_files": exclusions,
            "repository_coverage": null
        }),
    );
    assert_success(
        &fixture.init_audit(&discovery, &plan),
        "init negative fixture",
    );
    fixture
}

fn complete_unchanged_unit(fixture: &Fixture, audit_id: &str) {
    assert_success(
        &fixture.audit_operation("assess", audit_id, &complete_assessment()),
        "assess unchanged",
    );
    assert_success(
        &fixture.audit_operation(
            "collect",
            audit_id,
            &serde_json::json!({"applicable_classes": ["test"], "requests": []}),
        ),
        "record unavailable selector",
    );
    assert_success(
        &fixture.audit_operation(
            "complete",
            audit_id,
            &serde_json::json!({"unit_id": "core", "repairs": [], "evidence_ids": ["unrun-test-core"]}),
        ),
        "complete unchanged",
    );
}

fn strict_projection_path() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../references/language-quality/rust/strict-audit.json")
}

fn assert_ledger_error(output: &std::process::Output, expected: &str) {
    assert_eq!(output.status.code(), Some(2));
    assert!(
        String::from_utf8_lossy(&output.stderr).contains(expected),
        "expected {expected}, got {}",
        String::from_utf8_lossy(&output.stderr)
    );
}

fn assert_lifecycle_error(output: &std::process::Output, expected: &str) {
    assert_eq!(output.status.code(), Some(2));
    assert!(
        String::from_utf8_lossy(&output.stderr).contains(expected),
        "expected {expected}, got {}",
        String::from_utf8_lossy(&output.stderr)
    );
}

fn assert_success(output: &std::process::Output, operation: &str) -> Value {
    assert!(
        output.status.success(),
        "{operation} failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );
    serde_json::from_slice(&output.stdout).expect("parse successful operation")
}

fn command(directory: &Path, program: &str, arguments: &[&str]) {
    let output = Command::new(program)
        .current_dir(directory)
        .args(arguments)
        .output()
        .expect("start fixture command");
    assert!(
        output.status.success(),
        "{program} failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );
}
