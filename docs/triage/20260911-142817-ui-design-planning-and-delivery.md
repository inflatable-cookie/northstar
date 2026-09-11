# UI design planning and delivery

Status: open; decision-ready
Owner: Northstar Chatterbox
Source: operator report and UI design workflow research, 2026-09-11

## Issue

Northstar UI handoffs can bound implementation without settling the user
workflow, information hierarchy, state model, or presentation direction. The
worker makes those decisions during coding, and conventional PR review finds
weak design after the expensive part of the loop.

## Research result

The primary repair is a Chatterbox-owned UI design brief before dispatch,
scaled as refinement, workflow change, or substantial redesign. Substantial
work should use a planning-only concept or prototype checkpoint. A
provider-neutral UI skill should then guide implementation and independent
exact-head rendered review.

Full evidence and proposed fields are in
`bundle-docs/research/translation-memos/ui-design-planning-and-delivery.md`.

## Decisions needed

- Whether the skill remains provider-neutral with external tools optional.
- Whether substantial UI work requires both an approved brief and a concept or
  prototype checkpoint.
- Whether the canonical task or spec owns the full brief and the handoff carries
  a self-contained execution copy.

After those decisions, promote a strict spec and compile one implementation
task. Do not implement the skill or alter delivery contracts from this triage
note.

