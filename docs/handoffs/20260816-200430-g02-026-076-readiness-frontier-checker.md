---
title: g02.026/076 readiness frontier checker worker
kind: northstar-handoff
handoff_mode: worker-pr-loop
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-08-16
updated: 2026-08-16 20:04:30 +0100
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260816-200430-g02-026-076-readiness-frontier-checker.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, readiness-mapping, frontier-checks]
---

## What This Thread Was Doing

The planning thread completed and merged the Batch 26.1 readiness-map and
decision-record file contract, then defined the exact Effigy-native command
surface for deterministic frontier validation. Card `g02.026/076` is now ready
for one bounded implementation worker lane.

This handoff starts that lane. It is written so the worker can operate from this
file, the named canonical refs, and the repository state without a copied
transcript or a second prompt.

## Why It Matters

Northstar needs a deterministic, repository-native readiness check before it can
add intent rounds, project-language routes, decision prototypes, and promotion
procedures. The checker must expose invalid dependency state rather than guessing,
while remaining read-only, fail-closed, and independent of external trackers,
providers, databases, and network access.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `8a755f1b7728191738e6b4f361e9d2efee32dda5`
- **Pushed main verification:** local `HEAD == origin/main` was verified after
  pushing the ready-state promotion; fetch again before editing
- **Planning checkout:** clean before handoff creation
- **Planning artifacts included at the base:** promoted Batch 26.1 contract,
  ready card 076, current roadmap/spec pointers, and the exact command contract
- **Worker branch:** `dogfood/g02-026-076-readiness-frontier-checker`
- **Worker worktree:** `/tmp/northstar-worker-g02-026-076-readiness-frontier`
- **Worktree creation command:** `git worktree add -b dogfood/g02-026-076-readiness-frontier-checker /tmp/northstar-worker-g02-026-076-readiness-frontier "$(git rev-parse origin/main)"`
- **Worker worktree policy:** use the named clean non-`main` worktree when it
  matches; otherwise create a unique temporary worktree/branch from current
  pushed `origin/main` before editing
- **Active spec lane:** `docs/specs/027-northstar-native-pre-execution-discovery.md`
- **Roadmap milestone:** `g02.026`
- **Ready card:** `g02.026/076`
- **Allowed runway:** one checker implementation card, one worker branch, one
  reviewable PR; no automatic continuation
- **Remaining card budget:** one card
- **Dispatch topology:** serial; this lane is the only ready implementation lane
- **Parallel safety check:** no parallel dispatch; checker wiring and fixtures
  share Effigy configuration and validation scope
- **Canonical refs:** `docs/specs/027-northstar-native-pre-execution-discovery.md`,
  `docs/roadmaps/g02/026-add-northstar-native-pre-execution-discovery.md`,
  `docs/roadmaps/g02/batch-cards/075-define-readiness-map-file-contract.md`,
  `docs/roadmaps/g02/batch-cards/076-implement-deterministic-readiness-frontier-checks.md`;
  `docs/architecture/system-architecture.md`; `docs/contracts/001-working-rules.md`;
  `bundle-docs/protocol-kernel.md`
- **Model capability profile:** capable/medium for bounded Rhai validation and
  fixture work; stop and report if the promoted contract is insufficient
- **Tool/runtime restrictions:** use Effigy-native Rhai; no network, database,
  provider adapter, external tracker, production code, or package-script alias;
  do not merge
- **Required validation:** `git diff --check && effigy check:readiness-map && effigy test:readiness-map && effigy qa && effigy qa:docs`
- **PR base/head:** current pushed `main` / `dogfood/g02-026-076-readiness-frontier-checker`
- **PR URL:** pending
- **Review state:** awaiting worker PR
- **Merge authorisation:** not granted; merge remains a separate operator-authorised action

## Boundaries

Please keep this run inside the named runway:

- **In scope:** implement the exact commands from card 076:
  `effigy check:readiness-map`, `effigy test:readiness-map`, and their
  `effigy qa:docs` integration; add the shared Rhai validation/parser helper if
  needed; add the committed fixture corpus; update repo-owned script/contract
  documentation needed to make the command surface discoverable and enforced.
- **Expected implementation surfaces:** `effigy.toml`,
  `scripts/check-northstar-readiness-map.rhai`,
  `scripts/test-northstar-readiness-map.rhai`, optional shared helpers under
  `scripts/lib/`, fixtures under `scripts/fixtures/readiness-map/`, and the
  relevant `scripts/README.md` / repo-contract data assertions.
- **Out of scope:** intent rounds, project language, decision prototypes,
  questionnaires, architecture refocus, reframe, starter templates, provider
  adapters, external trackers, database/network access, production code, broad
  schema redesign, or changing the worker/PR protocol.
- Do not infer missing authority, dependency, resolution evidence, or accepted
  uncertainty. Report invalid state instead.
- Do not mutate readiness maps, decision records, or fixtures during checking.
- Work only in the selected clean worker worktree. Never edit the orchestrator's
  planning checkout or an unrelated dirty checkout.
- Do not merge the PR. Merge remains a separate operator-authorised action.

## Important Context

- **Planning lineage:** `g02.026/075` promoted the exact Batch 26.1 contract;
  card 076 is the first implementation card against that contract.
- **Map location and frontmatter:**
  `docs/specs/<destination-slug>/README.md` with
  `kind: readiness-map`, stable `id`, `title`, `destination`, `owner`,
  `status: active|cleared|paused`, `master_spec`, and `roadmap`.
- **Required map sections:** `Destination`, `Decision index`, `Current frontier`,
  and `Readiness gate`.
- **Decision record location and frontmatter:**
  `docs/specs/<destination-slug>/decisions/<decision-id>-<slug>.md` with stable
  `id`, `kind`, `mode`, `status`, `title`, `owner`, `authority`, and `blocked_by`.
  Resolved records expose exactly one of `resolution_evidence` or
  `accepted_uncertainty`.
- **Integrity rules:** IDs are lowercase kebab-case and unique within a
  destination; `blocked_by` uses those IDs; relative links stay inside the
  destination subtree or target named canonical docs surfaces.
- **Frontier rule:** a decision is on the frontier when it is open, not out of
  scope, not claimed by an active planning session, and every blocking decision
  is resolved. Research may be delegated only with a complete question and
  source boundary. Operator-owned or prototype-owned decisions remain blocked
  until live exchange/evidence returns.
- **Required invalid cases:** missing references, dependency cycles, orphan
  decisions, invalid states, and operator-blocked decisions.
- **Report after:** the command contract is implemented and the fixture matrix is
  green; report again after final validation and PR creation
- **Report to:** the operator, who will relay progress to the orchestrator

## Suggested Next Move

Start by reading this handoff from the top. Before broad repository reads, run
the startup worktree-safety preflight in `## Completion Protocol`. Verify the
current context is a clean, dedicated, non-`main` worktree matching the handoff.
If it is not, do not edit it: create and record a unique temporary worktree and
branch from pushed `origin/main`, then continue only from that fallback.

Read `AGENTS.md`, `effigy.toml`, `scripts/README.md`, the active milestone,
card 076, spec 027, the promoted architecture/contract refs, and the prior card
075 closeout. Then implement the smallest repository-native checker that satisfies
card 076. Keep the live zero-map check deterministic and use the committed fixture
corpus to prove valid, missing-reference, cyclic, orphan, and operator-blocked
behaviour.

## Completion Protocol

### Before you start

1. Read this handoff path, then run a quick startup safety check before broad
   repository reads: `git rev-parse --show-toplevel`,
   `git branch --show-current`, `git status --porcelain`, and
   `git worktree list --porcelain`.
2. Run `git fetch origin`. Use the named worktree only if its root/path and
   branch match `/tmp/northstar-worker-g02-026-076-readiness-frontier` /
   `dogfood/g02-026-076-readiness-frontier-checker`, its status is empty, its
   branch is not `main`, and its `HEAD` is `origin/main`.
3. If any condition fails, do not edit the current checkout. Create a unique
   temporary worktree and branch from pushed `origin/main`, for example:
   `TEMP_SUFFIX="$(date +%Y%m%d%H%M%S)-$$"; TEMP_WORKTREE="${TMPDIR:-/tmp}/northstar-worker-${TEMP_SUFFIX}"; TEMP_BRANCH="dogfood/g02-026-076-readiness-frontier-checker-tmp-${TEMP_SUFFIX}"; git worktree add -b "$TEMP_BRANCH" "$TEMP_WORKTREE" "$(git rev-parse origin/main)"`
   Record the actual fallback path and branch, and run all subsequent commands
   from that selected worktree. Never clean, reset, stash-over, or discard the
   original checkout's dirty state.
4. From the selected worktree, confirm `git rev-parse HEAD` equals
   `git rev-parse origin/main`, confirm
   `git merge-base --is-ancestor 8a755f1b7728191738e6b4f361e9d2efee32dda5 HEAD`
   succeeds, and confirm this handoff file exists in the selected `HEAD`.
5. Read the active milestone, card 076, spec 027, `AGENTS.md`,
   `effigy.toml`, and the canonical architecture/contract refs.
6. Run `effigy tasks` and `effigy doctor`, then record what you actually ran.

### While you work

- Execute only `g02.026/076`.
- Keep commits aligned with meaningful bounded chunks, not arbitrary turns.
- After each meaningful chunk, report changed files, validation actually run,
  remaining work, risks, and blockers through the operator.
- Stop and report if the promoted contract is insufficient, a new operator-owned
  choice appears, a canonical contradiction is found, the checker needs network
  or provider access, or scope expands.
- Do not quietly turn an open question into a new schema or architecture.

### When the assigned runway is complete

1. Run `git diff --check && effigy check:readiness-map && effigy test:readiness-map && effigy qa && effigy qa:docs`.
2. Confirm the live checker, fixture test, and full QA outputs are deterministic;
   verify the valid fixture's frontier output is stable across two runs.
3. Confirm invalid fixtures fail for actionable intended reasons and the
   operator-owned case remains blocked rather than inferred resolved.
4. Confirm checker execution did not mutate maps, records, or fixtures.
5. Update the card/log evidence required by the runway, including the actual
   worktree and branch if the temporary fallback was used.
6. Commit the bounded implementation with a concise message.
7. Push the selected worker branch (the fallback branch if one was created).
8. Open a reviewable PR against the current pushed `main` tip.
9. In the PR body, link spec 027, milestone 026, cards 075/076, changed
   surfaces, the fixture matrix, deterministic frontier output, validation, and
   unresolved items.
10. Report the PR URL and evidence to the operator. Do not merge.

### Review and merge path

The orchestrator will independently review the PR against canonical refs, diff,
checks, and card scope. It records an evidence-backed verdict in the provider
review surface. If the orchestrator and worker share a GitHub identity, formal
self-approval is unavailable; the verdict must be posted as a PR comment, which
is the canonical review record. The operator must explicitly authorise any merge.

- **Closeout refs:** `docs/roadmaps/g02/batch-cards/076-implement-deterministic-readiness-frontier-checks.md`,
  `docs/roadmaps/g02/026-add-northstar-native-pre-execution-discovery.md`,
  `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`,
  `docs/logs/README.md`

### Handoff closeout

Before calling the runway complete, leave card 076, milestone 026, the log, and
the next-task state honest. If the implementation is blocked or the fixture
contract is disputed, record the blocker and stop rather than making the checker
look more complete than it is.

NEVER include API keys, tokens, passwords, secrets, credentials, or connection strings in the summary — replace any that appear with [REDACTED].
