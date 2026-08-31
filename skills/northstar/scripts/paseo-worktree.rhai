fn require(condition, message) {
    if !condition {
        throw("[northstar:paseo-worktree] " + message);
    }
}

fn canonical_existing(raw_path) {
    let result = exec::run(
        ["realpath", raw_path],
        #{ run_in: "host", cwd: repo_root },
    );
    require(result["success"], "cannot resolve path `" + raw_path + "`: " + str::trim(result["stderr"]));
    str::trim(result["stdout"])
}

fn linked_worktree_primary(target_root) {
    let dot_git = path::join(target_root, ".git");
    if fs::is_dir(dot_git) {
        return "";
    }
    require(fs::is_file(dot_git), "target is not a Git checkout: " + target_root);

    let git_dir = "";
    for line in str::split_lines(fs::read_file(dot_git)) {
        let trimmed = str::trim(line);
        if str::starts_with(trimmed, "gitdir:") {
            git_dir = str::trim(regex::replace("^gitdir:", trimmed, ""));
        }
    }
    require(git_dir != "", "linked worktree .git file has no gitdir pointer");
    if !str::starts_with(git_dir, "/") {
        git_dir = path::join(target_root, git_dir);
    }

    let common_dir = git_dir;
    let common_file = path::join(git_dir, "commondir");
    if fs::is_file(common_file) {
        let common = str::trim(fs::read_file(common_file));
        require(common != "", "linked worktree commondir is empty");
        common_dir = common;
        if !str::starts_with(common_dir, "/") {
            common_dir = path::join(git_dir, common_dir);
        }
    }
    common_dir = canonical_existing(common_dir);
    require(path::file_name(common_dir) == ".git",
        "cannot derive primary checkout from Git common directory: " + common_dir);
    path::parent(common_dir)
}

fn read_link_records(checkout_root) {
    let ledger_path = path::join(checkout_root, ".effigy/local/dependency-links.json");
    if !fs::exists(ledger_path) {
        return [];
    }
    require(fs::is_file(ledger_path), "Effigy dependency-link ledger is not a file: " + ledger_path);
    let ledger = json::read_file(ledger_path);
    require(type_of(ledger) == "map", "Effigy dependency-link ledger must be an object");
    require(ledger.contains("schema") && ledger["schema"] == "effigy.deps.links.v1",
        "unsupported Effigy dependency-link ledger schema");
    require(ledger.contains("schema_version") && ledger["schema_version"] == 1,
        "unsupported Effigy dependency-link ledger version");
    require(ledger.contains("links") && type_of(ledger["links"]) == "array",
        "Effigy dependency-link ledger lacks links array");

    let records = [];
    for link in ledger["links"] {
        require(type_of(link) == "map" && link.contains("key") && type_of(link["key"]) == "map",
            "Effigy dependency-link ledger contains a malformed link");
        let key = link["key"];
        require(key.contains("manager") && (key["manager"] == "cargo" || key["manager"] == "bun"),
            "Effigy dependency-link ledger contains an unsupported manager");
        require(key.contains("library_path") && type_of(key["library_path"]) == "string" && key["library_path"] != "",
            "Effigy dependency-link ledger contains an invalid library path");
        records.push(#{ manager: key["manager"], source: key["library_path"] });
    }
    records
}

fn parse_source_spec(primary_root, raw_spec) {
    require(type_of(raw_spec) == "string" && raw_spec != "", "sibling source cannot be empty");
    let raw_source = raw_spec;
    let link_name = "";
    if raw_spec.contains("=") {
        raw_source = regex::replace("^([^=]+)=.*$", raw_spec, "$1");
        link_name = regex::replace("^[^=]+=", raw_spec, "");
    }
    require(raw_source != "", "sibling source cannot be empty: " + raw_spec);
    if !str::starts_with(raw_source, "/") {
        raw_source = path::join(primary_root, raw_source);
    }
    let source = canonical_existing(raw_source);
    if link_name == "" {
        link_name = path::file_name(source);
    }
    require(regex::is_match("^[A-Za-z0-9][A-Za-z0-9._-]*$", link_name),
        "sibling link name must be one safe path component: " + link_name);
    #{ source: source, name: link_name }
}

fn collect_sources(primary_root, extra_specs) {
    let requested = [];
    for record in read_link_records(primary_root) {
        requested.push(parse_source_spec(primary_root, record["source"]));
    }
    for raw_spec in extra_specs {
        requested.push(parse_source_spec(primary_root, raw_spec));
    }

    let by_name = #{};
    let sources = [];
    for source in requested {
        let name = source["name"];
        if by_name.contains(name) {
            require(by_name[name] == source["source"],
                "two sibling sources request the same link name `" + name + "`");
        } else {
            by_name[name] = source["source"];
            sources.push(source);
        }
    }
    sources.sort(|left, right| left["name"] < right["name"]);
    sources
}

fn prepare_links(target_root, sources) {
    let sibling_root = path::parent(target_root);
    let create = [];
    for source in sources {
        let destination = path::join(sibling_root, source["name"]);
        if fs::is_symlink(destination) {
            let observed = canonical_existing(destination);
            let mismatch = "sibling link `" + destination;
            mismatch += "` points to `" + observed;
            mismatch += "`, expected `" + source["source"] + "`";
            require(observed == source["source"], mismatch);
            log("[northstar:paseo-worktree] reuse " + destination + " -> " + observed);
        } else if fs::exists(destination) {
            throw("[northstar:paseo-worktree] sibling destination already exists and is not a symlink: " + destination);
        } else {
            let source_path = source["source"];
            let change = #{};
            change["source"] = source_path;
            change["destination"] = destination;
            create.push(change);
        }
    }

    for link in create {
        let source_path = link["source"];
        let destination = link["destination"];
        fs::create_symlink(source_path, destination);
        log("[northstar:paseo-worktree] create " + destination + " -> " + source_path);
    }
    log("Paseo sibling preparation: OK (sources=" + sources.len() + ")");
}

fn run_link_action(action, records) {
    for record in records {
        let result = effigy::run_json(["deps", action, record["manager"], record["source"]]);
        let expected_schema = "effigy.deps." + action + ".v1";
        require(type_of(result) == "map" && result.contains("schema") && result["schema"] == expected_schema,
            "effigy deps " + action + " returned unexpected evidence for " + record["source"]);
    }
    log("Paseo Effigy dependency " + action + ": OK (links=" + records.len() + ")");
}

fn prepare(target_root, extra_specs) {
    let primary_root = linked_worktree_primary(target_root);
    if primary_root == "" {
        log("Paseo sibling preparation: skipped (primary checkout)");
        return;
    }
    prepare_links(target_root, collect_sources(primary_root, extra_specs));
}

fn replay_links(target_root) {
    let primary_root = linked_worktree_primary(target_root);
    if primary_root == "" {
        log("Paseo Effigy dependency link: skipped (primary checkout)");
        return;
    }
    run_link_action("link", read_link_records(primary_root));
}

fn unlink_worktree(target_root) {
    let primary_root = linked_worktree_primary(target_root);
    if primary_root == "" {
        log("Paseo Effigy dependency unlink: skipped (primary checkout)");
        return;
    }
    run_link_action("unlink", read_link_records(target_root));
}

fn self_test() {
    let fixture = fs::make_temp_dir("northstar-paseo-worktree");
    let primary = path::join(fixture, "primary");
    let library = path::join(fixture, "library");
    let worktrees = path::join(fixture, "worktrees");
    let worktree = path::join(worktrees, "lane");
    fs::create_dir(path::join(primary, ".effigy/local"));
    let worktree_git_dir = path::join(primary, ".git/worktrees/lane");
    fs::create_dir(worktree_git_dir);
    fs::write_file(path::join(worktree_git_dir, "commondir"), "../..\n");
    fs::create_dir(library);
    fs::create_dir(worktree);
    fs::write_file(path::join(worktree, ".git"), "gitdir: " + worktree_git_dir + "\n");
    let key = #{ manager: "cargo" };
    key["consumer_repo"] = primary;
    key["library_path"] = library;
    let link = #{ key: key };
    let ledger = #{
        schema: "effigy.deps.links.v1",
        schema_version: 1,
        links: [link],
    };
    json::write_file(path::join(primary, ".effigy/local/dependency-links.json"), ledger);

    require(linked_worktree_primary(worktree) == canonical_existing(primary),
        "self-test did not recover the linked worktree primary checkout");
    let sources = collect_sources(primary, []);
    require(sources.len() == 1, "self-test recovered the wrong link count");
    let recovered_source = sources[0]["source"];
    require(recovered_source == canonical_existing(library), "self-test did not recover the primary Effigy link");
    prepare(worktree, []);
    let destination = path::join(worktrees, path::file_name(library));
    require(fs::is_symlink(destination), "self-test did not create a sibling symlink");
    require(canonical_existing(destination) == canonical_existing(library), "self-test created the wrong sibling link");
    prepare_links(worktree, sources);

    let conflict_root = path::join(fixture, "conflict-worktrees");
    let conflict_worktree = path::join(conflict_root, "lane");
    fs::create_dir(conflict_worktree);
    fs::write_file(path::join(conflict_root, path::file_name(library)), "occupied\n");
    let rejected = false;
    try {
        prepare_links(conflict_worktree, sources);
    } catch (error) {
        rejected = error.to_string().contains("not a symlink");
    }
    require(rejected, "self-test did not stop on a conflicting sibling path");
    log("Northstar Paseo worktree helper self-test: OK");
}

let task_args = [];
for argument in args {
    task_args.push(argument);
}
if task_args.len() > 0 && task_args[0] == "--" {
    let forwarded = [];
    for index in 1..task_args.len() {
        forwarded.push(task_args[index]);
    }
    task_args = forwarded;
}

if task_args.len() == 0 {
    throw("usage: paseo:worktree <prepare [SOURCE[=LINK] ...]|link|unlink|self-test>");
}

let action = task_args[0];
if action == "prepare" {
    let extras = [];
    for index in 1..task_args.len() {
        extras.push(task_args[index]);
    }
    prepare(repo_root, extras);
} else if action == "link" {
    replay_links(repo_root);
} else if action == "unlink" {
    unlink_worktree(repo_root);
} else if action == "self-test" {
    self_test();
} else {
    throw("usage: paseo:worktree <prepare [SOURCE[=LINK] ...]|link|unlink|self-test>");
}
