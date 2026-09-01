// Focused validation for Northstar language package machine contracts (card 116).
//
// Validates:
// 1. Package manifest, official registry, and installation receipt schemas.
// 2. Initial official registry document.
// 3. Policy-free fixture package structure, manifest, and self-check.
// 4. Package independence and sibling isolation.
// 5. Negative fixture suite covering all review-oracle invariants.
// 6. Schema and contract portability.

fn require(condition, message) {
    if !condition {
        let err = "[northstar:language-packages] ";
        err += message;
        throw(err);
    }
}

fn require_key(value, key, context) {
    if type_of(value) != "map" {
        let err = context;
        err += " must be an object";
        throw(err);
    }
    if !value.contains(key) {
        let err = context;
        err += " missing required field: ";
        err += key;
        throw(err);
    }
}

fn require_array(value, context) {
    if type_of(value) != "array" {
        let err = context;
        err += " must be an array";
        throw(err);
    }
}

fn validate_schema_file(root, filename, expected_id_part) {
    let schema_path = path::join(root, filename);
    require(fs::is_file(schema_path), "missing schema file: " + filename);
    let schema = json::read_file(schema_path);
    require(schema["$schema"] == "https://json-schema.org/draft/2020-12/schema",
        filename + " uses incorrect JSON Schema dialect");
    require(schema["$id"].contains(expected_id_part),
        filename + " has incorrect schema $id: " + schema["$id"]);
    require(schema["type"] == "object", filename + " root must be type object");
    require_array(schema["required"], filename + " required fields");
    require(schema["required"].len() > 0, filename + " requires non-empty required fields");
    require(schema["additionalProperties"] == false,
        filename + " must disallow additionalProperties at root");
}

fn validate_manifest(manifest, context) {
    for key in [
        "schema_version", "package_id", "version", "kind", "compatible_core_range",
        "supported_languages", "supported_overlays", "available_workflows",
        "entrypoints", "runtime_capabilities", "self_check"
    ] {
        require_key(manifest, key, context);
    }

    require(manifest["schema_version"] == "1.0.0",
        context + " unsupported schema_version: " + manifest["schema_version"]);
    require(regex::is_match("^@[a-z0-9-]+/[a-z0-9-]+$", manifest["package_id"]),
        context + " invalid package_id: " + manifest["package_id"]);
    require(regex::is_match("^[0-9]+\\.[0-9]+\\.[0-9]+(-[a-zA-Z0-9.-]+)?$", manifest["version"]),
        context + " invalid semver version: " + manifest["version"]);
    require(manifest["kind"] == "language-quality",
        context + " kind must be 'language-quality', got: " + manifest["kind"]);
    require(manifest["compatible_core_range"].len() > 0,
        context + " compatible_core_range cannot be empty");

    require_array(manifest["supported_languages"], context + " supported_languages");
    require(manifest["supported_languages"].len() > 0,
        context + " supported_languages must be non-empty");

    require_array(manifest["supported_overlays"], context + " supported_overlays");

    require_array(manifest["available_workflows"], context + " available_workflows");
    require(manifest["available_workflows"].len() > 0,
        context + " available_workflows must be non-empty");
    for workflow in manifest["available_workflows"] {
        if workflow != "everyday_authoring" && workflow != "explicit_audit_repair" {
            let err = context;
            err += " unknown workflow: ";
            err += workflow;
            throw(err);
        }
    }

    require(type_of(manifest["entrypoints"]) == "map", context + " entrypoints must be an object");

    let runtime = manifest["runtime_capabilities"];
    require_key(runtime, "required_commands", context + " runtime_capabilities");
    require_key(runtime, "optional_effigy_selectors", context + " runtime_capabilities");
    require_array(runtime["required_commands"], context + " required_commands");
    require_array(runtime["optional_effigy_selectors"], context + " optional_effigy_selectors");

    let self_check = manifest["self_check"];
    require_key(self_check, "entrypoint", context + " self_check");
    require_key(self_check, "validated_profile_versions", context + " self_check");
    require_key(self_check, "validated_schema_versions", context + " self_check");
    require(self_check["entrypoint"].len() > 0, context + " self_check entrypoint cannot be empty");
    require_array(self_check["validated_profile_versions"], context + " validated_profile_versions");
    require_array(self_check["validated_schema_versions"], context + " validated_schema_versions");

    for forbidden in ["official", "is_official", "trusted", "trust_level", "allowlisted"] {
        if manifest.contains(forbidden) {
            let err = context;
            err += " self-claims trust or official status (trust must be core-owned)";
            throw(err);
        }
    }
}

fn validate_registry(registry, context) {
    require_key(registry, "schema_version", context);
    require_key(registry, "registry_version", context);
    require_key(registry, "packages", context);

    require(registry["schema_version"] == "1.0.0", context + " unsupported schema_version");
    require(registry["registry_version"].len() > 0, context + " empty registry_version");
    require_array(registry["packages"], context + " packages");

    let seen_ids = [];
    for entry in registry["packages"] {
        for key in [
            "package_id", "version", "repository", "subpath", "commit",
            "tree_digest", "manifest_digest", "compatible_core_range"
        ] {
            require_key(entry, key, context + " package entry");
        }

        let pkg_key = entry["package_id"] + "@" + entry["version"];
        require(!seen_ids.contains(pkg_key), "duplicate registry package: " + pkg_key);
        seen_ids.push(pkg_key);

        require(regex::is_match("^@[a-z0-9-]+/[a-z0-9-]+$", entry["package_id"]),
            "invalid registry package_id: " + entry["package_id"]);
        require(regex::is_match("^[0-9]+\\.[0-9]+\\.[0-9]+(-[a-zA-Z0-9.-]+)?$", entry["version"]),
            "invalid registry semver version: " + entry["version"]);
        require(regex::is_match("^https://", entry["repository"]),
            "registry repository must be HTTPS URL: " + entry["repository"]);
        require(entry["subpath"].len() > 0, "registry entry subpath cannot be empty");

        let commit = entry["commit"];
        let is_hex_commit = regex::is_match("^[0-9a-f]{40}$", commit) || regex::is_match("^[0-9a-f]{64}$", commit);
        if !is_hex_commit {
            let err = "registry commit must be immutable 40/64-char hex, got mutable source: ";
            err += commit;
            throw(err);
        }

        require(regex::is_match("^(sha256:)?[0-9a-f]{64}$", entry["tree_digest"]),
            "invalid tree_digest hex in registry: " + entry["tree_digest"]);
        require(regex::is_match("^(sha256:)?[0-9a-f]{64}$", entry["manifest_digest"]),
            "invalid manifest_digest hex in registry: " + entry["manifest_digest"]);
        require(entry["compatible_core_range"].len() > 0, "registry entry compatible_core_range empty");
    }
}

fn validate_receipt(receipt, context) {
    for key in [
        "schema_version", "package_id", "version", "kind", "trust_class",
        "source", "content_identity", "compatibility", "installation"
    ] {
        require_key(receipt, key, context);
    }

    require(receipt["schema_version"] == "1.0.0", context + " unsupported schema_version");
    require(regex::is_match("^@[a-z0-9-]+/[a-z0-9-]+$", receipt["package_id"]), context + " invalid package_id");
    require(receipt["kind"] == "language-quality", context + " kind must be language-quality");

    let trust = receipt["trust_class"];
    require_key(trust, "type", context + " trust_class");
    let trust_type = trust["type"];
    if trust_type != "official" && trust_type != "operator_allowlist" && trust_type != "interactive_approval" {
        let err = context;
        err += " invalid trust_class type: ";
        err += trust_type;
        throw(err);
    }

    let source = receipt["source"];
    for key in ["repository", "subpath", "commit"] {
        require_key(source, key, context + " source");
    }
    let commit = source["commit"];
    let is_hex_commit = regex::is_match("^[0-9a-f]{40}$", commit) || regex::is_match("^[0-9a-f]{64}$", commit);
    if !is_hex_commit {
        let err = context;
        err += " source commit must be exact hex";
        throw(err);
    }

    let content = receipt["content_identity"];
    require_key(content, "package_tree_digest", context + " content_identity");
    require_key(content, "manifest_digest", context + " content_identity");
    require(regex::is_match("^(sha256:)?[0-9a-f]{64}$", content["package_tree_digest"]),
        context + " invalid package_tree_digest");
    require(regex::is_match("^(sha256:)?[0-9a-f]{64}$", content["manifest_digest"]),
        context + " invalid manifest_digest");

    let compat = receipt["compatibility"];
    require_key(compat, "compatible_core_range", context + " compatibility");
    require_key(compat, "installed_core_version", context + " compatibility");

    let install = receipt["installation"];
    for key in ["installed_path", "installed_at", "acquisition_adapter", "activation_status"] {
        require_key(install, key, context + " installation");
    }
    let status = install["activation_status"];
    if status != "active" && status != "inactive" && status != "installed" {
        let err = context;
        err += " invalid activation_status: ";
        err += status;
        throw(err);
    }
}

fn check_semver_compatibility(range_str, core_version) {
    if range_str == "*" {
        return true;
    }
    if str::starts_with(range_str, ">=") && range_str.contains("<") {
        let parts = str::split_lines(str::replace(range_str, " ", "\n"));
        let min_ver = "";
        let max_ver = "";
        for p in parts {
            if str::starts_with(p, ">=") {
                min_ver = str::replace(p, ">=", "");
            } else if str::starts_with(p, "<") {
                max_ver = str::replace(p, "<", "");
            }
        }
        if min_ver != "" && core_version < min_ver {
            return false;
        }
        if max_ver != "" && (core_version == max_ver || core_version > max_ver) {
            return false;
        }
        return true;
    }
    if str::starts_with(range_str, "^") {
        let base_ver = str::replace(range_str, "^", "");
        return str::starts_with(core_version, "0.") && str::starts_with(base_ver, "0.") && core_version >= base_ver;
    }
    if str::starts_with(range_str, ">=") {
        let min_ver = str::replace(range_str, ">=", "");
        return core_version >= min_ver;
    }
    core_version == range_str
}

fn compute_subpath_tree_inventory(root, subpath) {
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

fn validate_policy_free_fixture(fixture_root) {
    let skill_path = path::join(fixture_root, "SKILL.md");
    let manifest_path = path::join(fixture_root, "northstar-package.json");
    require(fs::is_file(skill_path), "policy-free fixture missing SKILL.md");
    require(fs::is_file(manifest_path), "policy-free fixture missing northstar-package.json");

    let manifest = json::read_file(manifest_path);
    validate_manifest(manifest, "policy-free fixture manifest");

    for forbidden in ["catalogue.json", "profile.schema.json", "strict-audit.json", "strict-authoring.json"] {
        if fs::is_file(path::join(fixture_root, forbidden)) {
            let err = "policy-free fixture contains production language file: ";
            err += forbidden;
            throw(err);
        }
    }

    let manifest_text = fs::read_file(manifest_path);
    if manifest_text.contains("RUST-") || manifest_text.contains("TS-") || manifest_text.contains("SVELTE-") {
        throw("policy-free fixture contains production rule IDs");
    }
    if manifest_text.contains("rust") || manifest_text.contains("typescript") || manifest_text.contains("svelte") {
        throw("policy-free fixture contains production language bindings");
    }

    let self_check_entry = manifest["self_check"]["entrypoint"];
    let self_check_path = path::join(fixture_root, self_check_entry);
    require(fs::is_file(self_check_path), "policy-free fixture self-check entrypoint missing: " + self_check_entry);
}

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
        validate_manifest(manifest, label);
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
        validate_registry(registry, label);
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

fn run_negative_oracle_suite(target_skill_root) {
    let fixtures_root = path::join(target_skill_root, "assets/fixtures/language-packages");

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
    expect_registry_rejection("mutable-registry-commit-branch", mutable_registry, "must be immutable 40/64-char hex");

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
    expect_registry_rejection("mutable-registry-commit-tag", tag_registry, "must be immutable 40/64-char hex");

    // Invariant 4: Packages are independent (addressing one yields only its subpath).
    let sibling_root = path::join(fixtures_root, "sibling-packages");
    let alpha_files = compute_subpath_tree_inventory(sibling_root, "packages/alpha-pkg");
    let beta_files = compute_subpath_tree_inventory(sibling_root, "packages/beta-pkg");
    require(alpha_files == ["SKILL.md", "northstar-package.json", "scripts/self-check.rhai"],
        "alpha package inventory leaked or drifted");
    require(beta_files == ["SKILL.md", "northstar-package.json", "scripts/self-check.rhai"],
        "beta package inventory leaked or drifted");
    for f in alpha_files {
        require(!f.contains("beta"), "alpha package retained beta file: " + f);
    }
    for f in beta_files {
        require(!f.contains("alpha"), "beta package retained alpha file: " + f);
    }

    // Invariant 5: Core compatibility is exact.
    let current_core = "0.2.0";
    let incompatible_manifest_path = path::join(fixtures_root, "negative/incompatible-range/northstar-package.json");
    let incomp_manifest = json::read_file(incompatible_manifest_path);
    expect_compat_rejection("incompatible-core-range", incomp_manifest["compatible_core_range"], current_core, incomp_manifest["package_id"], "incompatible with Northstar core");

    // Invariant 6: Malformed manifests rejected.
    let missing_fields_path = path::join(fixtures_root, "negative/malformed-manifest/missing-fields.json");
    let missing_manifest = json::read_file(missing_fields_path);
    expect_manifest_rejection("malformed-manifest-missing-fields", missing_manifest, "missing required field");

    let invalid_kind_path = path::join(fixtures_root, "negative/malformed-manifest/invalid-kind.json");
    let invalid_kind_manifest = json::read_file(invalid_kind_path);
    expect_manifest_rejection("malformed-manifest-invalid-kind", invalid_kind_manifest, "kind must be 'language-quality'");
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
validate_registry(registry, "official-registry.json");

let fixture_root = path::join(northstar_skill_root, "assets/fixtures/language-packages/policy-free-fixture");
validate_policy_free_fixture(fixture_root);

run_negative_oracle_suite(northstar_skill_root);
scan_forbidden_dependencies(northstar_skill_root);

log("Northstar language package machine contracts: OK (3 schemas, official registry, policy-free fixture, 6 negative oracle invariants, portable contracts)");
