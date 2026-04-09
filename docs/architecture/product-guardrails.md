# Product Guardrails

Status: active
Owner: repo maintainers
Updated: 2026-04-08
Vision refs: docs/vision/001-northstar-delivery-vision.md

## Operator Experience

- Prefer clarity over cleverness in docs, prompts, and skills.
- Keep front doors short and human-readable.
- Do not require operators to remember hidden ritual phrasing for ordinary
  thread starts.

## UI and Workflow Simplicity

- Do not add visual or process complexity unless the product need is explicit.
- Treat "more elaborate" as suspicious by default, not automatically better.
- Favor strong defaults and constrained paths over sprawling option surfaces.

## Anti-Fake-Work Rules

- Do not treat mockups, placeholders, or partial stubs as completed delivery.
- Do not claim a lane is complete while required references, validation, or
  integration are still missing.
- Do not replace missing planning with guessed behavior.

## Delivery Expectations

- Material work should use a master spec and batch cards.
- Completion should be evidenced in logs, not only described in chat.
- Roadmap milestones should sequence real execution work, not just summarize
  intent.

## Autonomy Expectations

- Agents should continue across ready batch cards without needing repeated
  operator prompts when the execution policy allows it.
- Agents should stop immediately on planning gaps, contract ambiguity, failed
  validation, or unresolved design uncertainty.

## Next Task

Keep these guardrails reflected in the repo's contracts, specs, and skills so
they remain enforceable rather than aspirational.
