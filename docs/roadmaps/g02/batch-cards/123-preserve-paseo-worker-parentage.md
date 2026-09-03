# 123 - Preserve Paseo Worker Parentage

Status: complete
Owner: repo maintainers
Created: 2026-09-03
Master roadmap: `g02.049`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/roadmaps/g02/049-preserve-paseo-worker-parentage.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Auto-start next card: no

## Objective

Make Paseo worker dispatch preserve both dedicated-workspace isolation and the
worker's child relationship to the current orchestrator.

## Scope

- update working rules, reusable doctrine, copy-ready contract, and operator
  guidance with the scoped cross-workspace child sequence;
- update the installable orchestrator mode and concise skill outcome;
- update protocol-kernel or architecture routing only where needed to keep the
  canonical owner discoverable;
- add focused positive and negative assertions for the six milestone oracle
  rows;
- prove installed-skill parity;
- write closeout evidence, reconcile front doors, and open a reviewable PR.

Out of scope: Paseo code/CLI changes, shared workspaces, generic notification
infrastructure, polling, provider-specific model changes, card 120, language
packages, Sentrux, or weaker worktree/review/merge boundaries.

## Ready-State Checks

- [x] the operator supplied a live failure pattern: detached root workers do
  not notify their originating orchestrators;
- [x] the Paseo reference confirms that agent-scoped `create_agent` preserves
  parentage when passed another workspace's ID;
- [x] spec 026 settles the ordered workspace-then-scoped-agent sequence and
  rejects detached substitutes;
- [x] the six review-oracle rows and implementation surfaces are bounded;
- [x] no active Northstar worker owns the same protocol surfaces.

## Acceptance Criteria

- [x] all six milestone oracle rows have focused proof;
- [x] every Paseo worker gets a dedicated `branch-off` worktree workspace;
- [x] worker creation is explicitly agent-scoped to the current orchestrator
  and receives the returned workspace ID;
- [x] live reusable wording rejects detached root, schedule, generic detached,
  and unproven CLI substitutes;
- [x] finish notification remains enabled and review follow-up targets the same
  child;
- [x] manual/provider-neutral fallback remains intact;
- [x] doctrine, copy-ready contract, skill source, operator guidance, and
  deterministic checks agree;
- [x] isolated skill-install parity, docs QA, full QA, and `git diff --check`
  pass;
- [x] the PR records its exact tested head and any limits.

## Evidence

### Before / after wording inventory

| Surface | Before | After |
| --- | --- | --- |
| `docs/contracts/001-working-rules.md` | "created in one isolated workspace for the lane"; "launches a worker with the single absolute handoff path" | "dedicated worktree workspace first, then creates the worker as a child agent from its own scoped surface using that returned workspace ID and finish notifications enabled"; "creates the worker as a child agent from its own agent-scoped tool context with that returned workspace ID, leaves finish notifications enabled (`notifyOnFinish: true`)"; rejects detached root, schedule, generic detached, or unproven CLI substitutes |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | General workspace creation failure handling; no explicit child-agent parentage invariant | Dedicated section stating workspace isolation and agent parentage are separate axes; worker created as child agent from orchestrator's agent-scoped surface with returned workspace ID; finish notifications enabled; revisions resume same child |
| `template-bundle/contracts/001-working-rules-template.md` | General capacity and dispatch wording | Explicit clause: workspace placement and agent parentage are separate axes; scoped cross-workspace child creation; detached roots/schedules/CLI rejected; revisions resume same child; manual fallback intact |
| `bundle-docs/operators/operator-quick-start.md` | "orchestrator commits and pushes... gives absolute path" | Explains Paseo cross-workspace child sequence, detached-root rejection, enabled notifications, same-child revision resumption, and manual fallback |
| `skills/northstar/references/modes/orchestrator.md` | "place it in that workspace, leave finish notification enabled" | "place it in that workspace using the returned workspace ID... Workspace placement does not detach parentage: this must be the current orchestrator's agent-scoped `create_agent` call so Paseo delivers finish, error, and permission notifications to the parent. A top-level/root-agent launch, schedule, generic detached run, or CLI path without explicit parent attachment is rejected as non-equivalent; reject launch configuration if finish notifications are disabled" |
| `skills/northstar/SKILL.md` | Generic orchestrator summary | Adds: "Paseo worker parentage preserved across dedicated worktree workspace placement (scoped cross-workspace child creation, finish notifications enabled, no detached root launches, same-agent revision resume)" |
| `bundle-docs/protocol-kernel.md` | No explicit entry for worker parentage | Added `Paseo worker parentage and cross-workspace child dispatch` pointing to doctrine 07 and working rules |
| `docs/architecture/system-architecture.md` | Generic control-plane tool injection invariant | Invariant updated to bind dedicated worktree workspace creation to agent-scoped child creation with returned workspace ID, rejecting detached roots/schedules/unproven CLI |

### Six-row review oracle proof

| Row | Invariant | Adversarial counterexample | Expected response | Proof in `check:worker-parentage` |
| --- | --- | --- | --- | --- |
| 1 | Isolation and parentage coexist | A worker needs a new worktree workspace | Create the workspace first, then create a child from the orchestrator scope with its ID | `require_row("isolation and parentage coexist", ...)` across 8 surfaces |
| 2 | Workspace placement does not detach | The child is placed in a workspace different from the parent | Preserve the orchestrator-child relationship and notification route | `require_row("workspace placement does not detach", ...)` across 8 surfaces |
| 3 | Detached roots are invalid workers | An orchestrator uses a top-level CLI/root launch because it can create the same worktree | Reject it as non-equivalent; use scoped creation or manual handoff | `require_row("detached roots are invalid workers", ...)` across 7 surfaces + `forbid` negative scan |
| 4 | Notifications are structural | The worker is created with finish notification disabled | Reject launch configuration before creation | `require_row("notifications are structural", ...)` across 7 surfaces + `forbid` negative scan |
| 5 | Revisions retain identity | Review requests changes after the child finishes | Resume the same child agent; do not create a detached replacement | `require_row("revisions retain identity", ...)` across 7 surfaces |
| 6 | Provider neutrality survives | Scoped Paseo tools are absent | Return the absolute handoff for manual launch without pretending parentage exists | `require_row("provider neutrality survives", ...)` across 7 surfaces |

### Live launch record

- Worktree workspace created first: `wks_0ac25c3a34f16567` at `/Users/tom/.paseo/worktrees/37pj4ag8/preserve-paseo-worker-parentage`
- Child agent created from orchestrator scope in that workspace: `3b92a429-64ec-4d31-a85b-bd97fd5b49d2` with `notifyOnFinish: true`
- Status snapshot records orchestrator parentage: label `paseo.parent-agent-id=ea5b027e-e772-4209-861a-25aa8d12ca29` (the current orchestrator)

### Validation

- `effigy check:worker-parentage` — PASS (six milestone 049 oracle rows verified across 9 surfaces with negative scans)
- `effigy check:command-skills` — PASS (9 adapters, aggregate descriptions=460 chars)
- `effigy check:skill-install skills/northstar` — PASS (199 files verified)
- `effigy qa:docs` — PASS (repo-contract machine contracts, repo-contract checks & 11 fixture tests, readiness-map checks & 5 fixture tests, command-skills, model-routing, worker-parentage, language-packages machine contracts)
- `effigy qa` — PASS (full validation suite + docs QA)
- `git diff --check` — clean (no whitespace or format errors)

## Stop Conditions

- None encountered. All acceptance criteria and review oracle rows passed.

## Next Task

Stop for exact-head orchestrator review. After reviewed merge and
installed-skill refresh, resume card 120's root-reduction lane.
