# 019 - Formalize Repo Posture Classification

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.018
Vision tags: `skills`, `setup`, `planning`, `recovery`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/022-formalize-repo-posture-classification.md`
Planning state: complete

## Problem

Northstar's package now explains repo shapes better, but the installed skills
still rely too much on operator judgment when deciding whether a repo is in a
healthy execution lane, a paused planning gate, a migration program, or a
drifted recovery state.

## Goals

- [x] identify posture classification as the next concrete package gap
- [x] add one explicit posture taxonomy to reusable doctrine
- [x] wire that taxonomy into `northstar-setup`, `northstar-plan`, and `northstar-recover`

## Execution Plan

### Batch 19.1 - Promote Repo Posture Classification Into Skills

- [x] close the workspace-container specimen lane
- [x] add the taxonomy to doctrine and setup references
- [x] update the core skills and prompts to use it

## Acceptance Criteria

- [x] the package names the recurring repo postures explicitly
- [x] setup/plan/recover each use the same posture model
- [x] paused-gate versus ready-lane versus drifted-state triage is more mechanical than before

## Next Task

Use the posture taxonomy in the next real setup, planning, or recovery pass
and see whether the package now needs a concrete recovery specimen or whether
the current skill wording is enough.
