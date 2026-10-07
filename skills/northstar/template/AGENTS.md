# <Project name>

<One paragraph: what this project is, who it serves, and what it must never
become.>

## Where things live

- Current state: `docs/README.md`
- Knowledge (one owner per fact): `docs/knowledge/README.md`
- Retired concepts, which must not come back: `docs/knowledge/retired.toml`
- Open questions: `docs/knowledge/questions.md`

The plan (lanes, their documents and their order), leads, briefs, papercuts,
tasks and status live in Queue, never in this repository. Read what's
next with `plan.get` (see the `northstar` skill).

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

## Papercuts and leads

File small, recurring friction in Queue with `papercut.add`, and unplanned
ideas or observations with `lead.add` (see the `northstar` skill). The
repository holds no papercut file or triage folder.

## Validate

Before a PR, run once, through Effigy, every check covering what you changed:
the tests and QA groups for it (`<narrow selector>`), a compile of what you
touched, `<docs check>` if docs changed, and any proof the brief names or the
change alters. Skip only the full `<qa command>` and repeat passes. Full `<qa command>` runs on `main` at release points
and after a major chunk of work.
