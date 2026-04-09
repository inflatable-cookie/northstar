# 005 - Execution Guardrails And Longer Autonomy

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.002

## Problem

The Signal pilot improved the operator front door, but it did not solve the
larger execution problem that keeps appearing across consumer repos: agents
still overcomplicate UIs, stop at substrate or mockup depth, leave partially
realized paths behind, and need too much operator prompting to stay on the
intended lane.

## Target Operating Model

Northstar should make these failure modes much harder by default.

That means:

- execution guardrails are explicit and reusable
- definition-of-done language rejects fake completion rather than merely
  preferring better behavior
- setup and planning surfaces install those guardrails by default for stricter
  projects
- longer autonomous runs follow ready card chains under those guardrails rather
  than free-form interpretation
- Northstar continues proving this in its own repo before treating it as stable
  doctrine for other projects

## Goals

- Define a reusable execution guardrail pack for stricter Northstar projects.
- Promote those guardrails into doctrine, template surfaces, and skill wording.
- Make regular spec hygiene an explicit protocol rule so specs stay focused on
  active planning as projects grow.
- Extend autonomy only where the guardrails and batch-card chain are strong
  enough to keep work on a real execution path.
- Keep `g02` open as the long-running external-proof and execution-hardening
  generation.

## Non-Goals

- Opening a new generation just because `g02.001` closed.
- Adding a larger public skill surface.
- Pretending autonomy is solved by policy language alone without another live
  lane to test it.

## Artifact Set

- `bundle-docs/sections/07-delivery-framework-and-autonomy.md`
- `bundle-docs/sections/03-roadmaps.md`
- `template-bundle/roadmaps/`
- `docs/contracts/001-working-rules.md`
- `docs/roadmaps/g02/002-tighten-execution-guardrails-and-extend-autonomy.md`

## Phased Delivery

### Phase 1

Define the execution guardrail pack and the long-lived generation posture in
published doctrine plus the live working rules.

### Phase 2

Promote the guardrail pack into the template bundle and the installed skill
surfaces so stricter repos inherit the same rules by default.

### Phase 3

Make regular spec cleanup explicit in the live protocol and milestone lane so
it is part of normal operation rather than an occasional cleanup afterthought.

### Phase 4

Run another longer live autonomy lane on Northstar itself and record where the
new guardrails still fail to hold execution on track.

## Acceptance Criteria

- Northstar doctrine explicitly defines the execution guardrail pack.
- Northstar doctrine and templates explicitly treat generations as long-lived
  sequencing eras.
- `g02` remains the active generation and gains a meaningful second milestone.
- The next promotion and autonomy batches are explicit.

## Stop Conditions

- the work collapses back into abstract doctrine without affecting reusable
  bundle or skill surfaces
- the guardrail pack stays too vague to reject fake completion in practice
- the new lane relies on a fresh generation instead of the corrected `g02`
  posture

## Next Task

Decide the next `g02` improvement slice from the autonomy findings now that
this guardrail and autonomy lane is complete.
