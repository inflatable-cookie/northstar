# Operator Workflow Drill

Use this drill when you need to test or maintain the Northstar operator stack
itself. This is not part of the normal day-to-day operator path inside a
healthy repo.

## Goal

Exercise the full Northstar operator loop and identify which docs are actually
needed in practice:

`sweep -> choose entry point -> planning/refocus -> roadmap compile -> handoff`

## When To Run It

- after changing operator docs, prompts, or skill routing
- before rolling the stack into another repo
- when you suspect the operator surfaces have become redundant or confusing

## Drill Setup

Pick one of these:

1. This Northstar repo using the seeded specimens
2. A consumer repo with Northstar docs already installed

For a real external pilot, prefer a repo that:

- already has a live Northstar docs spine and active roadmap lane
- uses Effigy as the normal operator front door
- is complex enough that routing and closeout decisions are non-trivial
- is stable enough that the pilot will expose Northstar friction rather than
  repo chaos
- has a real current task the operator can route toward a valid next batch

## Drill Steps

### Step 1: Start From Quick Start Only

Open only:

- [operator-quick-start.md](/Users/betterthanclay/Dev/projects/northstar/bundle-docs/operators/operator-quick-start.md)

Task:

- decide what you would do first if an operator said:
  “Refocus this drifting project under Northstar and get me back to a valid next
  batch.”

Expected result:

- you route to sweep/refocus, not roadmap compilation

### Step 2: Route Using Minimal Support Docs

Open only if needed:

- [operator-quick-start.md](/Users/betterthanclay/Dev/projects/northstar/bundle-docs/operators/operator-quick-start.md)

Task:

- confirm which skill or prompt you would use

Expected result:

- `northstar-recover` or `project-refocus-starter-prompt.md`

If you needed more than the quick start plus one support page, note that.

### Step 3: Run The Recovery Path

Use:

- [live-project-refocus-specimen.md](/Users/betterthanclay/Dev/projects/northstar/bundle-docs/operators/live-project-refocus-specimen.md)

Task:

- trace the in-place repair path
- trace the `g02` rollover path
- confirm you can tell when to choose one versus the other

Expected result:

- localized seam repair -> in-generation recompile
- broad sequencing invalidation -> `g02` rollover

### Step 4: Confirm Roadmap Compilation Boundary

Use:

- [SKILL.md](/Users/betterthanclay/Dev/projects/northstar/skills/northstar-plan/SKILL.md)

Task:

- answer whether “lay out the next few roadmaps” should compile milestones now
  or first repair planning

Expected result:

- compile only when planning is already coherent and contract-backed

### Step 5: Confirm Handoff Readiness

Use:

- [SKILL.md](/Users/betterthanclay/Dev/projects/northstar/skills/northstar-handoff/SKILL.md)

Task:

- decide whether you can hand the work to another thread yet

Expected result:

- handoff happens only after there is one bounded next batch with clear
  contract refs and evidence requirements

## What To Record

After the drill, note:

- which page you actually started from
- the order of pages opened before reaching the first valid next batch
- which extra pages you needed before you could act confidently
- which pages felt duplicative
- where routing was still ambiguous
- whether the quick start was enough on its own
- whether any false start or wrong entry point had to be corrected
- how long it took to reach a valid next batch rather than just a first guess

Use:

- [operator-pilot-record-template.md](/Users/betterthanclay/Dev/projects/northstar/bundle-docs/maintenance/operator-pilot-record-template.md)
- [operator-doc-pruning-rubric.md](/Users/betterthanclay/Dev/projects/northstar/bundle-docs/maintenance/operator-doc-pruning-rubric.md)

## Success Criteria

- an operator can choose the right entry point in under 2 minutes
- an operator can distinguish planning, replan, roadmap compile, and refocus
  without guessing
- an operator can tell when handoff is appropriate
- redundant pages become obvious enough to merge or trim

## Next task

Run this drill only when maintaining the Northstar operator stack, then push
the results back into the simpler operator front door.
