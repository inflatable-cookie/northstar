# Contract Index

Status: active
Owner: repo maintainers
Updated: 2026-09-05

## Coverage Rules

- Every separate contract used by this repo should be listed here.
- Roadmap milestones should reference their governing artifacts directly.
- If a boundary genuinely needs its own contract and none exists yet, mark the
  roadmap blocked and close the gap before execution continues.

## Contract Register

| Contract | Boundary | Owning surface | Dependent roadmaps | Status |
| --- | --- | --- | --- | --- |
| `001-working-rules` | compact delivery grammar, structural-not-editorial validation, papercuts feedback loop, triage capture/cleanup, done-ness, guardrail pack, spec-hygiene rule, planning artifact lifecycle classes, prune triggers, generation closure, preservation oracle, currentness-surface rules, autonomy rules, diversified model routing, orchestrator/worker, planning-delegate, orchestrator-continuation, documentation-projection, and independent-review-child boundaries, worktree isolation, PR review and merge gates, and the live ready-state/closeout rules for the repo | `docs/`, `bundle-docs/`, `template-bundle/`, `skills/`, `scripts/` | `g01.001` through `g03.001` where directly applicable | active |
| `002-agent-local-paths` | ignored path registry, manual worktree container selection, harness-vs-manual ownership, and nested-agent stop boundary | `AGENTS.md`, `docs/contracts/`, `template-bundle/`, `skills/`, `docs/handoffs/` | orchestrator-owned implementation-worker and planning-delegate launches, plus any manual worktree lane | active |
| `003-agent-instruction-surface` | always-loaded versus scoped/on-demand instruction content, root-file review budget, precedence, and read-only audit boundary | `AGENTS.md`, `docs/contracts/`, `template-bundle/`, `skills/`, `scripts/` | current agent-instruction changes and consumer adoption | active |
| `004-language-quality-pack` | optional package identity, digest framing, discovery, acquisition, operator-owned trust/lifecycle state and migration plus shared catalogue, workflow, scope, remediation, profile, deviation, and evidence behavior | `docs/contracts/`, Northstar core package protocol, optional language packages, external package catalogues, Effigy adapters, consumer profiles | current language-package changes and consumer adoption | active |

## Current readiness

Contract coverage supports `g03.001`'s remaining lifecycle retirement correction
on card 132. The milestone stays open until promoted-spec callers and fixtures
stop depending on spec 038 and its retirement passes preservation review.
Closed `g01` and `g02` work has no execution authority here; selected evidence
and deferred dispositions live in their roll-ups. The active generation's
watchlist retains unresolved operator feedback.
