# 008 - Tighten Repo Contract And Log Autonomy Pilot

Status: complete
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/001-northstar-delivery-layer.md
Roadmap refs: g01.001 batch 1.4
Governing refs: docs/contracts/001-working-rules.md, scripts/check-northstar-repo-contract.sh, docs/roadmaps/g01/001-enact-northstar-on-northstar.md
Auto-start next card: no

## Objective

Make the new standard stricter docs spine enforceable in this repo, then log
what the uninterrupted multi-card run proved and where autonomy still needs
tighter guardrails.

## Scope

- tighten the repo contract check around the stricter docs spine
- run the repo validation path once after the three-card lane
- update the live roadmap/spec state to reflect the completed pilot
- add a batch log with the autonomy findings

## Steps

1. Update the repo contract check for the new stricter docs spine surfaces.
2. Run `effigy qa` and `effigy qa:docs`.
3. Update the active roadmap and any affected live planning refs.
4. Add the autonomy-pilot batch log with the evidence and findings.

## Acceptance Criteria

- the repo contract check enforces the newly explicit stricter docs spine
- validation passes with `effigy qa` and `effigy qa:docs`
- the roadmap and batch-card state reflect the completed lane accurately
- the log names what still limits longer hands-off execution

## Evidence Required

- updated `scripts/check-northstar-repo-contract.sh`
- validation command output recorded in the batch log
- updated roadmap/batch-card state
- new autonomy-pilot log under `docs/logs/2026-04/`

## Stop Conditions

- the repo check still permits the stricter spine to drift silently
- the log claims the pilot succeeded without naming residual autonomy gaps

## Completion Notes

The three-card lane ran cleanly and validated at the end of the run. The main
remaining autonomy limit is not missing doctrine; it is the still-manual work
of choosing the next ready chain and closing state cleanly across cards,
roadmaps, specs, and logs.

## Next Task

Compile the next significant delivery-layer milestone from the pilot findings,
with emphasis on ready-state selection and closeout mechanics.
