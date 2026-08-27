# Northstar

Northstar is a reusable documentation and execution system for agent-led
projects. It gives direction, architecture, durable rules, planned work, and
evidence distinct homes so an agent can act without reconstructing intent from
conversation history. This repository is the source of that system.

## What must stay true

- Keep `template-bundle/` copy-ready. It is starter material for another
  project, not a showcase for Northstar-specific examples.
- Keep `bundle-docs/` about reusable doctrine. Northstar's own implementation
  decisions belong under `docs/`.
- Preserve one authority chain: vision and research inform architecture and
  contracts; roadmaps sequence approved work; logs prove what happened; triage
  only holds unresolved leads.
- Prefer direct, legible systems over compatibility theatre. Before 1.0, update
  callers and remove superseded surfaces together. After 1.0, preserve stable
  user-visible contracts by default.
- Write for a human collaborator. Be short and blunt, but keep the connective
  reasoning that makes a decision understandable. The full house style is in
  `docs/policy/internal-writing-style.md`.

## How work moves here

In this repo, normal-mode agents work in the current checkout and follow the
task's canonical docs. Worker mode exists only when an
orchestrator-dispatched handoff says so; never infer it from a worktree, branch
name, or harness.

Work in meaningful batches. Start from the governing contract, spec, or ready
card and leave the planning and evidence chain coherent when the batch ends.
Unresolved notes in `docs/triage/` are leads to promote or remove, never
execution authority.

## Sharp edges

- Do not edit `.github/workflows/` or run release mutations without an explicit
  operator request. These operations can affect published or shared state.
- If a refactor breaks callers, contracts, or documented behavior, stop with a
  short impact summary and options. Do not hide the decision behind a shim or
  silent fallback.
- Do not let a current task, log, or conversational note become a second source
  of truth. Promote durable meaning to its canonical home.

## Finding your way

Start with `effigy tasks`. Use `effigy doctor` only when routing or environment
state is unclear; it is orientation, not the validation board. Prefer
`effigy <task>` and `effigy graph` over raw package-manager commands, and use
`--repo <PATH>` only when operating on another repository. Do not add
`package.json` scripts that merely re-export Effigy tasks.

The main front doors are:

- `docs/README.md` for Northstar's live project state;
- `bundle-docs/protocol-kernel.md` for the reusable system and authority map;
- `template-bundle/README.md` for copy-ready adoption surfaces;
- `skills/northstar/SKILL.md` for routed agent workflows;
- `docs/contracts/001-working-rules.md` for delivery and closeout;
- `docs/contracts/003-agent-instruction-surface.md` for AGENTS design.

Read the owning surface when the task enters it. Its detail outranks this map.

## What complete means

Run `effigy qa` for normal validation and `effigy qa:docs` when documentation
changes. `effigy check:agent-instructions` is an advisory evidence pass, not a
prose-quality score. `effigy check:posture-advisory` is the optional docs-drift
check described in `scripts/README.md`.

If you hit a small, recurring, solvable hurdle, record it in `PAPERCUTS.md`
under the working-rules contract and continue the scoped task. Do not turn the
observation into unplanned work.

Stop and ask when canonical planning does not settle the next direction, when a
breaking choice needs operator intent, or when validation fails in a way that
changes the plan. A bare `continue` stays inside the current bounded lane; it is
not permission to invent the next one.
