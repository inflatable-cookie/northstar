# Plan

Updated: 2026-09-26

## Now

1. **Finish the lean rollout** (lane `lean-northstar`). The skill swap,
   Northstar's own cut and the hook-bridge removal have landed. Remaining:
   drop the `northstar-lean` install once the Chatterbox repositories have
   renamed their references.
2. **Move planning to Queue** (lane `lean-northstar`). When Queue ships
   planning records (Nucleus contract 002), import each repository's
   `docs/plan.md` and `docs/triage/`, delete them, retire them, and rewrite the
   skill's plan and triage guidance, as was done for papercuts.

## Next

- Reshape the optional modules (UI, language packages) to the lean shape and
  settle Q-002. The consumer-rerun test lost its Jetstream fixture when
  Jetstream's lean cut removed its TypeScript quality marker; give it a
  self-contained fixture.
- Fold recurring shell-guidance papercuts into the skill's worker guidance.

## Not now

- A knowledge manifest with typed links and suspect-link detection. It may
  belong to Nucleus; revisit after the cheaper mechanisms prove out.
- A first tagged release (Q-001).
