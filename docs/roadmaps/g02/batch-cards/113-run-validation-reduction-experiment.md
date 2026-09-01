# 113 - Run Validation Reduction Experiment

Status: ready
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
- [x] the milestone defines the retained structural boundary and seven-row
  review oracle;
- [x] no active worker owns Northstar's checker or these planning surfaces.

## Acceptance Criteria

- [ ] every old required path has a recorded classification;
- [ ] individual historical cards, milestones, logs, and closed specs are not
  live required paths;
- [ ] no required/forbidden prose assertion executes or remains as dead data;
- [ ] missing-front-door, broken-link, and mirror-drift fixtures fail;
- [ ] representative benign editorial fixtures pass;
- [ ] existing readiness-map and command-skill tests stay intact;
- [ ] docs explain the structural boundary without copying the fixture list;
- [ ] card, roadmap, log, front doors, and next-task state reconcile;
- [ ] `effigy qa:docs`, `effigy qa`, and `git diff --check` pass.

## Review Oracle

Use all seven rows from `g02.045`. The reviewer must falsify the changed checker
against at least the missing-front-door, broken-link, parity-drift,
token-like-prose, editorial-rewording, and historical-path cases. A green run on
the unchanged repository is insufficient.

## Evidence Required

- before/after required-path classification and counts;
- search proof for removed prose assertion classes;
- focused fixture results with expected failures identified;
- unchanged-task proof for readiness and command-skill checks;
- `effigy qa:docs`, `effigy qa`, and `git diff --check` results;
- closeout log, reviewable PR, and exact tested head.

## Stop Conditions

- a retained invariant needs a new schema or unsettled policy;
- the implementation weakens link, parity, readiness, command-skill, or install
  validation;
- a fixture needs a consumer checkout or provider-specific state;
- the worker discovers overlap with another Northstar checker lane;
- validation changes the plan.

## Next Task

Open a reviewable PR and stop for orchestrator exact-head review. Do not merge
or begin spec 034 implementation.
