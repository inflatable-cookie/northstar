# g03.002 Complete Consumer Compaction

Status: complete
Owner: repo maintainers
Created: 2026-09-05
Governing refs: contract 001, Consumer compaction maintenance and preservation oracle

## Outcome

Make the shipped maintenance routes compact safely closed generations in an
existing consumer project. Operator reports that several projects retained all
expanded generations after running maintenance. Source inspection confirms
refresh/normalize lack an explicit compaction procedure; cleanup is generic,
and the starter mentions roll-up only at rollover. Installed refresh/normalize
match source. This corrects the incomplete reusable outcome of g03.001; it does
not rewrite its delivery history.

## Completed work

- [x] Deliver one shared preservation-led procedure, route it through
  maintenance and rollover, align reusable doctrine/templates, and prove a
  consumer fixture end to end.
- [x] Close the lane with exact-head review, installed parity, and compact
  outcome/evidence.

## Delivery evidence (absorbed from card 133)

Worker delivery was the shared procedure, disposable fixture, recorded
installed-skill replays, and independent before/after assertions. PR #41 merged
after exact-head review.

Installed-skill route: `$HOME/.agents/skills/northstar` via
`references/lifecycle-maintenance.md`. Provider `codex/gpt-5.6-luna`,
`full-access`, `xhigh`. Replay artifacts:
`scripts/tests/consumer-compaction/evidence/`.

| Scenario | Agent | Result |
| --- | --- | --- |
| Happy authorized refresh | `70fbe934-62fa-431f-a183-1db9ecb5c0af` | Removed expanded `g01`/`g02`; wrote `archive/g01.md` and `archive/g02.md`; preserved `g03` and `ACTIVE-GEN-ONLY-TOKEN`; promoted `UNIQUE-RULE-WIDGET-PREFIX`; rehomed `DEFERRED-COMMITMENT-WIDGET-AUDIT`; retained PR 101/`c0ffee101` and PR 202/`c0ffee202`; rewrote stale `g01/`/`g02/` front-door links |
| Read-only cleanup | `0ea21e44-e63a-4927-93f6-2a8698d693d9` | Proposal only; byte-identical tree |
| Unresolved ownership | `b3ac3ec8-d1a8-4df7-a8a3-c72c5dd94989` | `g01` and `UNIQUE-ORPHAN-RULE` left on the source card; no `archive/g01.md`; `g02` compacted as safely closed |
| Active/closed conflict | `2767c19d-82ae-494a-b358-24f432ce46c3` | Stopped; no mutations; `CONFLICT-ACTIVE-CLOSED` retained |
| Repeat refresh | `3b9de735-b7c0-40d2-9f43-5a700eb524e1` | No docs content churn; no re-expansion |

Validation on that checkout: `git diff --check`, `effigy check:consumer-compaction`
(123/0), `effigy qa:docs`, `effigy qa`, and
`effigy check:skill-install $HOME/.agents/skills/northstar` (112 files) all passed.

Limits: live consumers were not migrated. Repeat input was the recorded happy
after-tree, not a second live consumer.

Closeout: PR [#41](https://github.com/inflatable-cookie/northstar/pull/41),
reviewed exact head `3fcb7e009adc89943c6e695d317092700c7fecee`, merge commit
`ec84170dd8e28d2ced8880f04e3b2832c3fb70fb`, independent review
[canonical verdict](https://github.com/inflatable-cookie/northstar/pull/41#issuecomment-5552845973).
Main was synchronized with `origin/main` at the merge commit. No live consumer
writes, reserved front-door edits, workflow changes, or release mutations were
included in the implementation PR. Pre-flattening provenance: batch card 133
carried this delivery; its file was consumed by `g03.003` after this
absorption. The card number is provenance only and grants no execution
authority.

## Boundary and checkpoint

One lane, no concurrent siblings. No live consumer migration was authorized.
Soundcheck consumer compaction passed after delivery. Mode consolidation and
unrelated simplification remain planned, not implicitly executable.

## Next task

`g03.003` absorbed this task's delivery evidence and is complete. Return to the
active generation runway for the current frontier.
