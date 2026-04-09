# Align Setup And Sync Skills

Status: complete
Owner: repo maintainers
Date: 2026-04-08
Roadmap refs: g01.001 batch 1.3
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/001-northstar-delivery-layer.md

## Summary

Aligned `northstar-setup` with the delivery-layer doctrine so stricter projects
install the guardrails and specs-promotion surfaces by default where
appropriate, then synced the updated skill set into Codex and Claude.

## Files Changed

- updated `skills/northstar-setup/` wording, metadata, and references
- updated the setup docs front-door template
- added `template-bundle/architecture/product-guardrails.md`
- updated the live roadmap, batch-card chain, and log index

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the full five-skill surface now follows the stronger delivery grammar where
  appropriate
- setup now installs the stricter delivery layer for complex or autonomy-heavy
  projects instead of leaving that decision implicit
- the remaining open work is the autonomy pilot rather than more setup doctrine

## Unresolved

- the autonomy envelope still needs a longer live run
- the current batch-card and stop-rule model still needs proof under sustained
  execution

## Next Task

Start batch 1.4 and run a longer live multi-card lane under the execution
policy so the autonomy envelope is tested against real use.
