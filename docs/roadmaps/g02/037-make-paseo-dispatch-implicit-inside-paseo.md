# 037 - Make Paseo Dispatch Implicit Inside Paseo

Status: complete
Owner: repo maintainers
Created: 2026-08-31
Depends on: `g02.036`, contract `001-working-rules`
Vision tags: `orchestration`, `handoff`, `portability`, `control-plane`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`
Planning state: card 105 complete

## Problem

The first Paseo adapter required a separate operator authorization even when
Paseo had already injected its orchestration tools into the active orchestrator
thread. That made the orchestrator ask for a control-plane choice the runtime
had already settled and prevented agent profiles from acting as the normal
worker-routing surface.

The new project-root `paseo.json` support solves repository lifecycle setup, but
its presence cannot prove that a particular thread is running inside Paseo.
Runtime tool injection and project capability configuration need distinct jobs.

## Goals

- [x] treat injected Paseo orchestration tools as implicit authorization for
  routine dispatch of approved, ready worker lanes;
- [x] list current profiles and select from their notes plus Northstar role/risk
  rules, with an explicit operator profile choice as the override;
- [x] keep `paseo.json` as optional project lifecycle configuration rather than
  a runtime-detection signal;
- [x] preserve manual dispatch when the tools are absent;
- [x] preserve planning, permission, cleanup, review, retry, and merge gates;
- [x] update and validate the distributed orchestrator procedure.

## Non-goals

- no required Paseo dependency or stored local profile names;
- no automatic dispatch of unready or operator-unapproved product work;
- no automatic permission approval, destructive cleanup, duplicate retry,
  review verdict, or merge;
- no change to the committed handoff as the worker's sole briefing.

## Execution plan

Card `g02.037/105` replaces the explicit adapter permission check in the active
spec, architecture, contract, router, and orchestrator mode. It then syncs the
installed skill and validates the result alongside the concurrent Paseo project
lifecycle work.

## Acceptance criteria

- [x] an orchestrator with injected Paseo profile/workspace/agent/follow-up tools
  dispatches a ready lane without asking or suggesting first;
- [x] an orchestrator without those tools returns the absolute handoff for
  manual launch;
- [x] `paseo.json` alone never activates control-plane dispatch;
- [x] current profile notes and Northstar role/risk rules determine the worker,
  unless the operator named a profile;
- [x] all non-transport authority gates remain explicit;
- [x] docs, skill validation, changed-file source/install parity, and repository
  QA pass.

## Next task

Lane complete. Use the next real bounded orchestrator lane as the live Paseo
dispatch proof.
