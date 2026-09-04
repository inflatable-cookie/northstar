# 131 - Compact g02 and Currentness

Status: ready to resume same worker after Chatterbox scope ruling
Owner: repo maintainers
Created: 2026-09-04
Master roadmap: `g03.001`
Governing refs: spec 038, contract 001
Auto-start next card: no

## Objective

Replace expanded closed `g02` history with one operational roll-up, prune its
routine transport/evidence debris, and make Northstar's front doors describe
only current `g03` authority and work.

## Approved dispatch manifest

- **Lane:** `g03.001/131`
- **State:** ready; resume the existing paused worker at its clean pre-mutation
  head after the promoted scope ruling
- **Prerequisites:** card 130 merged and lifecycle checks green
- **Completion:** `g02` is rolled up, classified old artifacts are pruned, and
  every current front door is `g03`-only
- **Approved concurrent siblings:** card 132 after the shared prerequisite
- **Serial edges:** card 130 before dispatch
- **Worker class:** economical general/day-to-day documentation implementation;
  not an auditor, planner, coordinator, or documentation-grind profile
- **Reviewer class:** independent semantic reviewer using a different
  provider/model identity from the worker
- **Escalation owner:** Chatterbox for any uncertain retention or currentness
  choice

Owned mutable paths:

- `docs/roadmaps/g02/**` and `docs/roadmaps/archive/g02.md`;
- `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`, and
  `docs/README.md`;
- `docs/specs/**` except active spec 038, using spec 038's explicit retention
  destination table;
- `docs/logs/**` and `docs/handoffs/**` only from a frozen, classified deletion
  manifest tied to closed `g01`/`g02` work;
- these exact checker callers that currently require deleted `g02` or pre-`g03`
  planning paths:
  - `scripts/lib/northstar-repo-contract-data.rhai`;
  - `scripts/check-northstar-model-routing.rhai`;
  - `scripts/check-northstar-command-skills.rhai`;
  - `scripts/test-northstar-repo-contract.rhai`;
  - `scripts/fixtures/readiness-map/**`;
- direct Northstar-only links broken by those exact removals;
- this card's compact closeout.

Card 132 owns `bundle-docs/**`, `template-bundle/**`, `skills/northstar/**`, and
reusable posture/lifecycle checks. The five exact checker/fixture surfaces above
are reserved to card 131 and excluded from card 132. Neither sibling may edit
the other's paths.

## Required work

1. Treat the `g02/README.md` closure record and g03 watchlist as authoritative
   dispositions for old active/deferred labels.
2. Freeze and classify the complete `g02`, promoted-spec, routine-log, and
   consumed-handoff deletion inventory.
3. Preserve lasting capability outcomes, current authority destinations,
   selected material evidence, and rehomed commitments in one `g02` roll-up.
4. Remove expanded `g02` and classified transient/routine artifacts.
5. Rewrite current front doors as bounded `g03` navigation, not history.
6. Modernize only the named checker callers so they test current durable
   authority and behavior without requiring historical files:
   - repo-contract authority/currentness data points to the compact live spine;
   - model-routing and command-skill assertions load current contracts,
     architecture, and installed mode surfaces rather than superseded specs;
   - repo-contract and readiness fixtures use current or fixture-local canonical
     references, never live `g02` paths;
   - preserve the checks' behavioral coverage and intended negative cases.

## Acceptance evidence and review oracle

- [ ] every removed file is present in the frozen classified inventory;
- [ ] the card-126 observation is reachable from the `g03` watchlist and does
      not keep `g02` executable;
- [ ] no current or unresolved meaning exists only in removed files;
- [ ] every removed pre-`g03` spec has the destination named by spec 038 and
      current-link/parity proof;
- [ ] exact search proves no named checker or readiness fixture requires a
      removed `g02` or pre-`g03` planning path;
- [ ] `effigy check:repo-contract`, `effigy check:command-skills`,
      `effigy check:model-routing`, and `effigy test:readiness-map` retain their
      positive and negative coverage against current or fixture-local authority;
- [ ] material `g02` outcomes remain traceable through selected evidence;
- [ ] a fresh reader answers authority/current/next without opening an archive;
- [ ] `git diff --check`, `effigy qa:docs`, and `effigy qa` pass;
- [ ] independent exact-head review applies the full preservation oracle.

## Stop conditions

- an old artifact cannot be classified confidently;
- a current caller still depends on executable-looking historical prose;
- checker modernization would change behavior beyond replacing the removed
  historical dependency or weaken an intended negative case;
- sibling path ownership collides;
- validation changes the plan.
