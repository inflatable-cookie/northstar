---
title: g02.026/075 readiness map contract worker
kind: northstar-handoff
handoff_mode: worker-pr-loop
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-08-16
updated: 2026-08-16 19:12:51 +0100
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260816-191251-g02-026-075-readiness-map-contract-worker.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, readiness-mapping]
---

## What This Thread Was Doing

The planning thread closed the first orchestrator/worker dogfood and then
compiled the first Batch 26.1 card for Northstar-native pre-execution discovery.
The operator settled two foundational choices: readiness maps use bounded
destination subdirectories under `docs/specs/`, and maps/records use Markdown
with YAML frontmatter and explicit links.

This handoff starts one bounded worker thread to promote the exact file contract
into Northstar's architecture, working rules, and active spec. It is written so
the worker can operate from this file and the named canonical refs without a
copied transcript or second prompt.

## Why It Matters

The readiness workflow must have one durable, repository-native contract before
frontier validation or further routes are implemented. This card prevents the
checker and later procedures from guessing the map layout, authority fields, or
canonical-rationale boundary.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `df6e187b650df22246ad8bb06b3d226e777ba41c`
- **Pushed main verification:** run `git fetch origin`, then confirm local
  `HEAD == origin/main`; the current tip contains this handoff file
- **Planning checkout:** clean before handoff creation
- **Planning artifacts included at the base:** spec 027, active g02.026
  milestone, ready card 075, and planned dependent card 076
- **Worker branch:** `dogfood/g02-026-075-readiness-map-contract`
- **Worker worktree:** `/tmp/northstar-worker-g02-026-075`
- **Worktree creation command:** `git worktree add -b dogfood/g02-026-075-readiness-map-contract /tmp/northstar-worker-g02-026-075 "$(git rev-parse origin/main)"`
- **Active spec lane:** `docs/specs/027-northstar-native-pre-execution-discovery.md`
- **Roadmap milestone:** `g02.026`
- **Ready card:** `g02.026/075`
- **Allowed runway:** one contract-promotion card, one commit, one PR
- **Remaining card budget:** one card; no automatic continuation
- **Canonical refs:** `docs/specs/027-northstar-native-pre-execution-discovery.md`, `docs/roadmaps/g02/026-add-northstar-native-pre-execution-discovery.md`, `docs/roadmaps/g02/batch-cards/075-define-readiness-map-file-contract.md`, `docs/roadmaps/g02/batch-cards/076-implement-deterministic-readiness-frontier-checks.md`; `docs/architecture/system-architecture.md`; `docs/contracts/001-working-rules.md`
- **Model capability profile:** capable/medium for bounded documentation and contract work
- **Tool/runtime restrictions:** work only in the named worktree; do not merge; do not implement the checker or edit skill/router/template surfaces
- **Required validation:** `git diff --check && effigy qa && effigy qa:docs`
- **PR base/head:** current pushed `main` / `dogfood/g02-026-075-readiness-map-contract`
- **PR URL:** pending
- **Review state:** awaiting worker PR
- **Merge authorization:** not granted; merge remains a separate operator-authorized action

## Boundaries

Please keep this run inside the named runway:

- **In scope:** promote the exact readiness-map and decision-record file contract
  into `docs/architecture/system-architecture.md`,
  `docs/contracts/001-working-rules.md`, and
  `docs/specs/027-northstar-native-pre-execution-discovery.md`; update this
  card with completion evidence when the card is done
- **Out of scope:** deterministic checker implementation, Effigy task wiring,
  router or skill changes, starter templates, intent rounds, project language
  procedures, decision prototypes, questionnaires, architecture refocus,
  reframe, production code, provider adapters, or automatic messaging
- Do not reopen the settled placement or representation choices without a
  concrete contradiction in the canonical refs.
- Do not invent a second planning database or duplicate decision rationale in the
  readiness map.
- Work only in `/tmp/northstar-worker-g02-026-075` on
  `dogfood/g02-026-075-readiness-map-contract`.
- Do not merge the PR. Merge remains a separate operator-authorized action.

## Important Context

- **Planning lineage:** g02.025 proved the manual operator-mediated worker/PR
  boundary. g02.026 now defines the pre-execution discovery contract before
  adding automation.
- **Settled operator choices:** bounded destination subdirectories under
  `docs/specs/`; Markdown records with YAML frontmatter and explicit relative
  links.
- **Required contract shape:**
  - map: `docs/specs/<destination-slug>/README.md`;
  - records: `docs/specs/<destination-slug>/decisions/<decision-id>-<slug>.md`;
  - map is an index and summary surface, not a second rationale store;
  - decision records expose stable ID, kind, mode, status, title, owner,
    authority, `blocked_by`, and resolution evidence or accepted uncertainty.
- **Authority boundary:** operator-owned decisions cannot be resolved by agent
  inference; research, prototype, and task records remain distinct from
  operator decisions.
- **Report after:** the canonical contract changes are clear, then after
  validation and PR creation
- **Report to:** the operator, who will relay progress to the orchestrator

## Suggested Next Move

Read this handoff first, then `AGENTS.md`, the active milestone, card 075, spec
027, `docs/architecture/system-architecture.md`, and
`docs/contracts/001-working-rules.md`. Verify the worktree, branch, remote tip,
planning ancestor, and handoff presence before editing.

Promote the layout, frontmatter, state vocabulary, stable-ID rules, dependency
reference rules, and map-versus-canonical-rationale boundary into the governing
architecture and contract. Keep spec 027's resolved decisions and remaining
open questions honest. Do not implement the checker; card 076 remains planned
until this contract is merged.

## Completion Protocol

### Before you start

1. Confirm the worker worktree is `/tmp/northstar-worker-g02-026-075` and the
   branch is `dogfood/g02-026-075-readiness-map-contract`.
2. Run `git fetch origin` and confirm `git rev-parse HEAD` equals
   `git rev-parse origin/main`.
3. Confirm `git merge-base --is-ancestor
   df6e187b650df22246ad8bb06b3d226e777ba41c HEAD` succeeds and that this
   handoff file exists in the current `HEAD`.
4. Read the active milestone, card 075, spec 027, `AGENTS.md`, and canonical
   architecture/contract refs.
5. Run the repo's cheap orientation checks and record what you actually ran.

### While you work

- Execute only `g02.026/075`.
- Keep changes limited to the three canonical surfaces and card 075 closeout.
- After the inspection/proposal chunk, report changed files, checks, remaining
  work, risks, and blockers through the operator.
- Stop if a new operator-owned choice appears, a canonical contradiction is
  found, the checker implementation becomes necessary, or scope expands.

### When the assigned runway is complete

1. Run `git diff --check && effigy qa && effigy qa:docs`.
2. Confirm no skill, router, template, checker, or production-code file changed.
3. Confirm the diff contains only the allowed canonical surfaces and card 075.
4. Commit the contract promotion with a concise documentation message.
5. Push `dogfood/g02-026-075-readiness-map-contract`.
6. Open a reviewable PR against the current pushed `main` tip.
7. In the PR body, link spec 027, milestone 026, cards 075/076, changed
   surfaces, validation, settled choices, and unresolved questions.
8. Report the PR URL and evidence to the operator. Do not merge.

### Review and merge path

The orchestrator will independently review the PR against canonical refs, diff,
checks, and card scope. It records an evidence-backed verdict in the provider
review surface. If the orchestrator and worker share a GitHub identity, formal
self-approval is unavailable; the verdict must be posted as a PR comment, which
is the canonical review record. The operator must explicitly authorize any
merge.

### Handoff closeout

Before calling the runway complete, leave card 075, milestone 026, the log, and
the next-task state honest. If the contract remains disputed or the worker is
blocked, record the blocker and stop rather than making the promotion look
complete.

NEVER include API keys, tokens, passwords, secrets, credentials, or connection strings in the summary — replace any that appear with [REDACTED].
