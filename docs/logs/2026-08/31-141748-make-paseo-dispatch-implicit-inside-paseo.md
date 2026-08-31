# Make Paseo Dispatch Implicit Inside Paseo

Date: 2026-08-31
Roadmap: `g02.037`
Card: `g02.037/105`
Status: complete

## Result

Northstar orchestrator mode now treats injected Paseo profile, workspace, agent,
and follow-up tools as implicit authorization for routine dispatch of an
approved, ready worker lane. It does not ask for permission or merely suggest
Paseo first.

The orchestrator lists current profiles and selects from their notes plus the
Northstar role/risk rules. An operator-named profile remains the explicit
override. The selected profile supplies the worker provider, model, reasoning,
and feature settings through Paseo; Northstar stores no local profile names.

Project-root `paseo.json` remains optional worktree lifecycle configuration. Its
presence alone does not activate dispatch when the thread lacks Paseo tools.

## Authority boundary

- implicit authorization covers transport for ready lanes only;
- the committed absolute handoff remains the worker's sole briefing;
- absent tools use manual launch and operator relay;
- unready work, missing product or contract choices, material permissions,
  destructive workspace cleanup, ambiguous retry, review, and merge remain
  explicit stop or operator boundaries;
- partial setup preserves and reports created identities before any retry.

## Validation

- `git diff --check` — pass;
- skill creator `quick_validate.py skills/northstar` — pass;
- changed source/installed skill files — exact match;
- isolated `effigy check:skill-install` — pass, 125 files;
- configured-install audit — the two changed runtime files match; the whole
  package still differs on eight files from the concurrent Paseo lifecycle
  batch, which this task did not install or overwrite;
- `effigy qa:docs` — pass;
- `effigy qa` — pass, including the concurrent Paseo lifecycle-helper tests.

## Next

Use the next real bounded orchestrator lane as the live proof. Confirm automatic
profile selection and launch, path-only briefing, notification/follow-up flow,
manual fallback, and unchanged review/merge gates.
