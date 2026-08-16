# 077 - Implement Pre-Execution Discovery Routes

Status: ready
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/027-northstar-native-pre-execution-discovery.md`
Governing refs: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `docs/roadmaps/g02/batch-cards/076-implement-deterministic-readiness-frontier-checks.md`, `g02.026`
Depends on: `g02.026/076` and the Batch 26.2 planning checkpoint
Auto-start next card: no

## Planning Gate

The planning gate is satisfied:

- the Batch 26.1 readiness-map contract and deterministic checker are merged;
- the operator selected Figmatic as the first dogfood and Poodle as the second;
- project language is local by default, with explicit promotion to the global
  glossary only for stable cross-project terms;
- the four route contracts are promoted into architecture and working rules;
- the implementation scope is bounded to the Northstar skill's provider-neutral
  planning procedures and router activation;
- starter templates, architecture refocus, reframe, consumer-repo dogfood, and
  production code are explicitly out of scope.

## Objective

Add the first routed Northstar procedure for pre-execution discovery. The route
must let an operator run intent rounds over a readiness frontier and direct each
unresolved question to project language, a decision prototype, or a questionnaire
without weakening the plan-only boundary.

## Intended Scope

- add an internal `pre-execution-discovery` mode under
  `skills/northstar/references/modes/`;
- activate that mode from the Northstar router for explicit readiness-mapping,
  intent-rounds, project-language, decision-prototype, and questionnaire work;
- implement the question-led intent-round procedure:
  repository facts first, small breadth-first question groups, canonical decision
  links, route selection, frontier recomputation, and explicit stop conditions;
- define how the mode uses the destination-local project-language surface and
  keeps stable-term promotion operator-visible;
- define the decision-prototype route as bounded evidence with a recorded verdict,
  limitations, and promotion target;
- define the questionnaire route as durable operator-owned questions in the
  canonical decision record across turns or sessions;
- preserve the existing orchestrator, planning, research, recovery, normalize,
  and handoff modes without creating a second public skill;
- update the skill's routing/default guidance only where needed to make the new
  mode discoverable and provider-neutral;
- refresh and prove installed skill parity after source changes.

## Out of Scope

- starter-bundle templates or worked examples;
- changes to the readiness-map checker or its fixture corpus;
- architecture refocus or reframe behavior;
- automatic cross-session messaging or provider-specific session APIs;
- external trackers, databases, network services, or production-code edits;
- running the Figmatic or Poodle dogfood itself;
- changing the existing worker handoff, worktree, PR, review, or merge contract.

## Acceptance Criteria

- explicit pre-execution discovery requests route to the new internal mode;
- the mode reads the current readiness map and works from its deterministic
  frontier rather than inventing a parallel question list;
- repository-answerable facts are resolved before operator questions are asked;
- intent rounds remain small, breadth-first, and linked to canonical decision IDs;
- project-language guidance keeps destination vocabulary local by default and
  makes global promotion explicit;
- decision prototypes produce evidence and a verdict but cannot resolve an
  operator-owned decision or edit production code;
- questionnaires preserve operator-owned questions and responses without an
  external tracker or silent agent substitution;
- the mode cannot clear a map, mark a card ready, or bypass normal promotion and
  roadmap gates;
- the existing Northstar modes and one-public-skill boundary remain intact;
- `effigy qa:docs` passes;
- source/install parity passes for both installed Northstar copies;
- `git diff --check` passes.

## Evidence Required

- exact changed-file list;
- router excerpt showing the new activation path;
- mode excerpt showing intent-round, project-language, prototype, and questionnaire
  behavior;
- explicit plan-only and operator-authority boundary evidence;
- `effigy qa:docs` output;
- source/install parity output for the installed skill;
- `git diff --check` output;
- explicit confirmation that no consumer repository or production code changed.

## Stop Conditions

- stop if the route requires a second public skill or provider-specific adapter;
- stop if the route invents a second readiness-map or decision-record authority;
- stop if a prototype or questionnaire can silently resolve an operator-owned
  decision;
- stop if implementation requires starter templates, checker changes, or
  architecture refocus that belong to later batches;
- stop if the route cannot remain useful without network access or cross-session
  messaging;
- stop if installed-skill parity cannot be restored and verified.

## Continuation Envelope

- Auto-start next card: no
- In-bounds next card: none until this card is implemented, reviewed, and merged
- Remaining ready chain after this card: 0
- Transition proof required before the next card becomes ready: route behavior,
  plan-only boundaries, installed-skill parity, and docs QA are recorded

## Next Task

Run this card through the isolated worker/PR loop. After its merge and closeout,
compile the starter surfaces and worked example for Batch 26.3 before dogfooding
Figmatic.
