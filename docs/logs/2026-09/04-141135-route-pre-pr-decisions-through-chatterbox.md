# Route Pre-PR Decisions Through Chatterbox

Date: 2026-09-04
Status: complete

## Trigger

A worker can stop before opening a PR with a real semantic blocker. Sending
that question from the mechanical coordinator straight to the operator loses
planning context and makes the coordinator interpret product meaning.

## Change

- Added a coordinator-to-Chatterbox `pre-PR decision request` carrying the
  worker's complete blocker capsule and verified paused state.
- Chatterbox returns a cited `Chatterbox ruling` when canonical or delegated
  planning authority already fixes the answer.
- When new material intent remains, Chatterbox explains the issue and options
  to the operator, promotes any durable planning change, and returns
  `operator-confirmed direction`.
- The coordinator resumes the same worker. It does not ask the semantic
  question itself, replace the worker, poll, or open a placeholder PR.
- Distinguished this blocker route from ordinary child waiting and the single
  empty-runway administrative notice.

## Evidence

- Spec 037, reusable doctrine, working rules, copy-ready template, architecture,
  router, Chatterbox/orchestrator modes, worker handoff template, skill prompt,
  and operator guidance share the same route.
- The routing checker now contains a twelfth oracle row covering both the
  existing-authority ruling and new-authority conversation branches.

## Validation

- `effigy check:model-routing` — passed, twelve oracle rows.
- `python3 /Users/tom/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/northstar` — passed.
- `effigy qa:docs` — passed.
- `effigy qa` — passed.
- `git diff --check` — passed.

## State

The coordinator remains mechanical. Chatterbox owns operator-facing planning
judgment at the pre-PR blocker boundary without gaining implementation,
supervision, review, or merge authority.
