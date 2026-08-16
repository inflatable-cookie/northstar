---
title: Pre-execution discovery routes worker handoff
kind: northstar-handoff
handoff_mode: worker-pr-loop
handoff: single-file-path-only
status: ready-to-launch
owner: repo maintainers
created: 2026-08-16
updated: 2026-08-16
handoff_path: docs/handoffs/20260816-213453-g02-026-077-pre-execution-discovery-routes.md
base_required: pushed-main
tags: [coordination, handoff, worker, pr, pre-execution-discovery]
---

## What This Thread Was Doing

The Northstar planning thread completed Batch 26.2's planning checkpoint for
pre-execution discovery. It promoted the route contract and prepared one bounded
implementation card: `g02.026/077`.

This is the handoff from the planning/orchestrator thread to one bounded
implementation thread. Read this file first; it is the complete worker brief.

## Why It Matters

Northstar now has deterministic readiness-map integrity checks, but it needs a
usable question-led route over the readiness frontier before a material project
can enter ordinary planning. This card adds the provider-neutral skill procedure
without adding a second authority surface, external tracker, or automatic
execution permission.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `a82e57c705849ce99c0b83b9840876c8de45f145`
- **Pushed main verification:** local `HEAD == origin/main` before handoff creation
- **Planning checkout:** clean before handoff creation
- **Planning artifacts included at the base:** Batch 26.2 route contract,
  architecture update, spec 027 decisions, roadmap updates, and card 077
- **Worker branch:** `dogfood/g02-026-077-pre-execution-routes`
- **Worker worktree:** `/tmp/northstar-worker-g02-026-077-pre-execution-routes`
- **Worktree creation command:** `git worktree add -b dogfood/g02-026-077-pre-execution-routes /tmp/northstar-worker-g02-026-077-pre-execution-routes origin/main`
- **Worker worktree policy:** use the named clean non-`main` worktree when it
  matches; otherwise create a unique temporary worktree/branch from `origin/main`
  before editing.
- **Active spec lane:** `docs/specs/027-northstar-native-pre-execution-discovery.md`
- **Roadmap milestone:** `docs/roadmaps/g02/026-add-northstar-native-pre-execution-discovery.md`
- **Ready cards, in order:** `g02.026/077`
- **Allowed runway:** implement the provider-neutral pre-execution discovery
  mode and router activation described in card 077 only
- **Remaining card budget:** one card; stop after the PR is opened
- **Dispatch topology:** serial; one worker lane
- **Parallel safety check:** no parallel lane offered because the route procedure,
  router, and installed skill parity share mutable skill surfaces
- **Canonical refs:** `docs/architecture/system-architecture.md`,
  `docs/specs/027-northstar-native-pre-execution-discovery.md`;
  `docs/contracts/001-working-rules.md`,
  `docs/roadmaps/g02/batch-cards/077-implement-pre-execution-discovery-routes.md`
- **Model capability profile:** capable coding/documentation model, medium reasoning
- **Tool/runtime restrictions:** provider-neutral; no network, database, external
  tracker, production-code, or consumer-repo changes
- **Required validation:** `git diff --check`, `effigy qa:docs`,
  `effigy check:skill-install /Users/tom/.agents/skills/northstar`,
  `effigy check:skill-install /Users/tom/.hermes/skills/northstar`
- **PR base/head:** `main` / `dogfood/g02-026-077-pre-execution-routes`
- **PR URL:** pending
- **Review state:** awaiting implementation and orchestrator review
- **Merge authorisation:** not granted; do not merge

## Boundaries

Please keep this run inside the named runway:

- **In scope:** card `g02.026/077`; add the internal
  `pre-execution-discovery` mode, router activation, intent-round procedure,
  project-language guidance, decision-prototype route, questionnaire route, and
  necessary skill default guidance.
- **Out of scope:** starter-bundle templates, worked examples, readiness-map
  checker/fixtures, architecture refocus, reframe, automatic cross-session
  messaging, provider-specific APIs, external trackers, databases, network
  services, production code, Figmatic, Poodle, and changes to the worker/PR
  contract.
- Do not invent architecture, change contracts, widen the roadmap, or choose an
  unresolved product/API/persistence/security decision.
- Work only in the selected clean worker worktree. Never edit the orchestrator's
  planning checkout or an unrelated dirty checkout.
- Do not merge the PR. Merge remains a separate operator-authorised action.

## Important Context

- **Planning lineage:** `g02.026` follows the completed orchestrator/worker PR
  loop and the merged readiness-map contract/checker cards. The route contract is
  now canonical in architecture and working rules.
- **Why this card is ready:** operator selected Figmatic first and Poodle second;
  project language is local by default; route inputs, outputs, authority
  boundaries, promotion rules, acceptance, evidence, and stop conditions are
  explicit in card 077.
- **Decisions and preferences:** keep Northstar-native names; keep routes human,
  conversational, provider-neutral, plan-only, and non-mutating by default;
  retain useful recommendations without silently deciding for the operator.
- **Open tensions:** do not turn intent rounds into exhaustive grilling; do not
  promote destination vocabulary to global glossary without evidence; do not let
  prototype evidence or questionnaire answers silently resolve operator-owned
  decisions.
- **Report after:** first coherent mode/router chunk, then after validation and PR
  creation
- **Report to:** the operator, who will relay progress to the orchestrator

## Suggested Next Move

Start by reading this handoff from the top. Before broad repository reads, run the
startup worktree-safety preflight in `## Completion Protocol`. Verify the current
context is a clean, dedicated, non-`main` worktree matching the handoff. Read the
active milestone, card 077, `AGENTS.md`, the Northstar skill router, the canonical
architecture, contract, and spec. Then implement only the assigned route
procedure, validate it, push the branch, and open a reviewable PR. Keep worker
reports natural and useful; report what changed, what validation actually ran,
and what remains.

## Completion Protocol

### Before you start

1. Read this handoff path, then run a quick startup safety check before broad
   repository reads:
   `git rev-parse --show-toplevel`, `git branch --show-current`,
   `git status --porcelain`, and `git worktree list --porcelain`.
2. Run `git fetch origin`. Use the named worktree only if its root/path and
   branch match `/tmp/northstar-worker-g02-026-077-pre-execution-routes` /
   `dogfood/g02-026-077-pre-execution-routes`, its status is empty, its branch is
   not `main`, and its `HEAD` is `origin/main`.
3. If any condition fails, do not edit the current checkout. Create a unique
   temporary worktree and branch from pushed `origin/main`, record the actual
   fallback path and branch, and continue only there. Never clean, reset, stash
   over, or discard the original checkout's dirty state.
4. From the selected worktree, confirm `git rev-parse HEAD` equals
   `git rev-parse origin/main`, confirm
   `git merge-base --is-ancestor a82e57c705849ce99c0b83b9840876c8de45f145 HEAD`
   succeeds, and confirm this handoff file exists in the selected `HEAD`.
5. Read the active milestone, card 077, `AGENTS.md`, and canonical refs.
6. Run `effigy tasks` and `effigy doctor`, recording what actually ran.

### While you work

- Execute only card 077 and keep commits aligned with meaningful chunks.
- Add the new internal mode under `skills/northstar/references/modes/` and update
  the router only as required for its activation.
- Keep the procedure grounded in the current readiness map/frontier and the
  canonical route contract. Do not create parallel schemas or hidden authority.
- After each meaningful chunk, report changed files, validation, remaining work,
  risks, and blockers through the operator.
- Stop if a contract is missing, intent is ambiguous, scope expands, authority is
  unclear, or validation changes the plan.

### When the assigned runway is complete

1. Run `git diff --check`, `effigy qa:docs`, and both skill-install parity checks.
2. Confirm no consumer repository or production code changed.
3. Update card 077 evidence only if the card's implementation state requires it;
   do not mark the card complete before merge.
4. Push the selected worker branch.
5. Open a reviewable PR against the current pushed `main` tip. Link the spec,
   milestone, card, changed surfaces, evidence, validation, and unresolved items.
6. Report the PR URL and evidence to the operator. Do not merge.

### Review and merge path

The orchestrator will review the PR against the canonical refs, diff, and checks.
The orchestrator will record an evidence-backed verdict in the provider review
surface. When the orchestrator and worker share a GitHub identity, formal
self-approval is unavailable, so the orchestrator will post the verdict as a PR
comment; that comment is the canonical review record. The operator must
explicitly authorise any merge.

- **Closeout refs:** card 077, spec 027, milestone g02.026, roadmap front doors,
  and a dated batch log under `docs/logs/2026-08/`

### Handoff closeout

Before calling the runway complete, leave card 077, the roadmap, log, and next-task
state honest. If implementation is blocked, record the blocker and stop rather
than making the handoff look more complete than it is.

NEVER include API keys, tokens, passwords, secrets, credentials, or connection strings in the summary — replace any that appear with [REDACTED].
