# 01 Vision

Status: active
Updated: 2026-03-05

## Why this section matters now

Vision is the first required write in a new implementation project.
It sets long-term direction and constraints so architecture and roadmap work stays coherent.

## Scope

Define long-horizon intent and directional constraints.
Do not include milestone task lists or delivery sequencing detail.

## Template layout

- `docs/vision/README.md` (index and writing rule)
- `docs/vision/001-<slug>.md` (first canonical vision artifact)
- `docs/vision/00n-<slug>.md` (additional vision artifacts)
- `docs/vision/vision-tag-rubric-template.md` (delta marker vocabulary)
- `docs/vision/vision-scorecard-template.md` (periodic posture review)
- `docs/vision/risk-checkpoint-ledger-template.md` (dated strategic risk tracking)

## Naming and ordering

- Use 3-digit prefixes: `001`, `002`, `003`.
- Keep sequence strictly increasing.
- Use `NNN-<kebab-slug>.md`.

## Content contract (per vision artifact)

1. `Status`, `Owner`, `Purpose`
2. `## Long-Term Outcome`
3. `## Strategic Constraints`
4. `## Target Envelopes`
5. `## Alignment Signals`
6. `## Next Task`

## Vision governance rule (lean)

- Keep governance lightweight and periodic.
- Use scorecards/checkpoint ledger at defined review points (for example monthly/quarterly), not per task.
- Prefer short, evidence-linked updates over heavyweight process overhead.

## Dependencies

- Architecture and roadmaps derive from accepted vision constraints.
- `001` must exist before first roadmap milestone is created.

## Next task

Align vision starter templates with the rubric/scorecard/checkpoint artifacts and keep review cadence explicitly periodic.
