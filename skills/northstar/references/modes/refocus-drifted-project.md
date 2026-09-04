# Refocus Drifted Project Mode

Use this mode when the current planning or roadmap state is stale,
contradictory, or otherwise not trustworthy enough to assume a valid base.

## Goal

Leave the project with coherent planning surfaces again and a trustworthy
active roadmap queue.

## Steps

1. Audit the live planning and execution surfaces before editing.
2. Classify the starting lifecycle state first and explain why it is no longer
   trustworthy enough to leave as-is.
3. Identify drift explicitly: stale milestones, stale specs, missing contracts,
   repo authority ambiguity, research that never promoted, and logs that hide
   planning failures.
4. Rebuild or repair `system-architecture.md`, `system-inventory.md`,
   `repo-authority-map.md`, and `contract-index.md`.
5. Rebuild the active spec lane when it no longer matches the canonical
   architecture/contracts.
6. Archive or remove stale specs when they only preserve a broken story instead
   of helping the active lane.
7. Mark invalid roadmap work blocked or superseded instead of trying to keep it
   limping forward.
8. Create contract deltas or new contracts for the real boundaries now shaping
   execution.
9. Recompile the active roadmap or open a new generation when the old sequence
   is no longer trustworthy.
10. Leave a clear next task pointing to the first newly valid batch or remaining
   planning blocker.

## Guardrails

- Do not preserve stale roadmap prose just because it already exists.
- Do not preserve stale spec lanes once the canonical surfaces moved on.
- Do not let implementation continue against a fake or implied contract.
- Do not collapse multiple repos into one owner to simplify the story.
- Do not treat refocus work as cosmetic cleanup; it must change execution
  authority.
