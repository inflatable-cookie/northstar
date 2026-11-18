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

The operator first. After a release, solo developers on any harness who find
the repository and want to try it.

## What belongs

A skill belongs when it fits the operator's overall workflow, he built it,
and it provides real, significant value. Starting small is fine.

Skills here are experiments. Anything the operator explains to agents
regularly qualifies for at least a spike; a skill that stops earning its place
is removed.

## The stack

| Skill | State |
| --- | --- |
| `hill-climb` | Shipped. Rate every part of a scope out of 10, plus integration; fix from the lowest level (the baseline, usually 6 or 7) up at least one level per run, more when an agent can reach it; then keep the rubric as a standing gate on every change. |
| `take-stock` | Shipped. Read-only audit of what a repository holds, what's stale, and what depends on it, ending in a report the operator decides from. |
| `fleet-sweep` | Shipped. One change across many repositories, with rules that keep it on track. |
| `prune-tests` | Shipped. Keep only tests anchored to intended behaviour, with guardrails: the source of intended behaviour, which duplicate survives, a commit before deleting and a coverage comparison after. |
| `atlas` | Rewrite. Long-horizon direction with the operator. It writes to `northstar-docs` files when the repository has opted in, otherwise to the project's planning surface, or asks the operator where to store the result. |
| `northstar-docs` | Renamed; rewrite pending. Opt-in. Static foundations: the "why" and depth behind a README, which is the pitch and getting-started guide. Rarely changed, easy to update, nothing that goes stale. |

Order: `fleet-sweep`, `hill-climb`, `take-stock` and `prune-tests` first
(done; the first sweep removed retired concepts across the consuming
repositories); then `northstar-docs`, then `atlas`, since the docs skill
defines the files Atlas writes to.

### Harness snippet

Writing style and work rhythm are not skills: agents need them in context
from the start, not when a skill triggers. The stack ships them as an opt-in
snippet for a harness's global instructions file (`CLAUDE.md`, `AGENTS.md`):
[`harness/snippet.md`](../../harness/snippet.md), which holds writing style
today. Work rhythm joins it once reassessed across Claude and Codex.

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
- A release waits until the operator is happy with the stack.
- The writing style lives only in the harness snippet; no second copy in
  the repository's contracts.
- A skill is its `SKILL.md` and what it needs; no harness-specific metadata
  files such as `agents/openai.yaml`.

## Non-goals

- A framework.
- A task system; that is Nucleus.
- A docs generator. `northstar-docs` is a structural template.
- Recording work merely to show that a step happened.
