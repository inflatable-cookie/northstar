---
title: Repair partial Rust evidence collection worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-09-01
updated: 2026-09-01
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260901-075536-repair-partial-rust-evidence-collection.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, papercuts, rust-quality]
---

## What This Thread Was Doing

Signal's `g11.003` audit found that a partial second Rust-quality `collect`
call can fabricate audit-wide `unrun` records contradicting immutable evidence.
The Signal orchestrator classified implementation ownership as Northstar and
promoted one bounded live-use correction lane.

This dispatches that implementation lane. No transcript or second prompt is
part of the authority chain.

## Why It Matters

False limitations make a finalized audit misrepresent its validation state and
force consumers to restart otherwise valid work. Northstar owns the installed
collector contract; Signal owns only the originating report and later papercut
closure.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `f4b4a088721be95ff7981dbcc63f673dfceeac2a`
- **Pushed main verification:** local `HEAD` equalled `origin/main` after push
- **Planning checkout:** clean before this handoff commit
- **Worker mode:** implementation worker dispatched by the orchestrator
- **Planning artifacts:** `g02.041` and ready card `g02.041/109`
- **Worker branch:** `worker/repair-partial-rust-evidence-collection`
- **Worker worktree:** Paseo-managed; launcher-selected path is authoritative
- **Worktree creation:** Paseo `branch-off` from `origin/main`
- **Required sibling worktree links:** none
- **Active lane:** baseline-routed live-use correction
- **Roadmap milestone:** `docs/roadmaps/g02/041-repair-partial-rust-evidence-collection.md`
- **Ready card:** `docs/roadmaps/g02/batch-cards/109-repair-partial-rust-evidence-collection.md`
- **Allowed runway:** one reproduce, diagnose, repair, evidence, closeout, and PR lane
- **Remaining card budget:** one card
- **Dispatch topology:** serial; no duplicate collector lane exists
- **Canonical refs:** `docs/contracts/004-language-quality-pack.md`,
  `docs/specs/033-rust-audit-v2-tool-enforcement.md`,
  `skills/northstar/references/language-quality/rust/evidence-collection.md`
- **Review oracle:** milestone `g02.041` and card `109`
- **Model capability profile:** capable coding worker; medium or stronger reasoning
- **Tool restrictions:** no Signal mutation, audit-record rewriting, release mutation, or workflow edit
- **Required validation:** focused Rust-quality tests,
  `effigy check:rust-quality`, `effigy check:skill-install`,
  `effigy qa:docs`, `effigy qa`, and `git diff --check`
- **PR base/head:** `main` ← `worker/repair-partial-rust-evidence-collection`
- **PR URL:** pending
- **Review state:** awaiting worker PR
- **Merge path:** orchestrator after accepted exact-head review and passing checks

## Boundaries

- **In scope:** card 109 and directly affected collector, focused tests,
  compact reference, roadmap/card/log closeout surfaces.
- **Out of scope:** Signal source or Git metadata, evidence deletion or rewrite,
  schemas, rule catalogue, detectors, wider lifecycle refactors, consumer reruns,
  `.github/workflows/`, and releases.
- **Outcome:** smallest complete contract-valid fix. Reproduce first, diagnose,
  remove temporary diagnostics, validate, record evidence, and open one PR.
- Do not choose a public schema or CLI change. Stop if one is required.
- Do not merge. Exact-head review and merge belong to the orchestrator.

## Important Context

- Signal recorded 42 false `unrun-<class>-<unit>` limitations after a partial
  second call omitted requests already represented by sealed passing records.
- Current `collect` tracks represented classes only in the current plan and
  expands an absent class across every audit unit. Treat this as a lead to
  falsify, not a preselected edit.
- Existing evidence and raw artifacts are immutable. A correction must preserve
  their bytes and fail before mutation on ambiguous or contradictory input.
- The legitimate first-call no-selector limitation must survive.
- No active agent, branch, or PR matched this collector defect at dispatch.
- Report after reproduction and again at PR-ready closeout.
- Report through Paseo to the originating orchestrator.

## Suggested Next Move

Run the worker preflight below before broad reads. Then read `AGENTS.md`, the
milestone, card, collector reference, and existing focused tests. Reproduce the
two-call failure in a fixture before editing implementation.

## Completion Protocol

### Before You Start

1. This handoff activates worker mode. Run only:
   `git rev-parse --show-toplevel`, `git branch --show-current`,
   `git status --porcelain`, and `git worktree list --porcelain`.
2. Accept a clean registered non-`main` launcher worktree as authoritative,
   regardless of its generated path or branch. Do not create another worktree.
3. If the launcher supplied `main`, a dirty tree, or an unregistered checkout,
   stop and report it. A manual fallback requires the repository's
   `AGENTS_WORKTREE_CONTAINER_DIR`; never guess a path or clean user work.
4. From the selected worktree run
   `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes" git fetch origin`.
   Confirm `HEAD == origin/main`, confirm the planning base is an ancestor of
   `HEAD`, and load the tracked copy of this handoff. Stop if the absolute and
   tracked copies differ.
5. Required sibling links are `none`.
6. Read the milestone, card, `AGENTS.md`, and canonical refs. Use Effigy for
   repository-owned validation.

### While You Work

- Own the full issue-fix loop inside card 109. Diagnosis alone is not complete.
- Keep immutable evidence byte-for-byte and prove that preservation.
- Try both adversarial paths: existing evidence omitted from a later plan, and
  genuinely missing applicable evidence in the later call's resolved scope.
- Stop on a needed schema/CLI decision, evidence mutation, overlapping lane,
  wider lifecycle defect, or validation result that changes the plan.
- Do not touch Signal. Record the Northstar merge evidence needed for the
  orchestrator to close Signal's papercut later.

### When Complete

1. Run the required validation and `git diff --check`.
2. Falsify the diff against every milestone oracle row. Inventory every new
   evidence record and compare pre-existing record hashes.
3. Mark card and milestone state honestly, add a closeout log under
   `docs/logs/2026-09/`, and align Northstar front doors. Leave Signal closure
   to the orchestrator after merge.
4. Push the worker branch and open a PR to `main` linking the milestone, card,
   changed surfaces, reproduction, preservation proof, validation, and limits.
5. Report PR URL and exact head through Paseo. Do not merge.

### Review And Merge

The orchestrator reviews the exact PR head independently and records its verdict
on the PR. If changes are requested, it will explicitly wake this same worker;
repair only those findings on this branch. Once the reviewed head is accepted,
required checks pass, and the PR is mergeable, the orchestrator may merge
without another operator prompt. It then reconciles Northstar closeout state
and closes the originating Signal papercut separately.
