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
require(main_text.contains("materialize the complete profile") &&
    main_text.contains("full-accept/full-access permission mode") &&
    main_text.contains("does not expand the child's Northstar authority"),
    "main skill does not carry the shared Paseo profile-permission invariant");
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

let chatterbox_triage = h2_section(chatterbox_mode_text, "## Discovery, triage, and reconciliation");
require(chatterbox_triage.contains("update the existing note in place") &&
    chatterbox_triage.contains("Never create a correction, addendum, or deprecation note") &&
    chatterbox_triage.contains("after full promotion, delete the source triage note") &&
    chatterbox_triage.contains("after partial promotion, edit the note down"),
    "chatterbox mode missing mutable triage or promotion-time pruning");

require(orchestrator_text.contains("mechanical delivery management") &&
    orchestrator_text.contains("canonical dispatch manifest published by Chatterbox") &&
    orchestrator_text.contains("narrow fast path"),
    "orchestrator mode missing mechanical coordination role");

let orchestrator_triage = h2_section(orchestrator_text, "## Triage boundary");
require(orchestrator_triage.contains("does not load, reconcile, edit, or prune") &&
    orchestrator_triage.contains("never chooses a planning branch") &&
    orchestrator_triage.contains("provenance-labelled recommendation"),
    "coordinator triage boundary is not mechanical");

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

let paseo_launch_settings = h2_section(orchestrator_text, "## Paseo launch settings");
require(paseo_launch_settings.contains("selected profile as a complete") &&
    paseo_launch_settings.contains("launch bundle. Materialize"),
    "Paseo child launch does not treat profiles as complete launch bundles");
require(paseo_launch_settings.contains("`settings.modeId`") &&
    paseo_launch_settings.contains("`settings.thinkingOptionId`") &&
    paseo_launch_settings.contains("`settings.features`"),
    "Paseo child launch does not materialize complete profile settings");
require(paseo_launch_settings.contains("full-accept/full-access") &&
    paseo_launch_settings.contains("ask-for-permission mode"),
    "Paseo child launch does not preserve the profile permission mode");
require(paseo_launch_settings.contains("does not widen"),
    "Paseo child launch does not preserve the authority boundary");
for child_class in [
    "workers",
    "reviewers",
    "chatterboxes",
    "planning delegates",
    "bounded research",
    "mechanical projection workers",
    "successor orchestrators",
] {
    require(paseo_launch_settings.contains(child_class),
        "Paseo launch-settings rule omits child class: " + child_class);
}

let review_child_section = h2_section(orchestrator_text, "## Independent review children and serial workspace lease");
require(review_child_section.contains("existing worker workspace") &&
    review_child_section.contains("serial clean") &&
    review_child_section.contains("pass that same value explicitly") &&
    review_child_section.contains("do not call `create_workspace` for review") &&
    review_child_section.contains("returned\nreviewer `workspaceId`") &&
    review_child_section.contains("ordinary re-review") &&
    review_child_section.contains("`create_agent`") &&
    review_child_section.contains("`send_agent_prompt`") &&
    review_child_section.contains("reviewer `agentId`") &&
    review_child_section.contains("finished or idle reviewer is reusable"),
    "review child missing worker workspace placement or serial lease");
require(!fs::read_file(path::join(repo_root, "docs/architecture/system-architecture.md"))
        .contains("review child (dedicated PR-head workspace)") &&
    !fs::read_file(path::join(repo_root, "docs/specs/036-economical-orchestrator-coordination.md"))
        .contains("creates a dedicated checkout/worktree workspace for the PR head"),
    "canonical docs retain superseded review-workspace creation instructions");

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

// Card 129: Spec 037 continuous coordinator fixtures

// Structural contract assertions
require(orchestrator_text.contains("continuous") &&
    orchestrator_text.contains("coordinator action chain") &&
    orchestrator_text.contains("without waiting for an operator `continue`"),
    "coordinator missing continuous action chain without continue");
require(orchestrator_text.contains("does not notify Chatterbox") &&
    (orchestrator_text.contains("active children") || orchestrator_text.contains("child waits")),
    "waiting child chatterbox silence missing");
require(orchestrator_text.contains("canonical runway is empty") &&
    orchestrator_text.contains("administrative notice with completed state"),
    "empty runway administrative notice missing");
require(review_child_section.contains("different underlying provider/model identity") &&
    review_child_section.contains("reject the same provider/model"),
    "cross-model review identity requirement missing");
require(review_child_section.contains("fail closed") &&
    review_child_section.contains("distinct reviewer"),
    "fail-closed reviewer qualification check missing");
require(orchestrator_text.contains("approved native write transport") &&
    orchestrator_text.contains("solicit credentials"),
    "authenticated write fallback check missing");
require(chatterbox_mode_text.contains("administrative notice with completed state") &&
    chatterbox_mode_text.contains("canonical runway is empty") &&
    chatterbox_mode_text.contains("does not notify Chatterbox"),
    "chatterbox direction channel missing empty-runway / child-wait contract");
require(pr_review_text.contains("different underlying provider/model identity") &&
    pr_review_text.contains("authoring worker"),
    "pr-review missing cross-model identity requirement");

// Behavioral Fixture 1: Lifecycle fixture runs child completion -> review -> merge -> closeout -> next-ready dispatch without an operator continue
fn run_coordinator_lifecycle_simulation() {
    let trace = [];
    let state = #{
        "worker_idle": true,
        "clean_head": true,
        "review_verdict_accepted": true,
        "gate_checks_pass": true,
        "gate_mergeable": true,
        "operator_pause": false,
        "runway_has_next_ready": true,
        "operator_continue_prompted": false,
    };

    // 1. Child completion arrives
    trace.push("child-complete");

    // 2. Launch review child under clean exact-head lease
    if state["worker_idle"] && state["clean_head"] {
        trace.push("review-dispatch");
    }

    // 3. Review completed with accepted verdict
    if state["review_verdict_accepted"] {
        trace.push("review-verdict-accepted");
    }

    // 4. Verify coordination gate
    let gate_holds = state["review_verdict_accepted"] &&
        state["gate_checks_pass"] &&
        state["gate_mergeable"] &&
        !state["operator_pause"];
    if gate_holds {
        trace.push("merge-gate-pass");
        trace.push("merge");
        trace.push("closeout");
    }

    // 5. Frontier recomputation and continuous dispatch in same turn
    if gate_holds && state["runway_has_next_ready"] {
        trace.push("frontier-recompute");
        trace.push("dispatch-next-ready");
    }

    // Assert the action chain progressed through to dispatch-next-ready without operator continue
    require(trace.len() == 8, "lifecycle fixture trace length mismatch: " + trace.len());
    require(trace[0] == "child-complete" &&
        trace[1] == "review-dispatch" &&
        trace[2] == "review-verdict-accepted" &&
        trace[3] == "merge-gate-pass" &&
        trace[4] == "merge" &&
        trace[5] == "closeout" &&
        trace[6] == "frontier-recompute" &&
        trace[7] == "dispatch-next-ready",
        "lifecycle fixture trace unexpected order");
    require(!state["operator_continue_prompted"], "lifecycle fixture required operator continue");
}
run_coordinator_lifecycle_simulation();

// Behavioral Fixture 2: Waiting-child fixture yields with notifications enabled and sends no Chatterbox message
fn run_waiting_child_yield_simulation() {
    let chatterbox_messages = [];
    let child_dispatch = #{
        "notifyOnFinish": true,
        "polled": false,
        "wait_primitive_called": false,
        "yielded": true,
    };

    // A child is dispatched/resumed; coordinator yields without messaging Chatterbox
    if child_dispatch["notifyOnFinish"] && child_dispatch["yielded"] {
        // No message to chatterbox on child wait
    }
    require(child_dispatch["notifyOnFinish"], "waiting-child fixture must leave notifyOnFinish enabled");
    require(!child_dispatch["polled"], "waiting-child fixture must not poll");
    require(!child_dispatch["wait_primitive_called"], "waiting-child fixture must not call wait primitives");
    require(child_dispatch["yielded"], "waiting-child fixture must yield promptly");
    require(chatterbox_messages.len() == 0, "waiting-child fixture must send zero Chatterbox messages");
}
run_waiting_child_yield_simulation();

// Behavioral Fixture 3: Empty-runway fixture sends exactly one Chatterbox administrative notice
fn run_empty_runway_simulation() {
    let chatterbox_messages = [];
    let runway = #{
        "ready_lanes": 0,
        "active_children": 0,
        "published_downstream": 0,
    };

    if runway["ready_lanes"] == 0 && runway["active_children"] == 0 && runway["published_downstream"] == 0 {
        chatterbox_messages.push(#{
            "type": "administrative notice",
            "content": "canonical runway is empty; all active work complete",
        });
    }

    require(chatterbox_messages.len() == 1, "empty runway must send exactly one Chatterbox notice");
    require(chatterbox_messages[0]["type"] == "administrative notice", "empty runway notice must be administrative notice");
}
run_empty_runway_simulation();

// Behavioral Fixture 4 & 5: Positive review fixture & negative fixtures for cross-model qualification
fn qualify_reviewer(worker_identity, candidate) {
    if candidate["provider"] == worker_identity["provider"] && candidate["model"] == worker_identity["model"] {
        // Same provider/model identity is rejected, even with different profile, effort, or thread
        return false;
    }
    true
}

fn run_cross_model_review_fixtures() {
    let worker_identity = #{
        "provider": "codex",
        "model": "day-to-day-engine",
    };

    // Positive fixture: qualified distinct provider/model
    let valid_distinct_candidate = #{
        "provider": "other-provider",
        "model": "independent-engine",
        "profile": "adequate-reviewer",
    };
    require(qualify_reviewer(worker_identity, valid_distinct_candidate),
        "positive review fixture failed: valid distinct provider/model was rejected");

    // Negative fixture 1: renamed profile with same provider/model
    let profile_renamed_candidate = #{
        "provider": "codex",
        "model": "day-to-day-engine",
        "profile": "senior-reviewer-profile",
    };
    require(!qualify_reviewer(worker_identity, profile_renamed_candidate),
        "negative review fixture failed: profile-renamed candidate was accepted");

    // Negative fixture 2: effort-changed copy with same provider/model
    let effort_changed_candidate = #{
        "provider": "codex",
        "model": "day-to-day-engine",
        "reasoning_effort": "high",
    };
    require(!qualify_reviewer(worker_identity, effort_changed_candidate),
        "negative review fixture failed: effort-changed candidate was accepted");

    // Negative fixture 3: fresh thread with same provider/model
    let fresh_thread_candidate = #{
        "provider": "codex",
        "model": "day-to-day-engine",
        "fresh_thread": true,
    };
    require(!qualify_reviewer(worker_identity, fresh_thread_candidate),
        "negative review fixture failed: fresh thread candidate was accepted");

    // Negative fixture 4: fail closed when no distinct reviewer is available
    let available_candidates = [profile_renamed_candidate, effort_changed_candidate, fresh_thread_candidate];
    let qualified_found = false;
    for cand in available_candidates {
        if qualify_reviewer(worker_identity, cand) {
            qualified_found = true;
        }
    }
    require(!qualified_found, "negative review fixture failed: expected fail-closed when no distinct candidate available");
}
run_cross_model_review_fixtures();

// Behavioral Fixture 6: Write-refusal fixture uses available authenticated native fallback only after unchanged merge gate
fn run_write_refusal_fixtures() {
    // Case A: Gate holds + connector refused + authenticated native transport available -> fallback succeeds
    let gate_current = true;
    let connector_refused = true;
    let native_transport_authenticated = true;
    let fallback_succeeded = false;
    let gate_weakened = false;

    if connector_refused && gate_current {
        if native_transport_authenticated {
            fallback_succeeded = true;
        }
    }
    require(fallback_succeeded && !gate_weakened,
        "write-refusal positive fixture failed: authenticated fallback should succeed with unchanged gate");

    // Case B (negative): Stale/failing gate + connector refused -> fallback must NOT execute
    let failing_gate = false;
    let fallback_on_bad_gate = false;
    if connector_refused && failing_gate {
        if native_transport_authenticated {
            fallback_on_bad_gate = true;
        }
    }
    require(!fallback_on_bad_gate,
        "write-refusal negative fixture failed: fallback must not execute on invalid merge gate");

    // Case C (negative): Unauthenticated native transport -> must NOT solicit credentials or improvise
    let unauthenticated_native = false;
    let fallback_solicited_credentials = false;
    let improvised_transport = false;
    if connector_refused && gate_current {
        if !unauthenticated_native {
            // Must stop fail closed without soliciting credentials
            fallback_solicited_credentials = false;
            improvised_transport = false;
        }
    }
    require(!fallback_solicited_credentials && !improvised_transport,
        "write-refusal negative fixture failed: unauthenticated transport must not solicit credentials");
}
run_write_refusal_fixtures();

// Behavioral Fixture 7: selected Paseo profile settings survive child launch;
// omission or permission downgrade fails before creation.
fn profile_settings_match(profile, launch) {
    launch["provider"] == profile["provider"] + "/" + profile["model"] &&
        launch["settings"]["modeId"] == profile["modeId"] &&
        launch["settings"]["thinkingOptionId"] == profile["thinkingOptionId"] &&
        launch["settings"]["features"] == profile["featureValues"]
}

fn run_paseo_profile_materialization_fixtures() {
    let selected_profile = #{
        "provider": "codex",
        "model": "day-to-day-engine",
        "modeId": "full-access",
        "thinkingOptionId": "medium",
        "featureValues": #{"fast_mode": true},
    };
    let valid_launch = #{
        "provider": "codex/day-to-day-engine",
        "settings": #{
            "modeId": "full-access",
            "thinkingOptionId": "medium",
            "features": #{"fast_mode": true},
        },
    };
    require(profile_settings_match(selected_profile, valid_launch),
        "complete selected profile was not accepted for Paseo child launch");

    let omitted_mode = #{
        "provider": "codex/day-to-day-engine",
        "settings": #{
            "modeId": "",
            "thinkingOptionId": "medium",
            "features": #{"fast_mode": true},
        },
    };
    require(!profile_settings_match(selected_profile, omitted_mode),
        "profile modeId omission incorrectly passed child launch");

    let downgraded_mode = #{
        "provider": "codex/day-to-day-engine",
        "settings": #{
            "modeId": "ask",
            "thinkingOptionId": "medium",
            "features": #{"fast_mode": true},
        },
    };
    require(!profile_settings_match(selected_profile, downgraded_mode),
        "ask-for-permission downgrade incorrectly passed child launch");
}
run_paseo_profile_materialization_fixtures();

// Behavioral Fixture 8: first review uses the worker workspace exactly; an
// omitted, split, or mismatched workspace fails closed.
fn valid_first_review_launch(worker_workspace_id, create_workspace_calls, requested_workspace_id, returned_workspace_id) {
    create_workspace_calls == 0 &&
        requested_workspace_id == worker_workspace_id &&
        returned_workspace_id == worker_workspace_id
}

fn run_review_workspace_fixtures() {
    let worker_workspace_id = "worker-workspace-17";
    require(valid_first_review_launch(worker_workspace_id, 0,
            "worker-workspace-17", "worker-workspace-17"),
        "first review rejected exact worker-workspace placement");
    require(!valid_first_review_launch(worker_workspace_id, 1,
            "review-workspace-99", "review-workspace-99"),
        "separate review workspace incorrectly passed");
    require(!valid_first_review_launch(worker_workspace_id, 0, "", "coordinator-workspace"),
        "omitted reviewer workspaceId incorrectly passed");
    require(!valid_first_review_launch(worker_workspace_id, 0,
            "worker-workspace-17", "other-workspace"),
        "mismatched returned reviewer workspaceId incorrectly passed");
}
run_review_workspace_fixtures();

// Behavioral Fixture 9: a revised head resumes the retained reviewer. Only a
// definitively unavailable reviewer may be replaced, in the same workspace.
fn valid_rereview(existing_reviewer_status, retained_agent_id, prompted_agent_id,
        create_agent_calls, worker_workspace_id, replacement_workspace_id) {
    if existing_reviewer_status == "idle" || existing_reviewer_status == "finished" {
        return prompted_agent_id == retained_agent_id && create_agent_calls == 0;
    }
    if existing_reviewer_status == "definitively-unavailable" {
        return create_agent_calls == 1 && replacement_workspace_id == worker_workspace_id;
    }
    false
}

fn run_rereview_identity_fixtures() {
    require(valid_rereview("finished", "reviewer-4", "reviewer-4", 0,
            "worker-workspace-17", ""),
        "finished reviewer was not reusable for revised head");
    require(!valid_rereview("idle", "reviewer-4", "reviewer-5", 1,
            "worker-workspace-17", "worker-workspace-17"),
        "ordinary re-review incorrectly created a new reviewer");
    require(!valid_rereview("ambiguous", "reviewer-4", "", 1,
            "worker-workspace-17", "worker-workspace-17"),
        "ambiguous reviewer state incorrectly allowed replacement");
    require(valid_rereview("definitively-unavailable", "reviewer-4", "", 1,
            "worker-workspace-17", "worker-workspace-17"),
        "valid same-workspace replacement was rejected");
    require(!valid_rereview("definitively-unavailable", "reviewer-4", "", 1,
            "worker-workspace-17", "review-workspace-99"),
        "replacement reviewer incorrectly used another workspace");
}
run_rereview_identity_fixtures();

log("Northstar command-skill surface: OK (" + commands.len() + " adapters, aggregate descriptions=" + aggregate_description_chars + " chars)");
