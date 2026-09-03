# Review Generic Language Discovery

Date: 2026-09-03
Roadmap: `g02.048`
Cards: `122`, `120`
Status: card 122 merged; card 120 ready

## Outcome

PR 28 passed exact-head review at
`183b55b9cd86f1dfa2975c4e753b6ca747d60850` and squash-merged as
`ddaae0d433b7654424c6a996646ec35178227c66`.

The first review rejected three gaps: malformed selection queries were
accepted, selection results omitted immutable source identity, and
registry/manifest drift could reach acquisition before rejection. The retained
worker repaired all three on the same branch.

Independent re-review proved that malformed, duplicate, mixed, and
shape-invalid flags fail closed; JSON selection returns commit, tree, and
manifest identity; and discovery drift stops before self-check, receipt, or
lifecycle mutation. Focused package checks, docs QA, full QA, and the
base-to-head diff check passed. GitHub exposed no separate branch checks; the
repository validation board was the merge gate.

## Readiness Refresh

Card 120's remaining readiness check is satisfied. Registry `1.5.0` selects
one immutable official entry from explicit intent or an exact activation
marker without package-specific core code. Detection refusal, trust checks,
offline routing, revocation, and the bounded fallback remain intact.

The frozen 95-file deletion inventory and 19 integration surfaces remain the
authority for the reduction. Card 120 is ready; no deletion started during
this closeout.

## Next Task

Dispatch one card-120 implementation worker. Do not start a new language or
Sentrux integration.
