# 102 - Add Direct PR Review Route

Status: complete
Owner: repo maintainers
Updated: 2026-08-27
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/contracts/001-working-rules.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Auto-start next card: no

## Objective

Make a fresh Northstar thread asked to review an existing PR publish its verdict
and every required change on the PR instead of returning a chat-only review.

## Scope

- promote a direct PR-review boundary into doctrine, contract, spec, and
  architecture;
- add one internal routed mode for existing-PR review;
- update skill discovery and runtime prompt text;
- add deterministic checks for routing, provider record, and same-identity
  fallback;
- update the current roadmap and evidence chain.

## Ready-State Checks

- [x] The operator supplied the desired behavior and target surface.
- [x] Existing PR-review doctrine owns the change.
- [x] The route is provider-neutral and does not need branch mutation.
- [x] No provider wrapper, release mutation, or CI change is in scope.

## Acceptance criteria

- direct PR review is distinct from worker and orchestrator startup;
- an explicit review request authorizes only review mutations on the named PR;
- every merge-blocking finding is on the provider review surface;
- same-identity GitHub review uses a canonical `Changes required` comment;
- chat summarizes the review and introduces no new required change;
- posting failure leaves the review blocked rather than falsely complete;
- `effigy qa:docs`, `effigy qa`, and `git diff --check` pass.

## Stop conditions

- the route would need a second public skill or provider-specific implementation;
- review authority would imply branch mutation or merge authority;
- source and copy-ready contracts cannot state the same boundary;
- validation fails in a way that changes the plan.

## Resolution

- promoted the direct provider-record boundary into reusable doctrine, the
  copy-ready working-rules template, Northstar's contract, spec, and architecture;
- added the routed direct PR-review mode and made PR-review intent discoverable
  from the main skill and OpenAI runtime prompt;
- required formal changes-requested review when permitted, with one canonical
  `Changes required` comment for same-identity GitHub review;
- made chat summary-only and treated provider posting failure as a blocked review;
- added deterministic repo checks, passed docs/full QA, and synced a
  source-identical 121-file local development install.

## Next task

No blocking follow-up. Accept operator feedback from direct PR-review use.
