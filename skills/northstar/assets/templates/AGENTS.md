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

For the end-of-turn closeout or meaningful checkpoint reply:

- lead with what was actually achieved
- then state the current lane state
- mention validation only if it failed or materially affects confidence
- then state the next move
- keep protocol detail brief and secondary

Do not make the operator infer the real outcome from card ids, file lists, or
long validation dumps.

## Compression Rule

For internal work surfaces and normal thread replies:

- use glue-light, compressed writing
- cut filler and ceremonial transitions
- prefer dense bullets and short factual statements

Do not apply that style blindly to public-facing docs that need fuller prose.
See `docs/policy/internal-writing-style.md`.
