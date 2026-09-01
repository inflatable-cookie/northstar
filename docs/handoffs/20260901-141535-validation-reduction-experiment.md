---
title: Validation reduction experiment worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: awaiting-exact-head-review
owner: repo maintainers
created: 2026-09-01
updated: 2026-09-01
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260901-141535-validation-reduction-experiment.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, validation, simplification]
---

## What This Thread Was Doing

The operator accepted the first-principles audit's freeze-and-reduce direction.
A 26-packet passive dogfood window is now closed and promoted. Canonical
planning settles one bounded experiment: preserve Northstar's structural
validation while removing exact prose assertions and historical-file inventory
from the repo-contract checker.

This dispatches one bounded implementation lane. No transcript or second prompt
is part of the authority chain.

## Why It Matters

Northstar's docs validation should protect authority shape, links, parity, and
executable surfaces. It should not make ordinary wording changes expensive or
turn old planning files into permanent schema. This experiment tests that
boundary directly, with adversarial structural fixtures and benign editorial
fixtures before any wider simplification work proceeds.

## Current State

Here is the state the worker is inheriting:

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `f9e1e8bff016f939764f18f9a0d8c0a661325600`
- **Pushed main verification:** local `HEAD` and `origin/main` both equal the
  planning base before this handoff commit; the orchestrator will push and
  verify the handoff commit before dispatch.
- **Planning checkout:** clean before this handoff; the worker must not edit it.
- **Worker mode:** implementation worker dispatched by the orchestrator; this
  handoff activates the worker-only worktree preflight.
- **Planning artifacts included at the base:** the closed dogfood evidence log,
  modular-language spec 034, milestone `g02.045`, card 113, and the live
  architecture/contract/front-door decisions.
- **Worker branch:** `worker/validation-reduction-experiment`
- **Worker worktree:** Paseo-managed worktree; the actual launcher path is
  authoritative.
- **Worktree creation command:** Paseo `branch-off` from pushed `origin/main`.
- **Worker worktree policy:** follow `Completion Protocol`; launcher worktree
  first, named/manual fallback only when required.
- **Required sibling worktree links:** none.
- **Active spec lane:** none; spec 034 remains planning-only and out of scope.
- **Roadmap milestone:**
  `docs/roadmaps/g02/045-reduce-prose-coupled-validation.md`
- **Ready cards, in order:**
  `docs/roadmaps/g02/batch-cards/113-run-validation-reduction-experiment.md`
- **Allowed runway:** card 113 only.
- **Remaining card budget:** one card.
- **Dispatch topology:** one Northstar implementation lane; no sibling worker
  lane is launched against this repository.
- **Parallel safety check:** no other active Northstar lane owns the checker,
  its fixtures, task wiring, or card 113 closeout surfaces.
- **Surfaces this lane owns:**
  `scripts/check-northstar-repo-contract.rhai`,
  `scripts/lib/northstar-repo-contract-data.rhai`, focused repo-contract
  fixtures/tests and their minimal harness, `effigy.toml`, `scripts/README.md`,
  milestone 045, card 113, one dated closeout log, and directly dependent
  Northstar front-door currentness.
- **Integration ownership:** the worker owns its complete card closeout. Keep
  spec 034 and the simplification open-questions triage packet unchanged.
- **Merge ordering:** same-repository PRs merge one at a time; the orchestrator
  refreshes this head against current `main` and re-reviews it if another lane
  merges first.
- **Canonical refs:** `docs/architecture/system-architecture.md`;
  `docs/contracts/001-working-rules.md`;
  `docs/logs/2026-09/01-140857-close-live-dogfood-and-plan-reduction.md`.
- **Review oracle:** all seven rows in milestone `g02.045` and card 113.
- **Model capability profile:** matching low-cost mechanical implementation
  profile selected from current Paseo profile notes.
- **Frontier-worker justification:** none.
- **Tool/runtime restrictions:** do not edit `.github/workflows/`, mutate
  installed skills or Paseo configuration, change orchestration behavior,
  extract language packages, touch consumer repositories, or introduce a new
  currentness schema.
- **Required validation:** focused repo-contract fixture task; unchanged
  readiness-map and command-skill checks; `effigy qa:docs`; `effigy qa`;
  `git diff --check`.
- **PR base/head:** `main` <- `worker/validation-reduction-experiment`.
- **PR URL:** https://github.com/inflatable-cookie/northstar/pull/18
- **Implementation-tested head:** `9eb8c6be23ef668ff9dfcf456e4983b9014263a0`.
- **Review state:** worker implementation and focused/full validation complete;
  awaiting orchestrator exact-head review.
- **Merge path:** orchestrator after accepted review of the current head and
  passing required checks.

## Boundaries

Please keep this run inside card 113:

- **In scope:** classify the old repo-contract path inventory, reduce it to the
  settled structural boundary, remove the two prose assertion classes, add the
  focused positive and negative fixtures, wire them into docs QA, document the
  checker boundary, reconcile closeout, and open a PR.
- **Out of scope:** language-package extraction, orchestration/autonomy changes,
  Paseo behavior, consumer mutations, new state/currentness metadata, broad docs
  cleanup, mode consolidation, or deletion of historical evidence.
- **Outcome shape:** implementation. Make the smallest complete structural
  checker reduction, prove retained failures and newly tolerated prose changes,
  update evidence, and create the reviewable PR.
- Do not invent architecture, change contracts, widen the roadmap, or choose an
  unresolved product/API/persistence/security decision.
- This handoff represents one worker lane. If another lane begins touching an
  owned surface, stop and report the overlap rather than resolving it silently.
- Work only in the clean worker worktree selected by `Completion Protocol`.
  Never edit the planning checkout or an unrelated dirty checkout.
- Do not merge the PR. Merge belongs to the orchestrator after its accepted
  review/check gate.

## Important Context

- **Planning lineage:** the first-principles audit found roughly twelve-surface
  protocol change amplification and prose-asserting validation. The operator
  accepted a freeze, passive dogfood window, and reduction experiment. The
  closed cohort found real value in structural/docs QA but also a reproducible
  benign token-like false positive and several semantic defects that only human
  review caught.
- **Why this card is ready:** the dogfood window is closed, the retained
  structural boundary is canonical, every intended counterexample is named,
  and the operator approved the experiment.
- **Decisions and preferences:** validation protects structure and executable
  invariants, not editorial wording. Stable front doors, links, parity,
  readiness, command surfaces, and install parity stay protected. Individual
  historical cards, milestones, logs, closed specs, and exact prose do not.
- **Open tensions:** the current data file mixes live and historical paths. If
  any entry cannot be classified under the milestone categories without a new
  schema or policy decision, stop and return it to planning.
- **Report after:** the full implementation and validation batch, or immediately
  on a stop condition.
- **Report to:** the operator through Paseo; the orchestrator retains exact-head
  review and merge authority.

## Suggested Next Move

Run the `Completion Protocol` preflight. Read `AGENTS.md`, milestone 045, card
113, the architecture and working-rules refs, then inventory the checker and its
data before mutation. Record a before classification and counts. Design the
smallest deterministic fixture harness that exercises all seven oracle rows,
then implement one coherent reduction batch.

## Completion Protocol

### Before you start

1. Before broad reads, run `git rev-parse --show-toplevel`,
   `git branch --show-current`, `git status --porcelain`, and
   `git worktree list --porcelain`.
2. Reuse a clean registered non-`main` launcher worktree. Its actual generated
   root and branch are authoritative; do not create another because they differ
   from the planned names above.
3. If the launcher context is `main`, dirty, unregistered, or unusable, stop and
   report it. Do not clean, reset, stash, discard, or overwrite another checkout.
4. From the selected worktree, record this handoff's repository-relative path.
   Fetch with
   `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes" git fetch origin`.
   Confirm `HEAD == origin/main`, confirm the planning base is an ancestor, and
   confirm this handoff exists in `HEAD`. Load it with `git show`; if the
   absolute dispatch file differs from the tracked blob, stop.
5. Required sibling links are `none`; create none.
6. Read the active milestone, assigned card, `AGENTS.md`, and canonical refs.
7. Run the repo's cheap orientation checks and record what actually ran.

### While you work

- Execute card 113 only. Keep commits aligned with meaningful chunks.
- Preserve the old required-path classification as closeout evidence, not as
  dead executable policy.
- Exercise every negative fixture and verify its failure reason. Exercise every
  benign fixture without adding wording-specific exceptions.
- Keep readiness-map, command-skill, install-parity, link, and mirror checks
  intact. If the reduction weakens one, stop.
- Report changed files, actual validation, remaining work, and blockers after a
  meaningful batch. Do not turn an open question into architecture.

### When the assigned runway is complete

1. Run the focused repo-contract fixture task, unchanged readiness-map and
   command-skill checks, `effigy qa:docs`, `effigy qa`, and
   `git diff --check`.
2. Falsify the diff against all seven milestone rows. Include missing-front-door,
   broken-link, parity-drift, token-like-prose, editorial-rewording, and
   historical-path cases. Search for hidden or renamed assertion paths.
3. Reconcile card 113, milestone 045, a dated closeout log, handoff status, and
   directly dependent front-door currentness. Do not start spec 034.
4. Push the selected worker branch. If `main` moved, integrate current `main`,
   rerun validation, and report the new exact head.
5. Open a reviewable PR against current `main`. Link the milestone, card,
   changed surfaces, before/after counts, fixture evidence, validation, and any
   unresolved item.
6. Report the PR URL and exact tested head through Paseo. Do not merge.

### Review and merge path

The orchestrator reviews the PR against the canonical refs, diff, checks, and
all seven oracle rows. If changes are requested, stay on the same branch and
repair only the posted findings. Blocking classes are `execution-miss`,
`oracle-gap`, `planning-change`, `validation-gap`, and `integration-drift`; a
`planning-change` returns to planning before revision. The orchestrator may
merge an accepted current head after required checks pass and mergeability is
clear, without another operator prompt.

- **Requested changes:** none.
- **Closeout refs:** card 113, milestone 045, one dated log,
  `docs/README.md`, roadmap front doors, generation index, and checker/task
  documentation.

### Handoff closeout

Before calling the runway complete, leave the card, roadmap, log, and next-task
state honest. If blocked, record the blocker and stop rather than making the
handoff look complete.
