---
title: Generic language package lifecycle worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: blocked; planning decisions required (round-2 review findings 1-2)
owner: repo maintainers
created: 2026-09-02
updated: 2026-09-02
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260902-004300-prove-generic-language-package-lifecycle.md
base_required: pushed-main
tags: [coordination, handoff, worker, language-quality, packages]
---

## What This Thread Was Doing

Card 116's package machine contracts are merged. A post-merge readiness pass
promoted the missing digest framing and lifecycle-state rules. Card 117 is now
the sole ready edge: prove the generic package lifecycle with the policy-free
fixture.

## Why It Matters

Northstar must prove discovery, trust, acquisition, activation, rollback, and
offline routing before moving TypeScript or Rust policy out of core. The proof
must stay generic so future language packages do not require core branches.

## Current State

- Repository: `/Users/tom/Dev/projects/northstar`.
- Planning branch: `main`; dispatch base before this handoff is `4645fc952bccac3e615bd8d834d4e91441ebfa0c`.
- Worker branch: `worker/prove-generic-language-package-lifecycle`.
- Worktree: Paseo `branch-off` from pushed `main`, slug
  `prove-generic-language-package-lifecycle`.
- Required siblings: none.
- Ready card: `docs/roadmaps/g02/batch-cards/117-prove-generic-language-package-lifecycle.md`.
- Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
  `docs/architecture/system-architecture.md`,
  `docs/contracts/004-language-quality-pack.md`, and
  `docs/specs/034-modular-language-quality-packages.md`.
- Allowed runway: card 117 only. Card 118 remains serial on review and merge.
- Surfaces owned: generic package lifecycle implementation, its schemas and
  fixtures, focused checks and parity wiring, card 117 closeout, one dated log,
  this handoff, and directly dependent front doors.
- Dispatch topology: sole ready frontier lane. No other worker owns these
  surfaces.
- Worker profile: DeepSeek v4 Flash Worker. This is a bounded day-to-day lane
  with settled architecture and an explicit adversarial oracle.
- Frontier-worker justification: none. Material risk stays with exact-head
  orchestrator review.
- Required validation: every card-117 evidence item, focused package checks,
  isolated skill-install parity, `effigy qa:docs`, `effigy qa`, and
  `git diff --check`.
- PR base/head: `main` <- `worker/prove-generic-language-package-lifecycle`.
- Merge path: orchestrator after accepted exact-head review and required checks.

## Boundaries

- Implement card 117 only: generic discovery, canonical identities,
  operator-owned trust/lifecycle state, immutable local acquisition,
  transactional activation and rollback, offline routing, visible notices,
  and the policy-free fixture proof.
- Do not fetch a production package, add language policy, change consumer
  activation, start card 118, or require Effigy/Paseo/a provider at runtime.
- Stop on any missing trust or architecture decision, language-specific route,
  provider API in the reusable contract, or failure that cannot preserve the
  active install and consumer bytes.
- Work only in the clean Paseo worker worktree. Never edit the planning checkout
  or merge the PR.

## Important Context

- Card 117 records the accepted card-116 schema/fixture hashes and the exact
  merge lineage. Treat those as the source baseline.
- The canonical package-tree identity is not a Git tree ID or archive hash.
  Follow the promoted byte framing exactly and falsify path, collision,
  symlink, special-file, and digest-spelling cases.
- Detection never authorizes acquisition. Consumer files never own trust or
  selection. Activation uses revisioned compare-and-swap state and preserves
  retained bytes on failure.
- Schema evaluator support remains bounded and fail-closed. Do not silently
  widen its vocabulary.

## Suggested Next Move

Run worker preflight, read the ready card and governing refs, then inventory the
merged card-116 implementation. Build the smallest coherent generic lifecycle
and fixture proof against the eight-row review oracle.

## Completion Protocol

1. Before broad reads, record repository root, branch, status, and registered
   worktrees. Use the current clean registered non-`main` worktree; do not make
   another because its generated path differs from this note.
2. Fetch origin with a bounded non-interactive SSH connection. Require worker
   `HEAD == origin/main`, this handoff tracked in `HEAD`, and the tracked blob
   byte-equal to the absolute file. Stop rather than clean, reset, or discard.
3. Execute card 117 only. Keep implementation and closeout coherent. Return any
   contract gap to the orchestrator instead of inventing architecture.
4. Falsify all eight review-oracle rows and produce every evidence item named by
   the card. Run the required validation above.
5. Reconcile card 117, roadmap 048, one dated log, this handoff, and directly
   dependent front doors. Leave card 118 blocked for post-merge refresh.
6. If `origin/main` moved, integrate it and revalidate. Push the worker branch
   and open a reviewable PR against `main` with exact tested head and limits.
7. Report the PR URL and exact head through Paseo. Do not merge. If review asks
   for changes, remain on this branch and repair only the classified in-bounds
   findings.

## Completion Record

- PR: https://github.com/inflatable-cookie/northstar/pull/22
  (`main` <- `worker/prove-generic-language-package-lifecycle`).
- Round-1 review head `981db752e25486e453a72888dccff394aa115b3e` required
  changes; repaired at `2b43cf0`. Round-2 review of `2b43cf0` ACCEPTED the
  byte-level repair and returned five findings: findings 1-2 are
  planning-change, findings 3-5 are execution-miss.
- Finding 3 fixed: staged manifest identity/version/range bound to the
  requested pin, with mutated negatives; route cross-checks
  reference/receipt/manifest end to end.
- Finding 4 fixed: install store addressed by the FULL canonical tree digest
  with exclusive verify-or-fail publishing (occupied/partial targets fail
  without writing); receipts written before CAS truthfully record
  `activation_status: "installed"`; prefix-collision and occupied-target
  counterexamples added.
- Finding 5 fixed: the concurrency oracle now runs two real bun processes
  against one state root with a deterministic barrier (one winner commits,
  the loser fails closed on the held lock without removing it, state remains
  parseable, one selected identity); interrupted/live-lock cases retained.
- Findings 1-2 STOPPED as planning-change: no canonical authority exists for
  a Bun consumer prerequisite or for the `required_commands[0]` self-check
  runner convention. The branch reverted the overstrong completion claims
  (card 117 -> blocked; acceptance items for non-Effigy routing and
  self-check un-checked) and records the precise decisions required in the
  card and dated log under "Planning Blockers".
- Validation on the new head: standalone oracle (Effigy absent) PASS (12
  oracle groups), `effigy check:language-packages` PASS (13 receipt schema
  validations), isolated skill-install parity (169 files), `effigy qa:docs`
  PASS, `effigy qa` PASS, `git diff --check` clean.
- Next: orchestrator planning decisions for the portable core host/API and
  the self-check runner/invocation contract. Do not merge; do not start card
  118 until the decisions land and this PR is accepted.
