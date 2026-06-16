# Product Guardrails

**Type: REQUIRED** (strict posture) -- Define execution constraints for strict-posture repos.

Status: draft
Owner: <owner>
Updated: YYYY-MM-DD
Vision refs: <docs/vision/001-...>

## Operator Experience

- keep the operator path clear and direct; do not require unnecessary navigation
  or invented side flows just to complete normal work
- prefer repo-owned facts, active roadmap state, and current logs over generic
  process theatre

## UI and Workflow Simplicity

- do not add UI or interaction complexity unless the governing refs make the
  user need explicit
- prefer simple, readable, maintainable flows over decorative sophistication or
  surface-area growth

## Anti-Fake-Work Rules

- do not call mockups, placeholders, fake adapters, or token substrate work
  "done" when the batch was supposed to land working behavior
- do not leave disconnected gesture work behind and imply the real path now
  exists
- if a seam is still scaffolded or unproven, name it explicitly as incomplete

## Delivery Expectations

- prefer integrated end-to-end follow-through over convenient partial stopping
  points
- update canonical refs, roadmap state, and logs so they match reality before
  claiming closure
- completion requires real evidence, not only plausible prose

## Autonomy Expectations

- agents may continue only across ready cards inside the same valid lane with
  current governing refs
- agents must stop on planning gaps, contradictions, failed validation, missing
  authority, or user-facing ambiguity that exceeds these guardrails

## Specs Posture

- use `specs/` while a material change is still being shaped
- once durable outcomes are accepted, promote structure into architecture and
  behavior or policy into contracts
- keep specs only while they still help the active lane or provide useful
  planning history; archive or remove them when they no longer add value
