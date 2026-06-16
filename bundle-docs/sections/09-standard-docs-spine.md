# Standard Docs Spine

Status: active
Updated: 2026-04-08

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

This is the smallest standard spine that still gives a repo clear direction,
realized structure, hard rules, execution sequencing, and evidence.

## Stricter Spine

Use the stricter spine when the repo is long-running, autonomy-sensitive,
multi-surface, or otherwise prone to drift.

That mode keeps the baseline spine and adds:

- `docs/architecture/product-guardrails.md`
- `docs/contracts/contract-index.md`
- `docs/contracts/001-working-rules.md`
- `docs/specs/README.md`
- `docs/specs/templates/`

In a mature baseline repo, that stricter surface may be introduced lane-first
for the active lane that actually needs it instead of forcing an all-at-once
repo-wide rewrite.

Treat that as a migration pattern, not a permanent excuse to avoid full
stricter compliance where the project is expected to run under the strict
Northstar framework.

## Surface Roles

- `vision/` defines the longer arc and major constraints.
- `architecture/` records the realized system shape and guardrails.
- `contracts/` define durable behavior, policy, boundaries, and completion
  rules.
- `specs/` are provisional planning surfaces used only while shaping material
  changes before promotion.
- `roadmaps/` sequence approved work from the canonical surfaces.
- `logs/` capture batch-level evidence and decisions.

## Nested Docs-Authority Repos

Some projects keep the standard spine inside a nested authority repo such as
`ledger/`, `trellis/`, `cp-docs/`, `acme-docs/`, or `composer-docs/` instead
of at the workspace root.

Treat that as a normal Northstar mode when:

- the workspace root is intentionally thin
- one nested repo clearly owns the planning contract
- shipping repos should not duplicate the same docs spine

In that shape:

- the nested authority repo still carries the baseline or stricter spine
- workspace-root front doors should point clearly into the authority repo
- native Effigy docs checks must be wired for the nested root deliberately
- setup should not frame this as a one-off exception

## Rules

- Do not treat the stricter spine as optional when the repo needs longer
  autonomous runs or tighter anti-drift guardrails.
- Do not install `specs/` mechanically on tiny repos that do not need
  provisional planning.
- Do not describe the baseline spine as if it carries the full continuation,
  lane-budget, and pause-signal model; that stricter autonomy state belongs in
  repos that also carry `specs/` and batch cards.
- Do not assume a mature baseline repo must switch all lanes at once; lane-
  first adoption is valid when the need is local to one active lane.
- Do not leave `specs/` present without also making the promotion rule clear.
- Do not let setup invent a bespoke docs structure when the standard spine is
  enough.
- Do not force a workspace root to imitate a docs repo when a nested authority
  repo already owns the contract cleanly.
- Do not assume native Effigy docs-policy tasks written for a root-owned
  `docs/` spine will work unchanged inside a nested authority repo.

## Migration posture

When a project is expected to reach full strict compliance:

- baseline mode is the starting point
- lane-first stricter adoption is the proving step
- the stricter spine should then expand to become the normal working surface

Do not treat lane-first adoption as sufficient forever when the project is
meant to live under the strict framework.

## Migration audit and rollout pattern

When a mature repo is moving from baseline or lane-first posture to full strict
compliance, keep that migration inside the standard spine rather than in a
separate control surface.

Use:

- one active migration spec
- one active roadmap milestone
- normal batch logs for completed migration tranches

The migration spec should record:

- current posture
- satisfied checkpoints
- blocking gaps
- whether mixed posture is still a valid migration state or has become drift
- current tranche
- next tranche
- tranche-close evidence

The roadmap milestone should then sequence the actual migration batches.

The live `## Next Task` pointer belongs in the roadmap front doors:
`docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`, and the active
`docs/roadmaps/gNN/README.md`. Other spine surfaces should summarize state or
dependencies without becoming the live thread pointer.

## Template Impact

The template bundle should make both modes copy-ready:

- the baseline spine should be obvious from the section layout
- the stricter spine should have concrete starter files, not just doctrine
- nested docs-authority repos should have an explicit native Effigy starter,
  not only prose about adapting the root-owned one

## Quick reference

- [Visual map: Doc hierarchy](../visual-map.md#doc-hierarchy)
- [Cheat sheet: Folder structure](../cheat-sheet.md#folder-structure)
