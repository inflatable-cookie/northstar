# 032 - TypeScript And Svelte Explicit Audit

Status: retired-in-place — promoted and distributed
Owner: repo maintainers
Created: 2026-08-26
Updated: 2026-08-26
Depends on: `docs/contracts/003-agent-instruction-surface.md`,
`docs/contracts/004-language-quality-pack.md`
Research ref: `bundle-docs/research/translation-memos/typescript-quality-and-svelte-overlay.md`
Prototype ref: `bundle-docs/research/prototypes/typescript-quality/README.md`
Promotion targets: `docs/architecture/system-architecture.md`, TypeScript
quality catalogue, explicit audit mode, thin command adapter, skill-local
Effigy selectors, and installed-skill parity
Roadmap ref: `docs/roadmaps/g02/031-ship-typescript-svelte-explicit-audit.md`

## Problem

Northstar has a production Rust quality pack but no equivalent explicit audit
for TypeScript repositories or mixed TypeScript/Svelte/SvelteKit workspaces.
The research pack now has repeatable finding and repair evidence for nine
source-local rules. Its everyday projection failed independent no-regression
testing and must not enter normal coding context.

## Goal

Ship one explicit-only strict TypeScript quality route that:

- discovers root and nested owning packages rather than assuming TypeScript is
  at repository root;
- resolves Svelte and SvelteKit overlays from dependency, version, semantic
  surface, package ownership, and path evidence;
- records findings before bounded repair and preserves dirty user state;
- uses the nine promoted normative rules and one evaluation-only slop signal;
- delegates compiler, framework, lint, and test execution to repository-owned
  selectors while preserving diagnostics and degraded evidence;
- installs any missing activation itself without requiring a human template
  copy;
- remains one routed mode inside the existing Northstar skill.

## Supported boundary

The initial production candidate is `strict` plus explicit audit-and-repair.
Everyday TypeScript authoring, combined mode, ordinary/high-assurance profiles,
and observable compaction resilience are unavailable.

The normative base rules are `TS-READ-001`, `TS-EVIDENCE-001`,
`TS-BOUNDARY-001`, `TS-ASYNC-001`, `TS-ERR-001`, and `TS-ARCH-001`. Svelte adds
`SVELTE-REACT-001` and `SVELTE-A11Y-001`; SvelteKit adds
`SVELTE-SSR-001`. `TS-SLOP-001` is evaluation-only/report-only.

Toolchain and testing rules remain outside the production catalogue until
package-backed research resolves their evidence and portability boundaries.

## Production shape

The pack stays under `skills/northstar/`:

- one checked catalogue and strict audit projection under
  `references/language-quality/typescript/`;
- one on-demand `typescript-quality-audit` mode;
- one thin explicit command adapter;
- skill-local setup, recorder, package check, and focused self-tests;
- copy-ready profile, deviations, and scoped activation templates.

The router names the mode but loads no catalogue or audit procedure unless the
operator explicitly requests a TypeScript/Svelte quality audit. No TypeScript
content enters everyday Northstar context.

## Scope and overlays

Worktree scope covers staged, unstaged, and relevant untracked source,
manifests, configs, tests, and directly owned documentation relative to
`HEAD`. Repository scope covers every declared owning package and semantic
framework surface. Repair extensions are finding-local and reported.

Root package metadata and declared workspaces establish ownership. Undeclared
nested packages are reported for policy resolution. Generated, vendored,
fixture, example, dependency, and build output is excluded only through
repository policy or unambiguous ownership evidence.

Svelte activation requires a compatible declared dependency plus owned Svelte
source. SvelteKit activation additionally requires owned routes, hooks, server
modules, or other Kit semantics. Version differences are reported; the pack
does not force framework migration.

## Runtime and evidence boundary

Setup, scope records, finding records, and deterministic finalization must not
require a consumer Node/Bun/package-manager runtime. Prefer the existing
skill-local Effigy/Rhai substrate unless the production-boundary card proves a
smaller portable option.

Repository-owned compiler, Svelte checker, lint, and test commands are evidence
inputs. Record the selector, environment, status, diagnostics, and startup or
collection failures. Missing or failed tooling becomes degraded evidence, not
a false pass and not permission to install dependencies or rewrite config.

## Repair and authority

Every normative rule defaults to `review_required`; slop remains
`report_only`. A repair must bind exact findings, owned files, protected
behavior, and validation before mutation. Public API breaks, dependency or
toolchain changes, framework upgrades, module-mode or strictness changes, and
architecture-policy decisions require existing repository authority or an
operator decision.

Case-local finalization rejects cross-unit evidence, unattributed changes,
mutation without a recorded repair plan, and changes to excluded pre-existing
dirty files.

## Evidence gate

Research promotion rests on one corrected precision review plus three isolated
repair subject/reviewer pairs: 27/27 normative claims, 96/96 review dimensions,
and 24/24 accepted repairs. This supports implementation planning, not
distribution.

Before distribution, a fresh production-payload cohort must pass three isolated
explicit-audit replicates with exact primary-defect recall and locality, no
findings outside the frozen primary-plus-admissible-corroborating set, protected-
behavior and dirty-state preservation, bounded churn, correct repair authority,
and blind review. A corroborating label is admissible only when the answer key
names its same-file primary prerequisite; it is optional and cannot replace
that primary finding. Evaluation-only candidate identity and count are recorded
as measurement, not compared to an answer-key total and not used as a pass/fail
gate. An unknown evaluation rule or evaluation-only mutation still fails the
authority gate. Every discovery-time input must be owned exactly once. A
required generated audit output may also be owned when it exists at recorder
initialization; its creation order is not a conformance signal. Known Effigy
graph/report runtime state is tooling, while finalized audit records remain
evidence. Revision S passed this gate: `30/30` primary findings, exact normative
precision, `96/96` blind dimensions, and `24/24` accepted repairs across three
fresh subject/reviewer pairs. The exact payload now matches the configured
global install across 93 files.

## Non-goals

- no everyday TypeScript or Svelte activation;
- no separate Svelte skill or duplicated base rules;
- no blanket lint preset, automatic formatter sweep, package installation, or
  framework/compiler migration;
- no production `TS-TOOLCHAIN-001`, `TS-TEST-001`, or `SVELTE-TEST-001` claim;
- no slop-only mutation, certification, NASA-compliance, or safety-case claim;
- no consumer repository mutation or release operation from this lane.

## Lane runway

- freeze the portable production boundary;
- promote the checked explicit-only catalogue;
- implement setup, recording, routing, and the thin adapter;
- [x] run fresh production evidence;
- [x] distribute after source/install parity and full QA.

Cards 089-093 are complete. The explicit-only TypeScript/Svelte audit is
distributed inside the single routed Northstar skill. Everyday activation and
the deferred toolchain/testing rules remain unavailable. Further work starts
only from operator-provided live-use evidence or a separately approved research
lane.
