# 003 - Agent Instruction Surface

Status: active
Owner: repo maintainers
Updated: 2026-08-16
Depends on: `docs/contracts/001-working-rules.md`
Affects: `AGENTS.md`, nested instruction files, `skills/`, `template-bundle/`,
Effigy instruction audits, and repository adoption guidance

## Purpose

`AGENTS.md` is an always-loaded context surface. It must help an agent on most
turns without becoming a handbook, history file, or duplicate contract store.
This contract defines what belongs in the root file and what should move to a
scoped or on-demand surface.

## Claude Code bridge

Repositories adopting this Northstar surface must also provide a root
`CLAUDE.md` containing the exact import reference `@AGENTS.md`.

`CLAUDE.md` is a Claude Code bridge, not a second repository authority. It may
contain concise Claude-specific instructions only when they cannot be expressed
in the shared `AGENTS.md` contract. Do not repeat cross-agent rules, policy, or
procedures in the bridge.

## Content classes

Every instruction belongs to one primary class:

| Class | Root `AGENTS.md`? | Canonical home |
| --- | --- | --- |
| Every-turn identity, authority, safety, or stop boundary | yes | root `AGENTS.md` |
| Verified common orientation and validation commands | yes, compactly | root `AGENTS.md` |
| Minimal repository layout and canonical pointers | yes, compactly | root `AGENTS.md` |
| Rules for one directory, package, language, or file type | no | nearest nested `AGENTS.md` or path-scoped rule |
| Multi-step procedure or task-specific workflow | no | skill, guide, contract, or task surface |
| Rationale, history, examples, or completed work | no | architecture, research, logs, or README |
- Personal or machine-local preference/path | no | ignored local file or user-level configuration |
| Claude Code bridge to the shared root contract | separate minimal `CLAUDE.md` | root `CLAUDE.md` with `@AGENTS.md` |

A short pointer may remain in the root file when it makes the canonical surface
discoverable. The root file must not duplicate the full rule.

## Root-file budget

Northstar uses a **soft review budget** for a root instruction file:

- target: no more than 100 non-blank lines and 12 KiB;
- advisory warning: above 150 non-blank lines or 20 KiB;
- no automatic deletion solely because a budget is exceeded.

These are Northstar operating targets, not claims that other agent runtimes use
the same limits. The audit must report both line and byte measurements because
runtimes impose different context limits.

## Required root shape

A compact root `AGENTS.md` should normally contain, in roughly this order:

1. repository identity and scope;
2. a small set of non-negotiable safety, authority, and compatibility
   boundaries, plus a concise pointer to any genuinely always-loaded worker
   boundary;
3. verified orientation and validation commands;
4. a minimal canonical-surface map;
5. stop/escalate rules;
6. links to detailed contracts, skills, and scoped instructions.

It may include a short generated-tool pointer when the tool contract is needed
on most runs. Long generated blocks must still pass the same audit.

## Exclusions from the root

Do not put these in the root file unless a specific project proves they are
needed every turn:

- task-specific instructions or a current task list;
- completed work, historical rationale, or roadmap narrative;
- full command inventories and optional selectors;
- detailed procedures already owned by a skill, contract, or guide;
- worker-mode worktree procedures that do not apply on normal turns;
- duplicated writing-style, papercut, handoff, or local-path procedures;
- large examples, transcripts, or troubleshooting catalogues;
- provider-specific instructions that do not apply across agents.

## Audit behavior

The instruction-surface audit is read-only. It should report:

- file path, non-blank lines, bytes, and an approximate token count;
- section and code-block inventory;
- likely always-loaded, scoped, procedural, historical, or duplicate content;
- links to canonical references and broken links;
- command candidates that need execution verification;
- budget warnings and a compactness score with explainable factors.
- presence of the root Claude bridge and its exact `@AGENTS.md` reference.

The audit may suggest moves, deletions, or rewrites, but it must never edit an
instruction file or weaken a safety/authority rule automatically. A compaction
change is accepted only with a reviewable diff and post-change validation.

## Review triggers

Re-audit a root instruction file when:

- an agent repeats a correction that should have been durable;
- a command, path, tool, or contract changes;
- a new nested instruction or skill makes root text redundant;
- the root file crosses an advisory budget;
- a consumer dogfood run reveals context pollution, missed boundaries, or
  unnecessary exploration.

## Precedence and authority

The nearest applicable instruction file may refine a broader file, but may not
silently weaken a repository-wide safety or authority boundary. User instructions
remain higher-priority than repository guidance. Canonical contracts and policy
surfaces remain authoritative over summaries in `AGENTS.md`.
