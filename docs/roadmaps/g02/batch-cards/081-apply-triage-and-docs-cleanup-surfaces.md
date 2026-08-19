# 081 - Apply Triage And Docs Cleanup Surfaces

Status: complete
Owner: repo maintainers
Updated: 2026-08-19
Master spec refs: `docs/specs/030-conversational-triage-and-docs-cleanup.md`
Governing refs: `skills/northstar/SKILL.md`, `skills/northstar/references/router.md`, `skills/northstar/references/modes/orchestrator.md`, `skills/northstar/references/modes/project-refresh.md`
Auto-start next card: yes

## Ready-State Checks

- [x] Contract card 080 is complete.
- [x] Scope is limited to docs, skills, templates, and deterministic checks.
- [x] No production or consumer-repository change is required.
- [x] Acceptance and validation are explicit.

## Objective

Ship the triage folder in the live and copy-ready docs spines, prompt regular
capture in conversational modes, make refresh manage note lifecycle, and expose
the safe cleanup route through the one installable Northstar skill.

## Scope

- `docs/triage/`, `template-bundle/triage/`, and minimal starter anchor;
- bundle doctrine and operator/setup guidance;
- orchestrator, refresh, router, cleanup mode, adapter, and skill metadata;
- command, bundle, and repo-contract check surfaces.

## Acceptance Criteria

- [x] All copy-ready spines name triage and its filename format.
- [x] Orchestrator and refresh capture unresolved material before deep dives.
- [x] Cleanup inventories `/docs`, classifies drift, and asks on ambiguity.
- [x] The new adapter remains thin and loads the router plus one mode.

## Validation

- `effigy check:command-skills`;
- `effigy check:bundle`;
- `effigy check:repo-contract`;
- `git diff --check`.

## Evidence

The implementation is represented by the changed docs, skill, adapter, and
checker files in this batch. Deterministic results are recorded by card 082.

## Stop Conditions

- stop if a copy-ready surface becomes Northstar-source-specific;
- stop if the new route creates a second installable skill;
- stop if a cleanup instruction permits blind deletion.

## Next Task

Run the full validation board and record the evidence.
