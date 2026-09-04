# 036 - Economical Orchestrator Coordination

Status: superseded by spec 037; card 125 records the initial implementation and
card 126 will observe the corrected model
Owner: repo maintainers
Created: 2026-09-04
Updated: 2026-09-04
Depends on: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/specs/035-chatterbox-intake-channel.md`
Governing architecture: `docs/architecture/system-architecture.md`
Governing contracts: `docs/contracts/001-working-rules.md`

> Current authority: use
> `docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`. The
> body below records the first economical-coordinator split; its promotion-
> worker, coordinator-planning, and dedicated-review-workspace rules are no
> longer current.

## Problem

The orchestrator currently combines queue coordination, product planning,
semantic PR review, and merge control. That makes the long-lived thread consume
frontier-model capacity for routine dispatch, status reconciliation, and merge
bookkeeping.

Northstar already has the pieces needed to separate those concerns:
chatterboxes can hold operator-facing discovery, direct PR review is an
independent mode, and the orchestrator retains durable child-agent and exact-head
merge controls. The authority split has not yet caught up with that shape.

## Goal

Keep the public **orchestrator** role, but narrow its normal job to economical
coordination:

- maintain the dependency frontier and launch every safe ready lane;
- create and resume child workers and reviewers in separate workspaces;
- route unresolved product meaning to an operator-facing chatterbox;
- promote only operator-confirmed meaning through a bounded documentation lane;
- route substantive exact-head review to an independent review child;
- verify the accepted review is for the current head, required checks pass,
  ancestry and mergeability are current, then merge and refresh the runway.

The coordinator does not repeat full planning or review work merely to satisfy
role ownership. It escalates when the packet, review, or repository state leaves
a real judgment unresolved.

## Roles and authority

| Role | Owns | Must not assume |
| --- | --- | --- |
| Operator | product intent, confirmation of material decisions, profile overrides, and merge pauses | that a chatterbox recommendation is confirmed intent |
| Chatterbox | human discovery, alternatives, confirmed-vs-tentative separation, and decision-ready triage packets | canonical promotion, readiness, implementation, review, or merge |
| Orchestrator | dependency frontier, dispatch, identity retention, state reconciliation, revision routing, merge gate, merge, and closeout | product meaning absent from operator-confirmed authority or a semantic verdict absent from an independent review |
| Planning projection worker | mechanical promotion of an exact, operator-confirmed packet into named canonical surfaces | new product decisions, hidden reconciliation choices, or readiness judgment |
| Implementation worker | implementation, tests, evidence, branch, and reviewable PR inside the ready card | planning, review acceptance, or merge |
| Review child | independent exact-head semantic review and durable provider verdict | branch mutation, implementation, merge, or acceptance of a later head |

## Planning path

Material discovery moves to an operator-facing chatterbox by default. The
chatterbox remains a non-authoritative intake role, but its triage note can become
**decision-ready** when it clearly separates:

- operator-confirmed decisions;
- recommendations not yet accepted;
- evidence and alternatives;
- unresolved questions;
- affected authority surfaces.

The orchestrator may not treat recommendations as decisions. Once the operator
confirms the material meaning, the orchestrator compiles an exact promotion
brief and dispatches a bounded planning-projection worker. The projection may
edit canonical architecture, contracts, specs, roadmaps, and cards only as named
by the brief. Any semantic ambiguity returns to the operator and chatterbox.

An independent review child checks the projection against the confirmed packet.
The orchestrator then applies the normal exact-head merge gate. Readiness remains
a canonical property of the promoted card, not an informal coordinator choice.

Small operational clarifications that do not alter product meaning may still be
handled directly by the orchestrator. The test is whether another reasonable
answer would change behavior, acceptance, public contract, or sequencing.

## Review path

Every worker PR gets an independent review child unless the operator explicitly
asks the current thread to perform a direct review. In Paseo, the orchestrator:

- creates a dedicated checkout/worktree workspace for the PR head;
- creates the reviewer through the orchestrator's agent-scoped launch so it
  remains a child and finish notifications return to the orchestrator;
- selects an economical adequate review route under the diversified-routing
  rule, escalating only when the diff retains exceptional unresolved reasoning;
- gives the reviewer the PR, canonical refs, and review oracle, not the worker's
  private transcript;
- keeps `notifyOnFinish: true` and retains workspace and agent identities.

The review child uses Direct PR Review mode and posts its verdict on the provider.
Changes requested return to the same implementation worker. The revised exact
head returns to the same reviewer when available. A replacement reviewer starts
a fresh complete review; it does not inherit an unseen verdict.

The orchestrator does not duplicate the full diff review. Before merge it must
independently verify only the coordination gate:

- the durable accepted verdict names the exact current head;
- every blocking finding is resolved or explicitly superseded on the provider;
- required checks pass;
- the PR targets the intended base and current base ancestry is acceptable;
- the PR is mergeable;
- no stricter repository rule or operator pause applies.

Ambiguous, contradictory, missing, or stale review evidence stops merge.

## Model posture

Northstar describes capability classes, not local profile names. The
orchestrator's normal profile should be an economical coordinator capable of
reliable tool use, concise state tracking, and bounded verification. Higher
reasoning effort or a frontier route is an escalation, not the default.

Planning chatterboxes and review children select independently from their
adequate pools. Expensive conversational models are reserved for material
operator-facing discovery. Frontier review is reserved for diffs whose residual
risk cannot be bounded by settled planning, explicit oracles, tests, and an
economical independent review.

## Trial boundary

Protocol implementation and live measurement are separate cards. The first
trial covers ten representative PRs and records:

- coordinator route and effort class;
- planning source and any operator reconfirmation;
- worker and reviewer route classes;
- review rounds and blocking-finding classes;
- coordinator interventions beyond mechanical state handling;
- stale-head, merge, notification, or parentage friction;
- any missed issue found after acceptance.

The trial may tighten or relax the split. It must not silently promote local
model names, prices, or subscription limits into reusable policy.

## Non-goals

- no rename of the public orchestrator role;
- no Paseo profile mutation from Northstar;
- no weakening of exact-head review, required checks, or mergeability gates;
- no automatic promotion of chatterbox notes;
- no autonomous product decisions by projection workers;
- no requirement that every user run Paseo or a particular model provider;
- no durable usage ledger.

## Review oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Coordination is the default orchestrator job. | Orchestrator repeats full planning or semantic review for a settled lane. | Route the work to chatterbox/projection/reviewer and retain only the gate. | Exact-head role-boundary review. |
| Recommendations are not decisions. | A chatterbox recommendation is promoted without operator confirmation. | Stop before canonical mutation. | Planning-path negative scenario. |
| Promotion is mechanical. | Projection must choose between two plausible product meanings. | Return the ambiguity; do not choose. | Projection handoff and stop-condition review. |
| Review is independent. | Worker narrative is treated as acceptance, or the reviewer edits the branch. | Require a separate provider verdict and preserve branch ownership. | Review-mode and orchestrator-flow review. |
| Review head is exact. | Accepted verdict names an older SHA. | Re-review the current head. | Merge-gate scenario. |
| Parentage survives workspace isolation. | Reviewer is launched as a detached root thread. | Reject launch; create a child in the dedicated workspace. | Paseo launch-shape review. |
| Economical routes are normal. | Coordinator or ordinary reviewer requires a frontier model by role name alone. | Build the adequate pool and escalate only for residual difficulty. | Model-posture review. |
| Merge safety is unchanged. | Coordinator merges with missing checks, unresolved findings, or ambiguous state. | Stop before merge. | Merge-gate scenario. |
| Failure stays lane-local. | One provider refusal halts unrelated ready work. | Reroute or pause only that lane. | Scheduling scenario. |
| Trial does not rewrite policy by anecdote. | One successful cheap review is treated as permanent proof. | Record the cohort and decide after the measurement window. | Separate trial card. |

## Acceptance criteria

- [ ] reusable doctrine and live Northstar rules describe the coordinator split;
- [ ] chatterbox packets require operator-confirmed vs tentative separation;
- [ ] promotion workers have a fail-closed semantic boundary;
- [ ] independent child review is the normal worker-PR review path;
- [ ] exact-current-head verdict, findings, checks, ancestry, mergeability, and
      pause checks remain mandatory before merge;
- [ ] capability language stays portable and names no local profile;
- [ ] a separate ten-PR trial card is compiled but not auto-started;
- [ ] source/install parity, docs QA, full QA, and `git diff --check` pass.
