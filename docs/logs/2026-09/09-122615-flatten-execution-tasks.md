# Flatten Northstar Execution Tasks Closeout

Status: complete
Task: `g03.003`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/roadmaps/archive/g03.md`

## Outcome

Northstar now has one executable planning level: each `gNN.NNN` roadmap file
owns its implementation and closeout detail. The migration removed active
milestone and batch-card indirection while preserving evidence from cards
130–133, readiness and lifecycle checks, starter-template behavior, and the
distinction between Northstar tasks, queue records, and Effigy selectors.

PR [#42](https://github.com/inflatable-cookie/northstar/pull/42) was accepted
at exact head `184937dbb24e3c7eadbd3daa74cc56ff3ba90496` in [review comment
5600997364](https://github.com/inflatable-cookie/northstar/pull/42#issuecomment-5600997364)
and merged as `92f3720576f8bd28b767768011aff8f6507b760a`.

## Validation

The accepted merge-sync review recorded `effigy qa` with 123 checks and 0
failures, `effigy qa:docs`, `git diff --check`, and installed-skill parity for
112 files. The integration checkout was clean and matched `origin/main` at the
merge commit before this closeout batch.

## Deferred limits

- Prose-only milestone vocabulary in illustrative or secondary surfaces is
  deferred to a later doctrine sweep; no shipped structural or starter surface
  retains the removed hierarchy.
- Live consumer migrations were not authorized. The related triage note is
  planning input only and does not create execution authority.

## Next

Return to Chatterbox for the next planning checkpoint. No successor is approved.
