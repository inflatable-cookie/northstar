# Bootstrap Live Northstar Docs

Status: complete
Owner: repo maintainers
Date: 2026-04-08
Roadmap refs: g01.001 batch 1.1
Governing refs: docs/contracts/001-working-rules.md

## Summary

Established a live `docs/` spine for the Northstar repo itself and captured the
delivery-layer/autonomy doctrine as active Northstar artifacts instead of
leaving it only in chat.

## Files Changed

- added repo-local `docs/` sections for vision, architecture, contracts, specs,
  roadmaps, and logs
- added the delivery-layer doctrine section in `bundle-docs/sections/`
- updated repo front doors and validation so the live docs spine is now part of
  the repo contract

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- Northstar now has a real internal planning spine for its own development
- the repo carries explicit product guardrails and compact working rules for
  done-ness and autonomy
- the first master spec, batch card, and roadmap milestone exist
- follow-on work is now sequenced rather than implied

## Unresolved

- the reusable template bundle still needs canonical delivery-layer artifacts
- the installable skills still need to emit and preserve the new delivery-layer
  surfaces by default
- the autonomy envelope still needs a longer live pilot

## Next Task

Execute `g01.001` batch 1.2 by promoting the minimum reusable delivery-layer
artifacts into `template-bundle/`.
