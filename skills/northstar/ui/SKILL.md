---
name: northstar-ui
description: Build and review UI work against an approved design brief.
---

# Northstar UI

Provider-neutral execution skill for UI tasks that already have an approved
design brief. It gives you two routes and no house aesthetic.

- **Build**: implement the complete approved workflow in the running product,
  exercise the scenario oracle, capture named rendered states, perform one
  bounded critique-and-repair pass, and attach exact-head rendered evidence.
- **Review**: independently run the exact PR head, exercise the workflow,
  states, viewports, and input paths, and publish actionable experience findings
  beside code findings.

## When the routes apply

Use them only for a task that ships a rendered interface a reviewer can run:
an app screen, or a component with a preview surface such as a story or
playground. A repository or task with no rendered surface is class None in
`references/ui/brief-contract.md`. It needs no UI brief, and its review is the
standard one (`references/review.md`) against the repository's own validation.
Don't stop for a missing rendered surface when none is meant to exist.

Load exactly one route from the main `northstar` package (a flattened
`northstar-ui` install still resolves these paths there):

- Build → `references/ui/build.md`
- Review → `references/ui/review.md`

Both routes use:

- `references/ui/brief-contract.md` for brief fields and classification depth;
- `references/ui/design-guidance.md` for compact execution guidance and common
  model-generated UI failures.

## Authority boundaries

- The consumer repository owns product truth, components, tokens, platform
  conventions, and visual language. This skill never overrides them.
- The approved brief is the design authority: the `## UI design brief` section
  of the task's Queue brief, plus the lane document or knowledge file it links.
  Do not redesign the workflow, invent missing states, or choose an open
  presentation direction.
- A passing test suite, lint pass, static screenshot, or style detector is
  supporting evidence, never design approval.
- This skill does not own a renderer. Use the consumer's declared preview,
  journey, accessibility, and visual-regression surfaces when they exist.
- When the running interface cannot actually be inspected, stop and report the
  missing capability instead of claiming rendered review.

## Companion capability

Before build or review, detect whether the consumer already has an adequate
run-inspect-capture loop. For substantial UI work, when that capability is
missing, recommend a compatible companion and name Impeccable as one supported
option without requiring it. Never depend on a companion's command vocabulary,
hooks, or parallel `PRODUCT.md`/`DESIGN.md` authority surfaces; consumer design
truth stays in the task's brief, the repository's knowledge and its design
system.
