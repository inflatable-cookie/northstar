# Compile Roadmaps Mode

Use this mode when architecture, inventory, authority, and contracts already
exist and the user wants the next milestones or batches.

## Goal

Produce **turnkey milestone roadmaps** that sequence only contract-approved work
and leave a bounded execution runway — not thread-scoped mini-plans or
one-card-at-a-time improvisation.

## Steps

1. Confirm the target work is fully represented in architecture, inventory, and
   contracts.
2. Classify the active repo posture before compiling anything:
   - `baseline-routing`
   - `strict-ready`
   - `strict-paused`
   - `migration`
   - `drifted`
3. If there is a spec for this lane, confirm its durable outcomes have already
   been promoted into the canonical surfaces the roadmap will reference.
4. If any required contract is missing, stop and surface a planning gap instead
   of drafting speculative batches.
5. Read the active generation's `## Generation Runway` in
   `docs/roadmaps/gNN/README.md`; use it to choose the next milestone direction
   before inventing new work from recent context. Treat the runway as a
   long-horizon steering surface for a significant 20-to-50-roadmap generation,
   not a short queue that expires after a few roadmaps.
6. Group work into meaningful **roadmap batches** (broad chunks), not
   agent-turn steps. Batch cards carry step-by-step detail in strict posture.
7. For non-trivial lanes, name at least two or three batches in `## Execution
   Plan` and anticipate several batch cards across the visible runway before
   execution starts.
8. Write `## Execution Plan`, `## Goals`, and `## Acceptance Criteria` as
   checkbox task lists (`- [ ]` / `- [x]`) so progress is scannable.
9. Make the lane runway explicit:
   - the generation runway goal the lane advances
   - the immediate ready card or paused gate
   - the next few meaningful batches or milestone transitions beyond it
   - the next planning checkpoint where strategy or intent may need review
10. For batch-card fields and ready-state checks, follow the target repo's
   `docs/contracts/001-working-rules.md` and installed batch-card template.
   When working in the Northstar source repo, expanded doctrine lives at
   `bundle-docs/sections/07-delivery-framework-and-autonomy.md` and maps
   through `bundle-docs/protocol-kernel.md`. Do not invent a divergent
   checklist when those source-repo surfaces are absent.
11. Apply the repo's readiness rubric before marking a card or short chain
   `ready`:
   - the work is bounded enough to execute without fresh planning decisions
   - the governing refs are current and canonical
   - acceptance criteria, validation, evidence requirements, and stop
     conditions are explicit
   - no unresolved planning gap still governs the work
   - any auto-continuation transition is already represented in file state
12. If the posture is `strict-paused`, compile toward a paused planning gate or
   intent checkpoint instead of pretending the lane is ready for execution.
13. Reference governing contract ids directly in each roadmap milestone.
14. Keep planning gaps visible in the milestone until they are closed.
15. Recommend generation rollover only when contract or architecture shifts make
   the current sequencing baseline misleading, the generation has had a
   substantial run already, and the repo is ready to close that generation
   cleanly rather than escaping local cleanup.
16. Before recommending rollover, confirm all current-generation milestones can
   be marked closed, superseded, or rehomed and that stale specs or batch cards
   from that generation can be archived or removed from `docs/specs/`.
17. Treat any remaining spec for the lane as context only; do not let it outrank
   the promoted canonical surfaces.

## Guardrails

- Do not compile roadmap work from intuition or likely behavior.
- Do not compile roadmap work from a provisional spec when the durable outcomes
  have not yet been promoted.
- Do not treat a stale spec as silent permission to outrun the promoted
  architecture and contracts.
- Do not ignore the active generation runway when choosing the next milestone.
- Do not rewrite the generation runway as a per-turn task list.
- Do not bury missing dependencies inside risk sections.
- Do not let one repo's roadmap imply ownership over another repo without an
  authority map and contract support.
- Do not create a new roadmap file per agent turn; update the active milestone
  and batch cards instead.
- Do not compile a roadmap whose execution plan is only one batch that mirrors
  a single batch card.
- Do not create micro-batches; keep execution grouped into meaningful chunks.
- Do not put batch-card-level steps only in roadmap prose when strict posture
  applies.
- Do not mark a batch `ready` just because it is next in sequence.
- Do not leave execution with only one visible next card when the lane clearly
  needs a broader runway or an explicit planning checkpoint.
- Do not suggest rollover after only a handful of milestones. Expect something
  closer to a 20-to-50-milestone generation unless a real sequencing reset
  clearly justifies earlier closure.
- Do not treat the end of a planned batch or lane as a generation closeout.
  After one batch closes, compile or continue the next batch inside the same
  generation.
- Do not open a new generation while the current one still has live milestones
  or stale specs that should have been cleaned up first.
