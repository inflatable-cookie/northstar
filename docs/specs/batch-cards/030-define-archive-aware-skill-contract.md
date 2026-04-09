# 030 - Define Archive-Aware Skill Contract

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/009-archive-aware-skill-and-setup-surfaces.md
Roadmap refs: g02.006 batch 6.1
Governing refs: docs/contracts/001-working-rules.md, template-bundle/specs/README.md, template-bundle/specs/archive/README.md
Auto-start next card: yes, if the implementation batch is explicit

## Objective

Define how setup, planning, and recovery should expose and use the spec archive
posture.

## Scope

- define what `northstar-setup` should install or explain
- define what `northstar-plan` and `northstar-recover` should read or update
- define which bundle surfaces should make the archive posture explicit

## Steps

1. Define the archive-aware contract for setup, planning, and recovery.
2. Define the corresponding bundle and template expectations.
3. Leave the implementation batch explicit and ready.

## Acceptance Criteria

- the archive-aware contract is explicit enough to implement
- the implementation batch is explicit

## Evidence Required

- updated spec/roadmap state
- next ready implementation batch

## Stop Conditions

- the contract stays too vague to implement cleanly

## Completion Notes

Defined the archive-aware contract across four areas:

- setup should install or explain the archive surface when `specs/` are part of
  the stricter docs contract
- planning should treat archive as part of normal lifecycle decisions when
  closed planning artifacts no longer belong in the active tree
- recovery should inspect and repair both the active specs surface and the
  archive posture when stale planning is part of the problem
- the bundle should make the same archive-aware behavior copy-ready without
  turning archive into a heavy subsystem

That leaves `6.2` as an implementation batch against concrete reusable
surfaces rather than another doctrine pass.

## Next Task

Start `g02.006` batch `6.2` by applying the archive-aware contract to the
skills, bundle, and checks.
