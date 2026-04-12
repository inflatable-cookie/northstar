---
name: northstar-plan
description: Use when a project needs Northstar planning work before or around execution. Handles plan-from-scratch coverage, provisional specs, promotion into architecture and contracts, and roadmap compilation from approved canonical surfaces without exposing those as separate top-level skills.
---

# Northstar Plan

Use this skill when the user asks to:

- plan a product or program in Northstar before implementation starts
- decompose a multi-repo system into explicit responsibilities and contracts
- tighten agent guardrails so roadmap work cannot outrun planning
- shape a complex change in specs before promoting the settled result
- lay out the next few roadmaps or milestones from completed planning
- sequence the next batches from approved contracts
- write or repair the contract surfaces a roadmap depends on

## Outcome

Leave the repo with coherent planning surfaces, promoted canonical artifacts,
and roadmap work that does not invent missing system behavior or claim
readiness prematurely.

Use this skill when the work is still fundamentally about planning.
If the plan was valid but changed, route to `northstar-recover`.
If the current project state is stale or contradictory, route to
`northstar-recover`.

## Quick Start

Inspect the active Northstar surface first:

```sh
effigy tasks
effigy doctor
```

Then read:

- `README.md`
- `AGENTS.md`
- `docs/vision/`
- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md` when present
- `docs/specs/` when present
- `docs/specs/archive/README.md` when present
- `docs/contracts/contract-index.md`
- `docs/roadmaps/`
- [`references/modes/plan-from-scratch.md`](./references/modes/plan-from-scratch.md)
- [`references/modes/shape-with-specs-and-promote.md`](./references/modes/shape-with-specs-and-promote.md)
- [`references/modes/compile-roadmaps.md`](./references/modes/compile-roadmaps.md)

## Workflow

1. Diagnose which planning mode is actually needed: plan from scratch, shape a
   change in specs and promote it, repair contract surfaces, or compile
   roadmaps from already-approved canonical surfaces.
   Name the repo posture first: `baseline-routing`, `strict-ready`,
   `strict-paused`, `migration`, or `drifted`.
2. If planning coverage is still missing, use
   [`references/modes/plan-from-scratch.md`](./references/modes/plan-from-scratch.md)
   and complete the architecture, inventory, authority, and contract surfaces.
3. If the change still needs provisional planning, use
   [`references/modes/shape-with-specs-and-promote.md`](./references/modes/shape-with-specs-and-promote.md)
   and promote settled outcomes into architecture/contracts before treating the
   work as roadmap-ready.
4. If the boundaries are known but the contract surface is thin, write or
   update the needed contracts before drafting roadmap work.
5. If planning is already coherent, use
   [`references/modes/compile-roadmaps.md`](./references/modes/compile-roadmaps.md)
   and compile only work backed by architecture and contracts. Mark cards or
   short chains as `ready` only when they satisfy the repo's explicit
   readiness rubric and continuation-envelope rules. Leave a bounded runway,
   not just one next card.
6. Surface planning gaps instead of writing speculative roadmap or execution
   work.
7. If planning is needed but the next direction is still materially ambiguous,
   stop and ask the user for intent instead of manufacturing certainty.
8. Leave one explicit next task in the planning chain.
9. If the repo is `strict-paused`, treat the immediate goal as resolving the
   paused gate cleanly instead of pretending execution is one card away.
10. If the repo is `strict-ready`, keep the next move pointed at the ready
    card or explicit ready chain rather than reopening planning by habit.
11. Keep specs only while they still help the active lane; once promotion is
   complete, treat them as provisional history and archive or remove them when
   they no longer add value.
12. Leave the specs folder tidier than you found it when stale specs are now
   clearly outlived by the promoted canonical surfaces.
13. Make lifecycle decisions explicit when a lane closes: keep the artifact
    active only if it still governs live work, use `retired-in-place` only for
    short-lived traceability, and otherwise move it into
    `docs/specs/archive/` or remove it.
14. If a card or short chain may auto-continue, make the continuation envelope
    explicit in file state: the in-bounds next card, the remaining ready chain,
    and the proof each transition depends on.
15. When a card closes, refresh any front-door currentness surfaces that still
    name the active lane, current ready card, or recent evidence chain. A
    completed card must not still appear as the active ready card anywhere.
16. Make the `Next Task` explicit enough that a later bare `continue` can
    resolve through file state without needing a recap prompt.
17. When planning a material lane, make the higher-level lane owner, the next
    few meaningful batches or milestone transitions, and the next planning
    checkpoint explicit so execution does not fall back into one-card
    improvisation after each closeout.
18. In operator-facing summaries, lead with the achieved planning outcome, the
    current lane state, and the next move. Keep validation and protocol detail
    short.
19. Use glue-light, compressed writing for internal planning artifacts and chat
    output unless the task is explicitly public-facing or explanatory.

## Required Outputs

Depending on the active mode, leave some or all of these surfaces materially
advanced:

- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md` for multi-repo work
- `docs/specs/NNN-<slug>.md` and `docs/specs/batch-cards/NNN-<slug>.md` when a
  change needs provisional planning
- `docs/specs/archive/README.md` or archived planning artifacts when closeout
  moved closed work out of the active tree
- `docs/contracts/contract-index.md`
- new or updated contract files for active roadmap dependencies
- new or updated roadmap milestones under `docs/roadmaps/gNN/`
- ready batch-card or short-chain state that is visibly justified in file state
- visible lane runway state beyond the immediate ready card for any material
  active lane
- explicit continuation-envelope state when a ready chain is allowed to keep
  going without operator intervention

## Guardrails

- Do not start roadmap execution to discover missing system behavior.
- Do not treat unplanned repos or interfaces as implied by context.
- Do not mark planning complete while `pending` or unknown authorities still
  govern active roadmap scope.
- Do not let roadmap prose substitute for a contract.
- Do not let a spec remain the only place that durable structure or behavior is
  defined once the change is ready for execution.
- Do not leave stale specs acting like shadow authority after the canonical
  surfaces already carry the truth.
- Do not let `docs/specs/` accumulate stale closed-lane plans indefinitely if
  they no longer help the active repo.
- Do not ignore `docs/specs/archive/` when lifecycle decisions or preserved
  planning history still matter to the active lane.
- Do not mark a card or chain `ready` if it still depends on fresh planning
  judgment during execution.
- Do not stop planning at one immediate card when the lane clearly needs a
  longer-horizon owner, batch sequence, or planning checkpoint.
- Do not guess the user's intent when multiple plausible planning directions
  remain open; ask instead of churning through speculative planning.
- Do not imply that a chain may continue just because cards exist in sequence;
  continuation must be explicitly bounded in file state.
- Do not leave currentness surfaces advertising stale authority after closeout,
  especially a completed card still shown as the current ready card.
- Do not leave a vague `Next Task` that forces the operator to restate the lane
  in chat before work can continue safely.
- Do not expose roadmap compilation as if it were separate from the rest of the
  planning spine; it is a planning mode, not a different operating model.
- Do not let the operator-facing summary collapse into card ids, file churn,
  and long validation dumps with the real outcome hidden underneath.
- Do not waste tokens on filler prose in internal planning surfaces when dense
  operator-facing language would say the same thing more clearly.

## Next Step

After the relevant planning mode is complete, either promote the settled
outcomes into architecture/contracts or compile the next valid milestones from
those canonical surfaces.
