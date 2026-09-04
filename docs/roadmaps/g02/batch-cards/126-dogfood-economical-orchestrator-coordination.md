# 126 - Dogfood Economical Orchestrator Coordination

Status: active; passive observation started after card 129 merge
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Master roadmap: `g02.051`
Governing refs: `docs/roadmaps/g02/051-economical-orchestrator-coordination.md`,
`docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`
Auto-start next card: no

## Objective

Observe ten representative PR lanes under the economical coordinator split and
decide whether the authority and escalation boundaries hold.

## Scope

- accept normal live lanes rather than creating synthetic project work;
- record the compact measures named by spec 036;
- include ordinary, material, revision, same-repository ordering, and
  provider-refusal cases when they occur naturally;
- record operator-confirmation-to-actual-worker latency, time-to-first-dispatch,
  promotion-only hops, polling/waiting, and open-turn incidents;
- compare every launched frontier with Chatterbox's approved manifest;
- record context-free operator questions and review-workspace/sidebar friction;
- finish with a short assessment and any narrowly justified protocol changes.

Out of scope: changing project work to satisfy the trial, polling workers,
durable token accounting, or encoding local model prices and quotas.

## Ready-state checks

- [x] card 125 merged through PR 32 as `61d4cc2`;
- [x] installed Northstar skill refreshed and tracked-archive parity verified;
- [x] operator updated Paseo with the `Luna coordinator` profile;
- [x] initial live use recorded roughly twenty minutes before actual-worker
      dispatch, one fail-closed promotion child, a pending repeated loop,
      coordinator polling/waiting, an opaque blocker question, and operator
      cancellation of both coordinator and promotion child;
- [x] g02.053/card 128 implements the corrected role topology;
- [x] observation packet and stop date are published;
- [x] g02.054/card 129 merged through PR 35 and installed parity verified.

## Observation packet

- **Cohort:** the first ten naturally occurring PR lanes coordinated under the
  installed post-card-129 protocol across the operator's Northstar-managed
  project work.
- **Start:** 2026-09-04 after card 129 merge plus verified installed-skill parity.
- **Stop:** the tenth accepted/closed PR lane, or 2026-09-18 at 17:00
  Europe/London, whichever comes first.
- **Collection:** record only evidence already emitted by normal coordinator,
  worker, reviewer, provider, and closeout activity. Do not create synthetic
  lanes, delay dispatch, or add an observation approval gate.
- **Per-lane fields:** project/lane/PR; coordinator, worker, and reviewer
  capability plus provider/model identity; confirmation-to-worker latency;
  review rounds/findings; coordinator interventions; `continue` prompts;
  polling/open-turn incidents; Chatterbox notifications and runway state;
  workspace/lease friction; write-transport refusal/fallback; post-acceptance
  misses.
- **Ownership:** coordinators emit their ordinary closeout facts; Chatterbox
  reconciles the bounded cohort assessment after the stop condition. Missing
  evidence stays missing and does not block project delivery.
- **Change freeze:** urgent correctness fixes may proceed through normal
  planning, but the assessment separates pre-change and post-change lanes.

## Acceptance criteria

- [ ] ten PR lanes recorded without interrupting them;
- [ ] coordinator interventions and post-acceptance misses are explicit;
- [ ] economical and escalated route choices are distinguishable;
- [ ] trial ends with keep, adjust, or revert recommendation.

## Next task

Collect passive evidence from natural project lanes. Stop at the tenth natural
lane or `2026-09-18 17:00 Europe/London`, whichever comes first. This card must
not block or synthesize work in Northstar or any consumer project.
