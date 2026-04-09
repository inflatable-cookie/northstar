# Standard Docs Spine Autonomy Pilot

Status: complete
Owner: repo maintainers
Date: 2026-04-08
Roadmap refs: g01.001 batch 1.4
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/001-northstar-delivery-layer.md

## Summary

Ran a live three-card lane under the written execution policy to make the
standard stricter docs spine explicit, align `northstar-setup` with it, tighten
the repo contract check, and then validate the run as one batch.

## Files Changed

- added `bundle-docs/sections/09-standard-docs-spine.md`
- updated bundle docs and template-bundle READMEs to expose the baseline versus
  stricter docs spines directly
- added `template-bundle/contracts/001-working-rules-template.md`
- added `template-bundle/specs/batch-cards/README.md`
- updated `skills/northstar-setup/` wording, references, and docs template
- tightened `scripts/check-northstar-repo-contract.sh`
- updated the live roadmap, master spec, working rules next-task chain, and
  batch-card state

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the stricter docs spine is now a clear published Northstar surface rather
  than a pattern scattered across doctrine and setup copy
- setup can scaffold the stricter spine from concrete bundle files instead of
  inferring the working-rules and batch-card surfaces
- the repo contract check now defends the standard docs spine so this repo is
  less likely to drift away from the published protocol
- the autonomy pilot succeeded as a single uninterrupted three-card run

## Autonomy Findings

- the pilot was safe to continue across ready cards because the lane was
  defined clearly up front and the intermediate cards used local evidence
  gates instead of demanding a full QA pass after each edit cluster
- the main remaining limit is ready-state selection: choosing the next useful
  two or three cards still depends on manual judgment more than it should
- closeout is also still too manual because card state, roadmap state, spec
  state, and logs all need coordinated updates at the end of the lane
- the framework now has enough doctrine; the next leverage point is making
  those state transitions more mechanical

## Unresolved

- Northstar still needs a clearer ready-state rubric so an agent can identify
  the next valid multi-card chain with less operator steering
- Northstar still needs a tighter closeout pattern so uninterrupted runs end
  with less manual state synchronization

## Next Task

Compile `g01.002` from these findings and focus it on ready-state selection and
closeout mechanics for longer hands-off execution.
