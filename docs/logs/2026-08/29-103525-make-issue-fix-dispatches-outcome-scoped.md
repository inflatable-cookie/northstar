# Issue-fix dispatches now own diagnosis through repair

Date: 2026-08-29
Surface: orchestrator worker-PR loop; delivery autonomy

Operator feedback exposed an authority gap: a reported issue could be split
into a diagnostics-only worker PR even when the requested outcome was a fix.
That made temporary instrumentation a separate review cycle and left the real
repair for another dispatch.

The corrected rule is outcome-scoped:

- a fix lane covers reproduction, diagnosis, the smallest complete contract-valid
  repair, removal of temporary diagnostics, validation, evidence, and PR;
- the card can be ready without a known root cause or exact edit when the
  failure, expected behavior, boundaries, validation, and stop conditions are
  clear;
- the worker owns ordinary causal and code-level judgment inside that envelope;
- diagnostics-only dispatch requires an explicit evidence-only request or a
  named blocker that prevents safe implementation.

Changed: delivery doctrine, live and copy-ready working-rules contracts, active
orchestrator spec, orchestrator mode, worker handoff template, and repo-contract
drift checks.

Validation: `git diff --check`; `effigy qa:docs`.

## Next task

Use the next real issue-fix dispatch as dogfood and record whether the worker
reaches a reviewable fix without a separate diagnostics PR.
