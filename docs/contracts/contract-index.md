# Contract Index

Status: active
Owner: repo maintainers
Updated: 2026-09-01

## Coverage Rules

- Every separate contract used by this repo should be listed here.
- Roadmap milestones should reference their governing artifacts directly.
- If a boundary genuinely needs its own contract and none exists yet, mark the
  roadmap blocked and close the gap before execution continues.

## Contract Register

| Contract | Boundary | Owning surface | Dependent roadmaps | Status |
| --- | --- | --- | --- | --- |
| `001-working-rules` | compact delivery grammar, structural-not-editorial validation, papercuts feedback loop, triage capture/cleanup, done-ness, guardrail pack, spec-hygiene rule, currentness-surface rules, autonomy rules, orchestrator/worker, planning-delegate, and documentation-projection boundaries, worktree isolation, PR review and merge gates, and the live ready-state/closeout rules for the repo | `docs/`, `bundle-docs/`, `template-bundle/`, `skills/`, `scripts/` | `g01.001` through `g02.045` where directly applicable | active |
| `002-agent-local-paths` | ignored path registry, manual worktree container selection, harness-vs-manual ownership, and nested-agent stop boundary | `AGENTS.md`, `docs/contracts/`, `template-bundle/`, `skills/`, `docs/handoffs/` | orchestrator-owned implementation-worker and planning-delegate launches, plus any manual worktree lane | active |
| `003-agent-instruction-surface` | always-loaded versus scoped/on-demand instruction content, root-file review budget, precedence, and read-only audit boundary | `AGENTS.md`, `docs/contracts/`, `template-bundle/`, `skills/`, `scripts/` | `g02.027` and future consumer adoption | active |
| `004-language-quality-pack` | shared language-package behavior: catalogue, conditional framework overlays, independently gated everyday and explicit-audit workflows, scope resolution, remediation authority, assurance profiles, deviations, and completion evidence | `docs/contracts/`, optional language packages, current embedded catalogues, Effigy selectors, consumer profiles | `g02.030` (complete), `g02.031` (complete), `g02.032` (complete), spec 034 extraction planning | active; current embedded implementation pending modular extraction design |

## Roadmap Readiness

`g01.001`, `g01.002`, `g01.003`, and `g02.001` through `g02.025` are complete.
Roadmap `g02.040` is complete through card 108: the planning-delegate boundary,
safe sibling-link preflight, worker-mode distinction, operator-confirmation
authority, and separate merge/promotion lifecycle passed final review and
validation. No live planning-delegate or Paseo dogfood was performed. Roadmap
`g02.038` is complete: the installed external skill task and a real Figmatic
Paseo managed-worktree lifecycle passed.
`g02.026` remains active: cards 075, 076, and 077 are complete, card 078 is
ready but deferred, and the architecture-refocus and reframe parts of Batch 26.4
are complete.
`g02.027/079` is complete; its operator-provided feedback measurement remains
pending. The generation remains open and no separate contract gap blocks that
existing planning lane. The Rust quality catalogue review and contract gate
have passed. Roadmap `g02.030` is complete through card 088; production
revisions K and M pass both required tracks and the 76-file published install
matches source. Northstar consumes live consumer feedback
supplied by the operator rather than selecting or dispatching a dogfood target.
TypeScript/Svelte explicit-audit research now supports nine normative rules and
one evaluation-only signal. Roadmap `g02.031` is complete: cards 089-093 froze
the boundary, promoted and implemented the explicit route, passed revision-S
production evidence, and proved exact 93-file source/install parity.
Everyday TypeScript authoring and package-context toolchain/testing rules remain
unavailable.
Operator-provided Convergence evidence promoted a Rust v2 strengthening
boundary into contract 004: worktree scope is anchor-based, every applicable
unit-rule pair and review dimension requires evidence, and degraded or unrun
evidence remains visible. Roadmap `g02.032` is complete: card 094 froze a
skill-shipped Cargo-native engine after rejecting the cross-root Effigy task
split. Card 095 now implements the Cargo-native scope, complete ledger,
attestations, policy snapshots, mutation attribution, and deterministic report
in source. Cards 096-099 added immutable evidence, qualified finite detectors,
passed revision-E production evidence, and distributed the exact 120-file
payload.

Roadmap `g02.045` is complete through card 113's implementation, review
corrections, and fixture proof. It reduces prose-coupled and
historical-inventory assertions while retaining structural path, current
authority, machine-contract, link, parity, readiness, command-surface, and
install checks; corrected exact-head review is pending. Spec 034 separately
plans modular language packages and is not ready for implementation.
