# <Project name>

<One paragraph: what this project is, who it serves, and what it must never
become.>

## Where things live

- Current state: `docs/README.md`
- Knowledge (one owner per fact): `docs/knowledge/README.md`
- Retired concepts, which must not come back: `docs/knowledge/retired.toml`
- Open questions: `docs/knowledge/questions.md`
- What's next: `docs/plan.md`
- Unresolved leads: `docs/triage/`

Tasks, briefs and status live in Queue, never in this repository.

## Commands

- `<command>` — <what it does>

## Product rules

- <Rules about the product itself that every change must respect.>

## Guardrails

- <Things an agent must not do without asking: releases, migrations,
  credentials, shared infrastructure.>
- When a change alters what is true, update the owning knowledge file in the
  same PR.
- An operator ruling given in conversation goes into its owning file before
  the thread ends.

## Validate

`<validation command>` before opening a PR.
