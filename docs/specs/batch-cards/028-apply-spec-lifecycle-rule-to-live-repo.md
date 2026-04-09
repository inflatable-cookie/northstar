# 028 - Apply Spec Lifecycle Rule To Live Repo

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Master spec refs: docs/specs/008-spec-lifecycle-and-archive-mechanics.md
Roadmap refs: g02.005 batch 5.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/README.md
Auto-start next card: yes, if the re-proof batch is explicit

## Objective

Apply the lifecycle and archive rule to Northstar's own specs surface so
`docs/specs/` mostly reflects active planning again.

## Scope

- move or retire stale planning artifacts according to the new rule
- keep active planning lanes obvious
- preserve useful history without leaving it as shadow authority in the active
  tree

## Steps

1. Identify stale master specs and closed batch-card lanes.
2. Apply the archive or retirement rule to those artifacts.
3. Refresh live front doors and indexes if the specs surface changes materially.

## Acceptance Criteria

- the live specs surface reflects mostly active planning
- archived or retired artifacts remain traceable
- the next re-proof batch is explicit

## Evidence Required

- updated specs surface
- application log with moved/retired artifacts recorded

## Stop Conditions

- active planning gets swept into archive
- useful traceability is lost

## Completion Notes

Applied the lifecycle rule to the live repo by archiving closed master specs
`001` through `007` and completed batch cards `001` through `027`, leaving the
active specs surface focused on:

- the live master spec `008-spec-lifecycle-and-archive-mechanics`
- the just-completed live cleanup card as batch evidence
- the ready re-proof card for the same active lane

Traceability is preserved under `docs/specs/archive/` without leaving those
closed artifacts in the active planning tree.

## Next Task

Start `g02.005` batch `5.3` by re-proving the specs surface after the
lifecycle update.
