# Shape With Specs And Promote Mode

Use this mode when a change is too large or uncertain to go straight into
architecture/contracts, but should not stay a spec forever.

## Goal

Use specs as a provisional planning layer, then promote the settled outcomes
into architecture and contracts before roadmap execution relies on them.

## Steps

1. Create or update a master spec when the goal spans multiple meaningful
   batches or still has open design questions.
2. Break the immediate path into batch cards when execution needs a tightly
   bounded, paint-by-numbers flow.
3. Use the spec to expose open questions, stop conditions, validation needs,
   and promotion targets.
4. Promote durable structural outcomes into architecture once they are accepted.
5. Promote durable behavioral or policy rules into contracts once they are
   accepted.
6. Once promotion is complete, decide whether the spec should stay as active
   planning history or be archived/removed because it no longer adds value.
7. Compile or update roadmap milestones only after the canonical surfaces are
   ready enough to govern execution.

## Guardrails

- Do not let the spec become a second permanent architecture surface.
- Do not leave durable rules only in the spec once execution depends on them.
- Do not leave obsolete specs in place if they only create shadow authority.
- Do not compile roadmap work directly from raw spec text when promotion is due.
