# 003 - Agent Instruction Surface

Status: active
Owner: repo maintainers
Updated: 2026-08-27
Depends on: `docs/contracts/001-working-rules.md`
Affects: `AGENTS.md`, nested instruction files, `skills/`, `template-bundle/`,
Effigy instruction audits, and repository adoption guidance

## Purpose

`AGENTS.md` is an always-loaded context surface. Its job is to help an agent
understand the repository well enough to make sound local decisions: what the
project is, what must remain true, how maintainers think about trade-offs, where
the sharp edges are, and how normal work is proved. It must do that without
becoming a handbook, history file, or duplicate contract store.

Shortness is a constraint, not the objective. A concise reason, product
invariant, local term, or engineering instinct belongs in the root when it
materially improves common decisions. Context that merely records background or
serves an unusual procedure belongs on demand.

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
| Product identity, mental model, stakes, or preservation invariant | yes, when it guides common decisions | root `AGENTS.md` |
| Every-turn authority, safety, or stop boundary | yes | root `AGENTS.md` |
| Shared project vocabulary or completion lens | yes, when misunderstandings are common or costly | root `AGENTS.md` |
| Maintainer taste or a compact causal explanation | yes, when it transfers useful judgment | root `AGENTS.md` |
| Verified common orientation and validation commands | yes, compactly | root `AGENTS.md` |
| Minimal repository layout and canonical pointers | yes, compactly | root `AGENTS.md` |
| Rules for one directory, package, language, or file type | no | nearest nested `AGENTS.md` or path-scoped rule |
| Multi-step procedure or task-specific workflow | no | skill, guide, contract, or task surface |
| Extended rationale, history, examples, or completed work | no | architecture, research, logs, or README |
| Personal or machine-local preference/path | no | ignored local file or user-level configuration |
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

The categories describe purpose, not required headings. A sentence can explain
why a hard boundary exists without becoming a history lesson. A memorable
example can earn its place when it prevents a common destructive mistake.

## Reader journey

A useful root file normally establishes this journey, adapted to the project:

1. **Orientation:** what this repository is, who or what it serves, and the
   simplest useful mental model.
2. **Preservation intent:** the few product or system properties that changes
   must keep true, with enough reason to guide unfamiliar cases.
3. **Local judgment:** shared vocabulary, maintainers' engineering taste, and
   the distinction between hard rules, normal defaults, and overridable advice.
4. **Sharp edges:** a small number of costly failure modes, described by cause
   and consequence rather than prohibition alone.
5. **Completeness:** the surfaces, states, modes, or contracts that commonly
   turn a plausible change into a finished one.
6. **Mechanics and map:** verified common commands, a compact responsibility
   map, stop conditions, and pointers to detailed procedures.

This is a design sequence, not a mandatory outline. Small or infrastructure-only
repositories may combine or omit stages. Preserve an existing project voice
when it is clear and useful; do not normalize every repository into Northstar's
headings.

It may include a short generated-tool pointer when the tool contract is needed
on most runs. Long generated blocks must still pass the same audit.

## Exclusions from the root

Do not put these in the root file unless a specific project proves they are
needed every turn:

- task-specific instructions or a current task list;
- completed work, historical narrative, or extended rationale that does not
  change a common decision;
- full command inventories and optional selectors;
- detailed procedures already owned by a skill, contract, or guide;
- worker-mode worktree procedures that do not apply on normal turns;
- duplicated writing-style, papercut, handoff, or local-path procedures; a
  concise local voice or taste statement may remain when it guides most work;
- large examples, transcripts, or troubleshooting catalogues;
- provider-specific instructions that do not apply across agents.

## Audit behavior

The deterministic instruction-surface check is read-only. It should report:

- file path, non-blank lines, bytes, and an approximate token count;
- section and code-block inventory;
- transparent placement or freshness leads without claiming semantic certainty;
- links to canonical references and broken links;
- command candidates that need execution verification;
- budget warnings as context-cost evidence, never as a quality score;
- presence of the root Claude bridge and its exact `@AGENTS.md` reference.

The review skill owns the semantic assessment. Before assigning dispositions,
it must map each section's intended effect on the reader and assess:

- whether the whole file creates a coherent mental model and useful flow;
- whether important rules state their stakes or causal reason;
- whether force is legible: hard boundary, default, taste, or user-overridable
  guidance;
- whether the tone is direct, human, specific, and consistent with the project;
- whether hazards are memorable and completion coverage is conscious;
- whether each section earns its always-loaded cost without forcing needless
  archaeology elsewhere.

The review may suggest moves, deletions, or rewrites, but it must never edit an
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
