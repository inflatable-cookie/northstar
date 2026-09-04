# 132 - Make Compact Lifecycle the Default

Status: ready; merged implementation requires README follow-up
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
- **State:** ready for the bounded post-merge README correction below
- **Prerequisites:** card 130 merged and lifecycle checks green
- **Completion:** reusable doctrine, templates, skills, setup, and checks expose
  one compact lifecycle with incremental adoption described only as migration;
  coordinator closeout synchronizes and verifies the local integration checkout
  after every merge
- **Approved concurrent siblings:** none; cards 130 and 131 are merged
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

## Post-merge README correction

Chatterbox ruling, 2026-09-05: spec 038's single-lifecycle decision and this
card's original repository-wide oracle require root `README.md` to agree with
the reusable setup doctrine. This is completion of approved intent, not a new
posture choice or a weaker acceptance rule.

PR #38 merged at `8de64926351a47273cd4be66c51f3708888899ef` after acceptance
of `6cc2ac0f4443922cb5e209bb072a1130b6b857ab`. The accepted review left root
README posture wording as follow-up. That exception did not satisfy the
repository-wide row. Preserve both provider records and merge history.

The remaining execution scope supersedes the broad initial path list above:

- Own root `README.md` only for compact-lifecycle setup, posture, and directly
  coupled onboarding wording. Reserve that exact path away from card 131.
- Own this card's follow-up evidence. Chatterbox reserves the milestone, spec,
  and currentness front doors for reconciliation.
- Replace Baseline versus Strict and the posture-selection migration ladder
  with the single compact lifecycle, consequence-triggered modules, and bounded
  migration. Keep copy commands consistent with the shipped bundle.
- Do not redesign the README or reopen other merged implementation surfaces.
  A repository-wide search finding outside this scope returns to Chatterbox.
- Resume the retained card-132 worker from synchronized current main for a new
  follow-up PR. Reuse its retained independent reviewer; do not amend the merged
  PR, rewrite history, or create a new implementation lane.
- Validate the complete correction with `git diff --check`, `effigy qa:docs`,
  and `effigy qa`. Review must test a fresh consumer's setup path against the
  shipped kernel and search repository-wide for supported alternative postures.
- Close the open acceptance row only after that evidence and independent review
  support it. Record the follow-up PR, accepted head, merge commit, and limits
  here; synchronize local main before closeout.

All original safety and acceptance requirements remain in force. After this
correction merges, return to Chatterbox for full `g03.001` reconciliation.

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

- [x] setup and routing expose one normal compact lifecycle;
- [ ] repository-wide search finds no supported alternative steady-state
      posture; historical evidence may name old terms only where clearly
      non-authoritative;
- [x] a new consumer can start small without being classified into a lighter
      protocol;
- [x] strict authority, ready-card, review, evidence, and stop protections are
      unchanged;
- [x] a merge fixture proves provider merge -> remote fetch -> local `main`
      fast-forward -> exact local/remote-head verification occurs before
      closeout and next dispatch;
- [x] dirty, wrong-branch, divergent, fetch-failure, and head-mismatch fixtures
      stop without mutation beyond the safe fetch and emit a context-complete
      Chatterbox blocker;
- [x] no successful-merge path can report closeout or create the next worker
      from a stale local integration head;
- [x] template file count and repeated required boilerplate decrease with an
      exact before/after inventory;
- [x] `git diff --check`, focused checks, `effigy qa:docs`, `effigy qa`, and
      source/install parity pass;
- [x] independent exact-head review tests for lost functionality and hidden
      compatibility aliases.

## Stop conditions

- removing a posture term would silently change an incident-proven safety gate;
- a consumer-visible compatibility choice needs operator intent;
- safe fast-forward would require overwriting, stashing, rebasing, resetting, or
  otherwise resolving concurrent local integration work;
- sibling path ownership collides;
- validation changes the plan.

## Completion Notes

- Shipped one compact strict lifecycle as the single reusable Northstar default.
- Retired baseline, light, lane-first, mixed, and full-strict posture variants as supported steady-state protocols.
- Established standard core spine + consequence-triggered modules (specs, batch cards, guardrails, research, additional authority files) doctrine.
- Removed and tightened two-spine wording across owned skill, setup, bundle, and template surfaces (`SKILL.md`, `assets/templates/README.md`, `assets/templates/docs.README.md.template`, `references/setup/workspace-container-example.md`, `template-bundle/README.md`, `template-bundle/contracts/README.md`, `bundle-docs/sections/09-standard-docs-spine.md`, `bundle-docs/sections/06-planning-and-contract-gates.md`, `bundle-docs/sections/07-delivery-framework-and-autonomy.md`). The repository-wide claim remains open: root `README.md` still publishes alternative postures.
- Implemented mandatory post-merge local integration reconciliation in contract 001 and orchestrator mode with full behavioral coverage in `scripts/tests/post-merge-reconciliation/` (35 assertions across 8 scenarios: happy path, unverified provider merge, fetch failure, dirty checkout with 100% untouched working tree/index preservation, wrong branch, divergent unpushed commit preservation, head mismatch, and coordinator stale-head dispatch rejection).
- Wired post-merge reconciliation behavioral test and posture label rejection into lifecycle checker (`scripts/lib/northstar-lifecycle-checker.rhai`).
- Preserved all card-131-owned paths (`scripts/check-northstar-command-skills.rhai`, `scripts/test-northstar-repo-contract.rhai`, `scripts/lib/northstar-repo-contract-data.rhai`, `scripts/check-northstar-model-routing.rhai`, `scripts/fixtures/readiness-map/**`, `README.md`) untouched.
- Synchronized installed Northstar skill (`~/.claude/skills/northstar`) to exact 100% parity (111 files).
- Exact before/after template inventory:
  - `template-bundle/specs/templates/strict-compliance-migration-template.md`: deleted (-63 lines, -8 sections).
  - `template-bundle/specs/templates/batch-card-template.md`: 113 lines / 13 sections -> 68 lines / 10 sections (-45 lines, -3 sections; stripped redundant continuation/budget fields and 8-item closeout checklist; encoded prune triggers).
  - `template-bundle/logs/templates/thread-handoff-template.md`: 71 lines / 8 non-standard sections -> 43 lines / 7 canonical sections (-28 lines, -1 section; aligned with canonical 7 sections, encoded prune triggers).
  - Net template reduction: -136 lines, 1 obsolete template deleted, boilerplate stripped while preserving ready-state rubric, review oracle, evidence, and stop protections.
- Validation:
  - `effigy qa:docs`: PASS
  - `effigy qa`: PASS
  - `scripts/tests/post-merge-reconciliation/self-test.sh`: PASS (35/35 assertions)
  - `effigy check:skill-install /Users/tom/.claude/skills/northstar`: PASS (111 files OK)
  - `git diff --check`: PASS (clean)
