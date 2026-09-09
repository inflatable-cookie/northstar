fn parse_active_generation(text) {
    let in_section = false;
    for line in str::split_lines(text) {
        if line == "## Active generation" {
            in_section = true;
            continue;
        }
        if in_section && (str::starts_with(line, "## ") || str::starts_with(line, "# ")) {
            break;
        }
        if in_section {
            let candidate = str::replace(line, "-", "");
            candidate = str::replace(candidate, "`", "");
            candidate = str::trim(candidate);
            if regex::is_match("^g[0-9]+$", candidate) {
                return candidate;
            }
        }
    }
    ""
}

fn parse_pending_migration_generations(text) {
    let pending = [];
    let in_log = false;
    for line in str::split_lines(text) {
        if line == "## Generation log" {
            in_log = true;
            continue;
        }
        if in_log && (str::starts_with(line, "## ") || str::starts_with(line, "# ")) {
            break;
        }
        if in_log && str::starts_with(line, "|") {
            let cells = [];
            for part in str::split_lines(str::replace(line, "|", "\n")) {
                let cell = str::trim(part);
                if cell != "" {
                    cells.push(cell);
                }
            }
            if cells.len() >= 4 {
                let gen_str = str::replace(cells[0], "`", "");
                let state = cells[1];
                let disposition = cells[3];
                if regex::is_match("^g[0-9]+$", gen_str) && state == "closed" {
                    if disposition.contains("roll-up") && !disposition.contains("archive/") {
                        pending.push(gen_str);
                    }
                }
            }
        }
    }
    pending
}

fn check_archive_non_authority(repo_root) {
    let archive_dir = path::join(repo_root, "docs/roadmaps/archive");
    if !fs::is_dir(archive_dir) {
        return;
    }

    for entry in fs::list(archive_dir) {
        if fs::is_file(entry) && str::ends_with(entry, ".md") {
            let text = fs::read_file(entry);
            let file_name = path::file_name(entry);

            if regex::is_match("(?m)^Status:\\s*(?:active|ready|in-flight)", text) {
                throw("archive roll-up " + file_name + " must not declare active status");
            }

            if regex::is_match("(?m)^##\\s*(?:Steps|Execution Plan|Acceptance Criteria)\\b", text) {
                throw("archive roll-up " + file_name + " must not contain runnable execution procedure");
            }

            if regex::is_match("(?m)^Auto-start next card:\\s*yes", text) {
                throw("archive roll-up " + file_name + " must not contain auto-start execution instructions");
            }

            let has_archived_status = regex::is_match("(?m)^Status:\\s*archived", text);
            let has_rollup_kind = regex::is_match("(?m)^Kind:\\s*roll-up", text);
            if !has_archived_status && !has_rollup_kind {
                throw("archive roll-up " + file_name + " must declare non-authoritative status (Status: archived or Kind: roll-up)");
            }
        }
    }
}

fn check_one_expanded_generation(repo_root) {
    let roadmaps_dir = path::join(repo_root, "docs/roadmaps");
    if !fs::is_dir(roadmaps_dir) {
        return;
    }

    let archive_dir = path::join(roadmaps_dir, "archive");
    if fs::is_dir(archive_dir) {
        for entry in fs::list(archive_dir) {
            if fs::is_file(entry) && str::ends_with(entry, ".md") {
                let file_name = path::file_name(entry);
                if regex::is_match("^g[0-9]+[.]md$", file_name) {
                    let gen = regex::replace("[.]md$", file_name, "");
                    let expanded_dir = path::join(roadmaps_dir, gen);
                    if fs::is_dir(expanded_dir) {
                        throw("archived generation " + gen + " must not remain expanded");
                    }
                }
            }
        }
    }

    let gen_index_file = path::join(roadmaps_dir, "generation-index.md");
    if fs::is_file(gen_index_file) {
        let index_text = fs::read_file(gen_index_file);
        let active_gen = parse_active_generation(index_text);
        let pending_migrations = parse_pending_migration_generations(index_text);

        let expanded_gens = [];
        for entry in fs::list(roadmaps_dir) {
            if fs::is_dir(entry) {
                let dir_name = path::file_name(entry);
                if regex::is_match("^g[0-9]+$", dir_name) {
                    expanded_gens.push(dir_name);
                }
            }
        }

        for gen in expanded_gens {
            if gen != active_gen && !pending_migrations.contains(gen) {
                throw("more than one expanded sequential generation in roadmaps: " + gen);
            }
        }
    }
}

fn check_retired_posture_labels(repo_root) {
    let roadmaps_dir = path::join(repo_root, "docs/roadmaps");
    if !fs::is_dir(roadmaps_dir) {
        return;
    }

    let files_to_check = [];
    let gen_index_file = path::join(roadmaps_dir, "generation-index.md");
    if fs::is_file(gen_index_file) {
        files_to_check.push(gen_index_file);
        let active_gen = parse_active_generation(fs::read_file(gen_index_file));
        if active_gen != "" {
            let active_gen_dir = path::join(roadmaps_dir, active_gen);
            if fs::is_dir(active_gen_dir) {
                for entry in fs::list(active_gen_dir) {
                    if fs::is_file(entry) && str::ends_with(entry, ".md") {
                        files_to_check.push(entry);
                    }
                }
            }
        }
    }

    let roadmaps_readme = path::join(roadmaps_dir, "README.md");
    if fs::is_file(roadmaps_readme) {
        files_to_check.push(roadmaps_readme);
    }

    let contract_index = path::join(repo_root, "docs/contracts/contract-index.md");
    if fs::is_file(contract_index) {
        files_to_check.push(contract_index);
    }

    let retired_pattern = "(?i)\\b(?:baseline-routing|strict-ready|strict-paused|full-strict|baseline posture|strict posture|mixed posture|lane-first posture|stricter posture)\\b";
    let retired_header_pattern = "(?i)^(?:operating\\s+)?posture:\\s*(?:baseline|strict|lane-first|mixed|full-strict)";
    let context_pattern = "(?i)(?:retired|remove|former|historical)";

    for file_path in files_to_check {
        let text = fs::read_file(file_path);
        let file_name = path::file_name(file_path);
        let prev_line = "";
        for line in str::split_lines(text) {
            let context_window = prev_line + " " + line;
            prev_line = line;
            if regex::is_match(context_pattern, context_window) {
                continue;
            }
            if regex::is_match(retired_pattern, line) {
                throw("retired posture label found in " + file_name + ": " + str::trim(line));
            }
            if regex::is_match(retired_header_pattern, line) {
                throw("retired posture header found in " + file_name + ": " + str::trim(line));
            }
        }
    }
}

fn check_post_merge_reconciliation(repo_root) {
    let script = path::join(repo_root, "scripts/tests/post-merge-reconciliation/validate_post_merge_reconciliation.py");
    if fs::is_file(script) {
        let res = process::run("python3", [script]);
        if !res["success"] {
            throw("post-merge reconciliation behavioral test failed: " + res["stderr"] + "\n" + res["stdout"]);
        }
    }
}

fn test_posture_label_rejection(repo_root) {
    let fixture_root = path::join(repo_root, "scripts/fixtures/lifecycle/posture-label-rejected");
    if fs::is_dir(fixture_root) {
        let failed = false;
        try {
            check_retired_posture_labels(fixture_root);
        } catch (err) {
            failed = true;
        }
        if !failed {
            throw("expected check_retired_posture_labels to fail on posture-label-rejected fixture, but it passed");
        }
    }
}

fn check_front_door_archive_links(repo_root) {
    let roadmaps_dir = path::join(repo_root, "docs/roadmaps");
    let archive_dir = path::join(roadmaps_dir, "archive");
    if !fs::is_dir(archive_dir) {
        return;
    }

    let archived_gens = [];
    for entry in fs::list(archive_dir) {
        if fs::is_file(entry) && str::ends_with(entry, ".md") {
            let file_name = path::file_name(entry);
            if regex::is_match("^g[0-9]+[.]md$", file_name) {
                archived_gens.push(str::replace(file_name, ".md", ""));
            }
        }
    }
    if archived_gens.len() == 0 {
        return;
    }

    let files_to_check = [];
    let candidates = [
        path::join(repo_root, "docs/README.md"),
        path::join(roadmaps_dir, "README.md"),
        path::join(roadmaps_dir, "generation-index.md"),
        path::join(repo_root, "docs/logs/README.md"),
        path::join(repo_root, "docs/contracts/contract-index.md"),
    ];
    for candidate in candidates {
        if fs::is_file(candidate) {
            files_to_check.push(candidate);
        }
    }

    for file_path in files_to_check {
        let text = fs::read_file(file_path);
        let file_name = path::file_name(file_path);
        for gen in archived_gens {
            let needle = gen + "/";
            if text.contains(needle) {
                throw("active front door " + file_name + " points at archived generation " + gen);
            }
        }
    }
}

fn list_expanded_generations(repo_root) {
    let gens = [];
    let roadmaps_dir = path::join(repo_root, "docs/roadmaps");
    if !fs::is_dir(roadmaps_dir) {
        return gens;
    }
    for entry in fs::list(roadmaps_dir) {
        if fs::is_dir(entry) && regex::is_match("^g[0-9]+$", path::file_name(entry)) {
            gens.push(entry);
        }
    }
    gens
}

fn check_no_nested_cards(repo_root) {
    for gen_dir in list_expanded_generations(repo_root) {
        let nested = path::join(gen_dir, "batch-cards");
        if fs::is_dir(nested) {
            throw("nested executable cards remain under docs/roadmaps/" + path::file_name(gen_dir) + "/batch-cards; flattened tasks live directly in the generation directory");
        }
    }
}

fn first_heading_id(text) {
    for line in str::split_lines(text) {
        if str::starts_with(line, "#") {
            let rest = line;
            while regex::is_match("g[0-9]+[.][0-9]+", rest) {
                let id = regex::replace("^(?:.*?)((?:g[0-9]+[.][0-9]+))(?:.*)$", rest, "$1");
                return id;
            }
            return "";
        }
    }
    ""
}

fn check_task_ids(repo_root) {
    let claimed_ids = [];
    let claimed_files = [];
    for gen_dir in list_expanded_generations(repo_root) {
        let gen = path::file_name(gen_dir);
        for entry in fs::list(gen_dir) {
            if !fs::is_file(entry) || !str::ends_with(entry, ".md") {
                continue;
            }
            let name = path::file_name(entry);
            if !regex::is_match("^[0-9]+-.+[.]md$", name) {
                continue;
            }
            let nnn = regex::replace("-.*$", name, "");
            let own_id = gen + "." + nnn;
            let heading_id = first_heading_id(fs::read_file(entry));
            if heading_id != "" && heading_id != own_id {
                throw("task file " + name + " heading claims " + heading_id + " but lives at " + own_id);
            }
            let dup_file = "";
            let i = 0;
            while i < claimed_ids.len() {
                if claimed_ids[i] == own_id {
                    dup_file = claimed_files[i];
                }
                i += 1;
            }
            if dup_file != "" {
                throw("duplicate task ID " + own_id + " claimed by " + name + " and " + dup_file);
            }
            claimed_ids.push(own_id);
            claimed_files.push(name);
        }
    }
}

fn frontier_ids_in(text) {
    let ids = [];
    for line in str::split_lines(text) {
        if !regex::is_match("(?i)(?:frontier|approved)", line) {
            continue;
        }
        let rest = line;
        while regex::is_match("g[0-9]+[.][0-9]+", rest) {
            let id = regex::replace("^(?:.*?)((?:g[0-9]+[.][0-9]+))(?:.*)$", rest, "$1");
            if !ids.contains(id) {
                ids.push(id);
            }
            rest = regex::replace("^(?:.*?)g[0-9]+[.][0-9]+(.*)$", rest, "$1");
        }
    }
    ids
}

fn check_frontier(repo_root) {
    let roadmaps_dir = path::join(repo_root, "docs/roadmaps");
    let candidates = [
        path::join(roadmaps_dir, "README.md"),
        path::join(roadmaps_dir, "generation-index.md"),
    ];
    let index_text = "";
    let gen_index_file = path::join(roadmaps_dir, "generation-index.md");
    if fs::is_file(gen_index_file) {
        index_text = fs::read_file(gen_index_file);
        let active_gen = parse_active_generation(index_text);
        if active_gen != "" {
            candidates.push(path::join(path::join(roadmaps_dir, active_gen), "README.md"));
        }
    }
    let declared = [];
    for candidate in candidates {
        if !fs::is_file(candidate) {
            continue;
        }
        let ids = frontier_ids_in(fs::read_file(candidate));
        if ids.len() == 0 {
            continue;
        }
        let ids_text = "";
        for id in ids {
            if ids_text != "" {
                ids_text += ",";
            }
            ids_text += id;
        }
        for known in declared {
            let same = known["ids"].len() == ids.len();
            if same {
                for id in ids {
                    if !known["ids"].contains(id) {
                        same = false;
                    }
                }
            }
            if !same {
                throw("front doors name different approved tasks: " + known["file"] + " declares " + known["text"] + " but " + path::file_name(candidate) + " declares " + ids_text);
            }
        }
        declared.push(#{ ids: ids, file: path::file_name(candidate), text: ids_text });
    }
    if declared.len() == 0 {
        return;
    }
    let frontier = declared[0]["ids"];
    let frontier_text = declared[0]["text"];
    for gen_dir in list_expanded_generations(repo_root) {
        let gen = path::file_name(gen_dir);
        for entry in fs::list(gen_dir) {
            if !fs::is_file(entry) || !str::ends_with(entry, ".md") {
                continue;
            }
            let name = path::file_name(entry);
            if !regex::is_match("^[0-9]+-.+[.]md$", name) {
                continue;
            }
            let nnn = regex::replace("-.*$", name, "");
            let own_id = gen + "." + nnn;
            if regex::is_match("(?m)^Status:\\s*ready", fs::read_file(entry)) && !frontier.contains(own_id) {
                throw("ready task " + own_id + " is outside the approved frontier " + frontier_text);
            }
        }
    }
}

fn check_lifecycle(repo_root) {
    check_archive_non_authority(repo_root);
    check_one_expanded_generation(repo_root);
    check_front_door_archive_links(repo_root);
    check_no_nested_cards(repo_root);
    check_task_ids(repo_root);
    check_frontier(repo_root);
    check_retired_posture_labels(repo_root);
    test_posture_label_rejection(repo_root);
    check_post_merge_reconciliation(repo_root);
}
