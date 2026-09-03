// Focused worker-parentage assertions for milestone `g02.049` (card 123).
//
// Each assertion names the milestone review-oracle row it defends. Positive
// assertions prove the scoped cross-workspace child creation rule is stated
// where it binds; negative assertions keep detached-launch wording, root-launch
// substitutes, and disabled finish notifications out of the reusable payload.
// This checker targets only the worker-parentage contract; it does not restore
// generic editorial validation.

fn load(relative) {
    fs::read_file(path::join(repo_root, relative))
}

fn pattern(phrase) {
    let p = str::replace(phrase, "\\", "\\\\");
    p = str::replace(p, "(", "\\(");
    p = str::replace(p, ")", "\\)");
    p = str::replace(p, "[", "\\[");
    p = str::replace(p, "]", "\\]");
    p = str::replace(p, "`", "\\`");
    str::replace(p, " ", "\\s+")
}

fn require_row(row, surface, text, phrase) {
    if !regex::is_match(pattern(phrase), text) {
        throw("[northstar:worker-parentage] oracle '" + row + "': '" + phrase +
            "' missing from " + surface);
    }
}

fn forbid(row, surface, text, regex_pattern) {
    if regex::is_match(regex_pattern, text) {
        throw("[northstar:worker-parentage] oracle '" + row + "': forbidden pattern '" +
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

// Row 1 — isolation and parentage coexist (ordered positive assertion).
require_row("isolation and parentage coexist", "spec 026", spec, "first creates the lane's dedicated worktree workspace, then uses its own agent-scoped `create_agent` surface");
require_row("isolation and parentage coexist", "working rules", contract, "dedicated worktree workspace first, then creates the worker as a child agent from its own scoped surface using that returned workspace ID");
require_row("isolation and parentage coexist", "architecture", architecture, "create one dedicated worktree workspace per worker lane, create the worker as a child agent from its scoped surface with that returned workspace ID");
require_row("isolation and parentage coexist", "orchestrator mode", mode, "current orchestrator's agent-scoped `create_agent` call");
require_row("isolation and parentage coexist", "doctrine 07", doctrine, "dedicated `branch-off` worktree workspace first, then creates the worker as a child agent from its own agent-scoped surface using that returned workspace ID");
require_row("isolation and parentage coexist", "working-rules template", template, "dedicated worktree workspace first, then create the worker from the orchestrator's agent-scoped tool context with that returned workspace ID");
require_row("isolation and parentage coexist", "operator guidance", operators, "creates each lane's dedicated worktree workspace first, then creates the worker as a child agent from its own scoped surface using that returned workspace ID");
require_row("isolation and parentage coexist", "skill outcome", skill, "Paseo worker parentage preserved across dedicated worktree workspace placement");

// Row 2 — workspace placement does not detach (cross-workspace child assertion).
require_row("workspace placement does not detach", "spec 026", spec, "Passing the new `workspaceId` changes placement without detaching ownership");
require_row("workspace placement does not detach", "working rules", contract, "Workspace placement does not detach parentage");
require_row("workspace placement does not detach", "architecture", architecture, "Workspace placement does not detach parentage");
require_row("workspace placement does not detach", "orchestrator mode", mode, "Workspace placement does not detach parentage");
require_row("workspace placement does not detach", "doctrine 07", doctrine, "Workspace placement does not detach parentage");
require_row("workspace placement does not detach", "working-rules template", template, "Workspace placement does not detach parentage");
require_row("workspace placement does not detach", "operator guidance", operators, "Workspace placement does not detach parentage");
require_row("workspace placement does not detach", "protocol kernel", kernel, "Paseo worker parentage and cross-workspace child dispatch");

// Row 3 — detached roots are invalid workers (negative detached-launch assertion).
require_row("detached roots are invalid workers", "spec 026", spec, "top-level/root-agent launch, schedule, generic detached run, or CLI path that cannot prove attachment to the current orchestrator is not an equivalent worker launch");
require_row("detached roots are invalid workers", "working rules", contract, "top-level/root-agent launch, schedule, generic detached run, or CLI path without explicit parent attachment is rejected");
require_row("detached roots are invalid workers", "architecture", architecture, "detached root launches, schedules, generic detached runs, or unproven CLI substitutes are rejected");
require_row("detached roots are invalid workers", "orchestrator mode", mode, "top-level/root-agent launch, schedule, generic detached run, or CLI path without explicit parent attachment is rejected");
require_row("detached roots are invalid workers", "doctrine 07", doctrine, "top-level/root-agent launch, schedule, generic detached run, or unproven CLI path is rejected");
require_row("detached roots are invalid workers", "working-rules template", template, "Detached root, schedule, generic detached, or unproven CLI launches are rejected");
require_row("detached roots are invalid workers", "operator guidance", operators, "Detached root launches, schedules, generic detached runs, or unproven CLI substitutes are rejected");

// Row 4 — notifications are structural (notification assertion).
require_row("notifications are structural", "spec 026", spec, "Finish notifications stay enabled");
require_row("notifications are structural", "working rules", contract, "leaves finish notifications enabled");
require_row("notifications are structural", "architecture", architecture, "finish notifications enabled");
require_row("notifications are structural", "orchestrator mode", mode, "leave finish notification enabled (`notifyOnFinish: true`)");
require_row("notifications are structural", "doctrine 07", doctrine, "Finish notifications remain structural and enabled");
require_row("notifications are structural", "working-rules template", template, "Finish notifications remain enabled");
require_row("notifications are structural", "orchestrator mode", mode, "reject launch configuration if finish notifications are disabled");

// Row 5 — revisions retain identity (follow-up identity assertion).
require_row("revisions retain identity", "spec 026", spec, "resume the same child for review revisions");
require_row("revisions retain identity", "working rules", contract, "resumes the same child agent");
require_row("revisions retain identity", "architecture", architecture, "Revisions resume the same child agent");
require_row("revisions retain identity", "orchestrator mode", mode, "do not create a replacement worker when changes are requested");
require_row("revisions retain identity", "doctrine 07", doctrine, "resume the same child agent identity rather than creating a detached replacement");
require_row("revisions retain identity", "working-rules template", template, "review follow-up resumes the same child");
require_row("revisions retain identity", "operator guidance", operators, "resumes the same child for revisions");

// Row 6 — provider neutrality survives (manual-fallback assertion).
require_row("provider neutrality survives", "spec 026", spec, "Without Paseo, the source returns the absolute handoff path for manual launch");
require_row("provider neutrality survives", "working rules", contract, "Manual launch and operator relay remain the required fallback when scoped tools are absent, returning the absolute handoff path without pretending parentage exists");
require_row("provider neutrality survives", "architecture", architecture, "Manual launch and operator relay remain the fallback when scoped tools are absent, returning the absolute handoff path without pretending parentage exists");
require_row("provider neutrality survives", "orchestrator mode", mode, "If required scoped tools are absent, use manual dispatch with the absolute handoff path without pretending parentage exists");
require_row("provider neutrality survives", "doctrine 07", doctrine, "Where no control plane or scoped tools are available, return the committed handoff's absolute path for manual launch without pretending parentage exists");
require_row("provider neutrality survives", "working-rules template", template, "With no control plane or when scoped tools are absent, publish every selected handoff at once for manual launch without pretending parentage exists");
require_row("provider neutrality survives", "operator guidance", operators, "Without Paseo or when scoped tools are absent, you get every absolute handoff path for manual launch without pretended parentage");

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
];

for entry in scanned {
    forbid("detached roots are invalid workers", entry["name"], entry["text"],
        "(?i)\\b(?:root[- ]agent|top[- ]level)\\s+(?:is\\s+an?\\s+equivalent|satisfies|is\\s+valid\\s+for)\\s+worker\\b");
    forbid("notifications are structural", entry["name"], entry["text"],
        "(?i)\\b(?:disable|turn\\s+off)\\s+(?:finish\\s+)?notifications?\\s+for\\s+workers?\\b");
}

log("Northstar worker-parentage contract assertions: OK (six milestone 049 oracle rows)");
