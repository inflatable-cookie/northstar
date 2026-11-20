---
name: milestone-qa
description: Run and qualify milestone QA against a pinned commit on main from an isolated checkout using repository-declared selectors, then hand a structured verdict to the planner. Use when a coherent batch on main merits full verification, or when qualifying a milestone pass, filing repair work from a QA failure, or handling an incomplete QA run.
---

# Milestone QA

Verify a coherent batch on the default branch against the repository's own
milestone QA scope, from an isolated checkout, and turn the result into a
clear planner decision.

This skill stays runner-neutral: it works with Effigy named runs (which handle
status, logs, and stop) or any repository-declared command runner. Project
selectors live in their own repository; scheduling and capacity leasing live
outside this skill.

## 1. Decide when a batch merits QA

Run milestone QA when a coherent batch has landed on `main` — a completed
feature, milestone, cross-cutting refactor, or release candidate — rather than
after every small commit. Skip docs-only batches or changes already covered by
fast per-PR checks unless the repository's QA contract says otherwise.

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
- Preserve logs and artefacts before removing the isolated checkout. Record
  any teardown or cleanup failure separately from the workload verdict.

## 4. Record the run

Hand the planner (or record in the project's planning surface) a compact run
record:

- **Revision and scope:** exact SHA, ref, and repository-declared milestone
  scope.
- **Selectors and toolchain:** exact selectors/commands executed and the
  relevant toolchain or runtime versions.
- **Workload verdict:** `pass`, `fail`, or `incomplete`, with failing
  selectors and minimal reproduction evidence.
- **Execution and cleanup faults:** runner crashes, lost sessions, setup
  errors, or teardown failures — kept distinct from product failures.
- **Logs and artefacts:** retained file paths or runner handles for full
  output.

## 5. Act on the outcome

- **Qualifying a pass:** A run qualifies the pinned SHA only when every
  declared selector for the scope ran to completion with no execution fault.
  A qualified pass advances the verified-good baseline to that SHA.
- **Turning reproducible failures into repair work:** Confirm the failure is a
  product or test regression at the pinned SHA (not an environment fault),
  then open focused repair work referencing the pinned SHA, failing selector,
  and log location. Re-run milestone QA on the repaired `main` SHA rather than
  treating a local fix as a milestone pass.
- **Handling incomplete runs:** Treat runner crashes, dropped sessions,
  timeouts, missing logs, or setup/cleanup faults as **incomplete** — never as
  a pass, and not automatically as a product defect. Fix or report the
  execution fault first, then re-run against the same pinned SHA (or a newer
  `main` SHA if further work has landed).
