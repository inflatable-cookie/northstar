# 128 - Implement Chatterbox-Led Planning

Status: complete in review
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Master roadmap: `g02.053`
Governing refs:
`docs/roadmaps/g02/053-chatterbox-led-planning-and-mechanical-coordination.md`,
`docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`,
`docs/contracts/001-working-rules.md`
Auto-start next card: no

## Objective

Implement the spec-037 topology in one delivery lane: Chatterbox promotes
canonical planning and designs the approved frontier; triage-only delegates feed
Chatterbox; the coordinator dispatches actual workers and review children
mechanically, asks contextual questions, reports, and yields.

## Scope

- reusable doctrine and operator quick start;
- copy-ready contracts and triage guidance;
- root Northstar skill, router, Chatterbox, orchestrator, PR-review, and planning-
  delegate routes;
- planning-delegate and worker/projection templates;
- command-skill, repo-contract, model-routing, and Chatterbox Git fixtures;
- card-126 dogfood measures and current front doors;
- source/install parity and obsolete-surface removal.

The worker must use exact-token search for `planning-delegate`, promotion worker,
decision-ready packet, dedicated PR-head review workspace, coordinator frontier
design, `send_agent_prompt`, polling/waiting, and operator-question wording. It
updates all semantic callers together rather than leaving compatibility aliases.

## Approved dispatch manifest

- **Lane:** `g02.053/128`
- **State:** ready for direct implementation-worker dispatch
- **Promoted base:** the `main` commit containing spec 037, roadmap 053, this
  card, the current architecture/contract updates, and removed resolved intake
- **Prerequisites:** cards 124, 125, and 127 complete; operator-confirmed
  corrections promoted; failed promotion worker/coordinator stopped; obsolete
  promotion workspace archived
- **Approved concurrent siblings:** none in this repository for this mutable
  surface set
- **Serial edges:** card 126 follows card 128 merge and installed-skill refresh;
  no other semantic serial edge
- **Worker class:** fast, economical general or day-to-day implementation agent
  capable of broad documentation/skill/checker refactoring; its live profile
  description must explicitly fit implementation or general worker work;
  exclude audit, documentation-grind, review, planning, and coordinator
  profiles; frontier reasoning is not required because spec 037 and this card
  settle the semantics
- **Escalation owner:** Chatterbox for missing role, sequencing, authority,
  acceptance, or parallelism decisions; operator for destructive or material
  permission choices
- **Closeout owner:** worker owns card/roadmap/log and implementation front-door
  updates; coordinator owns the merge gate; Chatterbox owns any post-review
  planning change

Allowed mutable surfaces:

- `bundle-docs/sections/07-delivery-framework-and-autonomy.md`;
- `bundle-docs/operators/operator-quick-start.md`;
- `bundle-docs/glossary.md`;
- `template-bundle/contracts/001-working-rules-template.md`;
- `template-bundle/contracts/002-agent-local-paths-template.md` only where the
  removed delegate-worktree contract requires it;
- `template-bundle/triage/README.md`;
- `skills/northstar/SKILL.md`;
- `skills/northstar/references/router.md`;
- `skills/northstar/references/handoff-contract.md`;
- `skills/northstar/references/modes/chatterbox.md`;
- `skills/northstar/references/modes/orchestrator.md`;
- `skills/northstar/references/modes/pr-review.md`;
- planning-delegate mode/adapter paths under `skills/northstar/commands/` and
  `skills/northstar/references/modes/` required by the routed design;
- obsolete or replacement templates under `skills/northstar/assets/templates/`;
- `scripts/check-northstar-command-skills.rhai`;
- existing Chatterbox Git, repo-contract, and model-routing fixtures under
  `scripts/tests/` and their direct callers;
- `docs/roadmaps/g02/053-chatterbox-led-planning-and-mechanical-coordination.md`;
- `docs/roadmaps/g02/batch-cards/128-implement-chatterbox-led-planning.md`;
- `docs/roadmaps/g02/batch-cards/126-dogfood-economical-orchestrator-coordination.md`;
- implementation closeout log and implementation-owned `docs/README.md`,
  `docs/roadmaps/g02/README.md`, `docs/roadmaps/g02/batch-cards/README.md`, and
  `docs/roadmaps/generation-index.md` status updates;
- installed Northstar skill destination selected by the existing install/parity
  task, with no unrelated installed-skill edits.

If exact-token search finds another direct caller whose removal is required to
make these named surfaces pass, the worker may add it only for a deterministic
parity/reference repair with no new semantics. A semantic caller or overlapping
owner returns to Chatterbox.

## Out of scope

- implementing product/Paseo APIs;
- changing implementation-worker workspace isolation;
- weakening provider verdict, exact-head review, checks, mergeability, or pause
  gates;
- completing the ten-PR card-126 cohort;
- unrelated Northstar cleanup.

## Ready-state checks

- [x] operator confirmed spec 037's role split and direct Chatterbox promotion;
- [x] the failed promotion worker and coordinator loop are stopped;
- [x] the obsolete promotion workspace is archived;
- [x] canonical architecture, contract, spec, roadmap, card, and front-door
      promotion is committed on `main` before dispatch;
- [x] no other active lane owns the named role/transport surfaces.

## Required implementation

1. Make Chatterbox the primary planning/promotion mode and triage owner.
2. Rebuild planning delegate as a same-workspace, unique-triage-only conversation
   with direct notice to Chatterbox and no planning PR.
3. Remove coordinator promotion workers, semantic packet compilation, lane-graph
   design, and discretionary parallel-frontier selection.
4. Consume canonical dispatch manifests mechanically and launch the complete
   approved frontier.
5. Add typed Chatterbox-to-coordinator direction with confirmed/recommended/
   administrative provenance.
6. Add the narrow authority-load/dispatch fast path and mandatory post-dispatch
   yield; forbid polling and wait calls.
7. Place visible parent-attached review children in the existing worker
   workspace with a serial clean exact-head lease.
8. Require child-produced context-complete operator escalation capsules.
9. Remove obsolete templates/routes/assertions and update card-126 observations.
10. Refresh the installed skill and prove byte/source parity.

## Acceptance criteria

- [x] no runtime/doctrine path dispatches a promotion-only worker from triage;
- [x] Chatterbox directly promotes confirmed canonical planning and can notify
      one unambiguous coordinator without dispatch/review/merge authority;
- [x] delegates write only unique triage files and cannot contact coordinators;
- [x] two approved independent lanes launch together and an unapproved lane
      cannot be added by Luna;
- [x] factual collision pauses only its lane and returns to Chatterbox;
- [x] coordinator dispatch trace contains no poll/wait and ends after reporting;
- [x] reviewer is a visible coordinator child in the worker workspace, no new
      review workspace appears, and lease boundaries are clean/exact-head;
- [x] opaque blocker output is rejected; the operator message is answerable
      without opening supporting artifacts;
- [x] old planning-delegate worktree/PR and promotion-projection surfaces are
      removed together;
- [x] source/install parity, docs QA, full QA, and exact-head review pass.

## Evidence required

- exact removed/replaced-token inventory;
- structural fixtures for role routing, direction provenance, full-frontier
  launch, yield, review placement, and escalation capsules;
- negative fixtures for raw-triage dispatch, semantic coordinator choice,
  duplicate direction, concurrent workspace lease, wrong head, and opaque
  operator question;
- `git diff --check`;
- `effigy check:chatterbox-git`;
- `effigy check:command-skills`;
- `effigy check:repo-contract`;
- `effigy check:model-routing`;
- isolated `effigy check:skill-install skills/northstar`;
- `effigy qa:docs` and `effigy qa`;
- reviewable PR and accepted verdict naming the exact tested head.

## Stop conditions

- implementation needs a new semantic role or authority decision;
- removal breaks a caller not covered by spec 037;
- direct messaging cannot preserve provenance or unambiguous identity;
- reviewer placement cannot preserve parentage, notification, and serial lease;
- validation changes the plan.

## Next task

Review and merge card 128, refresh installed skill, and begin the revised
card-126 observation window.
