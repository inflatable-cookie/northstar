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

let spec = load("docs/specs/026-orchestrator-thread-and-worker-pr-loop.md");
let contract = load("docs/contracts/001-working-rules.md");
let architecture = load("docs/architecture/system-architecture.md");
let mode = load("skills/northstar/references/modes/orchestrator.md");
let doctrine = load("bundle-docs/sections/07-delivery-framework-and-autonomy.md");
let template = load("template-bundle/contracts/001-working-rules-template.md");
let operators = load("bundle-docs/operators/operator-quick-start.md");
let skill = load("skills/northstar/SKILL.md");
let kernel = load("bundle-docs/protocol-kernel.md");
let handoff = load("skills/northstar/references/handoff-contract.md");

// Row 1 — adequacy precedes preference (adequate-pool assertion).
require_row("adequacy precedes preference", "spec 026", spec, "adequate profile pool");
require_row("adequacy precedes preference", "working rules", contract, "adequate profile pool");
require_row("adequacy precedes preference", "architecture", architecture, "builds the adequate pool");
require_row("adequacy precedes preference", "orchestrator mode", mode, "Adequacy comes before price or rotation");
require_row("adequacy precedes preference", "doctrine 07", doctrine, "Adequacy comes before price or rotation");
require_row("adequacy precedes preference", "working-rules template", template, "Adequacy filters before price or rotation");

// Row 2 — cheapest adequate tier wins (cost-tier assertion).
require_row("cheap adequate routes are used", "spec 026", spec, "cheapest adequate tier");
require_row("cheap adequate routes are used", "working rules", contract, "cheapest adequate tier");
require_row("cheap adequate routes are used", "architecture", architecture, "cheapest adequate tier");
require_row("cheap adequate routes are used", "orchestrator mode", mode, "cheapest adequate tier");
require_row("cheap adequate routes are used", "doctrine 07", doctrine, "cheapest adequate tier");
require_row("cheap adequate routes are used", "working-rules template", template, "cheapest adequate tier");
require_row("cheap adequate routes are used", "skill outcome", skill, "cheapest adequate tier");
require_row("cheap adequate routes are used", "operator guidance", operators, "cheapest adequate day-to-day pool");

// Row 3 — successful routes do not become permanent defaults (no-repeat
// assertion).
require_row("no permanent route defaults", "spec 026", spec, "vary provider/model identity");
require_row("no permanent route defaults", "working rules", contract, "vary provider/model identity");
require_row("no permanent route defaults", "architecture", architecture, "varies provider/model identity");
require_row("no permanent route defaults", "orchestrator mode", mode, "vary provider/model identity");
require_row("no permanent route defaults", "doctrine 07", doctrine, "vary provider/model identity");
require_row("no permanent route defaults", "working-rules template", template, "vary provider/model identity");
require_row("no permanent route defaults", "skill outcome", skill, "recent-use rotation");
require_row("no permanent route defaults", "operator guidance", operators, "varies provider/model identity between runs");

// Row 4 — history is optional; current-run memory is enough
// (history-fallback assertion).
require_row("history is optional", "spec 026", spec, "recent-agent history");
require_row("history is optional", "working rules", contract, "recent-agent history");
require_row("history is optional", "architecture", architecture, "recent agent history");
require_row("history is optional", "orchestrator mode", mode, "recent-agent history");
require_row("history is optional", "doctrine 07", doctrine, "recent-agent history");
require_row("history is optional", "working-rules template", template, "recent-agent history");
require_row("history is optional", "spec 026", spec, "current orchestrator run");
require_row("history is optional", "working rules", contract, "current orchestrator run");
require_row("history is optional", "orchestrator mode", mode, "current orchestrator run");
require_row("history is optional", "working-rules template", template, "current orchestrator run");
require_row("history is optional", "spec 026", spec, "durable usage ledger");
require_row("history is optional", "working rules", contract, "usage ledger");
require_row("history is optional", "architecture", architecture, "durable usage ledger");
require_row("history is optional", "orchestrator mode", mode, "durable usage ledger");
require_row("history is optional", "doctrine 07", doctrine, "durable usage ledger");
require_row("history is optional", "working-rules template", template, "durable usage ledger");

// Row 5 — orchestrators rotate too (successor-routing assertion).
require_row("orchestrators rotate too", "spec 026", spec, "adequate orchestrator-role pool");
require_row("orchestrators rotate too", "architecture", architecture, "orchestrator-role pool");
require_row("orchestrators rotate too", "orchestrator mode", mode, "adequate orchestrator-role pool");
require_row("orchestrators rotate too", "doctrine 07", doctrine, "orchestrator-role pool");

// Row 6 — review strength is not worker price (risk-separation assertion).
require_row("review strength is not worker price", "spec 026", spec, "review-strength control");
require_row("review strength is not worker price", "working rules", contract, "keeps material review");
require_row("review strength is not worker price", "architecture", architecture, "material lanes use that economical pool");
require_row("review strength is not worker price", "orchestrator mode", mode, "review-strength control");
require_row("review strength is not worker price", "doctrine 07", doctrine, "review-strength control");
require_row("review strength is not worker price", "working-rules template", template, "review-strength control");

// Row 7 — frontier cost is exceptional (residual-reasoning assertion).
require_row("frontier cost is exceptional", "spec 026", spec, "remaining reasoning");
require_row("frontier cost is exceptional", "working rules", contract, "remaining reasoning");
require_row("frontier cost is exceptional", "architecture", architecture, "remaining reasoning");
require_row("frontier cost is exceptional", "orchestrator mode", mode, "remaining reasoning");
require_row("frontier cost is exceptional", "doctrine 07", doctrine, "remaining reasoning");
require_row("frontier cost is exceptional", "working-rules template", template, "remaining reasoning");

// Row 8 — operator intent wins (override assertion).
require_row("operator intent wins", "spec 026", spec, "operator-named profile");
require_row("operator intent wins", "working rules", contract, "operator-named profile");
require_row("operator intent wins", "architecture", architecture, "operator-selected profile still wins");
require_row("operator intent wins", "orchestrator mode", mode, "operator-named");
require_row("operator intent wins", "doctrine 07", doctrine, "operator-named profile");
require_row("operator intent wins", "working-rules template", template, "operator-named profile");
require_row("operator intent wins", "operator guidance", operators, "name a profile to");

// Row 9 — route failure stays local (failure/fallback assertion).
require_row("route failure stays local", "working rules", contract, "only for that attempt");
require_row("route failure stays local", "architecture", architecture, "mark only that route unavailable");
require_row("route failure stays local", "orchestrator mode", mode, "mark only that route unavailable");
require_row("route failure stays local", "doctrine 07", doctrine, "only for that attempt");
require_row("route failure stays local", "working-rules template", template, "only for that attempt");
require_row("route failure stays local", "orchestrator mode", mode, "lane's diversified pool");
require_row("route failure stays local", "doctrine 07", doctrine, "lane's diversified pool");
require_row("route failure stays local", "working-rules template", template, "lane's diversified pool");
require_row("route failure stays local", "operator guidance", operators, "lane's diversified pool");

// Row 10 — Northstar stays portable (provider-neutral search plus parity).
// The per-surface assertions above cover both the live contract and the
// copy-ready template with the same markers, so drift between them fails a
// named row; the scans below reject local model names, prices, and the
// concentration-era fallback wording anywhere in the routing payload.
let scanned = [
    #{ "name": "spec 026", "text": spec },
    #{ "name": "working rules", "text": contract },
    #{ "name": "architecture", "text": architecture },
    #{ "name": "orchestrator mode", "text": mode },
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

log("Northstar model-routing contract assertions: OK (ten milestone 047 oracle rows)");
