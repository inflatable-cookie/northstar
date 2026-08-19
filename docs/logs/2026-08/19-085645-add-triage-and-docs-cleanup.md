# Add Conversational Triage And Docs Cleanup

Status: complete — implementation batch; live-use feedback remains
Created: 2026-08-19
Roadmap: `g02.029-add-conversational-triage-and-docs-cleanup`
Batch: `g02.029/080` through `g02.029/082`

## Summary

Northstar now has a standard `docs/triage/` capture buffer for unresolved
observations and a safe cleanup route for docs drift. Orchestrator and refresh
guidance captures useful threads before a deeper branch is followed, while
refresh and cleanup require an explicit disposition instead of silently
discarding material.

## Changes

- added live, full-bundle, and minimal `triage/README.md` anchors;
- documented the handoff-matched `YYYYMMDD-HHMMSS-<slug>.md` naming rule and
  lightweight Markdown body policy;
- promoted triage lifecycle and authorization boundaries into the working-rules
  contract, architecture, protocol kernel, standard-spine docs, setup guidance,
  operator docs, sweeps, and front doors;
- added regular triage checkpoints to orchestrator mode and triage inspection,
  capture, and disposition to project refresh;
- added `cleanup-docs` mode and `/northstar-cleanup` adapter for inspect-first,
  classify, rehome, and ask-before-uncertain docs maintenance;
- updated bundle, repo-contract, command-surface, and installed-skill parity
  surfaces.

## Validation Performed

- `git diff --check` — passed;
- `effigy check:bundle` — passed;
- `effigy check:repo-contract` — passed;
- `effigy check:command-skills` — passed: 7 adapters, 394 aggregate description
  characters;
- `effigy qa:docs` — passed;
- `effigy qa` — passed;
- `effigy doctor` — passed with no findings;
- `effigy check:posture-advisory` — passed with 0 warnings;
- `effigy check:skill-install /Users/tom/.agents/skills/northstar` — passed:
  49 files in parity.

## Evidence

The source and installed skill trees contain the same cleanup mode, adapter,
router, orchestrator, refresh, setup, and metadata files. The live docs and
copy-ready bundles expose the same triage filename and lifecycle contract.

## Risks

- Live operator use has not yet measured whether checkpoint cadence feels
  natural or whether triage pruning creates too much noise.
- Triage remains intentionally non-authoritative; material notes still need
  promotion into normal planning surfaces before execution.

## Next Task

Use `northstar-refresh` or an orchestrator conversation against a real project,
inspect the resulting triage notes, and record operator feedback before
retiring or archiving spec 030.
