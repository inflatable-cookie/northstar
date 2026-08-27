fn frontmatter_value(text, key) {
    let prefix = key + ":";
    for line in str::split_lines(text) {
        if str::starts_with(line, prefix) {
            return str::trim(str::replace(line, prefix, ""));
        }
    }
    ""
}

fn require(condition, message) {
    if !condition {
        throw("[northstar:command-skills] " + message);
    }
}

fn count_lines_containing(lines, needle) {
    let count = 0;
    for line in lines {
        if line.contains(needle) {
            count += 1;
        }
    }
    count
}

fn first_line_containing(lines, needle) {
    let index = 0;
    for line in lines {
        if line.contains(needle) {
            return index;
        }
        index += 1;
    }
    -1
}

fn is_text_skill_surface(root, file) {
    let relative = str::replace(file, root + "/", "");
    if str::starts_with(relative, "target/") || relative.contains("/target/") {
        return false;
    }

    str::ends_with(relative, ".md") ||
        str::ends_with(relative, ".yaml") ||
        str::ends_with(relative, ".yml") ||
        str::ends_with(relative, ".json") ||
        str::ends_with(relative, ".toml") ||
        str::ends_with(relative, ".rhai") ||
        str::ends_with(relative, ".rs") ||
        str::ends_with(relative, ".lock") ||
        str::ends_with(relative, ".txt")
}

let root = path::join(repo_root, "skills/northstar");
require(fs::is_dir(root), "missing skills/northstar directory");

let commands = [
    ["come-again", "commands/come-again/SKILL.md", "references/modes/pre-execution-discovery.md"],
    ["northstar-agents-review", "commands/northstar-agents-review/SKILL.md", "references/modes/agent-instruction-review.md"],
    ["northstar-readiness-review", "commands/northstar-readiness-review/SKILL.md", "references/modes/planning-readiness-review.md"],
    ["northstar-architecture-refocus", "commands/northstar-architecture-refocus/SKILL.md", "references/modes/architecture-refocus.md"],
    ["northstar-refresh", "commands/northstar-refresh/SKILL.md", "references/modes/project-refresh.md"],
    ["northstar-cleanup", "commands/northstar-cleanup/SKILL.md", "references/modes/cleanup-docs.md"],
    ["northstar-atlas", "commands/northstar-atlas/SKILL.md", "references/modes/atlas.md"],
    ["northstar-rust-audit", "commands/northstar-rust-audit/SKILL.md", "references/modes/rust-quality-audit.md"],
    ["northstar-typescript-audit", "commands/northstar-typescript-audit/SKILL.md", "references/modes/typescript-quality-audit.md"],
];

let aggregate_description_chars = 0;
let expected_paths = ["SKILL.md"];
let main_text = fs::read_file(path::join(root, "SKILL.md"));
let main_description = frontmatter_value(main_text, "description");
require(main_description != "", "main skill description is missing");
require(main_description.len() <= 60, "main skill description exceeds 60 characters");
require(str::ends_with(main_description, "."), "main skill description must end with a period");
aggregate_description_chars += main_description.len();

for command in commands {
    let name = command[0];
    let relative = command[1];
    let mode = command[2];
    let full_path = path::join(root, relative);
    let mode_path = path::join(root, mode);
    require(fs::is_file(full_path), "missing adapter: " + relative);
    require(fs::is_file(mode_path), "missing canonical mode: " + mode);

    let text = fs::read_file(full_path);
    let lines = str::split_lines(text);
    let description = frontmatter_value(text, "description");
    require(frontmatter_value(text, "name") == name, "wrong name in " + relative);
    require(description != "", "missing description in " + relative);
    require(description.len() <= 60, "description exceeds 60 characters in " + relative);
    require(str::ends_with(description, "."), "description must end with a period in " + relative);
    let router_hits = count_lines_containing(lines, "references/router.md");
    let mode_hits = count_lines_containing(lines, mode);
    let mode_reference_hits = count_lines_containing(lines, "references/modes/");
    let router_line = first_line_containing(lines, "references/router.md");
    let mode_line = first_line_containing(lines, mode);
    require(router_hits == 1, "adapter must load exactly one router reference: " + relative);
    require(mode_hits == 1, "adapter must load exactly one canonical mode reference: " + relative);
    require(mode_reference_hits == 1, "adapter must contain exactly one mode reference: " + relative);
    require(router_line < mode_line, "router reference must precede mode reference: " + relative);
    require(fs::file_size(full_path) <= 1200, "adapter is too large to remain thin: " + relative);
    require(!text.contains("## Procedure") && !text.contains("## Steps"), "adapter contains a duplicated procedure heading: " + relative);
    require(text.contains("Do not") || text.contains("Remain") || text.contains("plan-only"), "adapter is missing an authority boundary: " + relative);
    let previous_negative_boundary = false;
    for line in lines {
        let negative_boundary = regex::is_match("(?i)(do not|don't|never|remain|read-only|plan-only|operator-owned|no )", line);
        if regex::is_match("(?i)(start|create|dispatch|authorize|merge|edit production)", line) && !negative_boundary && !previous_negative_boundary {
            throw("[northstar:command-skills] possible unauthorized action in " + relative + ": " + line);
        }
        previous_negative_boundary = negative_boundary;
    }
    require(!text.contains("northstar-wayfinder"), "retired Wayfinder alias remains in " + relative);

    expected_paths.push(relative);
    aggregate_description_chars += description.len();
}

let actual_command_files = [];
for file in fs::list_recursive(path::join(root, "commands")) {
    if str::ends_with(file, "/SKILL.md") {
        let relative = str::replace(file, root + "/", "");
        actual_command_files.push(relative);
    }
}
actual_command_files.sort();
expected_paths.sort();
require(actual_command_files.len() == commands.len(), "unexpected command adapter count");
for relative in actual_command_files {
    require(expected_paths.contains(relative), "unexpected command adapter: " + relative);
}
require(aggregate_description_chars <= 460, "command descriptions exceed 460 aggregate characters");

let typescript_policy = fs::read_file(path::join(
    root,
    "commands/northstar-typescript-audit/agents/openai.yaml",
));
require(typescript_policy.contains("allow_implicit_invocation: false"),
    "TypeScript audit adapter must remain explicit-only");

let all_skill_text = "";
for file in fs::list_recursive(root) {
    if is_text_skill_surface(root, file) {
        all_skill_text += fs::read_file(file);
    }
}
require(!all_skill_text.contains("northstar-reframe"), "retired Northstar-prefixed reframe name remains in installable skill tree");
require(!all_skill_text.contains("northstar wayfinder"), "retired natural-language Wayfinder alias remains in installable skill tree");
require(!all_skill_text.contains("northstar-wayfinder"), "retired slash Wayfinder alias remains in installable skill tree");

log("Northstar command-skill surface: OK (" + commands.len() + " adapters, aggregate descriptions=" + aggregate_description_chars + " chars)");
