# <Project name>

<One paragraph: what this project is, who it serves, and what it must never
become.>

## Where things live

- Current state: `docs/README.md`
- Knowledge index: `docs/knowledge/README.md`
- Retired concepts: `docs/knowledge/retired.toml`
- Open questions: `docs/knowledge/questions.md`

## Commands

- `<command>` — <what it does>

## Product rules

- <Rules about the product itself that every change must respect.>

## Guardrails

- <Things an agent must not do without asking: releases, migrations,
  credentials, shared infrastructure.>
- When a change alters what is true, update the owning knowledge file in the
  same change.
- Record operator rulings in the file that owns the affected knowledge.

## Validate

Before a change is ready, run the checks that cover what changed: tests or
checks for touched code and documentation checks when documentation changed.
List the project's selectors here. Run larger suite checks at the project's
milestones.
