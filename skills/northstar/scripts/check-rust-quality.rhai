fn require(condition, message) {
    if !condition {
        throw(message);
    }
}

fn require_key(value, key, context) {
    require(type_of(value) == "map", context + " must be an object");
    require(value.contains(key), context + " missing " + key);
}

fn require_array(value, context) {
    require(type_of(value) == "array", context + " must be an array");
}

fn valid_enforcement(value) {
    value == "mandatory" || value == "required" || value == "advisory" ||
        value == "disapplied" || value == "evaluation_only"
}

fn valid_authority(value) {
    value == "review_required" || value == "report_only" ||
        value == "operator_decision" || value == "safe_automatic"
}

fn find_rule(catalogue, rule_id) {
    for rule in catalogue["rules"] {
        if rule["id"] == rule_id {
            return rule;
        }
    }
    throw("missing required rule: " + rule_id);
}

fn replace_rule(catalogue, replacement) {
    for index in 0..catalogue["rules"].len() {
        if catalogue["rules"][index]["id"] == replacement["id"] {
            catalogue["rules"][index] = replacement;
            return catalogue;
        }
    }
    throw("cannot replace unknown rule: " + replacement["id"]);
}

fn validate_profile_map(values, context, validator) {
    for profile in ["ordinary", "strict", "high_assurance"] {
        require(values.contains(profile), context + " missing " + profile);
        require(call(validator, values[profile]), context + " has invalid " + profile + " value");
    }
    require(values.len() == 3, context + " has an unknown profile");
}

fn validate_rule(rule, ids) {
    for key in [
        "id", "title", "category", "maturity", "decidability", "dimensions",
        "applicability", "enforcement_by_profile", "requirement", "rationale",
        "provenance", "authoring_projection", "audit_procedure",
        "mechanical_enforcement", "remediation", "deviation",
        "completion_evidence",
    ] {
        require_key(rule, key, "rule");
    }

    let rule_id = rule["id"];
    require(regex::is_match("^RUST-[A-Z]+-[0-9]{3}$", rule_id), "invalid rule id: " + rule_id);
    require(!ids.contains(rule_id), "duplicate rule id: " + rule_id);
    ids.push(rule_id);
    require(rule["maturity"] == "approved" || rule["maturity"] == "prototype", "invalid maturity: " + rule_id);
    require_array(rule["dimensions"], rule_id + " dimensions");
    require(rule["dimensions"].len() > 0, rule_id + " requires dimensions");
    require_array(rule["provenance"], rule_id + " provenance");
    require(rule["provenance"].len() > 0, rule_id + " requires provenance");

    validate_profile_map(rule["enforcement_by_profile"], rule_id + " enforcement", Fn("valid_enforcement"));
    if rule["maturity"] != "approved" {
        require(rule["enforcement_by_profile"]["strict"] == "evaluation_only", "non-approved rule cannot enforce strict: " + rule_id);
    }

    for source in rule["provenance"] {
        for key in ["authority", "maturity", "revision", "url", "upstream_rules"] {
            require_key(source, key, rule_id + " provenance");
        }
        require(source["authority"].len() > 0, rule_id + " has empty provenance authority");
        require(source["revision"].len() > 0, rule_id + " has unpinned provenance");
        require(str::starts_with(source["url"], "https://"), rule_id + " has non-HTTPS provenance");
    }

    let remediation = rule["remediation"];
    validate_profile_map(remediation["default_authority_by_profile"], rule_id + " authority", Fn("valid_authority"));
    require_array(remediation["action_overrides"], rule_id + " action overrides");
    for action_override in remediation["action_overrides"] {
        require_key(action_override, "action", rule_id + " action override");
        require_key(action_override, "authority_by_profile", rule_id + " action override");
        require_key(action_override, "reason", rule_id + " action override");
        validate_profile_map(action_override["authority_by_profile"], rule_id + "/" + action_override["action"], Fn("valid_authority"));
    }
}

fn validate_catalogue(catalogue) {
    for key in ["schema_version", "language", "schema_provenance", "modelled_profiles", "production_profiles", "rules"] {
        require_key(catalogue, key, "catalogue");
    }
    require(catalogue["schema_version"] == "1.0.0", "unsupported catalogue schema version");
    require(catalogue["language"] == "rust", "catalogue language must be rust");
    require(catalogue["modelled_profiles"] == ["ordinary", "strict", "high_assurance"], "modelled profiles drifted");
    require(catalogue["production_profiles"] == ["strict"], "strict must be the only production profile");
    require_array(catalogue["rules"], "catalogue rules");
    require(catalogue["rules"].len() == 7, "catalogue must contain seven rules");

    let ids = [];
    let approved = 0;
    for rule in catalogue["rules"] {
        validate_rule(rule, ids);
        if rule["maturity"] == "approved" {
            approved += 1;
        }
    }
    require(approved == 6, "catalogue must contain six approved rules");

    let readability_rule = find_rule(catalogue, "RUST-READ-001");
    require(readability_rule["authoring_projection"].len() >= 4 &&
        readability_rule["authoring_projection"][3].contains("account for every changed line") &&
        readability_rule["authoring_projection"][3].contains("public trait implementation") &&
        readability_rule["authoring_projection"][3].contains("optional derives") &&
        readability_rule["authoring_projection"][3].contains("formatting-only churn"),
        "readability authoring lacks final-diff responsibility accounting");

    let unsafe_rule = find_rule(catalogue, "RUST-UNSAFE-001");
    require(unsafe_rule["enforcement_by_profile"]["strict"] == "mandatory", "strict unsafe assessment must be mandatory");
    require(unsafe_rule["remediation"]["default_authority_by_profile"]["strict"] == "report_only", "strict unsafe repair must remain report-only");
    require(unsafe_rule["authoring_projection"].len() >= 6 &&
        unsafe_rule["authoring_projection"][2].contains("single-allocation") &&
        unsafe_rule["authoring_projection"][2].contains("isize::MAX") &&
        unsafe_rule["authoring_projection"][2].contains("full borrow") &&
        unsafe_rule["authoring_projection"][4].contains("tick each copied Safety bullet") &&
        unsafe_rule["authoring_projection"][4].contains("Never infer provenance"),
        "unsafe authoring lacks the pointer-operation proof checklist");
    require(unsafe_rule["authoring_projection"][3].contains("CStr::from_ptr") &&
        unsafe_rule["authoring_projection"][3].contains("complete range through the first NUL") &&
        unsafe_rule["authoring_projection"][3].contains("isize::MAX"),
        "unsafe authoring lacks the CStr::from_ptr proof checklist");

    let slop_rule = find_rule(catalogue, "RUST-SLOP-001");
    require(slop_rule["maturity"] == "prototype", "slop rule must remain prototype");
    require(slop_rule["enforcement_by_profile"]["strict"] == "evaluation_only", "slop rule must remain evaluation-only");
    require(slop_rule["remediation"]["default_authority_by_profile"]["strict"] == "report_only", "slop rule must remain report-only");
    require(slop_rule["audit_procedure"].len() >= 4 &&
        slop_rule["audit_procedure"][2].contains("total candidate ledger") &&
        slop_rule["audit_procedure"][2].contains("disposition retain") &&
        slop_rule["audit_procedure"][3].contains("independently under RUST-READ-001") &&
        slop_rule["audit_procedure"][3].contains("Public visibility alone"),
        "slop audit may silently omit retained candidates");

    let error_rule = find_rule(catalogue, "RUST-ERR-001");
    require(error_rule["remediation"]["default_authority_by_profile"]["strict"] == "review_required",
        "ordinary error repair must remain review-required");
    require(error_rule["remediation"]["action_overrides"].len() == 1,
        "foreign error policy override missing");
    let error_override = error_rule["remediation"]["action_overrides"][0];
    require(error_override["action"] == "change_foreign_error_policy",
        "foreign error policy action drifted");
    require(error_override["authority_by_profile"]["strict"] == "operator_decision",
        "foreign error policy mutation requires operator decision");

    let msrv_rule = find_rule(catalogue, "RUST-MSRV-001");
    require(msrv_rule["applicability"]["rust_release"].contains("repository"), "MSRV must be repository-derived");
    require(msrv_rule["remediation"]["action_overrides"].len() == 1, "MSRV policy override missing");
    let msrv_override = msrv_rule["remediation"]["action_overrides"][0];
    require(msrv_override["action"] == "change_version_policy", "MSRV policy action drifted");
    require(msrv_override["authority_by_profile"]["strict"] == "operator_decision", "MSRV policy mutation requires operator decision");
}

fn projected_overrides(remediation) {
    let projected = [];
    for action_override in remediation["action_overrides"] {
        let item = #{};
        item["action"] = action_override["action"];
        item["authority"] = action_override["authority_by_profile"]["strict"];
        item["reason"] = action_override["reason"];
        projected.push(item);
    }
    projected
}

fn projected_remediation(rule) {
    let projected = #{};
    projected["default_authority"] = rule["remediation"]["default_authority_by_profile"]["strict"];
    projected["action_overrides"] = projected_overrides(rule["remediation"]);
    projected["guidance"] = rule["remediation"]["guidance"];
    projected
}

fn project_rule(rule, workflow) {
    let projected = #{};
    for key in ["id", "title", "maturity", "dimensions", "applicability", "requirement", "mechanical_enforcement", "deviation", "completion_evidence"] {
        projected[key] = rule[key];
    }
    projected["enforcement"] = rule["enforcement_by_profile"]["strict"];
    projected["remediation"] = projected_remediation(rule);
    if workflow == "everyday_authoring" {
        projected["authoring_projection"] = rule["authoring_projection"];
    } else {
        projected["rationale"] = rule["rationale"];
        projected["audit_procedure"] = rule["audit_procedure"];
    }
    projected
}

fn project_catalogue(catalogue, workflow) {
    let projected_rules = [];
    for rule in catalogue["rules"] {
        projected_rules.push(project_rule(rule, workflow));
    }
    let projection = #{};
    projection["schema_version"] = "1.0.0";
    projection["language"] = "rust";
    projection["workflow"] = workflow;
    projection["profile"] = "strict";
    projection["catalogue_schema_version"] = catalogue["schema_version"];
    projection["rules"] = projected_rules;
    projection
}

fn require_projection(catalogue, workflow, skill_root, filename) {
    let expected = project_catalogue(catalogue, workflow);
    let actual = json::read_file(path::join(skill_root, filename));
    require(actual == expected, workflow + " projection drifted from catalogue");
}

fn validate_schema_file(skill_root, filename) {
    let schema = json::read_file(path::join(skill_root, filename));
    require(schema["$schema"] == "https://json-schema.org/draft/2020-12/schema", filename + " uses wrong JSON Schema dialect");
    require(schema["$id"].contains("rust-quality"), filename + " has wrong schema identity");
    require(schema["type"] == "object", filename + " root must be an object");
    require_array(schema["required"], filename + " required fields");
    require(schema["required"].len() > 0, filename + " requires no fields");
}

fn validate_authoring_references(catalogue, skill_root) {
    let ids = [
        "RUST-READ-001", "RUST-API-001", "RUST-ERR-001", "RUST-UNSAFE-001",
        "RUST-ASYNC-001", "RUST-MSRV-001", "RUST-SLOP-001",
    ];
    let filenames = [
        "rust-read-001.json", "rust-api-001.json", "rust-err-001.json",
        "rust-unsafe-001.json", "rust-async-001.json", "rust-msrv-001.json",
        "rust-slop-001.json",
    ];
    let projection = json::read_file(path::join(
        skill_root,
        "references/language-quality/rust/strict-authoring.json",
    ));
    let mode = fs::read_file(path::join(
        skill_root,
        "references/modes/rust-quality-authoring.md",
    ));

    require(projection["rules"].len() == filenames.len(), "authoring projection and references differ in size");
    for index in 0..filenames.len() {
        let expected = find_rule(projection, ids[index]);
        let actual = json::read_file(path::join(
            skill_root,
            "references/language-quality/rust/authoring/" + filenames[index],
        ));
        require(actual == expected, filenames[index] + " drifted from strict authoring projection");
        require(mode.contains(filenames[index]), "authoring mode does not route " + filenames[index]);
    }
    require(fs::file_size(path::join(skill_root, "references/modes/rust-quality-authoring.md")) <= 8192,
        "Rust authoring mode exceeds compact context budget");
}

fn route_authoring_case(item) {
    if item["explicit_audit"] && item["rust_task"] {
        return "rust_quality_audit";
    }
    if item["rust_scope_active"] && item["rust_task"] {
        return "rust_quality_authoring";
    }
    "other_router"
}

fn validate_authoring_routes(skill_root) {
    let fixtures = json::read_file(path::join(
        skill_root,
        "references/language-quality/rust/authoring-routing-fixtures.json",
    ));
    require(fixtures["schema_version"] == "1.0.0", "unsupported authoring routing fixture schema");
    require_array(fixtures["cases"], "authoring routing cases");
    require(fixtures["cases"].len() == 7, "Rust routing fixtures must contain seven cases");
    let ids = [];
    for item in fixtures["cases"] {
        for key in ["id", "rust_scope_active", "rust_task", "explicit_audit", "expected_route"] {
            require_key(item, key, "authoring routing case");
        }
        require(!ids.contains(item["id"]), "duplicate authoring routing case: " + item["id"]);
        ids.push(item["id"]);
        require(route_authoring_case(item) == item["expected_route"], "wrong route for " + item["id"]);
    }
}

fn authoring_workflow_action(item) {
    if !item["profile_resolved"] {
        return "stop_before_edit";
    }
    if item["requested_scope"] != "task_tranche" {
        return "reject_unrelated_scope";
    }
    if item["stage"] == "start" {
        if !item["native_selector_known"] {
            return "discover_effigy_tasks";
        }
        return "begin_task";
    }
    if item["deviation_needed"] {
        return "record_deviation";
    }
    "review_changed_tranche"
}

fn validate_authoring_workflow(skill_root) {
    let fixtures = json::read_file(path::join(
        skill_root,
        "references/language-quality/rust/authoring-workflow-fixtures.json",
    ));
    require(fixtures["schema_version"] == "1.0.0", "unsupported authoring workflow fixture schema");
    require_array(fixtures["cases"], "authoring workflow cases");
    require(fixtures["cases"].len() == 6, "authoring workflow fixtures must contain six cases");
    let ids = [];
    for item in fixtures["cases"] {
        for key in [
            "id", "stage", "profile_resolved", "native_selector_known",
            "requested_scope", "deviation_needed", "expected_action",
        ] {
            require_key(item, key, "authoring workflow case");
        }
        require(!ids.contains(item["id"]), "duplicate authoring workflow case: " + item["id"]);
        ids.push(item["id"]);
        require(item["stage"] == "start" || item["stage"] == "closeout", "invalid stage for " + item["id"]);
        require(authoring_workflow_action(item) == item["expected_action"], "wrong authoring action for " + item["id"]);
    }
}

fn validate_profile(profile, context) {
    for key in [
        "schema_version", "language", "profile", "msrv", "exclusions", "deviations_file",
    ] {
        require_key(profile, key, context);
    }
    require(profile["schema_version"] == "1.0.0", context + " uses unsupported schema");
    require(profile["language"] == "rust", context + " language must be rust");
    require(profile["profile"] == "strict", context + " must activate strict");
    for key in ["source", "cargo_manifests", "toolchain_policy_paths", "when_unresolved"] {
        require_key(profile["msrv"], key, context + " MSRV policy");
    }
    require(profile["msrv"]["source"] == "repository_policy", context + " must derive MSRV from repository policy");
    require_array(profile["msrv"]["cargo_manifests"], context + " cargo manifests");
    require_array(profile["msrv"]["toolchain_policy_paths"], context + " toolchain policy paths");
    require(profile["msrv"]["when_unresolved"] == "stop", context + " must stop when version policy is unresolved");
    require_array(profile["exclusions"]["generated"], context + " generated exclusions");
    require_array(profile["exclusions"]["vendored"], context + " vendored exclusions");
    require(profile["deviations_file"].len() > 0, context + " deviations path is empty");
}

fn validate_deviations(deviations, context) {
    require(deviations["schema_version"] == "1.0.0", context + " uses unsupported schema");
    require(deviations["language"] == "rust", context + " language must be rust");
    require_array(deviations["deviations"], context + " deviations");
}

fn validate_activation_surface(repo_root, skill_root) {
    let router = fs::read_file(path::join(skill_root, "references/router.md"));
    let skill = fs::read_file(path::join(skill_root, "SKILL.md"));
    let mode = fs::read_file(path::join(skill_root, "references/modes/rust-quality-authoring.md"));
    let scoped = fs::read_file(path::join(skill_root, "assets/templates/language-quality/rust/AGENTS.md"));

    require(router.contains("Rust everyday authoring (repository-activated)"), "router lacks repository-activated Rust route");
    require(router.contains("Rust explicit audit-and-repair (explicit only)"), "router lacks explicit Rust audit route");
    require(router.contains("never activates from ordinary coding alone"), "router permits implicit Rust audit");
    require(router.contains("modes/rust-quality-authoring.md"), "router does not select Rust authoring mode");
    require(skill.contains("Rust everyday authoring"), "skill mode table lacks Rust authoring");
    require(mode.contains("Do not load `strict-audit.json`"), "authoring mode can load the audit projection");
    require(mode.contains("Re-entry at task start and coherent batch closeout"), "authoring mode lacks re-entry contract");
    require(scoped.contains("never route it through everyday authoring"), "scoped activation blurs audit intent");
    require(fs::is_file(path::join(skill_root, "references/modes/rust-quality-audit.md")), "missing explicit Rust audit mode");
    require(fs::is_file(path::join(skill_root, "references/language-quality/rust/audit-recording.md")), "missing Rust audit recorder contract");
    require(fs::file_size(path::join(skill_root, "assets/templates/language-quality/rust/AGENTS.md")) <= 12288,
        "scoped Rust instructions exceed context budget");

    let template_profile = json::read_file(path::join(skill_root, "assets/templates/language-quality/rust/rust-quality-profile.json"));
    let template_deviations = json::read_file(path::join(skill_root, "assets/templates/language-quality/rust/rust-quality-deviations.json"));
    validate_profile(template_profile, "Rust profile template");
    validate_deviations(template_deviations, "Rust deviations template");

    if fs::is_dir(path::join(repo_root, "skills/northstar")) {
        let active_profile = json::read_file(path::join(repo_root, "docs/contracts/rust-quality-profile.json"));
        let active_deviations = json::read_file(path::join(repo_root, "docs/contracts/rust-quality-deviations.json"));
        require(active_profile == template_profile, "Northstar Rust profile drifted from copy-ready template");
        require(active_deviations == template_deviations, "Northstar Rust deviations drifted from copy-ready template");
    }
}

fn validate_audit_surface(skill_root) {
    let mode_path = path::join(skill_root, "references/modes/rust-quality-audit.md");
    let recording_path = path::join(skill_root, "references/language-quality/rust/audit-recording.md");
    let recorder_path = path::join(skill_root, "scripts/rust-quality-recorder.rhai");
    let adapter_path = path::join(skill_root, "commands/northstar-rust-audit/SKILL.md");
    let mode = fs::read_file(mode_path);
    let recording = fs::read_file(recording_path);
    let recorder = fs::read_file(recorder_path);
    let adapter = fs::read_file(adapter_path);

    require(mode.contains("Use only when the operator explicitly requests"), "Rust audit mode is not explicit-only");
    require(mode.contains("three distinct passes"), "Rust audit mode lacks separate review passes");
    require(mode.contains("run `extend` before editing"), "Rust audit mode lacks pre-mutation scope widening");
    require(mode.contains("rejects hidden mutation"), "Rust audit mode lacks deterministic final assembly");
    require(mode.contains("Format only files already") && mode.contains("byte-for-byte identical"),
        "Rust audit mode permits broad formatting or weak preservation");
    require(recording.contains("init <target-root>") && recording.contains("assess <target-root>") &&
        recording.contains("extend <target-root>") && recording.contains("complete <target-root>") &&
        recording.contains("finalize <target-root>"), "Rust recording contract lacks an operation");
    require(adapter.contains("Thin explicit entrypoint"), "Rust audit adapter duplicates procedure");
    require(!adapter.contains("## Procedure") && !adapter.contains("## Steps"), "Rust audit adapter contains procedure");
    require(!recorder.contains("process::") && !recorder.contains("command::"), "Rust recorder can launch a subprocess");
    require(fs::file_size(mode_path) <= 12288, "Rust audit mode exceeds on-demand context budget");
    require(fs::file_size(recording_path) <= 12288, "Rust recording contract exceeds on-demand context budget");
    require(fs::file_size(adapter_path) <= 1200, "Rust audit adapter exceeds thin-adapter budget");

    let manifest_schema = json::read_file(path::join(skill_root, "references/language-quality/rust/audit-manifest.schema.json"));
    let result_schema = json::read_file(path::join(skill_root, "references/language-quality/rust/audit-result.schema.json"));
    require(manifest_schema["required"].contains("initial_state"), "audit manifest does not bind dirty state");
    require(manifest_schema["required"].contains("policy_snapshot"), "audit manifest does not bind repository policy");
    require(result_schema["required"].contains("preservation"), "audit result does not prove preservation");
}

fn expect_rejection(label, catalogue, expected) {
    let rejected = false;
    try {
        validate_catalogue(catalogue);
    } catch (error) {
        rejected = true;
        require(error.to_string().contains(expected), label + " rejected for wrong reason: " + error);
    }
    require(rejected, label + " unexpectedly passed");
}

fn self_test(catalogue_path) {
    let unsupported = json::read_file(catalogue_path);
    unsupported["production_profiles"] = ["ordinary", "strict"];
    expect_rejection("unsupported profile", unsupported, "only production profile");

    let unsafe_broadened = json::read_file(catalogue_path);
    let unsafe_rule = find_rule(unsafe_broadened, "RUST-UNSAFE-001");
    unsafe_rule["remediation"]["default_authority_by_profile"]["strict"] = "review_required";
    unsafe_broadened = replace_rule(unsafe_broadened, unsafe_rule);
    expect_rejection("unsafe authority", unsafe_broadened, "report-only");

    let slop_broadened = json::read_file(catalogue_path);
    let slop_authority_rule = find_rule(slop_broadened, "RUST-SLOP-001");
    slop_authority_rule["remediation"]["default_authority_by_profile"]["strict"] = "review_required";
    slop_broadened = replace_rule(slop_broadened, slop_authority_rule);
    expect_rejection("slop authority", slop_broadened, "report-only");

    let slop_enforced = json::read_file(catalogue_path);
    let slop_enforcement_rule = find_rule(slop_enforced, "RUST-SLOP-001");
    slop_enforcement_rule["enforcement_by_profile"]["strict"] = "required";
    slop_enforced = replace_rule(slop_enforced, slop_enforcement_rule);
    expect_rejection("prototype enforcement", slop_enforced, "non-approved rule");

    let msrv_broadened = json::read_file(catalogue_path);
    let msrv_rule = find_rule(msrv_broadened, "RUST-MSRV-001");
    msrv_rule["remediation"]["action_overrides"][0]["authority_by_profile"]["strict"] = "review_required";
    msrv_broadened = replace_rule(msrv_broadened, msrv_rule);
    expect_rejection("MSRV authority", msrv_broadened, "requires operator decision");

    let error_broadened = json::read_file(catalogue_path);
    let error_rule = find_rule(error_broadened, "RUST-ERR-001");
    error_rule["remediation"]["action_overrides"][0]["authority_by_profile"]["strict"] = "review_required";
    error_broadened = replace_rule(error_broadened, error_rule);
    expect_rejection("foreign error policy authority", error_broadened, "requires operator decision");

    let unpinned = json::read_file(catalogue_path);
    let unpinned_rule = find_rule(unpinned, "RUST-READ-001");
    unpinned_rule["provenance"][0]["revision"] = "";
    unpinned = replace_rule(unpinned, unpinned_rule);
    expect_rejection("unpinned provenance", unpinned, "unpinned provenance");
}

let skill_root = repo_root;
if fs::is_dir(path::join(repo_root, "skills/northstar/references/language-quality/rust")) {
    skill_root = path::join(repo_root, "skills/northstar");
}
let payload_root = path::join(skill_root, "references/language-quality/rust");
let catalogue_path = path::join(payload_root, "catalogue.json");
let catalogue = json::read_file(catalogue_path);
validate_catalogue(catalogue);
require_projection(catalogue, "everyday_authoring", skill_root, "references/language-quality/rust/strict-authoring.json");
require_projection(catalogue, "explicit_audit_repair", skill_root, "references/language-quality/rust/strict-audit.json");
validate_authoring_references(catalogue, skill_root);
validate_authoring_routes(skill_root);
validate_authoring_workflow(skill_root);
validate_activation_surface(repo_root, skill_root);
validate_audit_surface(skill_root);

for filename in [
    "references/language-quality/rust/catalogue.schema.json",
    "references/language-quality/rust/profile.schema.json",
    "references/language-quality/rust/audit-manifest.schema.json",
    "references/language-quality/rust/audit-unit.schema.json",
    "references/language-quality/rust/audit-result.schema.json",
] {
    validate_schema_file(skill_root, filename);
}

for filename in ["catalogue.json", "strict-authoring.json", "strict-audit.json"] {
    let text = fs::read_file(path::join(payload_root, filename));
    require(!text.contains("1.95"), filename + " hardcodes the benchmark MSRV");
    require(!text.contains("answer_key") && !text.contains("expected_findings"), filename + " leaks prototype oracle data");
}

self_test(catalogue_path);
log("Northstar Rust quality package: OK (7 rules, strict-only, 7 negative paths, 7 Rust routes, 6 authoring workflow cases)");
