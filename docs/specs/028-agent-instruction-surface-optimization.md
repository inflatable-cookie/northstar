# 028 - Agent Instruction Surface Optimization

Status: complete
Owner: repo maintainers
Created: 2026-08-16
Updated: 2026-08-27
Related research: `bundle-docs/research/translation-memos/agent-instruction-surface-optimization.md`
Governing architecture: `docs/architecture/system-architecture.md`
Governing contract: `docs/contracts/003-agent-instruction-surface.md`

## Problem

Northstar's `AGENTS.md` is loaded on every agent run, but it currently combines
rules with different lifetimes: every-turn boundaries, detailed procedures,
generated runner guidance, local-path instructions, writing style, papercuts,
and navigation. That increases context cost and makes it harder to tell which
sentences are truly binding for the current task.

Northstar needs a repeatable way to audit and improve the always-loaded surface
without deleting useful identity, intent, safety, authority, or validation
guidance. Operator feedback showed that a classification-and-compaction lens is
not sufficient: a short file can still be sterile, hard to internalise, and weak
at transferring project judgment.

## Goal

Make `AGENTS.md` a high-signal, human instruction contract. It should orient the
agent, communicate what must stay true and why, distinguish hard boundaries from
defaults and taste, and provide reliable mechanics. Move scoped, procedural,
historical, and on-demand material to its canonical owner without optimizing
for smallness at the expense of judgment.

## Design

The feature has three parts:

1. **Content contract:** define the reader journey and classify instruction text
   by the decision it improves: orientation, preservation intent, local
   judgment, sharp edge, completeness, mechanics, or on-demand detail.
2. **Read-only audit:** report size, section shape, approximate token cost,
   references, duplicate candidates, command candidates, and budget warnings.
3. **Semantic review and rewrite:** map each section's intent, flow, tone, force,
   and decision value before rewriting the Northstar source `AGENTS.md` and
   copy-ready template.

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
- the deterministic check identifies mechanical placement/freshness leads
  without claiming semantic certainty it cannot prove;
- the review skill assesses section intent, reader flow, tone, force, causal
  clarity, completion coverage, and decision usefulness;
- the source repository and copy-ready starter both provide a minimal Claude
  bridge containing `@AGENTS.md`;
- the source and template root files contain every-turn judgment and boundaries
  plus short canonical pointers;
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

No blocking work remains. Consume later operator-provided feedback as new
evidence; do not select, dispatch, or modify a consumer repository from this
spec.
