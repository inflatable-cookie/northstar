# Spec 039: UI Design Planning And Delivery

Status: approved for `g03.004`
Owner: repo maintainers
Created: 2026-09-11
Research: `bundle-docs/research/translation-memos/ui-design-planning-and-delivery.md`

## Problem

Northstar UI tasks can reach workers without a settled user workflow,
information hierarchy, state model, or presentation direction. The worker then
designs while coding, and review catches weak experience decisions after the
most expensive part of the delivery loop.

## Goal

Move material UI design decisions into Chatterbox planning. Give workers a
self-contained approved brief and a compact provider-neutral implementation
skill. Require independent review of the running exact PR head against the
expected user workflow.

## Frozen decisions

1. Northstar ships a provider-neutral `northstar-ui` skill. Impeccable and
   similar tools remain optional aids.
2. UI work is classified by decision risk and user impact:
   - **refinement** preserves an established workflow and pattern;
   - **workflow change** alters actions, navigation, forms, states, or
     information hierarchy;
   - **substantial redesign** creates or materially replaces a user experience.
3. Refinement gets a compact UI design brief. Workflow change gets a full brief.
   Substantial redesign gets a full brief plus an operator-approved concept,
   comp, or interactive prototype checkpoint before readiness.
4. The canonical task or governing spec owns the full brief. The worker handoff
   carries a self-contained execution copy inside `Important Context` under
   `UI Design Brief`. The existing seven top-level handoff sections do not
   change.
5. Chatterbox inspects the running current surface when it exists, maps the
   current workflow, defines the target workflow, identifies design authority,
   and settles material decisions before marking a UI task ready.
6. A planning-only design delegate may gather requirements, map workflows, and
   produce materially different concepts. It cannot implement production code
   or grant readiness. The operator selects the direction.
7. Artifacts needed after the planning thread must live at a stable project
   path with recorded identity. Rejected variants are non-authoritative.
8. The worker implements the whole approved workflow, exercises its scenarios
   in the running product, captures named rendered states, performs one bounded
   critique-and-repair pass, and attaches exact-head evidence to the PR.
9. An independent reviewer exercises the running exact PR head. Material
   workflow, hierarchy, state, accessibility, responsive, or presentation
   failures block acceptance. Diff review, tests, screenshots, and deterministic
   style checks are supporting evidence only.
10. The consumer repository owns product truth, components, tokens, platform
    conventions, and visual language. Northstar owns the planning, handoff,
    skill, readiness, scenario, evidence, and review protocol.
11. Effigy may discover and run consumer-declared preview, journey,
    accessibility, and visual-regression selectors. Northstar does not require a
    universal renderer or treat a detector as design approval.

## UI design brief contract

The full brief contains the following fields. A field may be marked
inapplicable with a reason; generic filler does not satisfy it.

1. Problem and evidence.
2. User, goal, and operating situation.
3. Current workflow: entry, actions, responses, decisions, friction, recovery,
   and completion.
4. Target workflow: ideal path, progressive information, actions, feedback,
   recovery, and completion.
5. Presentation direction: governing design authority, reference surfaces,
   density, hierarchy, tone, focal point, rhythm, and intentional character.
6. Required states and realistic content ranges.
7. Device, viewport, input, zoom, motion, and assistive-technology envelope.
8. Reuse, platform, performance, copy, and preservation constraints.
9. Concept or prototype evidence and selected direction when required.
10. Scenario oracle: start state, actions, visible feedback, outcome, negative
    or recovery case, and required rendered evidence.
11. Open decisions and stop conditions.

For a refinement, Chatterbox may compress the brief to the affected user,
current and target behavior, governing pattern, state or viewport impact,
scenario oracle, and stop conditions.

## Planning flow

1. Inspect the repository's current design authority and run the current UI.
2. Walk and capture the real current workflow.
3. Classify the lane and ask only questions that change the experience.
4. Define the ideal workflow before implementation structure.
5. For substantial work, use the lightest concept artifact that resolves the
   risk and obtain operator selection.
6. Promote the selected direction into the spec or task and write its scenario
   oracle.
7. Compile the self-contained handoff copy. Stop if the worker would still need
   to invent a material experience decision.

## Skill behavior

`northstar-ui` exposes two routes:

- **Build**: inspect the brief and current product, implement the complete
  workflow using consumer design authority, render required states, exercise
  the scenario oracle, perform one bounded critique and repair batch, then
  publish exact-head evidence.
- **Review**: independently run the exact PR head, exercise the workflow,
  states, viewports, and input paths, and publish actionable experience findings
  beside code findings.

The skill gives compact guidance for hierarchy, layout, typography, color,
icons, copy, feedback, accessibility, responsiveness, states, content ranges,
motion, and recurring model-generated UI failures. It must not impose a
universal aesthetic.

## Required proof

- A refinement fixture proves the compact path does not require a prototype.
- A workflow-change fixture proves the full brief and scenario oracle reach the
  worker handoff.
- A substantial fixture fails readiness without selected concept evidence and
  passes after operator selection is represented.
- Handoff fixtures preserve the seven-section contract and include the
  self-contained UI brief under `Important Context`.
- Build and review skill fixtures distinguish exact-head rendered inspection
  from test-only or screenshot-only claims.
- Source, installed skill, template, and minimal-starter surfaces agree.
- `effigy qa:docs`, `effigy qa`, and `git diff --check` pass.

The fixtures prove protocol wiring, not aesthetic quality. Record findings from
the first natural refinement and substantial consumer lanes before tightening
the protocol further.

## Stop conditions

Stop for Chatterbox if implementation would create a competing product/design
authority, change the seven-section handoff shape, make an external design tool
mandatory, require Northstar to own a renderer, or reduce rendered review to a
deterministic approval score.

