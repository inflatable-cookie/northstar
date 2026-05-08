# 007 - Align Setup With Standard Docs Spine

Status: archived
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/001-northstar-delivery-layer.md
Roadmap refs: g01.001 batch 1.4
Governing refs: docs/contracts/001-working-rules.md, skills/northstar-setup/SKILL.md, template-bundle/README.md
Auto-start next card: yes, if setup guidance and starter templates now point at the standard stricter spine

## Objective

Update `northstar-setup` so the standard stricter docs spine is scaffolded and
explained directly instead of being pieced together from multiple references.

## Scope

- align the skill wording with the standard stricter docs spine
- update delivery-layer adoption guidance
- update the setup docs front-door template so the canonical surfaces are clear

## Steps

1. Update `northstar-setup` to describe the standard baseline and stricter
   docs spines more plainly.
2. Update delivery-layer adoption guidance to reference the concrete standard
   stricter spine.
3. Update the docs README template so it reflects the new structure directly.

## Acceptance Criteria

- `northstar-setup` names the standard stricter docs spine explicitly
- the delivery-layer adoption reference points at concrete bundle surfaces
- the docs README template reflects the canonical execution surfaces clearly

## Evidence Required

- updated files under `skills/northstar-setup/`
- updated setup templates that reference the standard stricter spine

## Stop Conditions

- setup still requires operators to assemble the stricter spine from scattered docs
- the setup wording drifts away from the published bundle doctrine

## Completion Notes

`northstar-setup` now names the baseline versus stricter docs spine directly,
and its adoption/template refs point at concrete bundle files instead of
leaving operators to reconstruct the stricter surface from scattered docs.

## Next Task

Tighten the repo contract check around the new standard spine, run validation,
and log what this uninterrupted three-card lane revealed about the autonomy
envelope.
