# 046 - Add Fresh Orchestrator Continuation

Status: active; card 114 implementation complete; awaiting exact-head review
Owner: repo maintainers
Created: 2026-09-01
Depends on: `g02.045`, spec 026
Vision tags: `orchestration`, `handoff`, `paseo`, `general-purpose`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`

## Problem

An operator can ask for a worker, planning delegate, or plain handoff, but an
existing orchestrator cannot yet hand its whole live lane to a fresh
orchestrator and launch that successor through Paseo. Manual thread creation
loses predictable labels and repeats transport steps; treating the successor as
a worker or delegate gives it the wrong authority.

## Goals

- add an explicit orchestrator-continuation handoff activation;
- reuse the normal seven-section handoff rather than add another public mode;
- transfer one lane's ownership cleanly from source to successor;
- launch a Paseo successor in a separate local workspace for the same project;
- apply the capitalized `Orchestrator` agent label at creation;
- select current orchestrator profiles by notes and copy their settings;
- keep manual absolute-path launch complete without Paseo;
- leave sidebar pin placement manual when no native control exists;
- forbid browser or computer-use fallback for pinning.

## Non-Goals

- no concurrent orchestrators sharing one mutable lane;
- no worker worktree, implementation branch, or PR for the successor thread;
- no automatic source-thread archival, deletion, killing, or unpinning;
- no provider/model name stored in reusable policy;
- no Paseo plugin, WebSocket, browser, computer-use, or UI automation work;
- no change to worker, planning-delegate, review, or merge authority.

## Execution Plan

Card `g02.046/114` owns the reusable protocol propagation, generic handoff
overlay, router activation, Paseo launch guidance, deterministic assertions,
distribution parity, and closeout. PR 18 merged at `1f6647a`; the lane must
launch from that refreshed `main` because both milestones own Northstar
front-door closeout.

## Acceptance Criteria

- a concrete continuation handoff activates normal orchestrator mode and cannot
  activate worker or planning-delegate preflight;
- the source publishes coherent pushed state before dispatch and yields mutation
  ownership afterward;
- Paseo creates a separate local workspace for the same project/checkout and
  launches one matching orchestrator-profile agent with `Orchestrator=true`;
- the launch prompt contains only the absolute handoff path;
- no current pin/reorder surface produces a concise manual-pin handoff, not a UI
  automation attempt or launch failure;
- manual launch remains complete when Paseo tools are absent;
- ambiguous workspace or agent creation state fails closed without duplication;
- source/install parity and full Northstar QA pass.

## Review Oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Continuation is a distinct normal orchestrator activation. | The successor is routed through generic handoff, worker, or planning-delegate mode. | Reject before launch. | Router/activation assertion. |
| One lane has one mutation owner. | The source continues dispatch or merge work after the successor starts. | Transfer stops; source yields the lane. | Ownership-transfer scenario. |
| Paseo preserves project context without worker isolation. | Launch uses a branch-off worktree or a different project path. | Reject the transport plan. | Local-workspace scenario. |
| The successor is visibly classified. | Agent creation omits or lowercases the `Orchestrator` label. | Reject launch configuration. | Capitalized-label assertion. |
| The handoff remains the only briefing. | Initial prompt includes a transcript or second task description. | Reject before agent creation. | Exact prompt scenario. |
| Unsupported pinning stays manual. | The source tries browser/computer UI automation or treats missing pin control as fatal. | Report manual placement and continue. | Negative pinning scenario. |
| Transport ambiguity does not duplicate threads. | Workspace/agent creation returns an identity with an ambiguous error and the source retries. | Preserve the identity and stop that launch attempt. | Ambiguous-creation scenario. |
| Northstar remains usable without Paseo. | Required orchestration tools are absent. | Return the absolute handoff path for manual launch. | Manual fallback scenario. |

## Stop Conditions

- current `main` no longer contains the settled structural-validation boundary
  merged through PR 18;
- Paseo's supported label semantics cannot represent the capitalized
  `Orchestrator` agent label;
- implementation would require a new workspace-layout or pinning API;
- the source and successor cannot establish exclusive ownership of the lane;
- validation changes the plan.

## Next Task

Review the worker PR against all eight oracle rows and merge only after the
exact-head and required-check gate passes. Spec 034 remains a separate
not-ready language-package planning lane. Diversified model-routing remains a
separate serial planning note and must not start from this card.
