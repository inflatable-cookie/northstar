# 001 - Northstar Delivery Vision

Status: active
Owner: repo maintainers
Updated: 2026-09-01

## Long-Term Outcome

Northstar should let operators run complex software projects with agents that
stay inside real planning, produce real outcomes, and need far less thread
babysitting than they do today.

## Target Operating Model

- Projects define direction, architecture, contracts, specs, batch cards, and
  evidence in a single coherent system.
- Agents do not improvise missing behavior when planning is incomplete.
- Agents do not claim completion for mockups, placeholders, or token partial
  work.
- Operators do not need to repeatedly restate guardrails in ordinary
  conversation.
- Ready work can continue for longer stretches under pre-authorized autonomy
  rules.
- Operators can adopt the core planning and execution system without also
  installing language-specific quality tooling they do not use.

## Constraints

- The public skill surface should stay small and reliable.
- Northstar must remain general-purpose across operators, repositories,
  harnesses, and local layouts. One operator's convenience may inform evidence
  but must not become a reusable assumption.
- The docs system must remain human-readable and copy-ready.
- The repo must use the same doctrine it promotes to other projects.
- Stricter delivery rules should reduce drift without turning Northstar into
  ceremony for its own sake.

## Target Envelopes

- Long-running work should move through clearly bounded batch cards rather than
  loosely interpreted milestone prose.
- User-facing complexity should be deliberately constrained, not treated as a
  default sign of sophistication.
- Completion should be based on evidence and integration, not narrative.

## Non-Goals

- Turning every small change into a heavyweight planning exercise.
- Replacing human judgment with blind automation.
- Growing the public skill surface by adding a separate skill for every narrow
  mode.
- Growing the root payload indefinitely as new language-quality implementations
  are added. Compatible language packages should remain optional modules under
  a shared core protocol.

## Next Task

Translate this vision into delivery-layer contracts, master specs, and active
roadmap work so Northstar itself becomes the first live pilot of the stricter
framework.
