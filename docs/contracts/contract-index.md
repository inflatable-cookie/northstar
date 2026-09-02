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
| `001-working-rules` | compact delivery grammar, structural-not-editorial validation, papercuts feedback loop, triage capture/cleanup, done-ness, guardrail pack, spec-hygiene rule, currentness-surface rules, autonomy rules, diversified model routing, orchestrator/worker, planning-delegate, orchestrator-continuation, and documentation-projection boundaries, worktree isolation, PR review and merge gates, and the live ready-state/closeout rules for the repo | `docs/`, `bundle-docs/`, `template-bundle/`, `skills/`, `scripts/` | `g01.001` through `g02.047` where directly applicable | active |
| `002-agent-local-paths` | ignored path registry, manual worktree container selection, harness-vs-manual ownership, and nested-agent stop boundary | `AGENTS.md`, `docs/contracts/`, `template-bundle/`, `skills/`, `docs/handoffs/` | orchestrator-owned implementation-worker and planning-delegate launches, plus any manual worktree lane | active |
| `003-agent-instruction-surface` | always-loaded versus scoped/on-demand instruction content, root-file review budget, precedence, and read-only audit boundary | `AGENTS.md`, `docs/contracts/`, `template-bundle/`, `skills/`, `scripts/` | `g02.027` and future consumer adoption | active |
| `004-language-quality-pack` | optional package identity, digest framing, discovery, acquisition, operator-owned trust/lifecycle state and migration plus shared catalogue, workflow, scope, remediation, profile, deviation, and evidence behavior | `docs/contracts/`, Northstar core package protocol, optional language packages, current embedded catalogues, Effigy adapters, consumer profiles | `g02.030` (complete), `g02.031` (complete), `g02.032` (complete), `g02.048` (active) | active; card 117 complete, card 118 package-source worker in flight |

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
install checks. PR 18 merged at `1f6647a` after corrected exact-head review.
Roadmap `g02.046` is complete through PR 19 at `b99d19c`. Roadmap `g02.047` is
complete through PR 20 at `08ad810`. Spec 034's modular package design is
promoted into architecture and contract 004. Roadmap `g02.048` is active: card
116 merged through PR 21 at `eaeac88`; card 117 proved the generic lifecycle
against the promoted host-protocol decisions with all review-oracle rows
falsified and merged through PR 22 at `75db6f5`. Card 118's source repository
is bootstrapped and its package-source worker is in flight; the TypeScript
identity and Jetstream canary remain fixed. Cards 119-120 stay planned behind
it.
