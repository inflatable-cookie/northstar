# 029 - Add Conversational Triage And Docs Cleanup

Status: active — implementation complete; operator usage feedback pending
Owner: repo maintainers
Created: 2026-08-19
Depends on: `g02.025`, `g02.027`
Vision tags: `conversational-capture`, `triage`, `docs-cleanup`, `orchestrator`
Master spec refs: `docs/specs/030-conversational-triage-and-docs-cleanup.md`
Contract refs: `docs/contracts/001-working-rules.md`, `bundle-docs/sections/09-standard-docs-spine.md`
Planning state: implementation and deterministic validation are complete; live operator usage remains

## Problem

Northstar needs a durable place for useful but unresolved conversational threads
and a safe route for reworking docs drift without treating unfamiliar content as
junk.

## Goals

- [x] add a standard `docs/triage/` capture buffer and lifecycle;
- [x] prompt orchestrator and refresh agents to capture notes before deep dives;
- [x] make refresh inspect and prune triage on every broad pass;
- [x] add a safe, operator-aware docs cleanup mode and command adapter;
- [x] align doctrine, templates, live docs, setup guidance, and deterministic
      checks;
- [ ] collect live operator feedback before retiring the spec.

## Non-Goals

- no rigid note form;
- no blind purge or automatic resolution of ambiguous docs;
- no production-code or consumer-repository changes.

## Contract Coverage

- Triage capture and cleanup rules live in `docs/contracts/001-working-rules.md`
  and `template-bundle/contracts/001-working-rules-template.md`.
- The standard spine and copy-ready folder live in `bundle-docs/sections/09-standard-docs-spine.md` and `template-bundle/triage/`.
- Conversation behavior lives in the orchestrator and refresh modes.
- Docs drift behavior lives in `cleanup-docs.md` and its command adapter.

## Execution Plan

### Batch 29.1 — Define the capture and cleanup contract

- promote the triage lifecycle and authority boundary into the live/template
  working-rules surfaces;
- define the handoff-matched filename format and lightweight body policy;
- define the cleanup classification, repair, and operator-question rules.

### Batch 29.2 — Apply the behavior and copy-ready surfaces

- add live, full-bundle, and minimal triage anchors;
- update orchestrator, refresh, router, setup, operator, sweep, and docs-front-door
  guidance;
- add the internal cleanup mode and thin command adapter;
- update source checks and command-surface expectations.

### Batch 29.3 — Reprove and close the implementation batch

- run deterministic bundle, contract, command, docs, QA, and parity checks;
- record the changed surfaces and validation evidence;
- leave live-use capture cadence as the one follow-up measurement.

## Acceptance Criteria

- [x] The standard spine and both starter bundles contain `triage/`.
- [x] Triage notes are timestamped like handoffs and explicitly temporary.
- [x] Orchestrator and refresh behavior records unresolved threads regularly.
- [x] Refresh reports triage as a managed facet and does not silently purge it.
- [x] Cleanup inspects and classifies `/docs` outliers before reworking them.
- [x] Uncertain ownership, destination, meaning, or removal asks the operator.
- [x] Source and installed skill surfaces remain deterministic and portable.

## Risks And Mitigations

- Risk: triage becomes a second backlog. Mitigation: keep it non-authoritative,
  require disposition, and promote material work into normal planning surfaces.
- Risk: cleanup removes useful project knowledge. Mitigation: inspect content and
  references, apply only clear bounded repairs, and ask on uncertainty.
- Risk: note-taking interrupts natural conversation. Mitigation: use topic shifts
  and meaningful checkpoints, not a rigid per-message form.

## Evidence Requirements

- changed-file inventory;
- deterministic validation output;
- manual review of triage lifecycle, orchestrator cadence, refresh management,
  and cleanup uncertainty boundaries;
- operator feedback before the spec is archived.

## Next Task

Run the new capture behavior in live use and record whether the notes preserve
the useful branches without creating cleanup noise.
