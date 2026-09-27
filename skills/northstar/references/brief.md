# Brief

A brief tells one worker what to achieve. It lives in Queue as the body of a
lead from its first version, so it is visible on the board before approval. It
is never a file in the repository or a loose file on disk.

## Template

```markdown
---
title: Farmyard mock drafts, review and resume
queue:
  lane: mock-exams
  laneDocuments: [mock-exams]
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

`queue.laneDocuments` pins the lane document's current version into the
worker's prompt; add it when the worker needs the lane's wider intent. Queue
needs only `title` and a non-empty body; the sections are Northstar's
convention.

## Writing a good brief

- Aim at the outcome. A capable worker picks the steps.
- Keep it short. If it needs pages of context, that context belongs in
  `docs/knowledge/` or the lane document, and the brief links to it.
- Name what the worker must update in `docs/knowledge/` if the work changes
  what is true.
- One brief per independently reviewable PR, in one repository. Cross-repository
  work is several linked tasks (`queue.dependsOn`).
- Queue numbers each task per repository (`repo#N`). Quote it to the operator,
  and start the PR title with the bare number (`304: Title`). On GitHub, `#304`
  would link an unrelated PR.
- Make acceptance about behaviour, not text. A grep-based check can push a
  worker into rewording files it shouldn't touch: answered questions in
  `questions.md` keep their original wording.

## Lead, approve, promote

From the Queue plugin root, with the payload on stdin
(`node bin/queue-cli.mjs METHOD - <<'JSON'`, the JSON, then a closing `JSON`
line; see `SKILL.md`):

1. **Write:** `lead.add` with `repositories` (a list of `{origin, path}`),
   `title`, the complete brief Markdown as `body`, `lanes` and `author` (your
   agent ID). Queue checks the brief as coming from the creation `author`, and
   a later edit can't change it: with a display name the check fails with
   "Agent not found", and the only fix is `lead.drop` and a new `lead.add`. A body with brief frontmatter makes it a brief-bearing lead:
   Queue checks each version at the pushed head. The result gives its `version`,
   `digest` and `check`. A lead that already holds the idea gets the brief
   through `lead.edit` instead.
2. **Revise:** `lead.edit` with `id`, the current `version`, the complete new
   `body` and `author`. Any edit clears approval. A version that fails its
   check can't be approved; `lead.get` shows versions, digests and checks.
3. **Approve:** only after the operator has authorized this brief.
   `lead.approve` takes the latest `id`, `version` and `digest`, `approver`
   (your agent ID), `relayed: true` and a `note` naming the authorization
   ("Tom approved in the planning thread on 2026-09-27"). The operator can
   also approve on the board. A brief that should wait simply stays an open
   lead.
4. **Promote:** `lead.promote-task` with `id`, `agent` and the authorization
   `note` (plus `repository` when the lead lists several) re-checks and returns
   the `taskId`. A refused promotion admits nothing and keeps the approval:
   repair the condition and promote again.

A papercut promotes directly: `papercut.promote-task` with `id`, `agent` and an
authorization `note` turns its text into the brief.

`notifyOriginOnCloseout: true` tells the submitting planner thread when the
task closes; `completionNotificationAgentIds` notifies other threads. To change
a brief after promotion and before merge, use Queue's `amend_brief` control;
don't create a second lead.
