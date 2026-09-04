# 054 - Finish Continuous Coordinator Delivery

Status: ready; card 129 is the sole implementation lane
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Depends on: `g02.053`, spec 037
Vision tags: `coordination`, `autonomy`, `review`, `chatterbox`, `paseo`
Governing refs:
`docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`,
`docs/contracts/001-working-rules.md`

## Problem

The corrected coordinator still treated merge and closeout as turn-completion
boundaries, forcing repeated operator `continue` prompts. Its review routing did
not explicitly prevent the authoring model from reviewing its own PR, and its
first connector write refusal consumed an avoidable stop/fallback branch.

## Goals

- continue through every immediately actionable mechanical transition;
- yield without polling while children or external results are outstanding;
- notify Chatterbox only when the canonical runway is empty;
- require a reviewer model distinct from the authoring worker model;
- use an available authenticated repository-native write path as the bounded
  fallback after an otherwise-valid connector write refusal;
- start the corrected ten-lane observation as passive evidence, not blocking
  work.

## Non-goals

- no coordinator planning, lane design, or semantic review;
- no open-turn waiting or polling;
- no Chatterbox notification for ordinary child waits;
- no provider-specific reusable policy or credential management;
- no synthetic PRs for the observation cohort.

## Execution plan

- [ ] **Card 129** updates reusable doctrine, modes, templates, checks, installed
      parity, and closeout in one implementation lane.
- [ ] **Card 126** then observes the next ten natural coordinated PR lanes or
      stops at the published time boundary, whichever comes first.

## Review oracle

Use spec 037's coordinator-advance, empty-runway, cross-model, exact-head, and
transport-fallback invariants. Review card 129 with a qualified model whose
provider/model identity differs from its worker.

## Next task

Dispatch card 129 directly. After accepted review and merge, begin card 126's
passive cohort without blocking normal project work.
