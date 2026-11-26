---
name: atlas
description: Shape a project's long-horizon direction with the operator. Use when settled direction has run out, a strategic or product choice will outlast the current plan, or the operator asks to step back and decide where the project is going.
---

# Atlas

Atlas covers why a project exists, where it's going, and which outcomes
come first. Don't use it for a change the current plan already settles.

Atlas is the operator's direction, not the agent's. Repository knowledge is
evidence to test with them, never permission to extend the strategy yourself.

## Order

1. **Read for context.** Read whatever states the project's purpose and shape:
   the README, `docs/knowledge/vision.md` and `architecture.md` when the
   project uses `northstar-docs`, and whatever plan or backlog it keeps. Look
   for tensions and vocabulary, not a prescription.
2. **Name the question.** State the project and the horizon, then separate what
   the operator has said and the project already settles from what is
   unknown. Don't fill a missing destination.
3. **Resolve gaps.** When a material question remains, summarise the direction
   so far and ask what would settle it. Check purpose, audience, desired
   outcome, constraints and non-goals. Pause where an answer is needed.
4. **Guide if they don't know.** If the operator isn't sure, offer
   first-principles prompts. If the aim still isn't ready, say Atlas is
   premature and stop; never make a strategy up to fill the gap.
5. **Reflect.** Restate the direction in the operator's words, marking each part
   confirmed, provisional or unknown, and ask for corrections.
6. **Options, only when asked or clearly useful.** A few distinct options with
   trade-offs, dependencies and non-goals. Recommend one only if asked.
7. **Synthesize the confirmed direction** into outcomes, their order and
   dependencies, accepted uncertainty and non-goals.

## Where it lands

Atlas is read-only until the operator asks to record the result. Then split
it by how long it stays true:

- **Durable direction** (purpose, constraints, non-goals, system invariants)
  goes to the project's static docs. With `northstar-docs`, that's
  `vision.md`, `architecture.md` and `contracts/`.
- **Ordered outcomes and open decisions** go to the project's planning
  surface: its task system, issue tracker, or the planning document it
  already keeps.

If the project has no home for either, ask the operator where it should live.
Don't create a docs structure or a new file unasked; adopting `northstar-docs`
is an option to offer, not a default.

No roadmap or Atlas-specific record. Atlas never plans tasks,
dispatches or approves work; that follows through the project's normal flow.
