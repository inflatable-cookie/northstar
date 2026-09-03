# Preserve Paseo Worker Parentage

Date: 2026-09-03
Roadmap: `g02.049`
Card: `g02.049/123`
Status: complete; awaiting orchestrator review

## Result

Paseo worker dispatch now explicitly preserves both dedicated worktree workspace
isolation and child-agent parentage to the current orchestrator.

The orchestrator first creates the lane's dedicated `branch-off` worktree
workspace, then uses its own agent-scoped `create_agent` surface with that
returned workspace ID and finish notifications enabled (`notifyOnFinish: true`).
Passing the workspace ID changes placement without detaching ownership, allowing
Paseo to deliver completion, error, and permission notifications back to the
parent orchestrator. Detached root launches, schedules, generic detached runs,
and unproven CLI substitutes are rejected for worker dispatch. Review revisions
resume the same originating child agent identity. When scoped tools are absent,
manual launch with the absolute handoff path remains the provider-neutral
fallback without pretending parentage exists.

## Changed Surfaces

| Surface | Before | After |
| --- | --- | --- |
| `docs/contracts/001-working-rules.md` | "created in one isolated workspace for the lane"; "launches a worker with the single absolute handoff path" | Ordered sequence: dedicated worktree workspace first, then worker created as child agent from orchestrator's scoped surface with returned workspace ID and finish notifications enabled; rejects detached roots/schedules/generic detached/CLI; revisions resume same child |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | Workspace creation failure handling without explicit child parentage rule | Dedicated section on separate workspace isolation and agent parentage axes; scoped child creation; enabled notifications; same-child revision resumption; manual fallback |
| `template-bundle/contracts/001-working-rules-template.md` | General capacity and dispatch wording | Explicit clause: workspace placement and agent parentage are separate axes; scoped cross-workspace child creation; detached roots/schedules/CLI rejected; revisions resume same child; manual fallback |
| `bundle-docs/operators/operator-quick-start.md` | "orchestrator commits and pushes... gives absolute path" | Explains Paseo cross-workspace child sequence, detached-root rejection, enabled notifications, same-child revision resumption, and manual fallback |
| `skills/northstar/references/modes/orchestrator.md` | "place it in that workspace, leave finish notification enabled" | "place it in that workspace using the returned workspace ID... Workspace placement does not detach parentage: this must be the current orchestrator's agent-scoped `create_agent` call so Paseo delivers finish, error, and permission notifications to the parent. A top-level/root-agent launch, schedule, generic detached run, or CLI path without explicit parent attachment is rejected as non-equivalent; reject launch configuration if finish notifications are disabled" |
| `skills/northstar/SKILL.md` | Generic orchestrator summary | Adds: "Paseo worker parentage preserved across dedicated worktree workspace placement (scoped cross-workspace child creation, finish notifications enabled, no detached root launches, same-agent revision resume)" |
| `bundle-docs/protocol-kernel.md` | No explicit entry for worker parentage | Added `Paseo worker parentage and cross-workspace child dispatch` pointing to doctrine 07 and working rules |
| `docs/architecture/system-architecture.md` | Generic control-plane tool injection invariant | Invariant updated to bind dedicated worktree workspace creation to agent-scoped child creation with returned workspace ID, rejecting detached roots/schedules/unproven CLI |
| `scripts/check-northstar-worker-parentage.rhai` | Did not exist | New focused checker: positive assertions for all six oracle rows across 9 surfaces plus negative scans |
| `effigy.toml`, `scripts/lib/northstar-repo-contract-data.rhai`, `scripts/test-northstar-repo-contract.rhai` | `qa:docs` without worker-parentage assertions | `check:worker-parentage` task wired into `qa:docs`; machine-contract pin and fixture tests updated |
| `scripts/README.md` | Unlisted | Documented `check:worker-parentage` task |

## Six Oracle Rows Falsified

| Milestone 049 oracle row | Adversarial scenario | Result | Proof in `check:worker-parentage` |
| --- | --- | --- | --- |
| 1. Isolation and parentage coexist | A worker needs a new worktree workspace | Create the workspace first, then create a child from the orchestrator scope with its ID | `require_row("isolation and parentage coexist", ...)` across 8 surfaces |
| 2. Workspace placement does not detach | The child is placed in a workspace different from the parent | Preserve the orchestrator-child relationship and notification route | `require_row("workspace placement does not detach", ...)` across 8 surfaces |
| 3. Detached roots are invalid workers | An orchestrator uses a top-level CLI/root launch because it can create the same worktree | Reject it as non-equivalent; use scoped creation or manual handoff | `require_row("detached roots are invalid workers", ...)` across 7 surfaces + `forbid` negative scan |
| 4. Notifications are structural | The worker is created with finish notification disabled | Reject launch configuration before creation | `require_row("notifications are structural", ...)` across 7 surfaces + `forbid` negative scan |
| 5. Revisions retain identity | Review requests changes after the child finishes | Resume the same child agent; do not create a detached replacement | `require_row("revisions retain identity", ...)` across 7 surfaces |
| 6. Provider neutrality survives | Scoped Paseo tools are absent | Return the absolute handoff for manual launch without pretending parentage exists | `require_row("provider neutrality survives", ...)` across 7 surfaces |

## Live Launch Record

- Worktree workspace created first: `wks_0ac25c3a34f16567` at `/Users/tom/.paseo/worktrees/37pj4ag8/preserve-paseo-worker-parentage`
- Child agent created from orchestrator scope in that workspace: `3b92a429-64ec-4d31-a85b-bd97fd5b49d2` with `notifyOnFinish: true`
- Status snapshot records parentage: label `paseo.parent-agent-id=ea5b027e-e772-4209-861a-25aa8d12ca29` (the current orchestrator)

## Validation

- `effigy check:worker-parentage` — PASS (six milestone 049 oracle rows verified across 9 surfaces with negative scans)
- `effigy check:command-skills` — PASS (9 adapters, aggregate descriptions=460 chars)
- `effigy check:skill-install skills/northstar` — PASS (199 files verified)
- `effigy qa:docs` — PASS (repo-contract machine contracts, repo-contract checks & 11 fixture tests, readiness-map checks & 5 fixture tests, command-skills, model-routing, worker-parentage, language-packages machine contracts)
- `effigy qa` — PASS (full validation suite + docs QA)
- `git diff --check` — clean (no whitespace or format errors)

## Next Task

Stop for exact-head orchestrator review. After reviewed merge and
installed-skill refresh, resume card 120's root-reduction lane.
