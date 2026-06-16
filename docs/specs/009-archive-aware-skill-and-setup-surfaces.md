# 009 - Archive-Aware Skill And Setup Surfaces

Status: complete
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.006

## Problem

Northstar now has a clearer spec lifecycle and a lean archive posture, but the
reusable automation layer still under-expresses that behavior. Setup, planning,
and recovery all mention archiving in prose, yet they do not make the archive
surface explicit enough in required outputs, quick starts, or reusable repo
shape. That makes the protocol easier to forget in day-to-day use than it
should be.

## Target Operating Model

Northstar's reusable automation layer should treat the archive posture as a
normal part of the docs contract:

- stricter repos that use specs should know when to install an archive surface
- planning and recovery should explicitly read and update the archive surface
  when cleanup or lifecycle transitions matter
- downstream repos should inherit the archive posture without needing extra
  operator explanation

## Goals

- align `northstar-setup` with the spec archive posture
- align `northstar-plan` and `northstar-recover` with archive-aware planning and
  cleanup behavior
- update the bundle surfaces where archive-aware setup should be copy-ready
- prove that the resulting reusable surface is explicit enough to rely on

## Non-Goals

- building archive automation that moves files without planning context
- turning the archive into a required heavy subsystem for every repo
- reopening the docs-tree cleanup that `g02.005` already proved

## Artifact Set

- `skills/northstar-setup/SKILL.md`
- `skills/northstar-plan/SKILL.md`
- `skills/northstar-recover/SKILL.md`
- `skills/northstar-setup/references/delivery-layer-adoption.md`
- `template-bundle/specs/README.md`
- `template-bundle/specs/archive/README.md`
- `docs/roadmaps/g02/006-align-archive-aware-skill-and-setup-surfaces.md`

## Archive-Aware Contract

### Setup

`northstar-setup` should treat the spec archive posture as part of the stricter
docs contract, not as optional cleanup trivia.

That means:

- when `specs/` are installed for a stricter repo, setup should also make the
  archive surface explicit
- setup should explain when `docs/specs/archive/` is warranted and when it is
  unnecessary overhead
- setup should leave downstream repos with a clear expectation that active
  planning stays in `docs/specs/` and preserved closed planning history moves
  out of that active tree

### Planning

`northstar-plan` should read and update the archive posture as part of normal
planning work when a lane crosses from active planning into preserved history.

That means:

- planning quick starts should not treat `docs/specs/` as the whole planning
  story once archive exists
- planning workflow should decide whether a closed planning artifact stays
  active, is briefly retired-in-place, or moves into archive
- planning outputs should leave the active specs lane cleaner when promotion or
  closeout has made older planning artifacts unnecessary in the live tree

### Recovery

`northstar-recover` should treat archive-aware cleanup as part of restoring a
coherent authority chain.

That means:

- recovery work should inspect both the active specs surface and the archive
  when stale planning is part of the problem
- recovery should archive, remove, or rewrite stale specs deliberately instead
  of merely warning about clutter
- recovery should avoid preserving obsolete specs in the active tree when they
  now only confuse the live planning lane

### Bundle Expectations

The reusable bundle should make the same posture copy-ready:

- `template-bundle/specs/README.md` should explain when the archive surface is
  part of the normal stricter docs contract
- `template-bundle/specs/archive/README.md` should stay lean and clearly
  subordinate to active planning
- stricter setup guidance should mention the archive surface when `specs/` are
  installed, rather than treating it as an optional afterthought

## Phased Delivery

### Phase 1

Define what archive-aware setup and planning behavior should look like in the
skills and bundle.

### Phase 2

Apply that alignment to the reusable skills, templates, and checks.

### Phase 3

Re-prove that the resulting reusable surface is explicit enough without adding
unnecessary complexity.

## Acceptance Criteria

- Northstar skills make the spec archive posture explicit where it affects
  setup, planning, and recovery.
- The bundle exposes the archive posture clearly enough for downstream repos.
- The resulting reusable surface is explicit enough to rely on without another
  archive-specific slice.

## Stop Conditions

- the lane turns into speculative feature creep beyond archive-aware behavior
- the archive posture becomes heavier in automation than in doctrine
