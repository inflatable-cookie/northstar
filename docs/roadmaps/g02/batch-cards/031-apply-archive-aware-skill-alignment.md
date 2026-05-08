# 031 - Apply Archive-Aware Skill Alignment

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/009-archive-aware-skill-and-setup-surfaces.md
Roadmap refs: g02.006 batch 6.2
Governing refs: docs/contracts/001-working-rules.md, skills/northstar-setup/SKILL.md, skills/northstar-plan/SKILL.md, skills/northstar-recover/SKILL.md
Auto-start next card: yes, if the re-proof batch is explicit

## Objective

Apply the archive-aware contract to the reusable skills, templates, and checks.

## Scope

- update the setup, plan, and recover skills
- update any bundle/template surfaces that should reflect the same posture
- keep the resulting behavior explicit without adding heavy automation

## Steps

1. Update the relevant skills and supporting references.
2. Update bundle/template surfaces where archive-aware behavior should be
   copy-ready.
3. Refresh checks or validation surfaces where deterministic expectations
   changed.

## Acceptance Criteria

- archive-aware behavior is explicit in the relevant reusable surfaces
- the re-proof batch is explicit and ready

## Evidence Required

- updated skills, bundle surfaces, and checks
- implementation batch log

## Stop Conditions

- the implementation starts inventing archive automation beyond the defined
  contract

## Completion Notes

Applied the archive-aware contract to the setup, plan, and recover skills,
added the archive surface to stricter setup guidance, and made the bundle
defaults explicit about seeding `docs/specs/archive/README.md` up front.
Archive handling remains deliberately manual: Northstar should explain and
enforce the posture, not auto-move planning artifacts behind the operator's
back.

## Next Task

Start `g02.006` batch `6.3` by re-proving the reusable archive-aware surface.
