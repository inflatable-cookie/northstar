# System Architecture

Status: active
Owner: repo maintainers
Updated: 2026-08-16
Vision refs: docs/vision/001-northstar-delivery-vision.md

## Top-Level Stack

- `bundle-docs/`
  is the doctrine authority for how Northstar is supposed to work
- `template-bundle/`
  is the copy-ready product artifact that downstream repos adopt
- `skills/`
  is the installable behavior surface for agent workflows
- `docs/`
  is the live Northstar planning spine for developing this repo itself
- `scripts/` plus `effigy`
  provide repo validation and maintenance checks
- published skill updates use the Skills CLI; source checkouts can verify an
  installed skill with the local parity checker
- root `PAPERCUTS.md`
  records small, solvable execution friction for later maintenance

## Data and Authority Flow

- Vision in `docs/vision/` sets the destination for Northstar's next evolution.
- Architecture plus a compact working-rules contract define the rules the repo
  should follow while changing itself.
- Specs and batch cards in `docs/specs/` define the detailed path for material
  changes.
- Roadmaps in `docs/roadmaps/` sequence approved work.
- Logs in `docs/logs/` provide batch-level evidence.
- Agents append execution friction to root `PAPERCUTS.md`; maintenance promotes
  repeated or material items into the normal planning spine.
- `bundle-docs/`, `template-bundle/`, and `skills/` should be updated from this
  planning spine rather than by ad hoc repo edits.
- published skill propagation and source/install parity should remain explicit
  so multi-harness installs do not depend on manual operator memory.

## Thread topology

For material work that benefits from a separate implementation context, the
preferred split is:

`operator ↔ orchestrator thread -> canonical plan/runway -> worker thread/worktree -> PR -> orchestrator review -> merge/closeout`

The orchestrator owns question-led discovery, promoted planning, ready-state,
launch preparation, and review. The worker owns only the assigned ready cards in
its dedicated worktree and branch. The operator relays reports and PR URLs while
Northstar remains independent of provider-specific session messaging.

The durable boundary is the repository: architecture, contracts, specs, roadmap
cards, one committed worker handoff under `docs/handoffs/`, pushed `main`, commits,
validation, and PR review. Private model conversation is not an authority surface.
A worker launch is valid only after the planning checkout has published `main`
and the operator has a repository-relative handoff path to give the new thread.

## Invariants

- `bundle-docs/` remains the doctrine authority for the reusable system.
- `template-bundle/` remains generic and copy-ready; repo-specific planning
  lives in `docs/`, not in the bundle.
- `docs/` is the authority for Northstar's own development process.
- Material delivery work should flow through contracts, master specs, batch
  cards, roadmaps, and logs rather than jumping straight from idea to edits.
- The public skill surface should remain small and deliberately routed.
- Before dispatch, the planning checkout must publish canonical planning state
  and one concrete worker handoff under `docs/handoffs/` on `main`; local-only
  state is not a valid worker base.
- The worker handoff is exactly one repository-relative path; no second prompt or
  copied private context is required.
- Orchestrator and worker threads must use separate worktree/branch boundaries;
  a worker may not edit the orchestrator's planning checkout.
- A worker's completion authority is a reviewable PR plus evidence, not a chat
  claim. The orchestrator reviews the diff and checks against canonical refs.
- Provider-native subagents, session messaging, and hosted agents are optional
  adapters, not Northstar protocol dependencies.
- Papercuts remain an observation queue, not a competing planning authority or
  automatic work queue.

## Performance and Reliability Constraints

- Operator-facing docs should stay readable and direct.
- The repo should default to manual, concrete evidence before adding more
  automation.
- Validation should stay cheap enough that batch-level checks remain normal.
- Autonomy should increase only when the repo's planning artifacts make it safe.

## Interfaces With Roadmaps

- `g01.001` uses this architecture to enact Northstar on Northstar and pilot
  the delivery layer inside this repo.
