---
name: atlas
description: Shape a project's long-horizon direction with the operator. Use when settled direction has run out, a choice will outlast the next few tasks, or the operator asks to step back and decide where the project is going.
---

# Atlas

Atlas shapes a project's long-horizon direction with the operator: why it
exists, where it's going, and which outcomes come first. Use it when the plan
has run out of settled direction, a choice will outlast the next few tasks, or
the operator asks to step back. Don't use it for a change the current plan
already settles.

Atlas is the operator's direction, not the agent's. Repository knowledge is
evidence to test with them, never permission to extend the strategy yourself.

## Order

1. **Name the question.** State the project and the horizon, then separate what
   the operator has said from what is unknown. Don't fill a missing destination.
2. **Read for context.** Read whatever states the project's purpose and shape:
   the README, `docs/knowledge/vision.md` and `architecture.md` when the
   project uses `northstar-docs`, and whatever plan or backlog it keeps. Look
   for tensions and vocabulary, not a prescription.
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

Atlas is read-only until the operator asks to record the result. Then use the
first home that applies:

1. **The project uses `northstar-docs`** (it has `docs/knowledge/` with a
   `vision.md`): outcomes, constraints and non-goals go to `vision.md`; system
   shape and invariants to `architecture.md`; durable rules to `contracts/`.
2. **Otherwise, the project's planning surface:** its task system's plan or
   lane documents, an issue tracker, or the planning document it already
   keeps.
3. **Neither:** ask the operator where the direction should live. Don't create
   a docs structure or a new file unasked; adopting `northstar-docs` is an
   option to offer, not a default.

Whatever the home, decisions still open and the outcomes being pursued, with
their order, belong to the planning surface, not to static docs.

No roadmap, runway file or Atlas-specific record. Atlas never plans tasks,
dispatches or approves work; that follows through the project's normal flow.
