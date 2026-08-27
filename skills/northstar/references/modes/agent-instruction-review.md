# Agent Instruction Review

Use this mode for explicit requests such as:

- `northstar AGENTS file review`;
- review, audit, optimize, or compact an `AGENTS.md`;
- review the `CLAUDE.md` bridge alongside `AGENTS.md`;
- reduce always-loaded instruction noise for more efficient agent runs.

This is a docs-only, bounded, target-repository-aware review. Do not start a
worker, create a worktree, or change production code.

The goal is not the smallest possible file. The goal is an always-loaded guide
that lets an unfamiliar agent understand the project, preserve its intent, and
work safely without unnecessary archaeology.

## Procedure

1. Identify the target repository from the current working directory and verify
   its `AGENTS.md` and root `CLAUDE.md` before reading Northstar source files.
2. Run the target-local audit when available:

   ```bash
   effigy check:agent-instructions
   ```

   If the target is the Northstar source repository, this uses the source
   catalog's task, which points at the shared helper shipped in the skill.

   When reviewing a consumer repository and no target-local task exists, resolve
   the installed Northstar skill directory and select its bundled Effigy catalog:

   ```bash
   effigy --repo /absolute/path/to/installed/northstar northstar/check:agent-instructions /absolute/path/to/target-repo
   ```

   The installed catalog contains only this consumer-safe, read-only audit; it
   does not make the rest of Northstar's source-repository QA tasks available.

3. If neither a target-local task nor the installed Northstar catalog is
   available, perform the same read-only measurements with repository tools.
   Do not silently substitute the Northstar source repository as the target.
   Treat mechanical output as evidence, never as a verdict on prose quality.
4. Read the whole applicable instruction chain in precedence order. Inspect the
   repository README, architecture front door, common task surface, and any
   product or engineering principles needed to understand what the instruction
   file is trying to protect. Do not review isolated sentences without their
   project context.
5. Read `docs/contracts/003-agent-instruction-surface.md` when the target has
   Northstar's contract. Otherwise apply the same reader-journey lenses:
   orientation, preservation intent, local judgment, sharp edges,
   completeness, mechanics, and canonical pointers. These are questions, not
   mandatory headings.
6. Build a section-intent map before recommending changes. For each section,
   record:

   - what it is trying to help the agent understand, decide, avoid, or verify;
   - how it contributes to the flow of the whole file;
   - whether its force is clear: non-negotiable boundary, normal default,
     maintainer taste, or user-overridable advice;
   - whether the important reason or consequence is present;
   - whether its tone is direct, human, project-specific, and easy to remember;
   - whether it earns its always-loaded context cost.

7. Review the file as one reader journey. Ask:

   - Can an unfamiliar agent explain what the project is and what matters before
     touching its mechanics?
   - Are the few properties that must survive a change explicit?
   - Are project-specific terms defined where ordinary meanings would mislead?
   - Are dangerous mistakes explained by cause and consequence rather than as a
     flat wall of prohibitions?
   - Does the file teach what “complete” means across relevant surfaces, states,
     clients, or modes?
   - Do commands and the responsibility map arrive after enough context to make
     them useful?
   - Is the voice recognisably this project, or could the file belong anywhere?
   - Is any section concise only because it pushes common understanding into
     repeated repository archaeology?

8. Review `CLAUDE.md` as a bridge. It must contain the exact `@AGENTS.md`
   reference. Keep it to that one line unless a real Claude-specific repository
   instruction is needed.
9. Produce a disposition for each section: retain, rewrite for intent, reorder,
   merge, move to canonical docs, replace with a pointer, remove as unnecessary,
   or investigate. Explain what reader need survives every move or deletion.
10. If the operator asked for optimization rather than audit-only review, apply
    the bounded `AGENTS.md`/`CLAUDE.md` changes. Preserve project voice and all
    safety, authority, compatibility, worktree, stop, and validation boundaries.
    Do not impose Northstar's headings or imitate an external example.
11. Run the target's relevant docs/QA checks, inspect the diff, and record:

    - the improved reader journey and any deliberately project-specific shape;
    - before/after measurements as context-cost evidence, not a quality score;
    - boundaries and intent preserved;
    - remaining ambiguity or material missing guidance.

The audit is advisory and read-only. A requested optimization may edit only the
instruction surfaces and their evidence/docs unless the operator explicitly
expands scope.
