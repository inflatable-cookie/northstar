# 06 Planning and Contract Gates

Status: active
Updated: 2026-03-24

## Why this section matters now

Northstar already provides a strong documentation spine, but complex delivery
programs fail when agents can infer missing boundaries and start building
against imagined system behavior. This section defines the stricter operating
mode: planning coverage must be explicit, contracts must exist before execution,
and planning gaps are a stop condition rather than a prompt for improvisation.

## Scope

Define the minimum planning artifacts and gate checks required before roadmap
work can begin, especially for multi-repo or high-risk systems.
This section governs planning completeness, contract-first execution, and
controlled replanning.
It does not replace vision, architecture, contracts, roadmaps, research, or
logs; it tightens how they interact.

## Required planning artifacts

Use these artifacts before execution starts:

- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md` when more than one repo or deployable
  authority exists
- `docs/contracts/contract-index.md`
- one or more `docs/contracts/NNN-<slug>.md` files for execution-relevant
  boundaries
- current research translation memos when a bet depends on external evidence
- roadmap milestones whose work is fully backed by the above surfaces

## Planning coverage rule

Before roadmap work starts, planning must enumerate every known
execution-relevant surface:

1. repos, packages, services, and deployable units
2. authority owners for data, workflows, and decisions
3. interfaces between internal components and external systems
4. contracts required for those interfaces and behaviors
5. validation surfaces needed to prove the contracts hold
6. unresolved areas that block execution

If any item is still unknown, record it explicitly as a planning gap.
Do not treat an unplanned surface as implicitly owned or already solved.

## Contract-first execution rule

Roadmap work may start only when all of the following are true:

- the relevant system area exists in `system-architecture.md`
- the area is represented in `system-inventory.md`
- ownership is clear in `repo-authority-map.md` when multiple authorities exist
- the governing contract exists in `docs/contracts/`
- the contract is indexed in `contract-index.md`
- the roadmap milestone references the contract directly
- required research translation memos are linked when the bet is evidence-driven

If these conditions are not met, the valid action is to add or repair planning
artifacts, not to start implementation.

## Planning gap rule

`Planning gap` is a first-class failure mode.

Use it when:

- a required repo or service is missing from the planning surfaces
- a roadmap milestone depends on behavior that no contract defines
- ownership is unclear across repos or teams
- research-backed decisions have not been promoted into architecture/contracts
- validation requirements are unknown or contradictory

When a planning gap appears:

1. stop execution on the affected batch
2. log the missing surface in the relevant planning artifact or a roadmap/log
   note
3. create or update the needed architecture, contract, or research artifact
4. regenerate affected roadmap batches only after the planning gap is closed

## Multi-repo rule

For multi-repo systems, roadmap work is invalid unless the repo authority map
states:

- every participating repo
- what each repo owns
- what each repo consumes
- which contracts govern each seam
- which repo is authoritative when state or behavior conflicts

Agents must not fabricate missing repo behavior to keep a batch moving.

## Replanning and change protocol

When reality changes:

1. update the affected contract or create a contract delta log
2. propagate the change into architecture and the repo authority map
3. review whether current roadmap generation still matches reality
4. re-sequence or roll over to a new generation if the contract shift is large
5. resume execution only after the planning surfaces are coherent again

## Content contract (system inventory)

1. `Status`, `Owner`, `Updated`, `Architecture refs`
2. `## Coverage Summary`
3. `## In-Scope System Elements`
4. `## Interfaces and Dependencies`
5. `## Validation Surfaces`
6. `## Planning Gaps`
7. `## Next Task`

## Content contract (repo authority map)

1. `Status`, `Owner`, `Updated`, `Architecture refs`
2. `## Topology`
3. `## Repo Authorities`
4. `## Cross-Repo Contracts`
5. `## Conflict Resolution Rules`
6. `## Planning Gaps`
7. `## Next Task`

## Content contract (contract index)

1. `Status`, `Owner`, `Updated`
2. `## Coverage Rules`
3. `## Contract Register`
4. `## Missing or Pending Contracts`
5. `## Roadmap Readiness`
6. `## Next Task`

## Dependencies

- Vision defines what the product is trying to achieve.
- Architecture defines the system shape and invariants.
- Research validates non-obvious bets before they harden.
- Contracts define the rules implementation must satisfy.
- Roadmaps sequence only the work already authorized by those surfaces.
- Logs prove what was changed and why.

## Next task

Pilot the planning gate on a live multi-repo program and tune the minimum
artifact set until agents reliably stop on genuine gaps without creating
ceremony for low-risk work.
