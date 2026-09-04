fn list_matching_files(directory, pattern) {
    let result = [];
    if !fs::is_dir(directory) {
        return result;
    }

    for entry in fs::list(directory) {
        if fs::is_file(entry) && regex::is_match(pattern, path::file_name(entry)) {
            result.push(entry);
        }
    }
    result
}

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

fn parse_target_root(default_root, argv) {
    let positional = "";
    if argv.len() > 0 && !str::starts_with(argv[0], "-") {
        positional = argv[0];
    }
    if positional != "" {
        return path::join(repo_root, positional);
    }
    default_root
}

let target_root = parse_target_root(repo_root, args);
let warnings = [];
let numbered_pattern = "^[0-9]{3}-.+[.]md$";

let gen_index = path::join(target_root, "docs/roadmaps/generation-index.md");
if fs::is_file(gen_index) {
    let gen = parse_active_generation(fs::read_file(gen_index));
    if gen != "" {
        let gen_dir = path::join(target_root, "docs/roadmaps/" + gen);
        let gen_readme = path::join(gen_dir, "README.md");
        if !fs::is_dir(gen_dir) {
            warnings.push("generation-index names active " + gen + " but docs/roadmaps/" + gen + "/ is missing");
        } else if !fs::is_file(gen_readme) {
            warnings.push("generation " + gen + " exists but docs/roadmaps/" + gen + "/README.md is missing (operators use it as a front door)");
        } else if list_matching_files(gen_dir, numbered_pattern).len() == 0 {
            warnings.push("docs/roadmaps/" + gen + "/ has no NNN-<slug>.md milestone files while generation-index still names it active");
        }

        let batch_dir = path::join(gen_dir, "batch-cards");
        if fs::is_dir(batch_dir) && list_matching_files(batch_dir, numbered_pattern).len() == 0 {
            warnings.push("docs/roadmaps/" + gen + "/batch-cards/ exists but has no NNN-<slug>.md cards (ready batch cards normally live here)");
        }
    }
}

let specs_dir = path::join(target_root, "docs/specs");
let numbered_specs = list_matching_files(specs_dir, numbered_pattern);
let archive_readme = path::join(specs_dir, "archive/README.md");
if numbered_specs.len() > 0 && !fs::is_file(archive_readme) {
    warnings.push("docs/specs/ has numbered master specs but docs/specs/archive/README.md is missing (archive path should be explicit when specs exist)");
}

if warnings.len() == 0 {
    log("Northstar posture advisory checks: OK (0 warnings)");
} else {
    for warning in warnings {
        log_warn("[northstar:advisory] " + warning);
    }
    log("Northstar posture advisory checks: " + warnings.len() + " warning(s) (non-blocking)");
}
