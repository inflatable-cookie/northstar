---
title: Northstar first-principles audit planning delegate handoff
kind: northstar-handoff
handoff_mode: planning-delegate
planning_mode: conversational-discovery
dispatch_authority: orchestrator
promotion_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-09-01
updated: 2026-09-01
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260901-110423-northstar-first-principles-audit.md
base_required: pushed-main
tags: [coordination, handoff, planning, audit, first-principles, pr]
---

## What This Thread Was Doing

The operator wants fresh eyes on Northstar after several weeks of rapid growth.
The working hypothesis is that the system is broadly healthy, but accumulated
doctrine, modes, templates, recorders, checks, and orchestration protocol may
hide gaps, internal contradictions, accidental complexity, weak evidence, or
features whose maintenance cost exceeds their value.

This dispatches one independent first-principles assessment. The delegate owns
discovery and evidence capture for this topic, not repairs, canonical promotion,
or implementation.

## Why It Matters

An internally consistent system can still solve the wrong problem, protect
boundaries users do not need, or preserve complexity that grew incrementally.
The audit should ask what Northstar must accomplish, derive the smallest system
that could accomplish it, and then compare the current repository against that
baseline. Its value is candid judgment, not confirmation that existing docs
agree with one another.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Base commit:** `463d12ef3fe73c441bfdc6c632c469e318d57a4e`
- **Pushed main verification:** local `HEAD` and `origin/main` matched this base
  before the handoff commit
- **Planning-delegate branch:** `planning/northstar-first-principles-audit`
- **Planning-delegate worktree:** Paseo-managed dedicated worktree; accept its
  actual path
- **Required sibling worktree links:** none
- **Topic boundary:** whether Northstar's current product/system shape still
  makes sense from first principles, including value, authority, complexity,
  evidence, usability, maintainability, and omissions
- **Canonical context:** `AGENTS.md`; `README.md`; `docs/vision/`;
  `docs/architecture/`; `docs/contracts/`; active `docs/specs/`;
  `docs/roadmaps/generation-index.md`; `docs/roadmaps/g02/README.md`;
  `bundle-docs/protocol-kernel.md`; `skills/northstar/SKILL.md`; recent
  `docs/logs/`; `PAPERCUTS.md`
- **Named triage packet:**
  `docs/triage/2026-09-01-northstar-first-principles-audit.md`
- **Named research evidence:** none; cite repository paths/commits directly in
  the triage packet, and cite any external source used
- **Allowed write paths:** the named triage packet only
- **Concurrent orchestrator work:** `g02.043/111` is implementing economical
  worker routing. It owns canonical protocol, skill, template, check, log,
  roadmap, and front-door surfaces. Do not edit or depend on its branch.
- **Frontier planning profile:** a current conversational-planning profile from
  a provider different from the originating Sol orchestrator, selected for
  independent synthesis
- **PR base/head:** `main` <- `planning/northstar-first-principles-audit`
- **PR URL:** pending
- **Promotion owner:** orchestrator after accepted review and merge

## Boundaries

- Assess the whole Northstar system at subsystem level. Do not perform an
  exhaustive line-by-line code review or a new Rust/TypeScript quality audit.
- Write only the named triage packet. Do not edit product code, architecture,
  contracts, specs, roadmaps, cards, logs, front doors, skills, templates,
  scripts, or tests.
- Start from first principles. Do not assume a surface is justified merely
  because another Northstar surface references it or a checker enforces it.
- Talk directly with the operator only when intent or experienced value changes
  the assessment. Begin with an independent pass so the operator does not have
  to supply the critique.
- Distinguish evidence, operator-confirmed facts, recommendations, alternatives,
  uncertainties, and questions. Do not turn recommendations into decisions.
- You may spawn bounded read-only research subagents or advisors for repository
  topology, skill/runtime complexity, and consumer-evidence quality. They must
  not edit, create worktrees/branches/PRs, contact the operator, or start nested
  orchestrator/implementation lanes.
- Do not merge. The orchestrator reviews and may merge the assessment packet;
  merge is intake, not promotion.

## Important Context

- **Known decisions:** Northstar aims to be a reusable docs spine and execution
  grammar for agent-led projects; provider adapters are optional transport;
  canonical authority remains in repositories; the operator values planning,
  worker delegation, review, and evidence but wants lower model cost and less
  serial work.
- **Questions worth exploring:**
  - What user problem does Northstar solve that simpler AGENTS/docs conventions
    do not?
  - Which current subsystems directly serve that problem, and which mainly serve
    Northstar's own process?
  - Where has a safeguard become ceremony, duplicated authority, or maintenance
    tax?
  - Which claimed benefits have consumer evidence, and which rest on internal
    dogfood or checker self-consistency?
  - What important failure modes, adoption barriers, or operator experiences are
    under-modelled?
  - If Northstar had to be half its current conceptual size, what would remain?
  - Which pieces should be kept, simplified, retired, or fundamentally
    rethought?
- **Research needs:** inventory the current system by capability, not folder;
  trace each capability to a user outcome and evidence; sample recent consumer
  audits and papercuts; compare the current shape with a credible minimal
  alternative; identify coupling and change amplification.
- **Non-goals:** implementation proposals disguised as decisions, code-quality
  audit, provider/model benchmarking, generic praise, or a demand to rewrite the
  system from scratch without evidence.
- **Mainline drift risk:** the economical-routing worker may merge first. Before
  opening the assessment PR, refresh this branch against current `main`, keep
  the diff limited to the triage packet, and account for any materially relevant
  routing change.
- **Stop conditions:** required judgment depends on private operator history not
  available in repository evidence; the topic expands into another project;
  a canonical edit is needed; an unlisted write path is required; or an
  implementation lane would be necessary.

## Suggested Next Move

Run the planning-worktree preflight, then do an independent repository pass
before asking the operator anything. Build a capability map and a minimal
counterfactual Northstar. Use focused operator questions only to test assumptions
about experienced value. Keep the packet current at meaningful checkpoints.

## Completion Protocol

### Before the conversation

1. Confirm the current checkout is a clean, dedicated, non-`main` registered
   worktree for the planning branch using `git rev-parse --show-toplevel`,
   `git branch --show-current`, `git status --porcelain`, and
   `git worktree list --porcelain`. Accept the launcher-provided worktree even
   when its path or branch differs from this handoff. Do not create another.
2. Fetch `origin`, confirm this handoff exists in the selected `HEAD`, and
   confirm base `463d12ef3fe73c441bfdc6c632c469e318d57a4e` is an ancestor. The
   tracked handoff is canonical; stop if the absolute dispatch copy differs.
3. Required sibling links are `none`.
4. Read `AGENTS.md`, the named canonical context, current triage index, recent
   logs/papercuts, and repository topology. Do not treat this handoff or the
   future triage packet as execution authority.

### During the assessment

- Derive a minimal system from user outcomes before mapping current surfaces.
- Assess at least: product purpose and audience; authority/doc topology;
  planning/execution/review lifecycle; skills and runtime/tooling; language
  quality systems; optional Paseo integration; templates/distribution;
  validation/evidence; consumer adoption; maintenance and cognitive cost.
- For each capability record purpose, evidence, coupling, failure mode, and a
  provisional `keep`, `simplify`, `retire`, or `rethink` disposition.
- Identify the highest-leverage flaws/gaps, over-engineering candidates, missing
  proofs, and decisions that only the operator can make. Rank impact and
  confidence separately.
- Include the strongest case for keeping the current shape, not only criticism.
- Keep any research delegation read-only and reconcile its results yourself.
- Stop on topic expansion, conflicting operator decisions, unlisted writes,
  required implementation, or a canonical change that cannot wait.

### When the planning packet is ready

1. Make the packet useful without private transcript context. Include:
   executive assessment; first-principles baseline; capability/disposition map;
   strengths; flaws and gaps; over-engineering/coupling; missing evidence;
   ranked recommendations; alternatives; operator decisions; unresolved
   questions; and proposed canonical destinations for any later promotion.
2. Refresh against current `main`. Resolve only the packet's factual drift and
   keep the complete branch diff limited to the named triage file.
3. Run `effigy qa:docs` and `git diff --check`.
4. Commit and push the planning branch, then open a PR against current `main`.
   The PR body lists base/head, the one changed file, operator-confirmed facts,
   recommendations, unresolved questions, sources, validation, and proposed
   promotion map.
5. Report the PR URL and exact head. Do not edit canonical surfaces or merge.

### Review, merge, and promotion

The orchestrator reviews the exact PR head for fidelity, evidence quality,
first-principles independence, scope, and clean separation of facts,
recommendations, alternatives, and open decisions. Requested changes wake this
same delegate. An accepted merge only admits the packet to `main`; the
orchestrator and operator separately choose what, if anything, to promote or
implement.
