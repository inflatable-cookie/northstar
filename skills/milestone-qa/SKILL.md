---
name: milestone-qa
description: Run and qualify milestone QA against a pinned commit on the default branch from an isolated checkout using repository-declared selectors, then hand a structured result to the operator or planner. Use when a coherent batch merits full verification, or when qualifying a pass, filing repair work from a failure, or handling an incomplete run.
---

# Milestone QA

Verify a coherent batch on the default branch against the repository's own
milestone QA scope, from an isolated checkout, and turn the result into a
clear decision.

This skill is runner-neutral: it works with Effigy named runs (which handle
status, logs, and stop) or any repository-declared command runner. Project
selectors live in their own repository; scheduling and host capacity live
outside this skill.

## 1. Decide when a batch merits QA

Run milestone QA when a coherent batch has landed on the default branch — a
completed feature, milestone, cross-cutting refactor, or release candidate —
rather than after every small commit. Follow the repository's milestone policy
and declared coverage to decide whether a batch merits a run; don't apply a
blanket skip.

## 2. Pin the revision and scope

- Fetch the default branch and pin the exact commit SHA to test. Never QA a
  moving branch tip or a dirty working tree.
- Read the milestone QA scope and selectors from the repository itself (such
  as `effigy.toml`, `AGENTS.md`, or a repo QA contract). If the repository
  declares no milestone scope, stop and ask the operator or planner to define
  it in the repository rather than inventing commands.

## 3. Execute in an isolated checkout

- Create a clean, isolated checkout at the pinned SHA (such as a detached
  `git worktree` or fresh clone) so local edits, untracked files, or
  concurrent work cannot contaminate the run.
- Run the declared selectors via the repository's runner (for example, an
  Effigy named run when available, so status, logs, and stop stay managed).
- Capture a durable run handle and export any required evidence **before**
  removing the isolated checkout, so another session or planner can recover
  it. Record any teardown or cleanup fault separately from the test result.

## 4. Record the run

Hand the operator or planner (or record in the project's planning surface) a
compact summary:

- **Revision and scope:** exact SHA, ref, and repository-declared milestone
  scope.
- **Selectors and coverage:** exact selectors or commands run, toolchain or
  runtime versions, and — for a named subset or fail-fast run — every
  declared selector that was skipped or not reached.
- **Test result:** `pass`, `fail`, or `incomplete`, keeping the runner's
  actual exit status and test counts even if a later infrastructure or
  teardown fault happens.
- **Execution and cleanup faults:** runner crashes, dropped sessions,
  log-close errors, setup errors, or teardown failures — kept separate from
  the test result.
- **Logs and durable handle:** retained artefact paths and durable runner
  handle for full output.

## 5. Act on the outcome

- **Qualifying a pass:** Advancing the verified-good baseline applies only to
  the declared scope at that pinned SHA. Full milestone qualification requires
  every required selector for the scope at one SHA to finish with its
  required evidence intact. An infrastructure, log, or teardown fault does not
  overwrite a recorded test pass; it blocks qualification only if it leaves
  required evidence or scope unproved.
- **Filing repair work:** Confirm the failure is a product or test regression
  at the pinned SHA (not an environment fault), then open focused repair work
  naming the pinned SHA, failing selector, and log location. Re-run milestone
  QA on the repaired default-branch SHA rather than treating a local fix as a
  milestone pass.
- **Handling incomplete runs:** Unknown or unfinished selectors leave the
  scope unqualified — never treat an incomplete run as a qualified pass, and
  don't file runner crashes, dropped sessions, timeouts, or setup faults as
  product defects. Fix or report the execution fault first, then re-run
  against the same pinned SHA (or a newer default-branch SHA if further work
  has landed).
