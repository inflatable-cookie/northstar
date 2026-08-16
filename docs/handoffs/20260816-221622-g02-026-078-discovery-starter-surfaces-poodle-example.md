---
title: g02.026/078 discovery starter surfaces and Poodle example worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-08-16
updated: 2026-08-16
handoff_path: docs/handoffs/20260816-221622-g02-026-078-discovery-starter-surfaces-poodle-example.md
base_required: pushed-main
tags: [coordination, handoff, worker, pre-execution-discovery, poodle]
---

## What This Thread Was Doing

The Northstar planning thread completed the Batch 26.3 starter-surface planning
checkpoint for `g02.026`. The operator changed the dogfood order to **Poodle
first, Figmatic later** because Figmatic is currently being handled through direct
one-to-one interactive bug fixing.

This handoff assigns one bounded implementation lane: card `g02.026/078`, which
adds copy-ready discovery templates, a worked docs-native Poodle `g15.006`
example, deterministic example coverage, and discoverability guidance. It does
not start the Poodle dogfood itself.

This is the complete worker instruction. Do not require a copied transcript or a
second prompt.

## Why It Matters

Northstar now has the routed discovery procedures and deterministic readiness-map
contract, but a new project still needs copy-ready surfaces and an example that
shows how a cleared map becomes ordinary spec and roadmap work without becoming a
second execution authority. The Poodle `g15.006` example makes the protocol
concrete against a real bounded release card while keeping the consumer repo
unchanged.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `d112c1830d7d09e5038b6c1ce336405da0d8d8cd`
- **Pushed main verification:** local `HEAD == origin/main` at the planning base
  before this handoff was created
- **Planning checkout:** clean and synchronized before handoff creation
- **Planning artifacts included at the base:** card `g02.026/078`, Batch 26.3
  checkpoint log, Poodle-first decision log, active spec/roadmap updates
- **Worker branch:** `dogfood/g02-026-078-discovery-starters`
- **Worker worktree:** `/tmp/northstar-worker-g02-026-078-discovery-starters`
- **Worktree creation command:**
  `git worktree add -b dogfood/g02-026-078-discovery-starters /tmp/northstar-worker-g02-026-078-discovery-starters "$(git rev-parse origin/main)"`
- **Worker worktree policy:** use the named clean non-`main` worktree when it
  matches; otherwise create a unique temporary worktree/branch from
  `origin/main` before editing. Never clean, reset, stash over, or discard a
  dirty/shared checkout.
- **Active spec lane:** `docs/specs/027-northstar-native-pre-execution-discovery.md`
- **Roadmap milestone:** `docs/roadmaps/g02/026-add-northstar-native-pre-execution-discovery.md`
- **Ready cards, in order:** `g02.026/078`
- **Allowed runway:** one card only; stop after the PR is opened
- **Remaining card budget:** one bounded docs/templates/fixture implementation
- **Dispatch topology:** serial worker/PR lane
- **Parallel safety check:** serial because the lane owns shared Northstar
  template, guidance, fixture, and active-roadmap surfaces
- **Canonical refs:** `docs/architecture/system-architecture.md`,
  `docs/specs/027-northstar-native-pre-execution-discovery.md`;
  `docs/contracts/001-working-rules.md`,
  `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
- **Model capability profile:** provider-neutral docs and fixture worker; no new
  architecture or product decision authority
- **Tool/runtime restrictions:** read Poodle only for source facts; do not modify
  `/Users/tom/Dev/projects/poodle` or `/Users/tom/Dev/projects/figmatic`
- **Required validation:** `git diff --check && effigy check:readiness-map && effigy test:readiness-map && effigy qa && effigy qa:docs && effigy doctor`; run both installed Northstar skill parity checks if skill references are touched
- **PR base/head:** current pushed `main` tip / `dogfood/g02-026-078-discovery-starters`
- **PR URL:** pending
- **Review state:** awaiting worker PR
- **Merge authorisation:** not granted; merge is a separate operator action

## Boundaries

Please keep this run inside the named runway:

- **In scope:** card `g02.026/078` only, especially:
  - `template-bundle/specs/templates/` readiness-map, decision-record,
    project-language, and cleared-map-promotion templates plus their index;
  - `template-bundle/specs/examples/poodle-g15-006/` self-contained example;
  - narrow deterministic fixture/test coverage for the example;
  - template-bundle, operator/setup, and pre-execution-discovery discoverability
    guidance;
  - execution evidence and one batch log if the card requires it.
- **Out of scope:**
  - any modification to Poodle source, contracts, roadmaps, logs, or readiness
    state;
  - any modification to Figmatic;
  - architecture refocus, reframe, consumer-repo dogfood execution, or worker/PR
    contract changes;
  - a second public skill or external tracker;
  - automatic map clearing, spec promotion, roadmap/card readiness, or worker
    dispatch;
  - new provider-specific APIs, network services, production code, or broad
    readiness-checker redesign.
- Do not invent Poodle behavior. Use only the Poodle source facts named below.
- Do not turn the example into a live readiness map scanned by Northstar's root
  checker unless the existing fixture convention explicitly requires a copied
  fixture; keep example-only files clearly non-live.
- Do not merge the PR. Merge remains a separate operator-authorised action.
- Work only in the selected clean worker worktree. Never edit the planning
  checkout or an unrelated dirty checkout.

## Important Context

- **Planning lineage:** Batch 26.1 established the readiness-map contract and
  deterministic checks; Batch 26.2 added routed intent rounds, project language,
  decision prototypes, and questionnaires; Batch 26.3 now adds starter surfaces
  and a promotion specimen.
- **Why this card is ready:** the scope, authority boundaries, exact validation,
  stop conditions, and Poodle example target are settled in card 078 and the
  Batch 26.3 checkpoint log.
- **Poodle target:** `g15.006 — React Mirror Implementation and Gallery Closure`,
  currently marked ready in Poodle's active `g15` generation. Read these source
  files read-only from `/Users/tom/Dev/projects/poodle`:
  - `docs/roadmaps/g15/README.md`;
  - `docs/roadmaps/g15/006-react-mirror-closure.md`;
  - `docs/roadmaps/g15/release-baseline-roster.md`;
  - `docs/roadmaps/g15/release-gap-register.md`;
  - `docs/architecture/001-poodle-system-shape.md`;
  - `docs/contracts/001-working-rules.md`.
- **Poodle posture note:** Poodle is clean and synchronized at `81fbbf5`. Its
  `effigy doctor` currently reports pre-existing generated-in-source, god-file,
  stale-suppression, and comment-ratio findings; the release gap register labels
  these as board-health findings. Report this baseline honestly; do not repair it
  in this card or attribute it to Northstar.
- **Poodle project-language seed:** release denominator, measured gap, React
  mirror, focused evidence, gallery specimen, active cohort, deferred backend.
  Each example entry must include aliases, meaning, authority, status, and
  rejected ambiguity. Keep these terms local to the example.
- **Promotion rule:** a cleared map may produce a promotion record linking
  evidence, canonical decision records, a master-spec target, a roadmap target,
  and an operator gate. It cannot clear itself, make a card ready, or mutate
  Poodle through this route.
- **Operator preference:** Poodle is first dogfood; Figmatic remains deferred
  during direct interactive bug fixing.
- **Report after:** the complete card and PR are finished, or immediately if a
  planning gap, missing authority, or scope boundary blocks the lane.
- **Report to:** the operator, who relays progress to the orchestrator.

## Suggested Next Move

Start by reading this handoff from the top. Before broad repository reads, run
the startup worktree-safety preflight in `## Completion Protocol`. Verify the
current context is a clean, dedicated, non-`main` worktree matching this handoff.
If it is not, do not edit it: create and record a unique temporary worktree and
branch from pushed `origin/main`, then continue only from that fallback. Read
`AGENTS.md`, the active milestone, card 078, the governing spec/contracts, and
the named Poodle source files read-only.

Once that checks out, implement only card 078. Keep the templates copy-ready,
keep the example internally linked, keep authority boundaries visible, run the
required checks, commit, push, and open a reviewable PR. Do not merge.

## Completion Protocol

### Before you start

1. Read this handoff path, then run a quick startup safety check:
   `git rev-parse --show-toplevel`, `git branch --show-current`,
   `git status --porcelain`, and `git worktree list --porcelain`.
2. Run `git fetch origin`. Use the named worktree only if its root/path and
   branch match `/tmp/northstar-worker-g02-026-078-discovery-starters` /
   `dogfood/g02-026-078-discovery-starters`, its status is empty, its branch is
   not `main`, and its `HEAD` is `origin/main`.
3. If any condition fails, do not edit the current checkout. Create a unique
   temporary worktree and branch from pushed `origin/main`, record the actual
   path and branch, and run all subsequent commands there. Never clean, reset,
   stash-over, or discard the original checkout's dirty state.
4. From the selected worktree, confirm `git rev-parse HEAD` equals
   `git rev-parse origin/main`, confirm
   `git merge-base --is-ancestor d112c1830d7d09e5038b6c1ce336405da0d8d8cd HEAD`
   succeeds, and confirm this handoff file exists at `HEAD`.
5. Read `AGENTS.md`, the active milestone, card 078, the governing spec and
   contracts, and the named Poodle source files.
6. Run cheap orientation checks and record what actually ran.

### While you work

- Keep changes aligned to card 078; do not broaden the template model.
- Treat all Poodle source reads as read-only evidence. Do not run commands that
  write into Poodle, generate Poodle artifacts, or change its git state.
- If a template field conflicts with the existing readiness-map contract, stop
  and report the contract gap instead of inventing a compatibility layer.
- After each meaningful chunk, report changed files, validation, remaining work,
  new risks, and blockers through the operator.

### When the assigned runway is complete

1. Run the required final validation:
   `git diff --check && effigy check:readiness-map && effigy test:readiness-map && effigy qa && effigy qa:docs && effigy doctor`.
2. If `skills/northstar/` or installed-skill source surfaces are touched, also
   run both Northstar skill-install parity checks.
3. Update the card/log evidence required by the runway, including actual
   changed files and any baseline Poodle findings.
4. Push the selected worker branch, or the recorded fallback branch.
5. Open a reviewable PR against the current pushed `main` tip. Link the spec,
   milestone, card, changed surfaces, Poodle source paths, validation, and
   unresolved items in the PR body.
6. Report the PR URL and evidence. Do not merge.

### Review and merge path

The orchestrator will review the exact PR diff and checks against card 078 and
the canonical refs. Current review state: awaiting worker PR.

The orchestrator records an evidence-backed verdict in the hosting provider's
review surface. When the orchestrator and worker share a GitHub identity, formal
self-approval is unavailable, so the orchestrator posts the verdict as a PR
comment; that comment is the canonical review record. The operator must
explicitly authorize any merge.

- **Closeout refs:** card 078, `docs/specs/027-northstar-native-pre-execution-discovery.md`,
  `docs/roadmaps/g02/026-add-northstar-native-pre-execution-discovery.md`,
  current roadmap front doors, and a new Batch 26.3 worker/PR closeout log.

### Handoff closeout

Before calling the runway complete, leave the card, roadmap, log, and next-task
state honest. If the work is blocked, record the blocker and stop rather than
making the handoff look more complete than it is.
