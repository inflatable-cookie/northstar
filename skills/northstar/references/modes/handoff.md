# Handoff mode (explicit trigger only)

Use this mode when the user explicitly wants a continuation brief, a fresh
thread, a spin-off, or a handoff for another person or agent. Your job is to
write a useful note that lets the next thread join the work without making the
user reconstruct the story.

This is a writing-and-re-entry task, not a reason to stop ordinary work early.
Do not create a handoff merely because the thread is long, context is compacted,
or the next task is already clear in the live planning surfaces.

Do not use this mode as the successor runtime for
`handoff_mode: orchestrator-continuation`. That successor enters Orchestrator
mode. The source orchestrator reuses the generic seven-section template; it
does not add a public continuation mode or template.

## Tone: write like a thoughtful teammate

The next thread should feel welcomed, not processed. Write in plain, natural
language:

- explain what happened and why it matters before listing mechanics;
- use short paragraphs, direct sentences, and contractions where they sound
  natural;
- say “Start by checking…” or “The open question is…” rather than issuing a
  wall of formal commands;
- keep the voice calm, practical, and human;
- distinguish what is known, what is likely, and what still needs a decision;
- keep bullets for facts, paths, commands, and acceptance criteria, not for
  every sentence;
- write to a capable teammate, not to a parser or a compliance auditor.

Avoid machine-like phrases such as “execute the following protocol”, “the agent
must now”, or “completion authority is granted”. If a hard rule matters, say it
clearly in ordinary language: “Please do not widen this into a redesign; that
choice has not been made yet.”

## Contract and templates

- [`../handoff-contract.md`](../handoff-contract.md) — required sections,
  placement, naming, and tone rules
- [`../../assets/templates/northstar-handoff.md.template`](../../assets/templates/northstar-handoff.md.template)
  — the generic human-friendly handoff template
- `../../assets/templates/northstar-orchestrator-run.md.template` — the worker
  handoff extension, using the same seven core sections and adding worker/PR
  instructions inside `## Completion Protocol`

## Workflow

1. **Load the repo context.** Read `AGENTS.md`, `docs/README.md`, the active
   roadmap/generation surfaces, relevant specs and contracts, and the latest
   relevant log. Use `effigy tasks` and `effigy doctor` when the repo guidance
   requires the normal orientation pass.
2. **Check whether a handoff is genuinely needed.** It is appropriate when
   another thread or person really needs to take over, or the user explicitly
   asked for the artifact. If the same thread can continue, prefer normal
   closeout and the existing `Next Task`.
3. **Finish the honest stopping point first.** Update the current card,
   roadmap/currentness surfaces, and log when the work has reached a meaningful
   closeout. Do not hide an unfinished planning or validation problem inside a
   friendly note.
4. **Write the handoff file.** Always use the generic template or the worker
   extension, and always write the concrete file under the target repo's
   `docs/handoffs/` directory. Use this filename shape:

   ```text
   YYYYMMDD-HHMMSS-<slug>.md
   ```

   The actual filename begins with digits, for example
   `20260816-143500-soundcheck-api-review.md`. Use the current local time, keep
   the slug short and lowercase, and add a numeric suffix if the same timestamp and
   slug already exist. Create `docs/handoffs/` if it is missing.
5. **Verify the artifact.** Read the file back, check that the seven core
   headings are present and ordered, make sure local references are absolute,
   and confirm that the next move is understandable without the old transcript.
6. **Report the path.** In the final response, give the user the absolute path
   to the file. Add a short, human summary of why it exists and what the next
   thread should do. Do not paste the entire handoff unless the user asks.

## Worker handoffs

The orchestrator/worktree flow reuses this exact writing flow. It uses the
worker extension template, writes the file under `docs/handoffs/` of the owning
repo, and gives the operator the **absolute path** to that file after the
prepared `main` branch has been committed and pushed. Do not dispatch with only
a repository-relative path; that is how a worker starts in the wrong repo.

The worker extension keeps the same friendly core sections, then adds inside
`## Completion Protocol`:

- how to confirm the worktree and branch;
- the ready cards and allowed runway;
- how and when to report progress through the operator;
- when to stop and ask for planning help;
- final validation and PR creation requirements;
- the fact that the worker must not merge.

The worker should sound like a teammate doing a bounded piece of work, not like
a robot reading a shell script. The hard boundaries still need to be explicit.

## Do not

- create a handoff only for compaction, low context, or a bare `continue`;
- write the handoff only in chat or only under `docs/logs/`;
- substitute a handoff for a batch log, roadmap update, or honest closeout;
- use stale front doors as authority without calling out the drift;
- use relative paths for local files inside the handoff;
- invent decisions that the current thread did not settle;
- give the worker a second prompt when the worker handoff file is being used.

## Operator message

Lead with the human answer: why the handoff exists, where things stand, and
what the next person should do first. Then give the absolute file path. Mention
validation only when it failed or materially changes confidence.
