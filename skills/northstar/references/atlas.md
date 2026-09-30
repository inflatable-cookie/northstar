# Atlas

Atlas shapes a project's long-horizon direction with the operator: why it
exists, where it's going, and which outcomes come first. Use it when the plan
has run out of settled direction, a choice will outlast the next few tasks, or
the operator asks to step back. Don't use it for a change the plan already
settles; plan it as a lane instead.

Atlas is the operator's direction, not the agent's. Repository knowledge is
evidence to test with them, never permission to extend the strategy yourself.

## Order

1. **Name the question.** State the project and the horizon, then separate what
   the operator has said from what is unknown. Don't fill a missing destination.
2. **Read for context.** Read `vision.md`, `architecture.md`, `questions.md`,
   the Queue plan and its lane documents, and open leads. Look for tensions
   and vocabulary, not a prescription.
3. **Ask, then stop.** End the first turn with a discovery checkpoint and
   nothing more:
   - what you understand (target, horizon, the operator's stated direction);
   - what the evidence says, including contradictions;
   - what is unknown;
   - a few high-leverage questions: why this exists, who it serves, the future
     state that would make it worthwhile, the hard constraints, and what it is
     explicitly not.
   Record them as a Queue decision too. Don't offer a horizon model, options or
   a recommended direction yet.
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

Atlas is read-only until the operator asks to record the result. Then:

- outcomes, constraints and non-goals go to `docs/knowledge/vision.md`;
- system shape and invariants go to `docs/knowledge/architecture.md`, durable
  rules to `docs/knowledge/contracts/`;
- decisions still open go to `questions.md`;
- each outcome being pursued becomes a Queue lane with a lane document, and the
  order goes into the project plan (`plan.set`); deferrals become leads. See
  [plan](plan.md).

No roadmap, runway file, or Atlas-specific record. Atlas never briefs,
dispatches or approves work: that follows through the normal plan and brief
flow once the lanes exist.
