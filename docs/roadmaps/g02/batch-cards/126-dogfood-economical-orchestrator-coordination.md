# 126 - Dogfood Economical Orchestrator Coordination

Status: blocked; observation packet and stop date are not published
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Master roadmap: `g02.051`
Governing refs: `docs/roadmaps/g02/051-economical-orchestrator-coordination.md`,
`docs/specs/036-economical-orchestrator-coordination.md`
Auto-start next card: no

## Objective

Observe ten representative PR lanes under the economical coordinator split and
decide whether the authority and escalation boundaries hold.

## Scope

- accept normal live lanes rather than creating synthetic project work;
- record the compact measures named by spec 036;
- include ordinary, material, revision, same-repository ordering, and
  provider-refusal cases when they occur naturally;
- finish with a short assessment and any narrowly justified protocol changes.

Out of scope: changing project work to satisfy the trial, polling workers,
durable token accounting, or encoding local model prices and quotas.

## Ready-state checks

- [x] card 125 merged through PR 32 as `61d4cc2`;
- [x] installed Northstar skill refreshed and tracked-archive parity verified;
- [x] operator updated Paseo with the `Luna coordinator` profile;
- [ ] observation packet and stop date are published.

## Acceptance criteria

- [ ] ten PR lanes recorded without interrupting them;
- [ ] coordinator interventions and post-acceptance misses are explicit;
- [ ] economical and escalated route choices are distinguishable;
- [ ] trial ends with keep, adjust, or revert recommendation.

## Next task

Blocked. Publish the bounded observation packet and stop date before starting
the cohort.
