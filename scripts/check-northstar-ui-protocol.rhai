import "scripts/lib/northstar-ui-protocol.rhai" as ui;

fn require(condition, message) {
    if !condition {
        throw("[northstar:ui-protocol] " + message);
    }
}

fn read(relative) {
    let full_path = path::join(repo_root, relative);
    require(fs::is_file(full_path), "missing UI protocol surface: " + relative);
    fs::read_file(full_path)
}

fn normalize(text) {
    regex::replace("\\s+", text, " ").to_lower()
}

fn require_contains(text, needle, label) {
    require(normalize(text).contains(normalize(needle)), label + " is missing: " + needle);
}

fn line_index_of(text, needle) {
    let index = 0;
    for line in str::split_lines(text) {
        if str::trim(line) == needle {
            return index;
        }
        index += 1;
    }
    -1
}

let skill = read("skills/northstar/ui/SKILL.md");
require_contains(skill, "name: northstar-ui", "northstar-ui skill");
require_contains(skill, "references/ui/build.md", "northstar-ui skill");
require_contains(skill, "references/ui/review.md", "northstar-ui skill");
require_contains(skill, "no house aesthetic", "northstar-ui skill");
require_contains(skill, "consumer repository owns product truth", "northstar-ui skill");
require_contains(skill, "without requiring it", "northstar-ui companion posture");
require_contains(skill, "does not own a renderer", "northstar-ui renderer boundary");

let brief = read("skills/northstar/references/ui/brief-contract.md");
for marker in [
    "Refinement",
    "Workflow change",
    "Substantial redesign",
    "Scenario oracle",
    "cannot implement production code or grant readiness",
    "operator selects the direction",
    "non-authoritative",
] {
    require_contains(brief, marker, "UI brief contract");
}

let build = read("skills/northstar/references/ui/build.md");
for marker in [
    "scenario oracle",
    "capture named rendered states",
    "one critique-and-repair pass",
    "exact head SHA",
    "never present it as design proof",
] {
    require_contains(build, marker, "northstar-ui build route");
}

let review = read("skills/northstar/references/ui/review.md");
for marker in [
    "exact head SHA",
    "running head",
    "workflow or navigation",
    "never replace rendered inspection",
] {
    require_contains(review, marker, "northstar-ui review route");
}

let guidance = read("skills/northstar/references/ui/design-guidance.md");
require_contains(guidance, "Common model-generated UI failures", "UI guidance");
let lowered_guidance = guidance.to_lower();
for topic in [
    "hierarchy",
    "typography",
    "accessibility",
    "responsiveness",
    "motion",
    "content ranges",
] {
    require(lowered_guidance.contains(topic), "UI guidance is missing topic: " + topic);
}

let handoff_contract = read("skills/northstar/references/handoff-contract.md");
require_contains(handoff_contract, "### UI Design Brief", "handoff contract");
require_contains(handoff_contract, "Important Context", "handoff contract");
require_contains(handoff_contract, "seven top-level sections", "handoff contract");

let worker_template = read("skills/northstar/assets/templates/northstar-orchestrator-run.md.template");
let worker_handoff = ui::validate_ui_handoff(worker_template, true);
require(worker_handoff["ok"],
    "worker handoff template failed the seven-section UI transport: " +
    ui::join_reasons(worker_handoff["errors"]));

let generic_template = read("skills/northstar/assets/templates/northstar-handoff.md.template");
let g_h2 = 0;
for line in str::split_lines(generic_template) {
    if str::starts_with(line, "## ") && !str::starts_with(line, "### ") {
        g_h2 += 1;
    }
}
require(g_h2 == 7, "generic handoff template no longer has seven top-level sections");
require(!generic_template.contains("handoff_mode:"), "generic handoff template gained activation fields");
let g_important = line_index_of(generic_template, "## Important Context");
let g_brief = line_index_of(generic_template, "### UI Design Brief");
let g_next = line_index_of(generic_template, "## Suggested Next Move");
require(g_important < g_brief && g_brief < g_next,
    "generic handoff template must carry the UI Design Brief inside Important Context");

let doctrine = read("bundle-docs/sections/11-ui-design-delivery.md");
for marker in [
    "## UI classification",
    "## UI design brief contract",
    "## Concept checkpoint and design delegate",
    "## Independent review",
    "## Stop conditions",
] {
    require_contains(doctrine, marker, "UI doctrine section");
}
require_contains(doctrine, "northstar-ui", "UI doctrine skill reference");

let contract = read("docs/contracts/001-working-rules.md");
require_contains(contract, "### UI design planning and delivery", "working-rules contract");
let template_contract = read("template-bundle/contracts/001-working-rules-template.md");
require_contains(template_contract, "### UI design planning and delivery", "copy-ready working-rules template");

let canonical_task_template = "template-bundle/roadmaps/templates/task-template.md";
let mirror_task_template = "skills/northstar/assets/templates/docs/roadmaps/templates/task-template.md";
let task_template = read(canonical_task_template);
require_contains(task_template, "UI classification:", "task template");
require_contains(task_template, "## UI Design Brief", "task template");
require_contains(task_template,
    "No unresolved planning gaps or operator intent checkpoints.",
    "task template readiness invariant");
require(fs::sha256(path::join(repo_root, canonical_task_template)) ==
    fs::sha256(path::join(repo_root, mirror_task_template)),
    "task template mirror drifted");

let chatterbox = read("skills/northstar/references/modes/chatterbox.md");
require_contains(chatterbox, "## UI design planning", "chatterbox mode");
require_contains(chatterbox, "materially different\nstructures", "chatterbox design delegate");

let discovery = read("skills/northstar/references/modes/pre-execution-discovery.md");
require_contains(discovery, "## UI design route", "pre-execution discovery mode");

let pr_review = read("skills/northstar/references/modes/pr-review.md");
require_contains(pr_review, "## UI-marked PRs", "pr-review mode");
require_contains(pr_review, "running exact head", "pr-review UI route");
require_contains(pr_review, "consumer repository owns design authority", "pr-review consumer authority boundary");

let handoff_mode = read("skills/northstar/references/modes/handoff.md");
require_contains(handoff_mode, "UI Design Brief", "handoff mode");

let main_skill = read("skills/northstar/SKILL.md");
require_contains(main_skill, "northstar-ui", "main skill");
require_contains(main_skill, "UI design delivery", "main skill outcome");
let router = read("skills/northstar/references/router.md");
require_contains(router, "UI design delivery", "router");
require_contains(router, "ui/SKILL.md", "router");

let architecture = read("docs/architecture/system-architecture.md");
require_contains(architecture, "## UI design planning and delivery", "system architecture");

log("Northstar UI design planning and delivery surface: OK (spec 039 / g03.004)");
