# 025 - Add Orchestrator Thread And Worker PR Loop

Status: complete
Owner: repo maintainers
Created: 2026-08-16
Depends on: g02.024
Vision tags: `orchestration`, `worker-thread`, `worktrees`, `pull-request`, `model-efficiency`
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `bundle-docs/research/translation-memos/northstar-orchestrator-thread.md`
Planning state: complete

## Problem

Northstar needs an explicit conversational orchestrator mode that can explore a
problem deeply, maintain a contract-backed runway, prepare a clean base, hand a
fresh worker thread a bounded prompt in a separate worktree, and review the
resulting PR without depending on private cross-thread history.

## Goals

- [x] promote the orchestrator/worker/PR boundary into architecture and contract
- [x] add the internal `orchestrator` mode to the single public skill
- [x] add a reusable worker handoff extension of the core handoff template
- [x] prove the loop with one bounded low-risk lane
- [x] measure relay burden, worker rework, review cycles, and validation success
- [x] refresh the installed skill and prove source/install parity

## Execution Plan

### Batch 25.1 - Define And Publish The Orchestrator Mode

- [x] write the evidence-backed translation memo
- [x] promote durable topology and boundaries
- [x] add the routed skill mode and operator-facing entry guidance

### Batch 25.2 - Add The Worker Packet And PR Review Contract

- [x] define the single-file handoff fields and worker file contract
- [x] define chunk reporting, stop, review, merge, and closeout rules
- [x] add a copy-ready worker handoff template

### Batch 25.3 - Dogfood And Measure The Loop

- [x] choose one bounded, low-risk consumer or Northstar lane
- [x] use `g02.025/074` as the one-file worker probe because no independent ready card existed
- [x] prepare main, create a dedicated worktree, and run a fresh worker thread
- [x] relay a worker completion report and one PR URL to the orchestrator
- [x] exercise approval and merge review with explicit operator authorization
- [x] record measured friction before promoting more automation

### Batch 25.4 - Refresh And Prove Skill Distribution

- [x] repair or adapt the parity checker to the supported Effigy runtime
- [x] refresh the installed skill from source through the documented path
- [x] prove source/install file-set and content parity
- [x] confirm a fresh session loads the new mode and worker handoff template

## Acceptance Criteria

- [x] planning and implementation contexts are separated without a second public skill
- [x] the worker can operate from canonical file refs plus a small packet
- [x] worker scope, worktree, branch, stop, evidence, PR, and merge boundaries are explicit
- [x] model selection is capability-based and provider-neutral
- [x] a real worker thread completes one bounded runway and opens a reviewable PR
- [x] the orchestrator review and closeout leave coherent roadmap/card/log state
- [x] the installed skill matches the source skill and loads the new mode

## Resolution

The first dogfood is complete. See
`docs/logs/2026-08/16-181533-dogfood-orchestrator-worker-pr-loop.md` for the
worker/PR evidence, measurements, two protocol repairs, and remaining papercuts.
The manual operator-mediated path remains the default; provider adapters and
automatic cross-session messaging remain unproven.

## Next Task

Begin `g02.026` planning from `docs/specs/027-northstar-native-pre-execution-discovery.md`.
Compile Batch 26.1 only after the readiness-map file contract and execution gate
are settled; do not start implementation from the queued milestone alone.
