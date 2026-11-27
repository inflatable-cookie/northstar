---
name: level-up
description: Raise the quality of a codebase in repeatable multi-skill rounds by chaining hill-climb, housekeeping, red-pen, a dependency bump, prune-tests, zoom-out, and relevant installed language or domain quality skills. Use when the operator wants a full quality pass on a codebase, wants to level it up step by step, or wants to run the improvement skills together.
---

# Level up

Chain `hill-climb`, `housekeeping`, `red-pen`, a dependency bump,
`prune-tests`, `zoom-out`, and relevant installed third-party quality skills
into repeatable rounds. Each round raises the verified quality floor by one
level without wasting polish on litter, features, tests, or workarounds that
should be cut or simplified first.

`level-up` orchestrates the standalone skills rather than repeating their
rules. `hill-climb` is required for the baseline, target, and re-read loop —
stop if it is not installed. If `housekeeping`, `red-pen`, `prune-tests`, or
`zoom-out` is missing, name it and ask the operator whether to skip that phase or stop. Skip
a phase that doesn't apply to the scope, such as `prune-tests` where there
are no tests, and say so.

Work on one branch for the round, and commit each step's batch before the
next step starts, so every phase can be reviewed and reverted on its own.

## 1. Scope and discover skills

- Agree on the scope (repository, crate, package, or module) and the overall
  target score (or climb one level per round until the operator stops).
- Identify the languages and domains in scope from manifests, build files, and
  source files.
- Inspect the skills installed on the system (the harness's available skills
  list and skill directories such as `~/.agents/skills/` or project-local
  skill folders). Select third-party code or design quality skills that match
  the languages or domains in scope — ignore Northstar's own skills and
  unrelated skills.
- Check whether the scope already has strict static quality gates for its
  languages (compiler strictness, linter, formatter) matching any confirmed
  language skills or repo conventions.
- Run the `housekeeping` inventory on the scope, so its items that need a
  name can join the confirmation below.
- Confirm the scope, target, proposed third-party skills (or that none
  matched), any missing or loose gates, and the housekeeping picks with the
  operator in one message before the baseline.

## 2. Clear litter (`housekeeping`)

- Remove the proven-safe and selected items before the baseline, so stray
  files, backups and dead branches aren't scored or reviewed as part of the
  scope.

## 3. Baseline (`hill-climb`)

- Run `hill-climb` in assessment mode to define the parts and rubric and get
  the verified baseline floor and round target. If every part and integration
  already meet the target, report and stop.

## 4. Cut scope (`red-pen`)

- Run `red-pen` on the scope so overbuilt features and dead options are cut
  before refactoring or pruning tests.
- Pause for operator verdicts on its Simplify and Remove items before changing
  behaviour.
- If the cuts remove or gut the parts that set the floor, recompute the floor
  and round target from the surviving parts' baseline scores.

## 5. Fix correctness bugs first

- If the baseline surfaced verified correctness or safety bugs that still
  exist after step 4, or if the test suite is red, fix those in their own
  correctness batch before later steps change the code. Skip if the suite is
  green and no verified bugs remain.

## 6. Bump dependencies

- Work on the manifests and lockfiles the scope owns, and skip this step if
  it owns none. In a workspace, bump only the scope's dependencies and test
  every member a shared lockfile change touches.
- Audit with the ecosystem's advisory tooling, such as `cargo deny`,
  `npm audit` or `pip-audit`, for vulnerable, deprecated, unmaintained or
  yanked dependencies. Where the tool reports only vulnerabilities, check
  registry metadata for the rest.
- Upgrade each dependency, including dev dependencies, to its latest safe
  version: a non-prerelease at least two weeks old with no open advisory. A
  fix for an open vulnerability or yanked release may be newer; say so in
  the report. Keep a pin whose reason is recorded.
- In one message, ask the operator about advisories a bump can't fix (each
  with a recommended replacement or mitigation) and any bump that needs a
  migration outside the scope, raises the toolchain or runtime requirement,
  or raises the floor that a published package's callers must meet.
- Land compatible bumps as one batch, then each breaking bump (including a
  `0.x` minor) as its own, fixing what it breaks and removing workarounds it
  made unnecessary. Leave fixes for new lint rules to step 9. Run the suite
  after each batch and re-run the audit after the last.

## 7. Clean the suite (`prune-tests`)

- Run `prune-tests` on the surviving code so dead or implementation-coupled
  tests are removed before deeper quality edits.

## 8. Replace band-aids and workarounds (`zoom-out`)

- Run `zoom-out` in audit mode with fixes on the scope, so workarounds are
  fixed at the owning constraint before idiomatic polishing.
- Pause for operator approval on its Propose items.

## 9. Language and domain quality pass

- If the operator approved adding or tightening static quality gates in step
  1, wire them up first. They wait until now so lint churn isn't spent on code
  that steps 4–8 cut or restructure.
- Run each confirmed third-party quality skill from step 1 against the
  matching parts of the scope.
- Apply fixes in focused batches and run targeted checks after each batch.
  Skip this step if no static gate updates or third-party skills were selected.

## 10. Close the gap and re-rate (`hill-climb`)

- Re-check which verified findings from the baseline still apply after steps
  4–9, and fix what still holds any part or integration below the round
  target.
- If earlier steps removed, split or merged parts, update the part map first.
- Run a fresh, unanchored `hill-climb` re-read to verify the new floor.

## 11. Repeat or finish

- If the verified floor is below the operator's target (or they ask for
  another step up), start the next round using step 10's fresh re-read as its
  baseline — don't run a second baseline assessment.
  - On follow-up rounds, skip `housekeeping`, `red-pen`, the dependency
    bump, `prune-tests`, and `zoom-out` unless the higher target or recent
    changes warrant re-running them; ask if unsure.
  - Reuse the confirmed third-party skill list unless the scope changed.
- Stop when every part and integration meet the target, the operator stops, or
  a round does not raise the floor.
- Offer `hill-climb`'s standing gate once the final floor is verified.

## Report

Give the operator:

- the scorecard per round (each part, integration, and how the verified floor
  moved);
- litter removed (`housekeeping`), cuts and simplifications landed
  (`red-pen`), test counts and coverage delta (`prune-tests`), workarounds
  fixed, contained or deferred (`zoom-out`), static quality gates added or
  tightened, and which third-party skills ran and what they changed;
- dependencies bumped, pins kept with their reasons, and advisories resolved
  or still open;
- any remaining shortfalls and whether a standing gate was recorded.
