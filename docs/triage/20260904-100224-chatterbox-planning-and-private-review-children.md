# Chatterbox planning and private review children

Status: decision-ready; operator-confirmed
Disposition: route through the operator-confirmed promotion lane

## Issue

The economical coordinator split still leaves two expensive or intrusive jobs
in the wrong place.

First, current decision-ready Chatterbox notes name affected authority surfaces,
then require the Luna coordinator to compile an exact promotion brief. Turning a
planning discussion into exact destinations, sequencing, acceptance intent, and
runway structure can require semantic choices. The coordinator is meant to be a
mechanical manager, not the final planner.

Second, the coordinator currently creates a separate Paseo workspace for every
independent PR reviewer. Those review workspaces crowd the operator's sidebar
even though the reviewed work already has its own worker workspace.

These are one role-boundary issue: material discovery and judgment should sit
with the operator-facing planning role and independent reviewers; the
coordinator should retain mechanical routing and gates without accumulating UI
or semantic ownership.

## Operator-confirmed decisions

- Chatterbox is the evolution of the conversational planning delegate, not its
  sibling.
- Chatterbox becomes Northstar's single operator-facing surface for material
  discovery and planning, including research tranches and runway planning.
- Retire the separate conversational planning-delegate path rather than keeping
  two overlapping operator-facing planning roles.
- Chatterbox owns the important planning work: problem discovery, alternatives,
  evidence synthesis, decisions, non-goals, dependency reasoning, runway shape,
  acceptance intent, and exact promotion deltas.
- Chatterbox may initiate bounded read-only research subagents. They return
  evidence to Chatterbox; they do not contact the operator, write repository
  files, create workspaces or worktrees, or make planning decisions. Chatterbox
  reconciles their results.
- Chatterbox remains unable to promote, implement, review, or merge. It never
  directly promotes, including for small changes.
- Operator confirmation makes the packet eligible for promotion. It does not
  make the triage file a second canonical planning spine.
- The coordinator performs mechanical completeness, current-state checks,
  dispatch, routing, identity retention, state reconciliation, merge-gate
  verification, merge, and closeout. It does not supply missing product meaning,
  choose canonical ownership, design sequencing, or invent acceptance policy.
- Independent PR reviewers are private child agents of the coordinator in the
  coordinator's existing workspace. Do not create a separate Paseo workspace or
  sidebar entry for a reviewer.
- A private reviewer inspects the exact PR base/head and canonical context
  read-only. It must not check out the PR, change branches, mutate the
  coordinator checkout, or edit the worker branch. Its durable provider verdict
  must still name the exact reviewed head.
- If a private reviewer cannot inspect the exact head and complete the required
  review without workspace or checkout mutation, stop and report the review as
  unroutable. Do not silently create a review workspace or weaken the exact-head
  gate.

## Execution-ready packet contract

The Chatterbox output is a transient **promotion envelope**, not a miniature
copy of Northstar's architecture/spec/roadmap/card hierarchy. It records only
the delta needed to project operator-confirmed meaning into that hierarchy:

1. confirmed decisions and accepted uncertainty;
2. an exact canonical destination map: path, create/edit action, and required
   semantic state transition for each destination;
3. proposed runway nodes, readiness intent, dependencies, and ordering;
4. non-goals and forbidden interpretations;
5. blocking questions and operator-accepted deferrals, each with impact and a
   reopen trigger;
6. acceptance assertions and fidelity-review questions;
7. the source note's post-promotion disposition: remove, split, or retain only
   unresolved residue;
8. an explicit operator-confirmation record covering the decisions and
   deferrals being promoted.

Exact canonical prose, standard document boilerplate, branch names, SHAs,
worker identities, PR metadata, and merge bookkeeping do not belong in the
envelope. The projection worker owns faithful wording and structure inside the
named destinations. The coordinator may add only mechanical transport data and
deterministic validation commands.

A packet is not dispatchable when a destination, dependency, acceptance
assertion, source-note disposition, or material question remains semantically
undetermined. The coordinator returns it to Chatterbox and the operator rather
than completing it by judgment. A deferred question is allowed only when the
operator explicitly accepts its exclusion and no promoted decision depends on
its answer.

## Promotion sequence

1. Chatterbox explores directly with the operator and may run bounded read-only
   research tranches.
2. Chatterbox reconciles the evidence and writes the promotion envelope in a
   unique triage note.
3. The operator explicitly confirms the envelope's material meaning and any
   deferrals.
4. The coordinator checks only field completeness, destination existence or
   valid creation paths, current-main conflicts, dependency availability, and
   mechanical routability.
5. The coordinator dispatches a bounded planning-projection worker in a normal
   branch/worktree/PR lane. The worker edits only named canonical surfaces and
   stops on semantic ambiguity.
6. A private independent review child checks the exact PR head against the
   confirmed envelope and posts a durable provider verdict naming that head.
7. The coordinator verifies the exact-head verdict, resolved findings, required
   checks, base ancestry, mergeability, and operator pauses, then merges and
   closes out mechanically.

Implementation workers continue to receive isolated workspaces. The no-new-
workspace rule applies to review children, not implementation or bounded
planning-projection workers.

## Canonical destination map

Promotion should update the following authority surfaces together. Exact
section placement is a projection concern; the semantic deltas are fixed here.

| Destination | Required delta |
| --- | --- |
| `docs/specs/035-chatterbox-intake-channel.md` | Evolve Chatterbox from intake-only problem identification into the single operator-facing discovery and planning role; allow bounded read-only research tranches and promotion-envelope/runway planning; preserve unique-triage-write and no-direct-promotion boundaries. |
| `docs/specs/036-economical-orchestrator-coordination.md` | Make the coordinator's promotion brief compilation mechanical from a complete operator-confirmed envelope; remove semantic completion by the coordinator; replace dedicated reviewer workspaces with private read-only review children in the coordinator workspace. |
| `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md` | Remove the separate planning-delegate route and state; route material planning through Chatterbox; revise reviewer transport without weakening independent exact-head review. |
| `docs/contracts/001-working-rules.md` | Freeze the promotion-envelope completeness gate, Chatterbox research/planning authority boundary, mechanical coordinator boundary, and no-review-workspace rule. |
| `docs/architecture/system-architecture.md` | Replace the planning-delegate topology with Chatterbox-to-confirmed-envelope-to-projection flow; show private reviewer children without dedicated workspaces. |
| `docs/architecture/system-inventory.md` | Remove planning delegate as a separate component/capability; expand Chatterbox's planning responsibility; update review-child ownership and transport. |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | Update reusable doctrine for Chatterbox-owned material planning, promotion envelopes, mechanical coordination, and private review children. |
| `bundle-docs/operators/operator-quick-start.md` | Present Chatterbox as the normal discovery/research/runway-planning conversation and remove reviewer-workspace instructions. |
| `bundle-docs/glossary.md` | Define Chatterbox and promotion envelope consistently with the evolved role; remove obsolete planning-delegate terminology where owned here. |
| `template-bundle/contracts/001-working-rules-template.md` | Carry the reusable contract changes into the copy-ready template without Northstar-specific examples. |
| `template-bundle/policy/internal-writing-style.md` | Keep the coordinator/chatterbox role wording aligned if the current planning split is named there. |
| `skills/northstar/SKILL.md` | Route discovery, research synthesis, and runway planning to Chatterbox; remove planning-delegate entrypoints and dedicated-review-workspace claims. |
| `skills/northstar/references/router.md` | Collapse planning-delegate routing into Chatterbox while preserving explicit worker, orchestrator, and direct-review precedence. |
| `skills/northstar/references/modes/chatterbox.md` | Define research-tranche dispatch, promotion-envelope planning, operator confirmation, and categorical no-promotion/no-implementation/no-review/no-merge stops. |
| `skills/northstar/references/modes/orchestrator.md` | Accept only complete confirmed envelopes, perform mechanical promotion routing, remove planning-delegate procedure, and launch reviewers as private children without creating review workspaces. |
| `skills/northstar/references/modes/pr-review.md` | Support exact-head read-only review from a private child in the coordinator workspace; forbid checkout/workspace mutation and retain provider-verdict requirements. |
| `skills/northstar/assets/templates/northstar-discovery-delegate.md.template` | Remove the superseded planning-delegate template and all live references in the same promotion batch. |
| `docs/README.md` and owned roadmap/front-door indexes | Reflect the promoted contract and sequence its implementation without claiming completion before evidence exists. |

The projection worker should use exact-token search to find derived parity and
validation surfaces that directly encode the changed role names or workspace
shape. Finding an additional semantic authority destination is not mechanical:
stop and return it for operator confirmation. Deterministic source/install
parity updates are mechanical once their canonical source paths are named.

## Non-goals

- no canonical planning edits from Chatterbox;
- no direct Chatterbox promotion, implementation, PR review, or merge;
- no implementation-worker or projection-worker workspace changes;
- no weakening of independent review or the exact-head provider verdict;
- no coordinator fallback into material planning or semantic review;
- no permanent duplicate of promoted planning in `docs/triage/`;
- no requirement for exact draft prose in a promotion envelope;
- no new public Northstar skill or separate renamed planning role;
- no Paseo product change unless private child agents cannot access the required
  read-only PR evidence through the existing agent-scoped launch surface.

## Sequencing and dependencies

- Treat this as one contract migration. Update callers and remove superseded
  planning-delegate surfaces together; do not leave compatibility aliases.
- Settle the contract/spec/architecture/doctrine changes before compiling the
  implementation card and marking any new lane ready.
- Update Chatterbox routing and packet behavior before making coordinator
  compilation reject incomplete envelopes.
- Update private-review transport and its review oracle together so removal of
  review workspaces cannot weaken exact-head fidelity.
- Preserve current worker and promotion worktree isolation throughout.
- Source/install parity follows the source skill change in the same delivery
  batch required by repository policy.

## Acceptance evidence

- A Chatterbox scenario can explore a material feature, launch two bounded
  read-only research tranches, reconcile their evidence, propose a dependency-
  ordered runway, and emit a complete promotion envelope without editing a
  canonical surface.
- A negative scenario proves a coordinator rejects a packet that names only
  affected surfaces or leaves sequencing, acceptance, or a material question
  undecided.
- A promotion scenario proves the coordinator adds only mechanical transport
  data and the projection diff maps every semantic change to a confirmed packet
  item.
- An independent reviewer flags invented, omitted, reinterpreted, or misrouted
  meaning and posts a verdict naming the exact PR head.
- A Paseo launch assertion proves review children are private parent-attached
  subagents in the coordinator's existing workspace and no review workspace is
  created.
- A read-only review fixture proves the reviewer can inspect the exact base/head
  and canonical context without checkout, branch change, worktree creation, or
  repository mutation.
- A negative review scenario stops when exact-head evidence is unavailable; it
  neither creates a workspace nor accepts stale or partial evidence.
- Existing worker-workspace, review independence, notification, revision-
  routing, provider-verdict, merge-gate, Chatterbox exact-file Git isolation,
  command/router, bundle, and source/install parity checks still pass.
- `git diff --check`, `effigy check:chatterbox-git`,
  `effigy check:command-skills`, `effigy check:repo-contract`,
  `effigy check:model-routing`, `effigy qa:docs`, and `effigy qa` pass for the
  eventual promotion batch.

## Unresolved questions

None block promotion. The implementation must prove that a private child can
obtain exact-head read-only evidence through existing Paseo and provider/Git
surfaces. Failure is a stop condition, not permission to restore automatic
review-workspace creation or dilute the review gate.

## Alternatives rejected

- **Keep Chatterbox and planning delegate as siblings.** This leaves the
  operator choosing between an intake role and the role that performs the real
  planning, and gives the coordinator room to finish semantics between them.
- **Require a mini spec/roadmap/card set inside triage.** This duplicates the
  Northstar spine. The envelope records semantic deltas and runway structure,
  then disappears or retains only unresolved residue after promotion.
- **Let the coordinator infer the exact brief.** Exact destinations,
  dependencies, non-goals, and acceptance intent are material planning.
- **Allow tiny direct promotions from Chatterbox.** A categorical no-promotion
  boundary is easier to route and audit.
- **Keep dedicated reviewer workspaces hidden or periodically clean them up.**
  This treats sidebar accumulation rather than removing the unnecessary
  workspace topology.
