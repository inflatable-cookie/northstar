# Specs

Use this folder when a change needs provisional planning before it is settled
into architecture and contracts.

## Artifact types

- `NNN-<slug>.md`
  master specs for material goals or epics
- `batch-cards/NNN-<slug>.md`
  tightly scoped execution cards derived from an active master spec
- `batch-cards/README.md`
  explains how the batch-card lane should work in a stricter repo

## Rule

Specs are a stepping stone, not the final authority.

Use specs to work through a change while the path is still being shaped.
Once the durable outcomes are accepted:

- structural decisions should be promoted into `docs/architecture/`
- behavioral or policy rules should be promoted into `docs/contracts/`

Roadmap execution should rely on architecture and contracts, not only on raw
spec text, once the change has moved out of planning.

Specs are usually provisional, but not necessarily deleted the moment a roadmap
exists.

- keep a spec while the lane is still active, the planning history is still
  useful, or later batches still rely on its shaped context
- archive or remove a spec when the lane is closed and the spec no longer adds
  value beyond the promoted architecture and contract surfaces
- do not leave specs around as shadow authority once the canonical surfaces are
  already carrying the truth

Use an explicit lifecycle:

- `active` when the spec still governs live planning or an imminent batch
- `retired-in-place` when the lane is closed but the artifact still deserves a
  short-lived place in the active tree for traceability
- `archived` when the artifact no longer governs live work and should move out
  of the active specs surface

Prefer archive over indefinite retired-in-place clutter.

When archive is warranted:

- move the artifact under `docs/specs/archive/`
- keep that archive lean and traceable rather than elaborate
- do not treat archived specs as canonical execution authority

For stricter repos, seed `docs/specs/archive/README.md` up front so preserved
closed artifacts already have a defined home before the first cleanup batch.

Make spec hygiene explicit in normal project maintenance:

- tidy `docs/specs/` regularly so it mostly reflects active planning
- treat spec cleanup as part of closeout and recovery, not as a rare special
  project
- prefer a smaller active specs folder over preserving every historical plan in
  place forever

Treat `ready` as a real state:

- a card is ready only when it can execute without fresh planning decisions
- a short auto-continuation chain is ready only when every transition is
  already represented in file state
- the previous closeout should leave a `Next Task` that lets a later bare
  `continue` resolve to the right ready card without a giant reminder prompt

If a repo wants the full continuation-envelope, lane-budget, and pause-signal
model, use this `specs/` layer with batch cards. A roadmap-only repo can still
route live work well, but it should not pretend to carry the same explicit
autonomy state.

In a mature baseline repo, you may introduce this layer lane-first for the
active work that needs it. Start with the current lane and bounded active
batch-card chain instead of backfilling closed history.

If the project is moving toward full strict Northstar compliance, treat that
lane-first seed as the first migration step rather than the final target.

In that migration, the expected progression is:

1. prove the stricter surface on one active lane
2. expand it to become the default for new material lanes
3. treat full strict compliance as the project-level operating state

Do not leave mixed posture unexamined once the project has already decided the
strict doctrine is the intended destination.

For a mature repo migrating toward full strict compliance, use one active
migration master spec to keep the rollout operational.

That migration spec should record:

- current posture
- satisfied checkpoints
- blocking gaps
- whether mixed posture is still valid migration state or has become drift
- current tranche
- next tranche
- the evidence needed to close the current tranche

Use the paired roadmap milestone to sequence the migration work and logs to
prove each completed tranche. Do not invent a separate governance tracker for
this.

## Templates

- `batch-cards/README.md`
- `archive/README.md`
- `templates/master-spec-template.md`
- `templates/batch-card-template.md`
- `templates/strict-compliance-migration-template.md`

## Next Task

Create a master spec only when a change is large or uncertain enough to justify
provisional planning before promotion into architecture/contracts, and archive
closed planning artifacts once they no longer belong in the active specs tree.
