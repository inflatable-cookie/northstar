# 132 - Make Compact Lifecycle the Default

Status: blocked-ready; card 130 merge required
Owner: repo maintainers
Created: 2026-09-04
Master roadmap: `g03.001`
Governing refs: spec 038, contract 001
Auto-start next card: no

## Objective

Make one compact strict lifecycle the reusable Northstar default and remove
light/baseline/lane-first/mixed/full-strict posture variants as supported
steady-state protocols.

## Approved dispatch manifest

- **Lane:** `g03.001/132`
- **State:** blocked-ready until card 130 merges; then ready
- **Prerequisites:** card 130 merged and lifecycle checks green
- **Completion:** reusable doctrine, templates, skills, setup, and checks expose
  one compact lifecycle with incremental adoption described only as migration;
  coordinator closeout synchronizes and verifies the local integration checkout
  after every merge
- **Approved concurrent siblings:** card 131 after the shared prerequisite
- **Serial edges:** card 130 before dispatch
- **Worker class:** economical general/day-to-day implementation agent with
  documentation and deterministic-check competence; not an auditor, planner,
  coordinator, or documentation-grind profile
- **Reviewer class:** independent semantic reviewer using a different
  provider/model identity from the worker
- **Escalation owner:** Chatterbox for any behavior or compatibility choice

Owned mutable paths:

- `bundle-docs/**`;
- `template-bundle/**`;
- `skills/northstar/**`;
- reusable posture/lifecycle checks, fixtures, and their direct callers under
  `scripts/**`;
- installed Northstar skill destination selected by the existing parity task;
- this card's compact closeout.

Card 131 owns Northstar live generation/log/handoff compaction and current
front doors. It also exclusively owns these deletion-coupled callers:
`scripts/lib/northstar-repo-contract-data.rhai`,
`scripts/check-northstar-model-routing.rhai`,
`scripts/check-northstar-command-skills.rhai`,
`scripts/test-northstar-repo-contract.rhai`, and
`scripts/fixtures/readiness-map/**`. Card 132 must not edit them. Neither sibling
may edit the other's paths. Any other direct caller outside these surfaces
returns to Chatterbox.

## Required work

1. Replace posture selection with one compact lifecycle and a bounded
   incremental-adoption description.
2. Make specs, detailed evidence, research, and additional authority files
   consequence-triggered modules rather than a second posture.
3. Remove template boilerplate and duplicated protocol defaults from cards and
   handoffs; lane artifacts carry only required fields and deviations.
4. Encode prune triggers for triage, handoffs, cards, routine logs, promoted
   specs, and closed generations.
5. Replace repeated currentness/history prose with kernel pointers or stable
   structural derivation where that is genuinely mechanical.
6. Refresh installed parity and update deterministic checks without preserving
   retired posture vocabulary as compatibility theatre.
7. Make post-merge local integration reconciliation mandatory before card
   closeout, frontier recomputation, or another worker dispatch:
   - resolve and verify the provider's merged PR and resulting `origin/main`;
   - fetch the integration remote, fast-forward the project's local `main`
     checkout to `origin/main`, and verify the local and remote heads match;
   - base all later closeout and dispatch facts on that synchronized head;
   - if the local integration checkout is dirty, not on `main`, or cannot
     fast-forward, preserve it unchanged and send Chatterbox a context-complete
     reconciliation blocker. Never reset, stash, rebase, discard, or dispatch
     from the stale local base.

## Acceptance evidence and review oracle

- [ ] setup and routing expose one normal compact lifecycle;
- [ ] repository-wide search finds no supported alternative steady-state
      posture; historical evidence may name old terms only where clearly
      non-authoritative;
- [ ] a new consumer can start small without being classified into a lighter
      protocol;
- [ ] strict authority, ready-card, review, evidence, and stop protections are
      unchanged;
- [ ] a merge fixture proves provider merge -> remote fetch -> local `main`
      fast-forward -> exact local/remote-head verification occurs before
      closeout and next dispatch;
- [ ] dirty, wrong-branch, divergent, fetch-failure, and head-mismatch fixtures
      stop without mutation beyond the safe fetch and emit a context-complete
      Chatterbox blocker;
- [ ] no successful-merge path can report closeout or create the next worker
      from a stale local integration head;
- [ ] template file count and repeated required boilerplate decrease with an
      exact before/after inventory;
- [ ] `git diff --check`, focused checks, `effigy qa:docs`, `effigy qa`, and
      source/install parity pass;
- [ ] independent exact-head review tests for lost functionality and hidden
      compatibility aliases.

## Stop conditions

- removing a posture term would silently change an incident-proven safety gate;
- a consumer-visible compatibility choice needs operator intent;
- safe fast-forward would require overwriting, stashing, rebasing, resetting, or
  otherwise resolving concurrent local integration work;
- sibling path ownership collides;
- validation changes the plan.
