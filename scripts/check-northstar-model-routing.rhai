// Focused routing-contract assertions for milestone `g02.047` (card 115).
//
// Each assertion names the milestone review-oracle row it defends. Positive
// assertions prove the diversified-routing rule is stated where it binds;
// negative assertions keep concentration-era wording and local provider,
// model, price, balance, or allowance values out of the reusable payload.
// This checker targets only the routing contract; it does not restore
// generic editorial validation.

fn load(relative) {
    fs::read_file(path::join(repo_root, relative))
}

fn pattern(phrase) {
    str::replace(phrase, " ", "\\s+")
}

fn require_row(row, surface, text, phrase) {
    if !regex::is_match(pattern(phrase), text) {
        throw("[northstar:model-routing] oracle '" + row + "': '" + phrase +
            "' missing from " + surface);
    }
}

fn forbid(row, surface, text, regex_pattern) {
    if regex::is_match(regex_pattern, text) {
        throw("[northstar:model-routing] oracle '" + row + "': forbidden pattern '" +
            regex_pattern + "' found in " + surface);
    }
}

fn require(condition, message) {
    if !condition {
        throw("[northstar:model-routing] " + message);
    }
}

let contract = load("docs/contracts/001-working-rules.md");
let architecture = load("docs/architecture/system-architecture.md");
let mode = load("skills/northstar/references/modes/coordinator.md");
let doctrine = load("bundle-docs/sections/07-delivery-framework-and-autonomy.md");
let template = load("template-bundle/contracts/001-working-rules-template.md");
let operators = load("bundle-docs/operators/operator-quick-start.md");
let skill = load("skills/northstar/SKILL.md");
let kernel = load("bundle-docs/protocol-kernel.md");
let handoff = load("skills/northstar/references/handoff-contract.md");
let chatterbox_mode = load("skills/northstar/references/modes/chatterbox.md");
let worker_template = load("skills/northstar/assets/templates/northstar-coordinator-run.md.template");

// Row 1 — adequacy precedes preference (adequate-pool assertion).
require_row("adequacy precedes preference", "working rules", contract, "adequate profile pool");
require_row("adequacy precedes preference", "architecture", architecture, "builds the adequate pool");
require_row("adequacy precedes preference", "coordinator mode", mode, "Adequacy comes before price or rotation");
require_row("adequacy precedes preference", "doctrine 07", doctrine, "Adequacy comes before price or rotation");
require_row("adequacy precedes preference", "working-rules template", template, "Adequacy filters before price or rotation");

// Row 2 — cheapest adequate tier wins (cost-tier assertion).
require_row("cheap adequate routes are used", "working rules", contract, "cheapest adequate tier");
require_row("cheap adequate routes are used", "architecture", architecture, "cheapest adequate tier");
require_row("cheap adequate routes are used", "coordinator mode", mode, "cheapest adequate tier");
require_row("cheap adequate routes are used", "doctrine 07", doctrine, "cheapest adequate tier");
require_row("cheap adequate routes are used", "working-rules template", template, "cheapest adequate tier");
require_row("cheap adequate routes are used", "skill outcome", skill, "cheapest adequate tier");
require_row("cheap adequate routes are used", "operator guidance", operators, "cheapest adequate day-to-day implementation pool");

// Row 3 — successful routes do not become permanent defaults (no-repeat
// assertion).
require_row("no permanent route defaults", "working rules", contract, "vary provider/model identity");
require_row("no permanent route defaults", "architecture", architecture, "varies provider/model identity");
require_row("no permanent route defaults", "coordinator mode", mode, "vary provider/model identity");
require_row("no permanent route defaults", "doctrine 07", doctrine, "vary provider/model identity");
require_row("no permanent route defaults", "working-rules template", template, "vary provider/model identity");
require_row("no permanent route defaults", "skill outcome", skill, "recent-use rotation");
require_row("no permanent route defaults", "operator guidance", operators, "varies provider/model identity between runs");

// Row 4 — history is optional; current-run memory is enough
// (history-fallback assertion).
require_row("history is optional", "working rules", contract, "recent-agent history");
require_row("history is optional", "architecture", architecture, "recent agent history");
require_row("history is optional", "coordinator mode", mode, "recent-agent history");
require_row("history is optional", "doctrine 07", doctrine, "recent-agent history");
require_row("history is optional", "working-rules template", template, "recent-agent history");
require_row("history is optional", "working rules", contract, "current coordinator run");
require_row("history is optional", "coordinator mode", mode, "current coordinator run");
require_row("history is optional", "working-rules template", template, "current coordinator run");
require_row("history is optional", "working rules", contract, "usage ledger");
require_row("history is optional", "architecture", architecture, "durable usage ledger");
require_row("history is optional", "coordinator mode", mode, "durable usage ledger");
require_row("history is optional", "doctrine 07", doctrine, "durable usage ledger");
require_row("history is optional", "working-rules template", template, "durable usage ledger");

// Row 5 — orchestrators rotate too (successor-routing assertion).
require_row("coordinator routes rotate too", "architecture", architecture, "Coordinator-role pool");
require_row("coordinator routes rotate too", "coordinator mode", mode, "adequate coordinator-role pool");
require_row("coordinator routes rotate too", "doctrine 07", doctrine, "adequate Coordinator-role pool");

// Row 6 — review strength is not worker price (risk-separation assertion).
require_row("review strength is not worker price", "working rules", contract, "keeps material review");
require_row("review strength is not worker price", "architecture", architecture, "material lanes use that economical pool");
require_row("review strength is not worker price", "coordinator mode", mode, "review-strength control");
require_row("review strength is not worker price", "doctrine 07", doctrine, "review-strength control");
require_row("review strength is not worker price", "working-rules template", template, "review-strength control");

// Row 7 — frontier cost is exceptional (residual-reasoning assertion).
require_row("frontier cost is exceptional", "working rules", contract, "remaining reasoning");
require_row("frontier cost is exceptional", "architecture", architecture, "remaining reasoning");
require_row("frontier cost is exceptional", "coordinator mode", mode, "remaining reasoning");
require_row("frontier cost is exceptional", "doctrine 07", doctrine, "remaining reasoning");
require_row("frontier cost is exceptional", "working-rules template", template, "remaining reasoning");

// Row 8 — operator intent wins (override assertion).
require_row("operator intent wins", "working rules", contract, "operator-named profile");
require_row("operator intent wins", "architecture", architecture, "operator-selected profile still wins");
require_row("operator intent wins", "coordinator mode", mode, "operator-named");
require_row("operator intent wins", "doctrine 07", doctrine, "operator-named profile");
require_row("operator intent wins", "working-rules template", template, "operator-named profile");
require_row("operator intent wins", "operator guidance", operators, "name a profile to");

// Row 9 — route failure stays local (failure/fallback assertion).
require_row("route failure stays local", "working rules", contract, "only for that attempt");
require_row("route failure stays local", "architecture", architecture, "mark only that route unavailable");
require_row("route failure stays local", "coordinator mode", mode, "mark only that route unavailable");
require_row("route failure stays local", "doctrine 07", doctrine, "only for that attempt");
require_row("route failure stays local", "working-rules template", template, "only for that attempt");
require_row("route failure stays local", "coordinator mode", mode, "lane's diversified pool");
require_row("route failure stays local", "doctrine 07", doctrine, "lane's diversified pool");
require_row("route failure stays local", "working-rules template", template, "lane's diversified pool");
require_row("route failure stays local", "operator guidance", operators, "lane's diversified pool");

// Row 10 — implementation adequacy is role-first. Documentation volume does
// not turn an implementation lane into an audit or documentation-grind job.
require_row("implementation routing is role-first", "working rules", contract, "profile qualifies only when its live notes explicitly fit implementation or general day-to-day work");
require_row("implementation routing is role-first", "working rules", contract, "Audit, documentation-grind, review, planning, and coordinator profiles do not qualify");
require_row("implementation routing is role-first", "coordinator mode", mode, "excluded from implementation lanes even when the work is long");
require_row("implementation routing is role-first", "doctrine 07", doctrine, "profiles do not qualify merely because an implementation lane is long");
require_row("implementation routing is role-first", "working-rules template", template, "profiles do not qualify merely because an implementation lane is long");
require_row("implementation routing is role-first", "operator guidance", operators, "profiles are not implementation workers");

// Row 11 — pre-PR semantic blockers return to the human-facing planning
// authority rather than making the mechanical coordinator interrogate the
// operator or invent the decision.
require_row("pre-PR decisions return to Chatterbox", "working rules", contract, "pre-PR decision request");
require_row("pre-PR decisions return to Chatterbox", "coordinator mode", mode, "Do not ask the operator the question in the coordinator thread");
require_row("pre-PR decisions return to Chatterbox", "chatterbox mode", chatterbox_mode, "Chatterbox ruling");
require_row("pre-PR decisions return to Chatterbox", "doctrine 07", doctrine, "pre-PR decision request");
require_row("pre-PR decisions return to Chatterbox", "working-rules template", template, "pre-PR decision request");
require_row("pre-PR decisions return to Chatterbox", "operator guidance", operators, "resumes the same worker");
require_row("pre-PR decisions return to Chatterbox", "worker handoff template", worker_template, "complete 10-part blocker capsule");
require_row("pre-PR decisions return to Chatterbox", "skill outcome", skill, "pre-PR worker decision requests routed to Chatterbox");

// Row 12 — observable planning completeness stays with Chatterbox; frontier
// advice is recommendation-only until the operator explicitly approves it.
for entry in [
    #{ "name": "working rules", "text": contract },
    #{ "name": "architecture", "text": architecture },
    #{ "name": "doctrine 07", "text": doctrine },
    #{ "name": "working-rules template", "text": template },
    #{ "name": "chatterbox mode", "text": chatterbox_mode },
] {
    require_row("planning-risk check is explicit", entry["name"], entry["text"], "observable planning completeness");
    require_row("frontier advice requires approval", entry["name"], entry["text"], "explicit operator approval");
    require_row("frontier advice is not a gate", entry["name"], entry["text"], "Ready manifests require no second-opinion field");
}
for marker in [
    "security",
    "privacy",
    "sensitive information",
    "trust boundaries",
    "irreversible",
    "cross-system",
    "distributed or concurrent",
    "falsifiable acceptance oracle",
    "model self-confidence",
    "do not automatically create or authorize another planning thread",
] {
    require_row("risk classes are observable", "chatterbox mode", chatterbox_mode, marker);
}
for marker in [
    "exact question",
    "minimum necessary evidence",
    "raw sensitive payloads",
    "ordinary advisor or committee mechanism",
    "Do not create, spawn, or request",
] {
    require_row("frontier advice is bounded and operator-approved", "chatterbox mode", chatterbox_mode, marker);
}

fn planning_complete(decision) {
    decision["authority_complete"] && decision["owner_named"] &&
        decision["evidence_separated"] && decision["alternatives_explained"] &&
        decision["irreversible_effects_identified"] && decision["oracle_falsifiable"]
}

fn advisor_launch_authorized(decision) {
    decision["operator_approved"]
}

fn run_planning_risk_fixtures() {
    let security_decision = #{
        "authority_complete": true,
        "owner_named": true,
        "evidence_separated": true,
        "alternatives_explained": true,
        "irreversible_effects_identified": true,
        "oracle_falsifiable": true,
        "operator_approved": false,
    };
    require(planning_complete(security_decision),
        "complete security planning fixture was rejected");
    require(!advisor_launch_authorized(security_decision),
        "risk label automatically authorized a frontier advisor");

    let incomplete_low_risk = security_decision;
    incomplete_low_risk["authority_complete"] = false;
    require(!planning_complete(incomplete_low_risk),
        "incomplete low-risk fixture incorrectly passed planning completeness");

    let approved_advisor = security_decision;
    approved_advisor["operator_approved"] = true;
    require(advisor_launch_authorized(approved_advisor),
        "explicit operator approval did not authorize the consultation");
}
run_planning_risk_fixtures();

// Row 13 — Northstar stays portable (provider-neutral search plus parity).
// The per-surface assertions above cover both the live contract and the
// copy-ready template with the same markers, so drift between them fails a
// named row; the scans below reject local model names, prices, and the
// concentration-era fallback wording anywhere in the routing payload.
let scanned = [
    #{ "name": "working rules", "text": contract },
    #{ "name": "architecture", "text": architecture },
    #{ "name": "coordinator mode", "text": mode },
    #{ "name": "doctrine 07", "text": doctrine },
    #{ "name": "working-rules template", "text": template },
    #{ "name": "operator guidance", "text": operators },
    #{ "name": "skill outcome", "text": skill },
    #{ "name": "protocol kernel", "text": kernel },
    #{ "name": "handoff guidance", "text": handoff },
];

for entry in scanned {
    forbid("northstar stays portable", entry["name"], entry["text"],
        "(?i)\\b(opus|grok|glm|sonnet|haiku|gemini)\\b");
    forbid("northstar stays portable", entry["name"], entry["text"],
        "(?i)\\b(sol|luna)\\b");
    forbid("northstar stays portable", entry["name"], entry["text"], "\\$\\s?[0-9]");
    forbid("northstar stays portable", entry["name"], entry["text"], "same-class");
    forbid("northstar stays portable", entry["name"], entry["text"],
        "matching non-frontier day-to-day profile");
    forbid("northstar stays portable", entry["name"], entry["text"], "best-fit");
}

log("Northstar model-routing contract assertions: OK (thirteen routing oracle rows)");
