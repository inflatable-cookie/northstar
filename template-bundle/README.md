# Template Bundle

**Type: PRODUCT ARTIFACT** -- Copy this directory or its `minimal/` subset into your project's `docs/`.

This directory is the product artifact.

The folders here are intended to be copied into a target project's `docs/` directory.

The root `PAPERCUTS.md` queue is a companion starter surface, not a `docs/`
folder. Seed it from `skills/northstar/assets/templates/PAPERCUTS.md` when
installing the top-level agent templates — on adopt/upgrade, before
release-candidate / exact-SHA prep. Do not introduce it during tag closeout
after a green clean-tree SHA. The installed Northstar skill also creates it on
first use when it is missing; that path must not be the first install after a
release candidate is already pinned.

## Quick Start: Choose Your Bundle

| What you need | Copy this | Contents |
|--------------|-----------|----------|
| Minimal viable setup, no examples | `minimal/` | 7 core folders, READMEs only |
| Full bundle with examples and templates | this directory | Core + optional add-ons + specimens |

For first-time users: start with `minimal/`, then add optional folders as needed.

## Core structure

- `vision/`
- `architecture/`
- `contracts/`
- `roadmaps/`
- `logs/`
- `handoffs/`
- `triage/`
- `policy/`

The top-level agent starter also includes `.agents.local.env.example`. Copy it
to the ignored `.agents.local.env` only when an agent needs local paths. Manual
worktree creation requires `AGENTS_WORKTREE_CONTAINER_DIR` from that file;
harness-managed worktrees do not. Install `AGENTS.md` and the one-line
`CLAUDE.md` bridge (`@AGENTS.md`) together.

For projects managed by Paseo, the installed Northstar skill also ships an
optional root `paseo.json` template and an Effigy-backed worktree helper. They
stay outside this docs-only bundle. The helper can recreate sibling repositories
from Effigy's machine-local dependency-link ledger before bootstrap and replay
those links afterward.

### Optional language quality packages

Language quality (Rust, TypeScript/Svelte) is not part of the docs bundle or
the core Northstar skill. Each language is an independently installable
official package under the generic package protocol in contract 004. Northstar
core plans, orchestrates, reviews, and normalizes docs with no language
package installed.

When the operator explicitly requests a language quality workflow — or the
repository already carries a registered activation marker — the agent routes
through the installed-package procedure in the Northstar skill
(`references/packages/installed-package-route.md`): generic registry-owned
selection, visible acquisition notice, and a `routed` result executing the
package's declared entrypoint from its installed path. Repository-owned
profiles, deviations, toolchains, and exclusions stay in the repository; the
package never rewrites them.

If no compatible package is installed and acquisition fails, only that
language workflow stops. The stop names the exact package identity and the
local installation route; every other Northstar workflow continues. There is
no embedded fallback and no compatibility alias in core.

## Standard docs spine

Every Northstar repository uses the standard core spine:

- `vision/`
- `architecture/`
- `contracts/`
- `roadmaps/`
- `logs/`
- `handoffs/`
- `triage/`
- `policy/`

The standard core spine handles direction, realized shape, durable rules,
sequencing, evidence, friendly handoffs, and lightweight conversational capture.

Add consequence-triggered modules when specific conditions require them, rather
than choosing a separate posture:

- `architecture/product-guardrails.md` -- when explicit execution constraints
  and negative guardrails are required
- `contracts/contract-index.md` -- when multiple contracts need formal indexing
- `contracts/001-working-rules-template.md` -- for explicit execution grammar,
  ready-state checks, and stop conditions
- `contracts/003-agent-instruction-surface-template.md` -- when customizing the
  AGENTS instruction surface
- `specs/` -- when provisional design shaping is needed before promoting durable
  outcomes into architecture/contracts
- `roadmaps/gNN/batch-cards/` -- for step-by-step execution detail under active
  roadmap milestones
- `research/` -- when comparative or source-backed exploration is needed before
  commitments

Starting small with the core spine does not classify a project into a lighter
protocol; it is already the compact Northstar lifecycle.

## Nested Docs-Authority Mode

Some projects keep the standard spine in a nested authority repo instead of at
the workspace root. That is a normal Northstar mode when the root is only an
orchestration container and one nested repo clearly owns planning.

In that shape:

- keep the standard spine in the nested authority repo
- keep the workspace root lean and link clearly into the authority repo
- adapt native Effigy docs checks so file paths and docs-policy config are
  rooted correctly for the nested authority

Do not treat this as a bespoke exception. It is a recurring setup mode for
multi-repo systems.

## Incremental adoption pattern

When a mature repo is adopting the compact lifecycle, keep that migration
inside the normal planning spine rather than inventing a detached governance
surface.

Use:

- one active migration master spec
- one active roadmap milestone
- normal batch logs for completed migration tranches

That migration spec should record:

- satisfied compact lifecycle checkpoints
- blocking gaps
- whether migration state is still deliberate or has drifted
- current tranche
- next tranche
- the evidence needed to close the current tranche

Use the roadmap milestone to sequence the actual migration work and the logs to
prove each closed tranche. Do not invent a permanent mixed posture.

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
  point for projects that need an explicit execution grammar.
- Treat `specs/` as a planning add-on: use it when a change needs provisional
  shaping before its durable outcomes are promoted into architecture/contracts.
- Treat specs as provisional planning surfaces rather than permanent authority:
  keep them while a lane is active or their history is still useful, and archive
  or remove them when they no longer add value beyond the promoted canonical
  surfaces.
- Treat `architecture/product-guardrails.md` as part of the default working
  surface rather than an optional extra when boundary rules must be explicit.
- Keep research comparative, source-backed, and separate from architecture/roadmaps until translation memos are explicit.
- Enforce clean migrations: no compatibility shim files in deprecated folders; update references and remove legacy files in the same batch. For code refactors, **before v1.0** avoid compatibility aliases and silent fallbacks and escalate breaking changes to the operator; **at v1.0+** default to preserving expected stable behavior unless policy says otherwise (see `contracts/001-working-rules-template.md`).
- Treat per-project `meta/` docs as deprecated; extract useful content and link to Northstar docs.

Examples should be seeded inside the relevant section content rather than in a separate top-level examples directory.
The architecture and contracts sections include planning specimens to
show how system inventory, repo authority, and contract readiness should work in
practice.
The roadmap and logs sections include a worked replan sequence showing how a
planning gap becomes a contract delta and then a recompiled milestone.
They also include a second specimen showing when refocus should force a clean
`g02` rollover rather than preserve a misleading `g01`.

`policy/` is the home for short repo-local rules that agent instruction files
should point at rather than duplicating inline. Use it for lightweight
allowlists and internal writing-style guidance.

## Quick reference

- [Visual map](../bundle-docs/visual-map.md) -- one-page overview
- [Glossary](../bundle-docs/glossary.md) -- terminology
- [Cheat sheet](../bundle-docs/cheat-sheet.md) -- naming, formats, commands

## Operating posture

Northstar defaults to lean, strict execution:
- batch-based logging, not per-task logging
- problem-led research, not collection-building for its own sake
- manual-first evidence, automation only when recurring pain justifies it
- prefer `effigy` first, then `TypeScript`+`bun` for repo-owned automation;
  treat Bash/Python as exceptions rather than a mixed default
- clear active queue + backlog separation to prevent roadmap sprawl
- specs are provisional; architecture and contracts are the canonical execution
  surfaces once a design is accepted
- strict planning gates: stop on planning gaps instead of making up missing
  behavior
- one compact lifecycle default: the core spine handles normal execution, with
  consequence-triggered modules added when needed
- incremental adoption moves mature projects into the compact lifecycle in
  bounded tranches without creating a permanent mixed posture
- already-closed generations compact through refresh, normalize, and authorized
  cleanup; a new rollover is not a prerequisite
