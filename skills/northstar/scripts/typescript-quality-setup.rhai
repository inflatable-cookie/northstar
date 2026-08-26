fn require(condition, message) {
    if !condition { throw("[northstar:typescript-quality-setup] " + message); }
}

fn resolve_path(base_root, raw_path) {
    if str::starts_with(raw_path, "/") { raw_path } else { path::join(base_root, raw_path) }
}

fn relative_path(root, file) {
    let prefix = root;
    if !str::ends_with(prefix, "/") { prefix += "/"; }
    require(str::starts_with(file, prefix), "discovered file escaped target root: " + file);
    str::replace(file, prefix, "")
}

fn dirname(relative) {
    if !relative.contains("/") { return "."; }
    let parts = relative.split("/");
    parts.pop();
    let result = parts[0];
    for index in 1..parts.len() { result += "/" + parts[index]; }
    result
}

fn ignored_path(relative) {
    for segment in [
        ".git", ".effigy", "node_modules", "target", "dist", "build", ".svelte-kit",
        "coverage", "vendor", "vendored", "generated", "fixtures", "docs",
    ] {
        if relative == segment || str::starts_with(relative, segment + "/") ||
            relative.contains("/" + segment + "/") { return true; }
    }
    false
}

fn discover_manifests(target_root) {
    let manifests = [];
    for file in fs::list_recursive(target_root) {
        let relative = relative_path(target_root, file);
        if !ignored_path(relative) && (relative == "package.json" || str::ends_with(relative, "/package.json")) {
            manifests.push(relative);
        }
    }
    manifests.sort();
    manifests
}

fn dependency_version(manifest, name) {
    for key in ["dependencies", "devDependencies", "peerDependencies", "optionalDependencies"] {
        if manifest.contains(key) && type_of(manifest[key]) == "map" && manifest[key].contains(name) {
            return manifest[key][name].to_string();
        }
    }
    ""
}

fn major_supported(version, major) {
    regex::is_match("^[~^<>= ]*" + major + "(?:[.xX* -]|$)", version)
}

fn workspace_patterns(root_manifest) {
    let patterns = [];
    if !root_manifest.contains("workspaces") { return patterns; }
    let workspaces = root_manifest["workspaces"];
    if type_of(workspaces) == "array" {
        for item in workspaces { patterns.push(item.to_string()); }
    } else if type_of(workspaces) == "map" && workspaces.contains("packages") {
        for item in workspaces["packages"] { patterns.push(item.to_string()); }
    }
    patterns
}

fn workspace_owns(package_root, patterns) {
    for pattern in patterns {
        let normalized = pattern;
        if str::ends_with(normalized, "/*") {
            let parent = normalized.sub_string(0, normalized.len() - 2);
            if str::starts_with(package_root, parent + "/") &&
                !str::replace(package_root, parent + "/", "").contains("/") { return true; }
        } else if package_root == normalized { return true; }
    }
    false
}

fn file_owned_by_manifest(relative, manifest_path, manifests) {
    let selected = "";
    let selected_length = -1;
    for candidate in manifests {
        let root = dirname(candidate);
        let owns = root == "." || relative == root || str::starts_with(relative, root + "/");
        if owns && root.len() > selected_length {
            selected = candidate;
            selected_length = root.len();
        }
    }
    selected == manifest_path
}

fn owned_source_evidence(target_root, manifest_path, manifests) {
    let typescript_sources = [];
    let svelte_source = false;
    let kit_semantics = false;
    for file in fs::list_recursive(target_root) {
        let relative = relative_path(target_root, file);
        if !ignored_path(relative) && file_owned_by_manifest(relative, manifest_path, manifests) {
            if str::ends_with(relative, ".ts") || str::ends_with(relative, ".tsx") ||
                str::ends_with(relative, ".mts") || str::ends_with(relative, ".cts") {
                typescript_sources.push(relative);
            }
            if str::ends_with(relative, ".svelte") { svelte_source = true; }
            if relative.contains("/src/routes/") || relative.contains("/src/hooks.") ||
                relative.contains(".server.") { kit_semantics = true; }
        }
    }
    #{ typescript_sources: typescript_sources, svelte_source: svelte_source, kit_semantics: kit_semantics }
}

fn resolve_overlay_evidence(manifest, manifest_path, owned) {
    let svelte_version = dependency_version(manifest, "svelte");
    let kit_version = dependency_version(manifest, "@sveltejs/kit");
    let overlays = ["base"];
    let svelte_evidence = #{ status: "absent", version: (), source: () };
    let kit_evidence = #{ status: "absent", version: (), source: () };
    if svelte_version != "" {
        svelte_evidence = #{ status: "unsupported", version: svelte_version, source: manifest_path };
        if major_supported(svelte_version, "5") {
            svelte_evidence["status"] = "supported";
            if owned["svelte_source"] { overlays.push("svelte"); }
        }
    }
    if kit_version != "" {
        kit_evidence = #{ status: "unsupported", version: kit_version, source: manifest_path };
        if major_supported(kit_version, "2") {
            kit_evidence["status"] = "supported";
            if owned["kit_semantics"] {
                overlays.push("sveltekit");
            }
        }
    }
    #{ overlays: overlays, version_evidence: #{ svelte: svelte_evidence, sveltekit: kit_evidence } }
}

fn package_record(target_root, manifest_path, ownership, manifests) {
    let package_root = dirname(manifest_path);
    let manifest = json::read_file(path::join(target_root, manifest_path));
    require(type_of(manifest) == "map", "package manifest must be an object: " + manifest_path);
    let owned = owned_source_evidence(target_root, manifest_path, manifests);
    let typescript_evidence_sources = owned["typescript_sources"];
    let typescript_version = dependency_version(manifest, "typescript");
    let tsconfig = "tsconfig.json";
    if package_root != "." { tsconfig = package_root + "/tsconfig.json"; }
    if typescript_version != "" { typescript_evidence_sources.push(manifest_path); }
    if fs::is_file(path::join(target_root, tsconfig)) { typescript_evidence_sources.push(tsconfig); }
    let typescript_status = "unavailable";
    if typescript_evidence_sources.len() > 0 { typescript_status = "supported"; }
    let overlay = resolve_overlay_evidence(manifest, manifest_path, owned);
    #{
        root: package_root,
        manifest: manifest_path,
        ownership: ownership,
        typescript_evidence: #{ status: typescript_status, sources: typescript_evidence_sources },
        overlays: overlay["overlays"],
        version_evidence: overlay["version_evidence"],
    }
}

fn discover_workspace_packages(target_root, manifests) {
    let packages = [];
    let unregistered = [];
    let root_manifest = json::read_file(path::join(target_root, "package.json"));
    let patterns = workspace_patterns(root_manifest);
    let root_package = package_record(target_root, "package.json", "root_workspace", manifests);
    packages.push(root_package);
    for manifest_path in manifests {
        if manifest_path != "package.json" {
            let package_root = dirname(manifest_path);
            if workspace_owns(package_root, patterns) {
                let workspace_package = package_record(target_root, manifest_path, "workspace_member", manifests);
                packages.push(workspace_package);
            } else {
                unregistered.push(manifest_path);
            }
        }
    }
    #{ packages: packages, unregistered: unregistered }
}

fn discover_independent_packages(target_root, manifests) {
    let packages = [];
    for manifest_path in manifests {
        let independent_package = package_record(target_root, manifest_path, "independent_root", manifests);
        packages.push(independent_package);
    }
    #{ packages: packages, unregistered: [] }
}

fn discover_packages(target_root) {
    let manifests = discover_manifests(target_root);
    require(manifests.len() > 0, "no package.json found under target root");
    if manifests.contains("package.json") {
        discover_workspace_packages(target_root, manifests)
    } else {
        discover_independent_packages(target_root, manifests)
    }
}

fn validate_profile(profile) {
    require(type_of(profile) == "map" && profile["schema_version"] == "1.0.0",
        "existing TypeScript quality profile uses an unsupported schema");
    require(profile["language"] == "typescript" && profile["workflow"] == "explicit_audit_repair",
        "existing TypeScript quality profile has unsupported language or workflow");
    require(profile["profile"] == "strict", "existing TypeScript quality profile must select strict");
    require(type_of(profile["packages"]) == "array" && profile["when_unresolved"] == "stop",
        "existing TypeScript quality profile lacks package ownership or fail-closed policy");
    require(profile["deviations_file"] == "docs/contracts/typescript-quality-deviations.json",
        "existing TypeScript quality profile has an unsupported deviations path");
}

fn validate_deviations(value) {
    require(type_of(value) == "map" && value["schema_version"] == "1.0.0" &&
        value["language"] == "typescript" && type_of(value["deviations"]) == "array",
        "existing TypeScript deviations file is invalid");
}

fn require_scope(scope) {
    require(scope == "." || regex::is_match("^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$", scope),
        "scope directory must be repository-relative: " + scope);
    require(!scope.contains(".."), "scope directory cannot contain '..'");
}

fn activation_state(agent_file, activation) {
    if !fs::exists(agent_file) { return "missing"; }
    require(fs::is_file(agent_file), "AGENTS target is not a file");
    let current = fs::read_file(agent_file);
    let has_start = current.contains("<!-- northstar:typescript-quality:start -->");
    let has_end = current.contains("<!-- northstar:typescript-quality:end -->");
    require(has_start == has_end, "existing AGENTS.md has an incomplete TypeScript activation block");
    if has_start {
        require(current.contains(activation), "existing TypeScript activation differs from installed template");
        "current"
    } else { "append" }
}

fn apply_setup(skill_root, target_root, scope) {
    require(fs::is_dir(target_root), "target root is not a directory");
    require_scope(scope);
    let scope_root = target_root;
    if scope != "." { scope_root = path::join(target_root, scope); }
    require(fs::is_dir(scope_root), "TypeScript instruction scope is not a directory: " + scope);
    let discovery = discover_packages(target_root);
    let asset_root = path::join(skill_root, "assets/templates/language-quality/typescript");
    let activation = fs::read_file(path::join(asset_root, "AGENTS.md"));
    let agent_file = path::join(scope_root, "AGENTS.md");
    let state = activation_state(agent_file, activation);
    let contracts_root = path::join(target_root, "docs/contracts");
    let profile_file = path::join(contracts_root, "typescript-quality-profile.json");
    let deviations_file = path::join(contracts_root, "typescript-quality-deviations.json");
    if fs::exists(profile_file) { validate_profile(json::read_file(profile_file)); }
    if fs::exists(deviations_file) { validate_deviations(json::read_file(deviations_file)); }

    if state == "missing" { fs::write_file(agent_file, activation); }
    if state == "append" {
        let current = fs::read_file(agent_file);
        let separator = "\n\n";
        if str::ends_with(current, "\n") { separator = "\n"; }
        fs::write_file(agent_file, current + separator + activation);
    }
    if !fs::exists(profile_file) || !fs::exists(deviations_file) { fs::create_dir(contracts_root); }
    if !fs::exists(profile_file) {
        let profile = json::read_file(path::join(asset_root, "typescript-quality-profile.json"));
        profile["packages"] = discovery["packages"];
        profile["unregistered_candidates"] = discovery["unregistered"];
        json::write_file(profile_file, profile);
    }
    if !fs::exists(deviations_file) {
        json::write_file(deviations_file,
            json::read_file(path::join(asset_root, "typescript-quality-deviations.json")));
    }
    log("Northstar TypeScript quality activation: OK (scope=" + scope +
        ", packages=" + discovery["packages"].len() +
        ", unregistered=" + discovery["unregistered"].len() + ")");
}

fn test_mixed_workspace(skill_root) {
    let mixed = fs::make_temp_dir("northstar-typescript-setup-mixed");
    fs::create_dir(path::join(mixed, "apps/web"));
    fs::create_dir(path::join(mixed, "apps/web/src/routes"));
    fs::create_dir(path::join(mixed, "packages/core"));
    fs::create_dir(path::join(mixed, "scratch/loose"));
    fs::write_file(path::join(mixed, "package.json"), "{\"private\":true,\"workspaces\":[\"apps/*\",\"packages/*\"]}\n");
    fs::write_file(path::join(mixed, "apps/web/package.json"), "{\"dependencies\":{\"svelte\":\"^5.0.0\",\"@sveltejs/kit\":\"^2.0.0\"}}\n");
    fs::write_file(path::join(mixed, "apps/web/src/routes/+page.svelte"), "<h1>Web</h1>\n");
    fs::write_file(path::join(mixed, "apps/web/src/routes/+page.server.ts"), "export const load = () => ({});\n");
    fs::write_file(path::join(mixed, "packages/core/package.json"), "{\"devDependencies\":{\"typescript\":\"^5.9.0\"}}\n");
    fs::write_file(path::join(mixed, "scratch/loose/package.json"), "{\"name\":\"loose\"}\n");
    fs::write_file(path::join(mixed, "apps/web/AGENTS.md"), "# Existing\n");
    apply_setup(skill_root, mixed, "apps/web");
    let profile_path = path::join(mixed, "docs/contracts/typescript-quality-profile.json");
    let profile = json::read_file(profile_path);
    require(profile["packages"].len() == 3, "declared workspace package count drifted");
    require(profile["unregistered_candidates"] == ["scratch/loose/package.json"], "unregistered package was absorbed");
    require(profile["packages"][1]["overlays"] == ["base", "svelte", "sveltekit"], "Svelte overlays did not resolve locally");
    require(fs::read_file(path::join(mixed, "apps/web/AGENTS.md")).contains("# Existing"), "setup overwrote scoped instructions");
    let profile_hash = fs::sha256(profile_path);
    let agent_hash = fs::sha256(path::join(mixed, "apps/web/AGENTS.md"));
    apply_setup(skill_root, mixed, "apps/web");
    require(fs::sha256(profile_path) == profile_hash && fs::sha256(path::join(mixed, "apps/web/AGENTS.md")) == agent_hash,
        "repeat setup was not idempotent");
}

fn test_rootless_packages(skill_root) {
    let rootless = fs::make_temp_dir("northstar-typescript-setup-rootless");
    fs::create_dir(path::join(rootless, "apps/site"));
    fs::create_dir(path::join(rootless, "packages/lib"));
    fs::write_file(path::join(rootless, "apps/site/package.json"), "{\"dependencies\":{\"svelte\":\"4.2.0\"}}\n");
    fs::write_file(path::join(rootless, "packages/lib/package.json"), "{\"devDependencies\":{\"typescript\":\"^5.9.0\"}}\n");
    apply_setup(skill_root, rootless, "apps/site");
    let rootless_profile = json::read_file(path::join(rootless, "docs/contracts/typescript-quality-profile.json"));
    require(rootless_profile["packages"].len() == 2, "rootless package count drifted");
    let rootless_site = rootless_profile["packages"][0];
    require(rootless_site["ownership"] == "independent_root", "rootless package was not independently owned");
    require(rootless_site["overlays"] == ["base"], "unsupported Svelte activated an overlay");
    let rootless_svelte = rootless_site["version_evidence"]["svelte"];
    require(rootless_svelte["status"] == "unsupported", "unsupported Svelte version was not recorded");
}

fn test_setup_rejections(skill_root) {
    let empty = fs::make_temp_dir("northstar-typescript-setup-empty");
    let empty_rejected = false;
    try { apply_setup(skill_root, empty, "."); } catch (error) {
        empty_rejected = true;
        require(error.to_string().contains("no package.json"), "missing package rejected for wrong reason: " + error);
    }
    require(empty_rejected, "missing package manifest unexpectedly passed");
    let broken = fs::make_temp_dir("northstar-typescript-setup-broken");
    fs::write_file(path::join(broken, "package.json"), "{}\n");
    fs::write_file(path::join(broken, "AGENTS.md"), "<!-- northstar:typescript-quality:start -->\n");
    let broken_rejected = false;
    try { apply_setup(skill_root, broken, "."); } catch (error) {
        broken_rejected = true;
        require(error.to_string().contains("incomplete TypeScript activation"), "partial activation rejected for wrong reason: " + error);
    }
    require(broken_rejected, "partial activation unexpectedly passed");
}

let skill_root = repo_root;
if fs::is_dir(path::join(repo_root, "skills/northstar/assets/templates/language-quality/typescript")) {
    skill_root = path::join(repo_root, "skills/northstar");
}
if args.len() == 1 && args[0] == "self-test" {
    test_mixed_workspace(skill_root);
    test_rootless_packages(skill_root);
    test_setup_rejections(skill_root);
    log("Northstar TypeScript quality setup self-test: OK (mixed workspace, rootless packages, overlays, preserve, idempotency, 2 negative paths)");
} else if (args.len() == 2 || args.len() == 3) && args[0] == "apply" {
    let scope = ".";
    if args.len() == 3 { scope = args[2]; }
    apply_setup(skill_root, resolve_path(repo_root, args[1]), scope);
} else {
    throw("usage: typescript-quality:setup self-test | apply <target-root> [scope-directory]");
}
