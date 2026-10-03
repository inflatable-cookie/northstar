# Plan

The plan says what matters next and why. It lives in Queue, not in the
repository: a project's plan is its ordering of lanes, and each lane's intent
is in its lane document. It is intent, not status.

Queue calls run from the plugin root (`~/Dev/projects/paseo-northstar-queue`)
with the payload on stdin: `node bin/queue-cli.mjs METHOD - <<'JSON'`, the
JSON, then a closing `JSON` line (see `SKILL.md`). A shared payload file can be
overwritten between a read and a write such as `plan.get` and `plan.set`.

## Lanes

A lane is one thing the project is trying to achieve. It may span
repositories.

- Create or update it with `lane.upsert`: `key`, `title`, a short `aim`
  (outcome and why; prompts carry it, and it grants no authority), and the full
  `repositories` list (`{origin: "owner/name", path}`).
- Write its working document with `lane.document.edit`: `key`, the latest
  `version` you read (`0` for the first), `text` and `author`. A stale save is
  refused; reload with `lane.document.get` and reapply.
- The document stays high level: the outcome, why it matters, dependencies,
  open question IDs from `questions.md`, completion states and caveats, and
  what is deliberately out of scope. Tasks hold the detail. Keep it under
  128 KB, because briefs can carry it.
- Never write task status into it: no "in review", "merged" or PR numbers.
  Queue keeps what landed.
- When the outcome is true, or the lane is dropped, set `lane.status` to
  `done` or `abandoned` with a note. It leaves the plan by itself.

A standing lane that is never finished, such as keeping versions current, stays
open. Its rules live in a contract, not in the lane document.

## Order

The plan is the project's roadmap: each lane is one step. `plan.get`
(`repository` as an origin or path, or `project`) reads it, including a `done`
list of closed lanes. `plan.set` saves it: the latest `version`,
`entries: [{lane, note?, horizon?, doneWhen?}]` in priority order, and
`author`.

- `horizon` is `now` (being worked), `next` (queued up behind it) or `later`.
  Keep `now` to a handful of lanes.
- `doneWhen` is one line saying when the step is finished, for example
  "consumer profiles read from docs/knowledge/contracts in every repository".
  Set it for every `now` and `next` lane, so anyone can tell whether the step
  is complete.
- Keep the plan current. When a lane closes, or work changes order, save the
  plan again. A lane that newly lists the project's repository joins the end by
  itself, so reorder after creating one.

## When Queue asks

The agent that last saved a plan owns it, and Queue sends it two kinds of
prompt. Answer each one; an unanswered prompt goes to the operator after a day.

- **A lane has drained:** it has no unfinished task, no open lead, and nothing
  changed for two hours. Close it if its `doneWhen` is met
  (`lane.status` `done`), brief more work toward it, or keep it with
  `lane.keep` (`key`, `reason`, `author`) when it legitimately waits: name the
  question, prerequisite or standing reason. A keep lasts until the lane next
  drains.
- **The board has drained:** the project has no unfinished task. Brief toward
  the top `now` step, move the first `next` step to `now`, or close a finished
  step. With no `now` or `next` step, save a plan that says what to aim at.

A step that waits on the operator's answer can't be briefed, and keeping it
only postpones the prompt. Record the question as a decision (see `SKILL.md`)
so the operator sees it.

## Leads

A lead is an unresolved observation, idea or question that isn't planned yet.
Leads are never authority.

- File with `lead.add`: `repositories` (a list of `{origin, path}`), `title`,
  optional `body`, `lanes` and `author`. Update with `lead.edit` (the current `version`); list with
  `lead.list` (by `repository`, `lane` or `state`, open by default).
- A deliberate deferral ("not now: spreadsheet marking, waiting on the Marking
  Hub design") is an open lead, so nobody re-proposes it without seeing why
  it waits.
- Resolve every lead:
  - write the brief into it and promote it with `lead.promote-task` (see
    [brief](brief.md));
  - `lead.promote` with kind `question` or `knowledge` records that it became a
    `questions.md` entry or a knowledge change, once that change is on `main`;
  - `lead.drop` with a reason.

Papercuts are similar records for small friction; see `SKILL.md`.

## Changing the plan

The planner changes lanes, documents and order with the operator. A worker never
edits the plan.
