# {{PROJECT_NAME}} AGENTS

This file applies to the whole repository.

If this repo is only a thin workspace container, keep the top-level AGENTS
focused on orchestration and route the real docs contract through the nested
docs-authority repo instead of copying the full single-repo contract here.

## Start Here

```sh
effigy tasks
effigy doctor
effigy test --plan
```

`doctor` is orientation (built-in checks + cheap `tasks.health`). It is not
the full validation board — that is `effigy qa`. Never map `health` to `qa`.

Then prefer `effigy <task>` for supported repo work before falling back to raw
tools.

Do not add `package.json` scripts that re-export Effigy tasks. Use
`package.json` scripts only for package-native workflows.

## Default Loop

```sh
effigy tasks
effigy doctor
effigy test --plan
effigy qa
```

Use `--repo <PATH>` only when you intentionally want to target a different
repository.

## Docs Authority

- `docs/README.md`
- `docs/vision/README.md`
- `docs/roadmaps/README.md`
- `docs/logs/README.md`

If those files live in a nested docs-authority repo instead of this root, point
agents there explicitly and keep this root focused on orchestration tasks.

## Papercuts Loop

During execution, when a small solvable hurdle appears, append a short entry to
the owning repository's root `PAPERCUTS.md` before continuing. If the file is
missing, create it from the starter template in this skill without asking the
operator.

Record the friction, impact, possible fix, and affected surface. Do not stop
the current task, wait for permission, or fix the papercut unless that fix is
already in scope. Skip ordinary one-off failures, external blockers, sensitive
data, and duplicate open entries. Papercuts are observations for later triage,
not automatic roadmap work.

## Continuation Rule

In a strict Northstar lane, a bare `continue` should be enough.

Treat it as:

- resume from the previous closeout's `Next Task`
- re-anchor on the current ready card or explicit stop/reassessment step
- stay inside that bounded lane unless the file state itself requires a stop

Do not rely on giant continuation prompts if the repo surfaces already carry
the active card, boundaries, validation, and closeout requirements.

## Planning Ambiguity Rule

When planning is needed and the next direction is not clearly settled in the
repo's authority surfaces, stop and ask for operator intent instead of
guessing.

Do this especially when:

- more than one reasonable next lane or batch exists
- a milestone may close, continue, or hand off
- the choice depends on product priority rather than missing file updates

## Reporting Rule

Use a natural, human conversational tone for normal replies. Keep useful
recommendations and next steps, and make it easy for the operator to respond or
redirect. In orchestrator work, be creative and exploratory while keeping the
planning and authority boundaries clear.

For the end-of-turn closeout or meaningful checkpoint reply:

- lead with what was actually achieved
- then state the current lane state
- mention validation only if it failed or materially affects confidence
- then state the next move
- keep protocol detail brief and secondary

Do not make the operator infer the real outcome from card ids, file lists, or
long validation dumps.

## Local Agent Paths and Worktrees

- `.agents.local.env.example` documents the supported local path keys.
- `.agents.local.env` is the ignored, path-only local registry; never commit it
  and never put credentials, secrets, or commands in it.
- Prefer a harness-managed worktree, scratch location, or artifact location when
  one is supplied. Do not create a second manual location around it.
- Before creating a worktree manually, read `.agents.local.env` and require a
  valid absolute `AGENTS_WORKTREE_CONTAINER_DIR`.
- If the file or key is absent, stop and ask: “What absolute directory should
  this repository use as its manual worktree container? I will store it in
  untracked `.agents.local.env` as `AGENTS_WORKTREE_CONTAINER_DIR=...` and use a
  separate subdirectory per repository and lane.” Do not guess, use `/tmp`, use
  `TMPDIR`, or create a repository-child/sibling worktree first.
- After the operator answers, create the local file, validate/create the
  container, and use `<container>/<repository-slug>-<lane-slug>` for manual
  worktrees. If validation fails, stop and report the boundary failure.
- A worker or subagent must not start a second orchestrator workflow or create a
  nested worktree when a parent harness/orchestrator already owns the lane.

The durable details live in `docs/contracts/002-agent-local-paths.md`.

## Compression Rule

For internal work artifacts such as batch cards, roadmaps, logs, and contracts:

- keep the structure compact and high-signal;
- cut filler and ceremonial transitions;
- prefer clear bullets and short factual statements where they remain readable.

Do not apply artifact compression to normal thread conversation. Threads should
retain natural connective language rather than becoming dry status reports.

Do not apply that style blindly to public-facing docs that need fuller prose.
See `docs/policy/internal-writing-style.md`.
