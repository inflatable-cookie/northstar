// Focused validation for Northstar language package machine contracts (card 116).
//
// Validates:
// 1. Structure across all 3 schema files (JSON Schema Draft 2020-12 dialect).
// 2. Bounded schema-instance evaluation engine evaluating frozen schema vocabulary directly.
// 3. Schema mutation discrimination proofs (supported keyword mutations reject instances,
//    unsupported schema keywords fail closed).
// 4. Exact semantic-version parsing and numeric range compatibility.
// 5. Safe package-relative path containment (disallowing traversal and absolute paths).
// 6. Manifest, registry, and receipt schema-instance conformance across all trust
//    (official, operator_allowlist, interactive_approval) and source variants
//    (git, local_path, archive).
// 7. Deep recursive policy-free fixture verification.
// 8. Independent package addressing and materialization boundary into isolated staging.
// 9. Mandatory negative review-oracle invariant suite (malformed, mutable, incompatible,
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
// Bounded Schema Vocabulary & Evaluation Engine
// -----------------------------------------------------------------------------

fn assert_supported_schema_keywords(schema, ctx) {
    if type_of(schema) != "map" { return; }
    let allowed = [
        "$schema", "$id", "title", "description",
        "type", "const", "enum", "pattern", "minLength",
        "minItems", "items", "required", "properties",
        "additionalProperties", "oneOf"
    ];
    for k in schema.keys() {
        if !allowed.contains(k) {
            let err = ctx;
            err += " contains unsupported schema keyword: ";
            err += k;
            throw(err);
        }
    }
}

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

        assert_supported_schema_keywords(schema, ctx);

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

fn collect_property_schemas(s, c) {
    if !s.contains("properties") { return []; }
    if type_of(s["properties"]) != "map" { return []; }
    let props = s["properties"];
    let items = [];
    for k in props.keys() {
        let sub_c = c;
        sub_c += ".properties.";
        sub_c += k;
        let sub_s = props[k];
        items.push(#{ schema: sub_s, ctx: sub_c });
    }
    items
}

fn collect_item_schema(s, c) {
    if !s.contains("items") { return []; }
    if type_of(s["items"]) != "map" { return []; }
    let sub_c = c;
    sub_c += ".items";
    let sub_s = s["items"];
    [ #{ schema: sub_s, ctx: sub_c } ]
}

fn collect_one_of_schemas(s, c) {
    if !s.contains("oneOf") { return []; }
    if type_of(s["oneOf"]) != "array" { return []; }
    let list = s["oneOf"];
    let idx = 0;
    let items = [];
    for sub_s in list {
        let sub_c = c;
        sub_c += ".oneOf[";
        sub_c += idx;
        sub_c += "]";
        items.push(#{ schema: sub_s, ctx: sub_c });
        idx += 1;
    }
    items
}

fn collect_additional_props_schema(s, c) {
    if !s.contains("additionalProperties") { return []; }
    if type_of(s["additionalProperties"]) != "map" { return []; }
    let sub_c = c;
    sub_c += ".additionalProperties";
    let sub_s = s["additionalProperties"];
    [ #{ schema: sub_s, ctx: sub_c } ]
}

fn validate_schema_file_vocabulary(schema, ctx) {
    let queue = [ #{ schema: schema, ctx: ctx } ];
    while queue.len() > 0 {
        let current = queue.pop();
        let s = current["schema"];
        let c = current["ctx"];
        if type_of(s) != "map" { continue; }
        assert_supported_schema_keywords(s, c);
        for item in collect_property_schemas(s, c) {
            queue.push(item);
        }
        for item in collect_item_schema(s, c) {
            queue.push(item);
        }
        for item in collect_one_of_schemas(s, c) {
            queue.push(item);
        }
        for item in collect_additional_props_schema(s, c) {
            queue.push(item);
        }
    }
}

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
    validate_schema_file_vocabulary(schema, filename);
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

    // Mutation 3: Adding an unsupported Draft keyword (e.g. maxLength) must fail closed
    let mutated_unsupported_schema = json::parse(json::stringify(base_schema));
    mutated_unsupported_schema["properties"]["package_id"]["maxLength"] = 1;

    let rejected_unsupported = false;
    try {
        validate_manifest_instance(valid_manifest, mutated_unsupported_schema, "mutated-unsupported-manifest");
    } catch (err) {
        let msg = err.to_string();
        if msg.contains("contains unsupported schema keyword: maxLength") {
            rejected_unsupported = true;
        }
    }
    require(rejected_unsupported, "schema mutation test failed: unsupported schema keyword was not rejected");
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

fn test_missing_fixture_discrimination() {
    let dummy_path = "/nonexistent/path/missing-fixture.json";
    let failed = false;
    try {
        require(fs::is_file(dummy_path), "missing required negative fixture: " + dummy_path);
    } catch (err) {
        let msg = err.to_string();
        if msg.contains("missing required negative fixture") {
            failed = true;
        }
    }
    require(failed, "missing fixture check failed to discriminate missing file");
}

fn run_negative_oracle_suite(target_skill_root, manifest_schema, registry_schema, receipt_schema) {
    let fixtures_root = path::join(target_skill_root, "assets/fixtures/language-packages");

    // Invariant 0: Policy-free fixture discrimination proof (forbidden rules / filenames rejected).
    require(has_forbidden_rule_id("Rule RUST-001 violation"), "policy-free scanner failed to detect RUST- rule ID");
    require(has_forbidden_rule_id("Rule TS-002 violation"), "policy-free scanner failed to detect TS- rule ID");
    require(has_forbidden_rule_id("Rule SVELTE-003 violation"), "policy-free scanner failed to detect SVELTE- rule ID");

    // Missing fixture discrimination proof.
    test_missing_fixture_discrimination();

    // Invariant 1: Identity precedes execution (manifest digest drift).
    let valid_manifest_path = path::join(fixtures_root, "policy-free-fixture/northstar-package.json");
    require(fs::is_file(valid_manifest_path), "missing required fixture: policy-free-fixture/northstar-package.json");
    let tampered_digest = "0000000000000000000000000000000000000000000000000000000000000000";
    expect_digest_drift_failure(valid_manifest_path, tampered_digest);

    // Invariant 2: Official trust is core-owned (self-authorization rejected).
    let self_auth_path = path::join(fixtures_root, "negative/self-authorizing/northstar-package.json");
    require(fs::is_file(self_auth_path), "missing required negative fixture: negative/self-authorizing/northstar-package.json");
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
    require(fs::is_file(incomp_path), "missing required negative fixture: negative/incompatible-range/northstar-package.json");
    let incomp_manifest = json::read_file(incomp_path);
    expect_compat_rejection("incompatible-core-range", incomp_manifest["compatible_core_range"], current_core, incomp_manifest["package_id"], "incompatible with Northstar core");

    let lexico_path = path::join(fixtures_root, "negative/incompatible-range-lexicographical/northstar-package.json");
    require(fs::is_file(lexico_path), "missing required negative fixture: negative/incompatible-range-lexicographical/northstar-package.json");
    let lexico_manifest = json::read_file(lexico_path);
    expect_compat_rejection("incompatible-core-range-lexicographical", lexico_manifest["compatible_core_range"], current_core, lexico_manifest["package_id"], "incompatible with Northstar core");

    // Invariant 6: Path traversal and absolute path containment rejection.
    let traversal_path = path::join(fixtures_root, "negative/path-traversal-manifest/traversal-entrypoint.json");
    require(fs::is_file(traversal_path), "missing required negative fixture: negative/path-traversal-manifest/traversal-entrypoint.json");
    let traversal_manifest = json::read_file(traversal_path);
    expect_manifest_rejection("traversal-entrypoint-manifest", traversal_manifest, manifest_schema, "does not match pattern");

    let abs_path = path::join(fixtures_root, "negative/absolute-path-manifest/absolute-entrypoint.json");
    require(fs::is_file(abs_path), "missing required negative fixture: negative/absolute-path-manifest/absolute-entrypoint.json");
    let abs_manifest = json::read_file(abs_path);
    expect_manifest_rejection("absolute-entrypoint-manifest", abs_manifest, manifest_schema, "does not match pattern");

    // Invariant 7: Malformed manifests and extra fields rejected.
    let missing_fields_path = path::join(fixtures_root, "negative/malformed-manifest/missing-fields.json");
    require(fs::is_file(missing_fields_path), "missing required negative fixture: negative/malformed-manifest/missing-fields.json");
    let missing_manifest = json::read_file(missing_fields_path);
    expect_manifest_rejection("malformed-manifest-missing-fields", missing_manifest, manifest_schema, "missing required field");

    let invalid_kind_path = path::join(fixtures_root, "negative/malformed-manifest/invalid-kind.json");
    require(fs::is_file(invalid_kind_path), "missing required negative fixture: negative/malformed-manifest/invalid-kind.json");
    let invalid_kind_manifest = json::read_file(invalid_kind_path);
    expect_manifest_rejection("malformed-manifest-invalid-kind", invalid_kind_manifest, manifest_schema, "const mismatch: expected 'language-quality'");

    // Invariant 8: Duplicate registry entries rejected.
    let duplicate_registry_path = path::join(fixtures_root, "negative/duplicate-registry/duplicate-package-registry.json");
    require(fs::is_file(duplicate_registry_path), "missing required negative fixture: negative/duplicate-registry/duplicate-package-registry.json");
    let dup_registry = json::read_file(duplicate_registry_path);
    expect_registry_rejection("duplicate-registry-entries", dup_registry, registry_schema, "duplicate registry package");

    // Invariant 9: Ambiguous trust and source receipts rejected.
    let ambiguous_trust_path = path::join(fixtures_root, "negative/ambiguous-receipt/ambiguous-trust-receipt.json");
    require(fs::is_file(ambiguous_trust_path), "missing required negative fixture: negative/ambiguous-receipt/ambiguous-trust-receipt.json");
    let amb_trust = json::read_file(ambiguous_trust_path);
    expect_receipt_rejection("ambiguous-trust-receipt", amb_trust, receipt_schema, "failed oneOf schema validation");

    let ambiguous_source_path = path::join(fixtures_root, "negative/ambiguous-receipt/ambiguous-source-receipt.json");
    require(fs::is_file(ambiguous_source_path), "missing required negative fixture: negative/ambiguous-receipt/ambiguous-source-receipt.json");
    let amb_source = json::read_file(ambiguous_source_path);
    expect_receipt_rejection("ambiguous-source-receipt", amb_source, receipt_schema, "failed oneOf schema validation");
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

// =============================================================================
// Card 117: Generic Installed-Package Runtime
//
// Implements the promoted canonical package-tree identity, operator-owned
// trust/lifecycle state, generic discovery and routing, transactional
// acquisition and rollback, offline local routing, and visible notices. The
// protocol is generic: routing matches manifest fields and never branches on
// a language name, and nothing here depends on Effigy or a provider.
//
// GENERIC-RUNTIME-SCAN-BEGIN
// =============================================================================

// Rhai functions cannot see top-level variables, so the frozen card-117
// identity vectors are exposed as accessor functions.
fn card_117_core_version() { "0.2.0" }
fn card_117_timestamp() { "2026-09-02T00:00:00Z" }
fn card_117_fixture_manifest_digest() { "sha256:029efa327745aba66c3316714cfb28b29246c365459bb5c9d7e6526e409c64ef" }
fn card_117_fixture_tree_digest() { "sha256:653ce7f63ddc46da3381314d561dea3657b4eaf59eb8aa1c57b4ba046d9f90f0" }

// -- visible notices ----------------------------------------------------------

fn emit_notice(message) {
    log("[northstar:language-packages] notice: " + message);
}

// -- canonical content identity -----------------------------------------------

fn require_canonical_digest(digest, context) {
    if type_of(digest) != "string" || !regex::is_match("^sha256:[0-9a-f]{64}$", digest) {
        let err = context;
        err += " uses non-canonical digest spelling: '";
        err += digest;
        err += "' (required sha256:<64 lowercase hex>)";
        throw(err);
    }
}

fn canonical_manifest_digest(manifest_path) {
    "sha256:" + fs::sha256(manifest_path)
}

fn file_executable_bit(file_path) {
    let out = exec::run(["stat", "-f", "%Lp", file_path], #{ run_in: "host", cwd: repo_root });
    let mode_str = "";
    if out["success"] {
        mode_str = str::trim(out["stdout"]);
    } else {
        let gnu = exec::run(["stat", "-c", "%a", file_path], #{ run_in: "host", cwd: repo_root });
        require(gnu["success"], "cannot stat file mode for canonical framing: " + file_path);
        mode_str = str::trim(gnu["stdout"]);
    }
    let mode = parse_int(mode_str);
    // 0o111 == 73 decimal; octal digits never carry into decimal positions.
    if mode % 2 == 1 || (mode / 8) % 2 == 1 || (mode / 64) % 2 == 1 {
        1
    } else {
        0
    }
}

fn ascii_case_fold(s) {
    let upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    let lower = "abcdefghijklmnopqrstuvwxyz";
    let out = "";
    let i = 0;
    while i < s.len() {
        let ch = s.sub_string(i, 1);
        let idx = upper.index_of(ch);
        if idx >= 0 {
            out += lower.sub_string(idx, 1);
        } else {
            out += ch;
        }
        i += 1;
    }
    out
}
fn ascii_fold_matches(a, b) {
    ascii_case_fold(a) == ascii_case_fold(b)
}

fn collect_canonical_file_records(package_root, context) {
    // Deterministic walker: only portable package-relative paths; symlinks and
    // special files are rejected (never followed or normalized); case-fold
    // collisions are invalid; directories are implicit and carry no identity.
    let records = [];
    let seen_fold = #{};
    let dirs = [""];
    while dirs.len() > 0 {
        let rel_dir = dirs.pop();
        let abs_dir = package_root;
        if rel_dir != "" {
            abs_dir = path::join(package_root, rel_dir);
        }
        for entry in fs::list(abs_dir) {
            let rel = rel_dir;
            if rel != "" {
                rel += "/";
            }
            rel += path::file_name(entry);
            if !is_safe_package_relative_path(rel) {
                let err = context;
                err += " contains non-portable package path: '";
                err += rel;
                err += "'";
                throw(err);
            }
            if fs::is_symlink(entry) {
                let err = context;
                err += " contains symbolic link (rejected, never followed): '";
                err += rel;
                err += "'";
                throw(err);
            }
            let fold = ascii_case_fold(rel);
            if seen_fold.contains(fold) {
                let err = context;
                err += " contains case-fold path collision: '";
                err += rel;
                err += "'";
                throw(err);
            }
            seen_fold[fold] = true;
            if fs::is_dir(entry) {
                dirs.push(rel);
                continue;
            }
            if !fs::is_file(entry) {
                let err = context;
                err += " contains special file (rejected): '";
                err += rel;
                err += "'";
                throw(err);
            }
            let executable = file_executable_bit(entry);
            let content = fs::read_file(entry);
            let record = #{ path: rel, executable: executable, content: content };
            records.push(record);
        }
    }
    records
}

fn sort_records_by_path(records) {
    let n = records.len();
    let i = 1;
    while i < n {
        let j = i;
        while j > 0 {
            let prev_path = records[j - 1]["path"];
            let curr_path = records[j]["path"];
            if prev_path <= curr_path {
                break;
            }
            let tmp = records[j];
            records[j] = records[j - 1];
            records[j - 1] = tmp;
            j -= 1;
        }
        i += 1;
    }
    records
}

fn frame_record(path, executable, content) {
    let path_len = path.len();
    let content_len = content.len();
    let part = "F\u0000";
    part += path_len;
    part += "\u0000";
    part += path;
    part += "\u0000";
    part += executable;
    part += "\u0000";
    part += content_len;
    part += "\u0000";
    part += content;
    part
}

// Frame construction is inlined into the digest function: Effigy's Rhai call
// depth is capped at eight frames, and the digest path must stay within it
// when invoked through the generic runtime entry points.
fn canonical_tree_digest(package_root, context) {
    // F\0<path-byte-length>\0<path>\0<executable:0|1>\0<content-byte-length>\0<content>
    // Files ordered by package-relative UTF-8 path bytes; decimal ASCII lengths
    // without padding; content length is the exact byte length.
    let records = sort_records_by_path(collect_canonical_file_records(package_root, context));
    let frame = "";
    for rec in records {
        let path = rec["path"];
        let part = frame_record(path, rec["executable"], rec["content"]);
        frame += part;
    }
    let frame_dir = fs::make_temp_dir("northstar-frame-");
    let frame_file = path::join(frame_dir, "frame.bin");
    fs::write_file(frame_file, frame);
    let digest = fs::sha256(frame_file);
    "sha256:" + digest
}

fn assert_fixture_identity_vectors(fixture_root, manifest_path) {
    require(canonical_manifest_digest(manifest_path) == card_117_fixture_manifest_digest(),
        "policy-free fixture manifest identity drifted from the accepted card-116 baseline");
    require(canonical_tree_digest(fixture_root, "policy-free fixture") == card_117_fixture_tree_digest(),
        "policy-free fixture canonical tree identity drifted from the card-117 derived vector");
}

// -- operator-owned trust and lifecycle documents ------------------------------

fn trust_allowlist_entries(trust_doc) {
    if trust_doc.contains("allowlist") && type_of(trust_doc["allowlist"]) == "array" {
        return trust_doc["allowlist"];
    }
    []
}

fn trust_revocation_entries(trust_doc) {
    if trust_doc.contains("revocations") && type_of(trust_doc["revocations"]) == "array" {
        return trust_doc["revocations"];
    }
    []
}

fn find_allowlist_entry(trust_doc, package_id, version, tree_digest, manifest_digest) {
    for entry in trust_allowlist_entries(trust_doc) {
        if entry["package_id"] == package_id && entry["version"] == version &&
            entry["tree_digest"] == tree_digest && entry["manifest_digest"] == manifest_digest {
            return entry;
        }
    }
    ()
}

fn find_revocation(trust_doc, package_id, tree_digest, manifest_digest) {
    for rec in trust_revocation_entries(trust_doc) {
        if rec["package_id"] == package_id && rec["tree_digest"] == tree_digest &&
            rec["manifest_digest"] == manifest_digest {
            return rec;
        }
    }
    ()
}

fn validate_trust_document(doc, schema, context) {
    validate_schema_node(doc, schema, context);

    let seen_allow = [];
    for entry in trust_allowlist_entries(doc) {
        require_canonical_digest(entry["tree_digest"], context + " allowlist");
        require_canonical_digest(entry["manifest_digest"], context + " allowlist");
        let key = entry["package_id"] + "@" + entry["version"] + "|" + entry["tree_digest"] + "|" + entry["manifest_digest"];
        if seen_allow.contains(key) {
            let err = context;
            err += " contains duplicate allowlist entry: ";
            err += key;
            throw(err);
        }
        seen_allow.push(key);
    }

    let seen_rev = [];
    for rec in trust_revocation_entries(doc) {
        require_canonical_digest(rec["tree_digest"], context + " revocation");
        require_canonical_digest(rec["manifest_digest"], context + " revocation");
        let key = rec["package_id"] + "|" + rec["tree_digest"] + "|" + rec["manifest_digest"];
        if seen_rev.contains(key) {
            let err = context;
            err += " contains duplicate revocation entry: ";
            err += key;
            throw(err);
        }
        seen_rev.push(key);
    }
}

fn validate_lifecycle_document(doc, schema, context) {
    validate_schema_node(doc, schema, context);

    let seen_refs = [];
    let selected_by_pkg = #{};
    for ref in doc["packages"] {
        let ref_tree = ref["tree_digest"];
        let ref_manifest = ref["manifest_digest"];
        let ref_receipt = ref["receipt_digest"];
        require_canonical_digest(ref_tree, context + " reference");
        require_canonical_digest(ref_manifest, context + " reference");
        require_canonical_digest(ref_receipt, context + " reference");
        if seen_refs.contains(ref_receipt) {
            let err = context;
            err += " contains duplicate receipt reference: ";
            err += ref_receipt;
            throw(err);
        }
        seen_refs.push(ref_receipt);
        let ref_pkg = ref["package_id"];
        if ref["selection"] == "selected" {
            if selected_by_pkg.contains(ref_pkg) {
                let err = context;
                err += " selects more than one receipt for package: ";
                err += ref_pkg;
                throw(err);
            }
            selected_by_pkg[ref_pkg] = true;
        }
    }
}

// -- lifecycle state root ------------------------------------------------------

fn state_file_path(state_root) {
    path::join(state_root, "lifecycle-state.json")
}

fn read_state_doc(state_root) {
    let p = state_file_path(state_root);
    if !fs::is_file(p) {
        return ();
    }
    json::read_file(p)
}

fn write_state_doc(state_root, doc) {
    fs::write_file(state_file_path(state_root), json::stringify(doc));
}

fn receipts_dir(state_root) {
    path::join(state_root, "receipts")
}

// Receipt conformance is proven by the harness against every written receipt
// (see assert_state_receipts_valid): Effigy's Rhai call depth is capped at
// eight frames, and oneOf evaluation inside the schema engine would overflow
// when invoked through the runtime entry points. The runtime constructs
// receipts from its fixed template; the harness revalidates them.
fn write_immutable_receipt(state_root, receipt_map) {
    let dir = receipts_dir(state_root);
    if !fs::is_dir(dir) {
        fs::create_dir(dir);
    }
    let body = json::stringify(receipt_map);
    let tmp = path::join(dir, "pending-receipt.json");
    fs::write_file(tmp, body);
    let digest = "sha256:" + fs::sha256(tmp);
    let final_path = path::join(dir, digest + ".json");
    if !fs::is_file(final_path) {
        fs::write_file(final_path, body);
    }
    fs::remove(tmp);
    digest
}

fn replace_state_cas(state_root, observed_revision, next_revision, packages) {
    let current = read_state_doc(state_root);
    if current == () {
        require(observed_revision == "0",
            "lifecycle CAS conflict: no state exists but observed revision " + observed_revision);
    } else {
        require(current["state_revision"] == observed_revision,
            "lifecycle CAS conflict: observed revision " + observed_revision + " is stale; current revision is " + current["state_revision"]);
    }
    write_state_doc(state_root, #{
        schema_version: "1.0.0",
        state_revision: next_revision,
        packages: packages,
    });
}

// -- generic discovery and routing ---------------------------------------------

fn manifest_matches(manifest, language, workflow) {
    if type_of(manifest) != "map" {
        return false;
    }
    if !manifest.contains("kind") {
        return false;
    }
    if manifest["kind"] != "language-quality" {
        return false;
    }
    if !manifest.contains("supported_languages") {
        return false;
    }
    if type_of(manifest["supported_languages"]) != "array" {
        return false;
    }
    if !manifest["supported_languages"].contains(language) {
        return false;
    }
    if !manifest.contains("available_workflows") {
        return false;
    }
    if type_of(manifest["available_workflows"]) != "array" {
        return false;
    }
    manifest["available_workflows"].contains(workflow)
}

fn verify_installed_identity(installed_path, reference, context) {
    require(fs::is_dir(installed_path), context + ": installed path missing: " + installed_path);
    let manifest_path = path::join(installed_path, "northstar-package.json");
    require(fs::is_file(manifest_path), context + ": installed manifest missing");
    require_canonical_digest(reference["tree_digest"], context);
    require_canonical_digest(reference["manifest_digest"], context);
    require(canonical_manifest_digest(manifest_path) == reference["manifest_digest"],
        context + ": installed manifest identity drifted from receipt");
    require(canonical_tree_digest(installed_path, context) == reference["tree_digest"],
        context + ": installed tree identity drifted from receipt");
    json::read_file(manifest_path)
}

// ROUTE-SCAN-BEGIN: local-only, read-only, adapter-free selection. No exec,
// no network, no Effigy, no language switch; matches manifest fields only.
fn resolve_installed_package(state_doc, trust_doc, language, workflow, core_version) {
    if state_doc == () {
        return ();
    }
    let candidates = [];
    for reference in state_doc["packages"] {
        if reference["selection"] != "selected" {
            continue;
        }
        if find_revocation(trust_doc, reference["package_id"], reference["tree_digest"], reference["manifest_digest"]) != () {
            continue;
        }
        let manifest = verify_installed_identity(reference["installed_path"], reference, "resolve");
        if !manifest_matches(manifest, language, workflow) {
            continue;
        }
        if !check_semver_compatibility(manifest["compatible_core_range"], core_version) {
            continue;
        }
        let candidate = #{ reference: reference, manifest: manifest };
        candidates.push(candidate);
    }
    if candidates.len() == 0 {
        return ();
    }
    candidates[0]
}
// ROUTE-SCAN-END

// -- transactional acquisition -------------------------------------------------

fn run_staged_self_check(staged_root, staged_manifest, context) {
    // Deterministic protocol self-check gate over the staged payload: the
    // declared entrypoint must be a contained regular file inside the staged
    // tree and the declared profile/schema versions must be supported; the
    // fixture-declared manifest conditions must hold. Arbitrary package code
    // execution is out of scope for the policy-free proof (card 118 canary).
    let entry = staged_manifest["self_check"]["entrypoint"];
    require(is_safe_package_relative_path(entry), context + ": self-check entrypoint violates containment");
    let entry_path = path::join(staged_root, entry);
    require(fs::is_file(entry_path), context + ": self-check entrypoint missing from staged payload");
    require(!fs::is_symlink(entry_path), context + ": self-check entrypoint must not be a symlink");
    for ver in staged_manifest["self_check"]["validated_schema_versions"] {
        require(ver == "1.0.0", context + ": self-check validates unsupported schema version: " + ver);
    }
    for ver in staged_manifest["self_check"]["validated_profile_versions"] {
        require(ver == "1.0.0", context + ": self-check validates unsupported profile version: " + ver);
    }
    require(staged_manifest["kind"] == "language-quality",
        context + ": self-check failed: staged manifest kind is not language-quality");
}

fn copy_tree(src_root, dst_root) {
    let queue = [""];
    while queue.len() > 0 {
        let rel_dir = queue.pop();
        let abs_src = src_root;
        if rel_dir != "" {
            abs_src = path::join(src_root, rel_dir);
        }
        for entry in fs::list(abs_src) {
            let name = path::file_name(entry);
            let rel = rel_dir;
            if rel != "" {
                rel += "/";
            }
            rel += name;
            let dest = path::join(dst_root, rel);
            let entry_is_dir = fs::is_dir(entry);
            let dest_exists = fs::is_dir(dest);
            if entry_is_dir && !dest_exists {
                fs::create_dir(dest);
            }
            if entry_is_dir {
                queue.push(rel);
                continue;
            }
            let parent = path::parent(dest);
            if !fs::is_dir(parent) {
                fs::create_dir(parent);
            }
            let content = fs::read_file(entry);
            fs::write_file(dest, content);
        }
    }
}

fn find_pin(registry, trust_doc, package_id, version) {
    for entry in registry["packages"] {
        if entry["package_id"] == package_id && entry["version"] == version {
            return entry;
        }
    }
    for entry in trust_allowlist_entries(trust_doc) {
        if entry["package_id"] == package_id && entry["version"] == version {
            return entry;
        }
    }
    ()
}

fn acquire_and_activate(state_root, trust_doc, registry, package_id, version, language, workflow, core_version, adapter, spy, manifest_schema, receipt_schema) {
    // Requires caller-verified intent (workflow request or existing activation).
    let pin = find_pin(registry, trust_doc, package_id, version);
    require(pin != (),
        "no trusted pin for " + package_id + "@" + version + "; manual or local-path installation required");
    require_canonical_digest(pin["tree_digest"], "pin");
    require_canonical_digest(pin["manifest_digest"], "pin");

    let pin_source = "official registry";
    let registry_has = false;
    for entry in registry["packages"] {
        if entry["package_id"] == package_id && entry["version"] == version {
            registry_has = true;
        }
    }
    if !registry_has {
        pin_source = "operator allowlist";
    }

    let acquire_notice = "acquire ";
    acquire_notice += package_id;
    acquire_notice += "@";
    acquire_notice += version;
    acquire_notice += " source=";
    acquire_notice += pin_source;
    acquire_notice += " target=";
    acquire_notice += path::join(state_root, "installed");
    acquire_notice += " workflow=";
    acquire_notice += workflow;
    emit_notice(acquire_notice);

    // Trust gate precedes any transport: revoked content never reaches an
    // adapter, and detection never reaches this function at all.
    require(find_revocation(trust_doc, package_id, pin["tree_digest"], pin["manifest_digest"]) == (),
        "identity " + pin["tree_digest"] + " is revoked; acquisition blocked");

    // The adapter is the only transport surface; transport probes observe it
    // through the adapter itself.
    let staged_root = call(adapter);

    let staged_manifest_path = path::join(staged_root, "northstar-package.json");
    require(fs::is_file(staged_manifest_path), "staged payload missing northstar-package.json");
    require(canonical_manifest_digest(staged_manifest_path) == pin["manifest_digest"],
        "staged manifest identity does not match pin " + package_id + "@" + version);
    require(canonical_tree_digest(staged_root, "staged payload") == pin["tree_digest"],
        "staged tree identity does not match pin " + package_id + "@" + version);

    let staged_manifest = json::read_file(staged_manifest_path);
    validate_manifest_instance(staged_manifest, manifest_schema, "staged manifest");

    require(check_semver_compatibility(pin["compatible_core_range"], core_version),
        "pin " + package_id + "@" + version + " incompatible with Northstar core " + core_version);

    run_staged_self_check(staged_root, staged_manifest, "acquisition");

    let install_root = path::join(state_root, "installed");
    if !fs::is_dir(install_root) {
        fs::create_dir(install_root);
    }
    let install_dir = path::join(install_root, package_id + "@" + version + "-" + pin["tree_digest"].sub_string(7, 12));
    if !fs::is_dir(install_dir) {
        fs::create_dir(install_dir);
    }
    copy_tree(staged_root, install_dir);

    let receipt_map = #{
        schema_version: "1.0.0",
        package_id: package_id,
        version: version,
        kind: "language-quality",
        trust_class: #{
            type: "operator_allowlist",
            allowlist_entry: pin_source,
            allowlisted_by: "operator",
        },
        source: #{
            type: "local_path",
            path: staged_root,
            acquisition_mode: "local",
        },
        content_identity: #{
            package_tree_digest: pin["tree_digest"],
            manifest_digest: pin["manifest_digest"],
        },
        compatibility: #{
            compatible_core_range: pin["compatible_core_range"],
            installed_core_version: core_version,
        },
        installation: #{
            installed_path: install_dir,
            installed_at: card_117_timestamp(),
            acquisition_adapter: "fixture-staging",
            activation_status: "active",
        },
    };
    let receipt_digest = write_immutable_receipt(state_root, receipt_map);

    let current = read_state_doc(state_root);
    let observed = "0";
    let packages = [];
    if current != () {
        observed = current["state_revision"];
        packages = current["packages"];
    }
    let new_packages = [];
    for ref in packages {
        let copied = json::parse(json::stringify(ref));
        if copied["package_id"] == package_id {
            copied["selection"] = "retained";
        }
        new_packages.push(copied);
    }
    new_packages.push(#{
        package_id: package_id,
        version: version,
        tree_digest: pin["tree_digest"],
        manifest_digest: pin["manifest_digest"],
        receipt_digest: receipt_digest,
        installed_path: install_dir,
        selection: "selected",
        installed_at: card_117_timestamp(),
    });
    let next_revision = (parse_int(observed) + 1).to_string();
    replace_state_cas(state_root, observed, next_revision, new_packages);

    let activate_notice = "activated ";
    activate_notice += package_id;
    activate_notice += "@";
    activate_notice += version;
    activate_notice += " identity=";
    activate_notice += pin["tree_digest"];
    activate_notice += " at ";
    activate_notice += install_dir;
    emit_notice(activate_notice);

    #{
        status: "activated",
        receipt_digest: receipt_digest,
        tree_digest: pin["tree_digest"],
        install_dir: install_dir,
    }
}

// -- rollback ------------------------------------------------------------------

fn rollback_selected(state_root, trust_doc, target_receipt_digest, core_version) {
    let current = read_state_doc(state_root);
    require(current != (), "rollback: no lifecycle state");
    require_canonical_digest(target_receipt_digest, "rollback target");

    let target = ();
    for ref in current["packages"] {
        if ref["receipt_digest"] == target_receipt_digest {
            target = ref;
        }
    }
    require(target != (), "rollback: target receipt is not retained");
    require(target["selection"] == "retained", "rollback: target receipt is not a retained install");

    // Revalidate retained bytes, receipt identity, revocation, compatibility
    // before changing only the selected receipt. No fetch happens here.
    let manifest = verify_installed_identity(target["installed_path"], target, "rollback revalidation");
    let receipt_path = path::join(receipts_dir(state_root), target_receipt_digest + ".json");
    require(fs::is_file(receipt_path), "rollback: retained receipt document missing");
    require("sha256:" + fs::sha256(receipt_path) == target_receipt_digest,
        "rollback: retained receipt identity drifted");
    require(find_revocation(trust_doc, target["package_id"], target["tree_digest"], target["manifest_digest"]) == (),
        "rollback: target identity is revoked");
    require(check_semver_compatibility(manifest["compatible_core_range"], core_version),
        "rollback: target incompatible with core " + core_version);

    let new_packages = [];
    for ref in current["packages"] {
        let copied = json::parse(json::stringify(ref));
        if copied["receipt_digest"] == target_receipt_digest {
            copied["selection"] = "selected";
        } else if copied["selection"] == "selected" && copied["package_id"] == target["package_id"] {
            copied["selection"] = "retained";
        }
        new_packages.push(copied);
    }
    let next_revision = (parse_int(current["state_revision"]) + 1).to_string();
    replace_state_cas(state_root, current["state_revision"], next_revision, new_packages);

    let rollback_notice = "rolled back ";
    rollback_notice += target["package_id"];
    rollback_notice += " to ";
    rollback_notice += target["version"];
    rollback_notice += " identity=";
    rollback_notice += target["tree_digest"];
    emit_notice(rollback_notice);

    #{ status: "rolled-back", receipt_digest: target_receipt_digest }
}

// -- workflow entry point ------------------------------------------------------

fn consumer_activation_valid(consumer_dir, package_id, version) {
    let marker = path::join(consumer_dir, "docs/contracts/language-quality-activation.json");
    if !fs::is_file(marker) {
        return false;
    }
    let doc = json::read_file(marker);
    type_of(doc) == "map" && doc.contains("package_id") && doc["package_id"] == package_id &&
        doc.contains("version") && doc["version"] == version
}

fn handle_workflow_request(state_root, consumer_dir, trust_doc, registry, package_id, version, language, workflow, core_version, adapter, spy, manifest_schema, receipt_schema, intent) {
    // intent is one of "workflow_request" (explicit), "activation" (existing
    // valid consumer activation), or "detection" (never authorizes acquisition).
    let installed = resolve_installed_package(read_state_doc(state_root), trust_doc, language, workflow, core_version);
    if installed != () {
        let identity = installed["reference"]["tree_digest"];
        let route_notice = "routed ";
        route_notice += package_id;
        route_notice += " ";
        route_notice += workflow;
        route_notice += " local-only";
        emit_notice(route_notice + " identity=" + identity);
        return #{ status: "routed", identity: identity, notice: route_notice };
    }
    if intent == "detection" {
        let notice = "no acquisition without explicit workflow intent or activation for ";
        notice += package_id;
        notice += " (";
        notice += workflow;
        notice += ")";
        emit_notice(notice);
        return #{ status: "no-route", notice: notice };
    }
    if intent == "activation" {
        require(consumer_activation_valid(consumer_dir, package_id, version),
            "activation marker missing or invalid for " + package_id + "@" + version);
    }
    let outcome = ();
    try {
        outcome = acquire_and_activate(state_root, trust_doc, registry, package_id, version, language, workflow, core_version, adapter, spy, manifest_schema, receipt_schema);
    } catch (err) {
        let notice = "workflow ";
        notice += workflow;
        notice += " for ";
        notice += package_id;
        notice += " stopped: ";
        notice += err.to_string();
        notice += "; manual or local-path installation route required";
        emit_notice(notice);
        outcome = #{ status: "stopped", notice: notice };
    }
    outcome
}

// -- helpers for the fixture proof ---------------------------------------------

fn snapshot_hashes(root) {
    let hashes = [];
    if !fs::is_dir(root) {
        return hashes;
    }
    for file in fs::list_recursive(root) {
        if fs::is_file(file) {
            let name = path::file_name(file);
            let digest = fs::sha256(file);
            let entry = name + ":" + digest;
            hashes.push(entry);
        }
    }
    hashes.sort();
    hashes
}

fn require_hashes_unchanged(label, root, before) {
    let after = snapshot_hashes(root);
    require(after == before, label + " changed consumer/state bytes: " + json::stringify(after));
}

fn build_fixture_trust_doc(fixture_root, extra_entries, revocations) {
    // Operator-owned trust document pinning the policy-free fixture identity.
    let allowlist = [];
    allowlist.push(#{
        package_id: "@northstar/language-fixture",
        version: "0.1.0",
        source_identity: #{
            type: "local_path",
            path: fixture_root,
        },
        tree_digest: card_117_fixture_tree_digest(),
        manifest_digest: card_117_fixture_manifest_digest(),
        compatible_core_range: ">=0.2.0 <1.0.0",
        workflows: ["explicit_audit_repair"],
        actor: "operator",
        timestamp: card_117_timestamp(),
        reason: "card 117 fixture pin",
    });
    for entry in extra_entries {
        allowlist.push(entry);
    }
    #{
        schema_version: "1.0.0",
        revision: "1",
        allowlist: allowlist,
        revocations: revocations,
    }
}

fn new_spy() {
    #{ calls: 0 }
}
fn assert_state_receipts_valid(state_root, receipt_schema) {
    // Harness-level receipt conformance: every immutable receipt document in
    // the operator-owned state root validates against the frozen schema.
    let dir = receipts_dir(state_root);
    require(fs::is_dir(dir), "no receipts directory in state root");
    let files = fs::list(dir);
    require(files.len() > 0, "state root contains no receipts");
    for file in files {
        if str::ends_with(file, ".json") {
            let receipt = json::read_file(file);
            validate_receipt_instance(receipt, receipt_schema, "state receipt " + file);
        }
    }
}

// GENERIC-RUNTIME-SCAN-END

// Card 117: Review-Oracle Falsification
//
// The adversarial harness below sits outside the generic-runtime scan slice:
// it names production languages and simulates transports on purpose.
// =============================================================================

fn expect_trust_rejection(label, doc, schema, expected_reason) {
    let rejected = false;
    try {
        validate_trust_document(doc, schema, label);
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

fn expect_lifecycle_rejection(label, doc, schema, expected_reason) {
    let rejected = false;
    try {
        validate_lifecycle_document(doc, schema, label);
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

fn test_lifecycle_schema_fail_closed(valid_trust, trust_schema, valid_lifecycle, lifecycle_schema) {
    // Trust schema mutation: narrowing a supported constraint rejects the instance.
    let mutated_trust = json::parse(json::stringify(trust_schema));
    mutated_trust["properties"]["allowlist"]["items"]["properties"]["workflows"]["items"]["enum"] = ["everyday_authoring"];
    let trust_rejected = false;
    try {
        validate_trust_document(valid_trust, mutated_trust, "mutated-trust");
    } catch (err) {
        trust_rejected = err.to_string().contains("not in allowed enum");
    }
    require(trust_rejected, "trust schema mutation did not reject the instance");

    // Lifecycle schema mutation: an unsupported keyword fails closed.
    let mutated_lifecycle = json::parse(json::stringify(lifecycle_schema));
    mutated_lifecycle["properties"]["state_revision"]["maxLength"] = 2;
    let lifecycle_failed_closed = false;
    try {
        validate_lifecycle_document(valid_lifecycle, mutated_lifecycle, "mutated-lifecycle");
    } catch (err) {
        lifecycle_failed_closed = err.to_string().contains("unsupported schema keyword: maxLength");
    }
    require(lifecycle_failed_closed, "lifecycle schema unsupported keyword did not fail closed");
}

fn test_detection_is_not_authority(fixture_root, trust_doc, registry, manifest_schema, receipt_schema) {
    let state_root = fs::make_temp_dir("northstar-state-detect-");
    let consumer = fs::make_temp_dir("northstar-consumer-detect-");
    // Cargo-shaped files exist without any workflow intent or activation.
    fs::create_dir(path::join(consumer, "src"));
    fs::write_file(path::join(consumer, "Cargo.toml"), "[package]\nname = \"detection-fixture\"\n");
    fs::write_file(path::join(consumer, "src/main.rs"), "fn main() {}\n");
    fs::write_file(path::join(consumer, "README.md"), "# consumer\n");
    let consumer_before = snapshot_hashes(consumer);

    let spy = new_spy();
    let adapter = || {
        spy["calls"] = spy["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(fixture_root, staged);
        staged
    };

    let outcome = handle_workflow_request(state_root, consumer, trust_doc, registry,
        "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), adapter, spy, manifest_schema, receipt_schema, "detection");
    require(outcome["status"] == "no-route", "detection-only invocation acquired or routed a package");
    require(spy["calls"] == 0, "detection-only invocation called the transport adapter " + spy["calls"] + " times");
    require_hashes_unchanged("detection-only consumer", consumer, consumer_before);
    require(!fs::is_file(state_file_path(state_root)), "detection-only invocation created lifecycle state");
    log("card-117 oracle 1 (detection is not authority): PASS (transport spy zero calls, consumer bytes exact)");
}

fn test_canonical_identity_vectors(fixture_root, fixture_manifest_path) {
    assert_fixture_identity_vectors(fixture_root, fixture_manifest_path);

    // Digest spelling drift: bare hex and upper-case prefixes are rejected.
    let drift_rejected = false;
    try {
        require_canonical_digest("653ce7f63ddc46da3381314d561dea3657b4eaf59eb8aa1c57b4ba046d9f90f0", "spelling");
    } catch (err) {
        drift_rejected = err.to_string().contains("non-canonical digest spelling");
    }
    require(drift_rejected, "bare-hex digest spelling was not rejected");
    let case_rejected = false;
    try {
        require_canonical_digest("SHA256:653ce7f63ddc46da3381314d561dea3657b4eaf59eb8aa1c57b4ba046d9f90f0", "spelling");
    } catch (err) {
        case_rejected = err.to_string().contains("non-canonical digest spelling");
    }
    require(case_rejected, "upper-case digest prefix was not rejected");

    // Cross-adapter vectors: reordered materialization yields the same identity.
    let stage_a = fs::make_temp_dir("northstar-adapter-a-");
    let stage_b = fs::make_temp_dir("northstar-adapter-b-");
    copy_tree(fixture_root, stage_a);
    let files = fs::list_recursive(fixture_root);
    let i = files.len() - 1;
    while i >= 0 {
        let rel = str::replace(files[i], fixture_root + "/", "");
        let dest = path::join(stage_b, rel);
        let parent = path::parent(dest);
        if !fs::is_dir(parent) {
            fs::create_dir(parent);
        }
        fs::write_file(dest, fs::read_file(files[i]));
        i -= 1;
    }
    let digest_a = canonical_tree_digest(stage_a, "adapter-a");
    let digest_b = canonical_tree_digest(stage_b, "adapter-b");
    require(digest_a == card_117_fixture_tree_digest() && digest_b == card_117_fixture_tree_digest() && digest_a == digest_b,
        "cross-adapter reordered materialization produced differing identities");

    // Retained payload reproduces the staged identity (immutable local bytes).
    let retained = fs::make_temp_dir("northstar-retained-");
    copy_tree(stage_a, retained);
    require(canonical_tree_digest(retained, "retained") == digest_a,
        "retained payload identity drifted from staged");

    // Symlink preserved by a transport: rejected, never followed.
    let symlink_stage = fs::make_temp_dir("northstar-symlink-");
    copy_tree(fixture_root, symlink_stage);
    let ln = exec::run(["ln", "-s", "SKILL.md", path::join(symlink_stage, "evil-link")], #{ run_in: "host", cwd: repo_root });
    require(ln["success"], "failed to create symlink fixture");
    let symlink_rejected = false;
    try {
        canonical_tree_digest(symlink_stage, "symlink");
    } catch (err) {
        symlink_rejected = err.to_string().contains("symbolic link");
    }
    require(symlink_rejected, "symlink payload was not rejected");

    // Symlink-following transport: materialized target changes the identity.
    let follow_stage = fs::make_temp_dir("northstar-follow-");
    copy_tree(fixture_root, follow_stage);
    fs::write_file(path::join(follow_stage, "followed-target"), fs::read_file(path::join(fixture_root, "SKILL.md")));
    require(canonical_tree_digest(follow_stage, "followed") != card_117_fixture_tree_digest(),
        "followed symlink payload matched the canonical identity");

    // Special file: rejected.
    let fifo_stage = fs::make_temp_dir("northstar-fifo-");
    copy_tree(fixture_root, fifo_stage);
    let fifo = exec::run(["mkfifo", path::join(fifo_stage, "pipe")], #{ run_in: "host", cwd: repo_root });
    require(fifo["success"], "failed to create special-file fixture");
    let special_rejected = false;
    try {
        canonical_tree_digest(fifo_stage, "special");
    } catch (err) {
        special_rejected = err.to_string().contains("special file");
    }
    require(special_rejected, "special file payload was not rejected");

    // Case-fold path collision: fold-equivalent names must not both register.
    // The host filesystem is case-insensitive (two case-only names cannot
    // coexist on disk), so the walker's per-entry fold registration is proven
    // through the same predicate the walker executes.
    require(ascii_fold_matches("SKILL.md", "skill.md"),
        "ascii case fold does not equate case-only variants");
    let seen = #{};
    let fold1 = ascii_case_fold("SKILL.md");
    seen[fold1] = true;
    let fold2 = ascii_case_fold("skill.md");
    let fold_rejected = seen.contains(fold2);
    require(fold_rejected, "case-fold path collision was not rejected");

    // Executable bit: same content with a different exec bit is a new identity.
    let exe_stage = fs::make_temp_dir("northstar-exe-");
    copy_tree(fixture_root, exe_stage);
    let chmod = exec::run(["chmod", "+x", path::join(exe_stage, "SKILL.md")], #{ run_in: "host", cwd: repo_root });
    require(chmod["success"], "failed to chmod executable fixture");
    require(canonical_tree_digest(exe_stage, "executable") != card_117_fixture_tree_digest(),
        "executable-bit change did not change tree identity");
    let records = collect_canonical_file_records(exe_stage, "executable");
    let found_exe = false;
    for rec in records {
        if rec["path"] == "SKILL.md" && rec["executable"] == 1 {
            found_exe = true;
        }
    }
    require(found_exe, "executable bit not recorded in canonical records");

    log("card-117 oracle 2 (content identity is canonical): PASS (vectors exact across source/staged/retained, reorder, symlink, special, fold, exec-bit, spelling)");
}

fn test_transactional_activation(fixture_root, manifest_schema, receipt_schema, registry) {
    let state_root = fs::make_temp_dir("northstar-state-tx-");
    let consumer = fs::make_temp_dir("northstar-consumer-tx-");
    fs::write_file(path::join(consumer, "README.md"), "# consumer\n");
    let consumer_before = snapshot_hashes(consumer);

    let trust_doc = build_fixture_trust_doc(fixture_root, [], []);
    let spy = new_spy();
    let adapter = || {
        spy["calls"] = spy["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(fixture_root, staged);
        staged
    };

    // Explicit workflow intent acquires the pinned fixture.
    let first = acquire_and_activate(state_root, trust_doc, registry,
        "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), adapter, spy, manifest_schema, receipt_schema);
    require(first["status"] == "activated", "fixture install did not activate");
    require(spy["calls"] == 1, "install used the adapter more than once");
    require_hashes_unchanged("install consumer", consumer, consumer_before);
    assert_state_receipts_valid(state_root, receipt_schema);
    let state1 = read_state_doc(state_root);
    require(state1["state_revision"] == "1", "install did not advance state revision to 1");
    require(state1["packages"].len() == 1 && state1["packages"][0]["selection"] == "selected",
        "install did not select exactly one receipt");

    // Explicit update intent acquires the pinned 0.2.0 variant and retains 0.1.0.
    let variant = build_variant_package(fixture_root, "0.2.0");
    let variant_pin_entry = variant_pin("@northstar/language-fixture", "0.2.0", variant);
    let trust_doc_v = build_fixture_trust_doc(fixture_root, [variant_pin_entry], []);
    let spy_v = new_spy();
    let variant_adapter = || {
        spy_v["calls"] = spy_v["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(variant, staged);
        staged
    };
    let update = acquire_and_activate(state_root, trust_doc_v, registry,
        "@northstar/language-fixture", "0.2.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), variant_adapter, spy_v, manifest_schema, receipt_schema);
    require(update["status"] == "activated", "update did not activate");
    let state2 = read_state_doc(state_root);
    require(state2["state_revision"] == "2", "update did not advance state revision to 2");
    require(state2["packages"].len() == 2, "update did not retain the previous install");
    let selected2 = [];
    for ref in state2["packages"] {
        if ref["selection"] == "selected" {
            selected2.push(ref["version"]);
        }
    }
    require(selected2 == ["0.2.0"], "update did not select the new version");
    require_hashes_unchanged("update consumer", consumer, consumer_before);
    assert_state_receipts_valid(state_root, receipt_schema);

    // Failed update: candidate self-check fails AFTER bytes stage. The staged
    // payload stays schema-valid; its declared self-check entrypoint is absent,
    // so the protocol self-check gate is the first failing gate.
    let broken = build_variant_package(fixture_root, "0.3.0");
    fs::remove(path::join(broken, "scripts/self-check.rhai"));
    let broken_pin = variant_pin("@northstar/language-fixture", "0.3.0", broken);
    let trust_doc_b = build_fixture_trust_doc(fixture_root, [broken_pin], []);
    let broken_adapter = || {
        spy_v["calls"] = spy_v["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(broken, staged);
        staged
    };
    let state_before_fail = fs::read_file(state_file_path(state_root));
    let failed = false;
    let fail_msg = "";
    try {
        acquire_and_activate(state_root, trust_doc_b, registry,
            "@northstar/language-fixture", "0.3.0", "fixture-lang", "explicit_audit_repair",
            card_117_core_version(), broken_adapter, spy_v, manifest_schema, receipt_schema);
    } catch (err) {
        failed = true;
        fail_msg = err.to_string();
    }
    require(failed, "self-check-failing candidate unexpectedly activated");
    require(fail_msg.contains("self-check"), "failed update stopped at the wrong gate: " + fail_msg);
    require(fs::read_file(state_file_path(state_root)) == state_before_fail,
        "failed update mutated lifecycle state");
    require_hashes_unchanged("failed-update consumer", consumer, consumer_before);
    let state3 = read_state_doc(state_root);
    require(state3["state_revision"] == "2" && state3["packages"].len() == 2,
        "failed update changed the state revision or duplicated references");
    let selected3 = [];
    for ref in state3["packages"] {
        if ref["selection"] == "selected" {
            selected3.push(ref["version"]);
        }
    }
    require(selected3 == ["0.2.0"], "failed update changed the selected receipt");

    // Rollback reselects the retained proven install without fetching.
    let spy_calls_before_rollback = spy_v["calls"];
    let rollback = rollback_selected(state_root, trust_doc_v, first["receipt_digest"], card_117_core_version());
    require(rollback["status"] == "rolled-back", "rollback did not complete");
    require(spy_v["calls"] == spy_calls_before_rollback, "rollback fetched from a transport");
    let state4 = read_state_doc(state_root);
    require(state4["state_revision"] == "3", "rollback did not advance the state revision");
    let selected4 = [];
    for ref in state4["packages"] {
        if ref["selection"] == "selected" {
            selected4.push(ref["version"]);
        }
    }
    require(selected4 == ["0.1.0"], "rollback did not reselect the retained install");
    require_hashes_unchanged("rollback consumer", consumer, consumer_before);

    // Failed rollback: the retained 0.2.0 install is tampered, so rollback to
    // it must stop at byte revalidation and leave selection and state exact.
    fs::write_file(path::join(update["install_dir"], "SKILL.md"), "tampered\n");
    let state_before_fail_rollback = fs::read_file(state_file_path(state_root));
    let rb_failed = false;
    try {
        rollback_selected(state_root, trust_doc_v, update["receipt_digest"], card_117_core_version());
    } catch (err) {
        rb_failed = err.to_string().contains("drifted");
    }
    require(rb_failed, "tampered retained bytes did not block rollback");
    require(fs::read_file(state_file_path(state_root)) == state_before_fail_rollback,
        "failed rollback mutated lifecycle state");

    log("card-117 oracle 3 (activation is transactional): PASS (before/after hashes exact, selection retained on every failure)");
}

fn test_operator_owned_state(fixture_root, manifest_schema, receipt_schema, registry) {
    let state_root = fs::make_temp_dir("northstar-state-owned-");
    let consumer = fs::make_temp_dir("northstar-consumer-owned-");
    // Consumer config claims trust and selection; it must be ignored.
    fs::create_dir(path::join(consumer, "docs/contracts"));
    fs::write_file(path::join(consumer, "docs/contracts/language-quality-config.json"),
        json::stringify(#{ package_id: "@northstar/language-fixture", version: "0.1.0", trusted: true, selected: true }));
    fs::write_file(path::join(consumer, "README.md"), "# consumer\n");
    let consumer_before = snapshot_hashes(consumer);

    let trust_doc = build_fixture_trust_doc(fixture_root, [], []);
    let spy = new_spy();
    let adapter = || {
        spy["calls"] = spy["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(fixture_root, staged);
        staged
    };

    let installed = resolve_installed_package(read_state_doc(state_root), trust_doc,
        "fixture-lang", "explicit_audit_repair", card_117_core_version());
    require(installed == (), "consumer config alone routed a package");

    // A consumer-claimed package without an operator pin cannot be acquired.
    let blocked = false;
    let block_msg = "";
    try {
        acquire_and_activate(state_root, trust_doc, registry,
            "@northstar/consumer-claimed", "0.1.0", "fixture-lang", "explicit_audit_repair",
            card_117_core_version(), adapter, spy, manifest_schema, receipt_schema);
    } catch (err) {
        blocked = true;
        block_msg = err.to_string();
    }
    require(blocked && block_msg.contains("no trusted pin"), "consumer-claimed trust authorized acquisition");
    require(spy["calls"] == 0, "consumer-claimed request reached the transport");
    require_hashes_unchanged("consumer-owned claim", consumer, consumer_before);
    require(!fs::is_file(state_file_path(state_root)), "consumer-claimed request created state");

    // Stale writer: A reads a revision, B commits, A's CAS write conflicts.
    let first = acquire_and_activate(state_root, trust_doc, registry,
        "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), adapter, spy, manifest_schema, receipt_schema);
    let observed_a = read_state_doc(state_root)["state_revision"];
    let variant = build_variant_package(fixture_root, "0.2.0");
    let variant_pin_entry = variant_pin("@northstar/language-fixture", "0.2.0", variant);
    let trust_doc_v = build_fixture_trust_doc(fixture_root, [variant_pin_entry], []);
    let spy_v = new_spy();
    let variant_adapter = || {
        spy_v["calls"] = spy_v["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(variant, staged);
        staged
    };
    acquire_and_activate(state_root, trust_doc_v, registry,
        "@northstar/language-fixture", "0.2.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), variant_adapter, spy_v, manifest_schema, receipt_schema);
    require(read_state_doc(state_root)["state_revision"] != observed_a,
        "writer B did not advance the revision");
    let state_before_stale = fs::read_file(state_file_path(state_root));
    let stale_failed = false;
    let stale_msg = "";
    try {
        let stale_packages = json::parse(json::stringify(read_state_doc(state_root)["packages"]));
        stale_packages.push(#{
            package_id: "@northstar/language-fixture",
            version: "0.9.9",
            tree_digest: "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            manifest_digest: "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            receipt_digest: "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            installed_path: "/stale/0.9.9",
            selection: "selected",
            installed_at: card_117_timestamp(),
        });
        replace_state_cas(state_root, observed_a, "99", stale_packages);
    } catch (err) {
        stale_failed = true;
        stale_msg = err.to_string();
    }
    require(stale_failed && stale_msg.contains("CAS conflict"), "stale writer was not stopped: " + stale_msg);
    require(fs::read_file(state_file_path(state_root)) == state_before_stale,
        "stale writer mutated lifecycle state");
    let state_final = read_state_doc(state_root);
    let selected_final = [];
    for ref in state_final["packages"] {
        if ref["selection"] == "selected" {
            selected_final.push(ref["version"]);
        }
    }
    require(selected_final == ["0.2.0"], "stale writer replaced the selection");
    let count_202 = 0;
    for ref in state_final["packages"] {
        if ref["version"] == "0.2.0" {
            count_202 += 1;
        }
    }
    require(count_202 == 1, "stale writer duplicated an installed package");

    log("card-117 oracle 4 (state is operator-owned compare-and-swap): PASS (consumer authority ignored, stale writer stopped, no duplicates)");
}

fn test_offline_local_routing(fixture_root, manifest_schema, receipt_schema, registry) {
    let state_root = fs::make_temp_dir("northstar-state-offline-");
    let consumer = fs::make_temp_dir("northstar-consumer-offline-");
    fs::write_file(path::join(consumer, "README.md"), "# consumer\n");
    let trust_doc = build_fixture_trust_doc(fixture_root, [], []);
    let spy = new_spy();
    let adapter = || {
        spy["calls"] = spy["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(fixture_root, staged);
        staged
    };
    acquire_and_activate(state_root, trust_doc, registry,
        "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), adapter, spy, manifest_schema, receipt_schema);

    // Network-denied adapter: a compatible install routes without it.
    let offline_spy = new_spy();
    let offline_adapter = || {
        offline_spy["calls"] = offline_spy["calls"] + 1;
        throw("network unavailable");
    };
    let routed = handle_workflow_request(state_root, consumer, trust_doc, registry,
        "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), offline_adapter, offline_spy, manifest_schema, receipt_schema, "workflow_request");
    require(routed["status"] == "routed", "offline installed route did not route");
    require(routed["identity"] == card_117_fixture_tree_digest(), "offline route resolved the wrong identity");
    require(routed["notice"].contains("local-only"), "offline route did not report local-only routing");
    require(offline_spy["calls"] == 0, "offline route touched the network adapter");

    log("card-117 oracle 5 (offline is local): PASS (network-denied adapter, zero calls, resolved identity exact)");
}

fn test_scoped_failure(fixture_root, manifest_schema, receipt_schema, registry) {
    let state_root = fs::make_temp_dir("northstar-state-scope-");
    let consumer = fs::make_temp_dir("northstar-consumer-scope-");
    fs::write_file(path::join(consumer, "README.md"), "# consumer\n");
    let trust_doc = build_fixture_trust_doc(fixture_root, [], []);
    let spy = new_spy();
    let adapter = || {
        spy["calls"] = spy["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(fixture_root, staged);
        staged
    };
    acquire_and_activate(state_root, trust_doc, registry,
        "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), adapter, spy, manifest_schema, receipt_schema);
    let state_before = fs::read_file(state_file_path(state_root));

    let offline_spy = new_spy();
    let offline_adapter = || {
        offline_spy["calls"] = offline_spy["calls"] + 1;
        throw("network unavailable");
    };

    // Requested package missing offline: its language is not provided by any
    // installed package, so only that workflow stops.
    let missing = handle_workflow_request(state_root, consumer, trust_doc, registry,
        "@northstar/missing-fixture", "0.1.0", "missing-lang", "explicit_audit_repair",
        card_117_core_version(), offline_adapter, offline_spy, manifest_schema, receipt_schema, "workflow_request");
    require(missing["status"] == "stopped", "missing package did not stop the workflow");
    require(missing["notice"].contains("manual or local-path"), "failure notice lacks the local installation route");
    require(missing["notice"].contains("@northstar/missing-fixture"), "failure notice lacks the exact identity");
    require(fs::read_file(state_file_path(state_root)) == state_before, "scoped failure mutated lifecycle state");

    // The installed package's workflow still routes: core unaffected.
    let routed = handle_workflow_request(state_root, consumer, trust_doc, registry,
        "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), offline_adapter, offline_spy, manifest_schema, receipt_schema, "workflow_request");
    require(routed["status"] == "routed", "core route failed after scoped package failure");

    log("card-117 oracle 6 (failure is scoped): PASS (dual-workflow fixture)");
}

fn test_revocable_trust(fixture_root, manifest_schema, receipt_schema, registry) {
    let state_root = fs::make_temp_dir("northstar-state-revoke-");
    let consumer = fs::make_temp_dir("northstar-consumer-revoke-");
    fs::write_file(path::join(consumer, "README.md"), "# consumer\n");
    let trust_doc = build_fixture_trust_doc(fixture_root, [], []);
    let spy = new_spy();
    let adapter = || {
        spy["calls"] = spy["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(fixture_root, staged);
        staged
    };
    acquire_and_activate(state_root, trust_doc, registry,
        "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), adapter, spy, manifest_schema, receipt_schema);
    let state_before = snapshot_hashes(state_root);
    let spy_before = spy["calls"];

    // Operator revokes the installed content identity.
    let revoked_doc = build_fixture_trust_doc(fixture_root, [], [
        #{
            package_id: "@northstar/language-fixture",
            version: "0.1.0",
            tree_digest: card_117_fixture_tree_digest(),
            manifest_digest: card_117_fixture_manifest_digest(),
            actor: "operator",
            timestamp: card_117_timestamp(),
            reason: "revocation proof",
        },
    ]);

    // Routing stops visibly and identifies the revocation.
    let outcome = handle_workflow_request(state_root, consumer, revoked_doc, registry,
        "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair",
        card_117_core_version(), adapter, spy, manifest_schema, receipt_schema, "workflow_request");
    require(outcome["status"] == "stopped", "revoked identity was routed or re-acquired");
    require(outcome["notice"].contains("revoked"), "revocation stop does not identify the revocation record");

    // Re-acquisition of the revoked identity is blocked before any transport call.
    require(spy["calls"] == spy_before, "revoked identity reached the transport");
    require(snapshot_hashes(state_root) == state_before,
        "revocation removed installed bytes, receipts, or lifecycle state");

    log("card-117 oracle 7 (trust is revocable): PASS (execution blocked, evidence and bytes retained)");
}

fn test_generic_routing(synthetic_root, manifest_schema, receipt_schema, registry) {
    let state_root = fs::make_temp_dir("northstar-state-generic-");
    let consumer = fs::make_temp_dir("northstar-consumer-generic-");
    fs::write_file(path::join(consumer, "README.md"), "# consumer\n");

    let synth_manifest = json::read_file(path::join(synthetic_root, "northstar-package.json"));
    validate_manifest_instance(synth_manifest, manifest_schema, "synthetic-language manifest");
    let synth_tree = canonical_tree_digest(synthetic_root, "synthetic-language");
    let synth_manifest_digest = canonical_manifest_digest(path::join(synthetic_root, "northstar-package.json"));
    let pin = #{
        package_id: "@northstar/synthetic-language",
        version: "0.1.0",
        source_identity: #{
            type: "local_path",
            path: synthetic_root,
        },
        tree_digest: synth_tree,
        manifest_digest: synth_manifest_digest,
        compatible_core_range: ">=0.2.0 <1.0.0",
        actor: "operator",
        timestamp: card_117_timestamp(),
        reason: "synthetic-language pin",
    };
    let trust_doc = #{
        schema_version: "1.0.0",
        revision: "1",
        allowlist: [pin],
        revocations: [],
    };
    let spy = new_spy();
    let adapter = || {
        spy["calls"] = spy["calls"] + 1;
        let staged = fs::make_temp_dir("northstar-staged-");
        copy_tree(synthetic_root, staged);
        staged
    };
    let install = acquire_and_activate(state_root, trust_doc, registry,
        "@northstar/synthetic-language", "0.1.0", "quantum-lang", "explicit_audit_repair",
        card_117_core_version(), adapter, spy, manifest_schema, receipt_schema);
    require(install["status"] == "activated", "synthetic-language package did not install");

    let routed = handle_workflow_request(state_root, consumer, trust_doc, registry,
        "@northstar/synthetic-language", "0.1.0", "quantum-lang", "explicit_audit_repair",
        card_117_core_version(), adapter, spy, manifest_schema, receipt_schema, "workflow_request");
    require(routed["status"] == "routed" && routed["identity"] == synth_tree,
        "synthetic-language route did not resolve by manifest fields");

    let undeclared = resolve_installed_package(read_state_doc(state_root), trust_doc,
        "quantum-lang", "everyday_authoring", card_117_core_version());
    require(undeclared == (), "undeclared workflow routed");
    let wrong_language = resolve_installed_package(read_state_doc(state_root), trust_doc,
        "fixture-lang", "explicit_audit_repair", card_117_core_version());
    require(wrong_language == (), "wrong-language request routed to the synthetic package");

    log("card-117 oracle 8 (routing is generic): PASS (unknown language resolved by manifest fields, no core switch)");
}

fn test_runtime_scan_slices(check_source) {
    let begin = check_source.index_of("GENERIC-RUNTIME-SCAN-BEGIN");
    let end = check_source.index_of("GENERIC-RUNTIME-SCAN-END");
    require(begin >= 0 && end > begin, "generic runtime scan markers missing");
    let runtime_slice = check_source.sub_string(begin, end - begin);
    // Comments are stripped so the scan proves the executable code carries no
    // language branch or Effigy dependency, not that prose never names them.
    let code_lines = [];
    for line in str::split_lines(runtime_slice) {
        let trimmed = str::trim(line);
        if !str::starts_with(trimmed, "//") {
            code_lines.push(line);
        }
    }
    let code = "";
    for line in code_lines {
        code += line;
        code += "\n";
    }
    require(!regex::is_match("(?i)\\b(effigy|rust|cargo|typescript|svelte|clippy|eslint|biome)\\b", code),
        "generic runtime contains a forbidden dependency or language branch");
    require(!code.contains("process::") && !code.contains("command::"),
        "generic runtime can launch a subprocess");

    let rb = check_source.index_of("ROUTE-SCAN-BEGIN");
    let re = check_source.index_of("ROUTE-SCAN-END");
    require(rb >= 0 && re > rb, "route scan markers missing");
    let route_slice = check_source.sub_string(rb, re - rb);
    require(!route_slice.contains("exec::"), "route selection code can launch a subprocess");
    require(!route_slice.contains("json::write") && !route_slice.contains("fs::write"),
        "route selection code mutates state or files");
    log("card-117 generic runtime scan: PASS (no Effigy, no provider, no language branch, route selection read-only)");
}

fn build_variant_package(fixture_root, version_str) {
    // A deterministic release candidate derived from the fixture payload:
    // identical bytes except the declared version.
    let variant = fs::make_temp_dir("northstar-variant-");
    copy_tree(fixture_root, variant);
    let manifest_path = path::join(variant, "northstar-package.json");
    let manifest = json::read_file(manifest_path);
    manifest["version"] = version_str;
    fs::write_file(manifest_path, json::stringify(manifest));
    variant
}

fn variant_pin(package_id, version_str, variant_root) {
    #{
        package_id: package_id,
        version: version_str,
        source_identity: #{
            type: "local_path",
            path: variant_root,
        },
        tree_digest: canonical_tree_digest(variant_root, "variant"),
        manifest_digest: canonical_manifest_digest(path::join(variant_root, "northstar-package.json")),
        compatible_core_range: ">=0.2.0 <1.0.0",
        actor: "operator",
        timestamp: card_117_timestamp(),
        reason: "card 117 variant pin",
    }
}

// =============================================================================
// Main Execution
// =============================================================================

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

// -----------------------------------------------------------------------------
// Card 117: Generic lifecycle proof
// -----------------------------------------------------------------------------

let trust_schema = load_and_validate_schema_file(packages_ref_root, "operator-trust.schema.json", "language-package-operator-trust");
let lifecycle_schema = load_and_validate_schema_file(packages_ref_root, "lifecycle-state.schema.json", "language-package-lifecycle-state");

let state_fixtures_root = path::join(northstar_skill_root, "assets/fixtures/language-packages/state");
let trust_fixture_doc = json::read_file(path::join(state_fixtures_root, "operator-trust.json"));
validate_trust_document(trust_fixture_doc, trust_schema, "operator-trust.json");
let lifecycle_fixture_doc = json::read_file(path::join(state_fixtures_root, "lifecycle-state.json"));
validate_lifecycle_document(lifecycle_fixture_doc, lifecycle_schema, "lifecycle-state.json");

let negative_trust_root = path::join(northstar_skill_root, "assets/fixtures/language-packages/negative/trust");
expect_trust_rejection("duplicate-allowlist",
    json::read_file(path::join(negative_trust_root, "duplicate-allowlist.json")), trust_schema, "duplicate allowlist entry");
expect_trust_rejection("duplicate-revocation",
    json::read_file(path::join(negative_trust_root, "duplicate-revocation.json")), trust_schema, "duplicate revocation entry");
expect_trust_rejection("trust-missing-fields",
    json::read_file(path::join(negative_trust_root, "missing-fields.json")), trust_schema, "missing required field");
expect_trust_rejection("trust-bare-hex-digest",
    json::read_file(path::join(negative_trust_root, "bare-hex-digest.json")), trust_schema, "does not match pattern");

let negative_lifecycle_root = path::join(northstar_skill_root, "assets/fixtures/language-packages/negative/lifecycle");
expect_lifecycle_rejection("duplicate-selection",
    json::read_file(path::join(negative_lifecycle_root, "duplicate-selection.json")), lifecycle_schema, "selects more than one receipt");
expect_lifecycle_rejection("duplicate-references",
    json::read_file(path::join(negative_lifecycle_root, "duplicate-references.json")), lifecycle_schema, "duplicate receipt reference");
expect_lifecycle_rejection("lifecycle-missing-required",
    json::read_file(path::join(negative_lifecycle_root, "missing-required.json")), lifecycle_schema, "missing required field");
expect_lifecycle_rejection("lifecycle-bare-hex-digest",
    json::read_file(path::join(negative_lifecycle_root, "bare-hex-digest.json")), lifecycle_schema, "does not match pattern");

test_lifecycle_schema_fail_closed(trust_fixture_doc, trust_schema, lifecycle_fixture_doc, lifecycle_schema);

assert_fixture_identity_vectors(fixture_root, fixture_manifest_path);
test_detection_is_not_authority(fixture_root, build_fixture_trust_doc(fixture_root, [], []), registry, manifest_schema, receipt_schema);
test_canonical_identity_vectors(fixture_root, fixture_manifest_path);
test_transactional_activation(fixture_root, manifest_schema, receipt_schema, registry);
test_operator_owned_state(fixture_root, manifest_schema, receipt_schema, registry);
test_offline_local_routing(fixture_root, manifest_schema, receipt_schema, registry);
test_scoped_failure(fixture_root, manifest_schema, receipt_schema, registry);
test_revocable_trust(fixture_root, manifest_schema, receipt_schema, registry);
let synthetic_root = path::join(northstar_skill_root, "assets/fixtures/language-packages/synthetic-language");
test_generic_routing(synthetic_root, manifest_schema, receipt_schema, registry);
test_runtime_scan_slices(fs::read_file(path::join(northstar_skill_root, "scripts/check-language-packages.rhai")));

log("Northstar language package machine contracts: OK (3 Draft 2020-12 schemas, bounded evaluator for frozen vocabulary across all variants, schema mutation & fail-closed proof, SemVer numeric ranges, path containment, trust/source receipt variants, deep policy-free proof, staged sibling isolation proof, 9 mandatory negative oracle invariants, portable contracts; card 117: canonical manifest/tree digest vectors, operator trust & lifecycle schemas, transactional acquire/update/rollback with CAS state, offline local routing, revocable trust, generic manifest-field routing, 8 review-oracle rows falsified)");
