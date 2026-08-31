# 107 - Delegate Mechanical Orchestrator Documentation

Status: complete
Owner: repo maintainers
Updated: 2026-08-31
Master roadmap: `g02.039`
Governing refs: `docs/contracts/001-working-rules.md`,
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`skills/northstar/references/modes/orchestrator.md`
Auto-start next card: no

## Objective

Provide a bounded, copy-ready brief for a profile-driven low-cost subagent to
project settled Northstar documentation while Sol retains all planning and
semantic authority.

## Scope

- add the documentation projection brief template;
- define the exact input fields, allowed-path boundary, stop conditions, and
  return report;
- define serial meaningful-batch delegation and provider-neutral profiles;
- preserve Sol ownership of discovery, planning, canonical homes, promotion,
  acceptance, review, merge, and final semantic diff review;
- update only the named g02.039 front doors for immediate execution while
  preserving g02.038's Effigy wait state.

## Ready-State Checks

- [x] The Sol/Luna middle ground is settled: Sol decides; a low-cost,
  profile-driven subagent projects exact documentation briefs.
- [x] Delegated work is documentation-only and does not require worker mode.
- [x] The template, roadmap, card, and front-door projections pass docs checks.
- [x] Sol has reviewed the complete resulting diff semantically.

## Acceptance Criteria

- the template names authority owner, settled decisions, canonical refs,
  allowed paths, exact state/evidence, required transitions, forbidden
  judgments, validation, stop conditions, and return report;
- the template forbids commit, push, reset, production edits, and protocol or
  readiness judgments;
- roadmap and card state remain active/in-progress until Sol's review and
  validation are complete;
- g02.038 text remains intact while g02.039/card107 become the immediate lane;
- no final log is created by this card.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| No semantic leakage. | Projection invents or changes intent, acceptance, stop, or review rules. | Stop and report; Sol resolves it. | Full diff against exact brief. |
| Dirty state is preserved. | Unrelated dirty file is changed or overwritten. | Stop before mutation. | Dirty-state/path comparison. |
| Dispatch is worthwhile. | A small edit costs more to dispatch and review than it saves. | Keep the edit in Sol. | Batch and timing evidence. |
| Sol reviews. | Projection is treated as accepted without semantic review. | Card stays incomplete. | Sol review record. |

## Evidence Required

- deterministic template/docs validation;
- changed-file report and unresolved-question report;
- proof that only allowed paths changed;
- Sol semantic review before any commit or push.

## Stop Conditions

- missing or contradictory brief input;
- unlisted path or production-code request;
- semantic decision required;
- unrelated dirty change at risk;
- no meaningful batch or no Sol review.

## Resolution

The first projection changed exactly six allowed files and passed
`git diff --check`. Sol reviewed the complete diff and corrected the roadmap
dependency to `g02.037` rather than waiting `g02.038`, and required explicit
`Forbidden judgments` and `Stop conditions` fields in the template. Sol then
promoted the policy through the contract, specification, architecture,
doctrine, operator, and skill surfaces and synced the installed skill.

The projection role remains provider-neutral; `gpt-5.6-luna` was only the local
fast/low-cost example. Validation also passed skill creator quick validation,
source/install parity excluding generated `.effigy` and Rust `target`, and full
`effigy qa`. No worker worktree was used.

## Next task

None. The later `g02.038/106` lifecycle proof is complete; return to generation
planning.
