# 003 - Agent Instruction Surface

**Type: TEMPLATE** -- Copy into `docs/contracts/003-agent-instruction-surface.md`
when a project wants to keep always-loaded agent instructions compact and useful.

Status: active
Owner: <owner>
Updated: YYYY-MM-DD
Depends on: `docs/contracts/001-working-rules.md`

## Purpose

`AGENTS.md` is always-loaded context. Keep it focused on durable facts and
boundaries that help on most turns. Move scoped rules, procedures, history, and
on-demand material to the surface that owns them.

## Root content classes

Keep these in the root file:

- repository identity and scope;
- non-negotiable safety, authority, compatibility, and stop boundaries;
- verified common orientation and validation commands;
- a minimal canonical-surface map;
- concise pointers to detailed contracts, guides, skills, and nested rules.

Keep these elsewhere unless they are genuinely needed every turn:

- task-specific instructions and current task lists;
- detailed procedures, optional command inventories, and troubleshooting;
- history, rationale, examples, and completed work;
- path-specific rules and personal or machine-local preferences;
- duplicated contract, style, papercut, handoff, or tool guidance.

## Soft review budget

Use a target of 100 non-blank lines / 12 KiB for the root file, with an advisory
warning at 150 lines / 20 KiB. These are review targets, not automatic deletion
rules. Measure lines and bytes because agent runtimes use different context
limits.

## Review rule

The instruction-surface audit is read-only. It reports size, approximate token
cost, sections, links, command candidates, duplicate candidates, likely scoped or
procedural content, and budget warnings. It may suggest a compaction, but never
rewrites or weakens policy automatically.

Before accepting a compaction, verify that every removed rule has a discoverable
canonical home, retained commands work or are clearly conditional, and safety,
authority, compatibility, worktree, and validation boundaries remain visible.

## Precedence

The nearest applicable instruction file may refine a broader file but must not
silently weaken a repository-wide boundary. User instructions take priority over
repository guidance. Canonical contracts remain authoritative over summaries in
`AGENTS.md`.
