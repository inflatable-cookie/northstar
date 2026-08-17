# Project Refresh Mode

Use this mode for the single short request `northstar refresh` (also accepted as
`northstar project refresh`). It is the general Northstar maintenance loop for
an existing project: inspect every planning and agent-facing facet, repair clear
staleness, and route unresolved work to the right internal mode.

This is a normal-mode operation. In normal-mode worktree checks are not part of
this mode. Do not inspect worker-local path configuration, start an orchestrator,
or create a worker/worktree. A refresh can run in the current checkout using the
repository's normal operating context.

## Purpose

Bring the current project back to a trustworthy Northstar state without blindly
rewriting its docs or starting implementation. The refresh is broader than an
AGENTS review or planning-readiness review, but it reuses those modes rather than
copying their procedures.

## Refresh loop

1. **Identify the target.** Confirm the repository root, repository identity,
   local `AGENTS.md`/`CLAUDE.md`, Northstar posture, docs authority, active
   generation, and current task. Do not infer a consumer target from the
   Northstar source checkout when an explicit target is available.
2. **Check the instruction surface.** Review root and relevant nested
   `AGENTS.md` files, the Claude bridge, command ordering, stop rules, and
   canonical pointers. Route instruction-surface findings through the AGENTS
   review mode. Normal-mode guidance must not contain worker-only startup rules.
3. **Check the docs spine.** Verify the front doors, architecture, inventory,
   repo authority, contract index, specs/archive posture, roadmaps, logs,
   handoffs, policy, Effigy wiring, and any required local-path contracts. Use
   normalize-docs only for structural or spine repair.
4. **Check architecture and authority.** Compare the current architecture and
   inventory with active repositories, services, interfaces, ownership, tests,
   validation surfaces, and recent changes. Surface missing or contradictory
   boundaries; do not invent system behavior. A codebase architecture-improvement
   loop is not silently substituted here: if active-code architecture review is
   needed and no bounded route exists, report it as a follow-up gap.
5. **Check planning completeness.** Run the planning-readiness review over the
   active spec, readiness maps, decision records, contracts, research promotion,
   roadmap milestones, batch cards, and recent logs. Confirm that the next
   executable batch has current refs, bounded scope, acceptance, validation,
   evidence, and stop conditions.
6. **Check currentness and closeout.** Reconcile roadmap/current-task pointers,
   completed or stale cards, latest logs, handoffs, papercuts, and unresolved
   decisions. Do not treat a stale pointer or an old handoff as current authority.
7. **Check validation and distribution.** Run only the repository's cheap
   orientation and relevant deterministic checks during the review. Run full QA
   when changes are made or the repository contract requires it. For the
   Northstar source repo, verify installed-skill parity; for a consumer repo,
   verify the target-local checks without pretending it is the Northstar source.
8. **Repair or route.** Apply only bounded, evidence-backed documentation,
   planning, or instruction-surface repairs that are clearly in scope. Route
   material ambiguity, missing contracts, research gaps, architecture drift, or
   execution work to exactly one existing mode. Never use refresh to smuggle in
   production-code changes or roadmap execution.
9. **Stop at authority boundaries.** Ask the operator when ownership, intent,
   architecture, promotion, generation rollover, or a material breaking choice
   remains unresolved. A refresh may identify the decision; it may not decide it
   silently.

## Facet result states

Report one state for each facet:

- `current` — checked and consistent;
- `repaired` — a bounded docs/planning/instruction correction was made;
- `stale` — canonical content exists but no longer describes reality;
- `missing` — required coverage or authority is absent;
- `ambiguous` — an operator-owned decision or boundary is unresolved;
- `blocked` — repair cannot proceed without another route, access, or decision;
- `not-applicable` — the project posture does not require that surface.

## Route precedence

Use the narrowest route that resolves the first material blocker:

1. `normalize-docs` for missing or malformed docs structure;
2. `northstar AGENTS file review` / agent-instruction review for instruction
   surfaces;
3. planning-readiness review for incomplete or uncertain planning;
4. recovery/refocus for stale or contradictory canonical state;
5. research or pre-execution discovery for unresolved evidence or intent;
6. roadmap compilation only when planning is already coherent;
7. orchestrator mode only when the operator explicitly wants a worker/PR loop.

Do not claim the project is refreshed merely because Effigy health is green. Do
not claim planning is complete merely because files exist.

## Output

Return a compact refresh report containing:

- target and posture;
- one state per facet;
- files/checks actually inspected;
- bounded repairs made, if any;
- unresolved blockers and operator decisions;
- exactly one recommended next route;
- whether execution is currently safe to continue.

If all facets are current and the next batch is genuinely ready, say so and point
to the canonical card. If the project is healthy but no execution lane is ready,
say that explicitly rather than inventing work.
