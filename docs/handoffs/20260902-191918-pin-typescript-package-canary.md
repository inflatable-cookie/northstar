---
title: Pin TypeScript package canary worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready
owner: repo maintainers
created: 2026-09-02
updated: 2026-09-02
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260902-191918-pin-typescript-package-canary.md
base_required: pushed-main
tags: [coordination, handoff, worker, language-quality, packages, registry]
---

## What This Thread Was Doing

Card 118's standalone TypeScript package source is accepted and merged. The
next serial edge is the Northstar core registry/routing change: pin that exact
source, route explicit TypeScript audits through the installed package, and
retain a visible frozen embedded fallback during the bounded overlap window.

## Why It Matters

The public package is useful only when core can acquire and route it through
the generic protocol without silently preferring embedded policy. This is the
first production canary for cards 116-117 and must settle before Jetstream can
produce fresh consumer evidence.

## Current State

- Repository: `/Users/tom/Dev/projects/northstar`.
- Planning branch: `main`; dispatch base is the commit containing this handoff.
- Worker branch: `worker/pin-typescript-package-canary`.
- Worktree: Paseo `branch-off` from pushed `main`, slug
  `pin-typescript-package-canary`.
- Required sibling: `/Users/tom/Dev/projects/northstar-language-packs`, linked
  into the Paseo container as `../northstar-language-packs` for immutable
  source/parity proof only. Runtime acquisition must use the registry source.
- Ready card: `docs/roadmaps/g02/batch-cards/118-extract-typescript-svelte-language-package.md`.
- Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
  `docs/architecture/system-architecture.md`,
  `docs/contracts/004-language-quality-pack.md`, and
  `docs/specs/034-modular-language-quality-packages.md`.
- Accepted source commit:
  `09ef1743dd8fc18bae3bf04fae791f1d7d4e5daf` in
  `https://github.com/inflatable-cookie/northstar-language-packs`, subpath
  `packages/typescript`.
- Accepted package identity:
  `@northstar/typescript-quality` `0.1.0`, tree digest
  `sha256:0fcd5c58296f168895b66f2472621d49761f7786ea2ad1ebeefb801040967d6b`,
  manifest digest
  `sha256:ed95883c428ef43f0f02d38d60bf8d50e6e29313f5751c1b2a5744157a5b5362`,
  core range `>=0.2.0 <1.0.0`.
- Allowed runway: card 118 registry/routing step only. Jetstream remains serial
  on accepted review and merge. Cards 119-120 are out of scope.
- Surfaces owned: official registry pin, generic installed-package route
  integration, visible frozen TypeScript fallback, focused fixtures/checks,
  card-118 progress, one dated log, this handoff, and directly dependent front
  doors.
- Dispatch topology: sole ready serial edge. No other worker owns these
  surfaces.
- Worker class: day-to-day. The protocol, immutable identity, route intent,
  fallback wording, and adversarial oracle are settled; material risk remains
  with exact-head orchestrator review.
- Required validation: registry schema/identity proof, installed inventory and
  direct self-check, installed/offline/rollback/acquisition-failure fallback
  oracles that do not require Jetstream, isolated skill-install parity,
  `effigy qa:docs`, `effigy qa`, and `git diff --check origin/main...HEAD`.
- PR base/head: `main` <- `worker/pin-typescript-package-canary`.
- Merge path: orchestrator after accepted exact-head review and required checks.

## Boundaries

- Pin only the accepted source commit and exact digests above. Reject moving
  refs, wider repository trees, identity drift, or a different manifest.
- Use the generic package lifecycle and host contract from card 117. Do not add
  a TypeScript-specific acquisition branch or make Effigy, Bun, Python, Paseo,
  or a provider a consumer prerequisite.
- Route only explicit TypeScript/Svelte audit intent. File detection and
  ordinary coding must not fetch, activate, or load the package.
- Keep the embedded TypeScript payload frozen. If official acquisition or
  routing fails during overlap, emit a visible notice naming the failed
  package identity and the frozen embedded fallback. Never silently prefer,
  update, or hide fallback use.
- Do not edit the public package source, Jetstream, Rust payload, consumer
  profiles/deviations, evidence schemas, or cards 119-120.
- Stop on any missing protocol authority, package-shape change, consumer-policy
  change, unsafe fallback behavior, or validation result that changes the plan.
- Work only in the clean Paseo worker worktree. Never edit the planning checkout
  or merge the PR.

## Suggested Next Move

Run worker preflight, read the ready card and governing refs, then map the
current explicit TypeScript route and card-117 lifecycle surface. Implement the
smallest generic registry/routing seam and falsify installed, offline,
rollback, route-intent, identity-drift, and visible-fallback cases before
touching closeout docs.

## Completion Protocol

1. Record repository root, branch, status, and registered worktrees. Require
   the worker head to equal pushed `origin/main` and this handoff to be tracked
   byte-for-byte before mutation.
2. Verify the sibling source checkout resolves accepted commit `09ef1743...`;
   use GitHub fetch only when required by the generic acquisition proof. Never
   rewrite or commit in the sibling.
3. Implement only the registry/routing step of card 118. Return a planning gap
   rather than inventing language-specific protocol.
4. Falsify every applicable card-118 oracle before claiming a route. Preserve
   the embedded payload and consumer files byte-for-byte.
5. Run the required validation. Reconcile card 118, roadmap 048, one dated log,
   this handoff, and directly dependent front doors. Leave Jetstream explicitly
   serial for post-merge dispatch.
6. If `origin/main` moved, integrate it and revalidate. Push the worker branch
   and open a reviewable PR with exact tested head, evidence, and limits.
7. Report through Paseo. Do not merge. If review asks for changes, remain on
   this branch and repair only classified in-bounds findings.

## Worker Report (2026-09-02)

The registry/routing step is complete on `worker/pin-typescript-package-canary`
from pushed `main` at `e36838c`. The official registry pins the accepted
canary identity at registry version `1.1.0`; the generic installed-package
route and the router's TypeScript audit route send explicit audit intent
through the installed package, with the frozen embedded payload reachable only
behind the visible fallback notice. The canary exposed a card-117 defect
(self-check receipts polluting the installed tree and breaking selection
re-verification); fixed generically by executing the declared self-check on a
byte-identical throwaway copy, with an oracle regression. Falsified with
`oracle-14 official-pin-route`, an independent spec-034 digest implementation
over the materialized accepted commit, and a real-package transcript.
Validation: standalone oracle, `effigy check:language-packages`, isolated
skill-install parity, `effigy qa:docs`, `effigy qa`, `git diff --check`. The
embedded TypeScript payload is byte-identical to `origin/main`. Registry
promotion completes at merge; Jetstream remains serial. Evidence:
`docs/logs/2026-09/02-201200-pin-typescript-package-canary.md`.
