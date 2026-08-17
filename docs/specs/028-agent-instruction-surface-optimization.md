# 028 - Agent Instruction Surface Optimization

Status: active — source implementation complete; operator feedback measurement pending
Owner: repo maintainers
Created: 2026-08-16
Updated: 2026-08-17
Related research: `bundle-docs/research/translation-memos/agent-instruction-surface-optimization.md`
Governing architecture: `docs/architecture/system-architecture.md`
Governing contract: `docs/contracts/003-agent-instruction-surface.md`

## Problem

Northstar's `AGENTS.md` is loaded on every agent run, but it currently combines
rules with different lifetimes: every-turn boundaries, detailed procedures,
generated runner guidance, local-path instructions, writing style, papercuts,
and navigation. That increases context cost and makes it harder to tell which
sentences are truly binding for the current task.

Northstar needs a repeatable way to audit and compact the always-loaded surface
without deleting useful safety, authority, or validation guidance.

## Goal

Make `AGENTS.md` a small, high-signal instruction contract. Keep every-turn
facts and boundaries in the root file; move scoped, procedural, historical, and
on-demand material to the canonical surface that owns it. Provide a read-only
audit that makes the trade-offs visible before any rewrite.

## Design

The feature has three parts:

1. **Content contract:** classify instruction text as every-turn, verified common
   command/orientation, minimal pointer, scoped rule, procedure, history, or
   local preference.
2. **Read-only audit:** report size, section shape, approximate token cost,
   references, duplicate candidates, command candidates, and budget warnings.
3. **Compaction pass:** review and rewrite the Northstar source `AGENTS.md` and
   copy-ready template, preserving all important boundaries and moving detail to
   canonical contracts, skills, guides, or nested files.

The read-only audit is advisory and explainable. It never edits files or silently
weakens policy. Northstar's soft root target is 100 non-blank lines / 12 KiB, with an
advisory warning at 150 lines / 20 KiB.

## Non-goals

- no provider-specific instruction dialect or second public skill;
- no automatic deletion or automatic rewriting of `AGENTS.md`;
- no requirement that every repository use exactly the Northstar budget;
- no migration of all consumer repositories in this card;
- no moving safety, authority, compatibility, or worktree boundaries out of
  discoverable canonical surfaces;
- no replacement of README, contracts, skills, nested instructions, or policy
  docs with one giant root file.

## Required surfaces

- `docs/contracts/003-agent-instruction-surface.md`;
- a root `CLAUDE.md` bridge containing `@AGENTS.md`;
- `effigy check:agent-instructions` or an equivalent deterministic read-only
  Effigy audit;
- an optimized Northstar source `AGENTS.md`;
- an optimized copy-ready `skills/northstar/assets/templates/AGENTS.md`;
- setup/template guidance explaining root versus scoped/on-demand content;
- a before/after audit report and validation evidence.

## Acceptance criteria

- the audit reports line, byte, and approximate token measurements;
- the audit identifies likely scoped/procedural/history/duplicate content without
  claiming semantic certainty it cannot prove;
- the source repository and copy-ready starter both provide a minimal Claude
  bridge containing `@AGENTS.md`;
- the source and template root files contain only every-turn content plus short
  canonical pointers;
- detailed local-path, papercut, writing-style, Effigy, and orchestrator rules
  remain available from their owning surfaces;
- all retained commands are verified or clearly labelled conditional;
- links and required contract references pass QA;
- Northstar's source/install skill parity remains green;
- the before/after diff and audit report show no lost safety or authority rule;
- no consumer repository is changed by this implementation card.

## Validation

- `git diff --check`;
- `effigy check:agent-instructions` against the source and template;
- `effigy qa`;
- `effigy qa:docs`;
- `effigy doctor`;
- both installed Northstar skill parity checks;
- one manual review of the final root file against the content-class contract.

## Stop conditions

- a proposed deletion has no surviving canonical home;
- the audit cannot distinguish a summary from an authority surface;
- compaction would hide a safety, authority, compatibility, or worktree boundary;
- a command cannot be verified and is not explicitly conditional;
- the work expands into a general consumer-repo migration or provider-specific
  integration;
- the root file becomes shorter but the agent must perform materially more
  repository archaeology on common tasks.

## Next task

Use feedback from the operator's live use of the optimized surface and record the
Batch 27.3 measurement. Northstar does not select or dispatch a consumer target;
it consumes evidence supplied in this conversation. Do not modify consumer
repositories as part of the implementation phase of this spec.
