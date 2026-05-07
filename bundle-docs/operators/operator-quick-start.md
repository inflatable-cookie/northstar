# Operator Quick Start

Use this page when you want to decide what to do next without wading through
the rest of the docs.

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

- No real planning yet -> `northstar-plan`
- Planning is sound and you want the next milestones or next valid batch -> `northstar-plan`
- The plan used to be right but changed -> `northstar-recover`
- The project has drifted and the current state is messy -> `northstar-recover`
- Research needs to become architecture or contracts -> `northstar-research`
- Another thread needs a clear continuation brief -> `northstar-handoff`

## If You Want Clear Prompting, Say It Plainly

- “Plan this system before we build” -> `northstar-plan`
- “Lay out the next few roadmaps from the current contracts” -> `northstar-plan`
- “Replan this after the contract change” -> `northstar-recover`
- “Refocus this project under Northstar” -> `northstar-recover`
- “Turn this memo into contracts” -> `northstar-research`
- “Create a handoff for the next thread” -> `northstar-handoff`

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
