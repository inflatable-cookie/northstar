# 11 UI Design Planning and Delivery

Status: active
Updated: 2026-09-11

## Why this section matters now

UI tasks can be bounded and still ship a weak product. When worker scope names
files and acceptance but not the user workflow, information hierarchy, states,
or presentation direction, the worker invents those decisions while coding. Diff
review then catches experience failures after the most expensive part of the
loop. Northstar moves material design decisions into planning, gives the worker
a self-contained approved brief, and requires independent review of the running
result.

This section governs the reusable protocol. It does not define an aesthetic.

## Scope

Cover UI planning classification, the design brief, the readiness and prototype
gate, the planning-only design delegate, handoff transport, the worker build
route, rendered evidence, and the independent review route. It does not define
consumer product truth, component libraries, tokens, platform conventions, or
visual language.

## Product and protocol boundary

- The consumer repository owns product truth, design-system authority,
  components, tokens, platform conventions, and visual language.
- Northstar owns classification, brief structure, readiness, handoff transport,
  the `northstar-ui` skill, scenario oracles, evidence requirements, and review
  posture.
- Northstar does not own a renderer, a design score, or a universal aesthetic.
  A deterministic detector, lint pass, or screenshot diff is a structural floor,
  never design approval.

## UI classification

Classify UI work by decision risk and user impact, not by file count. A one-file
checkout change can alter a critical workflow; a broad token migration can
preserve one.

| Class | Meaning | Required planning depth |
| --- | --- | --- |
| Refinement | A local correction inside an established workflow and pattern | Compact UI design brief; a prototype is normally unnecessary |
| Workflow change | New or altered actions, navigation, forms, state transitions, or information hierarchy | Full UI design brief with current and target workflows; material choices settled before readiness |
| Substantial redesign | A new or materially replaced user experience | Full brief plus an operator-approved concept, comp, or interactive prototype checkpoint before readiness |

When a lane spans classes, plan at the highest class it contains.

## UI design brief contract

The canonical task or governing spec owns the full brief. A field may be marked
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
9. Concept or prototype evidence and the selected direction when required.
10. Scenario oracle: start state, actions, visible feedback, outcome, negative or
    recovery case, and required rendered evidence.
11. Open decisions and stop conditions.

A refinement may compress the brief to the affected user, current and target
behavior, governing pattern, state or viewport impact, scenario oracle, and stop
conditions. The skill's `references/ui/brief-contract.md` carries the
agent-facing field list; the canonical task or spec remains the durable home.

## Planning flow

Chatterbox, or the active planning route, performs this before a UI task is
marked ready:

1. Inspect the repository's current design authority and run the current UI when
   it exists; do not infer the experience from code alone.
2. Walk and capture the real current workflow, including its friction and
   recovery paths.
3. Classify the lane and ask only questions that change the experience.
4. Describe the ideal user workflow before choosing implementation structure.
5. For substantial work, use the lightest concept artifact that resolves the
   risk and obtain operator selection.
6. Promote the selected direction into the spec or task and write its scenario
   oracle.
7. Compile the self-contained handoff copy. Stop if the worker would still need
   to invent a material experience decision.

An unresolved material design choice is an intent checkpoint: the task is not
ready.

## Concept checkpoint and design delegate

A substantial UI lane may use a planning-only design delegate. It gathers
requirements, inspects the current surface, maps workflows, and produces two or
three materially different structures. It cannot implement production code,
grant readiness, or select the direction. The operator selects the direction.

Use the lightest artifact that resolves the risk: annotated screenshots, a flow
or wireframe, high-fidelity comps, or a disposable interactive prototype.
Operational software often needs an interactive prototype because feedback,
focus, state, and recovery are part of the design. If the operator already
provides a precise approved design, another prototype adds no value.

Any artifact the worker or reviewer needs must live at a stable project path
with recorded identity. A chat image or temporary preview is not durable
authority. Rejected variants are non-authoritative.

## Handoff transport

The seven-section handoff shape does not change. A UI worker handoff carries a
self-contained execution copy inside `## Important Context` under
`### UI Design Brief`, bound back to its canonical spec or task. The worker must
not reconstruct the approved experience from planning history or a diff.

## Worker delivery

For UI-marked work, the worker routes through the `northstar-ui` skill's Build
route:

- reproduce and capture the current path when it exists;
- implement the complete approved workflow using consumer design authority;
- exercise the scenario oracle in the running product;
- capture named rendered states at the required viewports;
- run project-declared interaction, accessibility, visual, and technical
  checks;
- perform one bounded critique-and-repair pass, then stop; and
- attach exact-head rendered evidence to the PR.

The worker does not redesign an approved workflow, invent missing states, or
treat a passing test suite as experience proof.

## Independent review

An independent reviewer loads the `northstar-ui` Review route and inspects the
running exact PR head. It exercises the expected workflow, states, viewports, and
input paths, and publishes UI findings beside code findings. Material workflow,
hierarchy, state, accessibility, responsive, or presentation failures block
acceptance even when the diff is technically correct. Tests, screenshots, and
deterministic style checks are supporting evidence only.

## Companion execution capability

Projects doing meaningful UI work should provide an Impeccable-like execution
capability: run and inspect the real interface, capture required states and
viewports, exercise interaction and accessibility paths, and retain rendered
evidence. The planning route discovers existing capability. For substantial work
it recommends a compatible companion when capability is missing, naming
Impeccable as one supported option rather than a dependency. Readiness blocks
only when the required design or rendered validation cannot actually be
performed.

Northstar does not depend on a companion's command vocabulary, hooks, detector,
or parallel `PRODUCT.md`/`DESIGN.md` authority surfaces. Consumer design truth
stays in the canonical task, spec, and repository design system.

## Effigy boundary

Effigy may discover and run consumer-declared preview, journey, accessibility,
and visual-regression selectors. Northstar adds no universal renderer and treats
no detector as design approval. Repositories without those selectors rely on
operator- or agent-driven running inspection and retained rendered evidence.

## Deterministic floor

The protocol's own fixtures prove wiring and classification. They cannot prove
aesthetic quality. Record findings from the first natural refinement and
substantial consumer lanes before tightening the protocol further, and never
replace rendered review with a score.

## Stop conditions

Stop for the planning authority when implementation would:

- create a competing product or design authority;
- change the seven-section handoff shape;
- make an external design tool mandatory;
- require Northstar to own a renderer; or
- reduce rendered review to a deterministic approval score.

## Required proof

- A refinement fixture proves the compact path does not require a prototype.
- A workflow-change fixture proves the full brief and scenario oracle reach the
  worker handoff.
- A substantial fixture fails readiness without selected concept evidence and
  passes once operator selection is represented.
- Handoff fixtures preserve the seven-section contract and include the
  self-contained brief under `Important Context`.
- Build and review skill fixtures distinguish exact-head rendered inspection
  from test-only or screenshot-only claims.
- Source, installed skill, template, and minimal-starter surfaces agree.

## Dependencies

- [07 Delivery Framework and Autonomy](./07-delivery-framework-and-autonomy.md)
  defines task readiness, the review oracle, and review finding classification.
- [06 Planning and Contract Gates](./06-planning-and-contract-gates.md) defines
  the planning gap and execution authority rules this section extends for UI.
- [`skills/northstar/references/handoff-contract.md`](../../skills/northstar/references/handoff-contract.md)
  owns handoff content and placement.

## Quick reference

- Skill: [`skills/northstar/ui/SKILL.md`](../../skills/northstar/ui/SKILL.md)
- Brief contract: [`skills/northstar/references/ui/brief-contract.md`](../../skills/northstar/references/ui/brief-contract.md)
- Glossary: [UI classification, UI design brief, design delegate](../glossary.md#planning-and-control)

## Next task

Dogfood one refinement and one substantial workflow change on operator-supplied
consumer lanes and reconcile the evidence before tightening any default.
