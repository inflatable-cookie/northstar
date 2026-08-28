# Translation Memo: Northstar Orchestrator Thread And Worker PR Loop

Status: promoted
Owner: repo maintainers
Last Updated: 2026-08-16
Related spec: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Promotion targets: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `skills/northstar/references/modes/orchestrator.md`

## Problem

Northstar already has a strong planning spine and bounded same-thread autonomy, but it
has no explicit operating mode for a long-lived conversational planning thread that
hands a prepared runway to a separate implementation thread in an isolated worktree.
It also has no durable contract for the worker-to-PR-to-orchestrator review loop.

The missing boundary causes three avoidable failures:

- the exploratory conversation is polluted with implementation output and test logs;
- the worker has to reconstruct intent from a giant prompt instead of canonical files;
- PR review and merge become an informal afterthought rather than the end of the lane.

## Internal evidence

The current Northstar surfaces already provide most of the required primitives:

- one installable skill with internal modes and a required router;
- architecture, contracts, specs, generation runways, strict batch cards, and logs;
- ready-state, continuation-envelope, lane-budget, pause-signal, and stop rules;
- explicit handoff placement under `docs/handoffs/` with a human-friendly,
  timestamped filename;
- Effigy-first orientation, graph-assisted code understanding, and deterministic QA;
- a source-repo skill parity checker and a clean consumer-proof posture.

The gap is orchestration shape, not a need for another planning system.

## External evidence reviewed

Sources were retrieved on 2026-08-16.

### OpenAI Codex

- [Subagents](https://developers.openai.com/codex/agent-configuration/subagents.md)
  describes context pollution/context rot, keeping the main agent focused on
  requirements and decisions, returning summaries, and being cautious with
  parallel write-heavy work.
- [AGENTS.md](https://developers.openai.com/codex/agent-configuration/agents-md.md)
  documents layered repository guidance, which supports putting worker rules in
  the repository rather than repeating them in every prompt.
- [Git worktrees](https://developers.openai.com/codex/environments/git-worktrees.md)
  documents isolated worktrees for parallel chats and the one-branch-per-worktree
  constraint.
- [Non-interactive mode](https://developers.openai.com/codex/non-interactive-mode.md)
  documents resumable runs, JSONL output, and structured output schemas for
  bounded automation.
- [Code review](https://developers.openai.com/codex/code-review.md) documents
  review-against-base, review-without-editing, separate review chats, and
  inline feedback loops.

### Claude Code

- [Common workflows](https://code.claude.com/docs/en/common-workflows.md)
  documents plan-before-editing, research subagents, PR creation, and isolated
  sessions in separate worktrees.
- [Agent teams](https://code.claude.com/docs/en/agent-teams.md) and
  [cross-session messaging](https://code.claude.com/docs/en/cross-session-messaging.md)
  show that native agent-to-agent communication now exists, but they also carry
  provider-specific availability, permission, and experimental-state concerns.
- [Worktrees](https://code.claude.com/docs/en/worktrees.md) and background
  session tooling support the proposed worker shape without requiring a shared
  worktree.

### OpenCode and GitHub

- OpenCode's [agents documentation](https://opencode.ai/docs/agents/) separates
  primary plan/build agents from read-only exploration and configurable
  subagents, with per-agent model, permission, and step controls.
- OpenCode's [GitHub integration](https://opencode.ai/docs/github/) demonstrates
  branch, implementation, PR, and review-comment flows.
- OpenCode's [skills documentation](https://opencode.ai/docs/skills/) confirms
  that repository-local `SKILL.md` assets are a portable integration boundary.
- GitHub's [pull-request review guidance](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/reviewing-proposed-changes-in-a-pull-request)
  supports file-by-file review, line comments, approval, and request-changes
  outcomes.

## Recommendation

Add an `orchestrator` mode inside the existing public `northstar` skill. The mode
should:

1. hold a question-led discovery conversation until decisions that affect scope,
   architecture, or prioritisation are explicit;
2. promote settled outcomes into architecture and contracts before execution;
3. compile a multi-card roadmap runway and mark only genuinely ready cards;
4. prepare a clean `main` boundary, commit and push the planning state, then
   create one self-contained worker handoff under `docs/handoffs/` whose
   absolute path is the operator-facing dispatch artifact (supersedes the
   earlier relative-only rule; see spec 026 and contract 001);
5. leave implementation to one fresh worker thread in one dedicated worktree;
6. receive operator-relayed progress and the final PR URL;
7. review the PR against the canonical plan, request changes or approve it, and
   close the roadmap/log surfaces after merge.

The operator remains the communication bridge between threads for now. Native
cross-session messaging, provider subagents, and hosted GitHub agents may reduce
manual relay later, but none is required for the protocol to work.

## Model-efficiency translation

Use capability profiles rather than hard-coded model IDs:

| Role | Required capability | Default effort |
| --- | --- | --- |
| Orchestrator | long-context conversation, ambiguity handling, architecture, review | frontier/high |
| Worker | reliable tool use, bounded implementation, tests, disciplined stop behavior | capable/medium; raise for risky cards |
| Reconnaissance | read-heavy search, summarisation, log reduction | fast/low-cost |
| Review | independent diff reasoning, contract comparison, failure analysis | frontier/high |

Keep deterministic work outside the model where possible: Effigy selectors,
repository reads, tests, diff inspection, and PR checks. Do not run parallel
write-heavy agents in one lane merely because a provider can spawn them.

## Rejected alternatives

- **A second public `northstar-orchestrator` skill:** rejected because the existing
  one-skill architecture is deliberate and a second front door would split routing
  and portability.
- **Live agent messaging as the primary boundary:** rejected because it couples
  Northstar to provider-specific session discovery, permissions, and delivery.
- **One worker thread per card:** rejected because it recreates context and
  handoff overhead; a ready runway should normally be one worker thread with
  bounded chunk reports.
- **One giant generated prompt:** rejected because canonical files are cheaper,
  inspectable, and less prone to context drift.
- **Automatic merge on PR creation:** rejected because review, checks, and merge
  are separate control points even when the same orchestrator owns them.

## Conditions for adoption

- The orchestrator mode must stop on unresolved planning gaps or intent branches.
- A worker must never infer new architecture from an underspecified card.
- Work must run in a dedicated worktree and branch; the orchestrator's planning
  checkout must not be used for implementation.
- The worker must finish with a reviewable PR, evidence, and explicit unresolved
  items, not only a chat summary.
- Before dispatch, planning state and the single worker handoff under
  `docs/handoffs/` must be committed and pushed on `main`; the operator
  receives that file's absolute path. The committed `HEAD` copy in the
  selected worktree is canonical. The handoff lists required sibling
  worktree links or `none`. This supersedes the relative-only dispatch
  rule; live authority is `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
  and `docs/contracts/001-working-rules.md`.
- The orchestrator must review the diff and checks against canonical refs before
  approving or requesting changes.
- The first dogfood run should measure elapsed time, worker rework, PR review
  cycles, validation success, and operator relay burden before broader automation.

## Promotion result

Durable system shape is promoted into `docs/architecture/system-architecture.md`.
Durable role, worktree, PR, stop, and merge-boundary rules are promoted into
`docs/contracts/001-working-rules.md`. The detailed realization path remains in
`docs/specs/026-orchestrator-thread-and-worker-pr-loop.md` and the executable
procedure is in `skills/northstar/references/modes/orchestrator.md`.

## Next task

Dogfood the mode on one bounded, low-risk lane using a fresh worker thread and an
isolated worktree; record where the worker-handoff path, reporting cadence, or
PR review gate still needs tightening.
