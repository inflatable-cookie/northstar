# 038 - Compact Default Lifecycle and Generation Roll-up

Status: active; approved for implementation
Owner: repo maintainers
Created: 2026-09-04
Governing architecture: `docs/architecture/system-architecture.md`
Governing contracts: `docs/contracts/001-working-rules.md`
Roadmap: `g03.001`

## Decision

Northstar has one normal operating posture: the compact strict lifecycle.
The former light, baseline, lane-first, mixed, and full-strict postures are no
longer alternative steady states. A repo may adopt the lifecycle incrementally,
but migration state is not a second protocol.

The live docs tree is working memory. Git and provider records retain historical
artifacts. Northstar preserves operational capability and material provenance,
not every intermediate planning file at `HEAD`.

## Problem

Northstar's safety and authority boundaries work, but completed transport and
execution artifacts accumulate indefinitely. The Northstar repo currently has
hundreds of roadmap, card, log, and handoff files. Current front doors repeat
historical narratives, completed generations remain fully expanded, and old
procedural text stays in normal search paths.

That increases agent reading cost, currentness drift, maintenance work, and the
chance that superseded instructions are mistaken for authority.

## Required capabilities

Compaction must preserve the ability to:

- find current authority and the active runway;
- understand present intent and important prior decisions;
- dispatch decision-ready work with explicit dependencies and parallelism;
- recover every unresolved or deferred commitment;
- trace material delivery to PRs, commits, releases, and validation evidence;
- explain current state, why it exists, and what comes next without loading an
  archive.

Keeping every intermediate artifact in the live tree is not a required
capability.

## Artifact lifecycle

Every planning artifact belongs to one lifecycle class and has a default
disposition:

| Class | Examples | Live-tree rule | Disposition trigger |
| --- | --- | --- | --- |
| durable authority | vision, architecture, contracts | retain while authoritative | replace or delete with all callers when superseded |
| active execution | active roadmap, ready/in-flight cards | retain only while actionable | fold outcome/evidence into closure, then generation roll-up |
| transient transport | triage, worker handoffs, questionnaires | retain only while carrying unresolved or unconsumed meaning | delete after promotion, consumption, abandonment, or transfer |
| exceptional evidence | releases, incidents, material migrations | retain when the evidence itself remains operationally useful | roll up only when its durable value is preserved |
| derived currentness | indexes, status tables, navigation projections | generate, bound, or remove | rebuild from canonical current state |

Normal delivery evidence belongs on the completed card: outcome, validation,
PR, commit, and material limits. A separate log is justified only for an
incident, release, migration, cross-lane decision, or evidence set too large to
keep the card legible.

Consumed worker handoffs are deleted after merge, abandonment, or ownership
transfer once any durable outcome has moved to the card or canonical docs.
Promoted specs are removed or reduced to a non-procedural tombstone only when a
stable external reference requires it. Superseded executable-looking prose must
not remain in the default read path.

## Generation closure and roll-up

A generation closes when its sequencing era ends. Passive observations and
future feedback requests move to the next generation's bounded watchlist; they
do not hold the old generation open.

Before compaction, the generation closure record must establish:

1. no milestone or card remains executable in the old generation;
2. durable decisions have canonical destinations;
3. unresolved and deferred work has an active destination or explicit removal;
4. current links and front doors no longer depend on files being removed;
5. material delivery remains traceable to selected PRs, commits, releases, or
   retained evidence;
6. the preservation oracle below passes.

After that gate, replace the expanded `docs/roadmaps/gNN/` tree with one
non-authoritative `docs/roadmaps/archive/gNN.md` roll-up and remove its routine
logs and consumed handoffs. The roll-up contains only:

- generation intent and boundary;
- shipped outcomes grouped by durable capability;
- current canonical destinations for lasting decisions;
- material migrations, compatibility limits, and retained risks;
- deferred/unresolved items and their new destinations;
- selected PR, commit, release, and validation references;
- the succeeding generation.

It must not reproduce old steps, card instructions, detailed status narration,
or superseded protocol. Git remains the full-fidelity archive.

## Currentness budget

Default-read surfaces describe current authority, the active runway, the
approved frontier, bounded watch items, and recent governing evidence only.
They do not narrate completed lanes.

Implementation should establish a deterministic structural check that rejects:

- more than one expanded sequential generation;
- an active front door pointing at an archived execution instruction;
- completed handoffs retained without an explicit exceptional-evidence reason;
- repeated historical lane narration in current roadmap indexes;
- posture labels that imply multiple supported steady-state protocols.

The check should prefer stable paths, states, and link relationships over prose
snapshots or arbitrary line-count scoring.

## Northstar migration

`g03` starts this lifecycle in the Northstar repo:

1. establish the lifecycle contract and compact `g01` as the pilot;
2. compact closed `g02`, prune its routine logs and consumed handoffs, and make
   all current front doors `g03`-only;
3. make the compact lifecycle the reusable default and remove posture variants
   from doctrine, templates, skills, setup, and deterministic checks.

Northstar's pre-`g03` specs have these retention destinations:

| Specs | Durable/current destination | `g03.001` disposition |
| --- | --- | --- |
| 001-025 and existing archive | architecture, contracts, bundle doctrine, Git history | remove after current-link and unique-meaning proof |
| 026, 035, 036 | superseded by 037 and its promoted contract/skill behavior | remove |
| 027 | discovery and planning skill modes plus working-rules gates | remove after parity proof |
| 028 | contract 003 and AGENTS review surfaces | remove |
| 029 | Atlas mode and routed command | remove; keep feedback request on watchlist |
| 030 | triage/cleanup modes and working-rules lifecycle | remove; keep feedback request on watchlist |
| 031-034 | architecture, contract 004, registry, and installed language packages | remove after package identity links are retained |
| 037 | working-rules contract, architecture, and Chatterbox/coordinator/review modes | remove after exact semantic parity proof |
| 038 | active `g03` planning | retain until this lifecycle is durably promoted and `g03.001` closes |

After the lifecycle is proven, later `g03` planning may consolidate overlapping
modes and repeated protocol enumerations. That later work is not authority to
merge distinct workflows before observed behavior proves them redundant.

## Non-goals

- no loss of current authority, ready work, unresolved commitments, or material
  delivery provenance;
- no age-only deletion rule;
- no backfilling historical repos to satisfy a new file shape;
- no generated currentness file that becomes a second source of truth;
- no permanent compact-versus-full posture split;
- no product/runtime implementation in the planning promotion.

## Preservation oracle

Each compaction lane must prove:

| Invariant | Counterexample that fails review | Evidence |
| --- | --- | --- |
| Current authority is unchanged or deliberately promoted. | A deleted file held the only current rule. | Before/after authority map and link check. |
| Every open commitment remains reachable. | Deferred work exists only in removed history. | Destination inventory. |
| Material outcomes remain traceable. | A lasting migration has no PR, commit, release, or evidence reference. | Roll-up evidence table. |
| Historical procedure cannot be mistaken for current authority. | An archive contains runnable steps or active status. | Archive-content review. |
| Current work is legible without archive reads. | The next lane or dependency requires opening a roll-up. | Fresh-reader current-state check. |
| Deletion is exact and reviewable. | A broad cleanup removes an unclassified file. | Frozen deletion manifest and diff review. |

## Unresolved questions

None block the first implementation frontier. Exact archive formatting and
checker implementation are worker choices only where they preserve this
contract and the card-specific review oracle.
