---
title: Compact lifecycle Chatterbox handoff
kind: northstar-handoff
status: active
owner: Northstar Chatterbox
created: 2026-09-04
updated: 2026-09-04
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260904-235726-compact-lifecycle-chatterbox.md
tags: [chatterbox, compact-lifecycle, g03, handoff]
---

## What This Thread Was Doing

We redesigned Northstar around one compact strict lifecycle. The operator wants
the live docs tree to be working memory rather than a museum: closed generations
roll up, transient artifacts disappear when consumed, and Git keeps the full
history. Chatterbox now owns planning and promotion while the Luna coordinator
stays mechanical.

The first `g03` foundation card is merged. Its two sibling implementation lanes
are now in review. Both reviews found real corrections, so the next Chatterbox
is taking over at the point where scope or ownership may need a ruling—not at a
blank planning slate.

## Why It Matters

This is the first proof that Northstar can shed hundreds of historical files and
retire the old light/strict posture split without losing authority, evidence,
safe dispatch, or review fidelity. It also dogfoods the new relationship:
Chatterbox settles semantics; the coordinator resumes the same workers and owns
reviews, merges, closeout, and continuous dispatch.

## Current State

Here is the short version:

- **Done:** `g03` is active; card 130 rolled up `g01` and merged as `e8637b3`.
  The lifecycle foundation and structural archive checks are on `main`.
- **Latest canonical planning:** `a2b9723` expands card 131 narrowly to the
  deletion-coupled checker callers and reserves those exact paths away from
  card 132. Local `main` and `origin/main` matched at handoff creation.
- **Still open:**
  - [PR 37](https://github.com/inflatable-cookie/northstar/pull/37), card 131,
    exact head `cf20aafd72d1d909d4962cb434d6c538add6fbb3`, has a posted
    `Changes required` review. The worker must repair current links to deleted
    specs and correct the frozen-deletion count.
  - [PR 38](https://github.com/inflatable-cookie/northstar/pull/38), card 132,
    exact head `e3051c19a54930e358d37f24d8be12ab58c4c955`, has a posted
    `Changes required` review. The worker must integrate `a2b9723`, drop edits
    to card-131-reserved callers, finish removing supported posture variants,
    and replace the vacuous post-merge simulation with owned behavioral proof.
- **Active spec lane:**
  `/Users/tom/Dev/projects/northstar/docs/specs/038-compact-default-lifecycle-and-generation-rollup.md`
- **Current milestone:**
  `/Users/tom/Dev/projects/northstar/docs/roadmaps/g03/001-compact-default-lifecycle.md`
- **Current cards:**
  - `/Users/tom/Dev/projects/northstar/docs/roadmaps/g03/batch-cards/131-compact-g02-and-currentness.md`
  - `/Users/tom/Dev/projects/northstar/docs/roadmaps/g03/batch-cards/132-make-compact-lifecycle-default.md`
- **Canonical contract:**
  `/Users/tom/Dev/projects/northstar/docs/contracts/001-working-rules.md`
- **Coordinator:** existing Northstar Coordinator
  `bcf9fd1f-0eda-44bc-b3a7-54990bc9a087`.
- **Remaining continuation envelope:** same-worker revisions, retained-reviewer
  exact-head re-reviews, merge, synchronized-local-main closeout, then
  Chatterbox reconciliation of `g03.001` and the next runway decision.
- **Pause signal:** both PR heads are review-blocked. This does not pause the
  sibling lane or authorize a new worker.

The checked-out front doors still describe card 130 as next because card 131
owns their rewrite in PR 37. Do not “fix” those files concurrently from the
Chatterbox checkout.

## Boundaries

Please keep the next pass within these boundaries:

- Enter Northstar Chatterbox mode. Own operator conversation, semantic rulings,
  canonical planning promotion, and the approved dependency frontier.
- Do not implement the PR fixes, supervise workers, review either PR, or merge.
  The existing coordinator owns those actions and should resume the same worker
  and retained reviewer in each existing workspace.
- Do not open a promotion worker. Promote any newly confirmed planning directly
  on clean local `main`, validate it, commit and push it, then send the
  coordinator one provenance-labelled background direction message.
- Do not edit card-131-owned live currentness surfaces or its five reserved
  checker/fixture paths while its worker is active. Do not edit card-132-owned
  bundle, template, skill, or reusable lifecycle-check surfaces.
- Keep the two lanes parallel. A blocker in one does not pause the other.
- Follow `/Users/tom/Dev/projects/northstar/AGENTS.md` and the canonical spec,
  contract, and cards above.

## Important Context

- The operator confirmed one compact lifecycle as the default. Light,
  baseline, lane-first, mixed, and full-strict are not supported steady-state
  protocols. Incremental adoption is migration only.
- Generation roll-up is state-based, not age-based. Current authority,
  unresolved commitments, material evidence, and safe next work must survive;
  historical procedure must not remain executable-looking at `HEAD`.
- Chatterbox ruled that card 131—not a new lane—owns the exact checkers coupled
  to deleted `g02` and pre-`g03` files. That ruling is canonical in `a2b9723`.
- PR 37's blocking findings are currently within card 131's allowed direct-link
  repair scope: working-rules still requires a deleted archived spec; the `g03`
  runway names deleted spec 037; system inventory and contract 004 still cite
  removed specs as current authority. Its machine board otherwise passed.
- PR 38's first and third findings are implementation corrections: integrate
  the current planning base, relinquish reserved files, and create a card-132-
  owned non-vacuous post-merge fixture. Its second finding exposes the likely
  Chatterbox question: root `/Users/tom/Dev/projects/northstar/README.md` still
  publishes Baseline versus Strict, but neither sibling card currently names
  that path. The review recommends fixing all 132-owned skill/setup remnants
  and resolving ownership of the root README before claiming the repository-
  wide acceptance row.
- Recommended resolution if the coordinator returns that collision: assign the
  root README narrowly to card 132 because the stale content is public reusable
  setup/posture doctrine, reserve that exact path away from card 131, and resume
  the same card-132 worker. Confirm against the actual revised diffs before
  promoting; do not guess if either worker has since touched it.
- The coordinator must fast-forward and verify local `main == origin/main`
  after every merge before closeout or later dispatch. Dirty, divergent,
  wrong-branch, fetch-failure, and head-mismatch states stop without reset,
  stash, rebase, or discard.
- Review children stay in the worker workspace, reuse the same reviewer for
  revisions, and use a different underlying model from the worker. Spawned
  threads preserve the full-accept profile settings. Coordinators yield while
  workers run and notify Chatterbox only for a real semantic decision or an
  empty runway.

## Suggested Next Move

Start by entering Northstar Chatterbox mode and reading this handoff, spec 038,
cards 131 and 132, and the current posted reviews on PRs 37 and 38. Then inspect
the existing coordinator once.

If the coordinator can route every posted finding back to the same workers
inside current authority, let it do so and do not duplicate coordination. If it
returns the root-README ownership collision or another complete semantic
capsule, settle it from the confirmed compact-lifecycle intent where possible;
otherwise explain the one material choice to the operator. Promote any scope
change before directing the coordinator.

After both cards merge and local `main` is synchronized, reconcile `g03.001`:
verify the preservation oracle, current front doors, installed skill parity,
and empty/transferred handoff state. Then talk with the operator about the next
`g03` simplification tranche rather than inventing it from the old backlog.

## Completion Protocol

This is a Chatterbox continuation, not worker or orchestrator continuation. It
does not transfer coordinator authority and does not activate worker preflight.

Before closing the next Chatterbox thread:

1. Keep spec 038 and `g03.001` as the planning authority until both cards are
   merged and semantically reconciled.
2. Record any new operator-confirmed decision in canonical planning, not only
   chat or triage.
3. Send each promoted ruling to the existing coordinator once with the commit,
   exact affected card, and same-worker instruction; do not poll afterward.
4. Do not mark either review resolved until its retained reviewer accepts the
   new exact head and the coordinator verifies the merge gate.
5. After both merges, verify local-main synchronization and complete the
   milestone/currentness closeout without recreating historical boilerplate.
6. Prune this consumed handoff when the new Chatterbox has fully taken over and
   its useful state is canonical or no longer needed.
