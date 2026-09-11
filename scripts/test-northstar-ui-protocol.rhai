import "scripts/lib/northstar-ui-protocol.rhai" as ui;

fn require(condition, message) {
    if !condition {
        throw("[northstar:ui-protocol-fixtures] " + message);
    }
}

fn base_plan() {
    #{
        ui_marked: true,
        classification: "workflow change",
        brief_depth: "full",
        current_workflow_defined: true,
        target_workflow_defined: true,
        scenario_oracle_defined: true,
        open_decisions: [],
        operator_selected_concept: false,
        handoff_carries_ui_brief: true,
        handoff_canonical_link: true,
    }
}

fn expect_reason(report, needle, label) {
    require(!report["ready"], label + " unexpectedly passed readiness");
    let joined = "";
    for reason in report["reasons"] {
        joined += reason + "\n";
    }
    require(joined.contains(needle), label + " failed for the wrong reason: " + joined);
}

fn valid_handoff() {
    "## What This Thread Was Doing\n" +
    "Story.\n\n" +
    "## Why It Matters\n" +
    "Reason.\n\n" +
    "## Current State\n" +
    "- **Done:** x\n\n" +
    "## Boundaries\n" +
    "- **Out of scope:** y\n\n" +
    "## Important Context\n" +
    "- **Planning lineage:** z\n\n" +
    "### UI Design Brief\n" +
    "- **Canonical owner:** docs/roadmaps/g03/004-ui-design-planning-and-delivery.md\n" +
    "- **Classification:** workflow change\n\n" +
    "## Suggested Next Move\n" +
    "Start here.\n\n" +
    "## Completion Protocol\n" +
    "Finish.\n"
}

// Fixture 1: a refinement uses the compact brief and needs no prototype.
let refinement = base_plan();
refinement["classification"] = "refinement";
refinement["brief_depth"] = "compact";
let refinement_report = ui::readiness(refinement);
require(refinement_report["ready"],
    "refinement fixture failed: compact brief should pass without a prototype: " +
    ui::join_reasons(refinement_report["reasons"]));
log("ui fixture refinement-compact: PASS");

// Fixture 2: an established-pattern correction must not be blocked on the full
// concept path, but a workflow change needs the full brief and scenario oracle.
let shallow_change = base_plan();
shallow_change["brief_depth"] = "compact";
expect_reason(ui::readiness(shallow_change),
    "insufficient for workflow change", "workflow-change-shallow");
let no_oracle = base_plan();
no_oracle["scenario_oracle_defined"] = false;
expect_reason(ui::readiness(no_oracle),
    "scenario oracle is undefined", "workflow-change-missing-oracle");
log("ui fixture workflow-change-depth: PASS");

// Fixture 3: substantial redesign fails readiness until operator-selected
// concept evidence is represented, and passes once it is.
let substantial = base_plan();
substantial["classification"] = "substantial redesign";
substantial["brief_depth"] = "full";
let missing_concept = ui::readiness(substantial);
expect_reason(missing_concept, "brief depth 'full' is insufficient", "substantial-missing-concept-depth");
substantial["brief_depth"] = "full+concept";
expect_reason(ui::readiness(substantial),
    "operator-selected concept or prototype evidence is missing", "substantial-missing-concept");
substantial["operator_selected_concept"] = true;
require(ui::readiness(substantial)["ready"],
    "substantial fixture failed: operator-selected concept should pass readiness");
log("ui fixture substantial-concept-gate: PASS");

// Fixture 4: design precedes coding. An open workflow, hierarchy, or state
// decision keeps a ready candidate un-ready and names the decision.
let open_decision = base_plan();
open_decision["open_decisions"] = ["checkout navigation becomes a two-step flow"];
expect_reason(ui::readiness(open_decision),
    "open material experience decisions", "open-material-decision");
let no_target = base_plan();
no_target["target_workflow_defined"] = false;
expect_reason(ui::readiness(no_target), "target workflow is undefined", "design-precedes-coding");
log("ui fixture design-precedes-coding: PASS");

// Fixture 5: handoff transport keeps the seven-section contract and places the
// self-contained brief under Important Context before Suggested Next Move.
let good = ui::validate_ui_handoff(valid_handoff(), true);
require(good["ok"], "handoff fixture failed: " + ui::join_reasons(good["errors"]));
let missing_brief = ui::validate_ui_handoff(
    str::replace(valid_handoff(), "### UI Design Brief\n", ""), true);
require(!missing_brief["ok"], "handoff fixture passed without a UI Design Brief");
require(ui::join_reasons(missing_brief["errors"]).contains("### UI Design Brief"),
    "missing-brief failure did not name the subsection");
let no_canonical_owner = ui::validate_ui_handoff(
    str::replace(valid_handoff(), "**Canonical owner:**", "**Owner:**"), true);
require(!no_canonical_owner["ok"],
    "handoff fixture accepted a UI Design Brief without a canonical owner");
log("ui fixture handoff-transport: PASS");

// Fixture 6: the brief must not sit after Suggested Next Move.
let after_next = "## What This Thread Was Doing\nx\n\n## Why It Matters\nx\n\n## Current State\nx\n\n## Boundaries\nx\n\n## Important Context\nx\n\n## Suggested Next Move\nx\n\n### UI Design Brief\n- **Canonical owner:** g03.004\n\n## Completion Protocol\nx\n";
let displaced = ui::validate_ui_handoff(after_next, true);
require(!displaced["ok"], "handoff fixture accepted a brief after Suggested Next Move");
log("ui fixture handoff-brief-placement: PASS");

// Fixture 7: build and review evidence must come from the running exact head,
// not from tests, a screenshot, or a deterministic detector.
let rendered = #{
    ran_exact_head: true,
    exercised_scenario_oracle: true,
    rendered_states: ["empty", "error", "success"],
    deterministic_only: false,
    screenshot_only: false,
    tests_only: false,
};
require(ui::evidence_sufficient(rendered)["ok"],
    "evidence fixture rejected running exact-head rendered evidence");
for field in ["deterministic_only", "screenshot_only", "tests_only"] {
    let claim = #{
        ran_exact_head: true,
        exercised_scenario_oracle: true,
        rendered_states: ["success"],
        deterministic_only: false,
        screenshot_only: false,
        tests_only: false,
    };
    claim[field] = true;
    require(!ui::evidence_sufficient(claim)["ok"],
        "evidence fixture accepted " + field + " as design proof");
}
let diff_only = #{
    ran_exact_head: false,
    exercised_scenario_oracle: true,
    rendered_states: ["success"],
    deterministic_only: false,
    screenshot_only: false,
    tests_only: false,
};
require(!ui::evidence_sufficient(diff_only)["ok"],
    "evidence fixture accepted evidence that never ran the exact head");
log("ui fixture rendered-evidence: PASS");

// Fixture 8: a material UI miss blocks even when the diff is correct and
// deterministic checks pass; a clean run does not block.
require(ui::review_blocks(true, true, true),
    "review fixture failed: material UI miss must block a correct diff");
require(!ui::review_blocks(false, true, true),
    "review fixture failed: no material miss must not block");
log("ui fixture review-blocks-material-miss: PASS");

// Fixture 9: non-UI lanes are unaffected by the UI readiness gate.
let non_ui = #{
    ui_marked: false,
    classification: "none",
    brief_depth: "none",
    current_workflow_defined: false,
    target_workflow_defined: false,
    scenario_oracle_defined: false,
    open_decisions: [],
    operator_selected_concept: false,
    handoff_carries_ui_brief: false,
    handoff_canonical_link: false,
};
require(ui::readiness(non_ui)["ready"], "non-UI lane was blocked by the UI readiness gate");
log("ui fixture non-ui-unaffected: PASS");

log("Northstar UI protocol fixture tests: OK (9 fixtures)");
