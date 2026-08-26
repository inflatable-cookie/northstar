# 091 - Add TypeScript And Svelte Explicit Audit

Status: complete
Owner: repo maintainers
Updated: 2026-08-26
Master spec refs: `docs/specs/032-typescript-svelte-explicit-audit.md`
Roadmap ref: `g02.031`
Governing refs: `docs/contracts/004-language-quality-pack.md`, cards 089-090
Auto-start next card: no

## Objective

Implement the explicit-only TypeScript/Svelte audit route, agent-owned setup,
case-local recorder, and thin command adapter over the checked catalogue.

## Scope

- Northstar router and one on-demand audit mode;
- thin explicit command adapter with implicit invocation disabled;
- mixed-workspace setup/discovery and strict profile resolution;
- finding-first worktree/repository audit, bounded repair waves, degraded tool
  evidence, and deterministic finalization;
- focused package, setup, recorder, routing, and negative-path tests;
- no everyday activation or distribution claim.

## Acceptance criteria

- [x] ordinary coding cannot activate the route;
- [x] setup works at the narrowest owning scope and preserves valid state;
- [x] Svelte/SvelteKit overlays resolve only where owned and applicable;
- [x] findings precede repair and unauthorized mutation is rejected;
- [x] repository-native evidence preserves diagnostics and failures;
- [x] command, route, catalogue, and selector inventories stay mechanically
  aligned.

## Validation

Run focused setup/recorder/router tests, command-surface checks, full QA, and
diff validation.

## Evidence

Record supported paths, negative cases, selector inventory, changed files,
hashes, and remaining production-evidence limits.

## Stop conditions

- stop if implementation diverges from cards 089-090;
- stop on implicit activation, hidden dependency installation, or dirty-state
  loss;
- do not distribute or claim production validity in this card.

## Completion evidence

- `bundle-docs/research/prototypes/typescript-quality/production-route-report-2026-08-26-m.md`
- focused source and copied-skill selectors with `PATH=/bin`

## Next task

Execute card 092. Freeze the copied production payload and run three fresh
isolated subjects plus blind reviewers without tuning the cohort.
