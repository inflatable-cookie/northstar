# Apply Remaining Underlay Consumer Strict Passes

Date: 2026-04-10
Roadmap refs: g02.016
Spec refs: docs/specs/019-underlay-consumer-cohort-and-underlay-reference-strict-pass.md

## Summary

Applied full paused strict Northstar posture installs to the remaining
Underlay consumer cohort repos after the `underlay-reference` proof:
`contact-patch`, `songsprout`, `acowtancy`, `compli-me`, and
`loophole/composer`.

## Evidence

- `contact-patch/cp-docs/` now has product guardrails, working rules, specs, a
  paused planning gate, and nested Effigy docs checks that pass.
- `songsprout/trellis/` now has the same strict paused posture under a rolled
  `g02` generation.
- `acowtancy/ledger/` now has one honest `g02.011` planning gate instead of an
  overloaded queue of implied next owners.
- `compli-me/docs/` now has a strict paused planning gate and working rules.
- `loophole/composer/composer-docs/` now has a strict paused planning gate in
  `g02` without touching the dirty `composer-admin` worktree.

## Validation

- `git -C ~/Dev/projects/contact-patch diff --check`
- `effigy cp-docs/qa:docs --repo ~/Dev/projects/contact-patch`
- `effigy cp-docs/qa:northstar --repo ~/Dev/projects/contact-patch`
- `git -C ~/Dev/projects/compli-me diff --check`
- `effigy qa:northstar --repo ~/Dev/projects/compli-me/docs`
- `git -C ~/Dev/projects/songsprout diff --check`
- `effigy qa:docs --repo ~/Dev/projects/songsprout/trellis`
- `effigy qa:northstar --repo ~/Dev/projects/songsprout/trellis`
- `git -C ~/Dev/projects/acowtancy diff --check`
- `effigy qa:docs --repo ~/Dev/projects/acowtancy/ledger`
- `effigy qa:northstar --repo ~/Dev/projects/acowtancy/ledger`
- `git -C ~/Dev/projects/loophole/composer diff --check`
- `effigy qa:docs --repo ~/Dev/projects/loophole/composer/composer-docs`
- `effigy qa:northstar --repo ~/Dev/projects/loophole/composer/composer-docs`

## Residual Non-Docs Blockers

- `effigy qa:docs --repo ~/Dev/projects/compli-me/docs` still fails on a pre-existing missing `underlay` file in the repo's own rollout audit path.
- `effigy qa --repo ~/Dev/projects/loophole/composer/composer-docs` still fails on a pre-existing reorder-conflict rollout contract in app code.

## Next Task

Have each upgraded consumer thread re-anchor on its new strict planning gate before resuming app-specific work.
