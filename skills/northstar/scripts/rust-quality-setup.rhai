fn require(condition, message) {
    if !condition {
        throw("[northstar:rust-quality-setup] " + message);
    }
}

fn resolve_path(base_root, raw_path) {
    if str::starts_with(raw_path, "/") {
        raw_path
    } else {
        path::join(base_root, raw_path)
    }
}

fn relative_path(root, file) {
    let prefix = root;
    if !str::ends_with(prefix, "/") {
        prefix += "/";
    }
    require(str::starts_with(file, prefix), "discovered file escaped target root: " + file);
    str::replace(file, prefix, "")
}

fn ignored_path(relative) {
    str::starts_with(relative, ".git/") ||
        str::starts_with(relative, ".effigy/") ||
        str::starts_with(relative, "target/") ||
        str::starts_with(relative, "vendor/") ||
        relative.contains("/.git/") ||
        relative.contains("/.effigy/") ||
        relative.contains("/target/") ||
        relative.contains("/vendor/")
}

fn matches_name(relative, name) {
    if relative == name {
        return true;
    }
    str::ends_with(relative, "/" + name)
}

fn discover_named_file(target_root, name) {
    let found = [];
    for file in fs::list_recursive(target_root) {
        let relative = relative_path(target_root, file);
        if !ignored_path(relative) && matches_name(relative, name) {
            found.push(relative);
        }
    }
    found.sort();
    found
}

fn strip_trailing_slashes(value) {
    regex::replace("/+$", value, "")
}

fn normalize_scope_directory(target_root, scope) {
    require(type_of(scope) == "string" && scope != "",
        "scope directory must be repository-relative (. or crates/foo)");
    require(!scope.contains(".."),
        "scope directory cannot contain '..'; use repository-relative form (. or crates/foo): " + scope);

    if str::starts_with(scope, "/") {
        let root = strip_trailing_slashes(target_root);
        let absolute = strip_trailing_slashes(scope);
        require(root != "" && absolute != "",
            "scope directory must be repository-relative (. or crates/foo): " + scope);
        if absolute == root {
            return ".";
        }
        let prefix = root + "/";
        require(str::starts_with(absolute, prefix),
            "scope directory must be under the target root; use repository-relative form (. or crates/foo): " + scope);
        let relative = regex::replace("^" + regex::escape(prefix), absolute, "");
        require(relative != "" && regex::is_match("^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$", relative),
            "scope directory must be repository-relative (. or crates/foo): " + scope);
        return relative;
    }

    require(scope == "." || regex::is_match("^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$", scope),
        "scope directory must be repository-relative (. or crates/foo): " + scope);
    scope
}

fn validate_profile(profile) {
    require(type_of(profile) == "map", "existing Rust quality profile must be an object");
    require(profile.contains("schema_version") && profile["schema_version"] == "1.0.0",
        "existing Rust quality profile uses an unsupported schema");
    require(profile.contains("language") && profile["language"] == "rust",
        "existing Rust quality profile must select rust");
    require(profile.contains("profile") && profile["profile"] == "strict",
        "existing Rust quality profile must select strict");
    require(profile.contains("msrv") && type_of(profile["msrv"]) == "map",
        "existing Rust quality profile lacks MSRV policy");
    require(profile["msrv"].contains("when_unresolved") &&
        profile["msrv"]["when_unresolved"] == "stop",
        "existing Rust quality profile must stop on unresolved MSRV policy");
    require(profile.contains("deviations_file") &&
        profile["deviations_file"] == "docs/contracts/rust-quality-deviations.json",
        "existing Rust quality profile has an unsupported deviations path");
}

fn validate_deviations(deviations) {
    require(type_of(deviations) == "map", "existing Rust deviations file must be an object");
    require(deviations.contains("schema_version") && deviations["schema_version"] == "1.0.0",
        "existing Rust deviations file uses an unsupported schema");
    require(deviations.contains("language") && deviations["language"] == "rust",
        "existing Rust deviations file must select rust");
    require(deviations.contains("deviations") && type_of(deviations["deviations"]) == "array",
        "existing Rust deviations file lacks deviations array");
}

fn agent_instruction_state(agent_file, activation) {
    let start_marker = "<!-- northstar:rust-quality:start -->";
    let end_marker = "<!-- northstar:rust-quality:end -->";
    if !fs::exists(agent_file) {
        return "missing";
    }
    require(fs::is_file(agent_file), "AGENTS target is not a file: " + agent_file);
    let current = fs::read_file(agent_file);
    let has_start = current.contains(start_marker);
    let has_end = current.contains(end_marker);
    require(has_start == has_end, "existing AGENTS.md has an incomplete Rust activation block");
    if has_start {
        require(current.contains(activation),
            "existing Rust activation differs from the installed Northstar template; inspect before replacing it");
        "current"
    } else {
        "append"
    }
}

fn install_agent_instructions(agent_file, activation, state) {
    if state == "missing" {
        fs::write_file(agent_file, activation);
    } else if state == "append" {
        let current = fs::read_file(agent_file);
        let separator = "\n";
        if str::ends_with(current, "\n") {
            separator = "";
        }
        fs::write_file(agent_file, current + separator + "\n" + activation);
    }
}

fn repository_declares_msrv(target_root, manifests, toolchain_paths) {
    for relative in manifests {
        if fs::read_file(path::join(target_root, relative)).contains("rust-version") {
            return true;
        }
    }
    toolchain_paths.len() > 0
}

fn apply_setup(skill_root, target_root, scope) {
    require(fs::is_dir(target_root), "target root is not a directory: " + target_root);
    let scope = normalize_scope_directory(target_root, scope);
    let scope_root = target_root;
    if scope != "." {
        scope_root = path::join(target_root, scope);
    }
    require(fs::is_dir(scope_root), "Rust instruction scope is not a directory: " + scope);

    let manifests = discover_named_file(target_root, "Cargo.toml");
    require(manifests.len() > 0, "no Cargo.toml found under target root");
    let toolchain_paths = discover_named_file(target_root, "rust-toolchain.toml");
    for relative in discover_named_file(target_root, "rust-toolchain") {
        toolchain_paths.push(relative);
    }
    toolchain_paths.sort();

    let asset_root = path::join(skill_root, "assets/templates/language-quality/rust");
    let activation = fs::read_file(path::join(asset_root, "AGENTS.md"));
    let agent_file = path::join(scope_root, "AGENTS.md");
    let agent_state = agent_instruction_state(agent_file, activation);

    let contracts_root = path::join(target_root, "docs/contracts");
    let profile_file = path::join(contracts_root, "rust-quality-profile.json");
    let deviations_file = path::join(contracts_root, "rust-quality-deviations.json");
    if fs::exists(profile_file) {
        require(fs::is_file(profile_file), "Rust quality profile target is not a file");
        validate_profile(json::read_file(profile_file));
    }
    if fs::exists(deviations_file) {
        require(fs::is_file(deviations_file), "Rust deviations target is not a file");
        validate_deviations(json::read_file(deviations_file));
    }

    install_agent_instructions(agent_file, activation, agent_state);
    if !fs::exists(profile_file) || !fs::exists(deviations_file) {
        fs::create_dir(contracts_root);
    }
    if !fs::exists(profile_file) {
        let profile = json::read_file(path::join(asset_root, "rust-quality-profile.json"));
        profile["msrv"]["cargo_manifests"] = manifests;
        profile["msrv"]["toolchain_policy_paths"] = toolchain_paths;
        json::write_file(profile_file, profile);
    }
    if !fs::exists(deviations_file) {
        let deviations = json::read_file(path::join(asset_root, "rust-quality-deviations.json"));
        json::write_file(deviations_file, deviations);
    }

    if !repository_declares_msrv(target_root, manifests, toolchain_paths) {
        log_warn("[northstar:rust-quality-setup] activation installed, but repository MSRV is unresolved; obtain repository policy before version-sensitive work");
    }
    log("Northstar Rust quality activation: OK (scope=" + scope +
        ", manifests=" + manifests.len() + ", toolchain_paths=" + toolchain_paths.len() + ")");
}

fn expect_error(label, action, expected) {
    let rejected = false;
    try {
        call(action);
    } catch (error) {
        rejected = true;
        require(error.to_string().contains(expected),
            label + " rejected for wrong reason: " + error.to_string());
    }
    require(rejected, label + " unexpectedly passed");
}

fn self_test(skill_root) {
    let target = fs::make_temp_dir("northstar-rust-quality-setup-positive");
    fs::create_dir(path::join(target, "crates/app/src"));
    fs::write_file(path::join(target, "Cargo.toml"),
        "[workspace]\nmembers = [\"crates/app\"]\n[workspace.package]\nrust-version = \"1.95\"\n");
    fs::write_file(path::join(target, "crates/app/Cargo.toml"),
        "[package]\nname = \"app\"\nversion = \"0.1.0\"\nrust-version.workspace = true\n");
    fs::write_file(path::join(target, "AGENTS.md"), "# Existing instructions\n");
    apply_setup(skill_root, target, ".");

    let profile_file = path::join(target, "docs/contracts/rust-quality-profile.json");
    let deviations_file = path::join(target, "docs/contracts/rust-quality-deviations.json");
    let agent_file = path::join(target, "AGENTS.md");
    let profile = json::read_file(profile_file);
    require(profile["msrv"]["cargo_manifests"] == ["Cargo.toml", "crates/app/Cargo.toml"],
        "setup did not discover Cargo manifests deterministically");
    require(profile["msrv"]["toolchain_policy_paths"] == [],
        "setup invented a toolchain policy path");
    require(fs::read_file(agent_file).contains("# Existing instructions"),
        "setup overwrote existing AGENTS instructions");
    require(fs::read_file(agent_file).contains("<!-- northstar:rust-quality:start -->"),
        "setup did not install scoped activation");

    let profile_hash = fs::sha256(profile_file);
    let deviations_hash = fs::sha256(deviations_file);
    let agent_hash = fs::sha256(agent_file);
    apply_setup(skill_root, target, ".");
    require(fs::sha256(profile_file) == profile_hash &&
        fs::sha256(deviations_file) == deviations_hash &&
        fs::sha256(agent_file) == agent_hash,
        "repeat setup was not idempotent");

    let no_cargo = fs::make_temp_dir("northstar-rust-quality-setup-no-cargo");
    expect_error("missing Cargo manifest", || apply_setup(skill_root, no_cargo, "."), "no Cargo.toml");

    let broken = fs::make_temp_dir("northstar-rust-quality-setup-broken-agents");
    fs::write_file(path::join(broken, "Cargo.toml"),
        "[package]\nname = \"broken\"\nversion = \"0.1.0\"\nrust-version = \"1.95\"\n");
    fs::write_file(path::join(broken, "AGENTS.md"),
        "<!-- northstar:rust-quality:start -->\n");
    expect_error("partial activation", || apply_setup(skill_root, broken, "."), "incomplete Rust activation");

    let absolute_root = fs::make_temp_dir("northstar-rust-quality-setup-absolute-root");
    fs::create_dir(path::join(absolute_root, "crates/app"));
    fs::write_file(path::join(absolute_root, "Cargo.toml"),
        "[package]\nname = \"absolute-root\"\nversion = \"0.1.0\"\nrust-version = \"1.95\"\n");
    require(normalize_scope_directory(absolute_root, absolute_root) == ".",
        "absolute target-root scope did not canonicalize to '.'");
    require(normalize_scope_directory(absolute_root, path::join(absolute_root, "crates/app")) == "crates/app",
        "absolute under-target scope did not canonicalize to relative form");
    apply_setup(skill_root, absolute_root, absolute_root);
    require(fs::read_file(path::join(absolute_root, "AGENTS.md")).contains("<!-- northstar:rust-quality:start -->"),
        "absolute target-root scope did not install activation");

    expect_error("escaped absolute scope",
        || normalize_scope_directory(absolute_root, "/tmp/northstar-rust-quality-setup-outside-scope"),
        "repository-relative form (. or crates/foo)");
    expect_error("parent scope segment",
        || normalize_scope_directory(absolute_root, ".."),
        "repository-relative form (. or crates/foo)");

    log("Northstar Rust quality setup self-test: OK (install, preserve, idempotency, absolute-under-target, 4 negative paths)");
}

let skill_root = repo_root;
if fs::is_dir(path::join(repo_root, "skills/northstar/assets/templates/language-quality/rust")) {
    skill_root = path::join(repo_root, "skills/northstar");
}

if args.len() == 1 && args[0] == "self-test" {
    self_test(skill_root);
} else if (args.len() == 2 || args.len() == 3) && args[0] == "apply" {
    let target_root = resolve_path(repo_root, args[1]);
    let scope = ".";
    if args.len() == 3 {
        scope = args[2];
    }
    apply_setup(skill_root, target_root, scope);
} else {
    throw("usage: rust-quality:setup self-test | apply <target-root> [scope-directory (. or crates/foo)]");
}
