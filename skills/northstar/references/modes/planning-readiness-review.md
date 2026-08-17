# Planning Readiness Review

Use this mode for an existing project when the operator wants to know whether
its planning is coherent enough to continue, without starting implementation.
The concise trigger is `northstar planning readiness review`.

## Default posture

This is a read-only review unless the operator explicitly asks for planning
repair. Do not edit production code, create a worker lane, mark a roadmap card
ready, or compile new execution work during the review.

Name the repository posture:

- `baseline-routing`
- `strict-ready`
- `strict-paused`
- `migration`
- `drifted`

## Review procedure

1. Read the repository front door, `AGENTS.md`, `docs/README.md`, the generation
   index, the active roadmap, and the latest relevant log.
2. Run the repository's cheap orientation and deterministic planning checks when
   available. Do not treat a green repository-health check as proof that planning
   is complete.
3. Inspect the planning gate surfaces:
   - `docs/architecture/system-architecture.md`;
   - `docs/architecture/system-inventory.md`;
   - `docs/architecture/repo-authority-map.md` when multiple repos or deployable
     surfaces are involved;
   - `docs/contracts/contract-index.md` and the contracts governing the active
     roadmap;
   - active specs, milestones, batch cards, and recent logs;
   - research promotion records and destination-local readiness maps when they
     exist.
4. Compare the active roadmap against those surfaces. Report exact gaps with
   file paths, including missing repos, interfaces, authority owners, contracts,
   promoted decisions, validation surfaces, or unresolved scope.
5. Classify the planning state and choose exactly one next route:
   - **planning incomplete:** use strict planning / `plan-from-scratch`;
   - **planning stale or contradictory:** use recovery / refocus or a planning
     sweep, freezing affected execution first;
   - **bounded destination still materially ambiguous:** use readiness mapping,
     intent rounds, project language, research, prototypes, or questionnaires;
   - **planning coherent:** use roadmap compilation rather than repeating the
     planning exercise;
   - **architecture drift in an active lane:** use architecture refocus, then
     promote any durable outcome through the normal planning gates.
6. State whether the next valid action is repair, recompile, discovery, or
   execution. Do not silently choose one for the operator.

## Is planning up to scratch?

The planning is up to scratch only when:

- every active roadmap area is represented in the architecture and inventory;
- cross-repo authority and ownership are explicit where applicable;
- active seams have governing contract references;
- research-backed decisions are promoted into architecture or contracts;
- missing planning is visible as a blocker rather than hidden in roadmap prose;
- the next batch has bounded scope, acceptance, validation, evidence, and stop
  conditions;
- no unresolved decision still governs the scope of the proposed next batch.

A clear review does not authorize execution by itself. Normal spec, promotion,
roadmap, readiness, validation, handoff, and operator gates still apply.

## Output

Return a compact review containing:

- posture;
- planning verdict: `incomplete`, `drifted`, `materially ambiguous`, or
  `coherent`;
- exact gaps and canonical files involved;
- the single recommended next route;
- whether execution is blocked;
- the next operator decision or action.

Do not produce a large questionnaire when a repository fact or deterministic
check can answer the issue. Keep unresolved operator decisions visible and route
them to the canonical decision records rather than resolving them in prose.
