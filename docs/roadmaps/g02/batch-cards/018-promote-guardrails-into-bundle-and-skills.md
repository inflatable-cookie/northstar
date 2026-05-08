# 018 - Promote Guardrails Into Bundle And Skills

Status: archived
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/archive/005-execution-guardrails-and-longer-autonomy.md
Roadmap refs: g02.002 batch 2.2
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/sections/07-delivery-framework-and-autonomy.md, template-bundle/README.md
Auto-start next card: yes, if the resulting bundle and skill surfaces stay coherent

## Objective

Promote the new execution guardrail pack into the reusable bundle and the
installed Northstar skill wording.

## Scope

- update the copy-ready bundle surfaces that should carry the new guardrails
- align setup, plan, and recovery surfaces where those guardrails should be
  inherited automatically
- keep the operator front door short while moving the real rules into canonical
  doctrine and templates

## Steps

1. Update the template bundle surfaces that should carry the guardrail pack.
2. Align the installed skill wording with the new anti-fake-work and
   anti-complexity posture.
3. Validate and record the promotion work.

## Acceptance Criteria

- the template bundle carries the new guardrail pack in the right canonical surfaces
- relevant skill wording reflects the guardrails without growing the public
  skill surface
- the next lane can focus on a longer autonomy pilot rather than reopening
  doctrine

## Evidence Required

- updated bundle and skill surfaces
- validation commands recorded in the batch log

## Stop Conditions

- the batch adds new top-level skill surfaces instead of tightening the current ones
- the bundle gains ceremony without clearer anti-fake-work rules

## Completion Notes

Promoted the execution guardrail pack into the copy-ready bundle and aligned the
installed `northstar-setup`, `northstar-plan`, and `northstar-recover` skills
with the same posture. Also clarified the intended lifecycle of `specs/`:
they are provisional by default, may remain while a lane is active or their
history is useful, and should be archived or removed when they no longer add
value beyond the promoted canonical surfaces.

## Next Task

Start the longer autonomy lane once the bundle and skill promotion is complete.
