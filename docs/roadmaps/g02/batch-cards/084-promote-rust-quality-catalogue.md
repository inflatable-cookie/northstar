# 084 - Promote Rust Quality Catalogue

Status: complete
Owner: repo maintainers
Updated: 2026-08-25
Master spec refs: `docs/specs/031-rust-quality-authoring-and-audit.md`
Roadmap ref: `g02.030`
Governing refs: `docs/contracts/004-language-quality-pack.md`, card 083
Auto-start next card: no

## Ready-State Checks

- [x] Card 083 selected Effigy-native Rhai with minimum Effigy `0.8.4`.
- [x] Catalogue, schema, projection, profile, and check paths are frozen.
- [x] Strict is the only production-valid profile; MSRV is repository-owned.
- [x] No production mode or command adapter is needed to complete this card.

## Objective

Promote the approved Rust catalogue, strict profile contract, schemas, and
mechanically checked workflow projections into the frozen production payload.

## Scope

- six approved normative rules plus evaluation-only `RUST-SLOP-001`;
- action-specific remediation overrides;
- strict-only production activation;
- shared authoring/audit projection checks;
- no benchmark corpus or historical evidence packs in the installed payload.

## Frozen Paths And Tasks

- payload root: `skills/northstar/references/language-quality/rust/`;
- canonical record: `catalogue.json`;
- schemas: `catalogue.schema.json`, `profile.schema.json`,
  `audit-manifest.schema.json`, `audit-unit.schema.json`, and
  `audit-result.schema.json`;
- checked views: `strict-authoring.json` and `strict-audit.json`;
- package check: `skills/northstar/scripts/check-rust-quality.rhai` exposed as
  `northstar/check:rust-quality`;
- consumer profile and deviation template names:
  `rust-quality-profile.json` and `rust-quality-deviations.json`.

This card raises `skills/northstar/effigy.toml`'s minimum to `0.8.4`. The
production payload must not hardcode Rust `1.95` or any other MSRV.

## Implementation Steps

1. Materialize the production catalogue and schemas at card 083's frozen paths.
2. Add the authoring and audit projections from that single record.
3. Add structural, provenance, maturity, profile, and authority regression tests.
4. Prove prototype-only fixtures and answer keys are absent from the payload.
5. Record the production hash and update the package inventory.

## Acceptance Criteria

- [x] One canonical production record generates or mechanically checks both
      workflow views.
- [x] Catalogue maturity, profile, unsafe, slop, and MSRV authority invariants
      have negative regression tests.
- [x] Production data contains pinned provenance but no prototype-only oracle.
- [x] Exact paths and commands match card 083.

## Validation

Run `effigy --repo skills/northstar northstar/check:rust-quality`, focused
negative tests, `git diff --check`, `effigy qa:docs`, and `effigy qa`.

## Evidence

See `docs/logs/2026-08/25-174148-promote-rust-quality-catalogue.md`.

## Stop Conditions

- stop if promotion creates a second catalogue authority;
- stop if any profile other than strict becomes production-valid;
- stop if a projected view can broaden remediation authority.

## Next Task

Card 085 is ready. The card-084 lane budget is exhausted; do not auto-start it
in this run.
