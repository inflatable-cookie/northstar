# Chatterbox authority and planning delegates

Status: decision-ready; operator-confirmed; superseding correction
Disposition: promote as the governing role topology after the active migration

## Issue

Live use of the economical coordinator exposed a recursive planning path. The
operator and Chatterbox settled material meaning, then Luna spent substantial
time compiling and dispatching a promotion worker before any implementation
worker could start. The coordinator also owns the current-ready-frontier and
parallelisation analysis even though dependency edges, mutable-surface
partitions, and safe concurrency require material planning judgment.

The active promotion worker later stopped fail-closed and the coordinator was
about to start another promotion loop. The operator stopped both. Their partial
state is evidence for this correction, not a lane to resume.

The earlier correction moved too far in the other direction by proposing that
Chatterbox replace the planning delegate entirely while still forbidding
Chatterbox from canonical promotion. The intended topology is more precise:

- Chatterbox is the primary, human-centric planning authority;
- small optional planning delegates provide parallel operator conversations and
  triage intake;
- Chatterbox owns reconciliation and canonical promotion;
- the coordinator mechanically dispatches and gates the approved schedule.

## Operator-confirmed decisions

- Chatterbox is the primary operator-facing Northstar authority for discovery,
  research direction, planning, sequencing, and promotion into canonical
  planning surfaces.
- After explicit operator confirmation, Chatterbox may directly edit, validate,
  commit, and push canonical planning surfaces on the integration branch. It
  does not dispatch a promotion worker.
- Chatterbox does not implement product/runtime changes, own worker execution,
  accept PR reviews, or merge implementation PRs.
- Reinstate a smaller **planning delegate** role for an operator who wants a
  separate parallel conversation about one bounded issue.
- A planning delegate writes only unique triage notes. It does not edit
  canonical planning, create a planning PR, promote its note, direct the
  coordinator, dispatch workers, review, or merge.
- Chatterbox is responsible for reading, reconciling, promoting, splitting, or
  retaining anything added to triage by planning delegates, external sources,
  refresh/cleanup routes, or other intake.
- Chatterbox owns the execution schedule: lane definitions, dependency edges,
  readiness intent, mutable-surface partitions, serial constraints, and approved
  parallel frontier.
- The coordinator computes no new schedule. It evaluates the published
  prerequisites, verifies current factual state, dispatches every approved ready
  lane, manages worker/reviewer transport, applies PR gates, merges, and reports.
- Remove promotion workers from the normal flow. Canonical planning promotion is
  Chatterbox work; implementation is worker work.

## Superseded earlier decisions

This packet deliberately supersedes parts of
`docs/triage/20260904-100224-chatterbox-planning-and-private-review-children.md`:

- replace “Chatterbox never directly promotes” with direct operator-confirmed
  canonical planning promotion by Chatterbox;
- replace “retire the separate planning-delegate path” with the smaller
  triage-only delegate defined here;
- remove the bounded planning-projection worker from the normal path;
- retain promotion-envelope thinking only as Chatterbox's transient working
  aid, not a required coordinator or worker artifact.

It also sharpens
`docs/triage/20260904-101838-coordinator-dispatch-fast-path-and-yield.md`:

- after Chatterbox has promoted canonical planning, the coordinator dispatches
  the actual implementation workers from the ready cards and dispatch manifest;
- the coordinator does not dispatch a promotion-only child from a triage
  envelope;
- the report-and-yield and notification-driven turn rules remain confirmed.

The private-review workspace correction and context-complete escalation contract
remain unchanged.

## Chatterbox canonical-promotion contract

Chatterbox may promote only after the operator has explicitly confirmed the
material meaning being promoted. Its promotion batch:

1. reconciles current canonical planning and all relevant triage/evidence;
2. resolves conflicts with the operator instead of choosing silently;
3. edits the owning architecture, contracts, specs, roadmaps, ready cards,
   dispatch manifest, and required indexes/front doors together;
4. records non-goals, accepted uncertainty, dependencies, acceptance evidence,
   stop conditions, and triage dispositions in their canonical homes;
5. runs the required documentation and repository validation for the batch;
6. reviews the complete semantic diff against the operator-confirmed decisions;
7. commits and pushes the coherent planning state to the integration branch;
8. sends the coordinator a provenance-labelled direction naming the exact
   promoted commit, ready lanes, and approved frontier.

Chatterbox does not write product/runtime implementation in this batch. If a
planning choice remains unresolved, the affected lane is not ready and is not
included in the dispatch frontier.

Canonical promotion should be direct rather than a planning PR by default. Use
independent planning review only when the operator requests it or Chatterbox
identifies material residual planning risk that operator confirmation and
bounded validation do not settle. A review must not become a routine second
promotion lane.

## Planning delegate contract

The planning delegate is a lightweight parallel conversation, not a secondary
planning authority.

### Start and placement

- The operator starts one directly or asks Chatterbox to create one for a named
  issue.
- In Paseo, place it as a visible agent tab in the same project workspace rather
  than a new worktree workspace.
- When Chatterbox creates it, preserve Chatterbox parentage. Long-running
  conversational turns should not spam finish notifications; the delegate sends
  one explicit administrative notice when it commits a ready triage note.
- Several delegates may coexist because their only repository writes are unique
  triage files.

### Scope

- one bounded issue, feature, alternative, research question, or side-planning
  discussion;
- direct conversation with the operator;
- optional bounded read-only research subagents when the issue needs evidence;
- one or more unique timestamped triage notes as distinct issues become coherent.

### Output

A delegate note remains lightweight. It records:

- the issue and why it matters;
- evidence and alternatives;
- operator-confirmed statements, clearly separated from recommendations;
- known constraints and non-goals;
- unresolved questions;
- likely affected authority surfaces when useful;
- enough context for Chatterbox to continue without the private transcript.

It does not need an exact canonical destination map, final runway, full
acceptance oracle, or promotion manifest. Requiring those would recreate the
primary planning protocol inside triage.

### Handoff to Chatterbox

- Commit only the exact unique triage file under the existing shared-checkout
  isolation rules.
- Send Chatterbox one administrative notice with the absolute path and a
  one-line summary when direct messaging is available.
- Otherwise report the path to the operator for manual relay.
- Do not contact or direct the coordinator.
- Do not treat operator-confirmed statements in the note as automatic readiness.
  Chatterbox checks current canonical context, resolves conflicts or missing
  planning with the operator, and owns promotion.

## Triage ownership

Chatterbox owns the project's active triage-planning boundary:

- inspect new delegate and external notes at natural planning checkpoints;
- classify each as discard/duplicate, retain with a next question, merge into an
  active planning topic, or promote;
- preserve provenance and operator-confirmation status;
- ask the operator when sources conflict or decision ownership is unclear;
- remove or split resolved notes in the same canonical promotion batch;
- never make the coordinator interpret raw triage into execution authority.

The coordinator may record or forward an administrative triage notice, but it
does not promote, sequence, or dispatch from that note. It acts only on
Chatterbox-promoted canonical planning and the exact direction naming it.

## Dispatch manifest and parallel frontier

Chatterbox publishes the execution schedule in canonical planning. For each
lane, it defines:

- lane/card identity and intended outcome;
- prerequisite nodes and completion conditions;
- owned mutable paths and reserved shared closeout/front-door surfaces;
- approved concurrent siblings;
- explicit serial edges and their reasons;
- required worker capability class;
- acceptance evidence and review oracle;
- stop conditions and escalation owner.

It then names the approved current frontier: every lane whose semantic and
dependency prerequisites are expected to be ready together.

The coordinator performs a mechanical launch check:

- promoted commit is current and available;
- prerequisite completion facts hold;
- named paths/workspaces/branches do not have an unexpected live collision;
- required transport/profile capability is available;
- no operator pause or repository gate applies.

When all checks hold, the coordinator launches every approved frontier lane. It
does not select a smaller subset for convenience or invent extra parallelism.
When a factual check fails, it pauses only the affected lane and reports the
conflict to Chatterbox with a context-complete escalation. Chatterbox changes the
schedule when the conflict requires new dependency, ownership, priority, or
sequencing judgment.

After a lane completes, the coordinator evaluates only the boolean prerequisites
already published for downstream nodes. A missing or ambiguous edge returns to
Chatterbox; Luna does not redesign the graph.

## Normal delivery path

`operator <-> Chatterbox -> canonical promoted plan + approved frontier -> coordinator dispatches actual workers -> independent review children -> coordinator gate/merge -> Chatterbox planning refresh when meaning changes`

Parallel side planning:

`operator <-> planning delegate -> unique triage note -> Chatterbox reconciliation/promotion -> canonical plan`

There is no normal `triage -> coordinator -> promotion worker -> ready card ->
implementation worker` chain.

## Canonical destination map

| Destination | Required delta |
| --- | --- |
| `docs/specs/035-chatterbox-intake-channel.md` | Recast Chatterbox as the primary human-centric planning authority with direct canonical promotion; move its former triage-only behavior into the smaller planning delegate. |
| `docs/specs/036-economical-orchestrator-coordination.md` | Remove promotion-worker dispatch and semantic frontier compilation from the coordinator; accept Chatterbox-promoted ready plans and approved parallel manifests. |
| `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md` | Define actual-worker dispatch from canonical ready cards, mechanical prerequisite evaluation, approved-frontier launch, and the triage-only planning-delegate route. |
| `docs/contracts/001-working-rules.md` | Freeze Chatterbox promotion authority, delegate limits, triage ownership, schedule ownership, and coordinator mechanical checks. |
| `docs/architecture/system-architecture.md` | Replace the promotion-worker topology with direct Chatterbox canonical promotion; show delegate-to-triage-to-Chatterbox and Chatterbox-manifest-to-coordinator flows. |
| `docs/architecture/system-inventory.md` | Update role/component ownership for Chatterbox, planning delegates, triage, coordinator, dispatch manifest, and parallel frontier. |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | Carry the reusable human-planner/mechanical-coordinator doctrine, direct planning promotion, delegate intake, and approved-frontier dispatch. |
| `bundle-docs/operators/operator-quick-start.md` | Explain the primary Chatterbox conversation, optional delegate tabs, direct promotion, and immediate actual-worker dispatch. |
| `bundle-docs/glossary.md` | Distinguish Chatterbox, planning delegate, coordinator, dispatch manifest, and approved frontier. |
| `template-bundle/contracts/001-working-rules-template.md` | Carry the portable topology into the copy-ready template. |
| `template-bundle/triage/README.md` | Assign delegate/external intake reconciliation and promotion to Chatterbox. |
| `docs/triage/README.md` | Describe Chatterbox ownership of triage promotion and delegate unique-file capture. |
| `skills/northstar/SKILL.md` | Route primary discovery/planning/promotion to Chatterbox, optional parallel intake to planning delegates, and mechanical execution to the coordinator. |
| `skills/northstar/references/router.md` | Distinguish primary Chatterbox planning from explicitly requested planning-delegate conversations and preserve worker/review/orchestrator precedence. |
| `skills/northstar/references/modes/chatterbox.md` | Define canonical promotion, triage ownership, dispatch-manifest planning, direct coordinator direction, and preserved no-implementation/no-review/no-merge limits. |
| `skills/northstar/references/modes/orchestrator.md` | Remove promotion workers and dependency-graph design; consume the approved manifest, verify factual prerequisites, launch the full frontier, and return planning conflicts to Chatterbox. |
| `skills/northstar/references/modes/pr-review.md` | Preserve independent implementation fidelity review against the Chatterbox-promoted canonical plan. |
| Planning-delegate mode/template/adapter surfaces under `skills/northstar/` | Replace the former worktree/PR planning delegate with the same-workspace, triage-only conversational delegate and its direct Chatterbox notice. |
| Orchestrator and documentation-projection templates under `skills/northstar/assets/templates/` | Remove promotion-worker use; retain ordinary implementation-worker dispatch overlays only where the canonical card does not already contain the required transport-independent detail. |
| `scripts/check-northstar-command-skills.rhai` and owned repo-contract/model-routing fixtures | Assert the revised role split, direct promotion, delegate triage-only boundary, and mechanical frontier consumption. |
| `docs/roadmaps/g02/batch-cards/126-dogfood-economical-orchestrator-coordination.md` | Record promotion latency, time-to-actual-worker, coordinator scheduling interventions, and full-frontier launch fidelity. |
| `docs/README.md` and owned roadmap/front-door indexes | Sequence this superseding role migration and show current implementation truth. |

Exact-token search may identify additional derived parity and validation callers.
New semantic authority destinations return for operator confirmation.

## Sequencing and dependencies

- Do not resume or replace the stopped promotion worker or coordinator loop.
  Inspect any preserved branch/workspace output as non-authoritative evidence;
  reuse it only through the new direct Chatterbox promotion batch.
- Chatterbox should make this superseding topology its next canonical promotion,
  then hand Luna only the resulting actual-worker frontier.
- Promote the Chatterbox/coordinator direction channel in
  `docs/triage/20260904-103055-chatterbox-coordinator-direction-channel.md` with
  this topology.
- Move canonical promotion into Chatterbox before deleting the coordinator's
  promotion-worker path.
- Publish the dispatch-manifest/frontier contract before removing Luna's current
  scheduling discretion.
- Install the triage-only planning-delegate route and its Chatterbox handoff
  before removing obsolete planning-delegate worktree/PR semantics.
- Update all callers and remove superseded surfaces together; do not retain
  compatibility aliases before 1.0.
- Update source/install parity and structural/semantic fixtures in the same
  delivery batch.

## Non-goals

- no Chatterbox implementation of product/runtime code;
- no Chatterbox worker supervision, PR acceptance, or merge authority;
- no planning-delegate canonical edits, PRs, promotion, coordinator direction,
  or execution dispatch;
- no coordinator choice of product meaning, lane boundaries, priorities,
  dependency edges, or parallel groups;
- no promotion-only worker in the normal delivery path;
- no full promotion-envelope requirement inside delegate triage notes;
- no blind launch when factual state contradicts the approved manifest;
- no permanent duplicate of promoted meaning in triage;
- no provider/profile names in reusable policy.

## Acceptance evidence

- A primary Chatterbox session reconciles operator discussion plus two delegate
  notes, promotes one coherent canonical plan directly on `main`, disposes the
  source notes, and sends the exact promoted commit/frontier to the coordinator
  without a promotion child.
- A delegate fixture writes and commits only one unique triage file, sends its
  path to Chatterbox, and cannot edit canonical files or contact the coordinator.
- An external triage note remains non-executable until Chatterbox reconciles and
  promotes it.
- A scheduling fixture gives Chatterbox a dependency graph with two parallel
  lanes and one downstream lane; the coordinator launches both approved frontier
  workers without selecting or redesigning the set.
- A collision fixture causes the coordinator to pause only the affected lane and
  return a context-complete conflict to Chatterbox.
- A completion fixture causes Luna to launch the downstream lane only when the
  published boolean prerequisites hold.
- A negative fixture proves Luna cannot turn a raw triage note into a promotion
  child, ready card, or implementation dispatch.
- A timed delivery scenario measures operator confirmation to actual-worker
  creation and contains no promotion-thread interval.
- Dogfood evidence records that the first promotion worker stopped fail-closed,
  the coordinator was about to start another loop, and the operator stopped both
  before actual-worker dispatch.
- Existing Chatterbox/coordinator messaging, unique-file Git isolation,
  worker/reviewer parentage, serial review workspace lease, exact-head review,
  revision routing, merge-gate, bundle, command/router, and source/install parity
  checks still pass.
- `git diff --check`, `effigy check:chatterbox-git`,
  `effigy check:command-skills`, `effigy check:repo-contract`,
  `effigy check:model-routing`, `effigy qa:docs`, and `effigy qa` pass for the
  eventual delivery batch.

## Unresolved questions

None block promotion. Chatterbox uses independent planning review only for
operator-requested or explicitly high-residual-risk planning changes; making it
routine would recreate the promotion queue this topology removes.

## Alternatives rejected

- **Chatterbox remains triage-only.** That forces Luna or another worker to
  reconstruct and promote planning, adding delay and semantic leakage.
- **Remove planning delegates entirely.** The operator loses useful parallel
  focused conversations; the problem was their promotion authority and ceremony,
  not their existence.
- **Planning delegates produce full execution envelopes.** This duplicates the
  primary planning protocol and makes Chatterbox a pass-through.
- **Luna continues choosing parallel lanes.** Dependency and ownership design is
  material planning, not mechanical coordination.
- **One worker promotes planning and implements.** It collapses planning and
  implementation ownership while still delaying canonical readiness until a PR
  completes.
- **Always review Chatterbox promotion through a PR.** Routine planning-review
  lanes restore the latency and recursion the change is intended to remove.
