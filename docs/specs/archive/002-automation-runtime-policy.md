# 002 - Automation Runtime Policy

Status: complete
Owner: repo maintainers
Updated: 2026-04-08
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g01.002

## Problem

Northstar currently tolerates a mixed scripting surface across repos. In
practice that means Bash, Python, and TypeScript all appear for similar kinds
of repo automation, which makes projects harder to read, maintain, and extend.

## Target Operating Model

Northstar should publish and use a clear automation stack:

- prefer `effigy` when it already covers the operation
- default repo-owned automation to `TypeScript` run with `bun`
- use `bash` only for very thin glue or compatibility boundaries
- use `python` or other runtimes only with a concrete technical justification

## Goals

- Capture the automation runtime policy in Northstar doctrine and working rules.
- Make `northstar-setup` install and explain the policy by default.
- Apply the policy to Northstar itself by migrating the repo checker scripts
  away from Bash.
- Keep the policy practical rather than ideological by preserving Effigy as the
  first-choice bootstrap and maintenance layer.

## Non-Goals

- Banning every non-TypeScript runtime in every situation.
- Replacing Effigy with bespoke Bun scripts.
- Migrating unrelated runtime surfaces that are not part of the current repo
  automation lane.

## Planned Surfaces

- bundle doctrine and template guidance
- live working rules
- `northstar-setup` skill and starter templates
- repo script policy surface
- live repo checker scripts and Effigy tasks

## Acceptance Criteria

- Northstar doctrine defines `Effigy -> TS/Bun -> exception-only Bash/Python`
  as the default automation stack.
- `northstar-setup` installs and explains that policy clearly.
- The live repo no longer relies on Bash for its main checker scripts.
- Validation still passes after the migration.

## Stop Conditions

- The policy weakens Effigy-first setup and maintenance.
- The repo ends the batch with mixed Bash and TypeScript versions of the same
  checker logic.
- The migration adds more ceremony than it removes.

## Next Task

Use the next live milestone to reduce ready-state and closeout friction now
that the repo's automation stack is explicit and consistent.
