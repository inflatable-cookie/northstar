# 039 - Delegate Mechanical Orchestrator Documentation

Status: complete
Owner: repo maintainers
Created: 2026-08-31
Depends on: `g02.037`, `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Vision tags: `orchestration`, `documentation`, `cost-control`, `paseo`
Governing refs: `docs/contracts/001-working-rules.md`,
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`skills/northstar/references/modes/orchestrator.md`
Planning state: card 107 complete

## Problem

Sol should retain planning, authority, review, and merge judgment, but routine
Northstar document projection can consume disproportionate expensive-model
usage. A profile-driven low-cost subagent can apply an exact brief to a bounded
set of named documentation surfaces after Sol has settled the meaning.

## Goals

- [x] define a copy-ready projection brief with explicit authority, scope,
  evidence, validation, and stop boundaries;
- [x] allow a serial profile-driven documentation projection subagent to update
  named Northstar surfaces without becoming a Northstar or Paseo dependency;
- [x] keep Sol responsible for discovery, planning, canonical-home selection,
  promotion, acceptance, review, merge, and full-diff semantic inspection;
- [x] record enough evidence to judge dispatch overhead against avoided Sol
  document churn.

## Non-goals

- no delegation of planning, architecture, contract, canonical-home, readiness,
  completion, review-oracle, PR-review, or merge decisions;
- no hard-coded Luna or Paseo dependency;
- no worker worktree or worker-mode handoff for documentation projection;
- no autonomous continuation, contradiction resolution, or production-code edit.

## Execution plan

Card `g02.039/107` adds the reusable brief and activates one serial projection
lane only for meaningful batches. Sol captures dirty state and allowed paths,
supplies settled wording and facts, reviews the complete diff semantically, and
owns commit/push. Tiny edits remain in Sol.

## Acceptance criteria

- [x] the template requires authority owner, settled decisions, canonical refs,
  allowed paths, exact state/evidence, required transitions, forbidden
  judgments, validation, stop conditions, and a return report;
- [x] the projection role is explicitly profile-driven and provider-neutral;
- [x] the role cannot choose intent, acceptance, readiness, completion, next
  work, review, merge, or resolve contradictions;
- [x] delegation is serial and limited to meaningful documentation batches;
- [x] Sol's full-diff semantic review and commit/push ownership are explicit;
- [x] front doors route the lane without changing the waiting Effigy lifecycle
  work in `g02.038`.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Sol retains meaning authority. | The subagent invents a contract, acceptance rule, canonical home, or next task. | Projection stops and reports the missing or changed choice. | Brief and mode inspection. |
| Projection is mechanical. | The subagent rewrites settled wording, resolves a contradiction, or edits production code. | Review rejects the projection. | Allowed-path diff and semantic comparison against supplied brief. |
| Existing dirty work is preserved. | The subagent overwrites unrelated edits or unlisted files. | Projection stops before destructive overwrite. | Pre/post dirty-state and path inventory. |
| Dispatch pays for itself. | A tiny edit is delegated or repeated dispatch/review costs exceed document churn avoided. | Sol keeps the edit or stops the lane. | Batch-size and overhead evidence. |
| Sol reviews the result. | Files are projected and committed without full-diff semantic inspection by Sol. | Lane remains incomplete. | Review record and uncommitted diff inspection. |

## Evidence Required

- template validation and docs QA;
- one bounded projection report naming changed files and validation;
- proof that unrelated dirty files and unlisted paths were untouched;
- Sol's semantic diff review recorded before commit/push;
- dispatch-overhead and batch-size observation.

## Stop Conditions

- any missing settled choice, contradictory fact, or unlisted required path;
- any request to decide intent, readiness, completion, review, merge, or next
  work;
- any production-code or unrelated-dirty-state mutation;
- dispatch overhead is not justified by the projection batch;
- Sol has not completed the full-diff semantic review.

## Current state

The projection brief and first bounded projection are complete. Sol reviewed the
full diff, corrected the roadmap dependency and made the template's forbidden
judgments and stop conditions explicit, then promoted the policy through the
canonical contract, specification, architecture, doctrine, operator, and skill
surfaces. The installed skill is synced and validation passed. The local fast
profile example was `gpt-5.6-luna`; the role remains provider-neutral.

## Resolution

The first projection changed exactly six allowed files and passed
`git diff --check`. Sol's semantic review caught two details that the
projection must not decide: the roadmap depends on `g02.037`, not the waiting
`g02.038`, and the brief must expose explicit `Forbidden judgments` and `Stop
conditions` fields. This confirms the intended middle ground: Sol owns meaning
and acceptance; a serial profile-driven subagent performs bounded document
projection and deterministic checks.

## Next task

Resume `g02.038/106` after Effigy's external `skill run` task runner lands.
