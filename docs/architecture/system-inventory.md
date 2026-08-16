# System Inventory

Status: active
Owner: repo maintainers
Updated: 2026-08-16
Architecture refs: docs/architecture/system-architecture.md

## Coverage Summary

Planning coverage is partial but now live. The repo has a standard Northstar
`docs/` spine, compact working rules, a master spec, a first batch card, and
an active roadmap milestone. The main remaining gap is promotion of the
delivery layer from live repo pilot into the reusable template bundle and
skills.

## In-Scope System Elements

| Element | Type | Owner | Authority | Planned artifacts |
| --- | --- | --- | --- | --- |
| `bundle-docs/` | doctrine surface | repo maintainers | reusable Northstar doctrine | `system-architecture.md`, `docs/contracts/001-working-rules.md` |
| `template-bundle/` | product artifact | repo maintainers | copy-ready downstream docs bundle | `docs/specs/archive/001-northstar-delivery-layer.md`, `docs/roadmaps/g01/001-enact-northstar-on-northstar.md` |
| `skills/` | automation surface | repo maintainers | installable agent workflows and published distribution | `docs/contracts/001-working-rules.md`, `bundle-docs/skills/README.md`, `scripts/check-northstar-skill-install.rhai` |
| `docs/` | live planning surface | repo maintainers | Northstar's own planning and execution state | all files in this repo-local docs spine |
| `scripts/` and `effigy` checks | validation surface | repo maintainers | repo integrity and enforcement hooks | `scripts/check-northstar-repo-contract.rhai`, roadmap evidence requirements |
| root `PAPERCUTS.md` | agent feedback surface | executing agents + repo maintainers | owning repository root | `bundle-docs/papercuts.md`, agent templates, working rules |
| orchestrator thread | conversational planning and review surface | repo maintainers / operator | active Northstar lane | `skills/northstar/references/modes/orchestrator.md`, active spec/roadmap/contract |
| worker thread/worktree | bounded implementation surface | worker agent | assigned ready cards and branch | single committed run file, `AGENTS.md`, batch cards, tests, commits |
| PR review boundary | delivery and merge-control surface | orchestrator + operator | worker branch against prepared base | PR metadata, diff, checks, review verdict, closeout log |

## Interfaces and Dependencies

| Surface | Upstream | Downstream | Governing artifact | Notes |
| --- | --- | --- | --- | --- |
| Doctrine promotion | `bundle-docs/` | `template-bundle/`, `skills/` | `001-working-rules` | Doctrine should not outrun reusable implementation for long |
| Live repo planning | `docs/vision/`, `docs/architecture/`, `docs/contracts/` | repo changes | `001-working-rules` | Internal repo development now follows Northstar in a compact contract mode |
| Spec-to-roadmap execution | `docs/specs/` | `docs/roadmaps/`, `docs/logs/` | `001-working-rules` | Batch cards are the detailed execution unit |
| Validation loop | roadmap/log state | `effigy qa`, `effigy qa:docs` | `001-working-rules` | Validation evidence is required for closure |
| Papercut feedback | agent execution | maintenance triage and normal planning surfaces | `bundle-docs/papercuts.md`, `001-working-rules` | Notes are captured at encounter time and promoted only after triage |
| Orchestrator planning | operator conversation + canonical planning spine | single pushed run-file handoff | `026-orchestrator-thread-and-worker-pr-loop` | Questions settle intent before cards are marked ready |
| Worker execution | single run-file path + ready cards | worker branch/worktree and evidence | `001-working-rules`, active batch cards | Worker stops rather than infers missing behavior |
| PR review and merge | worker branch/PR | orchestrator verdict + operator-authorised merge | `001-working-rules`, active cards | Review uses diff/check evidence; merge is separate from PR creation |

## Validation Surfaces

| Area | Evidence required | Owner | Status |
| --- | --- | --- | --- |
| Repo contract integrity | `effigy qa` | repo maintainers | ready |
| Bundle docs integrity | `effigy qa:docs` | repo maintainers | ready |
| Delivery-layer adoption | active docs spine, compact working rules, spec, roadmap, log | repo maintainers | ready |
| Template/skill promotion | follow-on roadmap batches and logs | repo maintainers | pending |
| Papercut loop | root queue, doctrine, templates, skill instruction, and QA coverage | repo maintainers | ready |
| Published skill parity | Skills CLI update path, global install inspection, and source checker | repo maintainers | ready; 32-file parity proven |
| Consumer papercut proof | real consumer queue entry and manual triage boundary | repo maintainers + consumer owner | observed |
| Orchestrator mode | single committed run file, fresh worker worktree, chunk report, PR, review, and closeout evidence | repo maintainers + operator | designed; dogfood pending |
| Model-efficiency comparison | measured role routing, rework, review cycles, and relay burden | repo maintainers | pending dogfood |

## Planning Gaps

- `template-bundle/` does not yet expose every delivery-layer artifact as
  canonical copy-ready surfaces.
- `skills/` do not yet consistently emit master specs, batch cards, and
  autonomy envelopes by default.
- The live repo pilot has not yet proven a longer autonomous multi-card run.
- The single-file run handoff and PR loop have not yet been proven in a real fresh
  worker thread/worktree; adapter and persistence defaults remain open.
- The new source skill is distributed to the installed skill copy and the
  32-file parity check now passes.
