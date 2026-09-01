# 113 - Run Validation Reduction Experiment

Status: complete; implementation complete; awaiting exact-head review
Owner: repo maintainers
Created: 2026-09-01
Master roadmap: `g02.045`
Governing refs: `docs/roadmaps/g02/045-reduce-prose-coupled-validation.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`,
`docs/logs/2026-09/01-140857-close-live-dogfood-and-plan-reduction.md`
Auto-start next card: no

## Objective

Replace Northstar's prose- and historical-inventory-coupled repo-contract check
with a smaller structural checker proven by both adversarial and benign
fixtures.

## Scope

- classify the current required-path inventory before mutation;
- reduce it to stable structure, active authority entry points, executable
  validation surfaces, and parity surfaces;
- remove the `required_content` and `forbidden_content` assertion classes;
- preserve independently stable bridge, task, QA, and runtime-hook identifiers
  with targeted checks;
- add focused repo-contract fixtures covering every milestone oracle row;
- wire the focused fixture task into documentation QA;
- update checker documentation and closeout surfaces;
- preserve unrelated historical files and every non-checker QA surface.

Out of scope: language-package extraction, orchestration or autonomy changes,
Paseo behavior, consumer mutations, a new currentness schema, broad docs
cleanup, and mode consolidation.

## Ready-State Checks

- [x] the first-principles audit identifies the exact checker and coupling
  classes;
- [x] the operator accepted structural validation and prose-coupling reduction;
- [x] the live dogfood cohort is closed and promoted;
- [x] the milestone defines the retained structural boundary and nine-row
  review oracle;
- [x] no active worker owns Northstar's checker or these planning surfaces.

## Acceptance Criteria

- [x] every old required path has a recorded classification;
- [x] individual historical cards, milestones, logs, and closed specs are not
  live required paths;
- [x] no prose assertion data or execution path remains;
- [x] current active-authority paths and stable machine contracts remain
  structurally protected;
- [x] missing-front-door, broken-link, and mirror-drift fixtures fail;
- [x] missing active authority, Claude bridge, and docs-QA wiring fixtures fail;
  the wiring fixture executes the mutated Effigy board and proves the outer
  `qa` path catches the `qa:docs` bypass;
- [x] representative benign editorial fixtures pass;
- [x] existing readiness-map and command-skill tests stay intact;
- [x] docs explain the structural boundary without copying the fixture list;
- [x] card, roadmap, log, front doors, and next-task state reconcile;
- [x] `effigy qa:docs`, `effigy qa`, and `git diff --check` pass on the final
  closeout head.

## Review Oracle

Use all nine rows from `g02.045`. The reviewer must falsify the changed checker
against at least the missing-front-door, broken-link, parity-drift,
token-like-prose, editorial-rewording, and historical-path cases. A green run on
the unchanged repository is insufficient. The nine-row review oracle and the
11-case fixture count are separate evidence.

## Evidence Required

- before/after required-path classification and counts;
- search proof for removed prose assertion classes;
- focused fixture results with expected failures identified;
- unchanged-task proof for readiness and command-skill checks;
- `effigy qa:docs`, `effigy qa`, and `git diff --check` results;
- closeout log, reviewable PR, and exact tested head.

## Completion Notes

- Reconciled the required-path inventory from 167 to 104 paths. The 73 removed
  historical paths were 40 batch cards, 15 milestones, 5 logs, and 13 closed
  or retired specs; six current active-authority paths were added, including
  the four identified in exact-head review.
- Removed 320 exact-presence and 41 exact-absence assertions. The retained
  checker validates required structure, current authority, portable skill
  links, Markdown links, template parity, and 16 targeted machine contracts.
- Added active-authority, Claude-bridge, and docs-QA-wiring negative fixtures;
  the wiring fixture executes mutated `qa:docs` and outer `qa` selectors, while
  the five existing benign prose fixtures still pass. The focused test remains
  wired into `qa:docs` and is also guarded by the independent `validate` path.
- Final validation and PR metadata are recorded in the closeout log.

## Stop Conditions

- a retained invariant needs a new schema or unsettled policy;
- the implementation weakens link, parity, readiness, command-skill, or install
  validation;
- a fixture needs a consumer checkout or provider-specific state;
- the worker discovers overlap with another Northstar checker lane;
- validation changes the plan.

## Next Task

Push the corrected review head and stop for orchestrator exact-head review. Do
not merge or begin spec 034 implementation.
