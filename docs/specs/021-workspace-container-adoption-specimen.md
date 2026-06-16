# 021 - Workspace-Container Adoption Specimen

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.018

## Problem

Northstar now describes nested docs-authority repos clearly, but setup still
leans on prose where a concrete workspace-container specimen would teach the
pattern faster and with less operator interpretation.

## Goal

Add one reusable workspace-container adoption specimen that shows how a thin
workspace root, nested docs-authority repo, and native Effigy validation
should fit together.

## Target Outcome

- one concrete specimen exists in the setup references
- setup docs and templates point at it
- future multi-repo migrations can copy from a real pattern instead of
  re-deriving the shape from doctrine alone

## Ready Chain

- `063-add-workspace-container-adoption-specimen.md` — complete
