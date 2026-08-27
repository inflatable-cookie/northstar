# System Inventory

Status: active
Owner: repo maintainers
Updated: 2026-08-25
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
| language quality packs | automation surface | repo maintainers | optional language-specific authoring and audit workflows | source translation memos, specs 031-033, `004-language-quality-pack`, Effigy selectors; Rust v2 recorder boundary promoted from live evidence |
| consumer language-quality profile | contract and policy surface | consumer maintainers | selected assurance profile, toolchain/MSRV, exclusions, deviations, and project architecture | repository-local configuration governed by `004-language-quality-pack` |
| `docs/` | live planning surface | repo maintainers | Northstar's own planning and execution state | all files in this repo-local docs spine |
| `docs/handoffs/` | fresh-thread coordination surface | handoff/orchestrator mode | timestamped takeover notes | handoff contract and templates |
| `docs/triage/` | temporary conversational capture surface | orchestrator/refresh/cleanup modes | timestamped non-authoritative notes | triage contract, refresh lifecycle, cleanup route |
| `scripts/` and `effigy` checks | validation surface | repo maintainers | repo integrity and enforcement hooks | `scripts/check-northstar-repo-contract.rhai`, roadmap evidence requirements |
| root `PAPERCUTS.md` | agent feedback surface | executing agents + repo maintainers | owning repository root | `bundle-docs/papercuts.md`, agent templates, working rules |
| `.agents.local.env` | local path registry | operator + agents | ignored machine-local paths only | `docs/contracts/002-agent-local-paths.md`, `.agents.local.env.example`, `AGENTS.md` |
| orchestrator thread | conversational planning and review surface | repo maintainers / operator | active Northstar lane | `skills/northstar/references/modes/orchestrator.md`, active spec/roadmap/contract |
| direct PR review thread | provider-facing review surface | reviewer + operator | named existing PR | `skills/northstar/references/modes/pr-review.md`, applicable repo authority, provider review record |
| `worker thread/worktree` | bounded implementation surface | worker agent | assigned ready cards and branch | one committed handoff per worker lane under `docs/handoffs/`, explicit worker-mode metadata, batch cards, tests, commits, startup worktree-safety preflight |
| PR review boundary | delivery and merge-control surface | orchestrator + operator | worker branch against prepared base | PR metadata, diff, checks, provider review record (formal review or comment), closeout log |

## Interfaces and Dependencies

| Surface | Upstream | Downstream | Governing artifact | Notes |
| --- | --- | --- | --- | --- |
| Doctrine promotion | `bundle-docs/` | `template-bundle/`, `skills/` | `001-working-rules` | Doctrine should not outrun reusable implementation for long |
| Live repo planning | `docs/vision/`, `docs/architecture/`, `docs/contracts/` | repo changes | `001-working-rules` | Internal repo development now follows Northstar in a compact contract mode |
| Spec-to-roadmap execution | `docs/specs/` | `docs/roadmaps/`, `docs/logs/` | `001-working-rules` | Batch cards are the detailed execution unit |
| Validation loop | roadmap/log state | `effigy qa`, `effigy qa:docs` | `001-working-rules` | Validation evidence is required for closure |
| Papercut feedback | agent execution | maintenance triage and normal planning surfaces | `bundle-docs/papercuts.md`, `001-working-rules` | Notes are captured at encounter time and promoted only after triage |
| Orchestrator planning | operator conversation + canonical planning spine | per-worker handoffs under `docs/handoffs/` | `026-orchestrator-thread-and-worker-pr-loop` | Questions settle intent before cards are marked ready |
| Conversational triage | operator conversation + agent observations | canonical docs or explicit removal | `030-conversational-triage-and-docs-cleanup` | Capture before deep dives; never execute directly from a note |
| Docs cleanup | `/docs` inventory and classification | reworked canonical docs or operator question | `030-conversational-triage-and-docs-cleanup` | Inspect content and references before any move or removal |
| Worker execution | explicit worker-mode handoff + startup worktree-safety preflight + ready cards | worker branch/worktree and evidence | `001-working-rules`, `002-agent-local-paths`, active batch cards | Only an orchestrator-dispatched worker uses the harness worktree or the operator-selected `AGENTS_WORKTREE_CONTAINER_DIR` when its starting context is unsuitable |
| PR review and merge | worker branch/PR | orchestrator verdict + operator-authorised merge | `001-working-rules`, active cards | Review uses diff/check evidence and a provider review record; same-identity GitHub runs use PR comments; merge is separate from PR creation |
| Direct PR review | operator request + existing PR | provider review record + chat summary | `001-working-rules`, applicable PR refs | Every blocking finding is posted on the PR; same-identity fallback uses one `Changes required` comment; no branch mutation or merge authority |
| Rust everyday language quality | scoped instructions + Rust catalogue + consumer profile | current changed tranche and closeout evidence | `031-rust-quality-authoring-and-audit`, `004-language-quality-pack` | Compact Rust projection re-enters at task start and batch exit; TypeScript everyday remains unavailable |
| Explicit language audit and repair | explicit operator request + resolved worktree or repository scope | findings, bounded repairs, deviations, and validation evidence | specs 031-032, `004-language-quality-pack` | Rust and TypeScript use package-specific catalogues, strict profiles, finding-first records, and dirty-state preservation |

## Validation Surfaces

| Area | Evidence required | Owner | Status |
| --- | --- | --- | --- |
| Repo contract integrity | `effigy qa` | repo maintainers | ready |
| Bundle docs integrity | `effigy qa:docs` | repo maintainers | ready |
| Delivery-layer adoption | active docs spine, compact working rules, spec, roadmap, log | repo maintainers | ready |
| Template/skill promotion | copy-ready skill assets, operator docs, roadmap batches, and logs | repo maintainers | ready |
| Papercut loop | root queue, doctrine, templates, skill instruction, and QA coverage | repo maintainers | ready |
| Published skill parity | Skills CLI update path, global install inspection, and source checker | repo maintainers | ready; 120-file configured parity proven |
| Explicit command surface | Nine thin command adapters, canonical router/mode wiring, description budget, and retired-alias checks | repo maintainers | ready; source and installed discovery verified |
| Triage lifecycle | `docs/triage/` anchors, timestamped naming, orchestrator/refresh capture, and cleanup dispositions | repo maintainers | ready; live operator feedback pending |
| Consumer feedback intake | operator-provided live-use evidence and manual triage boundary | repo maintainers + operator | operator-owned |
| Orchestrator mode | per-worker committed handoff under `docs/handoffs/`, fresh worker worktree or safe temporary fallback, startup check, chunk report, PR, provider review record, and closeout evidence | repo maintainers + operator | operator validation complete; longer multi-card evidence pending |
| Model-efficiency comparison | measured role routing, rework, review cycles, and relay burden | repo maintainers | one operator validation measured; broader comparison pending |
| Rust quality production foundation | seven-rule catalogue, seven JSON schemas, two strict checked projections, two routed modes, thin audit adapter, skill-local setup/check tasks, and Cargo-native audit engine | repo maintainers | v2 revision E distributed with exact 120-file configured parity |
| Rust quality prototype | representative rule catalogue, audit and authoring benchmark corpora, blinded subject/coordinator/reviewer packets, projections, deterministic case-local result recorder, result scorer, false-positive and churn measures, context-retention test | repo maintainers + operator | retained evidence infrastructure; strict everyday and explicit-audit tracks eligible; compaction unproven |
| TypeScript/Svelte explicit-audit foundation | nine normative rules, one evaluation-only signal, strict checked projection, conditional Svelte/SvelteKit overlays, thin explicit adapter, and skill-local Rhai setup/record/check tasks | repo maintainers | ready and distributed; explicit-only, agent-owned activation, 93-file combined installed parity proven |
| Rust v2 tool enforcement | skill-shipped Cargo-native engine, managed bootstrap, anchor-based scope, complete unit-rule ledger, three review attestations, structured limitations, mechanical evidence adapters, detector qualification, and exact distribution parity | repo maintainers | complete; cards 094-099 passed revision-E evidence and 120-file configured parity |

## Planning Gaps

- `template-bundle/` does not yet expose every delivery-layer artifact as
  canonical copy-ready surfaces.
- `skills/` do not yet consistently emit master specs, batch cards, and
  autonomy envelopes by default.
- The live repo pilot has not yet proven a longer autonomous multi-card run.
- The first per-worker handoff/PR loop is proven, including same-identity GitHub
  review comments; provider adapter and packet-persistence defaults remain open.
- The refresh, orchestrator, cleanup, Rust audit, and TypeScript/Svelte audit
  routes are distributed to the installed skill copy; the nine-command surface
  now passes source and installed parity verification.
- Atlas has a discovery-first contract now, but existing-project behavioral
  validation is still open because earlier runs were prescriptive rather than
  operator-guided.
- The Rust quality pack has a seven-rule catalogue, ten-case audit corpus, five
  bounded authoring tasks, isolated subject and blind-review paths, exact
  finding locality, and deterministic case-local result assembly. Revision F
  makes everyday authoring eligible and rejects combined as the default for
  lack of paired improvement. Revision M makes strict explicit audit eligible
  at `3/3`. Strict unsafe repair remains report-only. Catalogue review and
  contract promotion are complete. Production K passes explicit audit 3/3 and
  production M passes everyday authoring 3/3; an observable compaction boundary
  still precedes stress claims.
- Contract `004-language-quality-pack` remains active. Roadmap `g02.030` and
  cards 083 through 088 are complete: the runtime boundary, shared production
  foundation, both routed workflows, deterministic recording, production
  evidence, copy-ready setup, and installed distribution are proven.
- Roadmap `g02.031` and cards 089 through 093 are complete. Revision S passes
  `3/3` production subjects and blind reviewers; the exact explicit-only
  TypeScript/Svelte payload is distributed with 93-file source/install parity.
