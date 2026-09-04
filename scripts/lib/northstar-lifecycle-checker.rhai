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

fn check_lifecycle(repo_root) {
    check_archive_non_authority(repo_root);
    check_one_expanded_generation(repo_root);
}
