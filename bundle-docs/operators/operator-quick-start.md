# Operator Quick Start

Use this page when you want to decide what to do next without wading through
the rest of the docs.

For the **one-page map** from posture to canonical doctrine files (before you
open long sections), read [`../protocol-kernel.md`](../protocol-kernel.md), then
[`../visual-map.md`](../visual-map.md) if you still need the hierarchy picture.

## Start With The Real First Question

Is this repo healthy and actively moving, or unclear and drifting?

### Healthy And Active

If the repo already has live docs and an active roadmap lane:

1. open the repo docs front door
2. open the generation index
3. open the active milestone
4. open the latest relevant log
5. use the governing contracts only when the milestone or log points at them

This is the shortest normal path to a valid next batch.

### Unclear, Missing, Or Drifted

If you cannot trust the current state:

- if contracts, authority, or system coverage are missing, the project still
  needs planning
- if the roadmap exists but no longer feels trustworthy, it needs recovery
- if you are not sure which of those is true, run the sweep pack first

- [sweeps/README.md](../sweeps/README.md)
- [08-planning-gate-sweep.md](../sweeps/08-planning-gate-sweep.md)

## Then Choose The Right Kind Of Work

Invoke the **`northstar`** skill and open
[`skills/northstar/references/router.md`](../../skills/northstar/references/router.md)
to pick one mode:

- No real planning yet -> planning: `plan-from-scratch`
- Existing project, planning quality uncertain -> planning readiness review:
  `northstar planning readiness review`
- Existing project, all Northstar facets need checking -> project refresh:
  `northstar refresh`
- Active codebase seam or architecture pressure -> architecture refocus:
  `northstar architecture refocus`
- Sound planning; need milestones or batches -> planning: `compile-roadmaps`
- Plan was right but changed -> recovery: `replan-after-change`
- Drifted or messy state -> recovery: `refocus-drifted-project` or `sweep-audit-repair`
- Research -> contracts/architecture -> `research`
- Bootstrap, migrate, or spine hygiene -> `normalize-docs`
- **Explicit** continuation brief / fresh thread -> `handoff` only (not bare `continue`)

## If You Want Clear Prompting, Say It Plainly

- “Plan this system before we build” -> `northstar` (plan-from-scratch)
- “Refresh this project under Northstar” -> `northstar` (project-refresh)
- “Refocus this subsystem's architecture” -> `northstar` (architecture-refocus)
- “Run a planning readiness review on this existing project” -> `northstar`
  (planning-readiness-review)
- “Lay out the next few roadmaps from the current contracts” -> `northstar` (compile-roadmaps)
- “Replan this after the contract change” -> `northstar` (replan-after-change)
- “Refocus this project under Northstar” -> `northstar` (refocus-drifted-project)
- “Turn this memo into contracts” -> `northstar` (research)
- **Create an orchestrator runway and worker PR loop** -> `northstar` (orchestrator mode)

In this mode, the orchestrator commits and pushes the planning state and one
worker handoff under `docs/handoffs/` before dispatch. The new worker thread
receives only the repository-relative path to that handoff; no second prompt or
copied context is needed.
- “Create a handoff for the next thread” -> `northstar` (handoff mode)

Handoff mode writes a plain-spoken note to `docs/handoffs/YYYYMMDD-HHMMSS-<slug>.md`
and returns its absolute path. The operator should pass that path to the next
thread rather than copying the whole note into chat.

If humans are going to reuse the same opener across multiple threads, use:

- [strict-planning-starter-prompt.md](./strict-planning-starter-prompt.md)
- [project-refocus-starter-prompt.md](./project-refocus-starter-prompt.md)

## If You Need An Example

- Use [live-project-refocus-specimen.md](./live-project-refocus-specimen.md)
  to see what recovery looks like in practice.

## If You Are New To Northstar

Start here instead of wading through all docs:

1. [Visual Map](../visual-map.md) -- one-page overview of how everything fits
2. [Glossary](../glossary.md) -- terminology reference
3. [Cheat Sheet](../cheat-sheet.md) -- naming conventions and quick rules

## Normal Loops

Healthy active repo:

`repo docs -> generation index -> active milestone -> latest log -> next batch`

Drifted or unclear repo:

`sweep -> choose entry point -> repair/complete planning -> compile roadmap -> execute batch -> log -> handoff`

## Maintenance-Only Support

These are for maintaining Northstar itself, not for normal repo operation:

- [maintenance/README.md](../maintenance/README.md)

## Next task

Validate whether the new visual map and glossary actually reduce the time from
"open repo" to "start next batch" for active operators.
