# Translation Memo: Intentful Agent Instructions

Status: promoted
Owner: repo maintainers
Last updated: 2026-08-27
Source: [T3 Code `AGENTS.md`](https://github.com/pingdotgg/t3code/blob/main/AGENTS.md)
Promotion targets: `docs/contracts/003-agent-instruction-surface.md` and
`skills/northstar/references/modes/agent-instruction-review.md`

## The useful lesson

T3 Code's instruction file is effective because it is a guided tour of project
judgment, not because it follows a special Markdown shape. It gives the reader
enough context to make good decisions without pretending every future case can
be reduced to a command.

Its flow moves through distinct questions:

1. What is this product, and what mental model should I carry?
2. What makes it valuable, and which properties must survive my changes?
3. How do the maintainers think about simplicity, ambition, and trade-offs?
4. Which local terms must we use consistently?
5. What are the few dangerous mistakes, and how do they happen?
6. Which surfaces and reverse states make a change complete?
7. How do local development, test data, verification, and pull requests work?
8. How does the system fit together, and where do responsibilities live?
9. Which engineering instincts express local taste rather than universal law?

That order creates progressive orientation. The reader meets purpose and stakes
before machinery, then hazards before detailed workflow. Architecture appears
after the product and operating model have given it meaning.

## Tone and direction

The prose has an owner. It uses plain language, explains consequences, and
occasionally names a failure mode memorably. The strongest rules usually carry
their reason nearby, so an agent can generalise the intent instead of matching
keywords.

The file also mixes several kinds of direction without pretending they have
equal force:

- product invariants that a change must preserve;
- dangerous boundaries with concrete failure consequences;
- reliable defaults for normal work;
- maintainer taste that guides choices between valid implementations;
- explicit places where the developer may choose differently.

This is more useful than a wall of undifferentiated imperatives. It tells the
agent which rules protect the system, which encode a preferred trade-off, and
which are practical defaults.

## What Northstar should adopt

An instruction review should test whether the file gives an agent:

- a concise product or repository mental model;
- the human stakes behind the work;
- a small set of preservation invariants;
- enough causal explanation to transfer intent to an unfamiliar case;
- shared vocabulary where ordinary words have project-specific meanings;
- memorable sharp edges rather than an exhaustive safety catalogue;
- a completion lens across relevant clients, states, contracts, and modes;
- verified mechanics for common work;
- a compact architecture and responsibility map;
- local engineering taste, clearly separated from hard authority.

Not every repository needs a section for every item. The reviewer should recover
the intended reader journey from the project, then judge whether each section
earns its context cost and arrives where it is useful.

## What Northstar should not adopt

- Do not copy T3 Code's headings, anecdotes, product claims, or repository map.
- Do not turn one strong example into a mandatory schema.
- Do not reward warmth, causal language, or founder voice mechanically.
- Do not keep low-value history merely because explanatory context can be useful.
- Do not use line count as a proxy for quality. A slightly larger file can be
  better when each section improves common decisions.
- Do not move all rationale out of the root. Move background history and long
  explanation; retain the shortest reason that changes how an agent acts.

## Northstar audit consequence

The deterministic task can measure size and expose structure, placement leads,
and bridge health. It cannot assess whether prose is humane, whether a warning
is memorable, or whether the section sequence creates a coherent mental model.
Those judgments belong to the review skill.

The review should therefore start with a section-intent map before issuing
retain, move, rewrite, or remove dispositions. The final recommendation should
explain the resulting reader journey, name any lost or conflicting intent, and
use compactness only as one constraint among usefulness, safety, clarity, and
voice.

## Source note

The source was reviewed on 2026-08-27. This memo paraphrases its structural and
rhetorical lessons; it does not reproduce its prose.
