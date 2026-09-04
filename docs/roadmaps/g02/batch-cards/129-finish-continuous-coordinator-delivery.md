# 129 - Finish Continuous Coordinator Delivery

Status: ready
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Master roadmap: `g02.054`
Governing refs:
`docs/roadmaps/g02/054-finish-continuous-coordinator-delivery.md`,
`docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`,
`docs/contracts/001-working-rules.md`
Auto-start next card: yes — card 126 passive observation after merge and parity

## Objective

Remove operator babysitting from the mechanical coordinator loop. An activated
turn runs every ready local transition, yields only when progress needs a child,
external event, new authority, or an empty runway, and never asks for `continue`
while canonical work is actionable.

## Approved dispatch manifest

- **Lane:** `g02.054/129`
- **State:** ready for direct implementation-worker dispatch
- **Promoted base:** the `main` commit containing the spec-037 continuity and
  cross-model corrections, roadmap 054, this card, and card 126's observation
  packet
- **Prerequisites:** card 128 and its installed-skill refresh complete
- **Approved concurrent siblings:** none for the named mutable surfaces
- **Serial edges:** card 126 starts passively after card 129 merge and installed
  parity; no other semantic edge
- **Worker class:** fast, economical general/day-to-day implementation agent;
  exclude audit, documentation-grind, review, planning, and coordinator profiles
- **Reviewer class:** qualified independent reviewer whose underlying
  provider/model identity differs from the worker; profile or reasoning-level
  differences alone do not qualify
- **Escalation owner:** Chatterbox for missing semantics, sequencing, or
  acceptance; operator only for destructive/material permission choices

Allowed mutable surfaces:

- `bundle-docs/sections/07-delivery-framework-and-autonomy.md`;
- `bundle-docs/operators/operator-quick-start.md`;
- `template-bundle/contracts/001-working-rules-template.md`;
- `skills/northstar/SKILL.md` only if its route summary carries the lifecycle;
- `skills/northstar/references/router.md`;
- `skills/northstar/references/modes/chatterbox.md`;
- `skills/northstar/references/modes/orchestrator.md`;
- `skills/northstar/references/modes/pr-review.md`;
- direct orchestrator/review templates under `skills/northstar/assets/templates/`;
- existing command-skill, model-routing, repo-contract, or focused lifecycle
  fixtures under `scripts/` and their direct callers;
- installed Northstar skill destination selected by the existing parity task;
- this card, roadmap 054, card 126, their implementation/observation logs, and
  current roadmap/front-door indexes for closeout only.

Another direct caller may be added only when exact-token search proves it must
change for deterministic semantic parity. Otherwise stop and return to
Chatterbox.

## Required implementation

1. Make merge, post-merge reconciliation, closeout, frontier recomputation, and
   next-ready dispatch one continuous coordinator action chain.
2. Yield promptly after launching/resuming a child or when another external
   result/new authority is required. Keep `notifyOnFinish: true`; never poll or
   hold the turn open.
3. Do not notify Chatterbox for child-wait yields. Send one administrative
   notice only when the canonical runway is empty. Route genuine blockers to
   their named escalation owner.
4. Carry the worker's provider/model identity into review dispatch. Reject the
   same provider/model even behind another profile, reasoning level, or thread.
5. Preserve same-workspace serial clean exact-head review leases and use the
   same distinct reviewer for revision rounds when available.
6. After a connector write refusal, use an already-authenticated repository-
   approved native write transport when available and the verified gate remains
   current. Never weaken the gate, solicit credentials, or improvise transport.
7. Refresh installed parity and update the focused structural fixtures.

## Acceptance evidence

- a lifecycle fixture runs child completion -> review -> merge -> closeout ->
  next-ready dispatch without an operator `continue`;
- waiting-child fixture yields with notifications enabled and sends no
  Chatterbox message;
- empty-runway fixture sends exactly one Chatterbox administrative notice;
- positive review fixture uses a qualified different provider/model;
- negative fixtures reject profile-renamed and effort-changed copies of the
  worker model;
- write-refusal fixture uses an available authenticated native fallback only
  after the unchanged merge gate;
- existing exact-head, lease, contextual-escalation, and full-frontier fixtures
  remain green;
- `git diff --check`, focused checks, `effigy qa:docs`, `effigy qa`, source/install
  parity, reviewable PR, and accepted exact-head review pass.

## Stop conditions

- implementation needs a new authority or dependency choice;
- continuation would cross into an unplanned lane;
- review-model identity cannot be observed reliably;
- fallback would bypass a gate or require new credentials;
- validation changes the plan.

## Next task

Dispatch this card immediately. After merge and parity, begin card 126's passive
cohort and continue any other canonical ready work without operator prompting.
