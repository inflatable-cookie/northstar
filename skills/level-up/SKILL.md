---
name: level-up
description: Raise the quality of a repository or scope in repeatable rounds by chaining hill-climb, red-pen, prune-tests, zoom-out, and relevant installed language or domain quality skills. Use when the operator wants a full quality pass, wants to level up a codebase step by step, or wants to run the improvement skills together.
---

# Level up

Chain `hill-climb`, `red-pen`, `prune-tests`, `zoom-out`, and relevant
installed third-party quality skills into repeatable rounds. Each round raises
the verified quality floor by one level without wasting polish on features,
tests, or stacked band-aids that should be cut or simplified first.

`level-up` orchestrates the standalone skills rather than repeating their
rules. `hill-climb` is required for the baseline, target, and re-read loop;
if `red-pen`, `prune-tests`, or `zoom-out` is not installed, name the missing
skill and ask the operator whether to skip that phase or stop.

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
- Show the proposed third-party skills (or note that none matched) and confirm
  the list with the operator before running them.

## 2. Baseline (`hill-climb`)

- Run `hill-climb` in assessment mode to define the parts and rubric and get
  the verified baseline floor.
- Set the round target to one level above the verified floor (capped at the
  operator's target, or 10). If every part and integration already meet the
  target, report and stop.

## 3. Cut scope (`red-pen`)

- Run `red-pen` on the scope so overbuilt features and dead options are cut
  before refactoring or pruning tests.
- Pause for operator verdicts on Simplify and Remove recommendations before
  changing behaviour, and land approved cuts in their own commits.

## 4. Fix correctness bugs first

- If the baseline surfaced verified correctness or safety bugs that still
  exist after step 3, or if the test suite is red, fix those in their own
  correctness batch before pruning tests or refactoring. Skip if the suite is
  green and no verified bugs remain.

## 5. Clean the suite (`prune-tests`)

- Run `prune-tests` on the surviving code so dead or implementation-coupled
  tests are removed before deeper quality edits.

## 6. Replace stacked band-aids (`zoom-out`)

- Run `zoom-out` in audit / refactor mode on the scope to find accumulated
  symptom fixes and replace them with cleaner lower-level invariants before
  idiomatic polishing.
- Pause for operator approval on proposals that change shared models or public
  behaviour, and land approved replacements with their superseded workarounds
  deleted.

## 7. Language and domain quality pass

- Run each confirmed third-party quality skill from step 1 against the
  matching parts of the scope.
- Apply fixes in focused batches and run targeted checks after each batch.
  Skip this step if no third-party skills were selected.

## 8. Close the gap and re-rate (`hill-climb`)

- Re-check which verified findings from the baseline still apply after steps
  3–7, and fix what still holds any part or integration below the round
  target.
- Run a fresh, unanchored `hill-climb` re-read to verify the new floor.

## 9. Repeat or finish

- If the verified floor is below the operator's target (or they ask for
  another step up), start the next round using step 8's fresh re-read as its
  baseline — don't run a second baseline assessment — and set the new round
  target to one level above the new floor (capped at the operator's target,
  or 10).
  - On follow-up rounds, skip `red-pen`, `prune-tests`, and `zoom-out` unless
    the higher target or recent changes warrant re-running them; ask if
    unsure.
  - Reuse the confirmed third-party skill list unless the scope changed.
- Stop when every part and integration meet the target, the operator stops, or
  a round does not raise the floor.
- Offer `hill-climb`'s standing gate once the final floor is verified.

## Report

Give the operator:

- the scorecard per round (each part, integration, and how the verified floor
  moved);
- cuts and simplifications landed (`red-pen`), test counts and coverage delta
  (`prune-tests`), band-aid clusters replaced (`zoom-out`), and which
  third-party skills ran and what they changed;
- any remaining shortfalls and whether a standing gate was recorded.
