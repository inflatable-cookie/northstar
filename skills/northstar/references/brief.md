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
  notifyOriginOnCloseout: true
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
- Queue numbers each task per repository (`repo#N`) and returns the number at
  submission. Quote it to the operator, and start the PR title with the bare
  number (`304: Title`). On GitHub, `#304` would link an unrelated PR.
- Make acceptance about behaviour, not text. A grep-based check can push a
  worker into rewording files it shouldn't touch: answered questions in
  `questions.md` keep their original wording.

## Submitting

With operator approval, submit from the Queue plugin root:

```sh
node bin/northstar-submit.mjs --brief --repo /absolute/repository /absolute/path/brief.md --dry-run
```

Drop `--dry-run` to submit. The file can live anywhere and is not committed.
Queue requires only `title`, `queue_approval` and optional `queue:` routing, and
a non-empty body; the sections above are Northstar's convention, not Queue's.
Queue records the pushed integration head as the planning commit. The submit
returns an operation ID: poll it with
`node bin/queue-cli.mjs operation-status payload.json`, where the payload is
`{"operationId": "..."}`, until it succeeds; the task ID is in
`result.taskId`. `notifyOriginOnCloseout: true`
tells the submitting planner thread when the task closes, and
`completionNotificationAgentIds: [<agent ids>]` notifies other threads. Use
`node bin/northstar-subscribe.mjs <task-id> subscribe` only to change that
after submission. `node bin/queue-cli.mjs --help` lists the other calls.
To change a brief before merge, use Queue's `amend_brief` control; don't
resubmit.

Brief mode requires the repository's Queue manifest to be v5, or absent.
