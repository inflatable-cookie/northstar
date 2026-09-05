# Standard Docs Spine

Status: active
Updated: 2026-08-19

## Purpose

Define the standard Northstar docs structure plainly enough that setup and
execution do not need to infer it from scattered doctrine.

## Baseline Spine

Every normal Northstar repo should have:

- `docs/README.md`
- `docs/vision/`
- `docs/architecture/`
- `docs/contracts/`
- `docs/roadmaps/`
- `docs/logs/`
- `docs/handoffs/` -- friendly, timestamped notes for genuine fresh-thread takeovers
- `docs/triage/` -- lightweight, timestamped capture notes awaiting promotion or removal

This is the smallest standard spine that still gives a repo clear direction,
realized structure, hard rules, execution sequencing, evidence, conversational
capture, and a dependable place for fresh-thread handoffs.

## Consequence-Triggered Modules

The core standard spine handles direction, realized shape, durable rules,
sequencing, evidence, handoffs, and conversational capture.

Add consequence-triggered modules when specific conditions require them,
rather than creating a separate posture:

- `docs/architecture/product-guardrails.md` -- when explicit execution constraints
  and negative guardrails are required
- `docs/contracts/contract-index.md` and `docs/contracts/001-working-rules.md` --
  for formal contract coverage and execution grammar
- `docs/specs/README.md` and `docs/specs/templates/` -- when provisional shaping
  is needed before promoting durable outcomes into architecture/contracts
- `docs/roadmaps/gNN/batch-cards/` -- for step-by-step execution detail under
  active roadmap milestones
- `docs/research/` -- when comparative or source-backed exploration is needed
  before architecture or roadmap commitments

Starting small with the core spine does not classify a project into a lighter
protocol; it is already the compact Northstar lifecycle.

## Surface Roles

- `vision/` defines the longer arc and major constraints.
- `architecture/` records the realized system shape and guardrails.
- `contracts/` define durable behavior, policy, boundaries, and completion
  rules.
- `specs/` are provisional planning surfaces used only while shaping material
  changes before promotion.
- `roadmaps/` sequence approved work from the canonical surfaces.
- `logs/` capture batch-level evidence and decisions.
- `handoffs/` hold friendly, timestamped notes for genuine thread takeovers.
- `triage/` holds temporary conversational observations, ideas, plans, and
  questions. It is a mutable capture buffer, not an execution authority. Update
  the same note when an issue changes. Full promotion deletes the note; partial
  promotion leaves only unresolved meaning. Git history and logs retain the
  history.

## Nested Docs-Authority Repos

Some projects keep the standard spine inside a nested authority repo such as
`ledger/`, `trellis/`, `cp-docs/`, `acme-docs/`, or `composer-docs/` instead
of at the workspace root.

Treat that as a normal Northstar mode when:

- the workspace root is intentionally thin
- one nested repo clearly owns the planning contract
- shipping repos should not duplicate the same docs spine

In that shape:

- the nested authority repo still carries the standard spine
- workspace-root front doors should point clearly into the authority repo
- native Effigy docs checks must be wired for the nested root deliberately
- setup should not frame this as a one-off exception

## Rules

- Do not install `specs/` mechanically on repos that do not need provisional
  planning; add them when material changes require shaping before promotion.
- Do not describe a repo without batch cards as carrying full
  continuation-envelope automation; batch cards carry step detail when explicit
  autonomy state is needed.
- Do not leave `specs/` present without making the promotion rule clear.
- Do not let setup invent a bespoke docs structure when the standard spine is
  enough.
- Do not force a workspace root to imitate a docs repo when a nested authority
  repo already owns the contract cleanly.
- Do not assume native Effigy docs-policy tasks written for a root-owned
  `docs/` spine will work unchanged inside a nested authority repo.

## Incremental adoption

When an existing mature repo adopts the compact lifecycle:

- adopt the standard spine in bounded tranches
- add consequence-triggered modules as needed
- maintain the migration inside the normal planning spine

Do not treat mixed-mode operation as a permanent state. Incremental adoption is
a migration path, not a second steady-state protocol.

## Migration audit and rollout pattern

When a mature repo is adopting the compact lifecycle, keep that migration
inside the standard spine rather than in a separate control surface.

Use:

- one active migration spec or roadmap milestone
- normal batch logs for completed migration tranches

The migration planning artifact should record:

- satisfied checkpoints
- blocking gaps
- whether migration state is still deliberate or has drifted
- current tranche
- next tranche
- tranche-close evidence

The roadmap milestone should then sequence the actual migration batches.

The live `## Next Task` pointer belongs in the roadmap front doors:
`docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`, and the active
`docs/roadmaps/gNN/README.md`. Other spine surfaces should summarize state or
dependencies without becoming the live thread pointer.

Refresh, normalization, and authorized docs cleanup compact already-closed
expanded generations into `docs/roadmaps/archive/gNN.md` without opening a new
generation. Leave unresolved generations expanded and name the blocker. Do not
report the spine current while classified closed generations remain expanded
unless that blocker or a bounded migration disposition is explicit.

## Template Impact

The template bundle makes the compact lifecycle copy-ready:

- the standard docs spine is obvious from the section layout
- consequence-triggered modules (such as working rules and specs) have concrete starter files, not just doctrine
- `handoffs/README.md` is the copy-ready home for fresh-thread notes
- `triage/README.md` is the copy-ready home for temporary capture notes; notes
  use `YYYYMMDD-HHMMSS-<slug>.md`, matching handoffs
- nested docs-authority repos should have an explicit native Effigy starter,
  not only prose about adapting the root-owned one

## Quick reference

- [Visual map: Doc hierarchy](../visual-map.md#doc-hierarchy)
- [Cheat sheet: Folder structure](../cheat-sheet.md#folder-structure)
