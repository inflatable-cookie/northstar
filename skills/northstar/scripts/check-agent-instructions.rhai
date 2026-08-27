fn resolve_path(base_root, raw_path) {
    if str::starts_with(raw_path, "/") {
        raw_path
    } else {
        path::join(base_root, raw_path)
    }
}

fn count_matching(lines, pattern) {
    let count = 0;
    for line in lines {
        if regex::is_match(pattern, line) {
            count += 1;
        }
    }
    count
}

fn audit_file(target_root, relative_path) {
    let full_path = resolve_path(target_root, relative_path);
    if !fs::is_file(full_path) {
        log_warn("[northstar:agent-instructions] missing: " + relative_path);
        return;
    }

    let text = fs::read_file(full_path);
    let lines = str::split_lines(text);
    let non_blank = count_matching(lines, "\\S");
    let bytes = fs::file_size(full_path);
    let approx_tokens = (bytes + 3) / 4;
    let headings = count_matching(lines, "^#{1,6} ");
    let links = count_matching(lines, "\\[[^]]+\\]\\([^)]*\\)");
    let fenced_blocks = count_matching(lines, "^```");

    let scoped = count_matching(lines, "(?i)(nested|path-specific|directory|package)");
    scoped += count_matching(lines, "(?i)(file type|local path|worktree)");
    let procedural = count_matching(lines, "(?i)(before creating|after the operator|during execution)");
    procedural += count_matching(lines, "(?i)(then prefer|do not add|fall back|route by job)");
    procedural += count_matching(lines, "(?i)(use `effigy)");
    let historical = count_matching(lines, "(?i)(status:|updated:|completed|current lane)");
    historical += count_matching(lines, "(?i)(next task|resolution|history|roadmap)");
    let summary = "[northstar:agent-instructions] " + relative_path;
    summary += ": non_blank=" + non_blank;
    summary += " bytes=" + bytes;
    summary += " approx_tokens=" + approx_tokens;
    summary += " headings=" + headings;
    summary += " links=" + links;
    summary += " fenced_blocks=" + (fenced_blocks / 2);
    log(summary);

    for line in lines {
        if regex::is_match("^#{1,6} ", line) {
            log("[northstar:agent-instructions] section: " + line);
        }
    }

    if non_blank > 100 {
        log_warn("[northstar:agent-instructions] " + relative_path + ": above Northstar target of 100 non-blank lines (" + non_blank + ")");
    }
    if non_blank > 150 {
        log_warn("[northstar:agent-instructions] " + relative_path + ": above advisory threshold of 150 non-blank lines");
    }
    if bytes > 12288 {
        log_warn("[northstar:agent-instructions] " + relative_path + ": above Northstar target of 12 KiB (" + bytes + " bytes)");
    }
    if bytes > 20480 {
        log_warn("[northstar:agent-instructions] " + relative_path + ": above advisory threshold of 20 KiB");
    }
    if scoped > 0 {
        log("[northstar:agent-instructions] " + relative_path + ": placement_leads=" + scoped + " (review scoped/local references in context)");
    }
    if procedural > 0 {
        log("[northstar:agent-instructions] " + relative_path + ": procedure_leads=" + procedural + " (review whether each procedure is needed on common turns)");
    }
    if historical > 0 {
        log("[northstar:agent-instructions] " + relative_path + ": freshness_leads=" + historical + " (review current-state or historical references for staleness)");
    }
}

fn audit_claude_bridge(target_root, relative_path) {
    let full_path = resolve_path(target_root, relative_path);
    if !fs::is_file(full_path) {
        log_warn("[northstar:agent-instructions] missing Claude bridge: " + relative_path);
        return;
    }

    let text = fs::read_file(full_path);
    if !text.contains("@AGENTS.md") {
        log_warn("[northstar:agent-instructions] Claude bridge missing exact @AGENTS.md reference: " + relative_path);
    } else {
        log("[northstar:agent-instructions] Claude bridge OK: " + relative_path + " -> @AGENTS.md");
    }
}

let target_root = repo_root;
let targets = [
    "AGENTS.md",
    "skills/northstar/assets/templates/AGENTS.md",
];
let bridges = [
    "CLAUDE.md",
    "skills/northstar/assets/templates/CLAUDE.md.template",
];

if args.len() > 0 && fs::is_dir(resolve_path(repo_root, args[0])) {
    target_root = resolve_path(repo_root, args[0]);
    targets = ["AGENTS.md"];
    bridges = ["CLAUDE.md"];
}

for target in targets {
    audit_file(target_root, target);
}

for bridge in bridges {
    audit_claude_bridge(target_root, bridge);
}

log("Northstar agent-instruction measurements complete (advisory; no files changed)");
log("Review meaning, reader flow, tone, force, and decision usefulness with the Northstar AGENTS review mode; the checker does not judge prose.");
