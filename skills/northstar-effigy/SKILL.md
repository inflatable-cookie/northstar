---
name: northstar-effigy
description: Use when a repo should adopt or normalize the Northstar + Effigy contract: scaffold docs structure, AGENTS guidance, changelog and release posture, repo tasks, and validation so an agent can act on “use Northstar and Effigy.”
---

# Northstar + Effigy

Use this skill when the user asks to:

- “use Northstar and Effigy”
- scaffold or normalize a repo around Northstar docs and Effigy workflows
- create the docs skeleton, changelog, release posture, and repo QA loop

## Quick Start

Start with the repo root:

```sh
effigy tasks
effigy doctor
effigy test --plan
```

Then confirm which Effigy surface is actually on `PATH`:

```sh
effigy docs --help
effigy release --help
```

Then choose native or compatibility mode from
[`references/adoption-modes.md`](./references/adoption-modes.md).

## Workflow

1. Inspect the repo state with Effigy plus `AGENTS.md`, `README.md`, and the
   current docs front door.
2. Apply the repo contract from
   [`references/repo-contract.md`](./references/repo-contract.md).
   If the repo is a thin workspace container with a nested docs-authority repo,
   keep the root lean, put the real Northstar spine in that nested repo, and
   leave release posture only on repos that actually ship.
3. Reuse Northstar's docs starter from [`../../template-bundle`](../../template-bundle)
   instead of inventing a bespoke structure.
4. Choose the right top-level templates from [`assets/templates`](./assets/templates).
5. Validate with the repo's `qa`, `qa:docs`, `qa:northstar`, and release
   surfaces where available.
6. Leave one explicit next task in the active roadmap or log flow.

## Required Outputs

The skill should leave these surfaces in a coherent state:

- `AGENTS.md`
- `effigy.toml`
- `CHANGELOG.md`
- `docs/README.md`
- `docs/vision/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`

Use the starter templates in [`assets/templates`](./assets/templates) for the
top-level repo surfaces. Use the Northstar bundle itself for the docs skeleton.
In workspace-container mode, the full docs set may live in a nested
docs-authority repo rather than at the workspace root, and `CHANGELOG.md` /
release config may belong only to releasable repos instead of the authority or
container root.

## References

- [`references/repo-contract.md`](./references/repo-contract.md): minimum shared
  repo contract
- [`references/adoption-modes.md`](./references/adoption-modes.md): choose
  between native and compatibility modes
- [`references/monkey-example.md`](./references/monkey-example.md): first real
  consumer example across both modes

## Guardrails

- Do not teach `--repo .` for current-repo usage.
- Do not introduce a custom `tasks.test` unless the repo intentionally needs to
  override built-in `effigy test`.
- Do not invent a repo-specific docs structure when the Northstar bundle already
  covers the need.
- Do not force a root-level docs/changelog/release layout onto a thin workspace
  container when a nested docs-authority repo already owns that contract.
- Do not force a docs-only authority repo to carry fake release posture just to
  satisfy a template.
- Do not assume native consumer-side docs or release config is available unless
  the installed Effigy surface actually supports it.
- Do not assume `effigy` on `PATH` is the same binary you just built; verify
  with `effigy docs --help` and `effigy release --help` before choosing native
  mode.

## Next Step

After scaffolding the repo, run the repo's validation path and classify any
friction as either repo-local cleanup or an Effigy product gap.
