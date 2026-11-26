# Vision

Northstar is Tom's stack: a small suite of agent skills that glue his workflow
together, so agents behave the way he wants without hassle. Anyone can opt in
to any piece.

## Why it exists

The operator's workflow comes first. Northstar exists to simplify day-to-day
work by encoding a system that works for the operator, not to record his
habits for their own sake.

Publishing is a filter. If nobody else wants a piece, that questions its
value, and possibly the workflow behind it. Designing for public use keeps the
architecture clean even before anyone adopts it.

## Who it serves

The operator first, then solo developers on any harness who find the
repository and want to adopt pieces of it.

## What belongs

A skill belongs when it fits the operator's overall workflow, he built it,
and it provides real, significant value. Starting small is fine.

Skills here are experiments. Anything the operator explains to agents
regularly qualifies for at least a spike; a skill that stops earning its place
is removed.

## The stack

Pick the skills that fit your workflow from the [skill list](../../README.md#the-skills).

### Harness snippet

Writing style, work rhythm and repo hygiene are not skills: agents need them
in context from the start, not when a skill triggers. The stack ships them as an opt-in
snippet in [`harness/snippet.md`](../../harness/snippet.md) for a harness's
global instructions file (`CLAUDE.md`, `AGENTS.md`).

## Rulings

Operator rulings, 2026-11-18:

- Northstar is the stack; the documentation structure is the opt-in
  `northstar-docs` skill.
- Removed: language-quality packages (maintained language skills, such as
  BeautifulRust, fill that role), the UI module (maintained design skills,
  such as Impeccable, fill it), retired concepts (agents reimplementing old
  ideas is rare and didn't justify the ceremony) and `questions.md` (open questions belong in a
  planning system, where they don't go stale).
- Nucleus is a standalone task system, not part of Northstar.
- Third-party agent orchestration tools stay out.
- Effigy may fit as a general task runner, but no skill requires it. Skill
  scripts run directly on Python 3.8+ with no dependencies.
- The writing style is clear and conversational, not blunt; the snippet's
  wording wins over older short versions (2026-11-19).
- The writing style lives only in the harness snippet; no second copy in
  the repository's contracts.
- `docs/README.md` is the entry point to a project's docs, not a
  current-state page or a mirror of the code. Each project decides what it
  points at, and it stays as static as the other docs (2026-11-19).
- A skill is its `SKILL.md` and what it needs; no harness-specific metadata
  files such as `agents/openai.yaml`.
- Agent PRs, descriptions and comments are always written for a human reader;
  there is no machine-only format (2026-11-26).
- Repo hygiene splits in two: prevention rules live in the harness snippet,
  and cleanup is the `housekeeping` skill, which removes proven-safe litter
  without asking (2026-11-26).

## Non-goals

- A framework.
- A task system; that is Nucleus.
- A docs generator. `northstar-docs` is a structural template.
- Recording work merely to show that a step happened.
