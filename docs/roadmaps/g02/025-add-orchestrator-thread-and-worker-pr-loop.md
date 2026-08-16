# 025 - Add Orchestrator Thread And Worker PR Loop

Status: active
Owner: repo maintainers
Created: 2026-08-16
Depends on: g02.024
Vision tags: `orchestration`, `worker-thread`, `worktrees`, `pull-request`, `model-efficiency`
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `bundle-docs/research/translation-memos/northstar-orchestrator-thread.md`
Planning state: ready for dogfood

## Problem

Northstar needs an explicit conversational orchestrator mode that can explore a
problem deeply, maintain a contract-backed runway, prepare a clean base, hand a
fresh worker thread a bounded prompt in a separate worktree, and review the
resulting PR without depending on private cross-thread history.

## Goals

- [x] promote the orchestrator/worker/PR boundary into architecture and contract
- [x] add the internal `orchestrator` mode to the single public skill
- [x] add a reusable worker launch-packet template
- [ ] prove the loop with one bounded low-risk lane
- [ ] measure relay burden, worker rework, review cycles, and validation success
- [x] refresh the installed skill and prove source/install parity

## Execution Plan

### Batch 25.1 - Define And Publish The Orchestrator Mode

- [x] write the evidence-backed translation memo
- [x] promote durable topology and boundaries
- [x] add the routed skill mode and operator-facing entry guidance

### Batch 25.2 - Add The Worker Packet And PR Review Contract

- [x] define the single-file handoff fields and worker file contract
- [x] define chunk reporting, stop, review, merge, and closeout rules
- [x] add a copy-ready packet template

### Batch 25.3 - Dogfood And Measure The Loop

- [ ] choose one bounded, low-risk consumer or Northstar lane
- [ ] prepare main, create a dedicated worktree, and run a fresh worker thread
- [ ] relay at least one chunk report and one PR URL to the orchestrator
- [ ] exercise approval or requested-changes review
- [ ] record measured friction before promoting more automation

### Batch 25.4 - Refresh And Prove Skill Distribution

- [x] repair or adapt the parity checker to the supported Effigy runtime
- [x] refresh the installed skill from source through the documented path
- [x] prove source/install file-set and content parity
- [x] confirm a fresh session loads the new mode and packet template

## Acceptance Criteria

- [x] planning and implementation contexts are separated without a second public skill
- [x] the worker can operate from canonical file refs plus a small packet
- [x] worker scope, worktree, branch, stop, evidence, PR, and merge boundaries are explicit
- [x] model selection is capability-based and provider-neutral
- [ ] a real worker thread completes one bounded runway and opens a reviewable PR
- [ ] the orchestrator review and closeout leave coherent roadmap/card/log state
- [x] the installed skill matches the source skill and loads the new mode

## Next Task

Run `g02.025/072` through a fresh worker thread, dedicated worktree, operator-
relayed chunk report, and reviewable PR. Keep adapter and packet-persistence
choices open until that evidence exists.
