# Agent Instruction Surface Optimization Closeout

Date: 2026-08-16 23:39 BST
Status: implementation complete; consumer measurement pending
Related milestone: `g02.027`
Related card: `g02.027/079`
Related spec: `docs/specs/028-agent-instruction-surface-optimization.md`
Related contract: `docs/contracts/003-agent-instruction-surface.md`

## Outcome

Northstar now has a deterministic, read-only `effigy check:agent-instructions`
audit and compact source/template `AGENTS.md` surfaces. The audit reports size,
approximate token cost, document shape, and transparent review signals for likely
scoped, procedural, historical, conversational, or over-budget content. It never
rewrites files.

## Measurements

| Surface | Before | After | Reduction |
| --- | --- | --- | --- |
| source `AGENTS.md` | 95 non-blank lines; 5,690 bytes; ~1,423 tokens | 43 non-blank lines; 2,619 bytes; ~655 tokens | 52 lines; 3,071 bytes; ~768 tokens |
| copy-ready template | 100 non-blank lines; 5,203 bytes; ~1,301 tokens | 35 non-blank lines; 1,707 bytes; ~427 tokens | 65 lines; 3,496 bytes; ~874 tokens |

The source root reduced by 54.7% in non-blank lines and 54.0% in bytes. The
template reduced by 65.0% in non-blank lines and 67.2% in bytes.

## Content disposition

### Retained in the root

- repository identity and Northstar/template-bundle authority;
- pre-1.0 migration and post-1.0 compatibility boundaries;
- worktree, nested-lane, release, and workflow safety boundaries;
- common Effigy orientation and validation commands;
- papercuts pointer and planning ambiguity stop rule;
- short pointers to canonical contracts and task surfaces.

### Moved to canonical references or compressed to pointers

- detailed manual worktree procedure -> `docs/contracts/002-agent-local-paths.md`;
- delivery, readiness, closeout, and papercut procedure ->
  `docs/contracts/001-working-rules.md`;
- root-versus-scoped instruction policy ->
  `docs/contracts/003-agent-instruction-surface.md`;
- detailed Effigy adoption, graph, JSON, and mode guidance -> the existing
  Effigy guide surfaces and Northstar skill references;
- detailed continuation, planning, writing-style, and compression guidance ->
  the owning skill/policy surfaces rather than every-turn root context.

### Removed from always-loaded context

- repeated startup/default-loop command blocks;
- first-time bootstrap example;
- full papercut procedure;
- conversational reporting and reply-style rules;
- current-task/history/roadmap narrative;
- long generated/tool reference prose that was not needed on every turn.

No safety, authority, compatibility, worktree, stop, or validation boundary was
removed; each retained boundary was checked against its canonical owner.

## Verification

- `effigy check:agent-instructions` — source and template: PASS, advisory only;
- `effigy check:agent-instructions AGENTS.md` — PASS;
- `effigy check:agent-instructions skills/northstar/assets/templates/AGENTS.md` — PASS;
- `effigy qa` — PASS;
- `effigy qa:docs` — PASS;
- `effigy doctor` — PASS, 19 OK / 0 warnings / 0 errors after graph refresh;
- `git diff --check` — PASS;
- installed `/Users/tom/.agents/skills/northstar` parity — PASS, 34 files;
- installed `/Users/tom/.hermes/skills/northstar` parity — PASS, 34 files.

## Remaining measurement

The implementation is complete, but the contract's later dogfood phase remains
open. Use the optimized surface in the planned Poodle-first direct dogfood and
record repeated setup questions, missed boundaries, failed commands, and
unnecessary repository exploration before tightening the budget further.
