# Translation Memo: Matt Pocock Skills Audit To Northstar-Native Discovery

Status: active
Owner: repo maintainers
Last Updated: 2026-08-16
Source repository: `https://github.com/mattpocock/skills`
Audited commit: `068b6e0c62393147daf03530149cdce209c93da8`
Related spec: `docs/specs/027-northstar-native-pre-execution-discovery.md`
Promotion target: Northstar planning, starter, and validation surfaces

## Project problem statement

Northstar already has a durable docs spine, planning gates, readiness rules, bounded
continuation, handoffs, and an orchestrator/worker PR boundary. It still allows a
material project to reach a plausible implementation plan before the destination,
domain language, architecture, decision dependencies, or operator intent are truly
settled.

The practical failure is code arriving before the project is ready to build. The
solution is not another external issue tracker or a collection of copied skills. It
is a Northstar-native discovery phase that makes unresolved decisions visible,
records them under the existing docs authority, and refuses the transition to
execution until the operator-owned readiness gate is satisfied.

## External evidence summary

The audit read all 35 skills in the source repository plus its catalog, repository
instructions, companion documentation for the principal workflows, and changelog.
The strongest transferable ideas were:

- destination-first planning for work larger than one session;
- decision records separated from implementation tickets;
- a frontier of unresolved questions whose prerequisites are complete;
- breadth-first question rounds rather than an unstructured serial interview;
- explicit separation of facts the environment can answer from decisions the human
  must make;
- a confirmation gate before a plan becomes an execution instruction;
- active-lane scoping for architecture improvement rather than evenly scanning a
  dormant codebase;
- prototypes as evidence for questions conversation cannot settle;
- small corrective language for messages that did not land;
- portable handoff intent without treating temporary files as durable authority.

The source system also documents failure modes Northstar must avoid: agent-authored
execution exemptions, waterfall-sized maps, duplicate human-in-the-loop sessions,
prototype choices made by the agent, CDN-dependent reports, and overlong grilling.

## Northstar translation

Do not reuse the source skill names as Northstar workflow names. Use these working
Northstar terms instead:

| Northstar term | Meaning |
| --- | --- |
| Readiness mapping | Multi-session discovery of the decisions required before a bounded destination can enter execution planning. |
| Intent rounds | The reusable, breadth-first question mechanism for settling operator-owned decisions. |
| Project language | A controlled vocabulary of terms, authorities, and rejected ambiguities used by the planning spine. |
| Decision prototype | A throwaway, question-specific artifact used when discussion cannot settle an interaction, state model, or design choice. |
| Architecture refocus | An evidence-led review of active code and seams that proposes candidate improvements without changing code. |
| Reframe | A non-mutating request to restate the last message in clearer project language. |

## What Northstar should adopt

1. Keep the map and decisions inside `docs/specs/`, with research, architecture,
   contracts, roadmaps, logs, and handoffs remaining the existing authority surfaces.
2. Make the destination explicit before creating a decision frontier.
3. Keep the map as an index and keep each decision in one canonical record.
4. Separate `not-yet-specified` from `out-of-scope` work.
5. Classify decisions as operator-led, research-led, prototype-led, or literal task
   work, and do not let an agent resolve an operator-led decision from its own notes.
6. Recompute the frontier after each decision rather than planning the entire
   implementation waterfall in advance.
7. Transition from readiness mapping to a Northstar spec, promotion, roadmap, and
   ready cards in that order.
8. Preserve the current durable handoff contract and add only purpose, target-next-
   session, and suggested-route metadata.
9. Scope architecture refocus to active lanes or a named area and keep the first
   report ephemeral unless a selected finding earns a durable research or spec
   record.
10. Make the first implementation path self-contained and offline-safe.

## What Northstar should reject

- External issue trackers as the source of truth for planning decisions.
- A map-owned note that can override the plan-only boundary.
- Parallel write-heavy sessions in one active lane.
- A requirement to answer every question before a small, well-bounded change can
  proceed.
- Permanent reports for every architecture scan.
- Automatic cross-session messaging as a protocol dependency.
- Provider-specific names, commands, or session semantics in the Northstar contract.

## What must be true before adoption

- The readiness map has a bounded destination and explicit scope.
- Every open decision has a status, owner/mode, and dependency list.
- The frontier can be calculated deterministically from repository files.
- Operator-led decisions cannot be marked resolved without operator evidence.
- The transition gate names the remaining accepted uncertainty.
- The resulting spec can be promoted into architecture/contracts before roadmap
  execution.
- The starter bundle can be installed without external tracker setup.
- The workflow survives a fresh thread because the repository remains authoritative.

## Required validation work

- Run readiness mapping on one new or materially ambiguous project.
- Record whether the map revealed decisions that would otherwise have become code.
- Measure plan revisions, reopened decisions, implementation rework, and operator
  correction burden.
- Test the no-fog early exit on a deliberately small change.
- Test the plan-only boundary against an agent attempt to self-authorise execution.
- Test dependency validation, orphan detection, and deterministic frontier output.
- Test a decision prototype round-trip from question to verdict to spec reference.

## Promotion target

This memo feeds `docs/specs/027-northstar-native-pre-execution-discovery.md`.
Durable rules should be promoted into the architecture and working-rules contract
only after the first docs-native implementation and dogfood evidence.

## Source inventory

- `https://github.com/mattpocock/skills/tree/068b6e0c62393147daf03530149cdce209c93da8`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/README.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/skills/engineering/wayfinder/SKILL.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/docs/engineering/wayfinder.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/skills/productivity/grilling/SKILL.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/docs/productivity/grilling.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/skills/engineering/improve-codebase-architecture/SKILL.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/docs/engineering/improve-codebase-architecture.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/skills/productivity/handoff/SKILL.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/docs/productivity/handoff.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/skills/productivity/wait-what/SKILL.md`
- `https://github.com/mattpocock/skills/blob/068b6e0c62393147daf03530149cdce209c93da8/CHANGELOG.md`

## Next task

Complete the current `g02.025` orchestrator dogfood first. Then define the
readiness-map file contract and deterministic frontier checks as the first batch
of `g02.026`.
