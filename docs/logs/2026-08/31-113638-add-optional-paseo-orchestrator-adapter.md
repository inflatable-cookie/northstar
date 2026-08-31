# Add Optional Paseo Orchestrator Adapter

Date: 2026-08-31
Roadmap: `g02.036`
Card: `g02.036/104`
Status: complete

## Result

Northstar orchestrator mode now uses Paseo as a conditional transport adapter
when its tools are available and the operator authorizes it for the run. It
lists current profiles, selects by notes and role/risk, creates one worktree
workspace from `origin/main`, and launches the worker with only the absolute
committed Northstar handoff path.

Manual launch and operator relay remain complete fallbacks. Control-plane IDs,
profiles, messages, and lifecycle state are transport metadata. Repository
planning, the handoff, branch, PR, checks, provider review record, and explicit
merge authority remain canonical.

## Boundary changes

- `/paseo-handoff` is excluded from Northstar worker dispatch because it would
  create a second briefing;
- finish and permission notifications replace polling;
- bounded continuation and requested changes reuse the same Paseo agent;
- permission requests return to the operator unless existing authority settles
  the exact action;
- partial setup reports any created workspace or agent and stops before a
  duplicate launch;
- no Paseo dependency, local profile name, `paseo.json`, or automatic workspace
  cleanup was added to Northstar.

## Validation

- `git diff --check` — pass;
- skill creator `quick_validate.py skills/northstar` — pass;
- `effigy qa:docs` — pass;
- isolated `effigy check:skill-install` — pass, 122 files;
- configured `effigy check:skill-install /Users/tom/.agents/skills/northstar`
  — pass, 122 files;
- `effigy qa` — pass.

## Next

Dogfood the adapter on the next real bounded orchestrator lane when Paseo is
available and explicitly authorized. Measure launch time, relay burden,
duplicate-workspace prevention, and review behavior before deciding any
automatic workspace-cleanup policy.
