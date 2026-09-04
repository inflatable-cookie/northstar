# Delivery Layer and Consequence-Triggered Modules

Northstar operates under one compact strict lifecycle as its single reusable
default. Former baseline, light, lane-first, mixed, and full-strict postures
are retired as alternative steady-state protocols.

The core standard spine (`vision/`, `architecture/`, `contracts/`, `roadmaps/`,
`logs/`, `handoffs/`, `triage/`, `policy/`) is the compact lifecycle default.
Specs, detailed evidence, research, and additional authority files are
consequence-triggered modules rather than a second posture.

## Standard Core Spine Is Default

Every Northstar repository starts with the core spine:

- `vision/` defines purpose, scope, and non-goals
- `architecture/` defines realized system structure and boundaries
- `contracts/` locks enforceable behavioral rules and interfaces
- `roadmaps/` sequences work into milestone lanes and batches
- `logs/` records dated batch-level outcomes and evidence
- `handoffs/` enables friendly fresh-thread transitions
- `triage/` captures conversational observations before promotion
- `policy/` holds lightweight repo rules and internal writing style

Starting small does not classify a project into a lighter protocol; the core
spine is already the compact Northstar lifecycle.

## Consequence-Triggered Modules

Add consequence-triggered modules when specific conditions require them, rather
than selecting a separate posture:

- `docs/architecture/product-guardrails.md` -- when explicit negative guardrails
  and execution constraints are needed
- `docs/contracts/contract-index.md` -- when multiple contracts govern the repo
- `docs/contracts/001-working-rules.md` -- when explicit execution grammar,
  review oracles, stop conditions, and coordinator mechanics are enforced
- `docs/specs/` and `docs/specs/archive/` -- when provisional design shaping is
  needed before promoting durable outcomes into architecture/contracts
- `docs/roadmaps/gNN/batch-cards/` -- when step-by-step execution detail is
  needed under an active roadmap milestone
- `docs/research/` -- when comparative or source-backed exploration is needed
  before architecture or contract commitments
- Additional authority files (e.g. `repo-authority-map.md`) -- when multi-repo
  boundaries or distinct authority seams genuinely require separate files

## Incremental Adoption Pattern

A mature repository may adopt the compact lifecycle in bounded tranches, but
the destination remains the same single protocol.

- Keep migration inside the normal planning spine: one active migration master
  spec or roadmap records satisfied capabilities, blocking gaps, the current
  tranche, the next tranche, and the evidence needed to advance.
- Do not backfill closed history merely to imitate the file shape.
- Close ordinary migration work on its card.
- Do not invent a detached governance tracker or a permanent mixed posture.
  Mixed-mode operation is migration debt, not an alternative steady state.

## Audit Checkpoints

Before changing a mature repo, classify it explicitly.

Record:

- lifecycle state: `ready`, `paused`, `migration`, or `drifted`
- which compact lifecycle checkpoints are already satisfied
- which gaps block full adoption
- whether migration state is still deliberate or has drifted into unowned
  inconsistency

At minimum, audit these checkpoints:

- standard docs spine is installed and current
- product guardrails, contract indexing, and working rules are explicit where
  applicable
- active material lanes use specs and batch cards where fuller execution detail
  is needed
- promotion into architecture and contracts is explicit before roadmap
  execution depends on settled outcomes
- closeout, currentness, and spec hygiene are normal maintenance rather than
  rescue cleanup

## Rollout Tracking Pattern

Track migration inside the repo's normal planning spine.

Use:

- one active migration master spec
- one active roadmap milestone
- normal batch logs for completed tranches

That migration spec should name:

- satisfied compact lifecycle checkpoints
- blocking gaps
- whether migration state is still deliberate or has drifted
- current tranche
- next tranche
- the evidence needed to close the current tranche

Do not invent a detached tracker or governance board for this. Migration lives
in the same docs surfaces that already govern the repo.

## Guardrails

- Do not install provisional specs mechanically on repos that do not need
  provisional planning; add them when material changes require shaping before
  promotion.
- Do not leave `specs/` present without making the promotion rule clear.
- Do not describe partial adoption as a permanent mixed posture; keep migration
  bounded.
- Do not treat nested docs-authority repos like bespoke migrations when they
  already cleanly own the planning contract.
- Normal delivery evidence belongs on the completed card; separate logs are
  reserved for exceptional evidence (releases, incidents, migrations).
