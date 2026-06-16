# 020 - Formalize Nested Docs-Authority Setup

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.017

## Problem

The consumer strict-upgrade sweep showed that Northstar handles non-standard
docs roots coherently in practice, but still treats them like special cases in
its reusable package and setup surfaces. Repos such as `acme-docs/`,
`cp-docs/`, `trellis/`, `ledger/`, and `composer-docs/` required repeated
manual adaptation of front doors and native Effigy docs tasks.

## Goal

Make nested docs-authority repos a first-class Northstar setup mode so
adoption does not depend on repo-by-repo improvisation.

## Target Outcome

- the package and doctrine explicitly recognize nested docs-authority roots as
  a normal standard-spine variant
- setup guidance explains how native Effigy docs checks should be wired for
  nested authority repos
- copy-ready templates exist for both root-owned and nested-authority native
  Effigy config
- future strict installs should not need ad hoc task-prefix repair to validate
  nested docs surfaces

## Ready Chain

- `062-promote-nested-docs-authority-support-into-setup.md` — complete
