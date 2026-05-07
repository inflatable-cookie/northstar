# Template Bundle

**Type: PRODUCT ARTIFACT** -- Copy this directory or its `minimal/` subset into your project's `docs/`.

This directory is the product artifact.

The folders here are intended to be copied into a target project's `docs/` directory.

## Quick Start: Choose Your Bundle

| What you need | Copy this | Contents |
|--------------|-----------|----------|
| Minimal viable setup, no examples | `minimal/` | 5 core folders, READMEs only |
| Full bundle with examples and templates | this directory | Core + optional add-ons + specimens |

For first-time users: start with `minimal/`, then add optional folders as needed.

## Core structure

- `vision/`
- `architecture/`
- `contracts/`
- `roadmaps/`
- `logs/`
- `policy/`

## Standard docs spines

Baseline Northstar repos should use:

- `vision/`
- `architecture/`
- `contracts/`
- `roadmaps/`
- `logs/`

That baseline mode is enough for normal routing, clear active-lane tracking,
and shorter bounded work.

Stricter repos should keep the baseline spine and also use:

- `architecture/product-guardrails.md`
- `contracts/contract-index.md`
- `contracts/001-working-rules-template.md`
- `specs/`

Use the stricter spine when the repo needs the fuller execution layer:
continuation envelopes, lane budgets, pause signals, and batch-card-driven
autonomy that should stay explicit in file state.

In a mature baseline repo, that stricter layer can be adopted lane-first for
the active lane that actually needs it. Treat that as a normal migration
pattern, not a half-complete repo state.

Where a project is intended to live under the full strict Northstar doctrine,
that lane-first posture should be treated as the way in, not the final resting
state.

The expected migration is:

1. baseline posture
2. lane-first stricter adoption
3. expanding strict coverage
4. full strict compliance

Treat mixed posture as migration state, not the desired long-term end state.

## Nested Docs-Authority Mode

Some projects keep the standard spine in a nested authority repo instead of at
the workspace root. That is a normal Northstar mode when the root is only an
orchestration container and one nested repo clearly owns planning.

In that shape:

- keep the full baseline or stricter spine in the nested authority repo
- keep the workspace root lean and link clearly into the authority repo
- adapt native Effigy docs checks so file paths and docs-policy config are
  rooted correctly for the nested authority

Do not treat this as a bespoke exception. It is a recurring setup mode for
multi-repo systems.

## Strict-compliance migration pattern

When a mature repo is moving toward full strict compliance, keep that migration
inside the normal planning spine rather than inventing a detached governance
surface.

Use:

- one active migration master spec
- one active roadmap milestone
- normal batch logs for completed migration tranches

That migration spec should record:

- current posture
- satisfied checkpoints
- blocking gaps
- whether mixed posture is still valid migration state or has become drift
- current tranche
- next tranche
- the evidence needed to close the current tranche

Use the roadmap milestone to sequence the actual migration work and the logs to
prove each closed tranche.

## Optional add-on folders

Create these only if the project actually needs them.
Delete unused add-ons after copying the bundle.
`research/` ships as a starter pack because the workflow benefits from concrete templates.

- `research/`
- `schemas/`
- `templates/`
- `diagrams/`
- `specs/`

`templates/` here means top-level `docs/templates/`.
Section-local template folders such as `docs/roadmaps/templates/`, `docs/logs/templates/`, and `docs/research/templates/` remain part of the core bundle when those sections exist.

## Folder policy

- Keep `roadmaps/backlog/` as the only backlog pattern.
- Prefer decision logs over a separate `decisions/` folder.
- Treat `architecture/system-inventory.md`, `architecture/repo-authority-map.md`
  (when multi-repo), and `contracts/contract-index.md` as planning gate
  artifacts, not optional niceties.
- Treat `contracts/001-working-rules-template.md` as the copy-ready starting
  point for stricter repos that need an explicit execution grammar.
- Treat `specs/` as a planning add-on: use it when a change needs provisional
  shaping before its durable outcomes are promoted into architecture/contracts.
- Treat specs as provisional planning surfaces rather than permanent authority:
  keep them while a lane is active or their history is still useful, and archive
  or remove them when they no longer add value beyond the promoted canonical
  surfaces.
- For stricter projects, `architecture/product-guardrails.md` should be treated
  as part of the default working surface rather than an optional extra.
- Keep research comparative, source-backed, and separate from architecture/roadmaps until translation memos are explicit.
- Enforce clean migrations: no compatibility shim files in deprecated folders; update references and remove legacy files in the same batch.
- Treat per-project `meta/` docs as deprecated; extract useful content and link to Northstar docs.

Examples should be seeded inside the relevant section content rather than in a separate top-level examples directory.
The architecture and contracts sections include strict-planning specimens to
show how system inventory, repo authority, and contract readiness should work in
practice.
The roadmap and logs sections include a worked replan sequence showing how a
planning gap becomes a contract delta and then a recompiled milestone.
They also include a second specimen showing when refocus should force a clean
`g02` rollover rather than preserve a misleading `g01`.

`policy/` is the home for short repo-local rules that agent instruction files
should point at rather than duplicating inline. Use it for lightweight
allowlists and internal writing-style guidance.

## Operating posture

## Quick reference

- [Visual map](../bundle-docs/visual-map.md) -- one-page overview
- [Glossary](../bundle-docs/glossary.md) -- terminology
- [Cheat sheet](../bundle-docs/cheat-sheet.md) -- naming, formats, commands

## Operating posture

Northstar defaults to lean governance:
- batch-based logging, not per-task logging
- problem-led research, not collection-building for its own sake
- manual-first evidence, automation only when recurring pain justifies it
- prefer `effigy` first, then `TypeScript`+`bun` for repo-owned automation;
  treat Bash/Python as exceptions rather than a mixed default
- clear active queue + backlog separation to prevent roadmap sprawl
- specs are provisional; architecture and contracts are the canonical execution
  surfaces once a design is accepted
- strict planning gates when execution spans multiple repos or high-risk seams:
  stop on planning gaps instead of making up missing behavior
- use the stricter docs spine when the project needs tighter guardrails and
  longer autonomous runs
- where the project is meant to live under the strict doctrine, move from the
  first stricter lane toward project-level full compliance deliberately rather
  than leaving mixed posture to drift
