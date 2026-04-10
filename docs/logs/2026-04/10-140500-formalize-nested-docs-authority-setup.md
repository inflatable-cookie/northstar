# Formalize Nested Docs-Authority Setup

Date: 2026-04-10
Roadmap refs: g02.017
Spec refs: docs/specs/020-formalize-nested-docs-authority-setup.md

## Summary

Closed the Underlay consumer cohort lane and promoted its main setup lesson
back into Northstar: nested docs-authority repos are now treated as a
first-class setup mode instead of bespoke migration cleanup.

## Evidence

- closed `g02.016` and opened `g02.017`
- updated standard-spine doctrine to recognize nested docs-authority repos as
  a normal mode
- updated template-bundle and `northstar-setup` guidance with explicit nested
  authority support
- added a copy-ready `effigy.native.docs-authority.toml.template`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Next Task

Keep testing the package against real repos and use the next recurring setup
friction to decide whether Northstar now needs a dedicated workspace-container
adoption specimen or whether the current nested-authority guidance is enough.
