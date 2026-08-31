# 108 - Delegate Conversational Feature Planning

Status: complete
Owner: repo maintainers
Updated: 2026-08-31
Master roadmap: `g02.040`
Governing refs: `docs/contracts/001-working-rules.md`,
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`skills/northstar/references/modes/orchestrator.md`
Auto-start next card: no

## Objective

Add the bounded planning-delegate lane so an operator-facing feature-planning
conversation can run in isolation while the orchestrator retains promotion and
implementation authority.

## Scope

- define the planning-delegate protocol and metadata;
- add and mirror the handoff template and source/install skill guidance;
- document the triage/research-only write boundary and bounded read-only
  research subagents;
- document exact-head review, same-delegate follow-up, check-gated merge, and
  post-merge promotion;
- update roadmap, card, front-door, and validation surfaces.

## Ready-State Checks

- [x] Authority split and promotion lifecycle are settled by the orchestrator.
- [x] Planning delegates use committed handoffs and isolated worktrees.
- [x] Research subagents are bounded, read-only, and non-contacting.
- [x] Source/install parity and full validation pass.
- [x] Sol reviews the complete resulting diff.

## Acceptance Criteria

- [x] all named source/install surfaces carry the same planning-delegate
  metadata and boundaries;
- [x] only named triage/research paths are writable by the delegate;
- [x] no delegate or research subagent can promote, implement, review, merge, or
  start nested orchestration;
- [x] merge remains intake and promotion remains a separate orchestrator batch;
- [x] Sol review, QA, and parity evidence are recorded before closeout.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| No authority leakage. | Delegate chooses canonical destination or readiness. | Review blocks. | Full diff against settled refs. |
| Bounded writes. | Delegate edits outside named triage/research paths. | Stop before PR. | Path inventory. |
| Research stays read-only. | Research helper edits or starts nested work. | Stop and report. | Handoff/mode inspection. |
| Promotion follows merge. | Merged packet is treated as promoted automatically. | Promotion remains separate. | Contract and orchestrator inspection. |

## Current state

The lane is complete. Sol's semantic review caught and corrected sibling-link
handling, the distinction between planning-delegate and implementation-worker
preflight, and the rule that operator confirmations in the packet—not private
thread history—are repository authority. Contract 002 now covers manual
delegated worktrees. No live planning-delegate, Paseo, or PR dogfood was
performed.

## Evidence Required

- `git diff --check` for named repository paths;
- `effigy check:repo-contract`;
- exact source/install diff for all six mirrored skill paths;
- full QA and Sol semantic review before completion.

## Stop Conditions

- missing or contradictory settled input;
- unlisted path or production-code mutation;
- any new authority or model-policy decision;
- failed validation requiring interpretation;
- Sol review or parity is incomplete.

## Resolution

The canonical policy, template, source/install skill, doctrine, architecture,
contracts, operator, and validation surfaces are aligned. `git diff --check`,
skill creator quick validation, exact source/install parity (excluding generated
`.effigy` and Rust `target`), and full `effigy qa` pass.

## Next task

None. The later `g02.038/106` lifecycle proof is complete; return to generation
planning.
