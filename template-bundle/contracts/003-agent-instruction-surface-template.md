# 003 - Agent Instruction Surface

**Type: TEMPLATE** -- Copy into `docs/contracts/003-agent-instruction-surface.md`
when a project wants always-loaded agent instructions to be useful, human, and
deliberately bounded.

Status: active
Owner: <owner>
Updated: YYYY-MM-DD
Depends on: `docs/contracts/001-working-rules.md`

## Purpose

`AGENTS.md` is always-loaded context. It should help an unfamiliar agent
understand what the project is, what must remain true, how maintainers think
about trade-offs, where the sharp edges are, and how normal work is proved.
Move scoped rules, long procedures, history, and on-demand material to the
surface that owns them.

Shortness is a constraint, not the objective. Keep the shortest reason,
invariant, local term, or engineering instinct that materially improves common
decisions.

## Root content classes

Keep these in the root file:

- repository identity, human stakes, and the simplest useful mental model;
- a small set of product or system properties that changes must preserve;
- non-negotiable safety, authority, compatibility, and stop boundaries;
- shared vocabulary or a completion lens where misunderstandings are costly;
- maintainer taste or causal explanation that transfers useful judgment;
- verified common orientation and validation commands;
- a minimal canonical-surface map;
- concise pointers to detailed contracts, guides, skills, and nested rules.

Keep these elsewhere unless they are genuinely needed every turn:

- task-specific instructions and current task lists;
- detailed procedures, optional command inventories, and troubleshooting;
- history, extended rationale, large examples, and completed work;
- path-specific rules and personal or machine-local preferences;
- duplicated contract, style, papercut, handoff, or tool guidance.

## Soft review budget

Use a target of 100 non-blank lines / 12 KiB for the root file, with an advisory
warning at 150 lines / 20 KiB. These are review targets, not automatic deletion
rules. Measure lines and bytes because agent runtimes use different context
limits.

## Reader journey

Adapt the file to the project rather than enforcing fixed headings. A useful
flow usually establishes:

1. orientation and stakes;
2. preservation intent and local engineering judgment;
3. memorable sharp edges with causes and consequences;
4. what complete means across relevant surfaces, states, or modes;
5. verified mechanics, a compact responsibility map, and stop conditions.

Make the force of guidance clear: hard boundary, normal default, maintainer
taste, or user-overridable advice. Preserve a useful existing project voice.

## Review rule

The deterministic check is read-only. It reports size, approximate token cost,
sections, links, command candidates, placement or freshness leads, and budget
warnings. The semantic review maps each section's intent and assesses the whole
file's mental model, flow, tone, force, causal clarity, completion coverage, and
decision usefulness. Mechanical evidence is not a prose-quality score.

Before accepting a rewrite, verify that every removed reader need has a
discoverable surviving home, retained commands work or are clearly conditional,
and product intent, safety, authority, compatibility, worktree, and validation
boundaries remain visible.

## Precedence

The nearest applicable instruction file may refine a broader file but must not
silently weaken a repository-wide boundary. User instructions take priority over
repository guidance. Canonical contracts remain authoritative over summaries in
`AGENTS.md`.
