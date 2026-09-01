# Close Live Orchestrator Dogfood And Plan Validation Reduction

Date: 2026-09-01
Status: planning complete; implementation card ready
Roadmap: `g02.045`
Card: `g02.045/113`

## Outcome

The first-principles audit and passive live-orchestrator cohort are promoted
out of triage. Northstar's orchestration protocol remains frozen while one
bounded simplification lane tests whether repository validation can protect
structure without mirroring editorial prose.

The operator also settled two separate product decisions:

- Northstar remains a general-purpose system for other operators, repositories,
  layouts, and harnesses. Local convenience is evidence, not reusable policy.
- Language quality leaves the root payload over time. Core Northstar will route
  to compatible optional language packages; Rust and TypeScript are the first
  extraction candidates. Spec 034 owns that later planning lane.

## First-principles assessment

The audit kept the docs spine, ready-card grammar, evidence chain, and
worker/PR loop. It identified five simplification pressures:

1. protocol decisions amplify across too many duplicated surfaces;
2. the repository checker treats exact prose and historical paths as schema;
3. language-quality packs have become a second product inside the root skill;
4. overlapping skill modes and autonomy terms need later usage-led reduction;
5. all adoption evidence still comes from one operator's repositories.

The operator accepted a protocol freeze, structural-not-editorial validation,
general-purpose audience, modular language integration, and later mode
consolidation based on observed use rather than a target count.

## Dogfood cohort

The closed cohort contains 26 observation packets and 12 completed lanes across
eight projects and two provider families. It recorded ten naturally parallel
frontiers, 23 completed review rounds, and 19 validation-reduction fixtures.
The raw packet remains available in Git at
`0debd58:docs/triage/2026-09-01-live-orchestrator-dogfood-window.md`.

What the cohort showed:

- parallel-first scheduling works when dependency and shared-surface edges are
  named instead of converted into a global queue;
- day-to-day and mechanical profiles completed bounded work without frontier
  escalation, while the frontier lanes had both required escalation axes;
- provider failure can remain lane-local while unrelated work continues;
- retained workspace and agent identity still has adapter friction during
  recovery;
- provider merge can succeed while local branch deletion fails because a Paseo
  worktree owns it;
- inside Paseo, explicit workspace archive owns managed-worktree teardown;
  agent termination must not implicitly archive a shared workspace;
- one token-scanner substring false positive and one false clean diff claim
  showed that prose-coupled checks can be both noisy and misleading;
- real structural publication errors still need deterministic rejection.

## Reduction fixture classes

The 19 supplied fixtures cover:

- benign token-like text that must not trigger a secret finding;
- rebase-only evidence and front-door currentness edits;
- compact `PAPERCUTS.md`, card, roadmap, log, and index closeouts;
- promoted-triage deletion and authority-aware triage compaction;
- historical-log appendix relocation;
- source-preserving test partitioning;
- frozen-versus-moving documentation supersession;
- one trailing-space correction that makes a claimed diff check true;
- one structural publication-path failure that must remain rejected.

Card 113 turns these into representative deterministic fixtures rather than
copying consumer repositories or their prose into Northstar.

## Validation boundary

The experiment may remove:

- `required_content` and `forbidden_content` substring assertions;
- individual historical cards, milestones, logs, and closed specs from the
  required-path inventory;
- currentness checks whose only contract is exact editorial wording.

It must retain:

- stable root and documentation front doors;
- active authority entry points;
- Markdown link integrity for the distributed skill;
- canonical/mirror parity checks;
- executable readiness, command-surface, and install-parity checks;
- failure fixtures for missing structure, broken links, and parity drift.

No new metadata schema is required merely to preserve an old prose assertion.
If a state invariant cannot be expressed structurally in this lane, it remains
a review responsibility and a candidate for later design.

## Deferred lanes

- Spec 034 plans modular language packages after `g02.045`; it is not ready for
  implementation.
- Paseo archive/worktree teardown ownership is settled input for later adapter
  planning, not a Northstar protocol change in this lane.
- Mode consolidation, enumeration deduplication, template/live divergence, and
  autonomy-term reduction remain open simplification questions.

## Evidence

- First-principles packet merged through PR 16 and preserved in Git before this
  promotion.
- Dogfood buffer closed at `0debd58`.
- `effigy qa:docs` and full planning-batch validation are required before
  dispatch.

## Next Task

Dispatch `g02.045/113`. Review the exact head against the milestone oracle;
merge only after structural negative fixtures and benign editorial fixtures
both pass.
