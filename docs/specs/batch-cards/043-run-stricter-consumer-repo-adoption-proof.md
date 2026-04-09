# 043 - Run Stricter Consumer-Repo Adoption Proof

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Master spec refs: docs/specs/013-stricter-consumer-repo-autonomy-adoption.md
Roadmap refs: g02.010 batch 10.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/013-stricter-consumer-repo-autonomy-adoption.md
Auto-start next card: yes, if the bounded findings are explicit

## Objective

Test the stricter delivery-layer adoption threshold against a real active
consumer repo.

## Scope

- inspect one active consumer-repo lane
- decide whether roadmap-only mode is still the correct posture or whether the
  stricter layer is warranted
- define the minimum additional surfaces if adoption is justified

## Steps

1. Select the active target repo and lane deliberately.
2. Evaluate whether the repo's current planning surfaces can express the needed
   autonomy state cleanly.
3. Record the minimum stricter surfaces needed if adoption is warranted.
4. Leave the consolidation batch explicit and ready.

## Acceptance Criteria

- the adoption-threshold proof is recorded against a real active repo
- the repo's correct posture is explicit: baseline remains enough, or stricter
  adoption is justified
- the minimum stricter surface is named if adoption is justified

## Evidence Required

- external-proof log
- updated roadmap/spec state

## Stop Conditions

- the proof starts retrofitting a repo before deciding whether adoption is
  warranted
- the proof degrades into another internal Northstar-only exercise

## Completion Notes

Signal remains valid as a baseline roadmap-mode repo at whole-repo scope, but
its active `g09` plugin-realization lane is deep enough that longer autonomous
runs would benefit from the stricter execution layer.

The proof-backed threshold is therefore sharper than a binary repo-wide choice:

- do not force a mature baseline repo into full stricter-mode conversion
- allow lane-first stricter adoption when one active lane needs explicit
  continuation-envelope, lane-budget, and pause-signal state
- the minimum likely surfaces for that lane are:
  - `docs/specs/README.md`
  - `docs/specs/batch-cards/README.md`
  - one active master spec for the lane
  - one or more active batch cards for the current bounded chain
  - no bulk retrofit of closed history

## Next Task

Start `g02.010` batch `10.3` by applying only the bounded findings from the
stricter consumer-repo adoption proof.
