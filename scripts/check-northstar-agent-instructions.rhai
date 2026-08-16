fn parse_targets(argv) {
    if argv.len() > 0 {
        return argv;
    }
    [
        "AGENTS.md",
        "skills/northstar/assets/templates/AGENTS.md",
    ]
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

fn audit_file(relative_path) {
    let full_path = path::join(repo_root, relative_path);
    if !fs::is_file(full_path) {
        log_warn("[northstar:agent-instructions] missing: " + relative_path);
        return;
    }

    let text = fs::read_file(full_path);
    let lines = str::split_lines(text);
    let non_blank = count_matching(lines, "\\S");
    let bytes = text.len();
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
    let conversational = count_matching(lines, "(?i)(normal replies|human conversational)");
    conversational += count_matching(lines, "(?i)(make it easy for the operator|tone|reporting rule)");

    let summary = "[northstar:agent-instructions] " + relative_path;
    summary += ": non_blank=" + non_blank;
    summary += " bytes=" + bytes;
    summary += " approx_tokens=" + approx_tokens;
    summary += " headings=" + headings;
    summary += " links=" + links;
    summary += " fenced_blocks=" + (fenced_blocks / 2);
    log(summary);

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
        log_warn("[northstar:agent-instructions] " + relative_path + ": " + scoped + " line(s) may be scoped/local rather than root-level; review manually");
    }
    if procedural > 0 {
        log_warn("[northstar:agent-instructions] " + relative_path + ": " + procedural + " line(s) may be procedural; prefer a contract, guide, or skill when not needed every turn");
    }
    if historical > 0 {
        log_warn("[northstar:agent-instructions] " + relative_path + ": " + historical + " line(s) may be historical/current-state content; review for staleness");
    }
    if conversational > 0 {
        log_warn("[northstar:agent-instructions] " + relative_path + ": " + conversational + " line(s) may be conversational/reporting guidance rather than repository contract");
    }
}

for target in parse_targets(args) {
    audit_file(target);
}

log("Northstar agent-instruction audit complete (advisory; no files changed)");
