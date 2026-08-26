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

fn require_text(value, context) {
    require(type_of(value) == "string" && value.len() > 0, context + " must be non-empty text");
}

fn require_relative_file(file, context) {
    require(type_of(file) == "string" && file.len() > 0, context + " must be non-empty text");
    require(!str::starts_with(file, "/"), context + " must be relative: " + file);
    require(file != ".." && !str::starts_with(file, "../") &&
        !file.contains("/../") && !str::ends_with(file, "/.."),
        context + " escapes target root: " + file);
    require(!file.contains("//") && !str::ends_with(file, "/"), context + " is not a file path: " + file);
    require(file != ".effigy" && !str::starts_with(file, ".effigy/"), context + " cannot own audit records: " + file);
}

fn fingerprint(full_path) {
    if fs::is_file(full_path) {
        return fs::sha256(full_path);
    }
    require(!fs::exists(full_path), "audited path is not a regular file: " + full_path);
    "missing"
}

fn sorted_copy(values) {
    let result = [];
    for value in values {
        result.push(value);
    }
    result.sort();
    result
}

fn push_unique(values, value, context) {
    require(!values.contains(value), context + ": " + value);
    values.push(value);
    values
}

fn require_same_set(left, right, message) {
    require(sorted_copy(left) == sorted_copy(right), message);
}

fn audit_root(target_root, audit_id) {
    path::join(target_root, ".effigy/rust-quality/audits/" + audit_id)
}

fn find_rule(catalogue, rule_id) {
    for rule in catalogue["rules"] {
        if rule["id"] == rule_id {
            return rule;
        }
    }
    throw("unknown rule: " + rule_id);
}

fn find_unit(manifest, unit_id) {
    for unit in manifest["units"] {
        if unit["unit_id"] == unit_id {
            return unit;
        }
    }
    throw("unknown assessed unit: " + unit_id);
}

fn effective_authority(rule, action) {
    for action_override in rule["remediation"]["action_overrides"] {
        if action_override["action"] == action {
            return action_override["authority_by_profile"]["strict"];
        }
    }
    rule["remediation"]["default_authority_by_profile"]["strict"]
}

fn matching_finding(findings, rule_id, action) {
    for finding in findings {
        if finding["rule_id"] == rule_id && finding["action"] == action {
            return finding;
        }
    }
    throw("repair plan has no matching local finding: " + rule_id + "/" + action);
}

fn matching_plan_exists(plans, rule_id, action) {
    for plan in plans {
        if plan["rule_id"] == rule_id && plan["action"] == action {
            return true;
        }
    }
    false
}

fn find_plan(plans, rule_id, action) {
    for plan in plans {
        if plan["rule_id"] == rule_id && plan["action"] == action {
            return plan;
        }
    }
    throw("missing pre-mutation repair plan: " + rule_id + "/" + action);
}

fn deviation_covers(deviations, rule_id, file) {
    for deviation in deviations {
        if deviation["rule_id"] == rule_id && deviation["scope"].contains(file) {
            return true;
        }
    }
    false
}

fn validate_deviation(deviation) {
    for key in ["rule_id", "scope", "reason", "evidence", "accepted_by", "recheck"] {
        require_key(deviation, key, "deviation");
    }
    require_array(deviation["scope"], "deviation scope");
    require(deviation["scope"].len() > 0, "deviation scope is empty");
    for file in deviation["scope"] {
        require_relative_file(file, "deviation scope");
    }
    require_array(deviation["evidence"], "deviation evidence");
    require(deviation["evidence"].len() > 0, "deviation evidence is empty");
    require_text(deviation["reason"], "deviation reason");
    require_text(deviation["accepted_by"], "deviation accepting owner");
    require_text(deviation["recheck"], "deviation recheck trigger");
}

fn load_policy_snapshot(target_root) {
    let profile_file = "docs/contracts/rust-quality-profile.json";
    let profile_path = path::join(target_root, profile_file);
    require(fs::is_file(profile_path), "missing Rust quality profile: " + profile_file);
    let profile = json::read_file(profile_path);
    require(profile["schema_version"] == "1.0.0" && profile["language"] == "rust",
        "unsupported Rust quality profile schema");
    require(profile["profile"] == "strict", "unsupported production profile: " + profile["profile"]);
    require(profile["msrv"]["source"] == "repository_policy", "MSRV must derive from repository policy");
    require(profile["msrv"]["when_unresolved"] == "stop", "unresolved MSRV policy must stop");

    let deviations_file = profile["deviations_file"];
    require_relative_file(deviations_file, "deviations file");
    let deviations_path = path::join(target_root, deviations_file);
    require(fs::is_file(deviations_path), "missing Rust quality deviations: " + deviations_file);
    let deviation_document = json::read_file(deviations_path);
    require(deviation_document["schema_version"] == "1.0.0" && deviation_document["language"] == "rust",
        "unsupported Rust deviations schema");
    require_array(deviation_document["deviations"], "Rust deviations");
    for deviation in deviation_document["deviations"] {
        validate_deviation(deviation);
    }

    #{
        profile_file: profile_file,
        profile_sha256: fs::sha256(profile_path),
        deviations_file: deviations_file,
        deviations_sha256: fs::sha256(deviations_path),
        deviations: deviation_document["deviations"],
    }
}

fn normalize_dirty_item(target_root, item) {
    require_key(item, "file", "dirty file");
    require_key(item, "states", "dirty file");
    let file = item["file"];
    require_relative_file(file, "dirty file");
    require_array(item["states"], "dirty file states");
    require(item["states"].len() > 0, "dirty file has no Git state: " + file);
    let states = [];
    for state_name in item["states"] {
        require(state_name == "staged" || state_name == "unstaged" || state_name == "untracked",
            "unsupported dirty state for " + file + ": " + state_name);
        states = push_unique(states, state_name, "duplicate dirty state for " + file);
    }
    #{
        file: file,
        states: states,
        baseline_fingerprint: fingerprint(path::join(target_root, file)),
    }
}

fn normalize_dirty_files(target_root, inputs) {
    let dirty_files = [];
    let dirty_paths = [];
    for input in inputs {
        let item = normalize_dirty_item(target_root, input);
        let file = item["file"];
        dirty_paths = push_unique(dirty_paths, file, "duplicate dirty file");
        dirty_files.push(item);
    }
    #{ items: dirty_files, paths: dirty_paths }
}

fn normalize_excluded_files(inputs, dirty_paths, in_scope_files) {
    let excluded = [];
    let excluded_paths = [];
    for item in inputs {
        require_key(item, "file", "excluded dirty file");
        require_key(item, "reason", "excluded dirty file");
        let file = item["file"];
        require_relative_file(file, "excluded dirty file");
        require_text(item["reason"], "excluded dirty-file reason");
        require(dirty_paths.contains(file), "excluded file was not in dirty snapshot: " + file);
        require(!in_scope_files.contains(file), "dirty file cannot be both in-scope and excluded: " + file);
        excluded_paths = push_unique(excluded_paths, file, "duplicate excluded dirty file");
        excluded.push(#{ file: file, reason: item["reason"] });
    }
    #{ items: excluded, paths: excluded_paths }
}

fn normalize_dirty_state(target_root, state, owned_files) {
    for key in ["dirty_files", "in_scope_files", "excluded_dirty_files", "scope_evidence"] {
        require_key(state, key, "initial state");
        require_array(state[key], "initial state " + key);
    }
    require(state["in_scope_files"].len() > 0, "audit scope is empty");
    require(state["scope_evidence"].len() > 0, "scope resolution evidence is empty");
    require_same_set(state["in_scope_files"], owned_files, "assessed units do not exactly own initial scope");
    let dirty = normalize_dirty_files(target_root, state["dirty_files"]);
    let excluded = normalize_excluded_files(state["excluded_dirty_files"], dirty["paths"], state["in_scope_files"]);
    for file in dirty["paths"] {
        require(state["in_scope_files"].contains(file) || excluded["paths"].contains(file),
            "dirty file lacks scope disposition: " + file);
    }
    for evidence in state["scope_evidence"] {
        require_text(evidence, "scope evidence");
    }
    #{
        dirty_files: dirty["items"],
        in_scope_files: state["in_scope_files"],
        excluded_dirty_files: excluded["items"],
        scope_evidence: state["scope_evidence"],
    }
}

fn normalize_units(target_root, input_units) {
    require_array(input_units, "manifest units");
    require(input_units.len() > 0, "manifest requires at least one assessed unit");
    let units = [];
    let unit_ids = [];
    let all_owned = [];
    for input_unit in input_units {
        for key in ["unit_id", "primary_file", "owned_files"] {
            require_key(input_unit, key, "manifest unit");
        }
        let unit_id = input_unit["unit_id"];
        require(regex::is_match("^[a-z0-9][a-z0-9-]*$", unit_id), "invalid unit id: " + unit_id);
        unit_ids = push_unique(unit_ids, unit_id, "duplicate unit id");
        require_array(input_unit["owned_files"], unit_id + " owned files");
        require(input_unit["owned_files"].len() > 0, unit_id + " owns no files");
        let baseline = #{};
        let local_owned = [];
        for file in input_unit["owned_files"] {
            require_relative_file(file, unit_id + " owned file");
            local_owned = push_unique(local_owned, file, "duplicate file inside unit " + unit_id);
            all_owned = push_unique(all_owned, file, "file owned by more than one unit");
            baseline[file] = fingerprint(path::join(target_root, file));
        }
        require_relative_file(input_unit["primary_file"], unit_id + " primary file");
        require(local_owned.contains(input_unit["primary_file"]), unit_id + " primary file is not owned");
        units.push(#{
            unit_id: unit_id,
            primary_file: input_unit["primary_file"],
            owned_files: local_owned,
            baseline_sha256: baseline,
        });
    }
    #{ units: units, owned_files: all_owned }
}

fn init_audit(target_root, manifest_input, catalogue_path) {
    require(fs::is_dir(target_root), "target root is not a directory: " + target_root);
    for key in ["audit_id", "profile", "scope", "initial_state", "units"] {
        require_key(manifest_input, key, "manifest input");
    }
    let audit_id = manifest_input["audit_id"];
    require(regex::is_match("^[a-z0-9][a-z0-9-]*$", audit_id), "invalid audit id: " + audit_id);
    require(manifest_input["profile"] == "strict", "unsupported production profile: " + manifest_input["profile"]);
    require(manifest_input["scope"] == "worktree" || manifest_input["scope"] == "repository", "unsupported audit scope");
    let root = audit_root(target_root, audit_id);
    require(!fs::exists(root), "audit already exists: " + audit_id);

    let normalized = normalize_units(target_root, manifest_input["units"]);
    let initial_state = normalize_dirty_state(target_root, manifest_input["initial_state"], normalized["owned_files"]);
    let policy = load_policy_snapshot(target_root);
    fs::create_dir(path::join(root, "units"));
    json::write_file(path::join(root, "manifest.json"), #{
        schema_version: "1.0.0",
        audit_id: audit_id,
        workflow: "explicit_audit_repair",
        profile: "strict",
        scope: manifest_input["scope"],
        target_root: target_root,
        catalogue_sha256: fs::sha256(catalogue_path),
        initial_state: initial_state,
        policy_snapshot: policy,
        units: normalized["units"],
    });
    root
}

fn require_unchanged(target_root, files, baseline, context) {
    for file in files {
        require(fingerprint(path::join(target_root, file)) == baseline[file], context + ": " + file);
    }
}

fn normalize_location(location, owned_files) {
    require_key(location, "file", "finding location");
    let file = location["file"];
    require_relative_file(file, "finding location");
    require(owned_files.contains(file), "cross-unit finding location: " + file);
    require(location.contains("symbol") || location.contains("line_span"), "finding requires exact symbol or line span");
    if location.contains("symbol") {
        require_text(location["symbol"], "finding symbol");
    }
    if location.contains("line_span") {
        require_array(location["line_span"], "finding line span");
        require(location["line_span"].len() == 2 && location["line_span"][0] >= 1 &&
            location["line_span"][1] >= location["line_span"][0], "invalid finding line span");
    }
    location
}

fn normalize_finding(input, owned_files, catalogue, deviations) {
    for key in ["rule_id", "confidence", "action", "location", "evidence", "disposition"] {
        require_key(input, key, "finding");
    }
    require(input["confidence"] == "high" || input["confidence"] == "medium" || input["confidence"] == "low",
        "unsupported finding confidence");
    require(regex::is_match("^[a-z][a-z0-9_]*$", input["action"]), "invalid finding action: " + input["action"]);
    require_text(input["evidence"], "finding evidence");
    let location = normalize_location(input["location"], owned_files);
    let rule = find_rule(catalogue, input["rule_id"]);
    let enforcement = rule["enforcement_by_profile"]["strict"];
    let authority = effective_authority(rule, input["action"]);
    let disposition = input["disposition"];
    if enforcement == "evaluation_only" || authority == "report_only" {
        require(disposition == "reported", "report-only finding must use reported disposition: " + input["rule_id"]);
    } else if authority == "operator_decision" {
        require(disposition == "operator_decision", "operator-owned finding must stop before mutation: " + input["rule_id"]);
    } else {
        require(disposition == "repair_planned" || disposition == "deviation",
            "review-required finding needs repair or accepted deviation: " + input["rule_id"]);
    }
    if disposition == "deviation" {
        require(deviation_covers(deviations, input["rule_id"], location["file"]),
            "finding has no accepted matching deviation: " + input["rule_id"] + "/" + location["file"]);
    }
    #{
        rule_id: input["rule_id"],
        maturity: rule["maturity"],
        enforcement: enforcement,
        confidence: input["confidence"],
        action: input["action"],
        authority: authority,
        location: location,
        evidence: input["evidence"],
        disposition: disposition,
    }
}

fn normalize_plan(input, findings, owned_files, catalogue) {
    for key in ["rule_id", "action", "owned_files", "preserved_behavior"] {
        require_key(input, key, "repair plan");
    }
    let finding = matching_finding(findings, input["rule_id"], input["action"]);
    require(finding["disposition"] == "repair_planned", "repair plan finding is not repairable");
    let rule = find_rule(catalogue, input["rule_id"]);
    let authority = effective_authority(rule, input["action"]);
    require(authority == "review_required", "repair plan lacks local authority: " + input["rule_id"] + "/" + input["action"] + " -> " + authority);
    require(rule["maturity"] == "approved" && rule["enforcement_by_profile"]["strict"] != "evaluation_only",
        "non-normative rule cannot authorize repair: " + input["rule_id"]);
    require_array(input["owned_files"], "repair-plan owned files");
    require(input["owned_files"].len() > 0, "repair plan owns no files");
    let plan_files = [];
    for file in input["owned_files"] {
        require(owned_files.contains(file), "repair plan crosses assessed-unit ownership: " + file);
        plan_files = push_unique(plan_files, file, "duplicate repair-plan file");
    }
    require_array(input["preserved_behavior"], "preserved behavior");
    require(input["preserved_behavior"].len() > 0, "repair plan has no protected behavior");
    for item in input["preserved_behavior"] {
        require_text(item, "preserved behavior");
    }
    #{
        rule_id: input["rule_id"],
        action: input["action"],
        authority: authority,
        owned_files: plan_files,
        preserved_behavior: input["preserved_behavior"],
    }
}

fn normalize_findings(inputs, owned_files, catalogue, deviations) {
    require_array(inputs, "unit findings");
    let findings = [];
    for input in inputs {
        findings.push(normalize_finding(input, owned_files, catalogue, deviations));
    }
    findings
}

fn normalize_plans(inputs, findings, owned_files, catalogue) {
    require_array(inputs, "unit repair plans");
    let plans = [];
    let keys = [];
    for input in inputs {
        let key = input["rule_id"] + "/" + input["action"];
        keys = push_unique(keys, key, "duplicate repair plan");
        plans.push(normalize_plan(input, findings, owned_files, catalogue));
    }
    plans
}

fn require_plans_for_findings(findings, plans) {
    for finding in findings {
        if finding["disposition"] == "repair_planned" {
            let rule_id = finding["rule_id"];
            let action = finding["action"];
            let exists = matching_plan_exists(plans, rule_id, action);
            require(exists, "repairable finding lacks pre-mutation plan: " + rule_id);
        }
    }
}

fn record_path(root, unit_id) {
    path::join(path::join(root, "units"), unit_id + ".json")
}

fn assess_unit(target_root, audit_id, input, catalogue) {
    let root = audit_root(target_root, audit_id);
    let manifest = json::read_file(path::join(root, "manifest.json"));
    require(manifest["target_root"] == target_root && manifest["audit_id"] == audit_id, "audit identity mismatch");
    for key in ["unit_id", "findings", "repair_plans"] {
        require_key(input, key, "assessment input");
    }
    let unit = find_unit(manifest, input["unit_id"]);
    require_unchanged(target_root, unit["owned_files"], unit["baseline_sha256"], "unit changed before assessment");
    let destination = record_path(root, unit["unit_id"]);
    require(!fs::exists(destination), "unit already assessed: " + unit["unit_id"]);
    require_array(input["findings"], "unit findings");
    let findings = [];
    for finding_input in input["findings"] {
        findings.push(normalize_finding(finding_input, unit["owned_files"], catalogue,
            manifest["policy_snapshot"]["deviations"]));
    }
    let plans = normalize_plans(input["repair_plans"], findings, unit["owned_files"], catalogue);
    require_plans_for_findings(findings, plans);
    json::write_file(destination, #{
        schema_version: "1.0.0",
        audit_id: audit_id,
        unit_id: unit["unit_id"],
        phase: "assessed",
        owned_files: unit["owned_files"],
        baseline_sha256: unit["baseline_sha256"],
        findings: findings,
        repair_plans: plans,
        repairs: [],
        validation: [],
        scope_extensions: [],
    });
}

fn file_owned_by_other_unit(manifest, unit_id, file) {
    for unit in manifest["units"] {
        if unit["unit_id"] != unit_id && unit["owned_files"].contains(file) {
            return true;
        }
    }
    false
}

fn extend_plan_files(plan, files, extension_files) {
    for file in files {
        require(extension_files.contains(file), "repair-plan extension names file outside scope extension: " + file);
        require(!plan["owned_files"].contains(file), "repair plan already owns extension file: " + file);
        plan["owned_files"].push(file);
    }
    plan
}

fn find_plan_index(plans, rule_id, action) {
    for index in 0..plans.len() {
        if plans[index]["rule_id"] == rule_id && plans[index]["action"] == action {
            return index;
        }
    }
    -1
}

fn extend_existing_plans(record, inputs, extension_files) {
    require_array(inputs, "repair-plan extensions");
    let keys = [];
    for input in inputs {
        for key in ["rule_id", "action", "files"] {
            require_key(input, key, "repair-plan extension");
        }
        let plan_key = input["rule_id"] + "/" + input["action"];
        keys = push_unique(keys, plan_key, "duplicate repair-plan extension");
        require_array(input["files"], "repair-plan extension files");
        require(input["files"].len() > 0, "repair-plan extension has no files");
        let index = find_plan_index(record["repair_plans"], input["rule_id"], input["action"]);
        require(index >= 0, "repair-plan extension has no existing plan: " + plan_key);
        let plan = record["repair_plans"][index];
        let files = input["files"];
        record["repair_plans"][index] = extend_plan_files(plan, files, extension_files);
    }
    record
}

fn extend_unit(target_root, audit_id, input, catalogue) {
    let root = audit_root(target_root, audit_id);
    let manifest_path = path::join(root, "manifest.json");
    let manifest = json::read_file(manifest_path);
    for key in ["unit_id", "files", "reason", "findings", "repair_plans", "plan_extensions"] {
        require_key(input, key, "scope extension");
    }
    require_array(input["files"], "scope-extension files");
    require(input["files"].len() > 0, "scope extension has no files");
    require_text(input["reason"], "scope-extension reason");
    let unit = find_unit(manifest, input["unit_id"]);
    let destination = record_path(root, unit["unit_id"]);
    require(fs::is_file(destination), "unit must be assessed before scope extension");
    let record = json::read_file(destination);
    require(record["phase"] == "assessed", "scope extension must precede completion");
    require_unchanged(target_root, record["owned_files"], record["baseline_sha256"], "scope extension follows mutation");

    let extension_files = [];
    for file in input["files"] {
        require_relative_file(file, "scope-extension file");
        require(!record["owned_files"].contains(file), "scope-extension file already owned: " + file);
        require(!file_owned_by_other_unit(manifest, unit["unit_id"], file), "scope extension crosses unit ownership: " + file);
        require(fs::is_file(path::join(target_root, file)), "scope-extension file is missing: " + file);
        extension_files = push_unique(extension_files, file, "duplicate scope-extension file");
        record["owned_files"].push(file);
        record["baseline_sha256"][file] = fingerprint(path::join(target_root, file));
    }
    record = extend_existing_plans(record, input["plan_extensions"], extension_files);

    let added_findings = normalize_findings(input["findings"], record["owned_files"], catalogue,
        manifest["policy_snapshot"]["deviations"]);
    for finding in added_findings {
        record["findings"].push(finding);
    }
    let added_plans = normalize_plans(input["repair_plans"], record["findings"], record["owned_files"], catalogue);
    for plan in added_plans {
        let rule_id = plan["rule_id"];
        let action = plan["action"];
        let duplicate = matching_plan_exists(record["repair_plans"], rule_id, action);
        require(!duplicate, "scope extension duplicates repair plan: " + rule_id + "/" + action);
        record["repair_plans"].push(plan);
    }
    require_plans_for_findings(record["findings"], record["repair_plans"]);
    record["scope_extensions"].push(#{
        files: extension_files,
        reason: input["reason"],
        recorded_before_mutation: true,
    });
    json::write_file(destination, record);

    for index in 0..manifest["units"].len() {
        if manifest["units"][index]["unit_id"] == unit["unit_id"] {
            manifest["units"][index]["owned_files"] = record["owned_files"];
            manifest["units"][index]["baseline_sha256"] = record["baseline_sha256"];
        }
    }
    json::write_file(manifest_path, manifest);
}

fn normalize_validation(inputs) {
    require_array(inputs, "completion validation");
    let normalized = [];
    for item in inputs {
        for key in ["selector", "status", "evidence"] {
            require_key(item, key, "validation item");
        }
        require_text(item["selector"], "validation selector");
        require(item["status"] == "passed" || item["status"] == "failed" || item["status"] == "blocked",
            "unsupported validation status");
        require_text(item["evidence"], "validation evidence");
        normalized.push(item);
    }
    normalized
}

fn changed_files(target_root, owned_files, baseline) {
    let changed = [];
    for file in owned_files {
        if fingerprint(path::join(target_root, file)) != baseline[file] {
            changed.push(file);
        }
    }
    changed
}

fn normalize_repair_completion(input, record, catalogue) {
    for key in ["rule_id", "action", "status", "changed_files"] {
        require_key(input, key, "repair");
    }
    let rule_id = input["rule_id"];
    let action = input["action"];
    let repair_key = rule_id + "/" + action;
    let planned = matching_plan_exists(record["repair_plans"], rule_id, action);
    require(planned, "repair has no matching pre-mutation plan: " + repair_key);
    let status = input["status"];
    require(status == "applied" || status == "not_applied", "unsupported repair status");
    require_array(input["changed_files"], "repair changed files");
    let files = [];
    for file in input["changed_files"] {
        require(record["owned_files"].contains(file), "repair attributes file outside unit: " + file);
        files = push_unique(files, file, "duplicate changed file in repair");
    }
    require(status == "applied" || files.len() == 0, "not-applied repair attributes mutation");
    require(status == "not_applied" || files.len() > 0, "applied repair attributes no files");
    let rule = find_rule(catalogue, rule_id);
    let plan = find_plan(record["repair_plans"], rule_id, action);
    for file in files {
        require(plan["owned_files"].contains(file), "repair changed file outside its pre-mutation plan: " + file);
    }
    #{
        key: repair_key,
        record: #{
            rule_id: rule_id,
            action: action,
            authority: effective_authority(rule, action),
            status: status,
            changed_files: files,
        },
    }
}

fn append_unique_values(target, inputs) {
    for value in inputs {
        if !target.contains(value) {
            target.push(value);
        }
    }
    target
}

fn normalize_repair_completions(inputs, record, catalogue) {
    require_array(inputs, "completion repairs");
    let repairs = [];
    let repair_keys = [];
    let attributed_files = [];
    for input in inputs {
        let normalized = normalize_repair_completion(input, record, catalogue);
        let repair = normalized["record"];
        repair_keys = push_unique(repair_keys, normalized["key"], "duplicate repair completion");
        if repair["status"] == "applied" {
            attributed_files = append_unique_values(attributed_files, repair["changed_files"]);
        }
        repairs.push(repair);
    }
    #{ repairs: repairs, keys: repair_keys, files: attributed_files }
}

fn complete_unit(target_root, audit_id, input, catalogue) {
    let root = audit_root(target_root, audit_id);
    let manifest = json::read_file(path::join(root, "manifest.json"));
    for key in ["unit_id", "repairs", "validation"] {
        require_key(input, key, "completion input");
    }
    let destination = record_path(root, input["unit_id"]);
    require(fs::is_file(destination), "unit must be assessed before completion: " + input["unit_id"]);
    let record = json::read_file(destination);
    require(record["phase"] == "assessed", "unit already completed: " + input["unit_id"]);
    let normalized = normalize_repair_completions(input["repairs"], record, catalogue);
    for plan in record["repair_plans"] {
        require(normalized["keys"].contains(plan["rule_id"] + "/" + plan["action"]),
            "repair plan lacks completion disposition: " + plan["rule_id"] + "/" + plan["action"]);
    }
    let actual_changed = changed_files(target_root, record["owned_files"], record["baseline_sha256"]);
    require_same_set(actual_changed, normalized["files"], "hidden or falsely attributed mutation in unit " + input["unit_id"]);
    let validation = normalize_validation(input["validation"]);
    if actual_changed.len() > 0 {
        require(validation.len() > 0, "applied repair requires local validation evidence");
        for item in validation {
            require(item["status"] == "passed", "applied repair has non-passing validation: " + item["selector"]);
        }
    }
    record["phase"] = "completed";
    record["repairs"] = normalized["repairs"];
    record["validation"] = validation;
    json::write_file(destination, record);
}

fn append_unit_evidence(record, findings, repairs, validation) {
    for item in record["findings"] {
        item["unit_id"] = record["unit_id"];
        findings.push(item);
    }
    for item in record["repairs"] {
        item["unit_id"] = record["unit_id"];
        repairs.push(item);
    }
    for item in record["validation"] {
        item["unit_id"] = record["unit_id"];
        validation.push(item);
    }
    #{ findings: findings, repairs: repairs, validation: validation }
}

fn finding_limitation(finding) {
    let rule_id = finding["rule_id"];
    let file = finding["location"]["file"];
    if finding["authority"] == "report_only" || finding["enforcement"] == "evaluation_only" {
        return "report-only finding remains: " + rule_id + " at " + file;
    }
    if finding["disposition"] == "operator_decision" {
        return "operator decision required: " + rule_id + "/" + finding["action"] + " at " + file;
    }
    ""
}

fn repair_limitation(repair, unit_id) {
    if repair["status"] == "not_applied" {
        let repair_name = repair["rule_id"] + "/" + repair["action"];
        return "repair not applied: " + repair_name + " in " + unit_id;
    }
    ""
}

fn validation_limitation(item, unit_id) {
    if item["status"] != "passed" {
        return "validation " + item["status"] + ": " + item["selector"] + " in " + unit_id;
    }
    ""
}

fn append_limitations(record, limitations) {
    for finding in record["findings"] {
        let message = finding_limitation(finding);
        if message != "" {
            limitations.push(message);
        }
    }
    for repair in record["repairs"] {
        let message = repair_limitation(repair, record["unit_id"]);
        if message != "" {
            limitations.push(message);
        }
    }
    for item in record["validation"] {
        let message = validation_limitation(item, record["unit_id"]);
        if message != "" {
            limitations.push(message);
        }
    }
    limitations
}

fn verify_policy_unchanged(target_root, snapshot) {
    require(fs::sha256(path::join(target_root, snapshot["profile_file"])) == snapshot["profile_sha256"],
        "Rust quality profile changed during audit");
    require(fs::sha256(path::join(target_root, snapshot["deviations_file"])) == snapshot["deviations_sha256"],
        "Rust quality deviations changed during audit");
}

fn verify_unrelated_dirty(target_root, initial_state) {
    let excluded = [];
    for item in initial_state["excluded_dirty_files"] {
        excluded.push(item["file"]);
    }
    let preserved = [];
    for item in initial_state["dirty_files"] {
        let file = item["file"];
        if excluded.contains(file) {
            let full_path = path::join(target_root, file);
            let final_value = fingerprint(full_path);
            let initial_value = item["baseline_fingerprint"];
            require(final_value == initial_value, "unrelated dirty file changed during audit: " + file);
            preserved.push(#{
                file: file,
                initial_fingerprint: initial_value,
                final_fingerprint: final_value,
            });
        }
    }
    preserved
}

fn attributed_repair_files(record) {
    let attributed = [];
    for repair in record["repairs"] {
        if repair["status"] == "applied" {
            attributed = append_unique_values(attributed, repair["changed_files"]);
        }
    }
    attributed
}

fn finalize_audit(target_root, audit_id) {
    let root = audit_root(target_root, audit_id);
    let result_path = path::join(root, "result.json");
    require(!fs::exists(result_path), "audit already finalized: " + audit_id);
    let manifest = json::read_file(path::join(root, "manifest.json"));
    require(manifest["target_root"] == target_root && manifest["audit_id"] == audit_id, "audit identity mismatch");
    verify_policy_unchanged(target_root, manifest["policy_snapshot"]);
    let preserved_dirty = verify_unrelated_dirty(target_root, manifest["initial_state"]);

    let units = [];
    let findings = [];
    let repairs = [];
    let validation = [];
    let changed_scope = [];
    let scope_extensions = [];
    let limitations = [];
    for unit in manifest["units"] {
        let unit_path = record_path(root, unit["unit_id"]);
        require(fs::is_file(unit_path), "missing assessed-unit record: " + unit["unit_id"]);
        let record = json::read_file(unit_path);
        require(record["phase"] == "completed", "unit is not completed: " + unit["unit_id"]);
        require(record["owned_files"] == unit["owned_files"] && record["baseline_sha256"] == unit["baseline_sha256"],
            "unit ownership drift: " + unit["unit_id"]);
        let actual_changed = changed_files(target_root, record["owned_files"], record["baseline_sha256"]);
        let attributed = attributed_repair_files(record);
        require_same_set(actual_changed, attributed, "final assembly found hidden mutation in " + unit["unit_id"]);
        for file in actual_changed {
            changed_scope = push_unique(changed_scope, file, "changed file attributed to multiple units");
        }
        for extension in record["scope_extensions"] {
            extension["unit_id"] = unit["unit_id"];
            scope_extensions.push(extension);
        }
        let evidence = append_unit_evidence(record, findings, repairs, validation);
        findings = evidence["findings"];
        repairs = evidence["repairs"];
        validation = evidence["validation"];
        limitations = append_limitations(record, limitations);
        let final_fingerprints = #{};
        for file in record["owned_files"] {
            final_fingerprints[file] = fingerprint(path::join(target_root, file));
        }
        units.push(#{
            unit_id: unit["unit_id"],
            primary_file: unit["primary_file"],
            owned_files: record["owned_files"],
            baseline_sha256: record["baseline_sha256"],
            final_sha256: final_fingerprints,
            findings: record["findings"],
            repairs: record["repairs"],
            validation: record["validation"],
            scope_extensions: record["scope_extensions"],
        });
    }
    changed_scope.sort();
    limitations.sort();
    let result = #{
        schema_version: "1.0.0",
        audit_id: audit_id,
        workflow: "explicit_audit_repair",
        profile: "strict",
        scope: manifest["scope"],
        catalogue_sha256: manifest["catalogue_sha256"],
        units: units,
        findings: findings,
        repairs: repairs,
        deviations: manifest["policy_snapshot"]["deviations"],
        changed_scope: changed_scope,
        validation: validation,
        preservation: #{
            verified: true,
            unrelated_dirty_files: preserved_dirty,
            scope_extensions: scope_extensions,
        },
        remaining_limitations: limitations,
    };
    json::write_file(result_path, result);
    result
}

fn test_profile() {
    #{
        schema_version: "1.0.0",
        language: "rust",
        profile: "strict",
        msrv: #{
            source: "repository_policy",
            cargo_manifests: ["Cargo.toml"],
            toolchain_policy_paths: ["Cargo.toml"],
            when_unresolved: "stop",
        },
        exclusions: #{ generated: [], vendored: [] },
        deviations_file: "docs/contracts/rust-quality-deviations.json",
    }
}

fn new_test_target(label) {
    let target_root = fs::make_temp_dir("northstar-rust-audit-" + label);
    fs::create_dir(path::join(target_root, "src"));
    fs::create_dir(path::join(target_root, "docs/contracts"));
    fs::write_file(path::join(target_root, "Cargo.toml"), "[package]\nname = \"audit-fixture\"\nversion = \"0.1.0\"\nrust-version = \"1.95\"\n");
    fs::write_file(path::join(target_root, "src/lib.rs"), "pub fn value() -> u8 { 1 }\n");
    fs::write_file(path::join(target_root, "src/helper.rs"), "pub fn helper() -> u8 { 2 }\n");
    fs::write_file(path::join(target_root, "notes.txt"), "preserve me\n");
    json::write_file(path::join(target_root, "docs/contracts/rust-quality-profile.json"), test_profile());
    json::write_file(path::join(target_root, "docs/contracts/rust-quality-deviations.json"), #{
        schema_version: "1.0.0",
        language: "rust",
        deviations: [],
    });
    target_root
}

fn test_unit(unit_id, primary_file, owned_files) {
    #{ unit_id: unit_id, primary_file: primary_file, owned_files: owned_files }
}

fn test_state(in_scope_files, dirty_files, excluded_files) {
    #{
        dirty_files: dirty_files,
        in_scope_files: in_scope_files,
        excluded_dirty_files: excluded_files,
        scope_evidence: ["bounded recorder self-test inventory"],
    }
}

fn test_manifest(profile, scope, units, state) {
    #{ audit_id: "audit", profile: profile, scope: scope, units: units, initial_state: state }
}

fn test_finding(rule_id, action, disposition, file) {
    #{
        rule_id: rule_id,
        confidence: "high",
        action: action,
        location: #{ file: file, symbol: "value" },
        evidence: "bounded recorder self-test evidence",
        disposition: disposition,
    }
}

fn test_plan(rule_id, action, files) {
    #{
        rule_id: rule_id,
        action: action,
        owned_files: files,
        preserved_behavior: ["fixture return behavior"],
    }
}

fn test_repair(rule_id, action, status, files) {
    #{ rule_id: rule_id, action: action, status: status, changed_files: files }
}

fn test_validation() {
    [#{ selector: "fixture:focused", status: "passed", evidence: "fixture passed" }]
}

fn init_single_test(target_root, catalogue_path, scope, dirty_files, excluded_files) {
    let units = [test_unit("unit-lib", "src/lib.rs", ["src/lib.rs"])];
    let state = test_state(["src/lib.rs"], dirty_files, excluded_files);
    init_audit(target_root, test_manifest("strict", scope, units, state), catalogue_path);
}

fn expect_init_error(label, target_root, manifest, catalogue_path, expected) {
    let rejected = false;
    try {
        init_audit(target_root, manifest, catalogue_path);
    } catch (error) {
        rejected = true;
        require(error.to_string().contains(expected), label + " rejected for wrong reason: " + error);
    }
    require(rejected, label + " unexpectedly passed");
}

fn expect_assess_error(label, target_root, input, catalogue, expected) {
    let rejected = false;
    try {
        assess_unit(target_root, "audit", input, catalogue);
    } catch (error) {
        rejected = true;
        require(error.to_string().contains(expected), label + " rejected for wrong reason: " + error);
    }
    require(rejected, label + " unexpectedly passed");
}

fn expect_extend_error(label, target_root, input, catalogue, expected) {
    let rejected = false;
    try {
        extend_unit(target_root, "audit", input, catalogue);
    } catch (error) {
        rejected = true;
        require(error.to_string().contains(expected), label + " rejected for wrong reason: " + error);
    }
    require(rejected, label + " unexpectedly passed");
}

fn expect_complete_error(label, target_root, input, catalogue, expected) {
    let rejected = false;
    try {
        complete_unit(target_root, "audit", input, catalogue);
    } catch (error) {
        rejected = true;
        require(error.to_string().contains(expected), label + " rejected for wrong reason: " + error);
    }
    require(rejected, label + " unexpectedly passed");
}

fn expect_finalize_error(label, target_root, expected) {
    let rejected = false;
    try {
        finalize_audit(target_root, "audit");
    } catch (error) {
        rejected = true;
        require(error.to_string().contains(expected), label + " rejected for wrong reason: " + error);
    }
    require(rejected, label + " unexpectedly passed");
}

fn test_positive_repair_and_extension(catalogue, catalogue_path) {
    let target = new_test_target("positive");
    let dirty = [#{ file: "notes.txt", states: ["untracked"] }];
    let excluded = [#{ file: "notes.txt", reason: "unrelated operator note" }];
    init_single_test(target, catalogue_path, "worktree", dirty, excluded);
    let first_finding = test_finding("RUST-READ-001", "simplify_control_flow", "repair_planned", "src/lib.rs");
    let first_plan = test_plan("RUST-READ-001", "simplify_control_flow", ["src/lib.rs"]);
    let assessment = #{
        unit_id: "unit-lib",
        findings: [first_finding],
        repair_plans: [first_plan],
    };
    assess_unit(target, "audit", assessment, catalogue);
    let plan_extension = #{
        rule_id: "RUST-READ-001",
        action: "simplify_control_flow",
        files: ["src/helper.rs"],
    };
    let extension = #{
        unit_id: "unit-lib",
        files: ["src/helper.rs"],
        reason: "direct helper required for coherent repair",
        findings: [],
        repair_plans: [],
        plan_extensions: [plan_extension],
    };
    extend_unit(target, "audit", extension, catalogue);
    fs::write_file(path::join(target, "src/lib.rs"), "pub fn value() -> u8 { 3 }\n");
    fs::write_file(path::join(target, "src/helper.rs"), "pub fn helper() -> u8 { 4 }\n");
    let first_repair = test_repair("RUST-READ-001", "simplify_control_flow", "applied", ["src/lib.rs", "src/helper.rs"]);
    let completion = #{
        unit_id: "unit-lib",
        repairs: [first_repair],
        validation: test_validation(),
    };
    complete_unit(target, "audit", completion, catalogue);
    let result = finalize_audit(target, "audit");
    require(result["changed_scope"] == ["src/helper.rs", "src/lib.rs"], "positive repair lost changed scope");
    require(result["preservation"]["verified"] && result["preservation"]["unrelated_dirty_files"].len() == 1,
        "positive repair did not prove dirty-state preservation");
    require(result["preservation"]["scope_extensions"].len() == 1, "positive repair lost scope extension");
}

fn test_positive_repository_scope(catalogue, catalogue_path) {
    let target = new_test_target("repository");
    let repository_files = ["Cargo.toml", "src/helper.rs", "src/lib.rs"];
    let units = [test_unit("unit-lib", "src/lib.rs", repository_files)];
    let state = test_state(repository_files, [], []);
    init_audit(target, test_manifest("strict", "repository", units, state), catalogue_path);
    assess_unit(target, "audit", #{ unit_id: "unit-lib", findings: [], repair_plans: [] }, catalogue);
    complete_unit(target, "audit", #{ unit_id: "unit-lib", repairs: [], validation: [] }, catalogue);
    let result = finalize_audit(target, "audit");
    require(result["scope"] == "repository" && result["changed_scope"].len() == 0,
        "clean repository-scope audit result drifted");
}

fn test_positive_operator_stop(catalogue, catalogue_path) {
    let target = new_test_target("operator-stop");
    init_single_test(target, catalogue_path, "worktree", [], []);
    assess_unit(target, "audit", #{
        unit_id: "unit-lib",
        findings: [test_finding("RUST-MSRV-001", "change_version_policy", "operator_decision", "src/lib.rs")],
        repair_plans: [],
    }, catalogue);
    complete_unit(target, "audit", #{ unit_id: "unit-lib", repairs: [], validation: [] }, catalogue);
    let result = finalize_audit(target, "audit");
    require(result["remaining_limitations"].len() == 1 && result["remaining_limitations"][0].contains("operator decision"),
        "operator-owned stop was not reported");

    let foreign_target = new_test_target("foreign-policy-stop");
    init_single_test(foreign_target, catalogue_path, "worktree", [], []);
    assess_unit(foreign_target, "audit", #{
        unit_id: "unit-lib",
        findings: [test_finding("RUST-ERR-001", "change_foreign_error_policy", "operator_decision", "src/lib.rs")],
        repair_plans: [],
    }, catalogue);
    complete_unit(foreign_target, "audit", #{ unit_id: "unit-lib", repairs: [], validation: [] }, catalogue);
    let foreign_result = finalize_audit(foreign_target, "audit");
    require(foreign_result["remaining_limitations"].len() == 1 &&
        foreign_result["remaining_limitations"][0].contains("RUST-ERR-001/change_foreign_error_policy"),
        "foreign error policy stop was not reported");
}

fn test_init_rejections(catalogue_path) {
    let unsupported = new_test_target("unsupported");
    let units = [test_unit("unit-lib", "src/lib.rs", ["src/lib.rs"])];
    let state = test_state(["src/lib.rs"], [], []);
    expect_init_error("unsupported profile", unsupported, test_manifest("ordinary", "worktree", units, state),
        catalogue_path, "unsupported production profile");

    let overlap = new_test_target("overlap");
    let overlap_units = [
        test_unit("unit-one", "src/lib.rs", ["src/lib.rs"]),
        test_unit("unit-two", "src/lib.rs", ["src/lib.rs"]),
    ];
    expect_init_error("overlapping ownership", overlap, test_manifest("strict", "repository", overlap_units, state),
        catalogue_path, "more than one unit");

    let undisposed = new_test_target("undisposed");
    let dirty = [#{ file: "notes.txt", states: ["untracked"] }];
    let dirty_state = test_state(["src/lib.rs"], dirty, []);
    expect_init_error("undisposed dirty file", undisposed, test_manifest("strict", "worktree", units, dirty_state),
        catalogue_path, "lacks scope disposition");
}

fn test_authority_rejections(catalogue, catalogue_path) {
    for test_case in [
        ["unsafe", "RUST-UNSAFE-001", "document_unsafe_contract", "reported", "not repairable"],
        ["slop", "RUST-SLOP-001", "remove_wrapper", "reported", "not repairable"],
        ["msrv", "RUST-MSRV-001", "change_version_policy", "operator_decision", "not repairable"],
        ["foreign-policy", "RUST-ERR-001", "change_foreign_error_policy", "operator_decision", "not repairable"],
    ] {
        let target = new_test_target(test_case[0]);
        init_single_test(target, catalogue_path, "worktree", [], []);
        let rule_id = test_case[1];
        let action = test_case[2];
        let finding = test_finding(rule_id, action, test_case[3], "src/lib.rs");
        let plan = test_plan(rule_id, action, ["src/lib.rs"]);
        let input = #{
            unit_id: "unit-lib",
            findings: [finding],
            repair_plans: [plan],
        };
        expect_assess_error(test_case[0] + " authority", target, input, catalogue, test_case[4]);
    }
}

fn test_cross_unit_rejection(catalogue, catalogue_path) {
    let target = new_test_target("cross-unit");
    let units = [
        test_unit("unit-lib", "src/lib.rs", ["src/lib.rs"]),
        test_unit("unit-helper", "src/helper.rs", ["src/helper.rs"]),
    ];
    let state = test_state(["src/lib.rs", "src/helper.rs"], [], []);
    init_audit(target, test_manifest("strict", "repository", units, state), catalogue_path);
    let input = #{
        unit_id: "unit-lib",
        findings: [test_finding("RUST-READ-001", "simplify_control_flow", "repair_planned", "src/helper.rs")],
        repair_plans: [],
    };
    expect_assess_error("cross-unit finding", target, input, catalogue, "cross-unit finding location");
}

fn test_temporal_rejections(catalogue, catalogue_path) {
    let pre_assess = new_test_target("pre-assess-mutation");
    init_single_test(pre_assess, catalogue_path, "worktree", [], []);
    fs::write_file(path::join(pre_assess, "src/lib.rs"), "pub fn value() -> u8 { 9 }\n");
    let empty_assessment = #{ unit_id: "unit-lib", findings: [], repair_plans: [] };
    expect_assess_error("pre-assessment mutation", pre_assess, empty_assessment, catalogue, "changed before assessment");

    let hidden = new_test_target("hidden");
    init_single_test(hidden, catalogue_path, "worktree", [], []);
    assess_unit(hidden, "audit", empty_assessment, catalogue);
    fs::write_file(path::join(hidden, "src/lib.rs"), "pub fn value() -> u8 { 9 }\n");
    let empty_completion = #{ unit_id: "unit-lib", repairs: [], validation: [] };
    expect_complete_error("hidden mutation", hidden, empty_completion, catalogue, "hidden or falsely attributed mutation");

    let late_extend = new_test_target("late-extend");
    init_single_test(late_extend, catalogue_path, "worktree", [], []);
    assess_unit(late_extend, "audit", empty_assessment, catalogue);
    fs::write_file(path::join(late_extend, "src/lib.rs"), "pub fn value() -> u8 { 9 }\n");
    let extension = #{ unit_id: "unit-lib", files: ["src/helper.rs"], reason: "late", findings: [], repair_plans: [], plan_extensions: [] };
    expect_extend_error("late scope extension", late_extend, extension, catalogue, "follows mutation");
}

fn test_validation_and_preservation_rejections(catalogue, catalogue_path) {
    let missing_validation = new_test_target("missing-validation");
    init_single_test(missing_validation, catalogue_path, "worktree", [], []);
    let assessment = #{
        unit_id: "unit-lib",
        findings: [test_finding("RUST-READ-001", "simplify_control_flow", "repair_planned", "src/lib.rs")],
        repair_plans: [test_plan("RUST-READ-001", "simplify_control_flow", ["src/lib.rs"])],
    };
    assess_unit(missing_validation, "audit", assessment, catalogue);
    fs::write_file(path::join(missing_validation, "src/lib.rs"), "pub fn value() -> u8 { 8 }\n");
    let completion = #{
        unit_id: "unit-lib",
        repairs: [test_repair("RUST-READ-001", "simplify_control_flow", "applied", ["src/lib.rs"])],
        validation: [],
    };
    expect_complete_error("missing validation", missing_validation, completion, catalogue, "requires local validation");

    let preservation = new_test_target("preservation");
    let dirty = [#{ file: "notes.txt", states: ["untracked"] }];
    let excluded = [#{ file: "notes.txt", reason: "unrelated" }];
    init_single_test(preservation, catalogue_path, "worktree", dirty, excluded);
    assess_unit(preservation, "audit", #{ unit_id: "unit-lib", findings: [], repair_plans: [] }, catalogue);
    complete_unit(preservation, "audit", #{ unit_id: "unit-lib", repairs: [], validation: [] }, catalogue);
    fs::write_file(path::join(preservation, "notes.txt"), "overwritten\n");
    expect_finalize_error("dirty-state preservation", preservation, "unrelated dirty file changed");
}

let skill_root = repo_root;
if fs::is_dir(path::join(repo_root, "skills/northstar/references/language-quality/rust")) {
    skill_root = path::join(repo_root, "skills/northstar");
}
let catalogue_path = path::join(skill_root, "references/language-quality/rust/catalogue.json");
let catalogue = json::read_file(catalogue_path);

if args.len() == 1 && args[0] == "self-test" {
    test_positive_repair_and_extension(catalogue, catalogue_path);
    test_positive_repository_scope(catalogue, catalogue_path);
    test_positive_operator_stop(catalogue, catalogue_path);
    test_init_rejections(catalogue_path);
    test_authority_rejections(catalogue, catalogue_path);
    test_cross_unit_rejection(catalogue, catalogue_path);
    test_temporal_rejections(catalogue, catalogue_path);
    test_validation_and_preservation_rejections(catalogue, catalogue_path);
    log("Rust quality recorder: OK (3 positive paths, 10 negative paths)");
} else if args.len() == 3 && args[0] == "init" {
    let root = init_audit(args[1], json::read_file(args[2]), catalogue_path);
    log("Rust quality audit initialized: " + root);
} else if args.len() == 4 && args[0] == "assess" {
    assess_unit(args[1], args[2], json::read_file(args[3]), catalogue);
    log("Rust quality unit assessed: " + args[3]);
} else if args.len() == 4 && args[0] == "extend" {
    extend_unit(args[1], args[2], json::read_file(args[3]), catalogue);
    log("Rust quality unit scope extended: " + args[3]);
} else if args.len() == 4 && args[0] == "complete" {
    complete_unit(args[1], args[2], json::read_file(args[3]), catalogue);
    log("Rust quality unit completed: " + args[3]);
} else if args.len() == 3 && args[0] == "finalize" {
    finalize_audit(args[1], args[2]);
    log("Rust quality audit finalized: " + path::join(audit_root(args[1], args[2]), "result.json"));
} else {
    throw("usage: rust-quality:record self-test | init <target-root> <manifest-input.json> | assess|extend|complete <target-root> <audit-id> <input.json> | finalize <target-root> <audit-id>");
}
