# Add Papercuts Feedback Loop

Roadmap refs: g02.023, card 067

## What changed

- Defined a root-level `PAPERCUTS.md` queue for small, solvable execution
  friction.
- Made agents append at encounter time and create the file without operator
  intervention when it is missing.
- Kept papercuts separate from backlog and roadmap authority until normal
  maintenance triage.
- Promoted the rule into bundle doctrine, protocol navigation, contracts,
  architecture, the Northstar skill, generated `AGENTS.md`, and starter assets.
- Added source QA coverage for the root queue and reusable papercut surfaces.

## Evidence

- The live queue contains a real papercut from stale/noisy Effigy graph
  orientation encountered while implementing this feature.
- `effigy qa`: passed bundle and repo-contract checks.
- `effigy qa:docs`: passed repo-contract checks.

## Lane State

- g02.023 complete
- continuation envelope exhausted
- lane budget complete
- pause signal: `lane-complete`

## Next Task

Run the loop in one consumer repository, then review the first entries for
duplicates, promotion candidates, and false-positive noise.
