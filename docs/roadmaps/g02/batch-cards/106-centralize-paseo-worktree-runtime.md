# 106 - Centralize Paseo Worktree Runtime

Status: in-progress
Owner: repo maintainers
Updated: 2026-08-31
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`, `g02.038`
Auto-start next card: no

## Objective

Make the installed Northstar skill the single owner of Paseo worktree lifecycle
code, close the requested-changes wake-up gap, and prove the consumer boundary
in Figmatic.

## Scope

- move `paseo-worktree.rhai` from copy-ready assets to the skill runtime;
- export `paseo:worktree` from the skill's Effigy catalog;
- replace consumer-local task registration with explicit `effigy skill run`;
- configure Figmatic with `../longhorn`, `../poodle`, and `effigy setup`;
- require pre-setup container-directory links and explicit review follow-up;
- replace per-PR operator merge approval with an exact-head accepted-review and
  passing-checks orchestrator gate;
- sync and validate the installed skill.

## Ready-State Checks

- [x] The operator selected skill-owned execution as the portability boundary.
- [x] Effigy's external skill task contract defines source and target semantics.
- [x] Figmatic's real setup task and sibling topology are known.
- [ ] The active Effigy binary implements `skill tasks` and `skill run`.

## Acceptance Criteria

- Northstar owns one helper under `skills/northstar/scripts/`;
- the skill manifest exports `paseo:worktree` without removing existing tasks;
- consumer settings use a configurable skill path and keep the consumer as the
  runtime target;
- Figmatic contains no copied helper and no local lifecycle task;
- sibling sources are explicit and links are present in the worktree container
  before setup;
- a changes-requested Paseo review prompts the originating worker after comments
  are posted;
- an orchestrator merges its worker PR without another operator prompt only
  after accepting the exact current head and confirming required checks and
  mergeability;
- workers and standalone direct-review threads still cannot merge;
- source/install parity and validation pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Runtime code has one owner. | A consumer still copies the Rhai file or registers a local task. | Review blocks the settings change. | Northstar/Figmatic file and task inventory. |
| Source and target stay distinct. | The task runs relative to the installed skill rather than Figmatic. | Effigy contract test or lifecycle self-test fails. | `skill run` JSON/text evidence and created-link target. |
| Siblings exist before setup. | Figmatic setup starts without Longhorn or Poodle in the container directory. | Lifecycle prepare stops before setup. | Managed-worktree proof and canonical symlink checks. |
| PR review resumes the same lane. | Comments are posted but no worker prompt is sent. | Orchestrator remains incomplete. | Mode/spec/contract inspection and live adapter proof when available. |
| Merge follows accepted evidence without operator churn. | The PR head changes after review, a check is pending/failing, or a standalone reviewer tries to merge. | Re-review or stop; no merge. | Mode/spec/contract/template inspection. |

## Evidence Required

- JSON validation for both project settings files;
- `effigy skill tasks` and `effigy skill run ... self-test` against the installed
  Northstar skill;
- Figmatic managed-worktree setup proof or an explicit external-feature blocker;
- `git diff --check` in both repos;
- skill validator and source/install parity;
- `effigy qa:docs` and relevant full QA.

## Stop Conditions

- Effigy's final CLI or source/target contract differs from the active draft;
- the project requires a machine-specific tracked absolute skill path;
- validation exposes a lifecycle ordering or destructive-link flaw;
- completing the proof would require overwriting unrelated work.

## Current state

Northstar and Figmatic are rewritten to the draft `effigy skill run` contract.
The active Effigy binary still rejects `skill` as an unknown selector, so runtime
proof and installed-skill sync remain pending.

## Next task

Rebuild or install Effigy after its external skill task runner lands, then run
the isolated skill self-test and Figmatic lifecycle proof.
