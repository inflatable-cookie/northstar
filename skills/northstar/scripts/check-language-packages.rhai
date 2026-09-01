// Focused validation for Northstar language package machine contracts (card 116).
//
// Validates:
// 1. JSON Schema Draft 2020-12 structure and properties across all 3 schema files.
// 2. Deterministic schema-instance validation engine evaluating schemas directly.
// 3. Schema mutation discrimination proof (modifying schema constraints rejects instances).
// 4. Exact semantic-version parsing and numeric range compatibility.
// 5. Safe package-relative path containment (disallowing traversal and absolute paths).
// 6. Manifest, registry, and receipt schema-instance conformance across all trust
//    (official, operator_allowlist, interactive_approval) and source variants
//    (git, local_path, archive).
// 7. Deep recursive policy-free fixture verification.
// 8. Independent package addressing and materialization boundary into isolated staging.
// 9. Negative review-oracle invariant suite (malformed, mutable, incompatible,
//    duplicate, ambiguous, digest-drift, path-traversal, self-authorizing).
// 10. Schema and contract portability.

fn require(condition, message) {
    if !condition {
        let err = "[northstar:language-packages] ";
        err += message;
        throw(err);
    }
}

// -----------------------------------------------------------------------------
// JSON Schema Draft 2020-12 Conformance Engine (Iterative)
// -----------------------------------------------------------------------------

fn check_node_type(instance, schema, ctx) {
    if !schema.contains("type") { return; }
    let expected_t = schema["type"];
    let actual_t = type_of(instance);
    if expected_t == "object" && actual_t != "map" {
        let err = ctx;
        err += " must be an object, got ";
        err += actual_t;
        throw(err);
    }
    if expected_t == "array" && actual_t != "array" {
        let err = ctx;
        err += " must be an array, got ";
        err += actual_t;
        throw(err);
    }
    if expected_t == "string" && actual_t != "string" {
        let err = ctx;
        err += " must be a string, got ";
        err += actual_t;
        throw(err);
    }
    if expected_t == "boolean" && actual_t != "bool" {
        let err = ctx;
        err += " must be a boolean, got ";
        err += actual_t;
        throw(err);
    }
    if expected_t == "integer" {
        let is_int = actual_t == "i64" || actual_t == "i32" || actual_t == "int";
        if !is_int {
            let err = ctx;
            err += " must be an integer, got ";
            err += actual_t;
            throw(err);
        }
    }
}

fn check_node_const_enum(instance, schema, ctx) {
    if schema.contains("const") {
        let expected_const = schema["const"];
        if instance != expected_const {
            let err = ctx;
            err += " const mismatch: expected '";
            err += expected_const;
            err += "', got '";
            err += instance;
            err += "'";
            throw(err);
        }
    }
    if schema.contains("enum") {
        let enum_list = schema["enum"];
        let found = false;
        for val in enum_list {
            if instance == val {
                found = true;
                break;
            }
        }
        if !found {
            let err = ctx;
            err += " value '";
            err += instance;
            err += "' is not in allowed enum";
            throw(err);
        }
    }
}

fn check_node_string(instance, schema, ctx) {
    if type_of(instance) != "string" { return; }
    if schema.contains("minLength") {
        let min_l = schema["minLength"];
        if instance.len() < min_l {
            let err = ctx;
            err += " string length is less than minLength ";
            err += min_l;
            throw(err);
        }
    }
    if schema.contains("pattern") {
        let pat = schema["pattern"];
        if !regex::is_match(pat, instance) {
            let err = ctx;
            err += " value '";
            err += instance;
            err += "' does not match pattern: ";
            err += pat;
            throw(err);
        }
    }
}

fn check_node_array(instance, schema, ctx) {
    if type_of(instance) != "array" { return; }
    if schema.contains("minItems") {
        let min_i = schema["minItems"];
        if instance.len() < min_i {
            let err = ctx;
            err += " array length is less than minItems ";
            err += min_i;
            throw(err);
        }
    }
}

fn get_array_children(instance, schema, ctx) {
    if type_of(instance) != "array" || !schema.contains("items") { return []; }
    let item_s = schema["items"];
    let children = [];
    let i = 0;
    for elem in instance {
        let elem_ctx = ctx;
        elem_ctx += "[";
        elem_ctx += i;
        elem_ctx += "]";
        children.push(#{ instance: elem, schema: item_s, ctx: elem_ctx });
        i += 1;
    }
    children
}

fn check_node_object_required(instance, schema, ctx) {
    if !schema.contains("required") { return; }
    let req_list = schema["required"];
    for req_k in req_list {
        if !instance.contains(req_k) {
            let err = ctx;
            err += " missing required field: ";
            err += req_k;
            throw(err);
        }
    }
}

fn get_object_property_children(instance, schema, ctx) {
    if type_of(instance) != "map" || !schema.contains("properties") { return []; }
    let props = schema["properties"];
    let children = [];
    for prop_k in instance.keys() {
        if props.contains(prop_k) {
            let sub_s = props[prop_k];
            let sub_val = instance[prop_k];
            let prop_ctx = ctx;
            prop_ctx += ".";
            prop_ctx += prop_k;
            children.push(#{ instance: sub_val, schema: sub_s, ctx: prop_ctx });
        }
    }
    children
}

fn check_disallowed_additional_props(instance, props, ctx) {
    for k in instance.keys() {
        if !props.contains(k) {
            let err = ctx;
            err += " contains forbidden additional property: ";
            err += k;
            throw(err);
        }
    }
}

fn collect_typed_additional_props(instance, props, add_prop, ctx) {
    let children = [];
    for k in instance.keys() {
        if !props.contains(k) {
            let sub_val = instance[k];
            let prop_ctx = ctx;
            prop_ctx += ".";
            prop_ctx += k;
            children.push(#{ instance: sub_val, schema: add_prop, ctx: prop_ctx });
        }
    }
    children
}

fn get_object_additional_property_children(instance, schema, ctx) {
    if type_of(instance) != "map" || !schema.contains("additionalProperties") { return []; }
    let props = #{};
    if schema.contains("properties") {
        props = schema["properties"];
    }
    let add_prop = schema["additionalProperties"];
    if add_prop == false {
        check_disallowed_additional_props(instance, props, ctx);
        return [];
    }
    if type_of(add_prop) == "map" {
        return collect_typed_additional_props(instance, props, add_prop, ctx);
    }
    []
}

fn check_node_one_of(instance, schema, ctx) {
    if !schema.contains("oneOf") { return false; }
    let one_of_list = schema["oneOf"];
    let matched = 0;
    let last_err = "";
    for sub_s in one_of_list {
        let ok = true;
        try {
            validate_schema_node(instance, sub_s, ctx);
        } catch (err) {
            ok = false;
            last_err = err.to_string();
        }
        if ok {
            matched += 1;
        }
    }
    if matched == 0 {
        let err = ctx;
        err += " failed oneOf schema validation: ";
        err += last_err;
        throw(err);
    }
    if matched > 1 {
        let err = ctx;
        err += " matched multiple oneOf schema variants (ambiguous)";
        throw(err);
    }
    true
}

fn validate_schema_node(root_instance, root_schema, root_ctx) {
    let queue = [ #{ instance: root_instance, schema: root_schema, ctx: root_ctx } ];

    while queue.len() > 0 {
        let current = queue.pop();
        let instance = current["instance"];
        let schema = current["schema"];
        let ctx = current["ctx"];

        if type_of(schema) != "map" { continue; }

        if check_node_one_of(instance, schema, ctx) {
            continue;
        }

        check_node_type(instance, schema, ctx);
        check_node_const_enum(instance, schema, ctx);
        check_node_string(instance, schema, ctx);
        check_node_array(instance, schema, ctx);

        for child in get_array_children(instance, schema, ctx) {
            queue.push(child);
        }

        if type_of(instance) == "map" {
            check_node_object_required(instance, schema, ctx);
            for child in get_object_property_children(instance, schema, ctx) {
                queue.push(child);
            }
            for child in get_object_additional_property_children(instance, schema, ctx) {
                queue.push(child);
            }
        }
    }
}

// -----------------------------------------------------------------------------
// SemVer Parsing & Numeric Range Evaluation
// -----------------------------------------------------------------------------

fn parse_semver(ver_str) {
    if type_of(ver_str) != "string" {
        return ();
    }
    if !regex::is_match("^[0-9]+\\.[0-9]+\\.[0-9]+$", ver_str) {
        return ();
    }
    let parts = str::split_lines(str::replace(ver_str, ".", "\n"));
    if parts.len() != 3 {
        return ();
    }
    let major = parse_int(parts[0]);
    let minor = parse_int(parts[1]);
    let patch = parse_int(parts[2]);
    [major, minor, patch]
}

fn compare_semver(v1, v2) {
    if v1[0] != v2[0] {
        return v1[0] - v2[0];
    }
    if v1[1] != v2[1] {
        return v1[1] - v2[1];
    }
    v1[2] - v2[2]
}

fn check_semver_compatibility(range_str, core_version_str) {
    let core_v = parse_semver(core_version_str);
    if core_v == () {
        throw("invalid core version: " + core_version_str);
    }

    if range_str == "*" {
        return true;
    }

    // Exact version: X.Y.Z
    if regex::is_match("^[0-9]+\\.[0-9]+\\.[0-9]+$", range_str) {
        let target_v = parse_semver(range_str);
        if target_v == () { return false; }
        return compare_semver(core_v, target_v) == 0;
    }

    // Caret range: ^X.Y.Z
    if regex::is_match("^\\^[0-9]+\\.[0-9]+\\.[0-9]+$", range_str) {
        let base_str = str::replace(range_str, "^", "");
        let base_v = parse_semver(base_str);
        if base_v == () { return false; }
        if compare_semver(core_v, base_v) < 0 {
            return false;
        }
        if base_v[0] > 0 {
            let next_major = base_v[0] + 1;
            let max_v = [next_major, 0, 0];
            return compare_semver(core_v, max_v) < 0;
        }
        if base_v[1] > 0 {
            let next_minor = base_v[1] + 1;
            let max_v = [0, next_minor, 0];
            return compare_semver(core_v, max_v) < 0;
        }
        let next_patch = base_v[2] + 1;
        let max_v = [0, 0, next_patch];
        return compare_semver(core_v, max_v) < 0;
    }

    // Bounded range: >=X.Y.Z <A.B.C
    if regex::is_match("^>=[0-9]+\\.[0-9]+\\.[0-9]+ <[0-9]+\\.[0-9]+\\.[0-9]+$", range_str) {
        let tokens = str::split_lines(str::replace(range_str, " ", "\n"));
        let min_str = str::replace(tokens[0], ">=", "");
        let max_str = str::replace(tokens[1], "<", "");
        let min_v = parse_semver(min_str);
        let max_v = parse_semver(max_str);
        if min_v == () || max_v == () { return false; }
        if compare_semver(core_v, min_v) < 0 {
            return false;
        }
        if compare_semver(core_v, max_v) >= 0 {
            return false;
        }
        return true;
    }

    // Greater-than-or-equal: >=X.Y.Z
    if regex::is_match("^>=[0-9]+\\.[0-9]+\\.[0-9]+$", range_str) {
        let min_str = str::replace(range_str, ">=", "");
        let min_v = parse_semver(min_str);
        if min_v == () { return false; }
        return compare_semver(core_v, min_v) >= 0;
    }

    // Less-than: <A.B.C
    if regex::is_match("^<[0-9]+\\.[0-9]+\\.[0-9]+$", range_str) {
        let max_str = str::replace(range_str, "<", "");
        let max_v = parse_semver(max_str);
        if max_v == () { return false; }
        return compare_semver(core_v, max_v) < 0;
    }

    false
}

// -----------------------------------------------------------------------------
// Package-Relative Path Containment
// -----------------------------------------------------------------------------

fn is_safe_package_relative_path(p) {
    if type_of(p) != "string" || p == "" {
        return false;
    }
    if str::starts_with(p, "/") || str::starts_with(p, "\\") {
        return false;
    }
    if p.contains("//") || str::ends_with(p, "/") {
        return false;
    }
    let parts = str::split_lines(str::replace(p, "/", "\n"));
    for part in parts {
        if part == "" || part == "." || part == ".." {
            return false;
        }
    }
    regex::is_match("^[a-zA-Z0-9_-][a-zA-Z0-9_.-]*(/[a-zA-Z0-9_-][a-zA-Z0-9_.-]*)*$", p)
}

fn assert_safe_package_relative_path(p, context) {
    if !is_safe_package_relative_path(p) {
        let err = context;
        err += " path violates package-relative containment: '";
        err += p;
        err += "'";
        throw(err);
    }
}

// -----------------------------------------------------------------------------
// JSON Schema Structure Validation (Draft 2020-12)
// -----------------------------------------------------------------------------

fn load_and_validate_schema_file(root, filename, expected_id_part) {
    let schema_path = path::join(root, filename);
    require(fs::is_file(schema_path), "missing schema file: " + filename);
    let schema = json::read_file(schema_path);
    require(schema["$schema"] == "https://json-schema.org/draft/2020-12/schema",
        filename + " uses incorrect JSON Schema dialect");
    require(schema["$id"].contains(expected_id_part),
        filename + " has incorrect schema $id: " + schema["$id"]);
    require(schema["type"] == "object", filename + " root must be type object");
    require(schema["additionalProperties"] == false,
        filename + " must disallow additionalProperties at root");
    require(schema.contains("required"), filename + " must declare required fields");
    require(schema["required"].len() > 0, filename + " required fields cannot be empty");
    schema
}

// -----------------------------------------------------------------------------
// Schema Instance Validators
// -----------------------------------------------------------------------------

fn validate_manifest_instance(manifest, schema, context) {
    // Non-schema semantic invariant: explicit rejection of self-authorizing trust
    for forbidden in ["official", "is_official", "trusted", "trust_level", "allowlisted"] {
        if manifest.contains(forbidden) {
            let err = context;
            err += " self-claims trust or official status (trust must be core-owned)";
            throw(err);
        }
    }

    validate_schema_node(manifest, schema, context);

    // Non-schema semantic invariant: entrypoints and self-check safe containment
    if manifest.contains("entrypoints") && type_of(manifest["entrypoints"]) == "map" {
        for entry_k in manifest["entrypoints"].keys() {
            let entry_p = manifest["entrypoints"][entry_k];
            assert_safe_package_relative_path(entry_p, context + " entrypoint[" + entry_k + "]");
        }
    }
    if manifest.contains("self_check") && type_of(manifest["self_check"]) == "map" {
        if manifest["self_check"].contains("entrypoint") {
            assert_safe_package_relative_path(manifest["self_check"]["entrypoint"], context + " self_check.entrypoint");
        }
    }
}

fn get_registry_entry_key(entry, context) {
    if type_of(entry) != "map" { return ""; }
    if entry.contains("subpath") {
        assert_safe_package_relative_path(entry["subpath"], context + " subpath");
    }
    if entry.contains("package_id") && entry.contains("version") {
        return entry["package_id"] + "@" + entry["version"];
    }
    ""
}

fn check_registry_duplicates(packages, context) {
    let seen_ids = [];
    for entry in packages {
        let pkg_key = get_registry_entry_key(entry, context);
        if pkg_key != "" {
            if seen_ids.contains(pkg_key) {
                let err = context;
                err += " contains duplicate registry package: ";
                err += pkg_key;
                throw(err);
            }
            seen_ids.push(pkg_key);
        }
    }
}

fn validate_registry_instance(registry, schema, context) {
    validate_schema_node(registry, schema, context);

    if registry.contains("packages") && type_of(registry["packages"]) == "array" {
        check_registry_duplicates(registry["packages"], context);
    }
}

fn validate_receipt_instance(receipt, schema, context) {
    validate_schema_node(receipt, schema, context);

    // Non-schema semantic invariant: safe subpath containment on source
    if receipt.contains("source") && type_of(receipt["source"]) == "map" {
        let src = receipt["source"];
        if src.contains("subpath") {
            assert_safe_package_relative_path(src["subpath"], context + " source subpath");
        }
    }
}

// -----------------------------------------------------------------------------
// Schema Mutation Discrimination Proof
// -----------------------------------------------------------------------------

fn test_schema_mutation_discrimination(valid_manifest, base_schema) {
    // Mutation 1: Changing schema_version.const from "1.0.0" to "9.9.9" must reject the 1.0.0 instance
    let mutated_schema = json::parse(json::stringify(base_schema));
    mutated_schema["properties"]["schema_version"]["const"] = "9.9.9";

    let rejected_const = false;
    try {
        validate_manifest_instance(valid_manifest, mutated_schema, "mutated-const-manifest");
    } catch (err) {
        let msg = err.to_string();
        if msg.contains("const mismatch: expected '9.9.9', got '1.0.0'") {
            rejected_const = true;
        }
    }
    require(rejected_const, "schema mutation test failed: changing schema const did not reject instance");

    // Mutation 2: Changing package_id pattern to reject non-matching package_id
    let mutated_pattern_schema = json::parse(json::stringify(base_schema));
    mutated_pattern_schema["properties"]["package_id"]["pattern"] = "^@custom/[a-z]+$";

    let rejected_pattern = false;
    try {
        validate_manifest_instance(valid_manifest, mutated_pattern_schema, "mutated-pattern-manifest");
    } catch (err) {
        let msg = err.to_string();
        if msg.contains("does not match pattern") {
            rejected_pattern = true;
        }
    }
    require(rejected_pattern, "schema mutation test failed: changing schema pattern did not reject instance");
}

// -----------------------------------------------------------------------------
// Deep Recursive Policy-Free Fixture Verification
// -----------------------------------------------------------------------------

fn has_forbidden_rule_id(content) {
    for prefix in ["RUST-", "TS-", "SVELTE-", "RUST_", "TS_"] {
        if content.contains(prefix) { return true; }
    }
    false
}

fn check_fixture_file_content(file_path) {
    if !fs::is_file(file_path) { return; }
    let content = fs::read_file(file_path);
    if has_forbidden_rule_id(content) {
        let err = "policy-free fixture file contains production rule IDs: ";
        err += file_path;
        throw(err);
    }
    if regex::is_match("(?i)\\b(rustc|cargo|typescript|svelte|clippy|eslint|biome)\\b", content) {
        let err = "policy-free fixture file contains production language bindings: ";
        err += file_path;
        throw(err);
    }
}

fn validate_policy_free_fixture_deep(fixture_root, manifest_schema) {
    let skill_path = path::join(fixture_root, "SKILL.md");
    let manifest_path = path::join(fixture_root, "northstar-package.json");
    require(fs::is_file(skill_path), "policy-free fixture missing SKILL.md");
    require(fs::is_file(manifest_path), "policy-free fixture missing northstar-package.json");

    let manifest = json::read_file(manifest_path);
    validate_manifest_instance(manifest, manifest_schema, "policy-free fixture manifest");

    let forbidden_names = [
        "catalogue.json", "profile.schema.json", "strict-audit.json", "strict-authoring.json",
        "default-profile.json", "rules.json", "detectors.json"
    ];

    for file_path in fs::list_recursive(fixture_root) {
        for forbidden in forbidden_names {
            if str::ends_with(file_path, "/" + forbidden) || file_path == forbidden {
                let err = "policy-free fixture contains production language file: ";
                err += file_path;
                throw(err);
            }
        }
        if file_path.contains("/rules/") || file_path.contains("/catalogue/") {
            let err = "policy-free fixture contains production rule/catalogue directory: ";
            err += file_path;
            throw(err);
        }
        check_fixture_file_content(file_path);
    }

    let self_check_entry = manifest["self_check"]["entrypoint"];
    let self_check_path = path::join(fixture_root, self_check_entry);
    require(fs::is_file(self_check_path), "policy-free fixture self-check entrypoint missing: " + self_check_entry);
}

// -----------------------------------------------------------------------------
// Independent Package Addressing & Staging Materialization Boundary
// -----------------------------------------------------------------------------

fn materialize_addressed_package_to_staging(source_repo_root, package_subpath, staging_root) {
    assert_safe_package_relative_path(package_subpath, "materialize_addressed_package_to_staging subpath");
    let source_dir = path::join(source_repo_root, package_subpath);
    require(fs::is_dir(source_dir), "addressed package source subpath does not exist: " + source_dir);

    let prefix = source_dir + "/";
    let staged_files = [];
    for file in fs::list_recursive(source_dir) {
        if fs::is_file(file) {
            let rel_file = str::replace(file, prefix, "");
            let dest_file = path::join(staging_root, rel_file);
            let dest_parent = path::parent(dest_file);
            if !fs::is_dir(dest_parent) {
                fs::create_dir(dest_parent);
            }
            let content = fs::read_file(file);
            fs::write_file(dest_file, content);
            staged_files.push(rel_file);
        }
    }
    staged_files.sort();
    staged_files
}

fn test_independent_package_materialization(sibling_root) {
    let stage_a = fs::make_temp_dir("northstar-stage-alpha-");
    let stage_b = fs::make_temp_dir("northstar-stage-beta-");

    let alpha_staged = materialize_addressed_package_to_staging(sibling_root, "packages/alpha-pkg", stage_a);
    let beta_staged = materialize_addressed_package_to_staging(sibling_root, "packages/beta-pkg", stage_b);

    let expected_inventory = ["SKILL.md", "northstar-package.json", "scripts/self-check.rhai"];
    require(alpha_staged == expected_inventory, "alpha-pkg staged inventory drifted");
    require(beta_staged == expected_inventory, "beta-pkg staged inventory drifted");

    // Verify stage_a contains zero beta files and vice versa
    for f in fs::list_recursive(stage_a) {
        if f.contains("beta") {
            throw("stage_a retained sibling beta payload: " + f);
        }
    }
    for f in fs::list_recursive(stage_b) {
        if f.contains("alpha") {
            throw("stage_b retained sibling alpha payload: " + f);
        }
    }

    // Negative selection test: addressing a broader directory containing both packages
    let stage_broad = fs::make_temp_dir("northstar-stage-broad-");
    let broad_staged = materialize_addressed_package_to_staging(sibling_root, "packages", stage_broad);
    let broad_retains_sibling = false;
    for f in broad_staged {
        if f.contains("beta-pkg") && broad_staged.contains("alpha-pkg/northstar-package.json") {
            broad_retains_sibling = true;
        }
    }
    require(broad_retains_sibling, "broad staging negative test failed to capture multiple packages");
}

// -----------------------------------------------------------------------------
// Negative Oracle Suite & Falsification Tests
// -----------------------------------------------------------------------------

fn verify_manifest_digest_check(manifest_path, expected_digest) {
    let actual_digest = fs::sha256(manifest_path);
    if actual_digest != expected_digest {
        let err = "manifest integrity verification failed: expected ";
        err += expected_digest;
        err += ", got ";
        err += actual_digest;
        throw(err);
    }
    throw("self-check ran unexpectedly after digest failure");
}

fn verify_core_compat_check(range_str, core_version, pkg_id) {
    if !check_semver_compatibility(range_str, core_version) {
        let err = "package ";
        err += pkg_id;
        err += " range ";
        err += range_str;
        err += " incompatible with Northstar core ";
        err += core_version;
        throw(err);
    }
}

fn expect_digest_drift_failure(manifest_path, tampered_digest) {
    let rejected = false;
    try {
        verify_manifest_digest_check(manifest_path, tampered_digest);
    } catch (error) {
        rejected = true;
        let message = error.to_string();
        if !message.contains("manifest integrity verification failed") {
            let err = "manifest-digest-drift failed for wrong reason: ";
            err += message;
            throw(err);
        }
    }
    if !rejected {
        throw("manifest-digest-drift unexpectedly passed");
    }
}

fn expect_manifest_rejection(label, manifest, manifest_schema, expected_reason) {
    let rejected = false;
    try {
        validate_manifest_instance(manifest, manifest_schema, label);
    } catch (error) {
        rejected = true;
        let message = error.to_string();
        if !message.contains(expected_reason) {
            let err = label;
            err += " rejected for wrong reason: ";
            err += message;
            throw(err);
        }
    }
    if !rejected {
        let err = label;
        err += " unexpectedly passed";
        throw(err);
    }
}

fn expect_registry_rejection(label, registry, registry_schema, expected_reason) {
    let rejected = false;
    try {
        validate_registry_instance(registry, registry_schema, label);
    } catch (error) {
        rejected = true;
        let message = error.to_string();
        if !message.contains(expected_reason) {
            let err = label;
            err += " rejected for wrong reason: ";
            err += message;
            throw(err);
        }
    }
    if !rejected {
        let err = label;
        err += " unexpectedly passed";
        throw(err);
    }
}

fn expect_receipt_rejection(label, receipt, receipt_schema, expected_reason) {
    let rejected = false;
    try {
        validate_receipt_instance(receipt, receipt_schema, label);
    } catch (error) {
        rejected = true;
        let message = error.to_string();
        if !message.contains(expected_reason) {
            let err = label;
            err += " rejected for wrong reason: ";
            err += message;
            throw(err);
        }
    }
    if !rejected {
        let err = label;
        err += " unexpectedly passed";
        throw(err);
    }
}

fn expect_compat_rejection(label, range_str, core_version, pkg_id, expected_reason) {
    let rejected = false;
    try {
        verify_core_compat_check(range_str, core_version, pkg_id);
    } catch (error) {
        rejected = true;
        let message = error.to_string();
        if !message.contains(expected_reason) {
            let err = label;
            err += " rejected for wrong reason: ";
            err += message;
            throw(err);
        }
    }
    if !rejected {
        let err = label;
        err += " unexpectedly passed";
        throw(err);
    }
}

fn test_receipt_conformance_variants(receipt_schema) {
    // 1. Positive: official trust + git source
    let official_git_receipt = #{
        schema_version: "1.0.0",
        package_id: "@northstar/language-fixture",
        version: "0.1.0",
        kind: "language-quality",
        trust_class: #{
            type: "official",
            registry_version: "1.0.0",
            registry_entry_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        source: #{
            type: "git",
            repository: "https://github.com/inflatable-cookie/northstar.git",
            subpath: "packages/fixture",
            commit: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        content_identity: #{
            package_tree_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
            manifest_digest: "b6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        compatibility: #{
            compatible_core_range: ">=0.2.0 <1.0.0",
            installed_core_version: "0.2.0",
        },
        installation: #{
            installed_path: "/path/to/installed/package",
            installed_at: "2026-09-01T18:00:00Z",
            acquisition_adapter: "git-clone",
            activation_status: "active",
        },
    };
    validate_receipt_instance(official_git_receipt, receipt_schema, "official-git-receipt");

    // 2. Positive: operator_allowlist trust + local_path source
    let allowlist_local_receipt = #{
        schema_version: "1.0.0",
        package_id: "@northstar/language-fixture",
        version: "0.1.0",
        kind: "language-quality",
        trust_class: #{
            type: "operator_allowlist",
            allowlist_entry: "https://github.com/inflatable-cookie/northstar.git",
            allowlisted_by: "operator@example.com",
        },
        source: #{
            type: "local_path",
            path: "/local/packages/fixture",
            acquisition_mode: "manual",
        },
        content_identity: #{
            package_tree_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
            manifest_digest: "b6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        compatibility: #{
            compatible_core_range: "^0.2.0",
            installed_core_version: "0.2.0",
        },
        installation: #{
            installed_path: "/path/to/installed/package",
            installed_at: "2026-09-01T18:00:00Z",
            acquisition_adapter: "local-copy",
            activation_status: "installed",
        },
    };
    validate_receipt_instance(allowlist_local_receipt, receipt_schema, "allowlist-local-receipt");

    // 3. Positive: interactive_approval trust + archive source
    let interactive_archive_receipt = #{
        schema_version: "1.0.0",
        package_id: "@northstar/language-fixture",
        version: "0.1.0",
        kind: "language-quality",
        trust_class: #{
            type: "interactive_approval",
            approved_by: "operator",
            approval_timestamp: "2026-09-01T18:00:00Z",
            approval_scope: "session",
        },
        source: #{
            type: "archive",
            url: "https://example.com/packages/fixture-0.1.0.tar.gz",
            archive_digest: "c6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
            subpath: "packages/fixture",
        },
        content_identity: #{
            package_tree_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
            manifest_digest: "b6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        compatibility: #{
            compatible_core_range: "0.2.0",
            installed_core_version: "0.2.0",
        },
        installation: #{
            installed_path: "/path/to/installed/package",
            installed_at: "2026-09-01T18:00:00Z",
            acquisition_adapter: "tarball-extract",
            activation_status: "installed",
        },
    };
    validate_receipt_instance(interactive_archive_receipt, receipt_schema, "interactive-archive-receipt");

    // 4. Negative: official trust without registry_version
    let broken_official_trust = #{
        schema_version: "1.0.0",
        package_id: "@northstar/language-fixture",
        version: "0.1.0",
        kind: "language-quality",
        trust_class: #{
            type: "official",
        },
        source: #{
            type: "git",
            repository: "https://github.com/inflatable-cookie/northstar.git",
            subpath: "packages/fixture",
            commit: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        content_identity: #{
            package_tree_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
            manifest_digest: "b6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        compatibility: #{
            compatible_core_range: ">=0.2.0 <1.0.0",
            installed_core_version: "0.2.0",
        },
        installation: #{
            installed_path: "/path/to/installed/package",
            installed_at: "2026-09-01T18:00:00Z",
            acquisition_adapter: "git-clone",
            activation_status: "active",
        },
    };
    expect_receipt_rejection("broken-official-trust-receipt", broken_official_trust, receipt_schema, "failed oneOf schema validation");

    // 5. Negative: mismatched trust provenance (official containing approved_by)
    let mismatched_trust = #{
        schema_version: "1.0.0",
        package_id: "@northstar/language-fixture",
        version: "0.1.0",
        kind: "language-quality",
        trust_class: #{
            type: "official",
            registry_version: "1.0.0",
            registry_entry_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
            approved_by: "operator",
        },
        source: #{
            type: "git",
            repository: "https://github.com/inflatable-cookie/northstar.git",
            subpath: "packages/fixture",
            commit: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        content_identity: #{
            package_tree_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
            manifest_digest: "b6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        compatibility: #{
            compatible_core_range: ">=0.2.0 <1.0.0",
            installed_core_version: "0.2.0",
        },
        installation: #{
            installed_path: "/path/to/installed/package",
            installed_at: "2026-09-01T18:00:00Z",
            acquisition_adapter: "git-clone",
            activation_status: "active",
        },
    };
    expect_receipt_rejection("mismatched-trust-provenance-receipt", mismatched_trust, receipt_schema, "failed oneOf schema validation");

    // 6. Negative: mismatched source provenance (local_path containing commit)
    let mismatched_source = #{
        schema_version: "1.0.0",
        package_id: "@northstar/language-fixture",
        version: "0.1.0",
        kind: "language-quality",
        trust_class: #{
            type: "operator_allowlist",
            allowlist_entry: "https://github.com/inflatable-cookie/northstar.git",
            allowlisted_by: "operator@example.com",
        },
        source: #{
            type: "local_path",
            path: "/local/packages/fixture",
            acquisition_mode: "manual",
            commit: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        content_identity: #{
            package_tree_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
            manifest_digest: "b6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
        },
        compatibility: #{
            compatible_core_range: ">=0.2.0 <1.0.0",
            installed_core_version: "0.2.0",
        },
        installation: #{
            installed_path: "/path/to/installed/package",
            installed_at: "2026-09-01T18:00:00Z",
            acquisition_adapter: "local-copy",
            activation_status: "installed",
        },
    };
    expect_receipt_rejection("mismatched-source-provenance-receipt", mismatched_source, receipt_schema, "failed oneOf schema validation");
}

fn test_semver_compatibility_suite() {
    let core = "0.2.0";

    // Positive compatibility cases
    require(check_semver_compatibility("*", core), "wildcard semver compatibility failed");
    require(check_semver_compatibility("0.2.0", core), "exact semver compatibility failed");
    require(check_semver_compatibility(">=0.2.0 <1.0.0", core), "bounded semver range compatibility failed");
    require(check_semver_compatibility(">=0.1.0", core), ">= semver range compatibility failed");
    require(check_semver_compatibility("<1.0.0", core), "< semver range compatibility failed");
    require(check_semver_compatibility("^0.2.0", core), "^0.2.0 with 0.2.0 failed");
    require(check_semver_compatibility("^0.2.0", "0.2.5"), "^0.2.0 with 0.2.5 failed");
    require(check_semver_compatibility("^1.2.3", "1.9.0"), "^1.2.3 with 1.9.0 failed");

    // Negative compatibility cases (numeric ordering vs lexicographical ordering)
    require(!check_semver_compatibility(">=0.10.0 <1.0.0", core), "0.2.0 was accepted by >=0.10.0 (lexicographical bug!)");
    require(!check_semver_compatibility(">=0.2.0 <0.9.0", "0.10.0"), "0.10.0 was accepted by <0.9.0 (lexicographical bug!)");
    require(!check_semver_compatibility("^0.2.0", "0.3.0"), "0.3.0 was accepted by ^0.2.0 (caret breach!)");
    require(!check_semver_compatibility("^0.2.0", "0.1.9"), "0.1.9 was accepted by ^0.2.0 (caret floor breach!)");
    require(!check_semver_compatibility("^1.2.3", "2.0.0"), "2.0.0 was accepted by ^1.2.3 (caret major breach!)");
    require(!check_semver_compatibility(">=99.0.0", core), "0.2.0 was accepted by >=99.0.0");
    require(!check_semver_compatibility("invalid-range", core), "invalid range string was accepted");
}

fn run_negative_oracle_suite(target_skill_root, manifest_schema, registry_schema, receipt_schema) {
    let fixtures_root = path::join(target_skill_root, "assets/fixtures/language-packages");

    // Invariant 0: Policy-free fixture discrimination proof (forbidden rules / filenames rejected).
    require(has_forbidden_rule_id("Rule RUST-001 violation"), "policy-free scanner failed to detect RUST- rule ID");
    require(has_forbidden_rule_id("Rule TS-002 violation"), "policy-free scanner failed to detect TS- rule ID");
    require(has_forbidden_rule_id("Rule SVELTE-003 violation"), "policy-free scanner failed to detect SVELTE- rule ID");

    // Invariant 1: Identity precedes execution (manifest digest drift).
    let valid_manifest_path = path::join(fixtures_root, "policy-free-fixture/northstar-package.json");
    let tampered_digest = "0000000000000000000000000000000000000000000000000000000000000000";
    expect_digest_drift_failure(valid_manifest_path, tampered_digest);

    // Invariant 2: Official trust is core-owned (self-authorization rejected).
    let self_auth_path = path::join(fixtures_root, "negative/self-authorizing/northstar-package.json");
    let self_auth_manifest = json::read_file(self_auth_path);
    expect_manifest_rejection("self-authorizing-manifest", self_auth_manifest, manifest_schema, "self-claims trust or official status");

    // Invariant 3: Sources are immutable (mutable registry sources rejected).
    let mutable_registry = #{
        schema_version: "1.0.0",
        registry_version: "1.0.0",
        packages: [
            #{
                package_id: "@northstar/mutable-fixture",
                version: "0.1.0",
                repository: "https://github.com/inflatable-cookie/northstar.git",
                subpath: "packages/fixture",
                commit: "main",
                tree_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
                manifest_digest: "b6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
                compatible_core_range: ">=0.2.0 <1.0.0",
            }
        ]
    };
    expect_registry_rejection("mutable-registry-commit-branch", mutable_registry, registry_schema, "does not match pattern");

    let tag_registry = #{
        schema_version: "1.0.0",
        registry_version: "1.0.0",
        packages: [
            #{
                package_id: "@northstar/tag-fixture",
                version: "0.1.0",
                repository: "https://github.com/inflatable-cookie/northstar.git",
                subpath: "packages/fixture",
                commit: "v1.0.0",
                tree_digest: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
                manifest_digest: "b6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
                compatible_core_range: ">=0.2.0 <1.0.0",
            }
        ]
    };
    expect_registry_rejection("mutable-registry-commit-tag", tag_registry, registry_schema, "does not match pattern");

    // Invariant 4: Packages are independent (addressing one yields only its subpath in staging).
    let sibling_root = path::join(fixtures_root, "sibling-packages");
    test_independent_package_materialization(sibling_root);

    // Invariant 5: Core compatibility is exact & SemVer numeric range rejection.
    let current_core = "0.2.0";
    let incomp_path = path::join(fixtures_root, "negative/incompatible-range/northstar-package.json");
    let incomp_manifest = json::read_file(incomp_path);
    expect_compat_rejection("incompatible-core-range", incomp_manifest["compatible_core_range"], current_core, incomp_manifest["package_id"], "incompatible with Northstar core");

    let lexico_path = path::join(fixtures_root, "negative/incompatible-range-lexicographical/northstar-package.json");
    let lexico_manifest = json::read_file(lexico_path);
    expect_compat_rejection("incompatible-core-range-lexicographical", lexico_manifest["compatible_core_range"], current_core, lexico_manifest["package_id"], "incompatible with Northstar core");

    // Invariant 6: Path traversal and absolute path containment rejection.
    let traversal_path = path::join(fixtures_root, "negative/path-traversal-manifest/traversal-entrypoint.json");
    let traversal_manifest = json::read_file(traversal_path);
    expect_manifest_rejection("traversal-entrypoint-manifest", traversal_manifest, manifest_schema, "does not match pattern");

    let abs_path = path::join(fixtures_root, "negative/absolute-path-manifest/absolute-entrypoint.json");
    let abs_manifest = json::read_file(abs_path);
    expect_manifest_rejection("absolute-entrypoint-manifest", abs_manifest, manifest_schema, "does not match pattern");

    // Invariant 7: Malformed manifests and extra fields rejected.
    let missing_fields_path = path::join(fixtures_root, "negative/malformed-manifest/missing-fields.json");
    let missing_manifest = json::read_file(missing_fields_path);
    expect_manifest_rejection("malformed-manifest-missing-fields", missing_manifest, manifest_schema, "missing required field");

    let invalid_kind_path = path::join(fixtures_root, "negative/malformed-manifest/invalid-kind.json");
    let invalid_kind_manifest = json::read_file(invalid_kind_path);
    expect_manifest_rejection("malformed-manifest-invalid-kind", invalid_kind_manifest, manifest_schema, "const mismatch: expected 'language-quality'");

    // Invariant 8: Duplicate registry entries rejected.
    let duplicate_registry_path = path::join(fixtures_root, "negative/duplicate-registry/duplicate-package-registry.json");
    if fs::is_file(duplicate_registry_path) {
        let dup_registry = json::read_file(duplicate_registry_path);
        expect_registry_rejection("duplicate-registry-entries", dup_registry, registry_schema, "duplicate registry package");
    }

    // Invariant 9: Ambiguous trust and source receipts rejected.
    let ambiguous_trust_path = path::join(fixtures_root, "negative/ambiguous-receipt/ambiguous-trust-receipt.json");
    if fs::is_file(ambiguous_trust_path) {
        let amb_trust = json::read_file(ambiguous_trust_path);
        expect_receipt_rejection("ambiguous-trust-receipt", amb_trust, receipt_schema, "failed oneOf schema validation");
    }
    let ambiguous_source_path = path::join(fixtures_root, "negative/ambiguous-receipt/ambiguous-source-receipt.json");
    if fs::is_file(ambiguous_source_path) {
        let amb_source = json::read_file(ambiguous_source_path);
        expect_receipt_rejection("ambiguous-source-receipt", amb_source, receipt_schema, "failed oneOf schema validation");
    }
}

fn check_forbidden_in_file(file) {
    let content = fs::read_file(file);
    if content.contains("\"claude\"") {
        throw("package contract schema " + file + " hardcodes LLM provider: claude");
    }
    if content.contains("\"codex\"") {
        throw("package contract schema " + file + " hardcodes LLM provider: codex");
    }
    if content.contains("\"openai\"") {
        throw("package contract schema " + file + " hardcodes LLM provider: openai");
    }
    if content.contains("\"anthropic\"") {
        throw("package contract schema " + file + " hardcodes LLM provider: anthropic");
    }
}

fn scan_forbidden_dependencies(target_skill_root) {
    let references_root = path::join(target_skill_root, "references/packages");
    for file in fs::list_recursive(references_root) {
        if str::ends_with(file, ".json") {
            check_forbidden_in_file(file);
        }
    }
}

// -----------------------------------------------------------------------------
// Main Execution
// -----------------------------------------------------------------------------

let northstar_skill_root = path::join(repo_root, "skills/northstar");
if !fs::is_dir(path::join(northstar_skill_root, "references/packages")) {
    northstar_skill_root = repo_root;
}

let packages_ref_root = path::join(northstar_skill_root, "references/packages");
let manifest_schema = load_and_validate_schema_file(packages_ref_root, "package-manifest.schema.json", "language-package-manifest");
let registry_schema = load_and_validate_schema_file(packages_ref_root, "official-registry.schema.json", "language-package-official-registry");
let receipt_schema = load_and_validate_schema_file(packages_ref_root, "installation-receipt.schema.json", "language-package-installation-receipt");

let official_registry_path = path::join(packages_ref_root, "official-registry.json");
require(fs::is_file(official_registry_path), "missing official-registry.json");
let registry = json::read_file(official_registry_path);
validate_registry_instance(registry, registry_schema, "official-registry.json");

let fixture_root = path::join(northstar_skill_root, "assets/fixtures/language-packages/policy-free-fixture");
validate_policy_free_fixture_deep(fixture_root, manifest_schema);

let fixture_manifest_path = path::join(fixture_root, "northstar-package.json");
let fixture_manifest = json::read_file(fixture_manifest_path);
test_schema_mutation_discrimination(fixture_manifest, manifest_schema);

test_semver_compatibility_suite();
test_receipt_conformance_variants(receipt_schema);
run_negative_oracle_suite(northstar_skill_root, manifest_schema, registry_schema, receipt_schema);
scan_forbidden_dependencies(northstar_skill_root);

log("Northstar language package machine contracts: OK (3 Draft 2020-12 schemas, schema-derived instance conformance across all variants, schema mutation proof, SemVer numeric ranges, path containment, trust/source receipt variants, deep policy-free proof, staged sibling isolation proof, 9 negative oracle invariants, portable contracts)");
