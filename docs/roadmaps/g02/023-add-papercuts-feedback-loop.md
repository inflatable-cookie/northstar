# 023 - Add Papercuts Feedback Loop

Status: complete
Owner: repo maintainers
Created: 2026-08-06
Depends on: g02.022
Vision tags: `agent-feedback`, `autonomy`, `skills`, `bundle-docs`
Governing refs: `docs/contracts/001-working-rules.md`,
`bundle-docs/papercuts.md`, `docs/specs/024-papercuts-feedback-loop.md`
Planning state: complete

## Problem

Agents meet small, repeatable execution friction while working, but the
observation is usually lost when the immediate task ends. Northstar needs an
agent-owned capture path that does not require an operator prompt or interrupt
the current work.

## Goals

- [x] define a small root-level papercut queue and entry shape
- [x] instruct agents to write at encounter time and create the file if absent
- [x] distinguish observations from normal planning and backlog authority
- [x] ship the rule through doctrine, contracts, templates, and the skill
- [x] validate source and starter surfaces through the existing Effigy QA path

## Non-goals

- [x] automatic triage, prioritization, or issue creation
- [x] a new agent runtime hook or public skill
- [x] recording every failed command or external blocker

## Contract Coverage

- [x] The reusable behavior is explicit in `bundle-docs/papercuts.md`.
- [x] The strict-repo binding is present in `docs/contracts/001-working-rules.md`.
- [x] The agent execution and setup surfaces carry the rule without operator
      intervention.

## Execution Plan

### Batch 23.1 - Define And Promote The Contract

- [x] define the queue schema, capture timing, exclusions, and triage rule
- [x] promote the behavior into the live and reusable working-rules surfaces
- [x] update architecture, inventory, protocol kernel, and operator entry points

### Batch 23.2 - Wire Agent And Setup Surfaces

- [x] add the root queue and reusable `PAPERCUTS.md` starter
- [x] update the Northstar skill, default prompt, and generated `AGENTS.md`
- [x] document root versus nested-repository ownership

### Batch 23.3 - Validate And Close The Implementation Lane

- [x] add required-file and content assertions to the existing repo checks
- [x] run Effigy QA against the complete change
- [x] record the first real papercut and the next consumer proof step

## Acceptance Criteria

- [x] An agent can encounter friction, create or append to root
      `PAPERCUTS.md`, and continue without asking the operator.
- [x] Entries are short, actionable, deduplicated, and exclude sensitive or
      non-solvable noise.
- [x] Papercuts remain separate from backlog and roadmap authority until triage.
- [x] The source repo, skill starter, templates, and checks agree on the rule.

## Evidence

- `PAPERCUTS.md` contains the orientation papercut found during this batch.
- `docs/logs/2026-08/06-000000-add-papercuts-feedback-loop.md`

## Next Task

Run the new loop in one consumer repository, then triage the first small cohort
of entries for duplicates, promotion candidates, and false-positive noise.
