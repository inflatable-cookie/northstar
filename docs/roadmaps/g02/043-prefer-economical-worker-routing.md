# 043 - Prefer Economical Worker Routing

Status: complete
Owner: repo maintainers
Created: 2026-09-01
Depends on: `g02.025`, `g02.035`, `g02.036`, `g02.037`, `g02.042`
Vision tags: `orchestration`, `workers`, `paseo`, `model-efficiency`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Planning state: card 111 implemented; awaiting orchestrator exact-head review

## Problem

Northstar says bounded workers should use capable medium-effort profiles, but it
also routes any worker touching a broad risk-domain list to frontier/high effort.
In practice, ordinary work is repeatedly labelled high complexity and launched
on the most expensive worker profile even when current Paseo notes reserve that
profile for the highest-priority, highest-complexity lanes.

## Goals

- make a matching non-frontier day-to-day profile the normal worker choice;
- reserve frontier workers for lanes that are both exceptionally difficult and
  highest-priority or materially consequential;
- stop treating task size, duration, file count, or a risk-domain label as an
  automatic frontier trigger;
- keep risky lanes protected by explicit review oracles and frontier review;
- keep model and profile names out of Northstar's reusable contract;
- make profile gaps visible instead of silently escalating to frontier cost.

## Non-goals

- no hard-coded provider, model, profile name, price, or context-window table;
- no change to frontier orchestrator, planning-delegate, or material-review
  routing;
- no weakening of security, persistence, concurrency, public-API, deployment,
  or multi-version review gates;
- no automatic mid-run model replacement or worker duplication;
- no Paseo product or profile mutation.

## Execution Plan

Card `g02.043/111` owns one bounded protocol, doctrine, skill, template,
operator-guidance, deterministic-check, distribution, and closeout lane. The
worker propagates the already-settled two-axis escalation rule; it does not
choose local profile names or redefine their notes.

## Acceptance Criteria

- ordinary bounded implementation selects a matching non-frontier day-to-day
  profile by default;
- long mechanical audits and documentation churn prefer fast/low-cost or
  mechanically oriented profiles even when their scope is broad;
- a frontier implementation worker requires both exceptional reasoning
  difficulty after planning and highest priority or material consequence;
- every frontier-worker handoff records both reasons;
- priority alone, complexity alone, breadth, duration, and risk-domain labels
  are explicitly insufficient;
- unresolved design choices return to planning instead of being delegated to an
  expensive worker;
- risky surfaces retain an explicit review oracle and frontier review;
- profile selection remains driven by current adapter notes with an explicit
  operator override and visible no-fit fallback;
- source/install parity and repository QA pass.

## Review Oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Day-to-day is the default. | A bounded ordinary fix is labelled “high complexity” without a concrete exceptional reasoning burden. | Select a matching non-frontier day-to-day profile. | Mode and operator scenario evidence. |
| Breadth is not intelligence. | A repository-wide docs or audit lane touches hundreds of files but follows settled mechanical rules. | Select a fast/low-cost or mechanically oriented profile. | Mechanical-work scenario evidence. |
| Risk labels do not spend by themselves. | A well-specified persistence or public-API change has a complete oracle and direct implementation. | Use a capable non-frontier worker and keep frontier review. | Risk-domain negative scenario evidence. |
| Frontier is conjunctive. | A lane is high priority but mechanically simple, or very difficult but low priority. | Do not select a frontier worker unless both axes are satisfied. | Two single-axis negative scenarios. |
| Frontier stays available. | A highest-priority, materially consequential lane still requires exceptional cross-system reasoning after planning. | Select a matching frontier profile and record both reasons. | Positive frontier scenario evidence. |
| Ambiguity is planning work. | Two product or architecture designs remain plausible. | Return to planning; do not use a frontier worker to choose. | Planning-return scenario evidence. |
| Profile gaps are visible. | No configured non-frontier profile fits an ordinary lane. | Report the gap; do not silently promote to frontier. | No-fit scenario evidence. |

## Stop Conditions

- implementation needs stored provider prices, model IDs, or local profile names;
- the rule cannot distinguish worker capability from review rigor;
- a risky surface would lose its review oracle or frontier review;
- the change invents a mid-run replacement protocol;
- validation reveals contradictory source/install behavior.

## Next Task

Orchestrator exact-head review and check-gated merge of the card 111 PR. Then
choose the next `g02` milestone from the generation runway.
