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

## 2. Pre-execution discovery

Use when the request explicitly concerns readiness mapping or the discovery
routes that precede ordinary planning:

- readiness mapping or a readiness frontier;
- intent rounds over the current frontier;
- destination-local project language;
- a decision prototype;
- an operator questionnaire for an unresolved decision.

This is an internal mode of the single public `northstar` skill. It is
provider-neutral, plan-only, and non-mutating by default; it cannot clear a map,
make a card ready, or replace normal spec, promotion, roadmap, or operator gates.

**Precedence:** If the user explicitly asks for an orchestrator thread, separate
worker/worktree preparation, or PR review around a readiness/discovery lane,
choose **Orchestrator** mode even when the request also mentions readiness or
discovery; treat discovery as the Orchestrator's planning lane. Direct
readiness, intent, project-language, decision-prototype, or questionnaire
requests without that orchestrator/worker/worktree/PR language remain
**Pre-execution discovery**.

→ [`modes/pre-execution-discovery.md`](./modes/pre-execution-discovery.md)

## 3. Orchestrator thread

Use when the user wants Northstar to own a question-led planning conversation,
prepare a separate worker thread/worktree, maintain a runway, or review the
worker's PR. This is an internal mode of the single public skill; the operator
still relays messages between threads.

→ [`modes/orchestrator.md`](./modes/orchestrator.md)

## 4. Agent instruction review

Use when the user explicitly asks for an always-loaded instruction-surface
review, especially:

- `northstar AGENTS file review`;
- review, audit, optimize, or compact `AGENTS.md`;
- review the root `CLAUDE.md` bridge alongside `AGENTS.md`;
- reduce agent-context noise or improve agent-run efficiency.

This mode is target-repository-aware and docs-only. It must not inspect
Northstar's own files when the target is a consumer repository.

→ [`modes/agent-instruction-review.md`](./modes/agent-instruction-review.md)

## 5. Normalize docs posture

Use when the job is **repo shape and spine health** (initial or ongoing):

- set up / bootstrap / migrate / normalize under Northstar
- fix or refresh docs front doors, generation index, Effigy wiring
- lane-first strict adoption, install working-rules / specs / archive surfaces
- keep the docs tree aligned with doctrine over time

→ [`modes/normalize-docs.md`](./modes/normalize-docs.md)

## 6. Research

Use when **external evidence** must become architecture or contracts before
roadmap work bets on it.

→ [`modes/research.md`](./modes/research.md)

## 7. Recovery

Use when planning **was valid but state is now untrustworthy**:

- drifted, stale, contradictory front doors or roadmaps
- replan after contract or boundary change
- sweep-led audit/repair of the docs spine

If planning coverage is **still missing**, use plan-from-scratch instead.

→ `replan-after-change.md`, `refocus-drifted-project.md`, or
`sweep-audit-repair.md`

## 8. Planning (default for implicit work)

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

## Worker startup fast path

When the thread is an implementation worker receiving a handoff, or the
launcher has already supplied a worktree, do not perform the normal shared reads
first. Run one quick read-only probe from the current context:

```sh
git rev-parse --show-toplevel
git branch --show-current
git status --porcelain
git worktree list --porcelain
```

If the current root is a registered worktree, the status is empty, and the branch
is not `main`, reuse it as the launcher-provided worktree. Record its actual
root/branch and do not compare generated path or branch names with a handoff
placeholder. Do not create another worktree merely because those values differ.
Only a `main`, dirty, unregistered, or otherwise unusable current context may
proceed to the named handoff worktree and then the manual local-path fallback.

Do not run `effigy tasks`, `effigy doctor`, broad repository reads, or discovery
commands before this decision. After the worktree is selected, read the handoff
and continue with the normal mode-specific checks.

## Posture label (all modes except handoff)

Name repo posture early: `baseline-routing`, `strict-ready`, `strict-paused`,
`migration`, or `drifted`.

## Shared reads

After choosing a mode (and after the worker startup fast path when applicable):

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
