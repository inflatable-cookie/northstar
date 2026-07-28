# 066 - Enforce And Prove Skill Portability

Status: complete
Owner: repo maintainers
Updated: 2026-07-28
Master spec refs: none
Governing refs: `docs/contracts/001-working-rules.md`,
`bundle-docs/skills/README.md`, `g02.022`
Auto-start next card: no

## Ready-State Checks

- [x] Objective is bounded enough to finish without fresh planning decisions.
- [x] Governing refs point at current canonical surfaces.
- [x] Scope boundaries and stop conditions are explicit.
- [x] Acceptance criteria, validation, and evidence requirements are explicit.
- [x] No unresolved planning or intent gap governs this card.
- [x] Auto-start is disabled at lane closeout.

## Objective

Make detached skill portability a blocking repo-contract check, refresh the
installed copy, and close the repair lane with evidence.

## Lane Runway Context

- Higher-level lane owner: g02 reusable bundle/skill hardening runway
- Next transition: lane closeout
- Next planning checkpoint: next queued g02 milestone

## Scope

- add one reusable recursive Markdown-link guard
- wire it to `skills/northstar/`
- update currentness assertions affected by g02.022
- refresh the installed skill only after source QA passes
- do not add a separate Effigy task or broad Markdown linter

## Steps

1. Add the portable-link guard and its contract invocation.
2. Run focused negative/positive checks and `effigy qa`.
3. Refresh the installed skill and compare it with source.
4. Close cards, milestone, front doors, and batch evidence.

## Acceptance Criteria

- QA rejects missing or escaping local skill links
- `effigy qa` passes
- installed and source skill trees match
- roadmap and log surfaces reflect lane closure

## Evidence Required

- focused guard failure proof
- `effigy qa`
- detached installed-copy audit
- source/install comparison

## Continuation Envelope

- Auto-start next card: no
- In-bounds next card: none
- Remaining ready chain after this card: 0
- Transition proof required before auto-start: none

## Lane Budget

- Current card ends budgeted run: yes
- Further operator decision required after this card: yes
- Pause signal if run stops here: lane-complete

## Stop Conditions

- Stop if QA changes require a generic Markdown parser or unrelated checker
  refactor.
- Stop if the installed target cannot be resolved exactly.

## Completion Notes

Added a recursive portable-link guard to `check:repo-contract`; proved it
rejects the original installed escape and a missing internal target; passed
source QA; refreshed `~/.agents/skills/northstar`; confirmed 29-file parity and
zero installed link failures.

## Next Task

Lane complete. Queue the next contract-backed g02 milestone when new work is
ready.
