# Implement the Non-Mutating Reframe Route

Date: 2026-08-17 08:27 BST
Status: implemented and validated
Milestone: `g02.026`, Batch 26.4

## Decision

Northstar now exposes a bounded `northstar reframe` route. It is a communication
aid for making the current operator request clearer in project language without
advancing the work.

## Behaviour

The route:

- restates the current request faithfully;
- separates explicit requests or decisions from unresolved scope, uncertainty,
  and authority;
- states what the reframe does not authorize;
- suggests a route only when the request already makes one evident;
- uses neutral language when no project-language surface is available;
- remains read-only and non-mutating by default.

It must not invent facts, turn preferences into decisions, add acceptance
criteria, widen scope, create a plan, imply approval, or write a map, decision
record, spec, roadmap, handoff, papercut, or code change.

## Surfaces changed

- `skills/northstar/references/modes/pre-execution-discovery.md`
- `skills/northstar/references/router.md`
- `skills/northstar/SKILL.md`
- `skills/northstar/agents/openai.yaml`
- `bundle-docs/operators/operator-quick-start.md`
- `scripts/lib/northstar-repo-contract-data.rhai`
- active spec 027 and milestone 026
- current roadmap, contract, batch-card, and recovery-log front doors

## Boundary

This route does not alter the operator-owned live dogfooding boundary. Consumer
execution remains outside Northstar's loop; feedback supplied by the operator
remains the evidence Northstar may promote through normal planning surfaces.

## Validation

- `effigy qa` — passed.
- `effigy qa:docs` — passed.
- `effigy check:repo-contract` — passed.
- `effigy check:readiness-map` — passed; 0 maps and all 5 fixtures passed.
- `effigy check:agent-instructions` — passed; advisory audit complete with both
  Claude bridges valid.
- `effigy graph status --refresh` — current; 451 files, 4,519 symbols, 5,128
  edges, stale 0.
- `effigy doctor` — passed; 19 OK, 0 warnings, 0 errors.
- Installed skill parity — passed; 38 files in both installed copies.
- `git diff --check` — passed.
