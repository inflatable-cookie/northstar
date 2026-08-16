# 026 - Add Northstar Native Pre-Execution Discovery

Status: planned
Owner: repo maintainers
Created: 2026-08-16
Depends on: g02.025
Vision tags: `pre-execution-discovery`, `readiness-mapping`, `intent-rounds`, `docs-native-planning`
Master spec refs: `docs/specs/027-northstar-native-pre-execution-discovery.md`
Research refs: `bundle-docs/research/translation-memos/matt-pocock-skills-audit-to-northstar.md`
Governing refs: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`
Planning state: queued behind the g02.025 orchestrator dogfood

## Problem

Northstar needs a stronger pre-execution phase for new or materially ambiguous
projects. The phase must expose decisions, dependencies, language, and accepted
uncertainty using the existing docs spine rather than an external issue tracker.

## Goals

- [ ] define readiness mapping and intent rounds with Northstar-native names
- [ ] keep decisions, research, prototypes, and operator questions distinct
- [ ] enforce a plan-only boundary that the map cannot override
- [ ] compile a cleared map into the normal spec/promotion/roadmap chain
- [ ] add starter templates and deterministic frontier checks
- [ ] add architecture refocus and reframe as bounded planning/communication routes
- [ ] preserve the current durable handoff and worker/PR contract
- [ ] dogfood the complete flow on a new or materially ambiguous project

## Execution plan

### Batch 26.1 - Define readiness state and frontier integrity

- define the map and decision-record schema;
- choose flat or bounded-subdirectory placement under `docs/specs/`;
- define status, ownership, blocking, resolution, and accepted-uncertainty fields;
- add deterministic orphan, cycle, and frontier checks;
- define the operator-owned transition gate.

### Batch 26.2 - Add intent and uncertainty-resolution procedures

- add intent-rounds procedure and router activation;
- add project-language rules and vocabulary ownership;
- add decision-prototype and questionnaire routes;
- ensure facts are investigated and decisions remain operator-owned.

### Batch 26.3 - Add starter surfaces and promotion path

- add copy-ready templates and a worked docs-native example;
- compile a cleared map into a master spec and roadmap lane;
- update setup, operator, and template-bundle guidance;
- add QA coverage for the new files and states.

### Batch 26.4 - Add architecture refocus, reframe, and dogfood

- add active-lane architecture refocus with offline-safe output;
- add non-mutating reframe behaviour;
- refine handoff purpose and next-session metadata;
- run one complete dogfood and record measured friction before broader promotion.

## Acceptance criteria

- [ ] current g02.025 dogfood is closed before this milestone becomes active;
- [ ] readiness maps use existing docs authority surfaces and no external tracker;
- [ ] frontier validation is deterministic and fail-closed on invalid state;
- [ ] no implementation card becomes ready while a governing decision is unresolved;
- [ ] operator-owned decisions cannot be resolved by agent-authored notes;
- [ ] the no-fog early exit works on a small change;
- [ ] the cleared-map promotion path leaves coherent spec, roadmap, and log state;
- [ ] architecture refocus is read-only and offline-safe;
- [ ] handoff additions preserve the single-file worker boundary;
- [ ] dogfood evidence measures planning revisions, reopened decisions, rework, and
      operator correction burden.

## Stop conditions

- stop if a second public skill or external tracker becomes necessary;
- stop if plan-only authority cannot be enforced from repository state;
- stop if the map duplicates canonical decision content;
- stop if the workflow encourages broad waterfall planning;
- stop if the starter cannot remain copy-ready for a consumer repository.

## Next task

Complete `g02.025/072` and its closeout. Then compile Batch 26.1 from the active
master spec and create its first ready card only after the file contract is settled.
