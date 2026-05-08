# 032 - Re-Prove Archive-Aware Surface

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/009-archive-aware-skill-and-setup-surfaces.md
Roadmap refs: g02.006 batch 6.3
Governing refs: docs/contracts/001-working-rules.md, skills/northstar-setup/SKILL.md, skills/northstar-plan/SKILL.md, skills/northstar-recover/SKILL.md
Auto-start next card: yes, if the next slice is explicit

## Objective

Re-prove that the reusable archive-aware surface is explicit enough without
adding unnecessary complexity.

## Scope

- inspect the updated reusable surfaces from an operator/agent point of view
- record any remaining ambiguity that still matters
- compile the next slice only if a bounded problem remains

## Steps

1. Re-run the relevant reusable-surface path.
2. Record any remaining bounded ambiguity.
3. Open another slice only if it is justified.

## Acceptance Criteria

- the reusable archive-aware surface is re-proved
- remaining ambiguity is explicit and bounded
- the next slice is only opened if warranted

## Evidence Required

- re-proof log
- updated roadmap/spec state if another slice opens

## Stop Conditions

- the re-proof becomes another speculative docs pass

## Completion Notes

Re-proof showed the archive-aware surface is now explicit enough for routine
use. Setup installs the archive surface when warranted, planning and recovery
read it when present, and the bundle makes the posture copy-ready without
adding heavy archive automation. No further archive-specific slice is
justified right now.

## Next Task

Start `g02.007` batch `7.2` by applying the continuation-envelope and
stop-signal contract to the working rules, templates, and handoff/planning
surfaces.
