# 080 - Define Triage And Docs Cleanup Contract

Status: complete
Owner: repo maintainers
Updated: 2026-08-19
Master spec refs: `docs/specs/030-conversational-triage-and-docs-cleanup.md`
Governing refs: `docs/contracts/001-working-rules.md`, `bundle-docs/sections/09-standard-docs-spine.md`
Auto-start next card: yes

## Ready-State Checks

- [x] Objective is bounded and operator intent is explicit.
- [x] Governing refs and acceptance are current.
- [x] The note lifecycle and cleanup uncertainty boundary are settled.
- [x] Validation and evidence requirements are explicit.

## Objective

Define the standard triage buffer, handoff-matched filename format, lifecycle,
conversation checkpoint rule, refresh management rule, and safe cleanup
classification/ask-before-uncertain behavior.

## Scope

- live and template working-rules contracts;
- protocol-kernel and standard-spine doctrine;
- cleanup route authority and deletion boundary.

## Acceptance Criteria

- [x] Triage is temporary, flexible Markdown and not execution authority.
- [x] Every note has a promote, merge, open, or remove disposition.
- [x] Cleanup inspects before reworking and asks when evidence is insufficient.

## Validation

- manual contract review;
- references from the spec, milestone, and skill modes are present.

## Evidence

The contract was applied in the same implementation batch and reviewed against
the user request before the copy-ready surfaces were changed.

## Stop Conditions

- stop if the protocol requires a rigid note schema;
- stop if cleanup can only be made safe by blind deletion or silent inference.

## Next Task

Apply the contract to the skill, docs, templates, and checks.
