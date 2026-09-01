---
title: Language package machine contracts worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: complete
owner: repo maintainers
created: 2026-09-01
updated: 2026-09-01
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260901-185002-freeze-language-package-machine-contracts.md
base_required: pushed-main
tags: [coordination, handoff, worker, language-quality, packages]
---

## What This Thread Was Doing

The operator settled and promoted Northstar's modular language-package design.
Roadmap g02.048 now sequences the fixture protocol, TypeScript extraction, Rust
extraction, and final embedded-payload removal. Card 116 is the only ready edge.

This dispatches that bounded implementation lane. No transcript or second
prompt is part of the authority chain.

## Why It Matters

Northstar must stay general-purpose as more languages are supported. Freezing
the provider-neutral manifest, registry, receipt, and policy-free fixture first
prevents draft runtime behavior or one language's implementation from becoming
the package protocol accidentally.

## Current State

- **Done in this lane:** Card 116 implemented and validated. Added manifest,
  registry, and receipt schemas; initial official-registry document; policy-free
  fixture package; negative oracle suite; and focused checker.
- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `b1e6691de564170ef5d0f6be306f1dce1dcd8a73`
- **Pushed main verification:** local `HEAD` and `origin/main` both equal the
  planning base before this handoff commit.
- **Planning checkout:** clean before this handoff was created.
- **Worker mode:** implementation worker dispatched by the orchestrator; this
  handoff activates worker-only worktree preflight.
- **Planning artifacts included at the base:** promoted architecture and
  contract 004, roadmap g02.048, and cards 116-120.
- **Worker branch:** `worker/freeze-language-package-machine-contracts`
- **Worker worktree:** Paseo-managed worktree; accept the clean registered
  non-`main` path returned by the launcher regardless of generated path.
- **Worktree creation command:** Paseo `branch-off` from `origin/main` with
  worktree slug `freeze-language-package-machine-contracts`.
- **Required sibling worktree links:** none.
- **Active spec lane:**
  `docs/specs/034-modular-language-quality-packages.md`
- **Roadmap milestone:**
  `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`
- **Ready cards, in order:**
  `docs/roadmaps/g02/batch-cards/116-freeze-language-package-machine-contracts.md`
  (complete).
- **Allowed runway:** card 116 only.
- **Remaining card budget:** one card; stop after the reviewable PR.
- **Dispatch topology:** sole ready frontier lane. Cards 117-120 are serial on
  the reviewed machine contracts produced here.
- **Parallel safety check:** no other worker owns the package-protocol or
  language-quality surfaces.
- **Surfaces this lane owns:** `skills/northstar/references/packages/`, the
  policy-free fixture package, focused package-contract validation and
  fixtures, required Effigy/check wiring, card 116, roadmap 048, one closeout
  log, this handoff, and directly dependent front doors.
- **Integration ownership:** this worker owns card-scoped closeout surfaces;
  the orchestrator owns PR review, merge, and card-117 readiness refresh.
- **Merge ordering:** same-repository PRs merge one at a time; refresh against
  current `main` and revalidate if another Northstar lane merges first.
- **Canonical refs:** `docs/architecture/system-architecture.md`;
  `docs/contracts/004-language-quality-pack.md`.
- **Review oracle:** card 116 `## Review Oracle` and roadmap 048 oracle.
- **Model capability profile:** Cursor Auto; bounded day-to-day implementation
  with exact schemas and a strong negative oracle.
- **Frontier-worker justification:** none.
- **Tool/runtime restrictions:** do not require Effigy, Paseo, a provider, a
  local checkout, or a package host in the reusable package contract. Effigy
  may run validation but is not package transport.
- **Required validation:** focused package-contract check; every named positive
  and negative fixture; isolated `effigy check:skill-install`; `effigy
  qa:docs`; `effigy qa`; `git diff --check`.
- **PR base/head:** `main` <-
  `worker/freeze-language-package-machine-contracts`.
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/21.
- **Review state:** awaiting orchestrator exact-head review.
- **Merge path:** orchestrator after accepted exact-head review and passing
  required checks.

## Boundaries

- **In scope:** card 116's schemas, empty/non-authorizing official registry,
  policy-free fixture, read-only checker, negative suite, parity, and closeout.
- **Out of scope:** remote acquisition, production activation, language
  routing, cards 117-120, TypeScript/Rust extraction, executable fixture code
  before identity validation, and Sentrux integration.
- **Outcome shape:** complete card-116 implementation, falsification evidence,
  pushed branch, and reviewable PR.
- Do not invent architecture, change contract 004, widen the roadmap, or choose
  a new trust, compatibility, hosting, or versioning rule.
- Work only in the clean worker worktree selected by the completion preflight.
  Never edit the planning checkout or merge the PR.

## Important Context

- **Planning lineage:** spec 034 decisions are promoted into system architecture
  and contract 004; roadmap 048, not the retained spec narrative alone, owns
  execution order.
- **Why this card is ready:** all manifest fields and trust/identity owners are
  canonical; scope, paths, validation, stop conditions, and six adversarial
  oracle rows are explicit.
- **Decisions and preferences:** one sibling source repo is only maintenance
  grouping; packages remain independent units. Official trust belongs to core.
  File detection never authorizes acquisition. The fixture carries no
  production language policy.
- **Open tensions:** exact schema encoding and checker implementation are worker
  choices only where they do not change promoted meaning. Return any missing
  field or trust decision to planning.
- **Report after:** schema/fixture/checker batch is coherent and focused
  negative proof runs, or immediately on a stop condition.
- **Report to:** the active Paseo control plane; finish notification will return
  the PR to the orchestrator.

## Suggested Next Move

Run the worker preflight before broad reads. Then read `AGENTS.md`, roadmap 048,
card 116, system architecture, and contract 004. Inventory current schema and
installed-parity conventions, then implement the smallest coherent card-116
batch.

## Completion Protocol

### Before you start

1. Run `git rev-parse --show-toplevel`, `git branch --show-current`, `git status
   --porcelain`, and `git worktree list --porcelain` before broad reads.
2. Use the current context immediately when it is a clean, registered,
   dedicated non-`main` worktree. Record its actual root and branch; do not
   create another because its generated path differs from this handoff.
3. If current context is unusable, inspect the named worktree, then require
   `AGENTS_WORKTREE_CONTAINER_DIR` from `.agents.local.env` for any manual
   fallback. Never use `/tmp`, guess a path, clean, reset, or discard state.
4. In the selected worktree, fetch with
   `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes" git fetch origin`.
   Confirm `HEAD == origin/main`, the planning base is an ancestor, and this
   repository-relative handoff exists in `HEAD`. Compare the tracked blob with
   the absolute file; stop on mismatch. The tracked copy is canonical.
5. Required sibling links are `none`.
6. Read the assigned refs and run only cheap orientation needed for card 116.

### While you work

- Execute card 116 only. Keep implementation and closeout in coherent commits.
- Report changed surfaces, validation, remaining work, and blockers after the
  meaningful schema/fixture/checker chunk.
- Stop on a missing contract field, provider/control-plane coupling, package-
  owned trust, executable-before-identity requirement, scope expansion, or
  validation that changes the plan.
- Do not turn an implementation choice into new architecture silently.

### When the assigned runway is complete

1. Run the required validation listed in `## Current State`.
2. Falsify every card-116 and roadmap oracle row. Prove invalid inputs create no
   receipt, activation, executable side effect, or sibling-package retention.
3. Reconcile card 116, roadmap 048, one dated log, this handoff, and directly
   dependent front doors. Leave card 117 planned; the orchestrator refreshes it
   after merge.
4. Integrate current `origin/main` if it moved, revalidate, and push the worker
   branch.
5. Open a PR against `main` linking the governing refs, changed surfaces,
   evidence, validation, exact tested head, and limits.
6. Report the PR URL and exact head. Do not merge.

### Review and merge path

The orchestrator reviews the exact PR head independently. With a shared GitHub
identity, its PR comment is the canonical verdict. If changes are requested,
the orchestrator will post classified findings and explicitly wake this same
worker. Repair only those in-bounds findings, validate, push, and report a new
head. Accepted review plus required checks and mergeability authorizes the
orchestrator to merge without another approval prompt.

- **Requested changes:** none.
- **Closeout refs:** card 116, roadmap 048, dated log, this handoff, docs and
  roadmap front doors.

### Handoff closeout

Leave card, roadmap, log, and next-task state honest. A blocker stays visible;
do not make card 117 ready or make this handoff look complete without the
required proof.
