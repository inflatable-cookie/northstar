---
name: northstar-setup
description: Use when a repo needs to be set up or normalized for Northstar. Scaffolds the repo shape, docs front doors, AGENTS guidance, changelog and release posture where needed, uses Effigy as part of the setup and validation layer, and installs the stricter delivery-layer surfaces by default where appropriate.
---

# Northstar Setup

Use this skill when the user asks to:

- set this repo or project up under Northstar
- scaffold or normalize a repo around Northstar docs and working conventions
- “use Northstar and Effigy”
- create the docs skeleton, changelog, release posture, and repo QA loop
- set up a stricter Northstar repo with stronger delivery guardrails
- normalize a repo onto the Northstar automation stack

## Quick Start

Start by confirming the repo shape, current docs posture, and the installed
tooling surface. Use Effigy where it is available and appropriate:

```sh
effigy tasks
effigy doctor
effigy test --plan
effigy docs --help
effigy release --help
```

Then choose the adoption mode from
[`references/adoption-modes.md`](./references/adoption-modes.md):

- single repo
- thin workspace root plus docs-authority repo
- compatibility mode only if the installed `effigy` binary cannot support the
  needed docs or release surface

Also decide whether the repo should install the stricter delivery layer from
[`references/delivery-layer-adoption.md`](./references/delivery-layer-adoption.md).
Think in terms of a standard docs spine:

- baseline spine: `vision`, `architecture`, `contracts`, `roadmaps`, `logs`
- stricter spine: baseline plus `product-guardrails`, `contract-index`,
  `001-working-rules`, and `specs/` with batch-card support

Treat those as two valid modes, not one correct mode and one compromise:

- baseline is enough for healthy routing and shorter bounded work
- stricter is the mode that can carry fuller continuation-envelope,
  lane-budget, and pause-signal state for longer autonomous runs

In a mature baseline repo, stricter adoption can begin lane-first. Use that
when one active lane needs fuller execution state but the rest of the repo does
not yet justify a broader rewrite.

Treat that as the migration entry point. If the project is intended to live
under the full strict Northstar doctrine, do not leave it indefinitely in a
mixed posture once the stricter lane proves out.

Make the longer migration path explicit too:

- baseline posture
- lane-first stricter adoption
- expanding strict coverage
- full strict compliance

Before you normalize an existing mature repo, classify its current posture:

- current posture
- satisfied strict-compliance checkpoints
- blocking gaps
- next migration tranche
- whether mixed posture is still valid migration state or has become drift

If the repo is meant to reach full strict compliance, keep that migration state
inside the normal planning spine rather than in side notes. One active
migration spec plus one active roadmap milestone is the default audit and
rollout surface.

When `specs/` are installed, make the lifecycle explicit:

- specs are provisional planning surfaces
- architecture and contracts become canonical once outcomes are settled
- specs may remain while the lane is active or the history is still useful
- `docs/specs/archive/` is the preservation surface for closed planning
  artifacts that should not stay in the active tree
- specs should be archived or removed when they no longer add value

For repo automation, use a clear runtime hierarchy:

- `effigy` first
- `TypeScript` + `bun` for repo-owned script logic
- Bash/Python only by explicit exception

## Workflow

1. Inspect the repo state with `README.md`, `AGENTS.md`, the current docs front
   door, and Effigy when available.
2. Apply the repo contract from
   [`references/repo-contract.md`](./references/repo-contract.md).
   Keep thin workspace roots lean, put the real Northstar spine in the repo
   that actually owns it, and leave release posture only on repos that
   actually ship.
3. Reuse Northstar's docs starter from
   [`../../template-bundle`](../../template-bundle) instead of inventing a
   bespoke structure. Apply either the baseline spine or the stricter spine
   deliberately; do not leave the repo between the two.
4. If the project is complex, long-running, or autonomy-sensitive, install the
   delivery-layer surfaces described in
   [`references/delivery-layer-adoption.md`](./references/delivery-layer-adoption.md).
   Make sure the repo inherits the execution guardrail pack against fake
   completion, unnecessary complexity, and shallow follow-through rather than
   only getting the folder shape. When `specs/` are part of that surface,
   install `docs/specs/archive/README.md` as well so closed planning artifacts
   already have an explicit home. Do not promise the full autonomy model from a
   roadmap-only repo when the stricter layer is the thing that actually carries
   that state. In a mature baseline repo, prefer lane-first stricter adoption
   when the need is local to one active lane rather than repo-wide, then plan
   the broader migration when the project is meant to reach full strict
   compliance. Be explicit about what phase the project is in, which
   checkpoints are already satisfied, what still blocks the next tranche, and
   what has to change before it can be treated as fully compliant. For mature
   repos already moving toward full strict compliance, leave that audit and
   rollout state in one active migration spec plus one active roadmap
   milestone.
5. Choose the right top-level templates from
   [`assets/templates`](./assets/templates).
   That includes the scripts README template when the repo owns custom script
   logic outside Effigy itself.
6. Validate with the repo's `qa`, `qa:docs`, `qa:northstar`, release surfaces,
   and any other existing setup checks where available.
7. Leave one explicit next task in the active roadmap or log flow.

## Required Outputs

The skill should leave these surfaces in a coherent state:

- `README.md`
- `AGENTS.md`
- `effigy.toml`
- `CHANGELOG.md`
- `scripts/README.md`
- `docs/README.md`
- `docs/vision/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`

For mature repos moving toward full strict compliance, also leave one explicit
audit and rollout surface in the normal planning spine:

- an active migration spec or equivalent existing spec updated with current
  posture, satisfied checkpoints, blocking gaps, current tranche, and next
  tranche
- an active roadmap milestone that sequences the migration batches from that
  audit state

For stricter projects, also leave these surfaces in place or explicitly
installed from the bundle:

- `docs/architecture/product-guardrails.md`
- `docs/contracts/contract-index.md`
- `docs/contracts/001-working-rules.md`
- `docs/specs/README.md`
- `docs/specs/archive/README.md`
- `docs/specs/batch-cards/README.md`
- `docs/specs/templates/master-spec-template.md`
- `docs/specs/templates/batch-card-template.md`

Use the starter templates in [`assets/templates`](./assets/templates) for the
top-level repo surfaces and the Northstar bundle itself for the docs skeleton.
In workspace-container mode, the full docs set may live in a nested
docs-authority repo rather than at the workspace root, and `CHANGELOG.md` or
release config may belong only to releasable repos instead of the container or
authority root. If Effigy is not yet the right layer for a repo, the setup work
should still leave the Northstar structure and repo front doors coherent.

## References

- [`references/repo-contract.md`](./references/repo-contract.md): minimum shared
  repo contract
- [`references/adoption-modes.md`](./references/adoption-modes.md): choose
  between single-repo, workspace-container, and compatibility behavior
- [`references/delivery-layer-adoption.md`](./references/delivery-layer-adoption.md):
  when to install the stricter delivery-layer surfaces
- [`references/monkey-example.md`](./references/monkey-example.md): first real
  consumer example across both modes

## Guardrails

- Do not teach `--repo .` for current-repo usage.
- Do not introduce a custom `tasks.test` unless the repo intentionally needs to
  override built-in `effigy test`.
- Do not invent a repo-specific docs structure when the Northstar bundle already
  covers the need.
- Do not introduce routine Bash or Python repo scripts when Effigy or
  TypeScript+Bun would cover the same job cleanly.
- Do not force a root-level docs/changelog/release layout onto a thin workspace
  container when a nested docs-authority repo already owns that contract.
- Do not force a docs-only authority repo to carry fake release posture just to
  satisfy a template.
- Do not leave a complex repo on the baseline surface when the delivery layer is
  clearly warranted.
- Do not treat one successful stricter lane as proof that the whole project is
  already fully compliant.
- Do not install `specs/` as if they were permanent authority; explain their
  provisional role, when `docs/specs/archive/` is warranted, and when closed
  planning artifacts should be archived or removed.
- Do not assume compatibility mode by default now that native consumer-side
  docs and release config are available on the released surface; use
  compatibility mode only when the installed binary still cannot support the
  needed commands or manifest keys.
- Do not assume `effigy` on `PATH` is the same binary you just built; verify
  with `effigy docs --help` and `effigy release --help` before choosing native
  mode.

## Next Step

After scaffolding the repo, run the repo's validation path and classify any
friction as either repo-local cleanup or an Effigy product gap.
