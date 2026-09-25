# g04

`g04` makes Northstar lean: repositories hold knowledge and code, the
orchestrator holds task state, and project knowledge stays current as
repositories grow.

Design: [`../../specs/042-lean-northstar.md`](../../specs/042-lean-northstar.md),
which absorbs [`../../specs/041-project-knowledge-currentness.md`](../../specs/041-project-knowledge-currentness.md).
Tom opened `g04` on 2026-09-25. Later that day he asked for a step back, so the
retired-concept check no longer goes first on its own. It becomes one of spec
042's knowledge mechanisms.

## Generation Runway

| Goal | State | Governing refs | Next task |
| --- | --- | --- | --- |
| Lean Northstar: task state leaves repositories, Queue gains a no-write closeout, and the skill and doctrine shrink. | design draft awaiting operator approval | spec 042 | approve spec 042, then agree the Queue work with the Queue Chatterbox |
| Retirements name the terms, paths and config keys they retire, and a check fails on live references outside history. | approved mechanism; sequenced inside spec 042 | spec 041 mechanism 1 | follows the spec 042 approval |
| Open questions are addressable items that an answer closes by pointing at the owning surface. | discovery | spec 041 mechanism 2 | follows `g04.001` evidence |
| Operator rulings reach their owning surface before a Chatterbox turn yields. | discovery; ownership recommendation is Northstar, awaiting operator confirmation | spec 041 mechanism 3 | follows the ownership ruling |
| Front-door frontier and state prose is generated, not hand-written. | discovery | spec 041 mechanism 4; lifecycle reference | follows `g04.001` |
| A knowledge manifest with typed links and suspect-link detection. | discovery; may belong to Nucleus | spec 041 mechanism 5; Nucleus triage note | after the cheaper mechanisms prove out |
| Keep unresolved operator feedback visible without pinning old generations open. | watch | contract 001 | bounded watchlist below |

Task mechanical state — status, stage, revision, delivery digests — is the
generated lifecycle block at the end of this file, refreshed by the closeout
hook at publication. Runway rows above stay coarse goal-sequencing intent and
are not a per-task status mirror.

## Current lane

No lane is dispatched. The next move is operator approval of spec 042.

## Bounded watchlist

- Discovery starter surfaces from `g02.026/078` remain deferred; revisit only
  through fresh planning if operator evidence makes them relevant.
- Atlas, triage/cleanup, and language-package feedback remain operator-provided
  evidence only. They are not ready Northstar execution lanes.

The economical-coordinator observation carried from `g02` closed at its
2026-09-18 deadline without a recorded reconciliation. It is not carried
forward; it can be reopened from fresh operator evidence.

## Task files

None yet.
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v2 digest=sha256:7b5d17b0bceb075bdacb18273d08eb1ce6c375375e4838c5adebf975b3b24495 -->
| Generation | Disposition | Runway state |
| --- | --- | --- |
| g04 | open | planning_required |
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
<!-- northstar:lifecycle:end -->
