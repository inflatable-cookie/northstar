# 035 - Chatterbox Intake Channel

Status: active
Owner: repo maintainers
Created: 2026-09-03
Updated: 2026-09-03
Depends on: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/specs/030-conversational-triage-and-docs-cleanup.md`
Governing architecture: `docs/architecture/system-architecture.md`
Governing contracts: `docs/contracts/001-working-rules.md`

## Problem

The orchestrator is the only long-lived human conversation in a Northstar
lane. Side issues, feature ideas, and exploratory planning get dumped into
that thread, which interrupts dispatch, review, and the current runway.

A planning delegate is too heavy for this: it reserves a topic, uses an
isolated packet and PR, and then needs a separate promotion batch. The Paseo
`paseo-advisor` skill is also the wrong shape: it is a one-shot second
opinion and must not write files. Spec 026 currently says "research
subagents or advisors" for read-only helpers; that wording collides with an
operator-facing role.

The operator needs several independent, human conversations that can sit
beside the orchestrator, identify problems, and leave durable intake without
taking over planning or implementation.

## Goal

Add a **chatterbox**: a secondary Northstar communication mode.

- The operator starts a fresh thread for one feature, issue, idea, or
  long-running planning chat.
- Several chatterboxes can run at once and must not interrupt the
  orchestrator's current work.
- The conversation is warm, curious, and easy to talk to. It chats with the
  operator to identify problems rather than filling in a workflow form.
- It collects notes in the thread. When one issue is coherent enough for
  another agent to pick up, it writes a normal timestamped `docs/triage/`
  note.
- In Paseo, it then gives the orchestrator a small idle-only intake ping.
  The file is always the durable signal.

Triage remains non-authority. The orchestrator still promotes, sequences,
dispatches, reviews, and merges.

## Roles and authority

| Role | Owns | Must not assume |
| --- | --- | --- |
| Operator | starts chatterbox threads, answers questions, may ask the orchestrator to spawn one | that a chatterbox can implement, promote, or dispatch |
| Chatterbox | one direct operator conversation, problem identification, unique triage-file capture, optional idle orchestrator ping | canonical planning, readiness, implementation, review, merge, worker dispatch, or a reserved topic |
| Orchestrator | the main runway, promotion of chatterbox notes, spawn on request, intake-ping handling | that a chatterbox ping is a new assignment or that private chatterbox chat is repository authority |

A chatterbox is not a planning delegate, worker, orchestrator continuation,
handoff, or `paseo-advisor`.

## Conversation

Chatterbox threads should feel more like a colleague than a planner. Ask
focused questions, follow the operator's curiosity, and keep the exchange
easy to redirect. Collect in the conversation. Do not write a triage note
every turn.

Stay on the thread's topic loosely enough to be useful: one chatterbox may
cover several related issues over a long session. Write one note per
distinct issue when that issue is ready. Keep chatting about the rest.

The "enough" bar for a note:

- the issue or idea is named;
- why it matters is clear;
- known vs unknown is separated;
- operator-confirmed vs tentative is obvious;
- a later agent can understand it without the chat log.

That is still a triage note, not a spec, card, or execution request.

## Start paths

Operator-started is the default. A fresh thread plus `/northstar-chatterbox`
or plain language ("you're a chatterbox on X") is enough. No handoff file.

The orchestrator may also spawn one on explicit request. No committed
handoff. The initial prompt names chatterbox mode and the topic. In Paseo:

- create a separate `local` workspace for the same project and checkout;
- reject `branch-off` worktree isolation and a different project path;
- label `Chatterbox=true` (capitalized; reject omitted or lowercased);
- set `notifyOnFinish` false so idle chatterbox turns do not spam the parent;
- select from the adequate operator-facing conversational pool under the
  diversified-routing rule; an operator-named profile wins;
- retain the returned identities; do not poll.

Without Paseo, tell the operator to start a thread on the same checkout and
invoke chatterbox mode. Manual start remains complete.

## Shared checkout and git

Chatterboxes share the orchestrator's checkout. They only add new unique
`docs/triage/YYYYMMDD-HHMMSS-<slug>.md` files, so they should not content-
conflict with each other or with orchestrator edits. Do not create a
worktree, branch, or PR for this role.

Git protocol:

- write only that new file; do not edit `docs/triage/README.md` or any other
  path;
- before staging, check `git diff --cached --name-only`; if the index contains
  pre-existing staged paths, fail closed: do not commit, leave the triage note
  on disk, and report to the operator;
- stage only that new file with `git add -- <exact-new-file>`; never `git add .`,
  never `git add -A`, amend, reset, stash, or force-push;
- commit with exact path: `git commit -m "docs(triage): <summary>" -- <exact-new-file>`;
- leave unrelated dirty files (staged or unstaged) untouched in the working tree
  and index;
- commit and push to the integration branch (`main` unless the repo says
  otherwise);
- if HEAD is not that branch, leave the file on disk and tell the operator;
  do not switch branches;
- on `index.lock` or commit/push failure, retry once; if it still fails,
  leave the file on disk and tell the operator.

Same-second slug collisions keep the existing `-2`, `-3` rule.

## Paseo ping (paused at planning)

Automated Paseo pings are paused at planning pending an atomic queue API.

Paseo has no notify-without-a-new-turn API. `send_agent_prompt` starts an
orchestrator turn, and inspecting `get_agent_status` before `send_agent_prompt`
is non-atomic; the target can begin running between the status check and prompt
dispatch. A two-call sequence therefore cannot guarantee never interrupting a
running orchestrator.

For v1 intake:
1. Chatterbox writes and commits the triage note to `docs/triage/` on the shared
   checkout.
2. Chatterbox reports the note path directly to the operator in chat.
3. Automated pings are omitted until Paseo provides an atomic/non-interrupting
   queue or the operator explicitly settles best-effort race behavior.
4. The orchestrator discovers and inspects triage notes at its next normal
   triage checkpoint. If an intake prompt is ever received, the orchestrator
   treats it as intake only: it records the path, does not promote from the
   ping, and does not change current work.

## Router and command

Add an internal `chatterbox` mode and a thin `/northstar-chatterbox`
adapter. Keep the public skill count at one.

Route here for `northstar chatterbox`, `/northstar-chatterbox`, or a thread
that is already a chatterbox. Explicit orchestrator, worker, planning-
delegate, continuation, or PR-review requests keep those routes. A
chatterbox asked to implement, promote, dispatch, review, or merge refuses
and points at the orchestrator.

If the command-skills aggregate description budget cannot admit a tenth
adapter, raise that budget by the minimum needed. Do not compress existing
command copy to make room.

## Model routing

Treat chatterbox spawn as an operator-facing conversational dispatch class:
build the adequate pool from current notes, prefer the cheapest adequate
tier that can actually talk and identify problems, then rotate. Do not use
a fast/low-cost mechanical profile. Do not store profile names in
Northstar.

## Non-goals

- no worktree, branch, or PR for chatterbox capture;
- no handoff file for start or spawn;
- no topic reservation that blocks the orchestrator;
- no canonical promotion, readiness, implementation, review, or merge;
- no nested orchestrator, worker, or planning-delegate from a chatterbox;
- no research-subagent fan-out in this first version;
- no Paseo product change, queue plugin, or notify-only API as a blocker;
- no rename of the separate `paseo-advisor` skill;
- no second public Northstar skill.

## Rejected alternatives

- **Advisor** as the role name. It collides with `paseo-advisor` and with
  spec 026's read-only research helpers. Keep **chatterbox**. During
  implementation, drop "or advisors" from the research-subagent wording.
- **Reuse planning-delegate.** Too much ceremony for intake.
- **Isolated worktree.** Unnecessary when the only writes are unique new
  triage files.
- **Always ping the orchestrator.** That interrupts the main lane.
- **Finish notifications on chatterbox agents.** Long-running idle turns
  would spam the parent.

## Acceptance criteria

- [ ] chatterbox is a distinct internal mode with a thin command adapter;
- [ ] operator start needs no handoff; orchestrator spawn uses a local
      workspace, `Chatterbox=true`, and `notifyOnFinish` false;
- [ ] durable output is only unique `docs/triage/` files on the shared
      checkout, committed with exact-file add;
- [ ] idle-only orchestrator ping; running orchestrators are not interrupted;
- [ ] orchestrator intake pings do not change the current task;
- [ ] chatterbox cannot implement, promote, dispatch, review, or merge;
- [ ] doctrine, contracts, inventory, router, and command checks name the
      role and keep it distinct from planning-delegate and `paseo-advisor`;
- [ ] research-subagent wording no longer uses "advisors";
- [ ] source/install parity and Northstar QA pass.

## Review oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Chatterbox is not another role. | Thread routes through orchestrator, worker, planning-delegate, handoff, or `paseo-advisor`. | Router/mode refuses and stays in chatterbox or asks the operator to start the right thread. | Router and adapter assertions. |
| Capture cannot widen authority. | Chatterbox edits a spec, card, or product file, or opens a PR. | Stop before the write. | Mode/contract negative path. |
| Shared checkout stays unique-file-only. | Chatterbox runs `git add .` or commits an unrelated dirty file. | Stop; leave unrelated files unstaged. | Git-protocol assertion. |
| No worktree is required. | Spawn uses `branch-off` isolation. | Reject the transport plan. | Paseo spawn assertion. |
| Long-running chatterboxes do not spam. | Spawn enables `notifyOnFinish`. | Reject launch configuration. | Label/notification assertion. |
| Pings do not interrupt live work. | Chatterbox `send_agent_prompt`s a running `Orchestrator=true` agent. | Skip the ping and tell the operator. | Idle-only ping assertion. |
| Intake is not a new assignment. | Orchestrator starts promotion or dispatch from the ping. | Record the path only; continue current work. | Orchestrator intake assertion. |
| Notes remain non-authority. | A chatterbox triage file is treated as a ready card. | Orchestrator still promotes through the normal spine. | Triage lifecycle assertion. |

## Validation

- `git diff --check`
- `effigy check:command-skills`
- `effigy check:repo-contract`
- `effigy qa:docs`
- `effigy qa`
- installed Northstar skill parity
- deterministic oracle rows in the command-skills checker

## Next Task

Compile `g02.050` and card 124 from this spec. Keep card 120 as the ready
implementation lane; chatterbox implementation stays serial behind that
card's skill/router/command ownership.
