# Repo Contract

Use this contract when a repo should mean the same thing when an agent is told
"use Northstar and Effigy."

The boundary is intentional:

- Northstar owns repo shape, docs structure, and starter templates
- Effigy owns generic validation, task/runtime surfaces, JSON contracts, and
  release orchestration
- compatibility mode exists only for older or mismatched installed binaries,
  not as the preferred default

## Minimum Files

- `README.md`
- `AGENTS.md`
- `effigy.toml`
- `CHANGELOG.md`
- `scripts/README.md`
- `docs/README.md`
- `docs/vision/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`

For workspace-container repos, keep the workspace root lean and apply this full
file set inside the nested docs-authority repo instead of duplicating it at the
top level.

Do not force `CHANGELOG.md` and release config onto the workspace root or the
docs-authority repo unless one of those repos is actually a releasable artifact.
Keep release posture on the repos that really ship code or packages.

## Minimum Semantics

- `effigy tasks`
- `effigy doctor` or `effigy health`
- `effigy test --plan`
- `effigy qa`
- `qa:docs`
- `qa:northstar`

## Starter Native Docs Policy

Native mode is now the normal target. When the installed Effigy surface
supports consumer-side `docs_policy`, the starter repo contract should include:

- `[docs_policy.indexes.vision]`
  - `file = "docs/vision/README.md"`
  - `dir = "docs/vision"`
  - `section = "Vision Artifacts"`
  - `exclude = ["history/**"]`
- `[docs_policy.next_actions.vision]`
  - `index = "vision"`
  - `heading = "## Next Task"`
  - `allowlist_file = "docs/policy/vision-next-task-verbs.txt"`

That config should pair with repo-owned tasks composed from native validators:

- `effigy docs check-paths README.md AGENTS.md docs/README.md docs/vision/README.md docs/roadmaps/README.md docs/logs/README.md docs/policy/vision-next-task-verbs.txt`
- `effigy docs check-contains AGENTS.md --require "effigy tasks" --require "effigy test --plan"`
- `effigy docs check-contains README.md --require "docs/README.md"`
- `effigy docs check-contains docs/README.md --require "vision/README.md" --require "roadmaps/README.md" --require "logs/README.md"`
- `effigy docs check-index --policy-index vision`
- `effigy docs check-next-action --policy vision`
- `effigy docs check-headings docs/vision/README.md --require-heading "## Current Vision"`
- `effigy docs check-forbidden ... --forbid '--repo .'`

For a thin workspace root that delegates into a nested docs-authority repo, the
same contract still applies. The root should only keep the orchestration tasks
and links it actually owns.

## Minimum Docs Model

Baseline docs spine:

- `vision` defines long-horizon outcome and strategic constraints
- `architecture` defines realized structure and guardrails once planning settles
- `contracts` define durable behavioral rules and important boundaries
- `roadmaps` define milestone queue and execution batches
- `logs` record meaningful evidence and decisions

Do not collapse all three into a single generic planning note.

For stricter or more failure-prone projects, adopt the stricter spine:

- `architecture/product-guardrails.md`
- `contracts/001-working-rules.md`
- `contracts/contract-index.md`
- `specs` as a provisional planning surface
- `specs/batch-cards/`

In that mode, specs should be treated as a stepping stone to
architecture/contracts rather than a second permanent authority.

## Minimum Automation Runtime Policy

- prefer `effigy` when it already covers the repo operation
- when repo-owned script logic is still needed, default to `TypeScript` run
  with `bun`
- use `bash` only for thin glue or compatibility boundaries
- use `python` or another runtime only with a concrete technical reason
- keep the local reason visible when a repo intentionally deviates from the
  default stack

## Minimum Agent Contract

- start with Effigy, not raw shell commands
- prefer built-in `effigy test` unless the repo intentionally overrides it
- use `--repo <PATH>` only for a different repo
- leave one explicit next task in the current planning surface
- keep repo-facing examples free of current-directory `--repo .` usage even if
  a nested authority repo needs internal delegation wiring in `effigy.toml`

## Minimum Release Posture

- maintain `CHANGELOG.md`
- define a release-readiness validation path
- use native Effigy release config when the installed surface supports it
- otherwise keep release posture explicit through changelog plus QA tasks

For workspace-container repos, add release posture only to the repos that are
actually releasable. Do not force a docs-only authority repo to pretend it
ships releases if that is not true.
