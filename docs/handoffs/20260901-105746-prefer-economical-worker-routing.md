---
title: Prefer economical worker routing
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-09-01
updated: 2026-09-01
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260901-105746-prefer-economical-worker-routing.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, model-efficiency]
---

## What This Thread Was Doing

Operator feedback showed ordinary Paseo workers being routed to the most
expensive frontier profile because broad risk domains and generic “high
complexity” labels were treated as sufficient escalation. Planning now settles
an economical default: use matching non-frontier day-to-day profiles for
ordinary implementation, audits, and mechanical work. A frontier worker is a
rare conjunctive exception requiring both exceptional reasoning difficulty
after planning and highest priority or material consequence.

This dispatches one bounded implementation lane. No transcript or second prompt
is part of the authority chain.

## Why It Matters

Frontier orchestration and review remain valuable, but spending frontier worker
capacity on routine execution wastes cost without improving the authority or
review boundary. The reusable protocol needs to make the cheaper matching
profile the obvious default while preserving strong review for risky changes.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `b3adf0c696ae4da9a3f9ef3f85e3b619c66d3399`
- **Pushed main verification:** local `HEAD` and `origin/main` both equal the
  planning base before this handoff commit
- **Planning checkout:** clean at dispatch preparation
- **Worker mode:** implementation worker dispatched by the orchestrator; this
  handoff activates the worker-only worktree preflight
- **Planning artifacts included at the base:** spec 026 model policy,
  `g02.043`, card 111, and current front-door routing
- **Worker branch:** `worker/prefer-economical-worker-routing`
- **Worker worktree:** Paseo-managed dedicated worktree; accept its actual path
- **Worktree creation command:** Paseo `branch-off` from `origin/main`
- **Required sibling worktree links:** none
- **Active spec lane:** `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
- **Roadmap milestone:** `docs/roadmaps/g02/043-prefer-economical-worker-routing.md`
- **Ready cards, in order:** `docs/roadmaps/g02/batch-cards/111-prefer-economical-worker-routing.md`
- **Allowed runway:** card 111 only
- **Remaining card budget:** one card
- **Dispatch topology:** one ready lane; no sibling frontier lane
- **Parallel safety check:** serial because this is the only ready lane, not
  because unrelated work was withheld
- **Surfaces this lane owns:** architecture/working-rules/doctrine/operator and
  copy-ready projections; Northstar skill and handoff-template projections;
  deterministic repo-contract checks; card/milestone/log/front-door closeout
- **Integration ownership:** this single worker owns its bounded closeout; the
  orchestrator owns review, merge, installed-skill refresh, and notifying other
  orchestrator threads
- **Merge ordering:** no sibling Northstar worker PR is active for this lane
- **Canonical refs:** `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`;
  `docs/contracts/001-working-rules.md`;
  `docs/architecture/system-architecture.md`;
  `bundle-docs/sections/07-delivery-framework-and-autonomy.md`
- **Review oracle:** milestone 043 and card 111
- **Model capability profile:** non-frontier day-to-day implementation profile;
  current adapter notes explicitly cover the majority of ordinary worker
  handoffs
- **Tool/runtime restrictions:** use Effigy tasks; do not edit workflows or
  mutate Paseo profiles
- **Required validation:** `effigy check:command-skills`, isolated
  `effigy check:skill-install`, `effigy qa:docs`, `effigy qa`, and
  `git diff --check`
- **PR base/head:** `main` <- `worker/prefer-economical-worker-routing`
- **PR URL:** pending
- **Review state:** awaiting worker PR
- **Merge path:** orchestrator after accepted review of the current head and
  passing required checks

## Boundaries

- **In scope:** execute card 111 exactly and open the reviewable PR.
- **Out of scope:** provider prices, model IDs, local profile names in reusable
  policy, Paseo profile changes, scheduler work, mid-run worker replacement,
  weaker review gates, or a new model-routing architecture.
- **Outcome shape:** protocol and distribution implementation with deterministic
  scenario evidence, closeout, and PR.
- Treat spec 026's two-axis rule as settled planning. Return any contradiction
  or material new routing choice to the orchestrator instead of rewriting it.
- Keep frontier review for security, persistence, concurrency, public API,
  deployment, and multi-version work. Remove only their automatic frontier
  **worker** trigger.
- Do not merge the PR. Merge belongs to the orchestrator after its
  accepted-review/check gate.

## Important Context

- Current configured profile notes distinguish day-to-day worker profiles from
  a frontier worker reserved for the highest-priority, highest-complexity work.
  This is dispatch evidence, not reusable policy vocabulary.
- “High priority” and “exceptional reasoning difficulty after planning” are
  separate gates. Frontier worker routing requires both and a matching profile.
- File count, repository breadth, duration, audit size, documentation churn, or
  a risk-domain label does not satisfy either gate by itself.
- A risky but well-specified direct implementation may use a capable
  non-frontier worker while the frontier orchestrator retains material review.
- Multiple plausible product or architecture designs mean planning is
  incomplete. Return them; do not spend a frontier worker to choose.
- If no non-frontier profile fits ordinary work, expose the profile gap rather
  than silently escalating.
- Report after the implementation/projection/check batch or immediately on a
  stop condition.
- Report through Paseo to the originating orchestrator.

## Suggested Next Move

Run the worker preflight, read the milestone, card, settled spec section, and
owned canonical projections, then inventory every existing model-routing claim
before editing. Implement one coherent batch and falsify all seven oracle rows.

## Completion Protocol

### Before you start

1. This handoff activates worker mode. Before broad reads run
   `git rev-parse --show-toplevel`, `git branch --show-current`,
   `git status --porcelain`, and `git worktree list --porcelain`.
2. Accept a clean registered non-`main` current worktree as Paseo-provided,
   regardless of generated path or branch-name differences. Record it and do
   not create another worktree.
3. If the launcher supplied `main`, dirty, or unusable state, stop and report it.
   Only a manual fallback may use `.agents.local.env` and its explicit
   `AGENTS_WORKTREE_CONTAINER_DIR`; never guess a path or clean existing work.
4. Fetch with
   `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes" git fetch origin`.
   Confirm `HEAD == origin/main`, the planning base is an ancestor, and this
   repository-relative handoff exists at `HEAD`. Compare its tracked blob with
   the absolute dispatch file and stop on mismatch.
5. Required sibling links are `none`.
6. Read `AGENTS.md`, milestone 043, card 111, spec 026's model policy, and the
   named canonical refs. Run cheap orientation checks.

### While you work

- Execute only card 111. Keep commits aligned with meaningful batches.
- Preserve provider neutrality. Current profile notes are evidence for the
  dispatch defect, not names to encode in Northstar.
- Add deterministic positive and negative checks that would fail if the broad
  risk-domain automatic frontier rule returned or if either escalation axis
  became sufficient alone.
- Keep the frontiers distinct: economical worker selection does not weaken
  review-oracle or material-review rigor.
- Stop on missing authority, contradictory planning, scope expansion, or a
  validation result that changes the plan.

### When the assigned runway is complete

1. Run all required validation named above.
2. Falsify the diff against every milestone 043 oracle row. Reconcile source,
   install, doctrine, contract, skill, template, operator, card, roadmap, log,
   and front-door claims.
3. Mark card/milestone execution state honestly and write the closeout log.
4. Push the worker branch and open a PR against current `main`.
5. Report PR URL, exact head, changed-surface inventory, scenario evidence,
   validation, limitations, and any decisions returned to planning.
6. Stay on this branch for review findings. A PR comment does not wake you; the
   orchestrator will explicitly prompt this same Paseo agent if revision is
   needed. Do not merge.
