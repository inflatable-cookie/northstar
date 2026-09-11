# Translation Memo: UI Design Planning And Delivery

Status: promoted to spec 039 and task `g03.004`
Owner: repo maintainers
Last Updated: 2026-09-11
Related spec: `docs/specs/039-ui-design-planning-and-delivery.md`
Promotion targets: Chatterbox mode, worker handoff contract, UI skill, review mode

## Problem

Northstar can send a technically bounded UI task to a worker while leaving the
actual experience underspecified. The worker then decides the workflow,
information hierarchy, states, and presentation while coding. A conventional
diff review happens too late to correct weak product design cheaply.

The main repair belongs before dispatch. A UI skill can improve execution, but
it cannot recover a missing user model or an unmade interaction decision.

## Evidence reviewed

Sources were retrieved on 2026-09-11.

- Anthropic's
  [frontend-design skill](https://github.com/anthropics/claude-code/blob/main/plugins/frontend-design/skills/frontend-design/SKILL.md)
  starts from purpose, audience, content, and an explicit aesthetic direction.
  It asks the agent to plan structure and presentation before implementation,
  reject generic defaults, and inspect screenshots during the build.
- [Impeccable](https://github.com/pbakaus/impeccable) separates durable product
  and design-system truth from a surface brief. Its shaping flow asks a small
  number of high-value questions, classifies the visitor's job, inspects the
  current visual authority, chooses comp-first or code-first deliberately, and
  uses a bounded render-inspect-repair loop. Its audit material also covers
  empty, loading, error, permission, overflow, responsive, keyboard, touch, and
  reduced-motion behavior.
- Vercel's
  [Web Interface Guidelines](https://github.com/vercel-labs/web-interface-guidelines)
  provide a useful mechanical review floor for semantics, labels, keyboard and
  focus behavior, forms, recovery, content ranges, responsive behavior, URL
  state, and actionable errors.
- The Design Council's
  [Double Diamond](https://www.designcouncil.org.uk/resources/the-double-diamond/)
  separates understanding and defining the problem from developing and testing
  alternatives.
- GOV.UK guidance says to
  [map the user's whole problem](https://www.gov.uk/service-manual/design/map-a-users-whole-problem),
  observe current behavior and frustration, and test the service across its
  interaction path rather than treating screens as isolated artifacts.
- W3C WAI recommends
  [integrating accessibility throughout the project](https://www.w3.org/WAI/planning-and-managing/)
  instead of applying it at final review.
- Anthropic's
  [product-design report](https://www-cdn.anthropic.com/58284b19e702b49db9302d5b6f135ad8871e7658.pdf)
  describes designers turning mockups into functional prototypes, mapping
  system and error states during design, and shortening the design-engineering
  feedback loop.

## Translation

Adopt the process, not a house aesthetic. Northstar should not prescribe a
visual style or supersede a consumer repository's design system. It should
require the decisions and evidence that let a worker execute a deliberate
design.

Use one UI planning path with three depths selected by decision risk and user
impact:

1. **Refinement**: a local correction inside an established pattern. Use a
   compact brief. A prototype is normally unnecessary.
2. **Workflow change**: a new action, form, state transition, navigation path,
   or information hierarchy. Require a full brief with current and target
   workflows. Resolve material choices before readiness.
3. **New or substantial redesign**: require the full brief plus a concept or
   prototype checkpoint before the task becomes ready.

File count is a poor proxy. A one-file checkout change can alter a critical
workflow, while a broad token migration can preserve it.

## UI design brief

The canonical task or strict spec should own the full brief. The worker handoff
should carry a self-contained execution copy under `Important Context` as
`UI Design Brief`. This preserves the existing seven-section handoff contract
while ensuring the worker does not reconstruct the design from scattered docs.

The brief should cover:

1. **Problem and evidence**: the observed failure, affected surface, and why it
   matters.
2. **User and situation**: goal, frequency, prior knowledge, constraints, and
   likely pressure or state of mind.
3. **Current workflow**: entry point, numbered actions, system responses,
   decisions, friction, dead ends, recovery, and success signal.
4. **Target workflow**: the ideal path, progressive information, primary and
   secondary actions, feedback, recovery, and completion.
5. **Presentation direction**: governing design system and references, density,
   hierarchy, tone, focal point, rhythm, and the intentional idea that gives the
   surface character.
6. **States and content ranges**: default, hover, focus, active, disabled,
   loading, empty, error, success, permission, slow or offline behavior, plus
   short, typical, long, missing, and localized content where relevant.
7. **Device and input envelope**: required viewports or native sizes, keyboard,
   pointer, touch, zoom, reduced motion, and assistive technology expectations.
8. **Constraints and reuse**: components, tokens, platform conventions,
   performance limits, factual copy, and preserved surfaces.
9. **Concept evidence**: alternatives considered, selected direction, operator
   decision, and stable artifact paths or identities when a checkpoint applies.
10. **Scenario oracle**: start state, user actions, visible feedback, expected
    outcome, at least one important negative or recovery case, and the rendered
    evidence required for review.
11. **Open decisions and stop conditions**: anything the worker must not invent.

The brief is a decision record, not a long design essay. Omit inapplicable
fields explicitly or compress them; do not fill them with generic prose.

## Chatterbox behavior

For UI work, Chatterbox should:

1. inspect the running current UI when it exists, rather than infer the
   experience from code alone;
2. walk the current user workflow and retain screenshots or equivalent evidence;
3. ask only questions that change the workflow, hierarchy, or presentation;
4. describe the ideal user path before choosing implementation structure;
5. identify the consumer design system and platform conventions that govern it;
6. write the brief and its scenario oracle;
7. use a concept or prototype checkpoint for substantial work;
8. promote only the selected direction and leave rejected variants
   non-authoritative; and
9. withhold readiness while a worker would still need to invent a material
   product or design decision.

## Design delegate and prototype checkpoint

A substantial UI lane may use a planning-only design delegate. Its job is to
interview, inspect, map flows, and produce two or three materially different
structures. It does not own production implementation.

Choose the lightest artifact that resolves the risk: annotated screenshots, a
flow or wireframe, high-fidelity comps, or a disposable interactive prototype.
Operational software often needs an interactive prototype because feedback,
focus, state, and recovery are part of the design. If the operator already
provides a precise approved design, another prototype adds no value.

Any artifact needed by the worker or reviewer must move to a stable project
path with its identity recorded. A chat image or temporary preview is not
durable authority.

## UI skill

Add one provider-neutral `northstar-ui` skill with build and review routes.

The build route should consume the approved brief, inspect the existing product
and design system, implement the complete workflow, render the result, perform
one bounded self-critique, repair a coherent batch, and confirm the scenario
oracle. Its compact guidance should cover hierarchy, layout, typography, color,
icons, copy, feedback, accessibility, responsiveness, state coverage, content
ranges, motion, and common model-generated UI failures.

The review route should independently inspect the running exact PR head. It
should exercise the expected workflow, states, viewports, and input paths, then
publish UI findings beside code findings. Passing tests, a static screenshot,
or a generic style detector cannot prove the experience is good.

Impeccable may remain an optional external tool. Northstar should not depend on
its command vocabulary, hooks, detector, or parallel `PRODUCT.md` and
`DESIGN.md` authority surfaces.

## Delivery and review evidence

A UI worker should:

1. reproduce and capture the current path;
2. implement the approved brief;
3. exercise the scenario oracle in the running product;
4. capture named after-states at required viewports;
5. compare current, target, and built behavior;
6. run project-declared interaction, accessibility, visual, and technical checks;
7. perform one bounded self-critique and repair pass; and
8. attach exact-head rendered evidence to the PR.

The reviewer must inspect the running exact head. A material workflow,
hierarchy, state, accessibility, or presentation miss blocks acceptance even
when the diff is technically correct.

## Northstar and Effigy boundary

Northstar owns brief structure, readiness, the UI skill, handoff transport,
scenario oracles, evidence requirements, and review posture. The consumer
repository owns product truth, its design system, and its visual language.

Effigy may discover and run consumer-declared preview, journey, accessibility,
and visual-regression commands. Northstar should not add a universal renderer
or treat a deterministic detector as design approval.

## Proposed adoption sequence

1. Freeze a strict UI planning and delivery spec.
2. Promote durable readiness, handoff, and exact-head review rules into their
   existing authorities.
3. Add the `northstar-ui` skill and route UI-marked worker and review work to it.
4. Extend task and handoff templates without changing the seven top-level
   handoff sections.
5. Add narrow structural fixtures for classification and brief presence while
   keeping qualitative judgment with people and agents.
6. Dogfood one refinement and one substantial workflow change. Use a prototype
   checkpoint for the substantial case and exact-head rendered review for both.
7. Reconcile the evidence before making stronger defaults or integrating an
   external detector.

## Success signals

- Workers no longer invent material workflow or visual choices while coding.
- UI PRs carry current and target workflows plus exact-head rendered proof.
- Independent review catches experience failures before merge.
- Operator correction moves to planning and prototype review.
- Small UI fixes remain quick.
- Rework caused by vague intent and missing states falls across dogfood runs.

## Promotion decision

The operator selected the provider-neutral skill, an approved brief plus a
concept or prototype checkpoint for substantial work, and canonical task or
spec ownership with a self-contained handoff copy. Spec 039 freezes those
choices; `g03.004` is the bounded implementation lane.
