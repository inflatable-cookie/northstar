# Brief

A brief tells one worker what to achieve. Queue stores it and pins it by
digest. It is never committed to the repository.

## Template

```markdown
---
title: Farmyard mock drafts, review and resume
queue_approval: "Tom approved on 2026-09-26 in the planning thread."
queue:
  lane: mock-exams
  capability: general
---

## Outcome

What will be true when this is done, in one short paragraph.

## Context

Links to the owning knowledge files and question IDs. Link; don't restate.

## Constraints

What must not change, what is out of scope, and any operator rulings that
bound the work.

## Acceptance

How a reviewer will know it is done: behaviour, tests, and the validation
command.

## Stop and report if

The conditions where the worker should stop rather than guess.
```

## Writing a good brief

- Aim at the outcome. A capable worker picks the steps.
- Keep it short. If it needs pages of context, that context belongs in
  `docs/knowledge/`, and the brief links to it.
- Name what the worker must update in `docs/knowledge/` if the work changes
  what is true.
- One brief per independently reviewable PR.

## Submitting

With operator approval, submit from the Queue plugin root:

```sh
node bin/northstar-submit.mjs --brief /path/to/brief.md
```

The file can live anywhere and is not committed. Queue records the pushed
integration head as the planning commit. Use `--dry-run` first, then check the
operation until it reports a task. To change a brief before merge, use Queue's
`amend_brief` control; don't resubmit.

Brief mode requires the repository's Queue manifest to be v5, or absent.
