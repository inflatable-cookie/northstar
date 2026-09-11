# Northstar UI — Review route

Use this route when an independent reviewer must judge the experience of a UI
PR, not just its diff. Review the running exact PR head. When this route cannot
run the interface, the review is incomplete.

## Setup

1. Resolve the PR and the exact head SHA. Work only against that head; a moved
   head invalidates the verdict.
2. Confirm the worktree is clean and do not edit tracked files, commit, push, or
   change branches.
3. Read the approved brief from the canonical task or spec and the handoff's
   `UI Design Brief`. Treat the brief as acceptance authority.
4. Detect whether the consumer has an adequate run-inspect-capture loop. If the
   required rendered path cannot actually be exercised, stop and report the
   blocker rather than approving from the diff.

## Exercise the running head

- Start the product at the PR head. Do not review from a screenshot as the only
  surface.
- Walk the expected workflow from entry to completion as the brief describes.
- Exercise each required state, including empty, loading, error, permission,
  slow or offline, and success.
- Exercise short, typical, long, missing, and localized content where the brief
  requires it.
- Exercise the required viewports, zoom, keyboard order, focus visibility,
  pointer and touch input, reduced motion, and assistive-technology paths.
- Exercise the scenario oracle's negative or recovery case.

## Findings

Publish UI findings beside code findings on the provider review surface. Post
every required change on the PR; chat is only a summary.

A blocking UI finding names a material failure in one of:

- workflow or navigation;
- information hierarchy, density, or focal point;
- state coverage, feedback, or recovery;
- accessibility or input behavior;
- responsive or viewport behavior;
- presentation that contradicts the approved brief.

State the observed behavior, the brief's expectation, the affected state or
viewport, and the condition that would resolve it. Separate optional taste from
merge-blocking experience misses.

## What does not accept a UI PR

- a green test suite;
- a single static screenshot;
- a passing style or accessibility detector;
- a code diff that looks reasonable without running the interface.

These may support a verdict. They never replace rendered inspection. Classify
blocking findings with the shared codes (`execution-miss`, `oracle-gap`,
`planning-change`, `validation-gap`, `integration-drift`); a `planning-change`
returns to planning before revision.

## Verdict

Post one coherent verdict naming the exact reviewed head SHA. When no blocking
UI finding exists, say which workflow, states, viewports, and input paths you
actually exercised so the evidence is checkable.
