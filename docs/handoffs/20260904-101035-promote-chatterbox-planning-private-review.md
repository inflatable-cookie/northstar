---
title: Promote Chatterbox planning and private review children
kind: northstar-handoff
handoff_mode: worker-pr-loop
worker_mode: implementation
dispatch_authority: orchestrator
handoff: single-file-path-only
status: ready-to-launch
owner: Northstar orchestrator
created: 2026-09-04
updated: 2026-09-04
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260904-101035-promote-chatterbox-planning-private-review.md
base_required: pushed-main
tags: [coordination, handoff, promotion, projection, pr]
---

## What This Thread Was Doing

This lane promotes two operator-confirmed triage packets into Northstar's
canonical planning, contract, architecture, doctrine, skill, and template
surfaces. The later packet
`docs/triage/20260904-100548-place-review-child-in-worker-workspace.md`
overrides the earlier packet wherever reviewer placement differs.

This is a bounded planning-projection worker lane. The worker may faithfully
materialize the confirmed meaning into the named surfaces, commit, push, and
open a reviewable PR. It is not a new planner and must stop on semantic
ambiguity.

## Why It Matters

Northstar needs one operator-facing material-planning role and a mechanical
coordinator. Independent review remains exact-head and provider-recorded, but
the reviewer leases the existing worker workspace serially instead of creating
a review-only workspace.

## Current State

- **Repository:** `/Users/tom/Dev/projects/northstar`
- **Planning branch:** `main`
- **Planning base commit:** `5ef7a99`
- **Pushed main verification:** local `HEAD` equals `origin/main` before this handoff commit
- **Planning checkout:** clean before this handoff
- **Worker mode:** bounded planning-projection worker dispatched by the orchestrator; this handoff activates the worker-only worktree preflight.
- **Planning artifacts included at the base:** the two operator-confirmed triage packets
- **Worker branch:** `worker/promote-chatterbox-planning-private-review`
- **Worker worktree:** Paseo-managed; record the actual path before broad reads
- **Worktree creation command:** Paseo `create_workspace` with `isolation: worktree`, `mode: branch-off`, `baseBranch: origin/main`
- **Required sibling worktree links:** `none`
- **Active spec lane:** operator-confirmed promotion of specs 035, 036, and 026
- **Roadmap milestone:** current `g02` runway; update only the named front-door/index surfaces as settled by the packet
- **Ready cards, in order:** none supplied; do not invent a card or readiness state
- **Allowed runway:** the exact canonical destination map in the two packets, with packet 2 overriding packet 1
- **Remaining card budget:** one bounded promotion lane; stop when the named promotion is complete or a stop condition fires
- **Dispatch topology:** one projection worker; an independent private review child will later lease this same worker workspace serially
- **Parallel safety check:** one worker owns all named promotion surfaces; review is strictly serial after the worker releases the workspace
- **Surfaces this lane owns:** every path in the exact destination map below and this handoff's PR/evidence updates; no product code
- **Integration ownership:** orchestrator owns Git mutations on `main`, independent review dispatch, merge gate, merge, triage disposition, and final closeout
- **Canonical refs:** `docs/triage/20260904-100224-chatterbox-planning-and-private-review-children.md`; `docs/triage/20260904-100548-place-review-child-in-worker-workspace.md`; `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`; `docs/specs/035-chatterbox-intake-channel.md`; `docs/specs/036-economical-orchestrator-coordination.md`; `docs/contracts/001-working-rules.md`
- **Review oracle:** confirmed-packet fidelity, no invented/omitted/reinterpreted/misrouted meaning, exact destination and state transitions, no compatibility alias, private worker-workspace review topology, exact-head verdict, and all packet validation rows
- **Model capability profile:** economical documentation/contract projection worker; independent economical exact-head review child
- **Frontier-worker justification:** `none`; settled packet meaning, explicit destinations, review oracle, deterministic validation, and independent review bound this lane
- **Tool/runtime restrictions:** no product-code edits; no `.github/workflows/` or release mutations; preserve unrelated dirty state; reviewer must not mutate tracked files, branches, or workspace topology
- **Required validation:** `git diff --check`; `effigy check:chatterbox-git`; `effigy check:command-skills`; `effigy check:repo-contract`; `effigy check:model-routing`; `effigy qa:docs`; `effigy qa`; and the repository's source/install parity check for the changed skill payload
- **PR base/head:** current pushed `main` / worker branch exact head
- **PR URL:** pending
- **Review state:** awaiting independent private child review after worker finish
- **Merge path:** orchestrator after accepted exact-head provider verdict, resolved findings, passing checks, acceptable ancestry, mergeability, and no pause

## Exact Promotion Brief

### Authority and settled input

- **Authority owner:** operator, confirmed in both named triage packets
- **Settled decisions:** use the earlier packet's confirmed decisions and
  destination map exactly; apply the later packet's correction everywhere: the
  independent reviewer remains a coordinator-owned child, is placed through
  the existing worker `workspaceId`, appears as a visible tab in that worker
  workspace, has `notifyOnFinish: true`, and leases the workspace only after
  the worker has finished and the coordinator has verified an exact-head clean
  boundary. Never create a review-only workspace or fall back to the
  coordinator workspace.
- **Required state transitions:** evolve Chatterbox into the single
  operator-facing material discovery/planning role; retire the separate
  planning-delegate path without a compatibility alias; make coordinator
  promotion routing mechanical from a complete confirmed envelope; preserve
  independent exact-head provider review and the merge gate; update named
  reusable/source/install surfaces; remove the superseded planning-delegate
  template; keep the triage packets out of canonical planning after promotion
  except for unresolved residue explicitly retained by the packet.

### Exact canonical destination map

Update only these paths, using the required deltas in the source packet:

- `docs/specs/035-chatterbox-intake-channel.md`
- `docs/specs/036-economical-orchestrator-coordination.md`
- `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
- `docs/contracts/001-working-rules.md`
- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `bundle-docs/sections/07-delivery-framework-and-autonomy.md`
- `bundle-docs/operators/operator-quick-start.md`
- `bundle-docs/glossary.md`
- `template-bundle/contracts/001-working-rules-template.md`
- `template-bundle/policy/internal-writing-style.md`
- `skills/northstar/SKILL.md`
- `skills/northstar/references/router.md`
- `skills/northstar/references/modes/chatterbox.md`
- `skills/northstar/references/modes/orchestrator.md`
- `skills/northstar/references/modes/pr-review.md`
- `skills/northstar/assets/templates/northstar-discovery-delegate.md.template` (remove)
- `docs/README.md`
- `docs/roadmaps/README.md`
- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/g02/README.md`

The final four roadmap/front-door paths are the concrete projection of the
packet's `docs/README.md and owned roadmap/front-door indexes` row. Do not
create a new milestone, card, or other semantic authority destination: the
packet does not name one. If faithful sequencing requires one, stop and return
that question to the operator.

Use exact-token search to locate derived wording and validation surfaces, but
do not add any path not listed above. If a checker or parity surface outside
the list requires a semantic edit, stop and report the path for confirmation.

### Forbidden judgments

Do not choose a canonical home, invent or reinterpret intent, turn a
recommendation into a decision, create acceptance/stop/review policy, decide
readiness/completion/next work, resolve a contradiction, retain a compatibility
alias, alter worker workspace creation, weaken independent review, or change
Paseo. Do not make a reviewer concurrent with the worker. Do not commit or
merge any review verdict in the worker branch.

### Validation and stop conditions

Run the required validation above plus focused structural checks already
provided by the repository. Stop and report if any destination is missing or
outside this list, the packets conflict beyond packet 2's reviewer-placement
override, exact wording or state is semantically underdetermined, validation
changes the plan, or unrelated dirty work would be overwritten.

## Boundaries

- **In scope:** one faithful promotion of the two confirmed packets into the
  named canonical surfaces.
- **Out of scope:** implementation code, a new roadmap/card lane, product
  decisions, compatibility shims, Paseo changes, review-workspace creation,
  direct review, merge, release work, and unrelated cleanup.
- **Outcome shape:** a committed, pushed, reviewable PR whose diff is fully
  traceable to the confirmed packets.
- Work only in the clean dedicated worker worktree selected by the completion
  protocol. Never edit the planning checkout.
- The private review child will use this same worker workspace after the
  worker releases it; no separate review workspace may be created.

## Important Context

- The current canonical surfaces still describe the older intake/planning-
  delegate and dedicated-review-workspace split. That is the meaning this
  promotion is authorized to update.
- Packet 2 overrides only reviewer placement and serial lease details; all
  other packet 1 decisions remain in force.
- The packets explicitly say no unresolved question blocks promotion. Failure
  to prove private exact-head read-only review is a stop condition, not a
  reason to restore a review workspace or dilute the gate.
- **Report after:** the complete projection diff and required validation, or
  immediately on a stop condition.
- **Report to:** the orchestrator/operator through Paseo finish notification.

## Suggested Next Move

Run the worker completion-protocol preflight before broad reads. Read the
tracked handoff, `AGENTS.md`, the two packets, and the named canonical refs.
Apply only the exact promotion map, validate, try to falsify the diff against
the packet, commit, push, and open a PR. Do not merge.

## Completion Protocol

1. Before broad reads, run `git rev-parse --show-toplevel`,
   `git branch --show-current`, `git status --porcelain`, and
   `git worktree list --porcelain`. Accept only a clean, registered,
   non-`main` launcher worktree; record its actual path and branch.
2. From that worktree run
   `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes" git fetch origin`.
   Confirm `HEAD == origin/main`, confirm `git merge-base --is-ancestor
   5ef7a99 HEAD`, and confirm this handoff exists in `HEAD`. Load the tracked
   blob with `git show HEAD:docs/handoffs/20260904-101035-promote-chatterbox-planning-private-review.md`.
   Stop if the tracked blob differs from this absolute dispatch file.
3. Confirm the worktree is clean and the worker branch is not `main`. Do not
   clean, reset, stash over, or discard anything.
4. Read the named packets and canonical refs. Apply only the listed paths and
   stop on the listed ambiguity conditions.
5. Run the required validation, enumerate universal/exact/negative claims,
   exercise every packet review-oracle counterexample, and reconcile the
   changed docs against the packets. Remove temporary diagnostics.
6. Commit the bounded projection, push the worker branch, and open a PR
   against current pushed `main`. Link both packets, the named canonical refs,
   changed paths, evidence, validation, and unresolved items in the PR body.
7. Notify the orchestrator with the PR URL, exact head SHA, changed files,
   validation results, and any blocker. Do not merge.

### Review and merge lease

After the worker finishes, the orchestrator must pause the worker and verify
the existing worker workspace is on the exact PR head with a clean index and
tracked worktree and no Git operation active. Only then may it create the
private review child through the orchestrator's agent-scoped call with this
same worker `workspaceId`, `notifyOnFinish: true`, and visible normal-tab
placement. The reviewer must inspect the checked-out exact head read-only,
post a durable provider verdict naming that exact head, and finish before the
workspace lease returns to the worker. No review-only workspace, coordinator
workspace fallback, checkout, branch change, tracked-file edit, commit, push,
or direct worker contact is allowed. A requested-changes revision repeats the
clean-boundary, same-workspace lease, and fresh exact-head verdict cycle.

The orchestrator independently verifies the coordination gate only: accepted
verdict names the current exact head; blocking findings are resolved or
superseded; required checks pass; base and ancestry are acceptable; the PR is
mergeable; and no stricter rule or operator pause applies.

### Closeout refs

Update card/milestone/log/front-door state only through the orchestrator's
post-merge closeout. The worker must not invent a card or claim readiness.
