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
:: Turnkey task plans derived from vision, architecture, and contracts.
  The generation README owns the runway; each `gNN.NNN` task owns its
  objective, steps, acceptance, and closeout. Model long work as
  dependency-linked tasks, not one agent turn.

**Logs**
:: Dated evidence and decision records. Written per completed task, not per step.

**Handoffs**
:: Friendly, timestamped notes that let another thread or person take over. They
  live in `docs/handoffs/` and do not replace task evidence.

**Triage notes**
: Lightweight, timestamped Markdown capture notes for observations, ideas,
  plans, and questions that are not yet settled. They live in `docs/triage/`,
  are not execution authority, and must be promoted, merged, or removed over
  time.

## Lifecycle and Adoption

**Compact lifecycle**
: Northstar's single operating model. One compact strict lifecycle combining the standard seven-folder docs spine with consequence-triggered modules (specs, product guardrails, research) and execution protections (ready-state rubric, review oracles, fail-closed stops). Former alternative steady states (baseline, light, lane-first, mixed, full-strict) are retired.

**Incremental adoption**
: Bounded migration of an existing mature repository into the compact lifecycle in explicit tranches. Migration state is not a permanent second protocol.

**Posture (historical)**
: Former classification into baseline, strict, or mixed operating protocols. Retired in favor of one compact lifecycle.

## Execution and Workflow

**Task**
:: The sole executable planning unit. Lives at `docs/roadmaps/gNN/NNN-<slug>.md`
  and is referenced as `gNN.NNN`. Owns its objective, sequence, dependencies,
  boundaries, dispatch manifest, acceptance oracle, evidence, and closeout.
  A queue task transports one Northstar task; an Effigy task is a command
  selector. Neither is planning authority.

**Generation**
:: A numbered era of roadmap tasks (`g01`, `g02`, `g03`). Holds 20-40 tasks before rollover is warranted. In parallel mode, multiple generations may be active simultaneously as independent queues. Its machine state has two axes: disposition (`open` or `closed`, changed only by an explicit closure record; never `complete`) and derived runway state (`active`, `ready`, `blocked`, `planned`, or `planning_required` — the exhausted state that asks planning for the next decision).

**Lane**
: An active line of work within a roadmap. Each active generation owns one
  approved queue.

## Planning and Control

**Planning gate**
: A required checkpoint. Execution stops when a required contract, architecture coverage, or repo authority is missing.

**Planning gap**
: Missing coverage that blocks roadmap execution. Recorded as a gap rather than inferred.

**Currentness**
: The property of front-door docs (`README.md`, `generation-index.md`) accurately reflecting the active lane and recent evidence.

**Currentness curation**
: The periodic or closeout-driven task of aligning front doors to active state.

**UI classification**
: The depth of UI planning a lane needs, chosen by decision risk and user
  impact: refinement, workflow change, or substantial redesign. File count is
  not a proxy.

**UI design brief**
: The durable record of a UI lane's problem, current and target workflows,
  presentation direction, states, viewports, constraints, concept evidence,
  scenario oracle, and stop conditions. Owned by the canonical task or spec and
  transported to the worker as a self-contained `UI Design Brief` subsection
  under `Important Context`.

**Design delegate**
: A planning-only conversational helper for a substantial UI lane. Gathers
  requirements, inspects the running surface, maps workflows, and produces
  materially different concepts. It cannot implement production code or grant
  readiness; the operator selects the direction.

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
| Roadmaps | Executable tasks | `docs/roadmaps/gNN/` |
| Logs | Evidence | `docs/logs/YYYY-MM/` |
| Handoffs | Coordination | `docs/handoffs/YYYYMMDD-HHMMSS-<slug>.md` |
| Triage notes | Temporary capture | `docs/triage/YYYYMMDD-HHMMSS-<slug>.md` |
| Policy | Repo-local rules | `docs/policy/` |

## Where to Start

- New to Northstar: [`bundle-docs/README.md`](./README.md)
- Want a quick visual overview: [`visual-map.md`](./visual-map.md)
- Want copy-ready templates: [`template-bundle/README.md`](../template-bundle/README.md)
- Want naming conventions fast: [`cheat-sheet.md`](./cheat-sheet.md)
