# Handoff Contract

Use this contract when a Northstar repo needs a fresh-thread brief or
continuation artifact. A handoff is a note for the next person or agent, not a
replacement for the live planning spine.

Do not create one merely because the current thread is nearing compaction. If
the same thread can continue after compaction, use normal closeout and continue
from the existing `Next Task`.

## Required Sections

Every handoff must include these sections in this order:

1. `## What This Thread Was Doing`
2. `## Why It Matters`
3. `## Current State`
4. `## Boundaries`
5. `## Important Context`
6. `## Suggested Next Move`
7. `## Completion Protocol`

A worker handoff uses the same seven sections. It adds its worker-mode and PR
instructions as subsections inside `## Completion Protocol`; it does not invent
a second handoff structure.

### Worker-mode activation

A worker handoff must declare all three frontmatter fields:

```yaml
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
```

These fields explicitly activate worker mode. The worktree preflight applies
only after a worker thread has received and read this orchestrator-dispatched
handoff. Normal-mode agents, planning/orchestrator threads, and agents that
merely happen to be in a worktree must not perform the worker preflight or
inspect worker-local path configuration.

### Consumer trailing sections

After `## Completion Protocol`, a consumer repo may require additional `##`
headings for its own docs policy. Those trailing sections:

- must not replace, reorder, or rename the seven core sections;
- must come after `## Completion Protocol`;
- are added only when the consumer's QA gate actually requires them.

The generic Northstar handoff template does not add consumer-specific headings by
default.

## Human writing rules

A good handoff should feel like a thoughtful teammate catching someone up:

- start with the story, not a command list;
- explain why the work matters in a sentence or two;
- use plain language and short paragraphs;
- use contractions and “you” when that makes the note warmer and clearer;
- be candid about uncertainty, unfinished work, and decisions still needed;
- use bullets for facts, paths, constraints, and checks;
- write the suggested next move as an inviting, concrete starting point;
- keep hard boundaries explicit without sounding theatrical or bureaucratic.

Avoid machine-like language such as “execute the following protocol”, “the agent
must now”, or “completion authority is granted”. Prefer “Start by checking…”,
“Please keep this within…”, and “If you hit this, pause and bring it back to…”.

## Content rules

- `What This Thread Was Doing` explains the actual arc in plain language, not
  just the task title.
- `Why It Matters` connects the immediate work to the larger product, roadmap,
  or planning goal.
- `Current State` captures:
  - what is true now;
  - what is finished versus still open;
  - the active spec lane and current batch card when present;
  - the canonical promoted refs the next thread should trust;
  - the remaining continuation envelope, if another ready card is in-bounds;
  - lane budget or pause signal when the run did not simply continue;
  - the key files or artifacts involved, using absolute paths for local files.
- `Boundaries` includes at least one explicit out-of-scope boundary and any hard
  constraints the next thread must respect.
- `Important Context` captures roadmap/log lineage, the relationship between
  the spec and canonical architecture/contracts, non-obvious decisions or user
  preferences, repo constraints from `AGENTS.md`, and open tensions.
- `Suggested Next Move` tells the next thread how to begin without pretending
  that unresolved choices are settled.
- `Completion Protocol` points back to the repo's batch card, roadmap,
  currentness, and log surfaces. It names the continuation envelope or pause
  signal, the next task, and unresolved risks. Worker handoffs also put the
  worker/PR flow here.

## Validity rules

A handoff is valid only when another thread genuinely needs to take over or the
user explicitly asked for a handoff artifact. Low context, compaction, or normal
thread-budget pressure alone is not enough.

The handoff must be useful without the originating transcript. It may point at
canonical files rather than copy their full contents, but it must explain what
the next thread should read and why.

## Placement and naming rule

Every handoff is written under the target repository's `docs/handoffs/`
directory. Create that directory if it does not exist. Do not put new handoffs in
`docs/logs/`; logs and handoffs are related but different artifacts.

Use this filename shape:

```text
YYYYMMDD-HHMMSS-<slug>.md
```

For example:

```text
docs/handoffs/20260816-143500-soundcheck-api-review.md
```

The timestamp is the local creation time. The slug is short, lowercase, and
kebab-case. If a same-timestamp collision occurs, add `-2`, `-3`, and so on after
the slug.

## Output rule

The handoff skill must write the concrete file with `write_file` and verify it
with `read_file` before reporting success. The final operator-facing response
must include the absolute path to the created file. A chat summary alone is not
a handoff.

## Northstar alignment

A Northstar handoff should preserve:

- vision context: what long-horizon outcome the work serves;
- roadmap context: which milestone or batch the work belongs to;
- spec context: which provisional planning lane is still active, if any;
- canonical context: which promoted architecture/contracts govern execution;
- log context: what evidence or decision chain the next thread should continue;
- thread context: what the current thread was really trying to figure out,
  protect, or improve.

Do not reduce the handoff to a generic todo list with no planning lineage or
continuity of thought. Do not use it as a substitute for proper closeout in the live planning spine.
