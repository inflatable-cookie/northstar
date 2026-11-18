# Vision

Northstar helps project teams and agents work from current, well-organized
knowledge without reconstructing intent from conversation history.

## What it is

A small skill and a flexible repository structure for project knowledge. Each
fact has one owner, useful detail stays available, and retired concepts are
recorded so they are not mistaken for current truth.

## Outcomes

- Readers can find the current facts relevant to their work.
- Durable rules and operator rulings reach the files that own them.
- The starter works in another project without Northstar-specific examples.

## Direction

Northstar becomes an opt-in stack: a small suite of skills that fit the
operator's workflow and that others can adopt piece by piece (operator ruling,
2026-11-18).

- The documentation structure stays, slimmed to what agents still need.
- Atlas, the long-horizon direction skill, belongs in Northstar as its own
  skill (`skills/atlas/`). It is not part of Nucleus.
- Nucleus is a standalone project, not part of Northstar or the stack.
- Third-party agent orchestration tools stay out of Northstar and the stack.
- Effigy may fit as a general task runner, but no stack skill should
  require it. Skill scripts run directly on Python 3.8+ with no
  dependencies; Effigy catalogs are optional wrappers.
- Language-quality packages are retired. Maintained language skills, such as
  BeautifulRust for Rust, fill that role.

## Constraints

- Keep the skill focused on documentation structure and maintenance.
- Make it useful across operators, repositories and harnesses.
- Keep the starter human-readable and ready to copy.
- Keep automation small and tied to a clear knowledge-maintenance need.

## Non-goals

- Recording work merely to show that a step happened.
- Storing task status, handoffs or delivery logs in the knowledge base.
- Replacing human judgment with automation.
