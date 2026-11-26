---
name: prune-tests
description: Remove tests that guard no intended behaviour, and rewrite ones that test the implementation, without losing coverage of anything callers rely on. Use when the operator asks to prune, clean up or slim a test suite, or when tests break on every refactor.
---

# Prune tests

Keep a test only if it is anchored to intended behaviour: it changes only when
that behaviour changes, and fails only when it regresses. Everything else is
deleted or rewritten. Adapted from the `prune-tests` skill in
[caldoai/skills](https://github.com/caldoai/skills) (MIT), with guardrails.

## 1. Set up safely

- Start from a clean tree so every removal can be reverted on its own. If
  unrelated uncommitted work is present, ask rather than committing it. Run on
  a dedicated branch unless a calling workflow already provides one.
- Run the suite and record the result. Don't prune a red suite; failing tests
  are a separate job.
- Record coverage for the scope (line and branch) if the project can produce
  it. Without coverage, say so; the review in step 4 then carries more weight.

## 2. Find the intended behaviour

A test can only be judged against a stated source. In order:

1. specs, contracts and architecture docs;
2. the public API, CLI or UI surface, and its documentation;
3. linked issues, bug reports and changelog entries;
4. the operator.

If none of them settles what a test guards, keep it and list it as a question.
Never infer intent from the test itself.

Always keep:

- regression tests for a reported bug, even when they look narrow;
- security, safety and data-loss tests;
- tests that pin a contract other projects rely on.

## 3. Classify each test

- **Anchored:** fails only when intended behaviour regresses. Keep.
- **Guards the past:** asserts that retired code stays gone without a current
  guarantee that it must stay absent. Delete.
- **Guards nothing:** no change to the code can make it fail: it tests the
  framework or browser, asserts what a mock returns after mocking the unit
  under test, or checks what the type system already guarantees. Delete.
- **Guards the implementation:** breaks when the code changes even though
  behaviour didn't: asserts private state, internal call order or which helper
  ran, or derives its expected value with the same logic as the code. Rewrite
  it against observable behaviour if it covers something callers rely on;
  otherwise delete.
- **Duplicate:** guards the same behaviour and failure mode as another
  test. Keep the one at the most stable boundary that is fast and
  deterministic; on a tie, keep the clearer one. Delete the rest.

Flaky tests aren't a category: fix or report them, don't prune them for being
flaky.

## 4. Prune

- Work one category at a time, one commit each, so a reviewer can follow the
  reasoning and revert a batch.
- Delete test-only support code (helpers, fixtures, test hooks) after
  checking that no retained tests, runtime paths, or downstream callers use
  it. Report production code that pruning shows to be dead; don't delete it
  here.
- Check that each rewritten test fails when the behaviour it guards breaks,
  not just that it passes now.
- Run targeted checks after each batch. Run the full suite at the end, or
  earlier if the project requires it or a batch changes shared code.
- Compare final coverage with step 1. Every production line or branch that
  lost coverage needs a reason: its behaviour is guarded elsewhere, or the
  code is dead and reported. Restore or rewrite a test for anything else.
  Without coverage data, map each deleted or rewritten test's behaviour to a
  retained test before deleting it.

## Report

Give the operator counts per category (kept, deleted, rewritten), the
coverage before and after with the reason for each loss, support code
removed, production code found dead, and the tests kept as questions.
