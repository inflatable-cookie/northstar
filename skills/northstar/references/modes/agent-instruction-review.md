# Agent Instruction Review

Use this mode for explicit requests such as:

- `northstar AGENTS file review`;
- review, audit, optimize, or compact an `AGENTS.md`;
- review the `CLAUDE.md` bridge alongside `AGENTS.md`;
- reduce always-loaded instruction noise for more efficient agent runs.

This is a docs-only, bounded, target-repository-aware review. Do not start a worker, create a worktree, or change production code.

## Procedure

1. Identify the target repository from the current working directory and verify
   its `AGENTS.md` and root `CLAUDE.md` before reading Northstar source files.
2. Run the target-local audit when available:

   ```bash
   effigy check:agent-instructions
   ```

   When reviewing a consumer repository from the Northstar catalog, use the
   target-root form so the audit does not inspect Northstar's own files:

   ```bash
   effigy northstar/check:agent-instructions /absolute/path/to/target-repo
   ```

3. If the audit task is unavailable, perform the same read-only measurements and
   content classification with repository tools. Do not silently substitute the
   Northstar source repository as the target.
4. Read `docs/contracts/003-agent-instruction-surface.md` when the target has
   Northstar's contract, or apply its six root-content classes: identity,
   boundaries, verified common commands, minimal orientation, stop rules, and
   canonical pointers.
5. Review `CLAUDE.md` as a bridge. It must contain the exact `@AGENTS.md`
   reference. Keep it to that one line unless a real Claude-specific repository
   instruction is needed.
6. Produce a disposition for each section: retain, move to canonical docs,
   replace with a pointer, remove as unnecessary, or investigate.
7. If the operator asked for optimization rather than audit-only review, apply
   the bounded `AGENTS.md`/`CLAUDE.md` changes and preserve safety, authority,
   compatibility, worktree, stop, and validation boundaries.
8. Run the target's relevant docs/QA checks, inspect the diff, and record the
   before/after measurements and any remaining uncertainty.

The audit is advisory and read-only. A review may edit only the instruction
surfaces and their evidence/docs unless the operator explicitly expands scope.
