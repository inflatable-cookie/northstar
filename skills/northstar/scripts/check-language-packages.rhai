// Focused validation for Northstar language package machine contracts (card 116).
//
// Validates:
// 1. JSON Schema Draft 2020-12 structure and properties across all 3 schema files.
// 2. Exact semantic-version parsing and numeric range compatibility.
// 3. Safe package-relative path containment (disallowing traversal and absolute paths).
// 4. Manifest schema instance conformance and constraints.
// 5. Official registry schema instance conformance and constraints.
// 6. Installation receipt schema instance conformance covering all trust variants
//    (official, operator_allowlist, interactive_approval) and source variants
//    (git, local_path, archive).
// 7. Deep recursive policy-free fixture verification.
// 8. Independent package addressing and sibling payload isolation.
// 9. Negative review-oracle invariant suite.
// 10. Schema and contract portability.

fn require(condition, message) {
    if !condition {
        let err = "[northstar:language-packages] ";
        err += message;
        throw(err);
    }
}

fn require_map(val, context) {
    if type_of(val) != "map" {
        let err = context;
        err += " must be an object";
        throw(err);
    }
}

fn require_array(val, context) {
    if type_of(val) != "array" {
        let err = context;
        err += " must be an array";
        throw(err);
    }
}

fn require_non_empty_string(val, context) {
    if type_of(val) != "string" || val.len() == 0 {
        let err = context;
        err += " must be a non-empty string";
        throw(err);
    }
}

fn require_regex(pattern, val, context) {
    if type_of(val) != "string" || !regex::is_match(pattern, val) {
        let err = context;
        err += " value '";
        err += val;
        err += "' does not match pattern: ";
        err += pattern;
        throw(err);
    }
}

fn assert_allowed_keys(instance, allowed_keys, context) {
    for key in instance.keys() {
        if !allowed_keys.contains(key) {
            let err = context;
            err += " contains forbidden additional property: ";
            err += key;
            throw(err);
        }
    }
}

fn require_field(instance, key, context) {
    if !instance.contains(key) {
        let err = context;
        err += " missing required field: ";
        err += key;
        throw(err);
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

fn validate_schema_file(root, filename, expected_id_part) {
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
// Manifest Conformance Validator
// -----------------------------------------------------------------------------

fn validate_manifest_instance(manifest, context) {
    require_map(manifest, context);

    // Explicit rejection of self-authorizing fields
    for forbidden in ["official", "is_official", "trusted", "trust_level", "allowlisted"] {
        if manifest.contains(forbidden) {
            let err = context;
            err += " self-claims trust or official status (trust must be core-owned)";
            throw(err);
        }
    }

    let allowed_keys = [
        "schema_version", "package_id", "version", "kind", "compatible_core_range",
        "supported_languages", "supported_overlays", "available_workflows",
        "entrypoints", "runtime_capabilities", "self_check", "evidence_providers"
    ];
    assert_allowed_keys(manifest, allowed_keys, context);

    for key in [
        "schema_version", "package_id", "version", "kind", "compatible_core_range",
        "supported_languages", "supported_overlays", "available_workflows",
        "entrypoints", "runtime_capabilities", "self_check"
    ] {
        require_field(manifest, key, context);
    }

    require(manifest["schema_version"] == "1.0.0", context + " schema_version must be 1.0.0");
    require_regex("^@[a-z0-9-]+/[a-z0-9-]+$", manifest["package_id"], context + " package_id");
    require_regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", manifest["version"], context + " version");
    require(manifest["kind"] == "language-quality", context + " expected const 'language-quality'");

    let semver_range_pattern = "^(\\*|[0-9]+\\.[0-9]+\\.[0-9]+|\\^[0-9]+\\.[0-9]+\\.[0-9]+|>=[0-9]+\\.[0-9]+\\.[0-9]+ <[0-9]+\\.[0-9]+\\.[0-9]+|>=[0-9]+\\.[0-9]+\\.[0-9]+|<[0-9]+\\.[0-9]+\\.[0-9]+)$";
    require_regex(semver_range_pattern, manifest["compatible_core_range"], context + " compatible_core_range");

    require_array(manifest["supported_languages"], context + " supported_languages");
    require(manifest["supported_languages"].len() >= 1, context + " supported_languages must have minItems 1");
    for lang in manifest["supported_languages"] {
        require_non_empty_string(lang, context + " supported_language");
    }

    require_array(manifest["supported_overlays"], context + " supported_overlays");
    for overlay in manifest["supported_overlays"] {
        require_non_empty_string(overlay, context + " supported_overlay");
    }

    require_array(manifest["available_workflows"], context + " available_workflows");
    require(manifest["available_workflows"].len() >= 1, context + " available_workflows must have minItems 1");
    for workflow in manifest["available_workflows"] {
        if workflow != "everyday_authoring" && workflow != "explicit_audit_repair" {
            let err = context;
            err += " unknown available_workflow: ";
            err += workflow;
            throw(err);
        }
    }

    require_map(manifest["entrypoints"], context + " entrypoints");
    for entry_k in manifest["entrypoints"].keys() {
        let entry_p = manifest["entrypoints"][entry_k];
        assert_safe_package_relative_path(entry_p, context + " entrypoint[" + entry_k + "]");
    }

    let runtime = manifest["runtime_capabilities"];
    require_map(runtime, context + " runtime_capabilities");
    assert_allowed_keys(runtime, ["required_commands", "optional_effigy_selectors"], context + " runtime_capabilities");
    require_field(runtime, "required_commands", context + " runtime_capabilities");
    require_field(runtime, "optional_effigy_selectors", context + " runtime_capabilities");
    require_array(runtime["required_commands"], context + " runtime_capabilities.required_commands");
    require_array(runtime["optional_effigy_selectors"], context + " runtime_capabilities.optional_effigy_selectors");

    let self_check = manifest["self_check"];
    require_map(self_check, context + " self_check");
    assert_allowed_keys(self_check, ["entrypoint", "validated_profile_versions", "validated_schema_versions"], context + " self_check");
    require_field(self_check, "entrypoint", context + " self_check");
    require_field(self_check, "validated_profile_versions", context + " self_check");
    require_field(self_check, "validated_schema_versions", context + " self_check");
    assert_safe_package_relative_path(self_check["entrypoint"], context + " self_check.entrypoint");
    require_array(self_check["validated_profile_versions"], context + " self_check.validated_profile_versions");
    require_array(self_check["validated_schema_versions"], context + " self_check.validated_schema_versions");
    for pv in self_check["validated_profile_versions"] {
        require_regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", pv, context + " validated_profile_version");
    }
    for sv in self_check["validated_schema_versions"] {
        require_regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", sv, context + " validated_schema_version");
    }

    if manifest.contains("evidence_providers") {
        require_array(manifest["evidence_providers"], context + " evidence_providers");
        for ep in manifest["evidence_providers"] {
            require_non_empty_string(ep, context + " evidence_provider");
        }
    }

    // Explicit rejection of self-authorizing fields
    for forbidden in ["official", "is_official", "trusted", "trust_level", "allowlisted"] {
        if manifest.contains(forbidden) {
            let err = context;
            err += " self-claims trust or official status (trust must be core-owned)";
            throw(err);
        }
    }
}

// -----------------------------------------------------------------------------
// Official Registry Conformance Validator
// -----------------------------------------------------------------------------

fn validate_registry_instance(registry, context) {
    require_map(registry, context);
    assert_allowed_keys(registry, ["schema_version", "registry_version", "packages"], context);
    require_field(registry, "schema_version", context);
    require_field(registry, "registry_version", context);
    require_field(registry, "packages", context);

    require(registry["schema_version"] == "1.0.0", context + " schema_version must be 1.0.0");
    require_regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", registry["registry_version"], context + " registry_version");
    require_array(registry["packages"], context + " packages");

    let seen_ids = [];
    let entry_allowed_keys = [
        "package_id", "version", "repository", "subpath", "commit",
        "tree_digest", "manifest_digest", "compatible_core_range"
    ];
    let semver_range_pattern = "^(\\*|[0-9]+\\.[0-9]+\\.[0-9]+|\\^[0-9]+\\.[0-9]+\\.[0-9]+|>=[0-9]+\\.[0-9]+\\.[0-9]+ <[0-9]+\\.[0-9]+\\.[0-9]+|>=[0-9]+\\.[0-9]+\\.[0-9]+|<[0-9]+\\.[0-9]+\\.[0-9]+)$";

    for entry in registry["packages"] {
        require_map(entry, context + " package entry");
        assert_allowed_keys(entry, entry_allowed_keys, context + " package entry");
        for req_k in entry_allowed_keys {
            require_field(entry, req_k, context + " package entry");
        }

        let pkg_key = entry["package_id"] + "@" + entry["version"];
        require(!seen_ids.contains(pkg_key), "duplicate registry package: " + pkg_key);
        seen_ids.push(pkg_key);

        require_regex("^@[a-z0-9-]+/[a-z0-9-]+$", entry["package_id"], context + " package_id");
        require_regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", entry["version"], context + " version");
        require_regex("^https://[a-zA-Z0-9.-]+(/[^/]+)*$", entry["repository"], context + " repository");
        assert_safe_package_relative_path(entry["subpath"], context + " subpath");
        require_regex("^[0-9a-f]{40}$|^[0-9a-f]{64}$", entry["commit"], context + " commit");
        require_regex("^(sha256:)?[0-9a-f]{64}$", entry["tree_digest"], context + " tree_digest");
        require_regex("^(sha256:)?[0-9a-f]{64}$", entry["manifest_digest"], context + " manifest_digest");
        require_regex(semver_range_pattern, entry["compatible_core_range"], context + " compatible_core_range");
    }
}

// -----------------------------------------------------------------------------
// Installation Receipt Conformance Validator
// -----------------------------------------------------------------------------

fn validate_official_trust(trust, context) {
    let ctx = context + " official trust";
    assert_allowed_keys(trust, ["type", "registry_version", "registry_entry_digest"], ctx);
    require_field(trust, "registry_version", ctx);
    require_field(trust, "registry_entry_digest", ctx);
    require_regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", trust["registry_version"], ctx);
    require_regex("^(sha256:)?[0-9a-f]{64}$", trust["registry_entry_digest"], ctx);
}

fn validate_allowlist_trust(trust, context) {
    let ctx = context + " allowlist trust";
    assert_allowed_keys(trust, ["type", "allowlist_entry", "allowlisted_by"], ctx);
    require_field(trust, "allowlist_entry", ctx);
    require_field(trust, "allowlisted_by", ctx);
    require_non_empty_string(trust["allowlist_entry"], ctx);
    require_non_empty_string(trust["allowlisted_by"], ctx);
}

fn validate_interactive_trust(trust, context) {
    let ctx = context + " interactive trust";
    assert_allowed_keys(trust, ["type", "approved_by", "approval_timestamp", "approval_scope"], ctx);
    require_field(trust, "approved_by", ctx);
    require_field(trust, "approval_timestamp", ctx);
    require_field(trust, "approval_scope", ctx);
    require_non_empty_string(trust["approved_by"], ctx);
    require_regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?Z?$", trust["approval_timestamp"], ctx);
    let scope = trust["approval_scope"];
    if scope != "session" && scope != "workspace" && scope != "permanent" {
        let err = context;
        err += " invalid approval_scope: ";
        err += scope;
        throw(err);
    }
}

fn validate_receipt_trust_variant(trust, context) {
    require_map(trust, context + " trust_class");
    require_field(trust, "type", context + " trust_class");

    let t_type = trust["type"];
    if t_type == "official" {
        validate_official_trust(trust, context);
    } else if t_type == "operator_allowlist" {
        validate_allowlist_trust(trust, context);
    } else if t_type == "interactive_approval" {
        validate_interactive_trust(trust, context);
    } else {
        let err = context;
        err += " unknown trust_class type: ";
        err += t_type;
        throw(err);
    }
}

fn validate_git_source(source, context) {
    let ctx = context + " git source";
    assert_allowed_keys(source, ["type", "repository", "subpath", "commit"], ctx);
    require_field(source, "repository", ctx);
    require_field(source, "subpath", ctx);
    require_field(source, "commit", ctx);
    require_regex("^https://[a-zA-Z0-9.-]+(/[^/]+)*$", source["repository"], ctx);
    assert_safe_package_relative_path(source["subpath"], ctx);
    require_regex("^[0-9a-f]{40}$|^[0-9a-f]{64}$", source["commit"], ctx);
}

fn validate_local_path_source(source, context) {
    let ctx = context + " local_path source";
    assert_allowed_keys(source, ["type", "path", "acquisition_mode"], ctx);
    require_field(source, "path", ctx);
    require_field(source, "acquisition_mode", ctx);
    require_non_empty_string(source["path"], ctx);
    let mode = source["acquisition_mode"];
    if mode != "manual" && mode != "local" {
        let err = context;
        err += " invalid local_path acquisition_mode: ";
        err += mode;
        throw(err);
    }
}

fn validate_archive_source(source, context) {
    let ctx = context + " archive source";
    assert_allowed_keys(source, ["type", "url", "archive_digest", "subpath"], ctx);
    require_field(source, "url", ctx);
    require_field(source, "archive_digest", ctx);
    require_regex("^https://[a-zA-Z0-9.-]+(/[^/]+)*$", source["url"], ctx);
    require_regex("^(sha256:)?[0-9a-f]{64}$", source["archive_digest"], ctx);
    if source.contains("subpath") {
        assert_safe_package_relative_path(source["subpath"], ctx);
    }
}

fn validate_receipt_source_variant(source, context) {
    require_map(source, context + " source");
    require_field(source, "type", context + " source");

    let s_type = source["type"];
    if s_type == "git" {
        validate_git_source(source, context);
    } else if s_type == "local_path" {
        validate_local_path_source(source, context);
    } else if s_type == "archive" {
        validate_archive_source(source, context);
    } else {
        let err = context;
        err += " unknown source type: ";
        err += s_type;
        throw(err);
    }
}

fn validate_receipt_instance(receipt, context) {
    require_map(receipt, context);
    let allowed_keys = [
        "schema_version", "package_id", "version", "kind", "trust_class",
        "source", "content_identity", "compatibility", "installation"
    ];
    assert_allowed_keys(receipt, allowed_keys, context);
    for req_k in allowed_keys {
        require_field(receipt, req_k, context);
    }

    require(receipt["schema_version"] == "1.0.0", context + " schema_version must be 1.0.0");
    require_regex("^@[a-z0-9-]+/[a-z0-9-]+$", receipt["package_id"], context + " package_id");
    require_regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", receipt["version"], context + " version");
    require(receipt["kind"] == "language-quality", context + " expected const 'language-quality'");

    validate_receipt_trust_variant(receipt["trust_class"], context);
    validate_receipt_source_variant(receipt["source"], context);

    let content = receipt["content_identity"];
    require_map(content, context + " content_identity");
    assert_allowed_keys(content, ["package_tree_digest", "manifest_digest"], context + " content_identity");
    require_field(content, "package_tree_digest", context + " content_identity");
    require_field(content, "manifest_digest", context + " content_identity");
    require_regex("^(sha256:)?[0-9a-f]{64}$", content["package_tree_digest"], context + " package_tree_digest");
    require_regex("^(sha256:)?[0-9a-f]{64}$", content["manifest_digest"], context + " manifest_digest");

    let compat = receipt["compatibility"];
    require_map(compat, context + " compatibility");
    assert_allowed_keys(compat, ["compatible_core_range", "installed_core_version"], context + " compatibility");
    require_field(compat, "compatible_core_range", context + " compatibility");
    require_field(compat, "installed_core_version", context + " compatibility");
    let semver_range_pattern = "^(\\*|[0-9]+\\.[0-9]+\\.[0-9]+|\\^[0-9]+\\.[0-9]+\\.[0-9]+|>=[0-9]+\\.[0-9]+\\.[0-9]+ <[0-9]+\\.[0-9]+\\.[0-9]+|>=[0-9]+\\.[0-9]+\\.[0-9]+|<[0-9]+\\.[0-9]+\\.[0-9]+)$";
    require_regex(semver_range_pattern, compat["compatible_core_range"], context + " compatible_core_range");
    require_regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", compat["installed_core_version"], context + " installed_core_version");

    let install = receipt["installation"];
    require_map(install, context + " installation");
    assert_allowed_keys(install, ["installed_path", "installed_at", "acquisition_adapter", "activation_status"], context + " installation");
    require_field(install, "installed_path", context + " installation");
    require_field(install, "installed_at", context + " installation");
    require_field(install, "acquisition_adapter", context + " installation");
    require_field(install, "activation_status", context + " installation");
    require_non_empty_string(install["installed_path"], context + " installed_path");
    require_regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?Z?$", install["installed_at"], context + " installed_at");
    require_non_empty_string(install["acquisition_adapter"], context + " acquisition_adapter");
    let status = install["activation_status"];
    if status != "active" && status != "inactive" && status != "installed" {
        let err = context;
        err += " invalid activation_status: ";
        err += status;
        throw(err);
    }
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

fn validate_policy_free_fixture_deep(fixture_root) {
    let skill_path = path::join(fixture_root, "SKILL.md");
    let manifest_path = path::join(fixture_root, "northstar-package.json");
    require(fs::is_file(skill_path), "policy-free fixture missing SKILL.md");
    require(fs::is_file(manifest_path), "policy-free fixture missing northstar-package.json");

    let manifest = json::read_file(manifest_path);
    validate_manifest_instance(manifest, "policy-free fixture manifest");

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
// Independent Package Addressing & Sibling Payload Isolation
// -----------------------------------------------------------------------------

fn extract_addressed_package_inventory(root, subpath) {
    assert_safe_package_relative_path(subpath, "extract_addressed_package_inventory subpath");
    let target = path::join(root, subpath);
    require(fs::is_dir(target), "target package subpath directory missing: " + target);
    let files = [];
    let prefix = target + "/";
    for file in fs::list_recursive(target) {
        let rel = str::replace(file, prefix, "");
        files.push(rel);
    }
    files.sort();
    files
}

fn verify_package_isolation(files, expected_files, forbidden_substring, label) {
    require(files == expected_files, label + " inventory drifted from expected package payload");
    for f in files {
        if f.contains(forbidden_substring) {
            let err = label + " retained sibling payload: " + f;
            throw(err);
        }
    }
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

fn expect_manifest_rejection(label, manifest, expected_reason) {
    let rejected = false;
    try {
        validate_manifest_instance(manifest, label);
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

fn expect_registry_rejection(label, registry, expected_reason) {
    let rejected = false;
    try {
        validate_registry_instance(registry, label);
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

fn expect_receipt_rejection(label, receipt, expected_reason) {
    let rejected = false;
    try {
        validate_receipt_instance(receipt, label);
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

fn test_receipt_conformance_variants() {
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
            commit: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
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
    validate_receipt_instance(official_git_receipt, "official-git-receipt");

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
    validate_receipt_instance(allowlist_local_receipt, "allowlist-local-receipt");

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
    validate_receipt_instance(interactive_archive_receipt, "interactive-archive-receipt");

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
            commit: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
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
    expect_receipt_rejection("broken-official-trust-receipt", broken_official_trust, "missing required field: registry_version");

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
            commit: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
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
    expect_receipt_rejection("mismatched-trust-provenance-receipt", mismatched_trust, "contains forbidden additional property: approved_by");

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
            commit: "a6c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9e0d1f3b5a7c9",
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
    expect_receipt_rejection("mismatched-source-provenance-receipt", mismatched_source, "contains forbidden additional property: commit");
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

fn run_negative_oracle_suite(target_skill_root) {
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
    expect_manifest_rejection("self-authorizing-manifest", self_auth_manifest, "self-claims trust or official status");

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
    expect_registry_rejection("mutable-registry-commit-branch", mutable_registry, "does not match pattern");

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
    expect_registry_rejection("mutable-registry-commit-tag", tag_registry, "does not match pattern");

    // Invariant 4: Packages are independent (addressing one yields only its subpath).
    let sibling_root = path::join(fixtures_root, "sibling-packages");
    let alpha_files = extract_addressed_package_inventory(sibling_root, "packages/alpha-pkg");
    let beta_files = extract_addressed_package_inventory(sibling_root, "packages/beta-pkg");
    verify_package_isolation(alpha_files, ["SKILL.md", "northstar-package.json", "scripts/self-check.rhai"], "beta", "alpha-pkg");
    verify_package_isolation(beta_files, ["SKILL.md", "northstar-package.json", "scripts/self-check.rhai"], "alpha", "beta-pkg");

    // Sibling payload leakage discrimination test
    let leaked_inventory = ["SKILL.md", "northstar-package.json", "packages/beta-pkg/leaked.txt", "scripts/self-check.rhai"];
    let leakage_rejected = false;
    try {
        verify_package_isolation(leaked_inventory, ["SKILL.md", "northstar-package.json", "scripts/self-check.rhai"], "beta", "alpha-pkg-leak-test");
    } catch (err) {
        leakage_rejected = true;
    }
    require(leakage_rejected, "sibling payload leakage test failed to reject leaked file");

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
    expect_manifest_rejection("traversal-entrypoint-manifest", traversal_manifest, "path violates package-relative containment");

    let abs_path = path::join(fixtures_root, "negative/absolute-path-manifest/absolute-entrypoint.json");
    let abs_manifest = json::read_file(abs_path);
    expect_manifest_rejection("absolute-entrypoint-manifest", abs_manifest, "path violates package-relative containment");

    // Invariant 7: Malformed manifests and extra fields rejected.
    let missing_fields_path = path::join(fixtures_root, "negative/malformed-manifest/missing-fields.json");
    let missing_manifest = json::read_file(missing_fields_path);
    expect_manifest_rejection("malformed-manifest-missing-fields", missing_manifest, "missing required field");

    let invalid_kind_path = path::join(fixtures_root, "negative/malformed-manifest/invalid-kind.json");
    let invalid_kind_manifest = json::read_file(invalid_kind_path);
    expect_manifest_rejection("malformed-manifest-invalid-kind", invalid_kind_manifest, "expected const 'language-quality'");
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
validate_schema_file(packages_ref_root, "package-manifest.schema.json", "language-package-manifest");
validate_schema_file(packages_ref_root, "official-registry.schema.json", "language-package-official-registry");
validate_schema_file(packages_ref_root, "installation-receipt.schema.json", "language-package-installation-receipt");

let official_registry_path = path::join(packages_ref_root, "official-registry.json");
require(fs::is_file(official_registry_path), "missing official-registry.json");
let registry = json::read_file(official_registry_path);
validate_registry_instance(registry, "official-registry.json");

let fixture_root = path::join(northstar_skill_root, "assets/fixtures/language-packages/policy-free-fixture");
validate_policy_free_fixture_deep(fixture_root);

test_semver_compatibility_suite();
test_receipt_conformance_variants();
run_negative_oracle_suite(northstar_skill_root);
scan_forbidden_dependencies(northstar_skill_root);

log("Northstar language package machine contracts: OK (3 Draft 2020-12 schemas, schema conformance across all variants, SemVer numeric ranges, path containment, trust/source receipt variants, deep policy-free proof, sibling isolation proof, 7 negative oracle invariants, portable contracts)");
