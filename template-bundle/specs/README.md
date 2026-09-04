# Specs

**Type: OPTIONAL** -- Add this consequence-triggered folder when provisional planning is needed before promotion.

Use this folder when a change needs provisional planning before it is settled
into architecture and contracts.

## Artifact types

- `NNN-<slug>.md`
  master specs for material goals or epics

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

Seed `docs/specs/archive/README.md` up front so preserved closed artifacts
already have a defined home before the first cleanup batch.

Make spec hygiene explicit in normal project maintenance:

- tidy `docs/specs/` regularly so it mostly reflects active planning
- treat spec cleanup as part of closeout and recovery, not as a rare special
  project
- prefer a smaller active specs folder over preserving every historical plan in
  place forever
- before roadmap generation rollover, purge closed or stale specs from the
  active specs tree so the next generation starts from clean authority rather
  than inherited planning clutter

Treat `ready` as a real state:

- a card is ready only when it can execute without fresh planning decisions
- a short auto-continuation chain is ready only when every transition is
  already represented in file state
- the roadmap front doors should keep the live `Next Task` pointer so a later
  bare `continue` resolves to the right ready card without a giant reminder
  prompt

Treat planning as a real runway:

- do not leave a material lane with only one immediate card and no visible
  higher-level owner beyond it
- make the next few meaningful batches or milestone transitions visible
- leave an explicit planning checkpoint so the lane does not fall back into
  one-card-at-a-time improvisation after each closeout
- compile roadmaps as turnkey multi-batch milestones with checkbox execution
  plans; put step detail in batch cards, not per-thread roadmap scratchpads
  (`bundle-docs/sections/03-roadmaps.md`, *Scope and granularity rule*)

If a repo wants the full continuation-envelope, lane-budget, and pause-signal
model, use `specs/` for master specs and `roadmaps/gNN/batch-cards/` for
execution cards. A roadmap-only repo can still route live work well, but it
should not pretend to carry the same explicit autonomy state.

In a mature repository adopting the compact lifecycle, introduce this layer
where the active work needs provisional shaping. Start with the current lane
instead of backfilling closed history.

Keep incremental adoption operational inside the normal planning spine:
- satisfied compact lifecycle checkpoints
- blocking gaps
- whether migration state is still deliberate or has drifted
- current tranche
- next tranche
- the evidence needed to close the current tranche

Use the paired roadmap milestone to sequence the migration work and logs to
prove each completed tranche. Do not invent a separate governance tracker or
permanent mixed posture for this.

## Templates

- `archive/README.md`
- `templates/master-spec-template.md`
- `templates/batch-card-template.md`
