# 051 - Economical Orchestrator Coordination

Status: initial model superseded by g02.053/g02.054; card 126 retained as the
bounded passive observation lane
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Depends on: `g02.047`, `g02.049`, `g02.050`, spec 036
Vision tags: `orchestration`, `cost`, `review`, `chatterbox`, `paseo`
Governing refs: `docs/specs/036-economical-orchestrator-coordination.md`,
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/specs/035-chatterbox-intake-channel.md`,
`docs/contracts/001-working-rules.md`

## Problem

The long-lived orchestrator spends frontier-model capacity on mechanical queue,
review-routing, and merge work because Northstar still assigns planning and full
semantic review to that one role.

## Goals

- make economical coordination the orchestrator default;
- route material planning through operator-confirmed chatterbox packets;
- use bounded workers for canonical promotion;
- use independent child agents for substantive exact-head review;
- keep merge authority and safety gates with the orchestrator;
- measure the split before treating it as settled operating evidence.

## Non-goals

- no Paseo profile edits;
- no public role rename;
- no weaker review or merge gate;
- no automatic promotion from triage;
- no durable model-usage ledger.

## Execution plan

- [x] **Card 125** implements the authority split, adapters, doctrine, templates,
      review-child path, and validation.
- [ ] **Card 126** runs the separate ten-PR observation window after card 125 is
      merged and the installed skill is refreshed.

## Review oracle

Use the ten rows in spec 036. Structural wiring gets deterministic validation;
semantic role and merge boundaries remain exact-head review evidence.

## Stop conditions

- a planning packet lacks explicit operator-confirmed meaning;
- the coordinator would need to invent product semantics;
- review-child transport cannot preserve parentage and exact-head identity;
- the proposed merge gate is weaker than spec 026;
- implementation overlaps another active owner of orchestrator, review, or
  chatterbox surfaces.

## Next task

Card 129 is merged through PR 35. Card 126's published passive observation is
active through the tenth natural lane or `2026-09-18 17:00 Europe/London`.
Observation must not block normal project delivery.
