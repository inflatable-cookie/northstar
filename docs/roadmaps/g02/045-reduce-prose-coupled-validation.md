# 045 - Reduce Prose-Coupled Validation

Status: complete; card 113 implementation complete; awaiting exact-head review
Owner: repo maintainers
Created: 2026-09-01
Depends on: `g02.044`, closed live-orchestrator dogfood cohort
Vision tags: `general-purpose`, `validation`, `simplification`
Governing refs: `docs/vision/001-northstar-delivery-vision.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`,
`docs/logs/2026-09/01-140857-close-live-dogfood-and-plan-reduction.md`
Planning state: the structural checker reduction, active-authority
reconciliation, machine-contract checks, and fixture proof are complete on the
worker branch; the orchestrator owns exact-head review and merge.

## Problem

Northstar's repo-contract checker mixes structural invariants with hundreds of
exact substring assertions and a required-path inventory containing individual
historical cards, milestones, logs, and closed specs. It can reject harmless
editorial movement while still relying on human review for semantic drift.

The first-principles audit and 26-packet dogfood cohort justify one bounded
experiment: retain structural failures, remove editorial coupling, and prove
both sides with deterministic fixtures.

## Goals

- keep stable root and docs entry points required;
- keep active authority entry points, portable links, canonical/mirror parity,
  readiness fixtures, command-surface checks, and install parity;
- remove exact prose-presence and prose-absence assertions;
- remove historical cards, milestones, logs, and closed specs from the
  required-path inventory;
- add representative benign editorial fixtures from the live cohort;
- add adversarial structural fixtures that still fail;
- leave the checker smaller and easier to explain than before.

## Non-Goals

- no orchestration-protocol change;
- no language-package extraction;
- no Paseo product or lifecycle implementation;
- no replacement editorial schema or generated prose manifest;
- no weakening of source/install parity, link integrity, readiness-map tests,
  command-skill checks, or full repository QA;
- no deletion of historical evidence merely because it stops being a required
  checker path.

## Execution Plan

Card `g02.045/113` owns the checker classification, reduced implementation,
fixture harness, deterministic proof, documentation, and closeout in one lane.
The worker may choose the smallest Rhai fixture organization but may not invent
new currentness metadata or broaden into general docs cleanup.

## Acceptance Criteria

- [x] every old `required_files` entry is classified as stable structure, active
  authority, executable validation surface, parity surface, or historical
  inventory;
- [x] the live required-path list contains no individual historical batch card,
  milestone, log, or closed spec;
- [x] prose assertion data and execution paths are removed;
- [x] current active-authority paths and independently stable machine contracts
  remain structurally protected;
- [x] stable front-door deletion, broken distributed-skill links, and canonical
  mirror drift each fail deterministically;
- [x] missing active authority, Claude bridge, and docs-QA wiring fail through
  targeted negative fixtures;
- [x] representative token-like prose, front-door wording changes, papercut
  closeouts, historical-evidence movement, and source-preserving partitions
  pass without exact wording exceptions;
- [x] no fixture depends on a consumer checkout or copies private provider
  state;
- [x] the reduced checker, its tests, docs, and task wiring are coherent;
- [x] `effigy qa:docs`, `effigy qa`, and `git diff --check` pass on the final
  closeout head.

## Review Oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Stable structure remains protected. | Remove one stable root or docs front door from an isolated fixture. | Checker fails before success. | Negative fixture names the missing path. |
| Distributed navigation remains valid. | Break one relative link inside the skill payload. | Checker fails on the broken link. | Negative link fixture. |
| Canonical mirrors remain exact. | Change one side of the batch-card template pair. | Checker fails parity. | Negative parity fixture. |
| Editorial prose is not schema. | Reword a `Next Task` or move a supersession paragraph without changing structure. | Checker passes. | Benign editorial fixtures. |
| Token-like benign text is not forbidden policy. | Add `mask-plus-translated-highlight` to Markdown. | Repo-contract checker passes; security scanning remains separately owned. | Benign token fixture. |
| Historical inventory is not live structure. | Remove a historical-card path from an isolated required-path fixture. | Checker does not require it. | Classification inventory plus fixture. |
| Current active authority remains live structure. | Remove `docs/specs/034-modular-language-quality-packages.md` from an isolated fixture. | Checker fails with the missing authority path. | `missing-active-authority` fixture. |
| Stable machine contracts remain executable. | Remove the Claude bridge or repo-contract tasks from the docs-QA sequence. | Targeted machine check fails. | `missing-claude-bridge` and `missing-qa-wiring` fixtures. |
| The reduction is real. | Leave a hidden or renamed substring assertion path. | Review rejects the head. | Search proof for removed assertion classes and old historical inventory. |

## Stop Conditions

- a structural invariant needs a new metadata or compatibility design;
- the worker cannot distinguish a stable entry point from historical evidence
  using the classifications above;
- a reduced checker would stop validating links, parity, readiness, command
  surfaces, or installed payloads;
- the lane requires consumer-repository mutation or synthetic dogfood;
- validation changes the plan.

## Next Task

Review the worker PR against all seven oracle rows and merge only after the
exact-head and required-check gate passes. Spec 034 remains a separate
not-ready planning lane; do not auto-start language extraction.
