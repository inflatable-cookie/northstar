# 131 - Compact g02 and Currentness

Status: complete
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
- **State:** complete; no dispatch authority
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

- [x] every removed file is present in the frozen classified inventory;
- [x] the card-126 observation is reachable from the `g03` watchlist and does
      not keep `g02` executable;
- [x] no current or unresolved meaning exists only in removed files;
- [x] every removed pre-`g03` spec has the destination named by spec 038 and
      current-link/parity proof;
- [x] exact search proves no named checker or readiness fixture requires a
      removed `g02` or pre-`g03` planning path;
- [x] `effigy check:repo-contract`, `effigy check:command-skills`,
      `effigy check:model-routing`, and `effigy test:readiness-map` retain their
      positive and negative coverage against current or fixture-local authority;
- [x] material `g02` outcomes remain traceable through selected evidence;
- [x] a fresh reader answers authority/current/next without opening an archive;
- [x] `git diff --check`, `effigy qa:docs`, and `effigy qa` pass;
- [x] independent exact-head review applies the full preservation oracle.

### Frozen classified deletion manifest (359 files)

#### 1. Expanded `g02` roadmaps and batch cards (172 files)

- `docs/roadmaps/g02/README.md` (front door, closure record)
- `docs/roadmaps/g02/batch-cards/README.md`
- 54 milestone files: `docs/roadmaps/g02/001-run-consumer-repo-pilot-and-consolidate.md` through `054-finish-continuous-coordinator-delivery.md`
- 116 batch cards: `docs/roadmaps/g02/batch-cards/014-select-consumer-repo-pilot-target.md` through `129-finish-continuous-coordinator-delivery.md`
- **Disposition:** Replaced by `docs/roadmaps/archive/g02.md` non-procedural roll-up. Lasting capabilities captured in roll-up; card 078 deferred; card 126 observation rehomed to `docs/roadmaps/g03/README.md` bounded watchlist.

#### 2. Pre-`g03` promoted specs (37 files)

| Group | Files | Historical role | Current canonical destination |
| --- | --- | --- | --- |
| 001–007 | `docs/specs/archive/001-northstar-delivery-layer.md` through `007-currentness-curation-and-evidence-window.md` (7 files) | Early delivery layer, runtime policy, closeout, pilot, guardrails, currentness | `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, bundle doctrine, Git history |
| 008–025 | `docs/specs/008-spec-lifecycle-and-archive-mechanics.md` through `025-skill-distribution-and-consumer-papercut-proof.md` (18 files) | Spec lifecycle, continuation envelope, lane budget, consumer autonomy proofs, strict compliance, underlay recovery, nested authority, repo posture, protocol kernel, papercuts | `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `bundle-docs/protocol-kernel.md`, `PAPERCUTS.md`, Git history |
| 026, 035, 036 | `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`, `035-chatterbox-intake-channel.md`, `036-economical-orchestrator-coordination.md` (3 files) | Early orchestrator/worker, intake, economical coordination | Superseded by 037, `docs/contracts/001-working-rules.md`, and skills |
| 027 | `docs/specs/027-northstar-native-pre-execution-discovery.md` (1 file) | Pre-execution discovery & readiness maps | `docs/contracts/001-working-rules.md`, `skills/northstar/references/modes/pre-execution-discovery.md`, `scripts/lib/northstar-readiness-map.rhai` |
| 028 | `docs/specs/028-agent-instruction-surface-optimization.md` (1 file) | Agent instruction surface | `docs/contracts/003-agent-instruction-surface.md`, `skills/northstar/references/modes/agent-instruction-review.md` |
| 029 | `docs/specs/029-northstar-long-horizon-planning.md` (1 file) | Long-horizon planning (Atlas) | `skills/northstar/references/modes/atlas.md`, `skills/northstar/commands/northstar-atlas/SKILL.md`; feedback on g03 watchlist |
| 030 | `docs/specs/030-conversational-triage-and-docs-cleanup.md` (1 file) | Triage and docs cleanup | `docs/contracts/001-working-rules.md`, `skills/northstar/references/modes/cleanup-docs.md`; feedback on g03 watchlist |
| 031–034 | `docs/specs/031-rust-quality-authoring-and-audit.md` through `034-modular-language-quality-packages.md` (4 files) | Rust and TypeScript quality packages, v2 tooling, modular packages | `docs/architecture/system-architecture.md`, `docs/contracts/004-language-quality-pack.md`, official registry, installed packages |
| 037 | `docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md` (1 file) | Chatterbox planning, coordinator, review modes | `docs/contracts/001-working-rules.md`, `docs/architecture/system-architecture.md`, skills modes |

#### 3. Consumed worker handoffs (34 files)

All 34 completed handoffs from closed `g01`/`g02` work removed (`docs/handoffs/20260816-*` through `20260904-123000-*`). At the implementation head, active handoffs retained: `docs/handoffs/20260904-123500-compact-g02-and-currentness.md` (card 131) and `docs/handoffs/20260904-123501-make-compact-lifecycle-default.md` (card 132), plus `docs/handoffs/README.md`.

#### 4. Routine closed batch logs (116 files)

116 routine step/checkpoint/halt logs removed from closed `g01` and `g02` work across `docs/logs/2026-04/`, `2026-05/`, `2026-08/`, and `2026-09/`. 51 exceptional evidence logs documenting pilots, migrations, releases, canary results, and foundational capabilities are retained and cited in `docs/roadmaps/archive/g01.md`, `docs/roadmaps/archive/g02.md`, and `docs/logs/README.md`.

### Six-row preservation oracle proof

| Row | Invariant | Adversarial counterexample | Expected response | Proof |
| --- | --- | --- | --- | --- |
| 1 | Current authority is unchanged or deliberately promoted | A deleted file held the only current rule | Destination authority verified before deletion | All pre-g03 spec rules and g02 operational policies exist in `system-architecture.md`, `001-working-rules.md`, `003-agent-instruction-surface.md`, `004-language-quality-pack.md`, and skills modes; `effigy qa:docs` green |
| 2 | Every open commitment remains reachable | Deferred work exists only in removed history | All commitments tracked to active destinations | Card 126 observation rehomed to `g03/README.md` bounded watchlist; card 078 deferred recorded in `archive/g02.md`; all other milestones/cards completed |
| 3 | Material outcomes remain traceable | A lasting migration has no PR, commit, release, or evidence reference | Roll-up contains evidence and provenance references | `docs/roadmaps/archive/g02.md` cites all retained milestone evidence logs, pilot proofs, canary closures, and Git history |
| 4 | Historical procedure cannot be mistaken for current authority | An archive contains runnable steps or active status | Roll-up contains only non-procedural outcomes | `archive/g02.md` has `Status: archived`, `Kind: roll-up`, no execution steps; `check_archive_non_authority` and `check_one_expanded_generation` pass |
| 5 | Current work is legible without archive reads | The next lane or dependency requires opening a roll-up | Next active cards legible in `g03` without reading archive | Current runway in `docs/roadmaps/g03/README.md` and `docs/README.md` is self-contained |
| 6 | Deletion is exact and reviewable | A broad cleanup removes an unclassified file | Exact frozen manifest matches deletion diff | `git status` diff confirms exactly the 360 classified files deleted |

### Checker callers modernized

- `scripts/lib/northstar-repo-contract-data.rhai`: `current_active_authority_files()` points to active spec 038; `required_files()` points to `docs/roadmaps/g03/README.md` instead of `g02/README.md`; removed closed spec 030.
- `scripts/check-northstar-model-routing.rhai`: Re-anchored assertions from removed specs 026 and 037 to current contracts (`001-working-rules.md`), architecture, orchestrator mode, doctrine, and templates; all 12 oracle rows pass.
- `scripts/check-northstar-command-skills.rhai`: Re-anchored superseded review-workspace creation assertion from removed spec 036 to `001-working-rules.md`; passes.
- `scripts/test-northstar-repo-contract.rhai`: Authority fixture uses active spec 038; added negative assertions for `g02/README.md` and spec 034; all 15 fixture tests pass.
- `scripts/fixtures/readiness-map/**`: Re-anchored fixture frontmatter from removed spec 027 and `g02` roadmap to active spec 038 and `g03/001-compact-default-lifecycle.md`; all 5 fixture tests pass with expected frontier and negative cases.

### Canonical citation corrections after exact-head review

Reconciled remaining live citations to deleted pre-`g03` specs across live authority surfaces:
- `docs/contracts/001-working-rules.md`: retargeted validation spec reference to active spec 038;
- `docs/roadmaps/g03/README.md`: retargeted watchlist governing ref from spec 037 to spec 038 / contract 001;
- `docs/architecture/system-inventory.md`: retargeted elements and interfaces citing deleted specs 001, 026, 030, 031–033, and 037 to current durable destinations (`001-working-rules`, `004-language-quality-pack`, `system-architecture.md`, `archive/g01.md`, and mode references);
- `docs/contracts/004-language-quality-pack.md`: retargeted tree-identity definition reference from deleted spec 034 to this contract and system architecture.

### Validation

- `effigy check:repo-contract` — PASS
- `effigy check:repo-contract-wiring` — PASS
- `effigy test:repo-contract` — PASS (15 fixture cases)
- `effigy check:readiness-map` — PASS
- `effigy test:readiness-map` — PASS (5 fixture cases)
- `effigy check:command-skills` — PASS
- `effigy check:model-routing` — PASS (12 routing oracle rows)
- `effigy check:language-packages` — PASS
- `effigy qa:docs` — PASS
- `effigy qa` — PASS
- `git diff --check` — clean (no whitespace or format errors)

## Stop conditions

- an old artifact cannot be classified confidently;
- a current caller still depends on executable-looking historical prose;
- checker modernization would change behavior beyond replacing the removed
  historical dependency or weaken an intended negative case;
- sibling path ownership collides;
- validation changes the plan.

## Next task

Independent exact-head review in this worker workspace by a reviewer with a
different provider/model identity, followed by coordinator merge gate.

## Reconciled delivery

PR #37 accepted head `597b89d654ea5d83a42c5a9951a3f7218ffa1752` merged as
`4b2e3dd5339d44a5410dea33fb9e528a8046a0ce`. The initial inventory's 360/35
count was inaccurate: the reviewed diff contained 359 deletions, including 34
consumed handoffs. Original card-131 transport is now consumed and pruned.
Remaining spec-038 checker retirement belongs to card 132's final correction;
this completed card grants no new execution authority.
