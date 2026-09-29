---
name: northstar
description: Keep a project's knowledge current and its work well-aimed. Use for planning, writing a task brief, reviewing a PR, recording an operator ruling, retiring a concept, or orienting in a Northstar repository.
---

# Northstar

Northstar keeps a repository's knowledge current and its plan legible, so any
agent can pick up work without reconstructing intent from conversation.

The repository holds **knowledge and code**. The orchestrator (the Paseo Queue
plugin today, Nucleus later) holds **process and planning**: the plan (lanes,
their documents and their order), leads (including briefs), papercuts, tasks,
status, review, closeout and outcomes. Never write either into the repository.

## Repository shape

| Surface | Holds |
| --- | --- |
| `AGENTS.md` | Orientation: what this is, the doc map, guardrails, the validation command |
| `docs/README.md` | What is true now, in a page, with links by topic |
| `docs/knowledge/` | Current truth, one owner per fact: vision, architecture, contracts, domain |
| `docs/knowledge/retired.toml` | Concepts that no longer exist, and what replaced them |
| `docs/knowledge/questions.md` | Open questions, and where each answer now lives |
| `docs/knowledge/contracts/release.md` | How this project releases, step by step. Every project has one |

There is no `docs/plan.md`, `docs/triage/`, task card, roadmap, generation,
handoff file, lifecycle record, delivery log or `PAPERCUTS.md`. Git history and the orchestrator's outcome records
are the history.

## Orient

Read `AGENTS.md`, then `docs/README.md`, then only the knowledge files your task
touches. For what's next, read the project's Queue plan (`plan.get`) and the
lane documents it lists. Before planning against a concept, check `retired.toml`. Before asking
the operator something, check `questions.md` and the owning knowledge file.
Asking a settled question again costs more than looking it up.

## How work moves

1. **Plan.** Each outcome the project pursues is a Queue lane with a working
   document; the project's plan orders the lanes. Unplanned ideas and
   deferrals are leads. See [plan](references/plan.md).
2. **Brief.** Each task starts as a brief in a Queue lead: outcome, context
   links, constraints, acceptance, and when to stop. See
   [brief](references/brief.md).
3. **Dispatch.** With the operator's approval, approve the lead and promote it
   to a task. Queue runs the worker, review, merge and closeout, and keeps the outcome.
4. **Review.** An independent reviewer checks the exact head against the brief.
   See [review](references/review.md).
5. **Keep knowledge current.** When work changes what is true, the same PR
   updates the owning knowledge file. See [knowledge](references/knowledge.md).

## Rules that matter

- **One home per fact.** Link to the owner; don't restate it. A copy is a
  future contradiction.
- **Rulings land before you hand off.** An operator answer given in
  conversation goes into its owning knowledge file, or closes a question in
  `questions.md`, before the thread ends or hands over.
- **Retirements name what they retire.** Retiring a concept adds an entry to
  `retired.toml` that lists the terms, paths and config keys it covers, and the
  same change removes or fixes the live references.
- **No status mirrors.** Never write "done", "merged" or "in review" into the
  repository. Queue owns status.
- **Write for the next reader.** Keep only what someone will need later.
  Short, plain, and with the reasoning that makes a decision understandable.
- **Break things honestly.** When a change breaks callers or contracts, say so
  and update them together. No shims that hide a decision.
- **Don't hold work for machine load.** A test that fails only under load is a
  defect: file it and fix it, rather than waiting for a quiet machine (Tom,
  2026-09-28).

## Shell commands

Agent shells here are usually zsh on macOS. These mistakes keep recurring:

- Single-quote literal patterns. Backticks and `$(...)` inside double quotes
  run as commands: ``rg 'use `foo`' docs``, not ``rg "use `foo`" docs``.
- Keep lists of paths in arrays. zsh doesn't split a string variable, so a
  space-separated list arrives as one argument:
  `files=(a.md b.md); for f in "${files[@]}"; do …; done`.
- Don't name variables after zsh specials such as `status`, `path` or `home`.
  Assigning `status` fails, and a `path` loop variable breaks command lookup.
  Use names like `exit_code` and `rel_path`.
- Brace a variable before a colon: `git show "${rev}:tools/x.md"`. zsh reads
  `$rev:t…` as a modifier, and `"$rev:tools/x.md"` becomes `HEADools/x.md`.
- macOS has BSD `sed` and `grep`: no `\b`, `sed -i` needs `''`, and GNU address
  forms fail. Use `rg`, `awk` or a short script to extract text.

## Papercuts and leads

Small, recurring friction worth fixing later is a papercut, filed in Queue, not
in the repository. Queue calls run from the plugin root
(`~/Dev/projects/paseo-northstar-queue`) with the payload on stdin. Don't use a
shared payload file: another thread can overwrite it between two calls.

```sh
node bin/queue-cli.mjs papercut.add - <<'JSON'
{"repository": {"origin": "owner/name", "path": "/abs/checkout"},
 "title": "...", "happened": "...", "impact": "..."}
JSON
```

A papercut needs `repository`, `title`, `happened` and `impact`, plus optional
`area` and `fix`. (`papercut.list` takes `repository` as the origin string,
`"owner/name"`.) Record it and carry on with the task. The planner promotes a
papercut with `papercut.promote-task` (see [brief](references/brief.md)),
attaches it to a lane with `papercut.set-lanes`, or closes it as completed or
deprecated.

An observation, idea or question that is bigger than friction and not yet
planned is a lead: `lead.add` (see [plan](references/plan.md)). Never write
either into a file.

## Ask the operator when

- the plan doesn't settle what to do next;
- a choice is breaking, irreversible, security-sensitive, or changes product
  direction;
- validation fails in a way that changes the plan.

Otherwise act. Asking again for authority that is already settled is a cost.

When a turn ends needing the operator's ruling, record it as a Queue decision
as well as asking in chat, so it shows on the board and the answer comes back
to you:

```sh
node bin/queue-cli.mjs decision.add - <<'JSON'
{"question": "...", "askedBy": "<your agent ID>", "options": ["A", "B"],
 "recommendation": "A, because ...", "context": "...",
 "project": {"origin": "owner/name", "path": "/abs/checkout"}}
JSON
```

Link the tasks, leads or papercuts it concerns (`tasks`, `leads`,
`papercuts`: ID arrays). When the question is overtaken, `decision.withdraw`
it (`id`, `version`, `reason`, `withdrawnBy`). If it changes shape,
`decision.supersede` it rather than adding a second one. A ruling given in
chat is recorded with `decision.answer`, quoting the operator word for word
and naming them in the `note`. Either way, the ruling still lands in its
owning knowledge file or closes its `questions.md` entry: a decision is the
live ask, not the record.

## Roles

- **Planner** (a Chatterbox thread): owns the project's Queue plan, lane
  documents, leads, knowledge upkeep, briefs and dispatch approval
  requests. It commits its own small repository changes (questions, a ruling
  landing in a knowledge file, link fixes) straight to `main`: run the
  repository's docs checks, check the exit code, then push. Don't open a PR for
  a small knowledge edit before a dispatch. A
  branch and a self-merged PR are for larger or riskier changes: restructuring
  knowledge, a migration cut, or anything touching code, QA configuration or
  scripts. For those, "passes" means an exit code of 0 that was actually
  checked. When parallel workers saturate the machine, local QA can fail for
  unrelated reasons, so use a CI run on the branch as the gate (dispatch it if
  CI doesn't run on PRs). The operator doesn't review planner changes; anything
  that needs independent review goes through Queue as a brief.
- **Worker:** implements one brief in the worktree Queue gives it, runs the
  repository's validation, opens one PR, and reports through Queue.
- **Reviewer:** checks the exact head independently and reports findings.

Coordination (recovery, review routing, merge, closeout) is Queue's job, not a
thread's. A planner hands over to a fresh successor using
[handover](references/handover.md); there are no handoff files.

## Adopting or migrating a repository

Use [adopt](references/adopt.md) and the starter in
[template/](template/README.md). A repository on the older Northstar shape
migrates in one deliberate cut, and drops its Queue manifest.

## Optional modules

UI design delivery and language quality packages are separate modules. Load one
only when the repository has opted in.

- **UI:** the nested [northstar-ui](ui/SKILL.md) skill builds and reviews UI
  work against an approved design brief. Its routes are
  [build](references/ui/build.md) and [review](references/ui/review.md).
- **Language packages:** for an explicit Rust or TypeScript/Svelte quality
  audit, follow the
  [installed-package route](references/packages/installed-package-route.md). It
  runs the skill's `language:route` task. Never start an audit from
  ordinary coding.
- **Worktrees:** `paseo:worktree` prepares and links sibling checkouts for
  Paseo worktrees; projects call it from `paseo.json` setup and teardown.
