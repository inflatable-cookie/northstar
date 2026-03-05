# 01 Vision

Status: draft
Updated: 2026-03-05

## Why this section matters now

Vision is the first required write in a new implementation project.
It establishes long-term direction and constraints so downstream roadmap work stays coherent.

## Scope

Define long-horizon intent and directional constraints.
Avoid execution detail that belongs in architecture or roadmaps.

## Template layout

- `docs/vision/README.md` (index and writing rule)
- `docs/vision/001-<slug>.md` (first canonical vision artifact)
- `docs/vision/00n-<slug>.md` (additional vision artifacts)

## Naming and ordering

- Use 3-digit prefixes for vision artifacts: `001`, `002`, `003`.
- Keep sequence strictly increasing.
- File names are `NNN-<kebab-slug>.md`.

## Content contract (per vision artifact)

1. `Status`, `Owner`, `Purpose`
2. `## Long-Term Outcome`
3. `## Strategic Constraints`
4. `## Target Envelopes`
5. `## Alignment Signals`
6. `## Next Task`

## Dependencies

- Architecture and roadmap sections derive from accepted vision constraints.

## Open decisions

- Should one vision file be mandatory (`001`) before any additional vision files are allowed?

## Next task

Draft the canonical `docs/vision/README.md` index language and the baseline `001` starter template.
