# 105 - Make Paseo Dispatch Implicit Inside Paseo

Status: complete
Owner: repo maintainers
Updated: 2026-08-31
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`, `g02.037`
Auto-start next card: no

## Objective

Use injected Paseo orchestration tools automatically for ready Northstar worker
lanes while keeping Northstar portable and preserving every non-transport
authority gate.

## Scope

- replace explicit current-run adapter permission with runtime tool detection;
- keep `paseo.json` project support separate from session detection;
- route workers through current Paseo profiles and Northstar role/risk guidance;
- retain manual dispatch and path-only worker briefing;
- sync the changed installed-skill files and close the evidence chain.

## Ready-State Checks

- [x] The operator explicitly requested implicit Paseo use inside Paseo.
- [x] Spec 026 owns the adapter policy and remains active.
- [x] Paseo project lifecycle support is present but is not a session signal.
- [x] The manual fallback and non-transport authority boundaries are settled.

## Acceptance Criteria

- required Paseo tool injection triggers profile discovery, workspace creation,
  and path-only worker launch without another permission prompt;
- an explicit operator profile choice wins; otherwise current profile notes and
  Northstar role/risk guidance select the worker;
- missing tools use the manual absolute-path handoff;
- `paseo.json` alone cannot activate dispatch;
- permissions, destructive cleanup, ambiguous retry, review, and merge remain
  outside implicit transport authority;
- skill/docs checks, source/install parity, and full QA pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Paseo use is implicit only in a Paseo runtime. | A repo has `paseo.json`, but the thread has no Paseo tools. | Orchestrator returns the absolute handoff for manual launch. | Spec, architecture, contract, and mode inspection. |
| Profiles control model/provider routing. | A remembered local profile or model name conflicts with current profile notes. | Orchestrator lists profiles and selects current configuration. | Mode and spec inspection. |
| Tool injection authorizes transport only. | A worker requests a material permission or the lane is not ready. | Orchestrator returns to the operator or planning instead of treating Paseo as authority. | Contract and stop-condition inspection. |
| Failed launch does not duplicate work. | Workspace creation succeeds and agent creation becomes ambiguous. | Orchestrator reports the identity and stops before retrying. | Mode stop condition and docs QA. |

## Evidence Required

- `git diff --check`
- skill validator on `skills/northstar/`
- isolated `effigy check:skill-install`
- exact source/install parity for the changed runtime files
- configured-install audit, with unrelated concurrent drift named if present
- `effigy qa:docs`
- `effigy qa`

## Stop Conditions

- session detection depends on project configuration instead of injected tools;
- the change stores local profile names or makes Paseo mandatory;
- implicit transport widens planning, permission, cleanup, review, retry, or
  merge authority;
- validation fails in a way that changes the design.

## Resolution

- made injected Paseo orchestration tools the implicit routine-dispatch signal;
- kept `paseo.json` as optional project lifecycle configuration rather than
  session detection;
- retained current-profile discovery, Northstar role/risk selection, and the
  explicit operator profile override;
- preserved manual launch plus planning, permission, cleanup, review, retry,
  and merge gates;
- synced the changed installed-skill files and passed 125-file isolated parity,
  docs QA, and full QA.

## Next task

Use the next real bounded orchestrator lane to prove automatic profile-based
Paseo dispatch and the manual fallback.
