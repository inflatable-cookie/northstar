# 126 - Dogfood Economical Orchestrator Coordination

Status: ready for corrected observation setup
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
- [ ] observation packet and stop date are published.

## Acceptance criteria

- [ ] ten PR lanes recorded without interrupting them;
- [ ] coordinator interventions and post-acceptance misses are explicit;
- [ ] economical and escalated route choices are distinguishable;
- [ ] trial ends with keep, adjust, or revert recommendation.

## Next task

Publish the bounded observation packet and stop date before starting the
corrected cohort.
