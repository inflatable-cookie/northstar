# Flattened Task Consumer Switchover

Status: open
Owner: Northstar Chatterbox and operator
Created: 2026-09-09
Depends on: `g03.003`; queue task `8a6f45f9-bc9f-48d9-a1e9-552fe2675006`

## Confirmed direction

After `g03.003` lands, produce one reusable prompt for existing project
orchestrator threads. It must move each project onto the generation-plus-task
model without keeping milestone, batch-card, or compatibility layers.

The prompt authorizes a bounded documentation repair. It does not authorize a
new product lane. Finalize it against the landed doctrine, templates, checks,
and installed skill version before distribution.

## Safe boundary

The orchestrator must stop new old-format dispatches before migration. It must
inspect the project queue, active workers, reviews, PRs, handoffs, worktrees,
and the integration checkout.

Do not rewrite the authority path beneath unfinished work submitted under the
old structure. Drain that work through merge and closeout first. A blocked task
remains a blocker; migration is not authority to abandon or supersede it. Stop
on a dirty or divergent integration checkout, conflicting ownership, or an
unsettled semantic decision.

## Switchover order

1. Establish the exact repository, branch, Northstar version, queue state, and
   current front doors. Require source/install parity for the flattened model.
2. Run closed-generation lifecycle maintenance first. Classify every expanded
   generation, freeze the preservation manifest, promote live authority and
   commitments, write compact roll-ups, rewrite current links, and delete only
   safely closed source trees.
3. Flatten the active generation. Inventory its generation README, milestone
   wrappers, batch cards, inbound references, dependencies, evidence, and
   transient handoffs before changing paths.
4. Make the generation README the roadmap and each executable unit one
   top-level `docs/roadmaps/gNN/NNN-<slug>.md` task. Remove `batch-cards/` and
   consumed wrappers only after the preservation and reference maps are
   complete.
5. Rewrite current front doors and unsubmitted handoffs atomically. Resume
   dispatch only after the new task IDs and approved frontier agree everywhere.
6. Run project docs checks, the landed structural checks, exact link and
   reference checks, and an idempotence replay. Report whether lifecycle state
   is current.

## Active-generation mapping

- Absorb a wholly completed milestone and its completed cards into one compact
  completed task when their unique outcome and material evidence have a clear
  destination.
- Preserve every ready, blocked, in-flight, or otherwise unresolved card as a
  distinct top-level task. Keep its status, dependencies, scope, acceptance,
  stop gates, owned paths, review evidence, and external identities.
- Preserve an existing `gNN.NNN` ID for the task that genuinely owns that
  outcome. Assign any remaining actionable cards the next unused generation-
  local IDs in dependency order.
- Record an explicit old path and ID to new task mapping, then rewrite all live
  references together. Stop for a planning ruling if ownership or order is
  ambiguous.
- Historical queue records may retain immutable old paths. No unfinished queue
  item may depend on an authority file that migration deletes.

## Required report

Return the closed-generation classifications and preservation manifest, the
old-to-new active-task map, exact deletions, validation results, unresolved
blockers, the new approved frontier, and whether dispatch can resume.

## Promotion trigger

When `g03.003` is merged and its installed surfaces are current, turn this note
into the exact self-contained switchover prompt. Distribution to project
orchestrators is a later operator action; do not queue or send it from this
triage capture.
