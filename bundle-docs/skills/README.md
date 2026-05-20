# Skill Architecture

This folder describes how Northstar skills should be structured.

The main goal is to keep the always-visible skill surface small so activation
stays reliable. Northstar should prefer a few broad entry-point skills with
clear intent, then load deeper modes and references only when needed.

When authoring or editing skill bodies, use the [protocol kernel](../protocol-kernel.md)
as the map of canonical doctrine versus repo contracts so skills **link**
instead of duplicating long enumerations.

## Recommended Public Skill Surface

Keep the top-level installable surface to these skills:

- `northstar-setup`
- `northstar-plan`
- `northstar-recover`
- `northstar-research`
- `northstar-handoff`

`northstar-setup` should absorb the former `northstar-effigy` role rather than
exposing Effigy in the public skill name. Effigy remains one useful setup
layer, not the whole operator-facing identity.

## Why This Shape

Use a top-level skill only when the user intent is already distinct in the
first sentence of the request.

Examples:

- “Set this repo up under Northstar”
- “Plan this system before we build”
- “Recover this project; the plan has drifted”
- “Turn this research into project decisions”
- “Create a handoff for the next thread”

Do not create a separate public skill when the distinction only appears after
diagnosis. That should be an internal mode inside a broader skill.

## Merge Map

Current skill surface:

- `northstar-setup`
- `northstar-plan`
- `northstar-recover`
- `northstar-research`
- `northstar-handoff`

Recommended consolidated surface:

- `northstar-setup`
  absorbs: former `northstar-effigy`
- `northstar-plan`
  absorbs: former `northstar-plan-product`, former `northstar-roadmap-compiler`
- `northstar-recover`
  absorbs: former `northstar-replan`, former `northstar-refocus`
- `northstar-research`
  absorbs: former `northstar-research-contracts`
- `northstar-handoff`
  remains top-level

## Internal Modes

Each public skill should stay short and route internally to a small number of
deeper modes.

Suggested mode layout:

- `northstar-setup`
  - repo bootstrap and normalization
  - Effigy adoption and validation setup when appropriate
  - migration from loose docs structure into canonical Northstar shape
  - **refactor maturity rules for agents:** no pre-1.0 compatibility shims;
    escalate breaking changes; from v1.0 onward preserve expected stable behavior
    (see `bundle-docs/sections/07-delivery-framework-and-autonomy.md` and the
    working-rules contract in the template bundle)
- `northstar-plan`
  - plan from scratch
  - write or repair contract surfaces
  - compile roadmaps from approved contracts
- `northstar-recover`
  - bounded replan after known change
  - broad refocus after drift
  - audit-and-repair sweep flow
- `northstar-research`
  - research intake and framing
  - promotion into architecture
  - promotion into contracts
- `northstar-handoff`
  - continuation brief
  - batch closeout handoff
  - spin-off prompt for parallel or follow-on work

## Structural Rules

- Keep the number of public skills low.
- Keep public skill descriptions broad, distinct, and non-overlapping.
- Put detailed procedures in `references/` and load them only when the chosen
  mode requires them.
- Prefer internal mode files over adding new top-level skills for adjacent
  concepts.
- Use operator docs and starter prompts for human guidance; do not turn every
  reusable prompt into a skill.

## Migration Plan

Recommended order:

1. Move deeper procedures into mode references under each merged skill.
2. Update operator docs and install surfaces after the merged skills are stable.

## Day-To-Day Posture

Northstar should feel like:

- a small number of reliable entry points
- strong internal routing once a skill is chosen
- detailed guidance loaded on demand

It should not feel like a large menu of near-duplicate skills competing to
trigger on slightly different wording.

## Next task

Stabilize the five-skill surface in real use, then trim any remaining operator
or maintenance wording that still speaks in terms of the retired split skills.
