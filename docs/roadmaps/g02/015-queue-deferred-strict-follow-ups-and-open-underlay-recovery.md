# 015 - Queue Deferred Strict Follow-Ups And Open Underlay Recovery

Status: complete
Owner: repo maintainers
Created: 2026-04-09
Depends on: g02.014
Vision tags: `consumer-repos`, `strict-follow-up`, `underlay`, `recovery`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/018-consumer-repo-follow-up-queue-and-underlay-recovery.md`
Planning state: ready

## Problem

Northstar has multiple consumer-repo outcomes in flight now:

- Signal proved the strict-lane execution model well enough to move back into
  the consumer repo itself.
- Jetstream and Loophole both improved materially, but should be revisited
  later rather than pushed immediately into fuller strict compliance.
- Underlay now appears to be the next real target because its docs authority
  says the major Poodle translation/contraction work is done while the live
  shared-surface overhaul continues across several consuming apps.

Without an explicit queue, these follow-ups will drift back into chat memory.

## Goals

- [x] record Jetstream and Loophole as deliberate deferred strict-migration
      return targets
- [x] open Underlay as the active next consumer-repo recovery target
- [x] complete an Underlay recovery audit that freezes its real active posture
- [x] decide that Underlay first needs planning/currentness repair rather than
      a blind stricter execution-lane install

## Non-Goals

- [ ] reopening Jetstream or Loophole immediately
- [ ] forcing full strict migration into Underlay before its drift pattern is
      understood
- [ ] widening this lane into a new doctrine rewrite

## Contract Coverage

- [x] Every execution-relevant behavior in this milestone is covered by an
      explicit governing artifact.
- [x] Cross-repo dependencies are listed in `repo-authority-map.md` or this
      milestone is single-repo only.
- [x] Required research translation memos are linked where relevant.

## Execution Plan

### Batch 15.1 - Queue Deferred Follow-Ups And Open Underlay Target

- [x] record Jetstream’s deferred return trigger
- [x] record Loophole’s deferred return trigger
- [x] open Underlay as the active next target
- [x] refresh Northstar’s front-door surfaces

### Batch 15.2 - Run Underlay Recovery Audit

- [x] inspect Underlay’s front doors, roadmap queue, logs, and active repo
      posture
- [x] identify the precise drift between declared and real active work
- [x] decide that the next move is planning/currentness repair first rather
      than a blind stricter execution-lane install

### Batch 15.3 - Apply Underlay Recovery Findings

- [x] apply the warranted Underlay recovery batch and open the next ownership
      lane explicitly
- [x] leave the next consumer-repo move unambiguous

## Acceptance Criteria

- [x] Jetstream and Loophole are explicitly queued as deferred return targets
- [x] Underlay is explicitly named as the active next target
- [x] Underlay’s real active posture is frozen from evidence
- [x] the next warranted Underlay move is explicit

## Planning Gaps

- none

## Evidence Requirements

- [x] updated roadmap/spec/front-door surfaces for the follow-up queue
- [x] audit evidence for Underlay’s live posture
- [x] application log for the resulting Underlay recovery decision

## Next Task

Let Underlay execute `g01.098` Batch 98.2, then reassess from that audit
whether Northstar should stay at planning-layer recovery there or open a
stricter execution-lane proof.
