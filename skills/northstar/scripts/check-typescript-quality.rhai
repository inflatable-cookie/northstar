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

fn validate_provenance(rule_id, provenance) {
    require_array(provenance, rule_id + " provenance");
    require(provenance.len() > 0, rule_id + " requires provenance");
    for source in provenance {
        for key in ["authority", "maturity", "revision", "url", "upstream_rules"] {
            require_key(source, key, rule_id + " provenance");
        }
        require(source["authority"].len() > 0, rule_id + " has empty provenance authority");
        require(source["revision"].len() > 0, rule_id + " has unpinned provenance");
        require(str::starts_with(source["url"], "https://"), rule_id + " has non-HTTPS provenance");
        require_array(source["upstream_rules"], rule_id + " upstream rules");
    }
}

fn validate_rule(rule, expected_id, expected_overlay, expected_enforcement) {
    for key in [
        "id", "title", "category", "overlay", "maturity", "decidability",
        "dimensions", "applicability", "strict_enforcement", "requirement",
        "rationale", "provenance", "audit_procedure", "mechanical_enforcement",
        "remediation", "deviation", "completion_evidence",
    ] {
        require_key(rule, key, expected_id);
    }
    require(!rule.contains("authoring") && !rule.contains("authoring_projection") &&
        !rule.contains("enforcement_by_profile") && !rule.contains("modelled_profiles"),
        expected_id + " exposes an unavailable everyday or profile surface");
    require(rule["id"] == expected_id, "catalogue rule order or inventory drifted at " + expected_id);
    require(rule["overlay"] == expected_overlay, expected_id + " overlay drifted");
    require(rule["strict_enforcement"] == expected_enforcement, expected_id + " strict enforcement drifted");
    require(rule["title"].len() > 0 && rule["requirement"].len() > 0 &&
        rule["rationale"].len() > 0, expected_id + " has empty normative content");
    require_array(rule["dimensions"], expected_id + " dimensions");
    require(rule["dimensions"].len() > 0, expected_id + " requires dimensions");
    require_array(rule["audit_procedure"], expected_id + " audit procedure");
    require(rule["audit_procedure"].len() > 0, expected_id + " requires an audit procedure");
    require_array(rule["mechanical_enforcement"], expected_id + " mechanical enforcement");
    require_array(rule["completion_evidence"], expected_id + " completion evidence");
    require(rule["completion_evidence"].len() > 0, expected_id + " requires completion evidence");
    validate_provenance(expected_id, rule["provenance"]);

    let remediation = rule["remediation"];
    for key in ["default_authority", "action_overrides", "guidance"] {
        require_key(remediation, key, expected_id + " remediation");
    }
    require(remediation["default_authority"] == "review_required" ||
        remediation["default_authority"] == "report_only" ||
        remediation["default_authority"] == "operator_decision",
        expected_id + " has invalid remediation authority");
    require_array(remediation["action_overrides"], expected_id + " action overrides");
    for action_override in remediation["action_overrides"] {
        for key in ["action", "authority", "reason"] {
            require_key(action_override, key, expected_id + " action override");
        }
        require(action_override["authority"] == "review_required" ||
            action_override["authority"] == "report_only" ||
            action_override["authority"] == "operator_decision",
            expected_id + " has invalid action authority");
    }
}

fn validate_catalogue(catalogue) {
    for key in ["schema_version", "language", "workflow", "production_profiles", "supported_overlays", "rules"] {
        require_key(catalogue, key, "catalogue");
    }
    require(!catalogue.contains("modelled_profiles") && !catalogue.contains("authoring"),
        "catalogue exposes an unavailable everyday surface");
    require(catalogue["schema_version"] == "1.0.0", "unsupported catalogue schema version");
    require(catalogue["language"] == "typescript", "catalogue language must be typescript");
    require(catalogue["workflow"] == "explicit_audit_repair", "catalogue must remain explicit-audit-only");
    require(catalogue["production_profiles"] == ["strict"], "strict must be the only production profile");
    require(catalogue["supported_overlays"] == ["base", "svelte", "sveltekit"], "supported overlays drifted");
    require_array(catalogue["rules"], "catalogue rules");
    require(catalogue["rules"].len() == 10, "catalogue must contain exactly ten rules");

    let expected_ids = [
        "TS-READ-001", "TS-EVIDENCE-001", "TS-BOUNDARY-001", "TS-ASYNC-001",
        "TS-ERR-001", "TS-ARCH-001", "SVELTE-REACT-001", "SVELTE-A11Y-001",
        "SVELTE-SSR-001", "TS-SLOP-001",
    ];
    let expected_overlays = [
        "base", "base", "base", "base", "base", "base", "svelte", "svelte",
        "sveltekit", "base",
    ];
    let expected_enforcement = [
        "required", "mandatory", "mandatory", "mandatory", "required", "required",
        "required", "mandatory", "mandatory", "evaluation_only",
    ];
    for index in 0..expected_ids.len() {
        validate_rule(
            catalogue["rules"][index],
            expected_ids[index],
            expected_overlays[index],
            expected_enforcement[index],
        );
    }

    for deferred_id in ["TS-TOOLCHAIN-001", "TS-TEST-001", "SVELTE-TEST-001"] {
        for rule in catalogue["rules"] {
            require(rule["id"] != deferred_id, "deferred rule entered production: " + deferred_id);
        }
    }

    let normative = 0;
    for rule in catalogue["rules"] {
        if rule["strict_enforcement"] != "evaluation_only" {
            normative += 1;
            require(rule["maturity"] == "approved", "normative rule is not approved: " + rule["id"]);
            require(rule["remediation"]["default_authority"] == "review_required",
                "normative repair must remain review-required: " + rule["id"]);
        }
    }
    require(normative == 9, "catalogue must contain exactly nine normative rules");

    let slop = find_rule(catalogue, "TS-SLOP-001");
    require(slop["maturity"] == "experimental", "slop signal must remain experimental");
    require(slop["strict_enforcement"] == "evaluation_only", "slop signal must remain evaluation-only");
    require(slop["remediation"]["default_authority"] == "report_only", "slop signal must remain report-only");
    require(slop["audit_procedure"].len() >= 4 &&
        slop["audit_procedure"][2].contains("independently under a named normative rule") &&
        slop["audit_procedure"][3].contains("Never fail the audit"),
        "slop signal lacks independent-rule and non-failing boundaries");

    let error_rule = find_rule(catalogue, "TS-ERR-001");
    require(error_rule["remediation"]["action_overrides"].len() == 1 &&
        error_rule["remediation"]["action_overrides"][0]["action"] == "change_error_contract" &&
        error_rule["remediation"]["action_overrides"][0]["authority"] == "operator_decision",
        "public error-contract mutation must require operator decision");
    let architecture_rule = find_rule(catalogue, "TS-ARCH-001");
    require(architecture_rule["remediation"]["action_overrides"].len() == 1 &&
        architecture_rule["remediation"]["action_overrides"][0]["authority"] == "operator_decision",
        "public package-contract mutation must require operator decision");
    let ssr_rule = find_rule(catalogue, "SVELTE-SSR-001");
    require(ssr_rule["remediation"]["action_overrides"].len() == 1 &&
        ssr_rule["remediation"]["action_overrides"][0]["authority"] == "operator_decision",
        "request or serialization contract mutation must require operator decision");
}

fn project_rule(rule) {
    let projected = #{};
    for key in [
        "id", "title", "overlay", "maturity", "dimensions", "applicability",
        "requirement", "rationale", "audit_procedure", "mechanical_enforcement",
        "remediation", "deviation", "completion_evidence",
    ] {
        projected[key] = rule[key];
    }
    projected["enforcement"] = rule["strict_enforcement"];
    projected
}

fn project_catalogue(catalogue) {
    let rules = [];
    for rule in catalogue["rules"] {
        rules.push(project_rule(rule));
    }
    let projection = #{};
    projection["schema_version"] = catalogue["schema_version"];
    projection["language"] = catalogue["language"];
    projection["workflow"] = catalogue["workflow"];
    projection["profile"] = "strict";
    projection["catalogue_schema_version"] = catalogue["schema_version"];
    projection["supported_overlays"] = catalogue["supported_overlays"];
    projection["rules"] = rules;
    projection
}

fn validate_projection(catalogue, payload_root) {
    let projection = json::read_file(path::join(payload_root, "strict-audit.json"));
    require(projection == project_catalogue(catalogue), "strict audit projection drifted from catalogue");
    require(!projection.contains("authoring") && !projection.contains("authoring_projection"),
        "strict audit projection exposes unavailable everyday guidance");
}

fn validate_schema(payload_root, filename) {
    let schema = json::read_file(path::join(payload_root, filename));
    require(schema["$schema"] == "https://json-schema.org/draft/2020-12/schema", filename + " uses wrong JSON Schema dialect");
    require(schema["$id"].contains("typescript-quality"), filename + " has wrong schema identity");
    require(schema["type"] == "object", filename + " root must be an object");
    require_array(schema["required"], filename + " required fields");
    require(schema["required"].len() > 0, filename + " requires no fields");
}

fn validate_profile(profile, context) {
    for key in [
        "schema_version", "language", "workflow", "profile", "packages",
        "unregistered_candidates", "evidence_selectors", "exclusions",
        "deviations_file", "when_unresolved",
    ] {
        require_key(profile, key, context);
    }
    require(profile["schema_version"] == "1.0.0", context + " uses unsupported schema");
    require(profile["language"] == "typescript", context + " language must be typescript");
    require(profile["workflow"] == "explicit_audit_repair", context + " workflow must remain explicit-audit-only");
    require(profile["profile"] == "strict", context + " must activate strict");
    require_array(profile["packages"], context + " packages");
    require_array(profile["unregistered_candidates"], context + " unregistered candidates");
    for evidence_class in ["compiler", "framework", "lint", "test"] {
        require_key(profile["evidence_selectors"], evidence_class, context + " evidence selectors");
        require_array(profile["evidence_selectors"][evidence_class], context + " " + evidence_class + " selectors");
    }
    for exclusion_class in ["generated", "vendored", "fixtures", "documentation", "build_output"] {
        require_key(profile["exclusions"], exclusion_class, context + " exclusions");
        require_array(profile["exclusions"][exclusion_class], context + " " + exclusion_class + " exclusions");
    }
    require(profile["deviations_file"] == "docs/contracts/typescript-quality-deviations.json",
        context + " deviations path drifted");
    require(profile["when_unresolved"] == "stop", context + " must stop when ownership or overlay is unresolved");
}

fn validate_templates(northstar_skill_root) {
    let template_root = path::join(northstar_skill_root, "assets/templates/language-quality/typescript");
    let profile = json::read_file(path::join(template_root, "typescript-quality-profile.json"));
    let deviations = json::read_file(path::join(template_root, "typescript-quality-deviations.json"));
    validate_profile(profile, "TypeScript profile template");
    require(deviations["schema_version"] == "1.0.0", "TypeScript deviations use unsupported schema");
    require(deviations["language"] == "typescript", "TypeScript deviations language drifted");
    require_array(deviations["deviations"], "TypeScript deviations");
}

fn validate_runtime_surface(northstar_skill_root) {
    let router = fs::read_file(path::join(northstar_skill_root, "references/router.md"));
    let mode_path = path::join(northstar_skill_root, "references/modes/typescript-quality-audit.md");
    let recording_path = path::join(northstar_skill_root, "references/language-quality/typescript/audit-recording.md");
    let setup_path = path::join(northstar_skill_root, "scripts/typescript-quality-setup.rhai");
    let recorder_path = path::join(northstar_skill_root, "scripts/typescript-quality-recorder.rhai");
    let adapter_path = path::join(northstar_skill_root, "commands/northstar-typescript-audit/SKILL.md");
    let policy_path = path::join(northstar_skill_root, "commands/northstar-typescript-audit/agents/openai.yaml");
    let mode = fs::read_file(mode_path);
    let recording = fs::read_file(recording_path);
    let setup = fs::read_file(setup_path);
    let recorder = fs::read_file(recorder_path);
    let adapter = fs::read_file(adapter_path);
    let policy = fs::read_file(policy_path);
    let catalog = fs::read_file(path::join(northstar_skill_root, "effigy.toml"));
    require(router.contains("TypeScript/Svelte explicit audit-and-repair (explicit only)"),
        "router lacks explicit TypeScript/Svelte audit route");
    require(router.contains("never") && router.contains("activates from ordinary TypeScript or Svelte coding"),
        "router permits implicit TypeScript/Svelte audit");
    require(mode.contains("Do not load or invent an") && mode.contains("everyday authoring projection"),
        "TypeScript audit mode permits unavailable everyday guidance");
    require(mode.contains("`extend` before editing") && mode.contains("dirty-state loss"),
        "TypeScript audit mode lacks mutation and preservation boundaries");
    require(recording.contains("compiler|framework|lint|test") && recording.contains("failure_stage"),
        "recording contract lacks typed tool evidence");
    require(adapter.contains("Thin explicit entrypoint") && !adapter.contains("## Procedure"),
        "TypeScript audit adapter is not thin");
    require(policy.contains("allow_implicit_invocation: false"),
        "TypeScript audit adapter allows implicit invocation");
    require(catalog.contains("check:typescript-quality") && catalog.contains("typescript-quality:setup") &&
        catalog.contains("typescript-quality:record") && catalog.contains("test:typescript-quality-setup") &&
        catalog.contains("test:typescript-quality-recorder"), "skill-local TypeScript selectors are incomplete");
    require(!setup.contains("process::") && !setup.contains("command::"),
        "TypeScript setup can launch a subprocess");
    require(!recorder.contains("process::") && !recorder.contains("command::"),
        "TypeScript recorder can launch a subprocess");
    require(fs::file_size(mode_path) <= 12288, "TypeScript audit mode exceeds context budget");
    require(fs::file_size(recording_path) <= 12288, "TypeScript recording contract exceeds context budget");
    require(fs::file_size(adapter_path) <= 1200, "TypeScript adapter exceeds thin-adapter budget");
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
    let everyday = json::read_file(catalogue_path);
    everyday["rules"][0]["authoring_projection"] = ["write code"];
    expect_rejection("everyday surface", everyday, "unavailable everyday");

    let deferred = json::read_file(catalogue_path);
    deferred["rules"][0]["id"] = "TS-TOOLCHAIN-001";
    expect_rejection("deferred rule", deferred, "inventory drifted");

    let slop_enforced = json::read_file(catalogue_path);
    let slop_rule = find_rule(slop_enforced, "TS-SLOP-001");
    slop_rule["strict_enforcement"] = "required";
    slop_enforced = replace_rule(slop_enforced, slop_rule);
    expect_rejection("slop enforcement", slop_enforced, "strict enforcement drifted");

    let slop_repair = json::read_file(catalogue_path);
    let repair_rule = find_rule(slop_repair, "TS-SLOP-001");
    repair_rule["remediation"]["default_authority"] = "review_required";
    slop_repair = replace_rule(slop_repair, repair_rule);
    expect_rejection("slop authority", slop_repair, "report-only");

    let overlay = json::read_file(catalogue_path);
    let overlay_rule = find_rule(overlay, "SVELTE-SSR-001");
    overlay_rule["overlay"] = "svelte";
    overlay = replace_rule(overlay, overlay_rule);
    expect_rejection("overlay drift", overlay, "overlay drifted");

    let unpinned = json::read_file(catalogue_path);
    let source_rule = find_rule(unpinned, "TS-BOUNDARY-001");
    source_rule["provenance"][0]["revision"] = "";
    unpinned = replace_rule(unpinned, source_rule);
    expect_rejection("unpinned provenance", unpinned, "unpinned provenance");

    let broadened = json::read_file(catalogue_path);
    let architecture_rule = find_rule(broadened, "TS-ARCH-001");
    architecture_rule["remediation"]["action_overrides"][0]["authority"] = "review_required";
    broadened = replace_rule(broadened, architecture_rule);
    expect_rejection("architecture authority", broadened, "operator decision");
}

let northstar_skill_root = repo_root;
if fs::is_dir(path::join(repo_root, "skills/northstar/references/language-quality/typescript")) {
    northstar_skill_root = path::join(repo_root, "skills/northstar");
}
let payload_root = path::join(northstar_skill_root, "references/language-quality/typescript");
let catalogue_path = path::join(payload_root, "catalogue.json");
let catalogue = json::read_file(catalogue_path);
validate_catalogue(catalogue);
validate_projection(catalogue, payload_root);
validate_schema(payload_root, "catalogue.schema.json");
validate_schema(payload_root, "profile.schema.json");
validate_templates(northstar_skill_root);
validate_runtime_surface(northstar_skill_root);
self_test(catalogue_path);
for filename in ["audit-manifest.schema.json", "audit-unit.schema.json", "audit-result.schema.json"] {
    validate_schema(payload_root, filename);
}
log("Northstar TypeScript quality package: OK (9 normative rules, 1 evaluation signal, 3 overlays, 7 catalogue negative paths, explicit audit only)");
