# 029 - Re-Prove Specs Surface After Lifecycle Update

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/008-spec-lifecycle-and-archive-mechanics.md
Roadmap refs: g02.005 batch 5.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/README.md
Auto-start next card: yes, if the next slice is explicit

## Objective

Re-run the specs path after the lifecycle update and record whether the surface
is now focused enough to live with.

## Scope

- re-run the live specs path after archive/retirement changes
- record whether the resulting surface is clearer and still traceable
- compile the next slice if another bounded problem remains

## Steps

1. Re-run the specs path through the live repo.
2. Record what ambiguity or clutter still remains acceptable.
3. Compile the next slice only if another bounded problem is evident.

## Acceptance Criteria

- the updated specs surface is re-proved
- remaining ambiguity is explicit and bounded
- the next slice is explicit only if warranted

## Evidence Required

- re-proof log
- updated roadmap/spec state if another slice opens

## Stop Conditions

- the re-proof turns into another speculative cleanup lane
- the archive posture still leaves the active surface broadly cluttered

## Completion Notes

The re-proof showed that the cleaned active specs surface is now materially
clearer:

- `docs/specs/` contains one live master spec plus the live card pair for the
  current lane
- closed planning history remains traceable under `docs/specs/archive/`
- the archive is lean enough to preserve history without acting as a second
  active planning tree

That is good enough to live with for the docs surface itself. The next bounded
gap is in the reusable automation layer: setup, planning, and recovery surfaces
should make the archive posture more explicit so downstream repos follow it
without special prompting.

## Next Task

Start `g02.006` batch `6.1` by aligning the setup, plan, and recover surfaces
with the spec archive posture so downstream repos inherit it more reliably.
