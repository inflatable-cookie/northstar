# Brief

A brief tells one worker what to achieve. It is a Queue draft from its first
version, visible on the board's Drafts column before approval. It is never a
file in the repository or a loose file on disk.

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

## Draft, approve, promote

From the Queue plugin root, with the payload on stdin
(`node bin/queue-cli.mjs METHOD - <<'JSON'`, the JSON, then a closing `JSON`
line; see `SKILL.md`):

1. **Create:** `draft.create` with `repoPath`, `baseBranch`, the complete
   Markdown `text`, `author` (your agent ID) and `originAgentId`. Queue checks
   each version at the pushed head and shows the result on the board.
2. **Revise:** `draft.edit` with `id`, the current `version`, the complete new
   `text` and `author`. Any edit clears approval.
3. **Approve:** only after the operator has authorized this brief.
   `draft.approve` takes the latest `id`, `version` and `digest` (from
   `draft.get`), `approver` (your agent ID), `relayed: true` and a `note`
   naming the authorization ("Tom approved in the planning thread on
   2026-09-27"). The operator can also approve on the board.
4. **Promote:** `draft.promote` with `id` returns an operation. Poll
   `operation-status` with `{"operationId": "..."}` until it settles; its
   `taskId` is the task. A refused promotion creates nothing: repair the
   condition and promote the same draft again.

A lead or papercut can skip steps 1–4: `lead.promote-task` or
`papercut.promote-task` with `id`, `agent` and an authorization `note` creates
the draft, approval and task in one action. With `shape: true` it stops at a
draft for editing.

`notifyOriginOnCloseout: true` tells the submitting planner thread when the
task closes; `completionNotificationAgentIds` notifies other threads. To change
a brief after promotion and before merge, use Queue's `amend_brief` control;
don't create a second draft.
