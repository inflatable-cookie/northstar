# Northstar Glossary

One-page reference for terms used across Northstar docs.

## Core Concepts

**Vision**
: Long-term direction and constraints. Not a delivery plan. The first required write in any new Northstar project.

**Architecture**
: System shape, boundaries, and inventory. Defines what exists and how it relates.

**Contracts**
: Explicit non-code agreements that constrain behavior -- API rules, policy, cross-repo ownership. Stable reference artifacts.

**Specs**
: Provisional planning surfaces. Temporary documents that shape a change before its durable outcomes are promoted into architecture or contracts.

**Roadmaps**
: Turnkey milestone plans derived from vision, architecture, and contracts.
  Name the batch sequence for a material slice of work — typically several
  batches and, in strict posture, several batch cards — not one agent turn.
  Use checkbox task lists in `## Execution Plan`, `## Goals`, and `## Acceptance
  Criteria`. Compiled after specs are promoted.

**Logs**
: Dated evidence and decision records. Written per completed batch, not per task.

**Handoffs**
: Friendly, timestamped notes that let another thread or person take over. They
  live in `docs/handoffs/` and do not replace batch logs.

**Triage notes**
: Lightweight, timestamped Markdown capture notes for observations, ideas,
  plans, and questions that are not yet settled. They live in `docs/triage/`,
  are not execution authority, and must be promoted, merged, or removed over
  time.

## Posture and Adoption

**Baseline**
: The standard seven-folder spine: `vision/`, `architecture/`, `contracts/`, `roadmaps/`, `logs/`, `handoffs/`, and `triage/`. Enough for normal routing, clear active-lane tracking, conversational capture, and dependable fresh-thread takeovers.

**Strict**
: Baseline plus additional guardrails: `contracts/contract-index.md`, `contracts/001-working-rules-template.md`, `architecture/product-guardrails.md`, `specs/`. Used when execution spans high-risk boundaries or needs longer autonomous runs.

**Posture**
: The current compliance level of a repo. A repo may be baseline, strict, or in migration between them.

**Lane-first adoption**
: Adopting strict posture for one active lane first, then expanding. The normal migration path, not a half-complete state.

## Execution and Workflow

**Batch**
: A meaningful chunk of work executed together. The unit of logging and closeout.

**Batch card**
: A short spec-like document that defines one batch's step-by-step scope,
  evidence, and done criteria. Sits under a roadmap milestone; the roadmap
  owns lane shape, batch cards own execution detail.

**Generation**
: A numbered era of roadmap milestones (`g01`, `g02`, `g03`). Holds 20-40 milestones before rollover is warranted. In parallel mode, multiple generations may be active simultaneously as independent queues.

**Milestone**
: One roadmap file inside a generation, named `NNN-<slug>.md`. Referenced as `gNN.NNN`.

**Lane**
: An active line of work within a roadmap. One active queue per generation plus a backlog.

**Backlog**
: Deferred work. Lives only at `docs/roadmaps/backlog/`.

## Planning and Control

**Planning gate**
: A required checkpoint. Execution stops when a required contract, architecture coverage, or repo authority is missing.

**Planning gap**
: Missing coverage that blocks roadmap execution. Recorded as a gap rather than inferred.

**Currentness**
: The property of front-door docs (`README.md`, `generation-index.md`) accurately reflecting the active lane and recent evidence.

**Currentness curation**
: The periodic or closeout-driven task of aligning front doors to active state.

## Research and Promotion

**Research**
: Comparative, source-backed exploration. Problem-led, not collection-building.

**Promotion**
: Moving durable outcomes from provisional specs into canonical architecture or contracts.

**Specimen dossier**
: A research artifact that documents one external system or approach.

**Value track**
: A research artifact that compares options along one dimension.

**Translation memo**
: A research artifact that bridges findings to actionable architecture or contract changes.

## Agent and Thread Concepts

**Continuation envelope**
: A brief that lets another thread pick up work without reconstructing context.

**Stop signal**
: An explicit reason why autonomous execution halted (planning gap, contract violation, budget exhausted).

**Pause signal**
: An explicit reason why a lane paused cleanly (budget hit, waiting for human input, external dependency).

**Lane budget**
: A bounded autonomy limit for a lane. Execution pauses when the budget is exhausted.

**Sweep**
: A structured audit-and-repair pass over project docs. Eight defined sweeps cover structure through planning gates.

**Handoff**
: A continuation brief created when one thread ends and another must continue.

**Chatterbox**
: The primary operator-facing planning authority. Owns discovery, research
  direction, triage reconciliation, canonical planning promotion, lane graph
  design, and the approved parallel frontier. Directly promotes confirmed
  planning on the integration branch and sends provenance-labelled direction to
  the coordinator.

**Planning delegate**
: An optional lightweight same-workspace conversation for exploring one issue
  in parallel. Creates one unique timestamped triage file, may keep that note
  current for the bounded issue under exact-path Git isolation, and reports to
  Chatterbox; does not open planning PRs or contact the coordinator.

**Coordinator**
: The mechanical delivery manager. Performs factual preflight, launches the
  approved frontier from the canonical dispatch manifest, manages
  worker/reviewer lifecycle, applies the merge gate, merges, and closes out.
  Yields immediately after action.

**Review child**
: An independent exact-head reviewer running in the existing worker workspace
  under a serial clean lease. The coordinator reuses its retained agent identity
  for revised heads. Posts a durable provider verdict naming the exact head.

**Dispatch manifest**
: The canonical specification in ready planning naming lane outcome, readiness,
  prerequisites, mutable paths, reserved closeout surfaces, approved concurrent
  siblings, serial edges, worker capability class, acceptance evidence, review
  oracle, and stop conditions.

## Files and Naming

**Slug**
: A short kebab-case identifier used in filenames: `001-my-feature.md`.

**Generation key**
: The `gNN` format for generation folders.

**Generation index**
: `docs/roadmaps/generation-index.md` -- the record of active generation(s), mode (sequential/parallel), and rollover history.

**Contract index**
: `docs/contracts/contract-index.md` -- the inventory of all active contracts.

## Quick Reference Table

| Term | What it is | Where it lives |
|------|-----------|----------------|
| Vision | Long-term intent | `docs/vision/` |
| Architecture | System shape | `docs/architecture/` |
| Contracts | Behavior rules | `docs/contracts/` |
| Specs | Provisional plans | `docs/specs/` |
| Roadmaps | Executable milestones | `docs/roadmaps/gNN/` |
| Logs | Evidence | `docs/logs/YYYY-MM/` |
| Handoffs | Coordination | `docs/handoffs/YYYYMMDD-HHMMSS-<slug>.md` |
| Triage notes | Temporary capture | `docs/triage/YYYYMMDD-HHMMSS-<slug>.md` |
| Backlog | Deferred work | `docs/roadmaps/backlog/` |
| Policy | Repo-local rules | `docs/policy/` |

## Where to Start

- New to Northstar: [`bundle-docs/README.md`](./README.md)
- Want a quick visual overview: [`visual-map.md`](./visual-map.md)
- Want copy-ready templates: [`template-bundle/README.md`](../template-bundle/README.md)
- Want naming conventions fast: [`cheat-sheet.md`](./cheat-sheet.md)
