---
name: milestone-qa
description: Run full QA on a pinned default-branch commit from an isolated checkout and hand the operator a structured result. Use when a batch of work merits milestone verification, or to file repair work from a failed or incomplete run.
---

# Milestone QA

Verify a coherent batch on the default branch (a completed feature,
milestone, cross-cutting refactor, or release candidate, not every small
commit) against the repository's own milestone QA scope, from an isolated
checkout, and turn the result into a clear decision. Follow the repository's
milestone policy on when a batch merits a run. Any repository-declared command
runner works; scheduling and host capacity live outside this skill.

## 1. Pin the revision and scope

- Fetch the default branch (or use the local one for a repository without a
  remote) and pin the exact commit SHA to test. Never QA a
  moving branch tip or a dirty working tree.
- Read the milestone QA scope and selectors from the repository itself (such
  as `effigy.toml`, `AGENTS.md`, or a repo QA contract). If the repository
  declares no milestone scope, stop and ask the operator to define
  it in the repository rather than inventing commands.

## 2. Execute in an isolated checkout

- Create a clean, isolated checkout at the pinned SHA (such as a detached
  `git worktree` or fresh clone) so local edits, untracked files, or
  concurrent work cannot contaminate the run.
- Run the declared selectors via the repository's runner (for example, an
  Effigy named run, which manages status, logs, and stop).
- Keep durable evidence outside the isolated checkout, so another session
  can recover it: saved logs and artefacts, or the runner's or CI's run ID.
  Then remove the checkout, whatever the result.

## 3. Record the run

Hand the operator (or record in the project's planning surface) a compact
summary. Keep execution faults separate from the test result throughout:

- **Revision and scope:** exact SHA, ref, and repository-declared milestone
  scope.
- **Selectors and coverage:** exact selectors or commands run, toolchain or
  runtime versions, and — for a named subset or fail-fast run — every
  declared selector that was skipped or not reached.
- **Test result:** `pass`, `fail`, or `incomplete`, with the runner's actual
  exit status and test counts.
- **Execution and cleanup faults:** runner crashes, dropped sessions,
  log-close errors, setup errors, or teardown failures.
- **Evidence:** where the logs, artefacts, or run ID live.

## 4. Act on the outcome

- **Qualifying a pass:** A pass qualifies only the declared scope at that
  pinned SHA, and only when every required selector finished with its
  evidence intact. An execution fault doesn't overwrite a recorded pass; it
  blocks qualification only if it leaves evidence or scope unproved.
- **Filing repair work:** Confirm the failure is a product or test regression
  at the pinned SHA (not an environment fault), then open focused repair work
  naming the pinned SHA, failing selector, and log location. Re-run milestone
  QA on the repaired default-branch SHA rather than treating a local fix as a
  milestone pass.
- **Handling incomplete runs:** Unknown or unfinished selectors leave the
  scope unqualified, and execution faults are not product defects. Fix or
  report the fault first, then re-run
  against the same pinned SHA (or a newer default-branch SHA if further work
  has landed).
