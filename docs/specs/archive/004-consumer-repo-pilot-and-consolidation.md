# 004 - Consumer Repo Pilot And Consolidation

Status: complete
Owner: repo maintainers
Updated: 2026-04-09
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.001

## Problem

Northstar has now established and internally proven its live planning spine,
automation stack, readiness rubric, and closeout mechanics. The next risk is
false confidence: the system may still read well inside this repo while
breaking down when an operator tries to use it on a real consumer project.

## Target Operating Model

Northstar should prove itself outside its own repo in one explicit external
pilot loop:

- choose a real consumer repo
- run the operator workflow against live project conditions
- capture what actually helped and what was redundant or confusing
- consolidate the operator/docs/skill surfaces based on that evidence

## Goals

- Run the first real consumer-repo Northstar pilot.
- Capture operator-path evidence rather than relying on internal specimens
  alone.
- Trim or merge docs and prompts that did not materially help in practice.
- Feed the findings back into the reusable bundle and skill surfaces.

## Non-Goals

- Reopening the internal delivery-layer foundation work from `g01`.
- Inventing new doctrine without a live consumer-repo trigger.
- Expanding the public skill surface.

## Planned Surfaces

- operator workflow docs and pilot templates
- `northstar-plan`, `northstar-recover`, `northstar-handoff`, and setup wording
- reusable bundle docs where the pilot reveals ambiguity or redundancy
- live logs and roadmap generation state

## Acceptance Criteria

- One real consumer-repo pilot is run and recorded.
- The operator decision path is evidenced, not inferred.
- At least one concrete consolidation or trim decision is made from pilot
  findings.
- The next Northstar improvement lane is based on external evidence rather than
  internal speculation.

## Stop Conditions

- The pilot target repo is too incomplete or unstable to produce useful Northstar
  evidence.
- The work slips into generic doc rewriting without a recorded pilot result.
- The generation grows into a grab-bag instead of a focused external proof
  phase.

## Next Task

Continue `g02` with the execution-guardrails and longer-autonomy lane now that
the first external pilot and consolidation pass are complete.
