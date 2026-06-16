# 019 - Underlay Consumer Cohort And Underlay-Reference Strict Pass

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.016

## Problem

Northstar has already recovered Underlay itself, but the wider Poodle-era
normalization wave still spans six consumer apps:

- `underlay-reference`
- `contact-patch`
- `songsprout`
- `acowtancy`
- `compli-me`
- `loophole/composer`

If these apps are handled ad hoc, Northstar will keep rediscovering the same
cohort state, migration order, and strictness expectations in chat instead of
preserving them in the planning spine.

## Target Operating Model

Northstar should treat these apps as one consumer cohort with:

- one explicit migration order
- one active first concrete app-level pass
- one deferred queue for the remaining apps
- a clear rule that the next app should be chosen from proof in the current
  app-level pass, not from memory

## Cohort Order

### 1. underlay-reference

- Why first:
  it is the cleanest reference consumer for retained Underlay surface rules and
  shared Poodle adoption expectations.
- Current owner:
  `acme-docs/roadmaps/g01/007-retained-underlay-surface-formalization.md`
- Immediate goal:
  install a full strict wrapper around `g01.007` without disturbing the live
  app worktree.

### 2. contact-patch

- Why next:
  likely to prove shared component normalization on a real app without the
  full administrative sprawl of `acowtancy` or `compli-me`.

### 3. songsprout

- Why near-term:
  another real consumer with app pressure, but still simpler than the heavier
  admin/workflow apps.

### 4. acowtancy

- Why later:
  more product-heavy admin/workflow surface area; better once the earlier
  cohort rules are sharper.

### 5. compli-me

- Why later:
  similar product/workflow weight to `acowtancy`; should follow once the
  tighter consumer migration pattern is more proven.

### 6. loophole/composer

- Why last:
  sits inside the broader Loophole rebuild program and is easiest to muddy with
  cross-repo planning noise if handled too early.

## Evidence To Close Current Tranche

- [x] Northstar records the Underlay consumer cohort and migration order
- [x] `underlay-reference` is named as the first concrete strict pass
- [x] the strict pass is installed around the honest live owner in
      `underlay-reference`
- [x] the `underlay-reference` thread proves the new strict wrapper is usable
- [x] the remaining consumer cohort installs are applied directly as a deliberate upgrade batch

## Current Cohort State

- `underlay-reference` — full strict posture installed under `acme-docs/`
- `contact-patch` — full strict posture installed under `cp-docs/`
- `songsprout` — full strict posture installed under `trellis/`
- `acowtancy` — full strict posture installed under `ledger/`
- `compli-me` — full strict posture installed under `docs/`
- `loophole/composer` — full strict posture installed under `composer-docs/`

## Risks

- Risk: Northstar forces a generic `docs/` strict install onto a repo whose
  authority already lives elsewhere.
- Mitigation: adapt the strict posture to repo-local authority when the live
  docs root is already different but coherent.

- Risk: the cohort queue turns into a vague list with no sequencing force.
- Mitigation: keep one active first concrete app-level pass and explicit
  deferred order.

## Stop Conditions

- `underlay-reference` strict work touches unrelated live app code
- the cohort order gets rewritten without proof from the active app-level pass
