# Coordinator dispatch fast path and yield

Status: decision-ready; operator-confirmed
Disposition: promote with the economical-coordinator contract changes

## Issue

Live dogfood of the Luna coordinator exposed two coordination failures after the
operator supplied a complete, confirmed promotion packet:

- worker dispatch took roughly six minutes;
- after dispatch, the coordinator appeared to keep its turn open while waiting
  for the worker.

The current orchestrator procedure helps cause both. Its general authority-load
path requires a broad sweep of architecture, contracts, runway, logs, and open
triage before dispatch. Its instruction to keep doing coordination while workers
run forbids idle polling but does not explicitly require the turn to end when no
immediate coordination remains.

A complete operator-confirmed promotion envelope should support a narrower
mechanical route. Recompiling it into another handoff and keeping a live turn
open add latency and ceremony without improving semantic safety.

## Operator-confirmed decisions

- Add a dispatch fast path for complete operator-confirmed promotion envelopes.
- The committed promotion envelope doubles as the projection worker's dispatch
  artifact. Do not create a second handoff that restates it.
- Limit coordinator preparation on this path to mechanical preflight. The
  coordinator does not reload unrelated planning or re-derive packet meaning.
- Dispatch every safe, immediately ready child identified at the checkpoint,
  report the returned identities, then end the coordinator turn.
- Do not poll, invoke a wait primitive, or keep a turn open merely because a
  worker or reviewer is running.
- Child launches keep `notifyOnFinish: true`. A completion, error, or permission
  notification starts the next bounded coordinator turn.
- For a complete packet with no conflict or transport failure, target less than
  two minutes from receipt to worker creation. Longer preparation is recorded as
  friction with an explicit reason rather than treated as normal behavior.

## Fast-path contract

The fast path applies only when all of these are already true:

- the promotion envelope is committed and names its exact commit/path;
- the operator-confirmation record covers its material decisions and accepted
  deferrals;
- the envelope includes exact canonical destination deltas, runway/dependency
  intent, non-goals, acceptance assertions, stop conditions, and source-note
  disposition;
- no blocking semantic question remains;
- the requested operation is bounded planning projection, not discovery,
  implementation, recovery, or general runway compilation.

The coordinator then performs only this preflight:

1. Read repository instructions, the applicable coordinator fast-path section,
   the confirmed envelope, and the named canonical destinations needed to prove
   current ownership or conflict.
2. Verify the integration branch and remote base, clean planning checkout,
   committed packet identity, explicit confirmation, destination existence or
   valid creation paths, active-lane path conflicts, and dependency readiness.
3. Resolve the current adequate worker profile from live profile notes.
4. Create the bounded projection workspace/branch from the verified base.
5. Launch the projection worker with the absolute envelope path and exact packet
   commit as its sole semantic dispatch authority. Mechanical transport values
   such as workspace, branch, base SHA, and agent identity remain launch state;
   they do not require a committed duplicate handoff.
6. Retain and report the returned workspace and agent identities.
7. Launch any other safe child already selected at the same checkpoint, then
   end the turn immediately.

If any fast-path prerequisite fails, stop or fall back to the applicable normal
route with the exact reason. Do not silently fill packet gaps or perform a broad
planning sweep under the name of preflight.

## Turn lifecycle

Coordinator turns are event-bounded:

- operator request or child notification starts a turn;
- the coordinator reconciles that event and performs the immediately available
  dispatch, revision, review, merge-gate, or closeout actions;
- once no action is available without a future child result, the coordinator
  reports state and yields;
- `notifyOnFinish: true` delivers the future event and begins another turn.

“Continue non-overlapping coordination while workers run” means perform work
that is already available in the current event. It is not authority to hold the
turn open, poll, wait, manufacture busywork, or repeatedly rescan unchanged
state.

The dispatch report should be compact: launched lane(s), agent/workspace
identities, packet path or handoff path, and the notification being awaited.

## Canonical destination map

| Destination | Required delta |
| --- | --- |
| `docs/specs/036-economical-orchestrator-coordination.md` | Add the confirmed-envelope dispatch fast path, bounded mechanical preflight, latency observation, and explicit post-dispatch yield rule. |
| `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md` | Make coordinator turns event-bounded; distinguish available concurrent work from waiting; allow a confirmed promotion envelope to serve as the projection dispatch artifact. |
| `docs/contracts/001-working-rules.md` | Require report-and-yield after the ready dispatch set; forbid polling, wait calls, or open-turn idling; freeze the fast-path prerequisites and fallback boundary. |
| `docs/architecture/system-architecture.md` | Show notification-driven coordinator re-entry rather than a continuously open coordinator turn. |
| `docs/architecture/system-inventory.md` | Record the committed promotion envelope as the projection lane's semantic dispatch input and finish notification as the coordinator wake-up input. |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | Add reusable dispatch-first and event-bounded-turn doctrine without naming Luna or another local profile. |
| `bundle-docs/operators/operator-quick-start.md` | Explain that the coordinator reports dispatch and yields while children run, then resumes from notifications. |
| `template-bundle/contracts/001-working-rules-template.md` | Carry the portable fast-path and yield rules into the copy-ready template. |
| `skills/northstar/SKILL.md` | Summarize promotion-envelope direct dispatch and notification-driven coordinator turns. |
| `skills/northstar/references/modes/orchestrator.md` | Add an early fast-path branch before broad authority loading; remove any implication that an idle coordinator should remain in-turn; require immediate yield after reporting launched identities. |
| `skills/northstar/assets/templates/northstar-orchestrator-run.md.template` | Keep normal implementation-worker handoffs unchanged; clarify that the template is not required when a complete confirmed promotion envelope is the bounded projection dispatch artifact. |
| `docs/roadmaps/g02/batch-cards/126-dogfood-economical-orchestrator-coordination.md` | Add time-to-first-dispatch and open-turn-wait incidents to the trial observations; record the roughly six-minute dispatch as initial evidence. |
| `docs/README.md` and owned roadmap/front-door indexes | Sequence the fast-path adjustment without claiming the trial complete. |

Exact-token search may identify derived source/install parity and structural
validation surfaces. Adding a new semantic destination is not mechanical and
returns for operator confirmation.

## Sequencing and dependencies

- Promote after or together with the Chatterbox promotion-envelope contract in
  `docs/triage/20260904-100224-chatterbox-planning-and-private-review-children.md`;
  the fast path depends on that envelope being complete enough to dispatch.
- Incorporate the reviewer placement correction in
  `docs/triage/20260904-100548-place-review-child-in-worker-workspace.md` so
  reviewer completion follows the same notification-driven turn lifecycle.
- Define the contract and fast-path routing before measuring further dogfood
  dispatches against the two-minute target.
- Keep ordinary implementation-worker handoffs where the ready card plus
  transport overlay remains necessary. This packet removes only the redundant
  projection handoff created from an already complete promotion envelope.
- Update source/install parity and structural checks in the delivery batch.

## Non-goals

- no weakening of packet completeness, operator confirmation, projection
  isolation, independent review, or merge gates;
- no two-minute timeout that aborts a valid launch in progress;
- no reusable policy dependency on the Luna profile or a particular provider;
- no removal of normal worker handoffs for ordinary implementation lanes;
- no polling disguised as state reconciliation;
- no coordinator exploration of product meaning to save a Chatterbox round;
- no requirement to remain busy while children run.

## Acceptance evidence

- A complete confirmed promotion envelope reaches `create_agent` without a
  second committed handoff or unrelated full-repository planning sweep.
- A timed happy-path scenario records packet receipt, workspace creation, agent
  creation, and dispatch report; the target is under two minutes absent an
  explicit conflict or transport failure.
- A negative scenario rejects the fast path when confirmation, destination
  deltas, dependencies, acceptance, stop conditions, or unresolved-question
  disposition is incomplete.
- A dispatch lifecycle scenario launches all immediately safe children, reports
  their identities, makes no poll/wait call, and ends the coordinator turn.
- A finish notification starts a fresh bounded coordinator turn that routes
  review or closeout without reconstructing semantic planning.
- A no-work scenario proves the coordinator yields rather than repeatedly
  rescanning unchanged state or inventing tasks.
- Trial evidence records the observed roughly six-minute launch and any later
  preparation exceeding the target with a reason classification.
- Existing worker isolation, parentage, notification, exact-head review,
  revision routing, merge-gate, bundle, command/router, and source/install parity
  checks still pass.
- `git diff --check`, `effigy check:command-skills`,
  `effigy check:repo-contract`, `effigy check:model-routing`,
  `effigy qa:docs`, and `effigy qa` pass for the eventual promotion batch.

## Unresolved questions

None block promotion. The two-minute value is a dogfood target and diagnostic
threshold, not a provider-independent hard timeout or release gate.

## Alternatives rejected

- **Always run the full authority-load procedure.** A complete confirmed packet
  already bounds the semantic lane; unrelated planning reads add latency without
  helping mechanical dispatch.
- **Compile another handoff from the envelope.** This duplicates confirmed
  meaning and gives the coordinator another opportunity to omit or reinterpret
  it.
- **Keep the turn open for faster reaction.** Finish notifications already
  provide re-entry. An open idle turn wastes capacity and obscures whether the
  coordinator has completed its available work.
- **Use a hard two-minute cancellation.** Provider and control-plane calls may
  validly take longer. Record and explain misses instead of aborting blindly.
