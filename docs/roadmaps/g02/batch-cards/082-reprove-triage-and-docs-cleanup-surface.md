# 082 - Reprove Triage And Docs Cleanup Surface

Status: complete
Owner: repo maintainers
Updated: 2026-08-19
Master spec refs: `docs/specs/030-conversational-triage-and-docs-cleanup.md`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/architecture/system-architecture.md`, `effigy.toml`
Auto-start next card: no

## Ready-State Checks

- [x] Cards 080 and 081 are complete.
- [x] Validation commands are known and proportionate to the docs/skill scope.
- [x] The remaining uncertainty is live operator usage, not implementation.

## Objective

Reprove that the triage and cleanup behavior is present, copy-ready, routed,
portable, and consistent with the repository contract.

## Scope

- deterministic source checks and docs QA;
- installed-skill parity;
- final diff review and batch evidence.

## Acceptance Criteria

- [x] Bundle, repo-contract, command-surface, docs, QA, and parity checks pass.
- [x] No unrelated files or consumer repositories change.
- [x] The next task is live-use feedback, not another implementation guess.

## Validation

- `git diff --check`;
- `effigy check:bundle`;
- `effigy check:repo-contract`;
- `effigy check:command-skills`;
- `effigy qa:docs`;
- `effigy qa`;
- installed Northstar skill parity.

## Evidence

Record actual command output and the final changed-file review in the dated
batch log.

## Stop Conditions

- stop if a validation failure indicates a contract or route change;
- stop if parity cannot be proved;
- stop if live-use feedback is mistaken for implementation evidence.

## Next Task

Use the behavior in a real refresh or orchestrator conversation and record
operator feedback before archiving the master spec.
