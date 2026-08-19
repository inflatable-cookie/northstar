# AGENTS

Scope: whole `northstar/` repository.

## Always-loaded boundaries

- This repository is the authority for the reusable Northstar documentation
  system. Keep `template-bundle/` copy-ready and `bundle-docs/` focused on bundle
  doctrine; do not add project-specific examples to either surface casually.
- Before 1.0, do not add compatibility aliases, shims, wrappers, or silent
  fallbacks. Update references and remove superseded symbols together. If a
  staged migration or breaking choice is needed, stop and ask the operator.
  After 1.0, preserve stable user-visible contracts by default and surface any
  unavoidable break with impact and options.
- In this repo, normal-mode agents use the current checkout and follow the
  task's canonical docs. Worker mode is activated only by an explicit
  orchestrator-dispatched handoff; read that handoff for its worker execution
  contract instead of inferring worker mode from a path, branch, or harness.
- When planning or docs work surfaces unresolved threads, inspect `docs/triage/`
  and treat its notes as leads to promote or remove, never as execution authority.
- Do not edit `.github/workflows/` or run release mutations without an explicit
  operator request.

## Common commands

- Start with `effigy tasks`; use `effigy doctor` only when routing or environment
  state is uncertain. Doctor is orientation, not the full validation board.
- Prefer `effigy <task>` and `effigy graph` for code understanding before raw
  package-manager or shell commands. Use `--repo <PATH>` only for another repo.
- Do not add `package.json` scripts that merely re-export Effigy tasks.

## Validation

- Normal validation: `effigy qa` and, for documentation changes, `effigy qa:docs`.
- The instruction-surface review is `effigy check:agent-instructions`; it is
  advisory and read-only.
- Optional docs-drift check: `effigy check:posture-advisory` (see
  `scripts/README.md`).
- During execution, record a small recurring solvable hurdle in `PAPERCUTS.md`
  under `docs/contracts/001-working-rules.md`; do not turn it into unplanned work.

## Stop and read

- If the canonical roadmap, contract, or ready-card surfaces do not settle the
  next direction, stop and ask instead of guessing. Continuation stays inside the
  current bounded lane.
- Read `docs/contracts/001-working-rules.md` for delivery, readiness, closeout,
  and papercut policy; `docs/contracts/003-agent-instruction-surface.md` for
  root-versus-scoped instruction policy.
- Read `docs/README.md`, `bundle-docs/protocol-kernel.md`,
  `template-bundle/README.md`, or `skills/northstar/SKILL.md` when the task
  enters those surfaces. Their detailed rules are authoritative over this
  summary.
