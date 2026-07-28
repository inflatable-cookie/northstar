# Northstar mode router

**Required first step** for every `northstar` invocation. Pick exactly one mode,
then open only that mode file under `references/modes/` (plus mode-specific
refs under `references/setup/` or `references/handoff-contract.md`).

## 1. Handoff (explicit only)

Use **only** when the user clearly wants a **fresh-thread artifact**, not
ordinary continuation:

- handoff, continuation brief, spin-off prompt, fresh thread, new thread, next
  agent thread, "write this up for the next agent"

**Do not** use handoff mode for:

- bare `continue`, "keep going", "context is full", compaction alone
- routine batch closeout without asking for a handoff file

→ [`modes/handoff.md`](./modes/handoff.md)

## 2. Normalize docs posture

Use when the job is **repo shape and spine health** (initial or ongoing):

- set up / bootstrap / migrate / normalize under Northstar
- fix or refresh docs front doors, generation index, Effigy wiring
- lane-first strict adoption, install working-rules / specs / archive surfaces
- keep the docs tree aligned with doctrine over time

→ [`modes/normalize-docs.md`](./modes/normalize-docs.md)

## 3. Research

Use when **external evidence** must become architecture or contracts before
roadmap work bets on it.

→ [`modes/research.md`](./modes/research.md)

## 4. Recovery

Use when planning **was valid but state is now untrustworthy**:

- drifted, stale, contradictory front doors or roadmaps
- replan after contract or boundary change
- sweep-led audit/repair of the docs spine

If planning coverage is **still missing**, use plan-from-scratch instead.

→ `replan-after-change.md`, `refocus-drifted-project.md`, or
`sweep-audit-repair.md`

## 5. Planning (default for implicit work)

Use when the job is **planning or sequencing** and recovery is not the main
problem:

- plan from scratch, contracts, specs, promotion, compile roadmaps/milestones
- next milestone, next batch, readiness, continuation envelope
- tighten guardrails so execution cannot outrun contracts

Choose one:

| Situation | Mode file |
| --- | --- |
| Missing architecture/inventory/contracts | [`plan-from-scratch.md`](./modes/plan-from-scratch.md) |
| Change still in provisional specs | [`shape-with-specs-and-promote.md`](./modes/shape-with-specs-and-promote.md) |
| Canonical surfaces exist; need milestones/cards | [`compile-roadmaps.md`](./modes/compile-roadmaps.md) |

## Posture label (all modes except handoff)

Name repo posture early: `baseline-routing`, `strict-ready`, `strict-paused`,
`migration`, or `drifted`.

## Shared reads

After choosing a mode:

```sh
effigy tasks
effigy doctor
```

Then read the target repo's available `README.md`, `AGENTS.md`,
`docs/README.md`, and `docs/contracts/001-working-rules.md` before loading
mode-specific paths.

Repo paths written as code literals are resolved from the target workspace,
not from this installed skill folder. When the target is the Northstar source
repo, also read `bundle-docs/protocol-kernel.md`. Consumer repos normally do
not contain `bundle-docs/`; its absence is not a contract gap.
