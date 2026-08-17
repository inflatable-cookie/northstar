# Contract Index

Status: active
Owner: repo maintainers
Updated: 2026-08-17

## Coverage Rules

- Every separate contract used by this repo should be listed here.
- Roadmap milestones should reference their governing artifacts directly.
- If a boundary genuinely needs its own contract and none exists yet, mark the
  roadmap blocked and close the gap before execution continues.

## Contract Register

| Contract | Boundary | Owning surface | Dependent roadmaps | Status |
| --- | --- | --- | --- | --- |
| `001-working-rules` | compact delivery grammar, papercuts feedback loop, done-ness, guardrail pack, spec-hygiene rule, currentness-surface rules, autonomy rules, orchestrator/worker boundary, worktree isolation, PR review and merge gates, and the live ready-state/closeout rules for the repo | `docs/`, `bundle-docs/`, `template-bundle/`, `skills/`, `scripts/` | `g01.001` through `g02.027` where directly applicable | active |
| `002-agent-local-paths` | ignored path registry, manual worktree container selection, harness-vs-manual ownership, and nested-agent stop boundary | `AGENTS.md`, `docs/contracts/`, `template-bundle/`, `skills/`, `docs/handoffs/` | orchestrator/worker launches and any manual worktree lane | active |
| `003-agent-instruction-surface` | always-loaded versus scoped/on-demand instruction content, root-file review budget, precedence, and read-only audit boundary | `AGENTS.md`, `docs/contracts/`, `template-bundle/`, `skills/`, `scripts/` | `g02.027` and future consumer adoption | active |

## Missing or Pending Contracts

No active contract gaps are blocking the current `g02` lane.

## Roadmap Readiness

`g01.001`, `g01.002`, `g01.003`, and `g02.001` through `g02.025` are complete.
`g02.026` remains active: cards 075, 076, and 077 are complete, card 078 is
ready but deferred, and the architecture-refocus part of Batch 26.4 is complete.
`g02.027/079` is complete; its operator-provided feedback measurement remains
pending. The generation remains open and no separate contract gap blocks the
current planning lane. Northstar consumes live consumer feedback supplied by the
operator rather than selecting or dispatching a dogfood target.
