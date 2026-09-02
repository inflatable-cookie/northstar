---
title: Repair installed language-package fallback notice worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: complete
owner: repo maintainers
created: 2026-09-02
updated: 2026-09-02
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260902-212756-repair-language-package-fallback-notice.md
base_required: pushed-main
tags: [coordination, handoff, worker, language-quality, packages, fallback]
---

## What This Thread Was Doing

Jetstream PR 4 ran card 118's fresh installed TypeScript canary. Exact-head
review found that its forced-failure transcript stops at the reference host's
manual/local-install message. No shipped core surface emits the contract's
required frozen-fallback notice, and the host stop prose omits the package
version.

This worker repairs that upstream Northstar execution miss. It adds the
smallest generic, operational fallback-decision surface, falsifies the exact
Jetstream counterexample, updates card-118 evidence, and opens a review-only
Northstar PR. Jetstream remains paused on its existing branch.

## Why It Matters

The overlap rule is safe only when fallback is visible and exact. A host stop is
not the same thing as the requesting mode announcing and selecting the frozen
payload. Treating the former as proof of the latter lets a silent or ambiguous
fallback pass the canary.

## Current State

- Repository: `/Users/tom/Dev/projects/northstar`.
- Worker worktree: `/Users/tom/.paseo/worktrees/37pj4ag8/repair-language-package-fallback-notice`.
- Worker branch: `worker/repair-language-package-fallback-notice`.
- Dispatch base `82489d47` is an ancestor of pushed `origin/main` `9a0e5fc`.
- Implementation: `decideFrozenFallback` plus `fallback` CLI on the generic
  lifecycle surface. Every host request/result carries a caller-generated
  `request_id`; both reference hosts echo it. Overlap windows are
  schema-validated and pin TypeScript `@northstar/typescript-quality` `0.1.0`
  as `open`. Detection, mismatched IDs, and a version outside that exact window
  fail closed. Host catch prose includes `@version` without claiming overlap
  fallback.
- Pre-fix counterexample recorded: stopped
  `@northstar/typescript-quality` `0.1.0` with
  `manual or local-path installation route required`, no `@0.1.0`, no frozen
  clause. `oracle-15` and the checker CLI convert that pair into the exact
  notice and fail closed on the nine mutations plus overlap-schema negatives.
- Evidence: `docs/logs/2026-09/02-215000-repair-language-package-fallback-notice.md`.
- Jetstream PR 4 remains paused on its existing branch.
- Merge authority: absent. The worker pushes the same PR and stops.

## Boundaries

- In scope: one core-owned operational surface that consumes a stopped package
  route and emits the exact bounded-overlap fallback notice; request/result
  identity binding; deterministic positive and negative fixtures; card-118
  oracle repair; directly dependent docs/evidence.
- The notice must name the full `package-id@version`, the actual stop reason,
  and that the frozen embedded language payload is in use.
- Preserve the separation between the provider-neutral host and Northstar's
  bounded-overlap policy. Do not disguise fallback as a successful host result
  or make the host claim it executed embedded policy.
- Review-authorized protocol correction: add a caller-generated `request_id`
  to every host request and echo it from every result. Update both reference
  hosts, the v1 schema, all fixtures and installed parity together; reject a
  fallback pair whose IDs differ.
- Add a schema for the overlap-window registry. Each open entry binds language,
  package ID and exact version to its frozen-payload label. Reject detection
  intent and a request version outside that exact window.
- Fail closed when the result is not `stopped`, request/result operations or
  identities disagree, required identity is absent, the language has no frozen
  overlap payload, or the embedded fallback window is closed.
- Keep the implementation generic. No provider/model names, consumer-specific
  branch, mutable registry identity, network requirement, or silent fallback.
- Do not edit Jetstream, the package source, Rust extraction, cards 119-120,
  release/CI surfaces, or unrelated retained findings.
- Work only in the supplied clean worktree. Do not merge.

## Important Context

- `skills/northstar/references/packages/installed-package-route.md` owns the
  exact fallback rule and notice template.
- `skills/northstar/scripts/language-package-lifecycle.ts` is the current
  executable reference surface. Prefer extending the existing generic
  request/result route over adding a second lifecycle implementation.
- `skills/northstar/scripts/check-language-packages.rhai` and its fixtures must
  prove the operational path, not merely scan prose.
- The pre-fix Jetstream-shaped case must fail: a stopped
  `@northstar/typescript-quality` `0.1.0` acquisition that only says
  `manual or local-path installation route required` is not fallback evidence.
- Preserve all accepted package identities, receipts, acquisition behavior,
  installed routing, self-check isolation, and core/package parity.

## Suggested Next Move

Review and merge the Northstar PR, then resume the retained Jetstream PR 4
worker for forced-fallback and hydrated editor validation. Do not start card
119.

## Completion Protocol

1. Require a clean non-`main` worktree at pushed `origin/main` with this handoff
   tracked in `HEAD`. Read the governing contract, spec, route and card.
2. Record the pre-fix failure using the Jetstream-shaped request/result pair.
3. Implement the operational fallback decision without changing the host's
   provider-neutral status grammar or accepted package protocol.
4. Wire deterministic positive and negative proof into
   `check:language-packages` and the normal docs/QA boards. Prove the exact
   notice includes `@northstar/typescript-quality@0.1.0`, the host reason, and
   `using the frozen embedded TypeScript payload during the bounded overlap
   window`.
5. Reconcile card 118, roadmap 048, one dated log, this handoff, and directly
   dependent front doors. Leave Jetstream explicitly paused until this PR
   merges and its retained worker reruns the forced-fallback leg.
6. Run `effigy check:language-packages`, isolated skill-install parity,
   `effigy qa:docs`, `effigy qa`, and `git diff --check`.
7. Integrate current `main` if it moved, revalidate, push, and open a PR with
   the exact tested head. Report through Paseo. Do not merge or start card 119.

Stop if the repair needs fallback semantics beyond the authorized request-ID
correlation and exact-version overlap registry, requires language-specific core
code beyond registered overlap metadata, or validation changes the plan.

## Vision Target Delta

None. This repairs the accepted package-overlap execution seam.

## Next Task

Review and merge the Northstar repair, then resume the existing Jetstream PR 4
worker to rerun forced fallback and hydrate/replay editor validation. Do not
create a replacement Jetstream lane.
