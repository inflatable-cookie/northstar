# 005 - Align Setup With Delivery Layer

Status: complete
Owner: repo maintainers
Updated: 2026-04-08
Master spec refs: docs/specs/archive/001-northstar-delivery-layer.md
Roadmap refs: g01.001 batch 1.3
Governing refs: docs/contracts/001-working-rules.md, skills/northstar-setup/SKILL.md
Auto-start next card: yes, if validation passes and the next card is ready

## Objective

Update `northstar-setup` so stricter projects install the delivery-layer
guardrails and specs-promotion surfaces by default where appropriate.

## Scope

- update `northstar-setup` wording and references
- update the docs front-door template it uses
- add the missing copy-ready `product-guardrails.md` template to the bundle
- sync the updated skill installs into Codex and Claude

## Steps

1. Add setup guidance for when the stricter delivery layer should be installed.
2. Update the repo contract and docs front-door template so architecture,
   contracts, and optional specs are surfaced correctly.
3. Add the reusable `product-guardrails.md` template to the bundle.
4. Sync the updated skill set into Codex and Claude.
5. Re-run validation and record the result.

## Acceptance Criteria

- `northstar-setup` explicitly installs the stricter delivery-layer surfaces
  where appropriate
- the setup templates point users at architecture/contracts as the canonical
  surfaces
- the bundle includes a copy-ready `product-guardrails.md`
- Codex and Claude skill homes are synced to the updated repo state
- `effigy qa`
- `effigy qa:docs`

## Evidence Required

- updated files under `skills/northstar-setup/`
- updated bundle template files
- synced skill directories in both tool homes
- validation commands recorded in the batch log

## Stop Conditions

- setup still leaves complex repos on the baseline surface by default
- the stricter layer becomes mandatory even for tiny repos that do not need it

## Completion Notes

This card is complete. The remaining open work in `g01.001` is proving the
autonomy envelope in a longer live run.

## Next Task

Start the autonomy pilot and record where the current batch-card and stop-rule
model still fails under a longer uninterrupted session.
