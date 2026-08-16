# Translation Memo: Always-Loaded Agent Instruction Surface

Status: proposed
Owner: repo maintainers
Last updated: 2026-08-16
Related track: Northstar agent-run efficiency and instruction-surface design
Promotion targets: `docs/contracts/003-agent-instruction-surface.md`,
`docs/specs/028-agent-instruction-surface-optimization.md`, and
`docs/roadmaps/g02/027-optimize-agent-instruction-surfaces.md`

## 1) Project problem statement

`AGENTS.md` is loaded before ordinary work and competes directly with the task,
repository evidence, and tool output for context. Northstar currently treats the
file as a mixture of hard rules, setup notes, detailed procedures, generated
Effigy guidance, local-path policy, writing style, papercut workflow, and
reference navigation. Much of that is useful somewhere, but not all of it is
useful on every turn.

The goal is not to make the file short for its own sake. The goal is to keep the
always-loaded surface limited to durable facts and boundaries that materially
improve most agent runs, while moving scoped or procedural material to the
nearest useful contract, skill, guide, or nested instruction file.

## 2) External evidence summary

### OpenAI Codex

Codex discovers instruction files by scope, merges them from broad to specific,
and includes at most one instruction file per directory. It stops adding files
when the combined instruction size reaches a configurable limit, 32 KiB by
default. The official guidance describes root `AGENTS.md` as a place for basic
project expectations and recommends nested overrides for specialized areas.[1]

### Claude Code

Claude Code says project instruction files are loaded into every session and
recommends keeping them under 200 lines / 25 KiB. It distinguishes facts needed
every session from path-specific rules and on-demand skills, and recommends
specific, concise, concrete, verifiable instructions. It also warns that
imports are loaded into context and that contradictory or stale instructions
reduce reliability.[2]

### GitHub Copilot

GitHub separates repository-wide instructions, path-specific instructions, and
agent instructions. Its official onboarding guidance recommends keeping the
repository-wide instructions task-agnostic and no longer than two pages, while
covering repository purpose, technology, layout, and validated build/test/lint
steps that reduce exploration and failed runs.[3]

### AGENTS.md open format

The open format deliberately has no required fields. Its examples and guidance
centre on project orientation, setup/build/test commands, code style, testing,
security, and nested files for large repositories. It describes `AGENTS.md` as a
complement to human-facing README content, not a replacement for all project
documentation.[4]

## 3) Recommendation

Treat root `AGENTS.md` as an **always-loaded instruction contract**, not as a
handbook. Keep only these classes in the root file:

1. repository identity and scope;
2. non-negotiable safety, authority, and compatibility boundaries;
3. a small set of verified orientation and validation commands;
4. a compact map of the most important canonical surfaces;
5. stop/escalate rules for ambiguity, missing authority, or unsafe context;
6. pointers to detailed contracts, skills, and path-scoped instructions.

Move detailed procedures, rationale, history, examples, full generated tool
contracts, optional workflows, and conversational style guidance to their
canonical references. Keep nested instruction files for path-specific rules and
skills for task-specific procedures.

Northstar should add a read-only audit that reports instruction size, content
classification, reference health, duplication candidates, and likely stale
commands. It should produce a reviewable proposal, never silently rewrite or
remove policy.

## 4) Tradeoffs the project would accept

- A compact root file may require one deliberate reference read at the start of
  an unusual task.
- Some instructions will be repeated in a short pointer and a canonical
  contract to preserve discoverability.
- The audit will be advisory first rather than an aggressive hard gate.
- The root file may include a small amount of generated runner guidance when it
  is genuinely needed on most runs, but the generated block must still be
  measured and reviewed.

## 5) What must be true before adoption

- Every removed rule has a canonical surviving home or is explicitly classified
  as unnecessary.
- Commands retained in the root file have been run successfully in the target
  repository or are clearly labelled as conditional.
- Safety, authority, worktree, compatibility, and stop boundaries remain
  discoverable without requiring a long transcript or private context.
- Root and nested instruction precedence is documented.
- The source `AGENTS.md` and copy-ready template are audited independently.
- The before/after size and content-classification report is recorded.

## 6) Required prototype or validation work

- Run the audit against Northstar's current `AGENTS.md` and template.
- Produce a compact candidate preserving all safety and authority rules.
- Check every link and command named by the candidate.
- Run Northstar docs/bundle/doctor QA and installed-skill parity.
- Use one later consumer dogfood to measure whether agents ask fewer setup or
  navigation questions without losing important boundaries.

## 7) Promotion target

- `architecture work` — the always-loaded versus scoped instruction boundary;
- `roadmap planning` — audit, compaction, and dogfood card;
- `watch only` — provider-specific file-size limits beyond Northstar's own target.

## 8) Sources

The source pages were retrieved on 2026-08-16.

[1] OpenAI Codex, “Custom instructions with AGENTS.md”.
[2] Claude Code, “How Claude remembers your project”.
[3] GitHub Copilot, “Adding repository custom instructions”.
[4] AGENTS.md open format and examples.

## Sources

[1] https://learn.chatgpt.com/docs/agent-configuration/agents-md — OpenAI Codex: Custom instructions with AGENTS.md
[2] https://code.claude.com/docs/en/memory — Claude Code: How Claude remembers your project
[3] https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions — GitHub Copilot: Adding repository custom instructions
[4] https://agents.md — AGENTS.md open format
