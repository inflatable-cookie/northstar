# 027 - Northstar Native Pre-Execution Discovery

Status: active
Owner: repo maintainers
Created: 2026-08-16
Updated: 2026-08-17
Related research: `bundle-docs/research/translation-memos/matt-pocock-skills-audit-to-northstar.md`
Governing architecture: `docs/architecture/system-architecture.md`
Governing contract: `docs/contracts/001-working-rules.md`

## Problem

Northstar has a strong docs spine and an increasingly strict execution boundary,
but a material project can still move from a broad idea to a plausible spec before
its destination, domain language, architecture, decision dependencies, and
operator-owned intent are genuinely settled.

The resulting code is often not wrong in a local sense. It is premature: the
project starts building while important decisions are still hidden in conversation,
assumed from context, or left to the worker. Northstar needs a deliberate
pre-execution discovery phase that is deeper than ordinary planning but remains
inside the existing repository authority model.

## Destination

Provide a Northstar-native workflow for taking a new or materially ambiguous
project from an unbounded idea to a bounded, decision-backed spec without using an
external issue tracker and without allowing the discovery map to authorise its own
execution.

## Goals

- define a docs-native readiness map for work larger than one planning session;
- make destination, scope, unresolved decisions, dependencies, and accepted
  uncertainty explicit;
- add a reusable intent-rounds question mechanism;
- distinguish facts the environment can answer from decisions the operator owns;
- support research, decision prototypes, and operator questionnaires as distinct
  routes;
- preserve one canonical decision record instead of duplicating decisions across
  maps, prompts, specs, and handoffs;
- compile a cleared map into the existing spec, promotion, roadmap, and batch-card
  chain;
- add deterministic checks for dependency integrity, frontier calculation, and
  plan-only boundaries;
- [x] add an architecture-refocus review for active code and seams;
- [ ] improve operator comprehension with a small non-mutating reframe route;
- keep the entire protocol provider-neutral and starter-bundle friendly.

## Non-goals

- another public installable Northstar skill;
- reuse of external skill names or tracker terminology as Northstar concepts;
- replacing the existing vision, architecture, contracts, specs, roadmaps, logs, or
  handoff surfaces;
- automatic cross-session messaging;
- parallel write-heavy agents in one active lane;
- a permanent report for every architecture scan;
- implementation directly from an uncleared readiness map;
- treating the agent's own map notes as authority to weaken plan-only mode.

## Northstar vocabulary

Use these names in the Northstar workflow and starter surfaces:

| Term | Meaning |
| --- | --- |
| Readiness mapping | Multi-session discovery of decisions required before a bounded destination can enter execution planning. |
| Intent rounds | Breadth-first questions over the current decision frontier. |
| Project language | Controlled vocabulary, authority terms, and rejected ambiguities for the project. |
| Decision prototype | Throwaway evidence used to settle a question conversation cannot settle. |
| Architecture refocus | Active-lane architecture review that produces candidates without editing code. |
| Reframe | Clearer restatement of the previous message using project language. |

## Artifact model

The workflow must use existing docs authority surfaces:

- active readiness map and linked decisions under `docs/specs/`;
- research findings under the project's research surface when research is needed;
- durable structure under `docs/architecture/`;
- durable policy and boundary rules under `docs/contracts/`;
- executable plans under `docs/roadmaps/` and batch cards;
- evidence under `docs/logs/`;
- thread continuation under `docs/handoffs/`.

### Batch 26.1 readiness-map contract

For a bounded destination named `<destination-slug>`, use:

```text
docs/specs/<destination-slug>/README.md
docs/specs/<destination-slug>/decisions/<decision-id>-<slug>.md
```

The map is Markdown with YAML frontmatter containing `kind: readiness-map`,
stable `id`, `title`, `destination`, `owner`, `status`, `master_spec`, and
`roadmap`. Map status is `active`, `cleared`, or `paused`. Its required index
sections are `## Destination`, `## Decision index`, `## Current frontier`, and
`## Readiness gate`. The decision index links each record and may summarise
state or blockers; it does not duplicate canonical rationale.

Each decision record is Markdown with YAML frontmatter containing stable `id`,
`kind: decision|research|prototype|task`,
`mode: operator|research|prototype|task`,
`status: open|in-progress|resolved|out-of-scope`, `title`, `owner`, `authority`,
and `blocked_by`. `blocked_by` uses stable decision IDs and is empty when there
are no blockers. A resolved record exposes exactly one of
`resolution_evidence` or `accepted_uncertainty`.

Map and record IDs are stable lowercase kebab-case values, unique within the
destination. A record filename begins with its exact ID followed by a
human-readable slug. Relative links stay inside the destination subtree or
point to named canonical docs surfaces: the governing spec, architecture,
contract, roadmap, or log. The map is an index, not a second rationale store;
operator-owned decisions cannot be resolved by agent inference; and research,
prototype, and task records remain distinct from operator decisions.

## Operating model

1. Inspect repository authority, current docs posture, and existing project language.
2. Establish a bounded destination and success conditions.
3. Run intent rounds to expose independent unknowns.
4. Resolve facts through repository inspection, deterministic commands, or bounded
   research; do not ask the operator questions the environment can answer.
5. Ask the operator to resolve operator-owned decisions. Recommendations are
   allowed; silent substitution is not.
6. Record every material decision once and recompute the open frontier.
7. Route unresolved questions to research, decision prototypes, or questionnaires
   when conversation alone is the wrong instrument.
8. Stop early when the destination has no material fog and ordinary planning is
   sufficient.
9. When the frontier is clear, produce or update the master spec and promote
   durable outcomes before compiling the roadmap.
10. Mark only cards that satisfy the existing ready-state rubric as executable.

## Plan-only authority

Readiness mapping is plan-only by construction. The map cannot override that rule.
The agent must not:

- edit production code;
- mark an operator-owned decision resolved without operator evidence;
- turn a research result into an implementation instruction without promotion;
- create a ready card while an unresolved decision or intent checkpoint governs its
  scope;
- treat a map note, conversation summary, or worker preference as an authority
  change.

The only transition into implementation planning is an explicit operator-owned
readiness decision represented in the repository by the resulting spec and its
promotion/roadmap state.

## Frontier rules

A decision is on the frontier when it is open, not out-of-scope, not claimed by an
active planning session, and every blocking decision is resolved. A research item
may be delegated when it has a complete question and source boundary. An
operator-owned or prototype-owned decision remains blocked until the live exchange
or evidence round returns.

The first implementation should calculate the frontier deterministically from
repository files. It must report missing references, cycles, orphan decisions, and
invalid states rather than guessing.

## Architecture refocus

Architecture refocus is a separate planning route, not an implementation route. It
should scope itself to an active lane or named area, inspect current architecture,
contracts, tests, recent changes, and papercuts, then produce a small candidate set.
The initial report is ephemeral by default. A selected candidate enters readiness
mapping, research, a decision prototype, or a normal spec only when it earns that
promotion.

The default output must be Markdown or self-contained HTML. It must not require a
network-loaded CDN to be useful or verifiable.

## Reframe

Reframe is a non-mutating communication route. It restates the previous message in
clearer language, uses the project's project-language terms, identifies a missing
premise when possible, and does not change planning state or silently alter scope.

## Handoff integration

The existing durable handoff contract remains authoritative. Add only optional
fields for:

- handoff purpose: fresh thread, new harness, new worktree, side task, or operator
  takeover;
- target outcome for the next session;
- suggested Northstar mode or references.

Do not replace `docs/handoffs/` with temporary transit files or automatic provider
messaging.

## Acceptance criteria

- a new readiness map can be created under the existing docs spine without an
  external tracker;
- the map and decision records use the Northstar vocabulary above;
- frontier output is deterministic and detects invalid dependency state;
- operator-owned decisions cannot be silently resolved by the agent;
- a no-fog project exits without a heavyweight map;
- a cleared map compiles into a normal Northstar spec and roadmap path;
- architecture refocus produces no code changes and is offline-safe;
- reframe changes no repository state;
- handoff additions preserve the current worker/PR contract;
- starter templates and checks remain copy-ready;
- operator-provided live-use evidence measures planning revisions, reopened
  decisions, implementation rework, and operator correction burden.

## Planned batches

1. Define the readiness-map and decision-record contract plus deterministic checks.
2. Add intent rounds, project language, decision-prototype, and questionnaire routes.
3. Add the routed Northstar procedures and starter-bundle templates.
4. Add architecture refocus and reframe, then consume operator-provided feedback
   from live use of the complete flow.

## Resolved decisions for Batch 26.1

- Readiness maps and their canonical decision records use bounded destination
  subdirectories under `docs/specs/`:
  `docs/specs/<destination-slug>/README.md` and
  `docs/specs/<destination-slug>/decisions/<decision-id>-<slug>.md`.
- Both surfaces use Markdown with YAML frontmatter and explicit relative links.
- The map frontmatter requires `kind: readiness-map`, stable `id`, `title`,
  `destination`, `owner`, `status: active|cleared|paused`, `master_spec`, and
  `roadmap`; its required sections are `Destination`, `Decision index`,
  `Current frontier`, and `Readiness gate`.
- Decision records require stable `id`, `kind`, `mode`, `status`, `title`,
  `owner`, `authority`, and `blocked_by`; resolved records expose exactly one
  of `resolution_evidence` or `accepted_uncertainty`.
- IDs are stable lowercase kebab-case values unique within the destination;
  `blocked_by` uses those IDs; links stay inside the destination subtree or
  target named canonical docs surfaces.
- The map is an index and summary surface, not a second rationale store.
  Operator-owned decisions cannot be resolved by agent inference, and research,
  prototype, and task records remain distinct from operator decisions.

## Resolved decisions for Batch 26.2

Northstar does not own a consumer-dogfood sequence. The operator dogfoods live
outside Northstar's execution loop and brings the resulting feedback into this
conversation as evidence, papercuts, or planning input. Northstar may inspect
consumer-repository evidence that the operator cites, but it does not select
consumer targets, prepare dogfood handoffs, dispatch consumer workers, or manage
Poodle/Figmatic execution from this lane. Earlier Poodle/Figmatic sequencing
notes are historical and do not govern current planning.

Project language is local by default:

- glossary surfaces own stable cross-project preferred terms and synonyms;
- architecture owns structural concepts and system boundaries;
- contracts own authority terms, behavioural meanings, and explicitly rejected
  ambiguities;
- a destination-local project-language surface owns project-specific preferred
  terms, aliases, meanings, authority, status, and rejected ambiguity;
- a stable local term may be promoted to the global glossary, but local wording
  does not become global doctrine automatically;
- readiness records own destination-specific decisions without silently promoting
  them into global vocabulary.

The four Batch 26.2 routes are bounded as follows:

1. **Intent rounds** ask a small, breadth-first set of questions over the live
   decision frontier. The route resolves repository-answerable facts first, links
   each question to a canonical decision record, and stops when the remaining
   unknowns are answered, routed, accepted as non-material, or explicitly left as
   accepted uncertainty. It is not an exhaustive questionnaire.
2. **Project language** provides the destination-local vocabulary surface. It is
   linked from the readiness map and cannot resolve a decision or grant authority.
3. **Decision prototypes** are throwaway, question-specific evidence. They record
   the question, hypothesis or options, bounded scope, evaluation method,
   evidence, verdict, limitations, and promotion target. They may inform a
   decision but cannot resolve an operator-owned decision or edit production code
   through the route.
4. **Questionnaires** preserve operator-owned questions across turns or sessions
   in the canonical decision record. They record context, constraints, options or
   recommendation, operator response, authority, and unresolved state. They do
   not use an external tracker or silently substitute an agent answer.

All four routes are provider-neutral, plan-only, non-mutating by default, and
must leave a traceable path back to the readiness map and canonical decision
records. No route can mark a map cleared, make a card ready, or bypass normal
spec, promotion, roadmap, or operator gates.

## Resolved decisions for Batch 26.3

The starter-surface worked example uses Poodle's historical card
`g15.006 — React Mirror Implementation and Gallery Closure`. It is a bounded,
repository-backed example of the discovery and promotion path, not a live
dogfood target or a change to the Poodle repository. It does not create or
require a live consumer handoff; operator feedback is brought into Northstar
separately when it is useful evidence.

The example's destination-local project language includes:

- release denominator;
- measured gap;
- React mirror;
- focused evidence;
- gallery specimen;
- active cohort; and
- deferred backend.

These terms remain local to the Poodle example. Each entry records aliases,
meaning, authority, status, and rejected ambiguity; none becomes global
Northstar vocabulary automatically.

The cleared-map promotion path is explicit and non-automatic:

1. inspect the destination's current canonical docs;
2. establish or repair the linked readiness map and decision records;
3. resolve repository facts and route operator-owned questions separately;
4. recompute and validate the deterministic frontier;
5. write a promotion record linking the cleared map, evidence, master-spec
   target, roadmap target, and operator gate;
6. promote durable outcomes through normal architecture/contracts/spec surfaces;
7. update roadmap/card status only after normal validation and authorization.

The Poodle example must show this path without applying it to Poodle. Poodle's
existing Effigy doctor findings are baseline board-health findings and must not
be presented as new Batch 26.3 failures.

## Current implementation state

The architecture-refocus and reframe portions of Batch 26.4 are implemented.
Architecture refocus is the read-only, offline-safe `northstar architecture
refocus` route. It produces candidate improvements without editing production
code or granting execution authority. Reframe is the concise, read-only
`northstar reframe` route; it restates the current request without adding
decisions, scope, or authorization. Live dogfooding is an operator-owned
activity; Northstar consumes its feedback rather than scheduling it.

## Next task

The Batch 26.3 starter-surface planning checkpoint is complete. Card
`g02.026/078` remains ready but deferred. Its `g15.006` material is a historical
worked example. When the operator brings live dogfood feedback into Northstar,
record or promote that evidence through the normal planning surfaces. Keep
consumer-dogfood orchestration out of card 078.
