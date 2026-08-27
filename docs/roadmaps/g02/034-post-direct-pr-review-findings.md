# 034 - Post Direct PR Review Findings

Status: complete
Owner: repo maintainers
Created: 2026-08-27
Depends on: `g02.025`, contract `001-working-rules`
Vision tags: `review`, `provider-record`, `agent-routing`
Governing refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`,
`docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Planning state: card 102 complete

## Problem

Northstar defines provider-recorded review inside an orchestrator/worker loop,
but a fresh thread asked only to review an existing PR has no direct route. It
can therefore return blocking findings in chat without posting them on the PR.

## Goals

- [x] route direct existing-PR review requests without starting worker mode;
- [x] make the provider review surface the durable record;
- [x] require every merge-blocking finding on the PR before chat summary;
- [x] preserve a same-identity `Changes required` comment fallback;
- [x] prove source docs, templates, skill packaging, and full repo QA.

## Non-goals

- no branch edits, commits, pushes, merge, or closeout authority from review;
- no provider-specific wrapper or automatic merge;
- no always-loaded root instruction for a task-specific procedure;
- no compatibility alias or second public review skill.

## Execution plan

Card `g02.034/102` promotes the direct-review boundary into doctrine and the
Northstar source contract, adds one routed skill mode, updates discoverability,
and makes repo QA hold the critical posting rules.

## Acceptance criteria

- [x] a fresh thread with an existing PR URL routes to direct PR-review mode;
- [x] blocking findings must be posted on the provider review surface;
- [x] formal changes-requested review is preferred and same-identity review uses
  one canonical `Changes required` comment;
- [x] chat cannot become the only home of a required change;
- [x] `effigy qa:docs` and `effigy qa` pass.

## Next task

Lane complete. Accept direct PR-review usage feedback; no follow-up is blocked.
