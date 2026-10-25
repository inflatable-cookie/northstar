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
  scope: general
  complexity: medium
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

How a reviewer will know it is done: behaviour, and the targeted checks that
prove it (named tests or selectors). Full QA isn't part of a task.

## Stop and report if

The conditions where the worker should stop rather than guess.
```

`queue.laneDocuments` pins the lane document's current version into the
worker's prompt; add it when the worker needs the lane's wider intent. Queue
needs only `title` and a non-empty body; the sections are Northstar's
convention.

## Writing a good brief

- Aim at the outcome. A capable worker picks the steps.
- Leave model choice to Queue. Every brief needs `complexity` (`very_low` to
  `very_high`): how capable a model the work needs, not its size. Use `medium`
  for ordinary work, `high` for subtle or cross-cutting changes, and
  `very_high` only when the strongest model is needed. Request a profile
  (`profileRequests`) only when the work needs it, with a reason the operator
  can judge. A request above the usage level, or for a by-request profile,
  opens a decision for the operator, and the role runs on automatic selection
  meanwhile; nothing waits for the answer. Only the operator answers those
  decisions; never answer or withdraw them for them.
- Keep it short. If it needs pages of context, that context belongs in
  `docs/knowledge/` or the lane document, and the brief links to it.
- Name what the worker must update in `docs/knowledge/` if the work changes
  what is true.
- One brief per independently reviewable PR, in one repository. Cross-repository
  work is several linked tasks (`queue.dependsOn`).
- Queue numbers each task per repository (`repo#N`). Quote it to the operator,
  and start the PR title with the bare number (`304: Title`). On GitHub, `#304`
  would link an unrelated PR.
- Every Rust project moves fully to Oxide, with no per-selector `:cargo`
  escapes (Tom, 2026-10-25, recorded in Oxide's
  `docs/knowledge/contracts/workflow.md`, "Switching an existing project").
  A brief in a repository still on plain Cargo also runs `oxide init` at its
  existing package or workspace, adopting that workspace rather than adding a
  root crate. This is standing approval, so don't ask the operator per
  repository (Tom, 2026-10-22, decisions 3b041cf4 and 89797220); the task
  still gets its normal checks and review.
  - Build, check, clippy, test, nextest and format routes call `oxide` with
    the same arguments, as do metadata, locate-project, fetch, update,
    install, package, publish, tree, fmt, deny and audit. Changing an entry
    point authorizes no actual publish, install, release or secret use.
  - Keep toolchain pins: `cargo +<toolchain>` becomes
    `RUSTUP_TOOLCHAIN=<toolchain> oxide` or a `rust-toolchain` file. Tests
    that find sibling binaries through `current_exe` use
    `env!("CARGO_BIN_EXE_<name>")` first, or read
    `$CARGO_TARGET_DIR/<profile>`, because oxide runs test executables from
    the slot and uplifts final binaries to `target/`.
  - A tool or driver that runs Cargo itself — a Tauri or packaging CLI, a
    Python or TypeScript script, anything choosing `--target-dir` or
    `CARGO_TARGET_DIR` — runs under `oxide exec --` with its command intact.
    Its final targets and its evidence keep their meaning; intermediates use
    the held slot. `oxide exec` replaces an inherited `CARGO_TARGET_DIR` with
    `<workspace>/target` before the tool starts, so a private final target is
    chosen by the command after `--`: `--target-dir` on the inner Cargo
    command, or that command's own child environment, as in
    `env CARGO_TARGET_DIR=<dir> <tool>`. A target set on `oxide exec`'s own
    environment never reaches the tool. A driver or fixture whose target is
    throwaway keeps it inside the temp root it removes. Change the route,
    never the product or fixture semantics it drives.
  - A proof whose subject is Cargo's own target layout, or that must build
    with no shared intermediate state, is a named proof exception: it still
    runs under `oxide exec`, sets its own build directory under
    `/Volumes/Builds/scratch/<project>/` or the proof's
    `OXIDE_TASK_SCRATCH_ROOT` (never `/var/folders`, `~` or a drive root),
    removes only that directory afterwards, and is listed by proof name with
    its preserved intent in the project's guidance.
  - Stays on Cargo: CI and release workflows, container and VM guest builds,
    product code that runs Cargo as part of its own behaviour, and test
    fixtures.
  - The only escape is explicit: `EFFIGY_OXIDE_ESCAPE=cargo`, or running
    Cargo by hand while Oxide is broken. Nothing falls back silently.
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

A papercut promotes directly: `papercut.promote-task` with `id`, `agent`,
`complexity` and an authorization `note` turns its text into the brief.

`notifyOriginOnCloseout: true` tells the submitting planner thread when the
task closes; `completionNotificationAgentIds` notifies other threads. To change
a brief after promotion and before merge, use Queue's `amend_brief` control;
don't create a second lead.
