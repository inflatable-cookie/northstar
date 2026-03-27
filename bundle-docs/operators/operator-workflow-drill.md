# Operator Workflow Drill

Use this drill to test the quick-start stack in a realistic sequence without
waiting for a live incident.

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

For the cleanest first pass, use the seeded specimen set in this repo.

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

- [skills/northstar-plan/SKILL.md](/Users/betterthanclay/Dev/projects/northstar/skills/northstar-plan/SKILL.md)

Task:

- answer whether “lay out the next few roadmaps” should compile milestones now
  or first repair planning

Expected result:

- compile only when planning is already coherent and contract-backed

### Step 5: Confirm Handoff Readiness

Use:

- [skills/northstar-handoff/SKILL.md](/Users/betterthanclay/Dev/projects/northstar/skills/northstar-handoff/SKILL.md)

Task:

- decide whether you can hand the work to another thread yet

Expected result:

- handoff happens only after there is one bounded next batch with clear
  contract refs and evidence requirements

## What To Record

After the drill, note:

- which page you actually started from
- which extra pages you needed before you could act confidently
- which pages felt duplicative
- where routing was still ambiguous
- whether the quick start was enough on its own

Use:

- [operator-pilot-record-template.md](/Users/betterthanclay/Dev/projects/northstar/bundle-docs/operators/operator-pilot-record-template.md)
- [operator-doc-pruning-rubric.md](/Users/betterthanclay/Dev/projects/northstar/bundle-docs/operators/operator-doc-pruning-rubric.md)

## Success Criteria

- an operator can choose the right entry point in under 2 minutes
- an operator can distinguish planning, replan, roadmap compile, and refocus
  without guessing
- an operator can tell when handoff is appropriate
- redundant pages become obvious enough to merge or trim

## Next task

Run this drill against a real consumer repo and trim or merge any operator docs
that did not materially help the decision path.
