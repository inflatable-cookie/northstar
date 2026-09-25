# 041 — Project knowledge currentness

Status: discovery
Owner: operator + Northstar Chatterbox
Created: 2026-09-25
Execution authority: none. Approved mechanisms become `g04` tasks; this spec
keeps the evidence and the unresolved options.

## Problem

Consumer repositories grow into thousands of Markdown files, and agents act on
stale or missing knowledge. They re-ask settled questions and plan work against
concepts that were retired months ago. Northstar was meant to prevent this. In
its current form it adds surfaces that restate each other, so it produces some
of the staleness itself.

A decisions folder does not fix it. A decision is history. The spec,
architecture or contract it changed is the current truth, and a second
chronological layer is one more thing to fall out of date.

## Evidence

Three cases, all observed on 2026-09-24 and 2026-09-25. They are this spec's
fixtures: any proposed mechanism must say how it would have caught each one.

### F1 — A retirement that named nothing it retired (acowtancy seed bundles)

- On 2026-08-21, `docs/contracts/legacy-coexistence-and-transition.md` stated
  that seed bundles are not a content path.
- The artefacts that ran the old model did not change: the state manifest
  (`state/acowtancy.state.toml`) kept pinning a 2026-06-19 GHCR spine artifact;
  the bundle registry kept listing `spine` as a live family; and the SQL
  generator, the install hook and a runbook still described the old route.
- Five weeks later a fresh apply failed on that artifact. A lane was planned
  straight from the failure and framed as a spine-bundle repair. Only then was
  the retirement restated. A same-day audit found about twenty live artefacts
  still built on the retired model.
- Failure class: agents act on what runs, not on a contract sentence. The
  retirement had no link to the files it invalidated, so nothing could check
  them.

### F2 — An answer that never reached the repository (acowtancy mock exams)

- The operator answered the mock-exam questions (fixed timer, resume after a
  disconnect, pass marks from the exam bodies) in conversation. `git log -S`
  shows none of those answers in any committed file before 2026-09-25, when
  they were recorded as "restating earlier rulings".
- A 2026-09-08 triage note still listed mock composition and pass marks as
  questions to decide, so the agent re-asked them correctly from the state of
  the repository.
- Operator rulings sat in at least five homes: a chronological decision
  register, a task card that carries numbered operator decisions, contracts,
  a workstream table, and 37 triage notes, among 2,364 Markdown files.
- Failure class: nothing makes a conversational ruling land in its owning
  surface, and an open question is prose that lingers, not an item that
  closes.

### F3 — Hand-written prose drifting from generated state (Northstar)

- After `g03.022` closed, Northstar's own runway row and generation index still
  called it "approved and ready". A monkey front door still names a terminal
  task as its approved frontier. A Chatterbox continuation brief described the
  front doors as accurate when they were not.
- The generated lifecycle blocks were correct in every case. Every error was in
  prose that restated state owned elsewhere.
- Failure class: restatement without a source link. Northstar already solves
  this for task status, through generated projections, and nowhere else.

## Prior art

Checked from knowledge as of mid-2026; verify current state before design work.

| Need | Prior art | Mechanism worth borrowing |
| --- | --- | --- |
| One home per fact, referenced by ID | sphinx-needs, StrictDoc, Doorstop | Stable IDs, typed links, and *suspect links*: an upstream change flags its dependants for review. |
| Docs coupled to code | Swimm | Docs declare the code they describe; CI flags them when that code changes. |
| System and concept map | Structurizr / C4, LikeC4, Backstage catalog | A structured model of systems, components and relations, with views generated from it. |
| Decisions that cannot rot | Architecture fitness functions (ArchUnit, dependency-cruiser) | A decision expressed as a check that runs. |
| Facts that supersede facts | Graphiti (temporal knowledge graph) | Facts with validity windows, explicitly invalidated by newer ones. It is an opaque store, so the model is useful but it cannot be the repository's source of truth. |

None of these covers F2. Requirements tools assume questions are asked and
answered inside the tool, not in an agent conversation.

## Candidate mechanisms

Ordered by evidence and cost, not by preference.

1. **Retirements name their scope.** Each repository keeps a machine-readable
   list of retired concepts. Each entry records the replacement, the owning
   surface, and the terms, paths and config keys the retirement covers. A check
   scans code, config and live docs, and fails on a reference outside history
   or an explicit allowance. This catches F1, is cheap, needs no new store, and
   is the strongest first-slice candidate.
2. **Open questions are addressable and closable.** A question gets an ID and
   one home. An answer closes it by pointing at the surface that now owns the
   truth. Cards and triage notes reference question IDs instead of restating
   the question. This catches F2's re-ask, and gives agents a lookup before
   they ask.
3. **Promotion is enforced at the end of a Chatterbox turn.** A turn that
   receives an operator ruling must land it in its owning surface, or close a
   question, before it yields. Doctrine already says this and nothing enforces
   it. This catches the root of F2. Where it lives is the open question
   below.
4. **Generated front doors.** Front-door frontier and state prose is generated
   from lifecycle records and a small manifest, not written by hand. This
   extends the one mechanism that already works to cover F3.
5. **A knowledge manifest with suspect links.** Concepts, systems, components
   and contracts get stable IDs, one owning document each, and typed links.
   Nodes record the digests of what they depend on, so an upstream change
   marks dependants suspect. This is the fullest answer to "single sources of
   truth and linkages", and the most expensive. It catches none of today's
   fixtures on its own, so it should follow the evidence, not lead.

## Relationship to other work

- The Nucleus convergence note
  (`docs/triage/20260914-191142-queue-northstar-nucleus-convergence.md`) names
  project knowledge as a Nucleus concern. Mechanisms 1, 2 and 4 work on the
  current Markdown spine and do not wait for Nucleus. Mechanism 5 may belong to
  Nucleus.
- Northstar's `audit-currentness` is the natural host for mechanisms 1 and 4:
  it already runs at closeout and already blocks red repositories.

## Non-goals

- A decisions folder or register as a new canonical layer.
- An opaque knowledge store as the source of truth.
- Retrofitting every consumer before a mechanism has proven itself in one
  repository.

## Operator decisions

- 2026-09-25: mechanism 1 (retired-concept scope check) is the first slice,
  proven in acowtancy against its 2026-09-25 realignment register.
- 2026-09-25: this work opens `g04`
  ([`../roadmaps/g04/README.md`](../roadmaps/g04/README.md)).

## Open questions for the operator

1. Where enforced promotion (mechanism 3) lives. Recommendation: Northstar owns
   the rule, the record shape (a closed question, or a landed ruling that
   names its owning surface), and a check at Chatterbox handoff and refresh.
   The Queue/Chatterbox runtime can add a turn-end trigger later, but a rule
   that exists only in the runtime would not travel with the repository.

## Promotion path

Approved mechanisms become roadmap lanes. Their lasting rules go to contract
001 and the bundle doctrine, and their check behaviour to the lifecycle
reference. Remove this spec once that promotion is done.
