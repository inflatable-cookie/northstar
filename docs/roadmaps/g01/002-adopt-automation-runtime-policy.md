# 002 - Adopt Automation Runtime Policy

Status: complete
Owner: repo maintainers
Created: 2026-04-08
Depends on: g01.001
Vision tags: `automation`, `repo-discipline`, `setup`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/archive/002-automation-runtime-policy.md`
Planning state: complete

## Problem

Northstar still leaves too much room for mixed scripting surfaces, which makes
repo automation harder to read and maintain than it should be.

## Goals

- Define a clear default automation stack for Northstar repos.
- Keep Effigy as the first-choice bootstrap and maintenance layer.
- Default repo-owned scripts to TypeScript run with Bun.
- Minimize Bash and Python usage to explicit exceptions.
- Apply the same rule to Northstar itself.

## Non-Goals

- Replacing Effigy with custom scripts.
- Migrating unrelated runtime surfaces outside the active checker lane.

## Contract Coverage

- [x] The runtime policy is covered by the live working-rules contract.
- [x] The milestone uses an active master spec and ready batch cards.

## Execution Plan

### Batch 2.1 - Capture the policy in doctrine and setup

- [x] Add the automation runtime doctrine to `bundle-docs/sections/`.
- [x] Update the live and template working-rules surfaces.
- [x] Update `northstar-setup`, its repo contract, and starter templates.
- [x] Add a standard scripts README template and align the live repo guidance.

### Batch 2.2 - Migrate the live checker lane

- [x] Replace the Bash checker scripts with TypeScript+Bun versions.
- [x] Update `effigy.toml` to use the new scripts.
- [x] Tighten repo checks around the runtime policy.
- [x] Sync the updated setup skill into Codex and Claude.
- [x] Run validation and record the result in a batch log.

## Acceptance Criteria

- [x] Northstar doctrine defines the default automation stack clearly.
- [x] Setup guidance makes the runtime hierarchy explicit for new repos.
- [x] The live repo checker lane runs through Bun/TypeScript rather than Bash.
- [x] Validation passes after the migration.

## Risks and Mitigations

- Risk: the policy becomes ideological and fights Effigy instead of reinforcing it.
- Mitigation: keep Effigy first in doctrine, setup guidance, and task wiring.
- Risk: the migration adds a second checker surface instead of replacing the first.
- Mitigation: remove the Bash checkers in the same batch.

## Planning Gaps

- None. The policy change is narrow and the implementation path is explicit.

## Evidence Requirements

- [x] One batch log for the completed runtime-policy lane.
- [x] Validation commands actually run.
- [x] Updated installed `northstar-setup` skill in both tool homes.

## Next Task

Compile the next live milestone around ready-state selection and closeout
mechanics for longer hands-off execution.
