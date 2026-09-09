# Compile Roadmaps Mode

Use this mode when architecture, inventory, authority, and contracts already
exist and the user wants the next tasks.

## Goal

Produce **turnkey `gNN.NNN` tasks** that sequence only contract-approved work
and leave a bounded execution runway — not thread-scoped mini-plans or
one-task-at-a-time improvisation.

## Steps

1. Confirm the target work is fully represented in architecture, inventory, and
   contracts.
2. Classify the active repo lifecycle state before compiling anything:
   - `ready`
   - `paused`
   - `migration`
   - `drifted`
   Also identify authority mode (root-owned or nested), active lane, whether a
   ready task exists, and whether an intent checkpoint blocks the next move.
3. If there is a spec for this lane, confirm its durable outcomes have already
   been promoted into the canonical surfaces the task will reference.
4. If any required contract is missing, stop and surface a planning gap instead
   of drafting speculative tasks.
5. Read the active generation's `## Generation Runway` in
   `docs/roadmaps/gNN/README.md`; use it to choose the next task direction
   before inventing new work from recent context. Treat the runway as a
   long-horizon steering surface for a significant 20-to-50-task generation,
   not a short queue that expires after a few tasks.
6. Group work into meaningful **tasks** (reviewable outcomes), not
   agent-turn steps. Size by coherent ownership and a reviewable outcome;
   model long work as dependency-linked tasks in one generation.
7. For non-trivial lanes, name the runway goal, the next few meaningful tasks
   beyond the immediate one, and the next planning checkpoint before
   execution starts.
8. Write `## Work` and acceptance rows as
   checkbox task lists (`- [ ]` / `- [x]`) so progress is scannable.
9. Make the lane runway explicit:
   - the generation runway goal the lane advances
   - the immediate ready task or paused gate
   - the next few meaningful tasks beyond it
   - the next planning checkpoint where strategy or intent may need review
10. For task fields and ready-state checks, follow the target repo's
   `docs/contracts/001-working-rules.md` and installed task template
   (`docs/roadmaps/templates/task-template.md`, or the skill-shipped copy
   at `assets/templates/docs/roadmaps/templates/task-template.md` when the
   consumer path is not yet installed). When working in the Northstar source
   repo, expanded doctrine lives at
   `bundle-docs/sections/07-delivery-framework-and-autonomy.md` and maps
   through `bundle-docs/protocol-kernel.md`. Do not invent a divergent
   checklist when those source-repo surfaces are absent.
11. Apply the repo's readiness rubric before marking a task or short chain
   `ready`:
   - the work is bounded enough to execute without fresh planning decisions
   - the governing refs are current and canonical
   - acceptance criteria, validation, evidence requirements, and stop
     conditions are explicit
   - no unresolved planning gap still governs the work
   - any auto-continuation transition is already represented in file state
12. If the lifecycle state is `paused`, compile toward a paused planning gate or
   intent checkpoint instead of pretending the lane is ready for execution.
13. Reference governing contract ids directly in each roadmap task.
14. Keep planning gaps visible in the task until they are closed.
15. Recommend generation rollover only when contract or architecture shifts make
   the current sequencing baseline misleading, the generation has had a
   substantial run already, and the repo is ready to close that generation
   cleanly rather than escaping local cleanup.
16. Before recommending rollover, confirm all current-generation tasks can
   be marked closed, superseded, or rehomed and that stale specs
   from that generation can be archived or removed from `docs/specs/`. Perform
   that closeout with [`../lifecycle-maintenance.md`](../lifecycle-maintenance.md).
   The same procedure also compacts already-closed generations during
   maintenance without opening a new generation.
17. Treat any remaining spec for the lane as context only; do not let it outrank
   the promoted canonical surfaces.

## Guardrails

- Do not compile roadmap work from intuition or likely behavior.
- Do not compile roadmap work from a provisional spec when the durable outcomes
  have not yet been promoted.
- Do not treat a stale spec as silent permission to outrun the promoted
  architecture and contracts.
- Do not ignore the active generation runway when choosing the next task.
- Do not rewrite the generation runway as a per-turn task list.
- Do not bury missing dependencies inside risk sections.
- Do not let one repo's roadmap imply ownership over another repo without an
  authority map and contract support.
- Do not create a new task file per agent turn; update the active task
  instead.
- Do not compile a task that is one vague bucket with no ordered steps.
- Do not create micro-tasks; keep execution grouped into meaningful outcomes.
- Do not mark a task `ready` just because it is next in sequence.
- Do not leave execution with only one visible next task when the lane clearly
  needs a broader runway or an explicit planning checkpoint.
- Do not suggest rollover after only a handful of tasks. Expect something
  closer to a 20-to-50-task generation unless a real sequencing reset
  clearly justifies earlier closure.
- Do not treat the end of a planned task or lane as a generation closeout.
  After one task closes, compile or continue the next task inside the same
  generation.
- Do not open a new generation while the current one still has live tasks
  or stale specs that should have been cleaned up first.
- Do not leave already-closed generations expanded until the next rollover;
  maintenance routes compact them through the shared lifecycle procedure.
