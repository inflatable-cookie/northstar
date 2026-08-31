# 036 - Use Optional Control Plane for Orchestrator Dispatch

Status: complete
Owner: repo maintainers
Created: 2026-08-31
Depends on: `g02.025`, contract `001-working-rules`
Vision tags: `orchestration`, `handoff`, `portability`, `control-plane`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`
Planning state: card 104 complete

## Problem

Northstar treats worktree managers, subagents, and session messaging as optional
adapters, but its executable orchestrator procedure still defaults to manual
launch and operator relay. Paseo now exposes profiles, isolated workspaces,
cross-provider agents, notifications, and follow-ups on this machine. Northstar
should use those capabilities when authorized without depending on Paseo or
letting control-plane state become execution authority.

## Goals

- [x] define one capability-aware dispatch path after the committed handoff;
- [x] preserve manual absolute-path dispatch as the complete fallback;
- [x] launch Paseo workers from the Northstar handoff instead of a generated
  second briefing;
- [x] select current agent profiles by notes and role/risk rather than fixed names;
- [x] keep permissions, PR review, merge, evidence, and closeout boundaries intact;
- [x] update the distributed skill and source/install evidence together.

## Non-goals

- no required Paseo dependency, `paseo.json`, plugin, or second Northstar skill;
- no automatic merge, permission approval, workspace archival, or worker retry;
- no changes to worker card readiness or the file-based authority chain;
- no consumer-repository mutation or live dogfood dispatch in this batch.

## Execution plan

Card `g02.036/104` promotes the accepted transport boundary into spec,
architecture, contract, handoff template, and orchestrator procedure, then
updates the skill install and validation evidence.

## Acceptance criteria

- [x] Paseo is used only when its tools are available and authorized for the run;
- [x] the worker starts in one isolated workspace from `origin/main` with only
  the absolute Northstar handoff path as its initial prompt;
- [x] `/paseo-handoff` is explicitly excluded from Northstar worker dispatch;
- [x] direct reports and follow-ups are transport evidence, not authority;
- [x] missing or failed adapter setup returns to a visible manual fallback
  without duplicate workers;
- [x] docs, skill validation, source/install parity, and repository QA pass.

## Next task

Lane complete. Dogfood the adapter on the next real bounded orchestrator lane
when Paseo is available and explicitly authorized.
