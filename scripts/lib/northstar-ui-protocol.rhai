// Pure protocol logic and fixtures for Northstar UI design planning and
// delivery (spec 039 / g03.004). No filesystem or provider access.

fn required_sections() {
    [
        "What This Thread Was Doing",
        "Why It Matters",
        "Current State",
        "Boundaries",
        "Important Context",
        "Suggested Next Move",
        "Completion Protocol",
    ]
}

fn brief_depth(classification) {
    if classification == "refinement" {
        return "compact";
    }
    if classification == "workflow change" {
        return "full";
    }
    if classification == "substantial redesign" {
        return "full+concept";
    }
    "unknown"
}

fn depth_rank(depth) {
    if depth == "compact" {
        return 1;
    }
    if depth == "full" {
        return 2;
    }
    if depth == "full+concept" {
        return 3;
    }
    0
}

fn required_rank(classification) {
    if classification == "refinement" {
        return 1;
    }
    if classification == "workflow change" {
        return 2;
    }
    if classification == "substantial redesign" {
        return 3;
    }
    99
}

fn join_reasons(reasons) {
    let text = "";
    for reason in reasons {
        if text != "" {
            text += " | ";
        }
        text += reason;
    }
    text
}

// Decide whether a UI lane may be marked ready. `plan` fields:
//   ui_marked, classification, brief_depth, current_workflow_defined,
//   target_workflow_defined, scenario_oracle_defined, open_decisions,
//   operator_selected_concept, handoff_carries_ui_brief, handoff_canonical_link
fn readiness(plan) {
    let reasons = [];
    if !plan["ui_marked"] {
        return #{ ready: true, reasons: reasons };
    }

    let expected = brief_depth(plan["classification"]);
    if expected == "unknown" {
        reasons.push("unknown UI classification: " + plan["classification"]);
    } else if depth_rank(plan["brief_depth"]) < required_rank(plan["classification"]) {
        reasons.push("brief depth '" + plan["brief_depth"] + "' is insufficient for " + plan["classification"]);
    }

    if !plan["current_workflow_defined"] {
        reasons.push("current workflow is undefined");
    }
    if !plan["target_workflow_defined"] {
        reasons.push("target workflow is undefined");
    }
    if !plan["scenario_oracle_defined"] {
        reasons.push("scenario oracle is undefined");
    }
    if plan["open_decisions"].len() > 0 {
        reasons.push("open material experience decisions: " + join_reasons(plan["open_decisions"]));
    }
    if expected == "full+concept" && !plan["operator_selected_concept"] {
        reasons.push("operator-selected concept or prototype evidence is missing");
    }
    if !plan["handoff_carries_ui_brief"] {
        reasons.push("handoff UI Design Brief subsection is missing");
    }
    if !plan["handoff_canonical_link"] {
        reasons.push("handoff brief does not bind to its canonical owner");
    }

    #{ ready: reasons.len() == 0, reasons: reasons }
}

fn top_level_sections(text) {
    let sections = [];
    for line in str::split_lines(text) {
        if str::starts_with(line, "## ") && !str::starts_with(line, "### ") {
            sections.push(str::trim(str::replace(line, "## ", "")));
        }
    }
    sections
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

// Validate that a handoff preserves the seven-section contract and transports
// the UI brief under Important Context before Suggested Next Move.
fn validate_ui_handoff(text, expect_ui_brief) {
    let errors = [];
    let required = required_sections();
    let sections = top_level_sections(text);
    if sections.len() != required.len() {
        errors.push("expected 7 top-level sections, found " + sections.len());
    } else {
        let index = 0;
        for expected in required {
            if sections[index] != expected {
                errors.push("section " + index + " is '" + sections[index] + "', expected '" + expected + "'");
            }
            index += 1;
        }
    }

    if expect_ui_brief {
        let important = line_index_of(text, "## Important Context");
        let brief = line_index_of(text, "### UI Design Brief");
        let next_move = line_index_of(text, "## Suggested Next Move");
        if brief < 0 {
            errors.push("missing '### UI Design Brief' subsection");
        } else if important < 0 || brief < important {
            errors.push("'### UI Design Brief' is not inside '## Important Context'");
        } else if next_move >= 0 && brief > next_move {
            errors.push("'### UI Design Brief' must precede '## Suggested Next Move'");
        }
        if !text.contains("**Canonical owner:**") {
            errors.push("UI Design Brief does not name its canonical owner");
        }
    }

    #{ ok: errors.len() == 0, errors: errors }
}

// Decide whether attached delivery evidence proves rendered behavior rather
// than a deterministic floor. `evidence` fields:
//   ran_exact_head, exercised_scenario_oracle, rendered_states,
//   deterministic_only, screenshot_only, tests_only
fn evidence_sufficient(evidence) {
    let reasons = [];
    if !evidence["ran_exact_head"] {
        reasons.push("the running exact head was not inspected");
    }
    if !evidence["exercised_scenario_oracle"] {
        reasons.push("the scenario oracle was not exercised");
    }
    if evidence["rendered_states"].len() == 0 {
        reasons.push("no named rendered states were captured");
    }
    if evidence["deterministic_only"] {
        reasons.push("a deterministic check is presented as design proof");
    }
    if evidence["screenshot_only"] {
        reasons.push("a static screenshot is presented as design proof");
    }
    if evidence["tests_only"] {
        reasons.push("passing tests are presented as experience proof");
    }
    #{ ok: reasons.len() == 0, reasons: reasons }
}

// A material experience miss blocks acceptance regardless of diff quality or
// green deterministic checks.
fn review_blocks(material_ui_miss, diff_correct, checks_pass) {
    material_ui_miss
}
