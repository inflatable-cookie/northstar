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
- `CLAUDE.md` containing `@AGENTS.md`
- `PAPERCUTS.md`
- `effigy.toml`
- `CHANGELOG.md`
- `scripts/README.md`
- `docs/README.md`
- `docs/vision/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`
- `docs/policy/internal-writing-style.md`

### Local agent paths

The tracked `.agents.local.env.example` and ignored `.agents.local.env` provide
the repository-local path registry for agents. The file is path-only, never a
credential store. `AGENTS_WORKTREE_CONTAINER_DIR` is required before an agent
creates a worktree manually; `AGENTS_SCRATCH_DIR` and `AGENTS_ARTIFACT_DIR` are
optional. Prefer harness-managed locations. If a manual worktree is needed and
the key is absent, ask the operator for an absolute container directory, create
the ignored file from that answer, and stop rather than guessing `/tmp`,
`TMPDIR`, or a repository-adjacent path.

See `docs/contracts/002-agent-local-paths.md` for the full contract.

### Optional Paseo project adapter

When Paseo manages the repository, project-root `paseo.json` may expose the
repo's Effigy tasks, metadata-generation guidance, and managed-worktree hooks.
Use [`paseo-project.md`](./paseo-project.md) and the shipped templates. Keep the
adapter optional, merge existing settings, and preserve the project's own
bootstrap and teardown authority.

### Claude Code bridge

When adopting the Northstar starter, copy `CLAUDE.md.template` to the
repository root as `CLAUDE.md`. Keep the exact `@AGENTS.md` reference so Claude
Code loads the shared cross-agent contract. Add Claude-specific instructions
only when they cannot be expressed in `AGENTS.md`; do not duplicate shared
rules.

Seed root `PAPERCUTS.md` from `assets/templates/PAPERCUTS.md` during adopt or
upgrade, before release-candidate / exact-SHA preparation. Do not add it during
tag closeout after a clean-tree release SHA is already green — that dirties the
tree or forces a retag. Missing-file create-on-first-friction remains valid for
agents mid-task; adoption must still install the starter early.

For workspace-container repos, keep the workspace root lean and apply this full
file set inside the nested docs-authority repo instead of duplicating it at the
top level.

Do not force `CHANGELOG.md` and release config onto the workspace root or the
docs-authority repo unless one of those repos is actually a releasable artifact.
Keep release posture on the repos that really ship code or packages.

## Minimum Semantics

Do not mirror these commands into `package.json` scripts. Agents and humans
should run `effigy <task>` directly; package scripts should stay
package-native.

- `effigy tasks`
- `effigy doctor`
- `effigy test --plan`
- `effigy qa`
- `qa:docs`
- `qa:northstar`

### Task ladder: `health` vs `qa`

`effigy doctor` runs built-in checks and, when present, `tasks.health`. Keep
that ladder honest:

- `health` — cheap orientation only (seconds-scale: fmt, toolchain floor,
  docs-forbidden, or a single `check`). This is what doctor should invoke.
- `validate` — mid gate when the repo uses one (check + build, etc.).
- `qa` — full validation board.

Never set `health = [{ task = "qa" }]` (or otherwise make health expand into
the full board). That turns every orientation `effigy doctor` into an
unbounded suite run. Full validation stays on `effigy qa`.

## Starter Native Docs Policy

Native mode is now the normal target. When the installed Effigy surface
supports consumer-side `docs_policy`, the starter repo contract should include:

- `[docs_policy.indexes.vision]`
  - `file = "docs/vision/README.md"`
  - `dir = "docs/vision"`
  - `section = "Vision Artifacts"`
  - `exclude = ["history/**"]`
That config should pair with repo-owned tasks composed from native validators:

- `effigy docs check-paths README.md AGENTS.md docs/README.md docs/vision/README.md docs/roadmaps/README.md docs/logs/README.md`
 - `effigy docs check-paths docs/policy/internal-writing-style.md`
- `effigy docs check-contains AGENTS.md --require "effigy tasks" --require "effigy test --plan"`
- `effigy docs check-contains README.md --require "docs/README.md"`
- `effigy docs check-contains docs/README.md --require "vision/README.md" --require "roadmaps/README.md" --require "logs/README.md"`
- `effigy docs check-index --policy-index vision`
- `effigy docs check-headings docs/vision/README.md --require-heading "## Current Vision"`
- `effigy docs check-forbidden ... --forbid '--repo .'`

For a thin workspace root that delegates into a nested docs-authority repo, the
same contract still applies. The root should only keep the orchestration tasks
and links it actually owns.

When native Effigy docs tasks live in a nested docs-authority repo, make that
mode explicit in config:

- either run the child catalog from the workspace root with root-prefixed file
  paths and policy files
- or run the nested repo as the true repo root and use local relative paths

Do not mix those two modes in one task surface.

## Minimum Docs Model

Baseline docs spine:

- `vision` defines long-horizon outcome and strategic constraints
- `architecture` defines realized structure and guardrails once planning settles
- `contracts` define durable behavioral rules and important boundaries
- `roadmaps` define milestone queue and execution batches
- `logs` record meaningful evidence and decisions
- `triage` holds temporary timestamped capture notes; it is not execution
  authority and must be promoted, merged, or removed over time

Do not collapse all three into a single generic planning note.

For consequence-triggered modules, adopt as needed:

- `architecture/product-guardrails.md`
- `contracts/001-working-rules.md`
- `contracts/contract-index.md`
- `specs` as a provisional planning surface
- `roadmaps/gNN/batch-cards/` for execution cards when batch-card detail is needed

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
- keep one explicit next-task pointer in the roadmap front doors
- keep repo-facing examples free of current-directory `--repo .` usage even if
  a nested authority repo needs internal delegation wiring in `effigy.toml`
- in normal operator-facing responses, use a natural, human conversational tone;
  keep recommendations and next moves clear without turning every reply into a
  status report
- in orchestrator threads, stay direct and easy to redirect: explain state,
  trade-offs, and next dispatches clearly, and route material product
  exploration to chatterbox threads while keeping authority boundaries clear
- keep execution artifacts compact and high-signal; do not apply artifact
  compression to normal thread conversation
- point `AGENTS.md` and `CLAUDE.md` at `docs/policy/internal-writing-style.md`
  instead of repeating the full style rule inline
- **Refactoring:** before v1.0, do not add compatibility shims, aliases, or
  silent fallbacks; clean migrations and operator decisions on breaks. At v1.0+
  maturity, default to preserving expected stable behavior; material breaks need
  explicit owner policy. Encode detail in `contracts/001-working-rules.md`
  (or the project's adapted copy).

## Minimum Release Posture

- maintain `CHANGELOG.md`
- define a release-readiness validation path
- use native Effigy release config when the installed surface supports it
- otherwise keep release posture explicit through changelog plus QA tasks
- confirm root `PAPERCUTS.md` exists before pinning an exact-commit /
  clean-tree release candidate (seed from the starter if absent)

For workspace-container repos, add release posture only to the repos that are
actually releasable. Do not force a docs-only authority repo to pretend it
ships releases if that is not true.
