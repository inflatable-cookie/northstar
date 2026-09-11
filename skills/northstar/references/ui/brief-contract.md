# UI design brief contract

Agent-facing field list for the `northstar-ui` skill. The canonical task or
governing spec owns the brief. The worker handoff carries a self-contained
execution copy under `## Important Context` as `### UI Design Brief`.

## Classification

Classify by decision risk and user impact, not file count:

| Class | Meaning | Required depth |
| --- | --- | --- |
| Refinement | Local correction inside an established workflow and pattern | Compact brief; prototype normally unnecessary |
| Workflow change | New or altered actions, navigation, forms, state transitions, or information hierarchy | Full brief with current and target workflows; material choices settled before readiness |
| Substantial redesign | New or materially replaced user experience | Full brief plus operator-approved concept, comp, or interactive prototype before readiness |

Plan at the highest class a lane contains.

## Full brief fields

A field may be marked inapplicable with a reason. Generic filler does not
satisfy it.

1. Problem and evidence.
2. User, goal, and operating situation.
3. Current workflow: entry, actions, responses, decisions, friction, recovery,
   completion.
4. Target workflow: ideal path, progressive information, actions, feedback,
   recovery, completion.
5. Presentation direction: governing design authority, reference surfaces,
   density, hierarchy, tone, focal point, rhythm, intentional character.
6. Required states and realistic content ranges.
7. Device, viewport, input, zoom, motion, and assistive-technology envelope.
8. Reuse, platform, performance, copy, and preservation constraints.
9. Concept or prototype evidence and selected direction when required.
10. Scenario oracle: start state, actions, visible feedback, outcome, negative
    or recovery case, required rendered evidence.
11. Open decisions and stop conditions.

## Compact brief fields

For a refinement only:

- affected user;
- current and target behavior;
- governing pattern;
- state or viewport impact;
- scenario oracle;
- stop conditions.

## Readiness rules

- A workflow change is not ready while an experience decision remains open.
- A substantial redesign is not ready without operator-selected concept
  evidence at a stable project path with recorded identity.
- Rejected variants are non-authoritative.
- A planning-only design delegate may gather requirements, map workflows, and
  propose materially different concepts, but cannot implement production code
  or grant readiness; the operator selects the direction.
