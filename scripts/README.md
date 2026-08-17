# Scripts

Place repo-owned helper logic here when Effigy does not already cover the job.

Use Effigy from the repo root for the default maintenance loop:

```bash
effigy tasks
effigy doctor
effigy qa
```

## Runtime Policy

- prefer `effigy` when it already covers the operation
- when repo-owned script logic is still needed, use Effigy-native `Rhai`
- use TypeScript run with `bun` only for a concrete technical reason
- use `bash` only for thin glue or compatibility boundaries
- use `python` or another runtime only with a concrete technical reason

## Working Rule

Scripts remain implementation detail until the helper flow is stable enough to
expose as a first-class Effigy task.

## Installed skill parity

After a published Northstar skill change, update the configured global install
with the Skills CLI:

```bash
npx skills update northstar -g -y
npx skills list -g --json
effigy check:skill-install /path/to/installed/northstar
```

`npx skills update` follows the configured published source. It cannot see
uncommitted or unpushed changes in this checkout. During local skill
development, a direct sync is appropriate; keep it out of the published
operator path:

```bash
rsync -a --delete skills/northstar/ /path/to/installed/northstar/
```

Restart agent sessions after updating an installed skill so they reload the
new instructions.

The parity, bundle, posture, and repo-contract checks are Effigy-native Rhai
tasks. The repo-contract data lives in
`scripts/lib/northstar-repo-contract-data.rhai`, and its portable Markdown link
boundary is checked before Effigy’s native link validator runs.

## Repo contract (`qa:docs`)

`check:repo-contract` validates required Northstar surfaces and the installable
skill boundary. Every local Markdown link under `skills/northstar/` must resolve
inside that folder; escaping or missing targets fail QA.

## Explicit command surface (`check:command-skills`)

Run `effigy check:command-skills` directly or through `effigy qa:docs`.

The command-surface checker validates the six thin adapters under
`skills/northstar/commands/`: their names, description budgets, router and mode
references and ordering, one-mode wiring, aggregate prompt footprint,
retired-alias removal, thin-body/procedure guards, authority boundaries, and
exact adapter count. It is included in `effigy qa:docs`.

## Readiness-map frontier (`check:readiness-map`)

The readiness-map checker is read-only and fail-closed. It scans live readiness
maps under `docs/specs/` by default, or one positional destination/fixture root.
It reports missing references, orphan records, dependency cycles, invalid states,
and a deterministic open frontier without resolving operator-owned decisions.

```bash
effigy check:readiness-map
effigy check:readiness-map scripts/fixtures/readiness-map/valid
effigy test:readiness-map
effigy qa:docs
```

The fixture test covers valid, missing-reference, cycle, orphan, and
operator-blocked cases without network, database, provider, or external tracker
access. A repository with no live readiness maps passes with deterministic
zero-map output.

## Agent-instruction audit (`check:agent-instructions`)

The read-only agent-instruction audit measures root or supplied `AGENTS.md`
files and prints line, byte, approximate-token, heading, link, and code-block
counts. It also reports transparent review signals for likely scoped,
procedural, historical, conversational, or over-budget content. Signals are
advisory heuristics, not semantic verdicts, and the task never edits files.

```bash
effigy check:agent-instructions
effigy check:agent-instructions AGENTS.md
effigy check:agent-instructions skills/northstar/assets/templates/AGENTS.md
# from the Northstar catalog, audit a consumer repository instead:
effigy northstar/check:agent-instructions /path/to/project
```

## Posture advisory (`check:posture-advisory`)

Non-blocking checks for common **declared vs actual** drift in Northstar-shaped
`docs/` trees (active generation paths, specs archive surface, empty batch-card
folders). Always exits `0`; warnings print as `[northstar:advisory] …`.

```bash
effigy check:posture-advisory
# or target another repo root with a positional path:
effigy check:posture-advisory /path/to/project
# from a different discovered catalog:
effigy northstar/check:posture-advisory /path/to/project
```

`--repo` is reserved by Effigy for selecting the catalog repository, so it is
not a pass-through option for this task.

Smoke examples (expect one advisory line each):

- point `docs/roadmaps/generation-index.md` at a generation folder that does not
  exist
- add `docs/specs/001-any.md` without `docs/specs/archive/README.md`

This task is **not** part of `effigy qa` / `effigy qa:docs` so baseline repos stay
quiet until operators opt in.
