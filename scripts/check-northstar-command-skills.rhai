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

fn h2_section(text, heading) {
    let capturing = false;
    let out = "";
    for line in str::split_lines(text) {
        if capturing && str::starts_with(line, "## ") && !str::starts_with(line, "### ") {
            return out;
        }
        if line == heading {
            capturing = true;
        }
        if capturing {
            out += line + "\n";
        }
    }
    require(capturing, "missing section: " + heading);
    out
}

fn h3_section(text, heading) {
    let capturing = false;
    let out = "";
    for line in str::split_lines(text) {
        if capturing && line != heading && (str::starts_with(line, "## ") || str::starts_with(line, "### ")) {
            return out;
        }
        if line == heading {
            capturing = true;
        }
        if capturing {
            out += line + "\n";
        }
    }
    require(capturing, "missing section: " + heading);
    out
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
    ["northstar-chatterbox", "commands/northstar-chatterbox/SKILL.md", "references/modes/chatterbox.md"],
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

let distribution = fs::read_file(path::join(repo_root, "bundle-docs/skills/README.md"));
require(distribution.contains("/tree/main/skills/northstar") &&
    distribution.contains("Do not use `--all`"),
    "published installation instructions drifted");
let all_skill_text = "";
for file in fs::list_recursive(root) {
    if is_text_skill_surface(root, file) {
        all_skill_text += fs::read_file(file);
    }
}
require(!all_skill_text.contains("northstar-reframe"), "retired Northstar-prefixed reframe name remains in installable skill tree");
require(!all_skill_text.contains("northstar wayfinder"), "retired natural-language Wayfinder alias remains in installable skill tree");
require(!all_skill_text.contains("northstar-wayfinder"), "retired slash Wayfinder alias remains in installable skill tree");
// Card 120: the embedded language modes are gone. No skill surface may route
// to a deleted mode file, and the public entry surfaces must select language
// work only through the generic installed-package route.
for deleted_mode in [
    "modes/rust-quality-audit.md",
    "modes/rust-quality-authoring.md",
    "modes/typescript-quality-audit.md",
    "Rust explicit audit",
    "TypeScript/Svelte explicit audit",
    "Rust everyday authoring",
] {
    require(!all_skill_text.contains(deleted_mode),
        "deleted embedded language mode still routed in the skill tree: " + deleted_mode);
}
let main_instructions = fs::read_file(path::join(root, "SKILL.md")) +
    fs::read_file(path::join(root, "agents/openai.yaml"));
require(main_instructions.contains("installed-package-route.md"),
    "skill entry surfaces do not name the generic installed-package route");
require(fs::is_file(path::join(root, "references/packages/installed-package-route.md")),
    "installed-package route file missing from the payload");

let router_text = fs::read_file(path::join(root, "references/router.md"));
let handoff_contract_text = fs::read_file(path::join(root, "references/handoff-contract.md"));
let orchestrator_text = fs::read_file(path::join(root, "references/modes/orchestrator.md"));
let handoff_mode_text = fs::read_file(path::join(root, "references/modes/handoff.md"));
let continuation_router = h2_section(router_text, "## Orchestrator-continuation activation");
let continuation_contract = h3_section(handoff_contract_text, "### Orchestrator-continuation activation");
let continuation_mode = h2_section(orchestrator_text, "## Fresh orchestrator continuation");
let generic_template = fs::read_file(path::join(root, "assets/templates/northstar-handoff.md.template"));
let generic_h2 = 0;
for line in str::split_lines(generic_template) {
    if str::starts_with(line, "## ") && !str::starts_with(line, "### ") {
        generic_h2 += 1;
    }
}

require(continuation_router.contains("handoff_mode: orchestrator-continuation") &&
    continuation_router.contains("orchestrator_mode: economical-coordination") &&
    continuation_router.contains("dispatch_authority: orchestrator"),
    "router continuation activation is missing the three settled fields");
require(continuation_router.contains("does not run the worker startup") &&
    continuation_router.contains("the launch before those other routes"),
    "router does not reject worker, planning-delegate, or handoff successor routing");
require(continuation_contract.contains("handoff_mode: orchestrator-continuation") &&
    continuation_contract.contains("Do not add a public mode or a second continuation template"),
    "handoff contract continuation overlay is incomplete");
require(main_text.contains("handoff_mode: orchestrator-continuation") &&
    main_text.contains("does not run worker or planning-delegate"),
    "skill outcome does not keep continuation in orchestrator mode");
require(handoff_mode_text.contains("Do not use this mode as the successor runtime"),
    "handoff-writing mode can be used as continuation runtime");
require(!continuation_mode.contains("handoff_mode: worker-pr-loop") &&
    !continuation_mode.contains("planning_mode: conversational-discovery"),
    "continuation procedure activates worker or planning-delegate metadata");
require(!fs::is_file(path::join(root, "assets/templates/northstar-orchestrator-continuation.md.template")),
    "continuation added a public template");
require(generic_h2 == 7 && !generic_template.contains("handoff_mode:"),
    "generic handoff template is no longer seven sections without activation fields");

require(continuation_mode.contains("stops planning, dispatch, review") &&
    continuation_mode.contains("merge mutations for the transferred lane") &&
    continuation_mode.contains("does not compete with the successor"),
    "source does not yield the transferred lane");

require(continuation_mode.contains("creates a separate `local` workspace") &&
    continuation_mode.contains("Reject the transport plan if it uses `branch-off` worktree isolation") &&
    continuation_mode.contains("different project path"),
    "continuation launch does not reject worker isolation or a different project path");

require(continuation_mode.contains("capitalized label") &&
    continuation_mode.contains("`Orchestrator=true`") &&
    continuation_mode.contains("omitted or lowercased"),
    "continuation launch does not require the capitalized Orchestrator label");

require(continuation_mode.contains("Read and follow <absolute-handoff-path>.") &&
    continuation_mode.contains("transcript or a") &&
    continuation_mode.contains("second task description"),
    "continuation launch does not keep the absolute handoff as the only prompt");

require(continuation_mode.contains("missing pin") &&
    continuation_mode.contains("is not a launch failure") &&
    continuation_mode.contains("Never use browser, computer-use") &&
    continuation_mode.contains("UI automation"),
    "unsupported pinning is not kept manual");

require(continuation_mode.contains("identity with an ambiguous") &&
    continuation_mode.contains("do not retry into") &&
    continuation_mode.contains("a duplicate successor"),
    "ambiguous continuation creation can duplicate the successor");

require(continuation_mode.contains("Without Paseo") &&
    continuation_mode.contains("Northstar remains") &&
    continuation_mode.contains("return the absolute handoff path for manual launch"),
    "continuation launch fails closed when Paseo tools are absent");

// Card 127: chatterbox spawn is a parent-attached sibling child in the
// coordinator's current workspace; it never creates a workspace.
let chatterbox_spawn = h2_section(orchestrator_text, "## Chatterbox spawn and intake");
require(chatterbox_spawn.contains("parent-attached child agent") &&
    chatterbox_spawn.contains("current workspace") &&
    chatterbox_spawn.contains("agent-scoped creation call") &&
    !chatterbox_spawn.contains("`local` workspace"),
    "chatterbox spawn must stay a sibling child in the coordinator workspace");

// Card 128: obsolete templates are removed
require(!fs::is_file(path::join(root, "assets/templates/northstar-discovery-delegate.md.template")),
    "deleted discovery-delegate template still present");
require(!fs::is_file(path::join(root, "assets/templates/northstar-documentation-projection.md.template")),
    "deleted documentation-projection template still present");

// Card 128: Spec 037 structural fixtures
let chatterbox_mode_text = fs::read_file(path::join(root, "references/modes/chatterbox.md"));
require(chatterbox_mode_text.contains("primary operator-facing planning authority") &&
    chatterbox_mode_text.contains("reconciles delegate, external, or conversational triage notes") &&
    chatterbox_mode_text.contains("directly updates canonical planning"),
    "chatterbox mode missing primary planning and promotion authority");

require(orchestrator_text.contains("mechanical delivery management") &&
    orchestrator_text.contains("canonical dispatch manifest published by Chatterbox") &&
    orchestrator_text.contains("narrow fast path"),
    "orchestrator mode missing mechanical coordination role");

let direction_section = h2_section(chatterbox_mode_text, "## Coordinator direction channel");
require(direction_section.contains("operator-confirmed direction") &&
    direction_section.contains("Chatterbox recommendation") &&
    direction_section.contains("administrative notice"),
    "chatterbox direction channel missing 3 provenance types");

let orchestrator_posture = h2_section(orchestrator_text, "## Operating posture");
require(orchestrator_posture.contains("complete approved ready frontier") &&
    orchestrator_posture.contains("event-bounded turns") &&
    orchestrator_posture.contains("never poll or call wait primitives"),
    "orchestrator missing full-frontier launch or post-dispatch yield");

let review_child_section = h2_section(orchestrator_text, "## Independent review children and serial workspace lease");
require(review_child_section.contains("existing worker workspace") &&
    review_child_section.contains("serial clean") &&
    review_child_section.contains("Do not create a review-only workspace"),
    "review child missing worker workspace placement or serial lease");

let escalation_section = h2_section(orchestrator_text, "## Context-complete operator escalations");
require(escalation_section.contains("10-part capsule") &&
    escalation_section.contains("headline") &&
    escalation_section.contains("observed versus intended behavior") &&
    escalation_section.contains("why operator authority is required") &&
    escalation_section.contains("one exact question"),
    "escalation capsule definition incomplete");

// Card 128: Spec 037 negative fixtures
require(orchestrator_text.contains("Raw triage notes are never authority"),
    "raw-triage dispatch forbidden check missing");
require(orchestrator_text.contains("without designing lanes"),
    "coordinator semantic lane design forbidden check missing");
require(direction_section.contains("Inspect coordinator state once to avoid duplicate messages") &&
    direction_section.contains("do not poll"),
    "duplicate direction check missing");
require(review_child_section.contains("verify the worker is idle") &&
    review_child_section.contains("tracked worktree are clean") &&
    review_child_section.contains("without editing tracked files"),
    "concurrent workspace lease protection missing");
let pr_review_text = fs::read_file(path::join(root, "references/modes/pr-review.md"));
require(pr_review_text.contains("post the durable verdict on the provider naming the exact head SHA reviewed") &&
    orchestrator_text.contains("durable accepted verdict names the exact current head"),
    "exact head verification missing in pr-review or coordinator merge gate");
require(escalation_section.contains("opaque or incomplete capsules") &&
    escalation_section.contains("do not reconstruct"),
    "opaque operator escalation rejection missing");

log("Northstar command-skill surface: OK (" + commands.len() + " adapters, aggregate descriptions=" + aggregate_description_chars + " chars)");
