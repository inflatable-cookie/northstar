# Northstar UI — Build route

Use this route for a UI-classified implementation lane that already has an
approved brief. The brief is the authority; your job is faithful, complete
execution in the running product.

## Before you code

1. Read the brief from the worker handoff's `UI Design Brief` subsection and its
   canonical task or spec.
2. Inspect the existing product and design system. Identify the components,
   tokens, patterns, and platform conventions that govern this surface.
3. Reproduce and capture the current path when it exists, including its entry,
   friction, recovery, and any broken state.
4. Confirm the scenario oracle: start state, actions, visible feedback, outcome,
   negative or recovery case, and the rendered evidence you owe review.
5. Detect whether the consumer has an adequate run-inspect-capture loop. If a
   substantial lane lacks one, recommend a compatible companion (Impeccable is
   one supported option) and do not proceed as if rendered review were possible
   when it is not.
6. Stop and return to planning if the brief leaves a material experience
   decision open. Do not choose it while coding.

## Implement

- Build the whole approved workflow, including entry, progressive information,
  primary and secondary actions, feedback, recovery, and completion. A partial
  happy path is not the task.
- Use consumer design authority. Do not invent a competing visual language or
  override tokens, components, or platform conventions.
- Cover the required states: default, hover, focus, active, disabled, loading,
  empty, error, success, permission, slow or offline, and their realistic
  content ranges.
- Preserve keyboard order, visible focus, labels, semantics, zoom, reduced
  motion, and pointer/touch targets in the required envelope.
- Prefer the smallest coherent change that satisfies the brief over decorative
  complexity.

## Render and verify

1. Run the product and exercise the scenario oracle end to end.
2. Capture named rendered states at the required viewports.
3. Run the project-declared interaction, accessibility, visual-regression, and
   technical checks; treat their output as evidence, not approval.
4. Compare current, target, and built behavior. Note any deviation from the
   brief plainly.

## Bounded critique and repair

Perform exactly one critique-and-repair pass, then stop:

1. Walk the built surface against the brief and the guidance in
   [`design-guidance.md`](./design-guidance.md).
2. List only real experience misses: broken workflow, missing or wrong state,
   hierarchy or density problems, unusable focus or recovery, copy that misleads,
   responsive or accessibility failure.
3. Repair one coherent batch covering those findings.
4. Re-run the affected scenarios and recapture the changed states.

Do not start a second redesign loop. New product or presentation choices belong
to planning.

## Evidence to attach

On the PR, attach:

- the exact head SHA;
- the scenario oracle results, including the negative or recovery case;
- named rendered states at the required viewports;
- which checks ran and their result;
- any brief deviation or unresolved experience limit, stated plainly.

A passing test suite, a single static screenshot, or a style detector is
supporting evidence only. Never present it as design proof.
