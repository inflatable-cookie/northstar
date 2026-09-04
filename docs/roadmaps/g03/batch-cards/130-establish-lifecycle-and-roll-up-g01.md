# 130 - Establish Lifecycle and Roll Up g01

Status: complete
Owner: repo maintainers
Created: 2026-09-04
Master roadmap: `g03.001`
Governing refs: spec 038, contract 001
Auto-start next cards: yes — cards 131 and 132 as concurrent siblings

## Objective

Implement the lifecycle foundation in canonical Northstar authority and prove
the generation-closure contract by replacing expanded `g01` with one safe
roll-up.

## Approved dispatch manifest

- **Lane:** `g03.001/130`
- **State:** ready
- **Prerequisites:** planning commit opening `g03` is on `main`; no active work
  or unresolved commitment remains in `g01`
- **Completion:** lifecycle authority and structural proof are merged; `g01`
  exists only as a roll-up and all current references remain valid
- **Approved concurrent siblings:** none
- **Serial edges:** cards 131 and 132 require this card merged
- **Worker class:** economical general/day-to-day documentation implementation;
  not an auditor, planner, coordinator, or documentation-grind profile
- **Reviewer class:** independent semantic reviewer using a different
  provider/model identity from the worker
- **Escalation owner:** Chatterbox for meaning, retention, or deletion choices

Owned mutable paths:

- `docs/architecture/system-architecture.md`;
- `docs/contracts/001-working-rules.md` and its index;
- `docs/roadmaps/g01/**`;
- `docs/roadmaps/archive/g01.md`;
- direct current links whose only change is the `g01` destination;
- focused lifecycle structural checks and direct fixtures under `scripts/`;
- this card and its exceptional evidence only if the result cannot remain
  legible here.

Reserved shared closeout surfaces: `docs/README.md`, roadmap front doors, and
installed skill parity. Card 130 may update them only where required to keep a
changed `g01` link valid; card 131 owns their compaction.

## Required work

1. Promote spec 038's artifact classes, prune triggers, generation closure, and
   preservation oracle into durable architecture/contract authority.
2. Freeze every tracked `g01` deletion target and classify any unique current
   meaning before deletion.
3. Create one non-procedural `g01` roll-up with current authority destinations
   and selected material evidence.
4. Remove expanded `g01` milestones and cards from `HEAD`.
5. Add the smallest stable structural proof needed for the one-expanded-
   generation and archive non-authority rules.

## Acceptance evidence and review oracle

- [x] frozen inventory accounts for every removed `g01` file;
- [x] no current authority or unresolved commitment exists only in removed
      content;
- [x] the roll-up contains outcomes and provenance, not runnable old steps;
- [x] current links and deterministic structural checks pass;
- [x] `git diff --check`, `effigy qa:docs`, and `effigy qa` pass;
- [ ] independent review falsifies each preservation-oracle row against the
      exact PR head.

### Frozen g01 deletion manifest (18 files)

| File | Historical role | Shipped outcome | Current canonical destination |
| --- | --- | --- | --- |
| `docs/roadmaps/g01/001-enact-northstar-on-northstar.md` | Milestone 001 definition | Self-hosting docs spine, delivery layer doctrine, template bundle promotion, skill alignment | `docs/architecture/system-architecture.md`, `bundle-docs/sections/07-delivery-framework-and-autonomy.md`, `template-bundle/` |
| `docs/roadmaps/g01/002-adopt-automation-runtime-policy.md` | Milestone 002 definition | Automation runtime hierarchy (Effigy -> Rhai/Bun/TS -> Bash/Python exceptions), checker migration | `docs/contracts/001-working-rules.md`, `bundle-docs/sections/10-automation-runtime-policy.md`, `scripts/README.md` |
| `docs/roadmaps/g01/003-tighten-ready-state-and-closeout-mechanics.md` | Milestone 003 definition | Ready-state rubric and mechanical end-of-lane closeout sequence | `docs/contracts/001-working-rules.md`, `bundle-docs/sections/07-delivery-framework-and-autonomy.md`, `docs/logs/README.md` |
| `docs/roadmaps/g01/README.md` | g01 front door | Closed generation marker and handoff to g02 | `docs/roadmaps/archive/g01.md`, `docs/roadmaps/generation-index.md` |
| `docs/roadmaps/g01/batch-cards/README.md` | Batch cards front door | Batch cards strict execution pattern | `template-bundle/roadmaps/g01/batch-cards/README.md`, `bundle-docs/sections/03-roadmaps.md` |
| `docs/roadmaps/g01/batch-cards/001-establish-live-northstar-docs-spine.md` | Card 001 | Live docs spine establishment | `docs/architecture/system-architecture.md`, `docs/roadmaps/archive/g01.md` |
| `docs/roadmaps/g01/batch-cards/002-promote-specs-promotion-into-template-bundle.md` | Card 002 | Template bundle specs and promotion rule | `template-bundle/specs/README.md`, `docs/roadmaps/archive/g01.md` |
| `docs/roadmaps/g01/batch-cards/003-align-northstar-plan-with-promotion-rule.md` | Card 003 | Specs-first planning skill alignment | `skills/northstar/references/modes/shape-with-specs-and-promote.md`, `docs/roadmaps/archive/g01.md` |
| `docs/roadmaps/g01/batch-cards/004-align-recover-and-handoff-with-promotion-rule.md` | Card 004 | Recover/handoff preservation alignment | `skills/northstar/references/handoff-contract.md`, `docs/roadmaps/archive/g01.md` |
| `docs/roadmaps/g01/batch-cards/005-align-setup-with-delivery-layer.md` | Card 005 | Setup skill and guardrails template | `skills/northstar/references/setup/delivery-layer-adoption.md`, `docs/roadmaps/archive/g01.md` |
| `docs/roadmaps/g01/batch-cards/006-standardize-strict-docs-spine.md` | Card 006 | Standard strict docs spine doctrine | `bundle-docs/sections/09-standard-docs-spine.md`, `docs/roadmaps/archive/g01.md` |
| `docs/roadmaps/g01/batch-cards/007-align-setup-with-standard-docs-spine.md` | Card 007 | Setup templates aligned with strict spine | `skills/northstar/references/setup/delivery-layer-adoption.md`, `docs/roadmaps/archive/g01.md` |
| `docs/roadmaps/g01/batch-cards/008-tighten-repo-contract-and-log-autonomy-pilot.md` | Card 008 | Tightened repo checks and autonomy pilot | `docs/contracts/001-working-rules.md`, `docs/logs/2026-04/08-141500-autonomy-pilot-batch-1.4.md` |
| `docs/roadmaps/g01/batch-cards/009-capture-automation-runtime-policy.md` | Card 009 | Automation runtime doctrine and contract | `docs/contracts/001-working-rules.md`, `bundle-docs/sections/10-automation-runtime-policy.md` |
| `docs/roadmaps/g01/batch-cards/010-migrate-repo-checkers-to-typescript.md` | Card 010 | Checker migration from Bash to TS/Bun | `scripts/README.md`, `docs/roadmaps/archive/g01.md` |
| `docs/roadmaps/g01/batch-cards/011-define-ready-state-rubric.md` | Card 011 | Ready-state rubric for cards/chains | `docs/contracts/001-working-rules.md`, `template-bundle/specs/templates/batch-card-template.md` |
| `docs/roadmaps/g01/batch-cards/012-define-closeout-pattern.md` | Card 012 | Mechanical end-of-lane closeout sequence | `docs/contracts/001-working-rules.md`, `docs/logs/README.md` |
| `docs/roadmaps/g01/batch-cards/013-apply-ready-state-and-closeout-mechanics.md` | Card 013 | Defended readiness/closeout in repo checks | `docs/contracts/001-working-rules.md`, `scripts/lib/northstar-repo-contract-checker.rhai` |

### Six-row preservation oracle proof

| Row | Invariant | Adversarial counterexample | Expected response | Proof |
| --- | --- | --- | --- | --- |
| 1 | Current authority is unchanged or deliberately promoted | A deleted file held the only current rule | Destination authority verified before deletion | All g01 rules promoted to `system-architecture.md` and `001-working-rules.md`; `effigy qa:docs` green |
| 2 | Every open commitment remains reachable | Deferred work exists only in removed history | All commitments tracked to active destinations | Milestones g01.001-g01.003 fully completed; follow-on work rehomed in g02 |
| 3 | Material outcomes remain traceable | A lasting migration has no PR, commit, release, or evidence reference | Roll-up contains evidence and provenance references | `docs/roadmaps/archive/g01.md` cites all batch logs, milestone refs, and provenance |
| 4 | Historical procedure cannot be mistaken for current authority | An archive contains runnable steps or active status | Roll-up contains only non-procedural outcomes | `scripts/lib/northstar-lifecycle-checker.rhai` proves non-authority; fixture `archive-executable` passes |
| 5 | Current work is legible without archive reads | The next lane or dependency requires opening a roll-up | Next active cards legible in `g03` without reading archive | Current runway in `docs/roadmaps/g03/README.md` is self-contained |
| 6 | Deletion is exact and reviewable | A broad cleanup removes an unclassified file | Exact frozen manifest matches deletion diff | `git status` diff confirms exactly the 18 frozen g01 files deleted |

### Validation

- `effigy check:repo-contract` — PASS
- `effigy check:repo-contract-wiring` — PASS
- `effigy test:repo-contract` — PASS (15 fixture cases; 9 expected failures, 6 benign passes)
- `effigy check:posture-advisory` — PASS (0 warnings)
- `effigy qa:docs` — PASS
- `effigy qa` — PASS
- `git diff --check` — clean (no whitespace or format errors)

## Stop conditions

- a `g01` file contains unique current authority or unresolved meaning without
  a confirmed destination;
- deletion scope extends beyond the frozen inventory;
- a checker requires prose snapshots or an arbitrary line-count score;
- validation changes the plan.

## Next task

Independent exact-head review in this worker workspace by a reviewer with a
different provider/model identity, followed by coordinator merge gate.
