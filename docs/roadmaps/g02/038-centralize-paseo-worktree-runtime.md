# 038 - Centralize Paseo Worktree Runtime

Status: complete
Owner: repo maintainers
Created: 2026-08-31
Depends on: `g02.037`, contract `001-working-rules`, Effigy external skill task runner
Vision tags: `orchestration`, `portability`, `control-plane`, `worktrees`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`
Planning state: card 106 complete

## Problem

The first Paseo project adapter copied a Northstar-owned Rhai helper into every
consumer and registered it as a local Effigy task. That duplicates runtime code,
makes upgrades project-by-project, and confuses project configuration with
Northstar implementation ownership.

Two live control-plane gaps also need explicit rules. Required sibling repos
must exist in the generated worktree's container directory before project setup
uses relative paths. Posting requested changes to a PR does not wake a finished
Paseo worker, so review must explicitly resume the originating agent.

## Goals

- [x] ship the worktree helper once inside the installed Northstar skill;
- [x] invoke it from consumer `paseo.json` through `effigy skill run` while the
  consumer remains the runtime target;
- [x] use the consumer's real idempotent setup task between prepare and replay;
- [x] require sibling links in the worktree container directory before setup;
- [x] require a Paseo follow-up to the originating agent after requested changes;
- [x] let an orchestrator merge its accepted, checks-passing worker PR without a
  second operator approval prompt;
- [x] dogfood the boundary in Figmatic without a copied helper or local task.

## Non-goals

- no mandatory Paseo dependency for Northstar;
- no ambient skill-name discovery or stored machine-specific absolute path;
- no replacement worker when the originating review thread is unavailable;
- no weaker review/check gate, worker merge authority, or standalone-review
  merge authority.

## Execution plan

Card `g02.038/106` moves the helper into the published skill catalog, rewrites
the project starter and adoption guidance, updates the orchestration invariants,
promotes accepted-review/check-gated orchestrator merge authority, then proves
Figmatic setup against an Effigy binary with external skill task execution.

## Acceptance criteria

- [x] the installed Northstar skill lists and runs `paseo:worktree` against a
  separate consumer root;
- [x] Northstar and Figmatic `paseo.json` files contain no copied-helper task or
  no-argument `effigy bootstrap` assumption;
- [x] Figmatic prepares both Longhorn and Poodle in the worktree container before
  `effigy setup`;
- [x] orchestration docs retain agent identity and call `send_agent_prompt`
  after a changes-requested review;
- [x] an accepted orchestrator review of the exact current head plus passing
  checks authorizes merge without another operator prompt;
- [x] skill validation, lifecycle self-test, docs QA, and relevant repo QA pass.

## Next task

No automatic follow-on card. Return to generation planning or accept the next
operator-provided live-use correction.
