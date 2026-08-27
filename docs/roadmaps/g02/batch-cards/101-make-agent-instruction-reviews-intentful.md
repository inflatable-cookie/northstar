# 101 - Make Agent Instruction Reviews Intentful

Status: complete
Owner: repo maintainers
Updated: 2026-08-27
Master spec refs: `docs/specs/028-agent-instruction-surface-optimization.md`
Governing refs: `docs/contracts/003-agent-instruction-surface.md`,
`bundle-docs/research/translation-memos/intentful-agent-instructions.md`
Auto-start next card: no

## Objective

Use operator-provided T3 Code evidence to make Northstar review an
`AGENTS.md` as a human instruction surface: understand its section flow,
preservation intent, tone, and effect on agent judgment before recommending
placement or compression changes.

## Scope

- translate the T3 Code example into Northstar design lessons without copying
  its text or imposing its headings;
- revise contract 003 and the review mode around mental model, intent, voice,
  memorable hazards, completion coverage, and decision usefulness;
- keep the deterministic checker read-only and evidence-led;
- stop treating conversational guidance as presumptively misplaced;
- improve the Northstar source file and copy-ready template as worked examples;
- update the active instruction-surface planning and evidence chain.

## Ready-State Checks

- [x] The operator supplied the source and the desired outcome.
- [x] The existing instruction-surface lane owns the change.
- [x] The work is limited to Northstar docs, skills, templates, and checks.
- [x] No consumer repository or provider integration is in scope.

## Acceptance criteria

- the review maps what each section helps an agent understand or decide before
  assigning a disposition;
- compactness remains a context-cost signal, not a quality score;
- concise explanatory reasoning is allowed when it changes everyday decisions;
- hard boundaries, defaults, taste, and user-overridable guidance are visibly
  distinguished;
- the checker reports mechanical evidence without claiming to judge prose;
- the source and template read naturally while retaining every existing safety,
  authority, workflow, and validation boundary;
- `effigy check:agent-instructions`, `effigy qa:docs`, and `effigy qa` pass.

## Stop conditions

- a rewrite would weaken a current authority or safety boundary;
- the template would prescribe T3 Code's product language or section names;
- a deterministic heuristic is asked to decide tone, meaning, or prose quality;
- the change expands into consumer-repository migration.

## Resolution

- translated the T3 Code example into a source-backed intent model without
  copying its prose or headings;
- revised contract 003, its copy-ready template, and spec 028;
- made the routed review start with a section-intent and whole-file journey map;
- narrowed the deterministic checker to objective evidence and review leads;
- rewrote Northstar's source and starter `AGENTS.md` surfaces as worked examples;
- passed the focused instruction check, docs QA, and full QA.

## Next task

No blocking work remains. Accept further operator-provided usage feedback when
it appears.
