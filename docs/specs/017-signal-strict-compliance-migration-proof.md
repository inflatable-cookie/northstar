# 017 - Signal Strict Compliance Migration Proof

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-10
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.014

## Problem

Northstar now has a reusable strict-compliance audit and rollout surface, but
it still needs one real migration proof lane showing that a mature baseline
repo can be classified, staged, and advanced toward full strict compliance
without inventing a bespoke process.

## Target Operating Model

Northstar should be able to audit Signal's current posture, name the next
migration tranche deliberately, and leave a credible migration plan without yet
rewriting the whole consumer repo from inside Northstar.

## Current Posture

- Current phase: `baseline`
- Mixed posture status: `valid migration state`
- Why this classification is accurate:
  Signal carries a healthy baseline docs spine with contracts and active
  roadmap sequencing, but it does not yet carry product guardrails,
  `001-working-rules`, or the `specs/` plus batch-card layer that full strict
  compliance expects.

## Checkpoint Audit

- [x] Standard docs spine is installed and current enough to route active work.
- [ ] Product guardrails, contract index, and working rules are explicit where
      the strict model expects them.
- [ ] Active material lanes use specs and batch cards where the fuller
      execution layer is being claimed.
- [ ] Promotion into architecture and contracts is explicit before roadmap
      execution depends on settled outcomes.
- [ ] Closeout, currentness, and spec hygiene are normal maintenance rather
      than rescue cleanup.
- [ ] The stricter surface is becoming a project-level default rather than a
      one-lane exception.

## Blocking Gaps

- Signal has no `docs/specs/` surface yet, so the fuller continuation-envelope
  and lane-budget model cannot be carried explicitly in file state.
- Signal has no `docs/contracts/001-working-rules.md` or
  `docs/architecture/product-guardrails.md`, so strict execution guardrails are
  not yet project-owned.
- Signal's top-level `docs/README.md` and `docs/logs/README.md` are still too
  generic or stale to carry stricter migration state cleanly.

## Current Tranche

- Prove the audit posture and define the first strict migration tranche for the
  active `g09` lane without touching the repo yet.

## Next Tranche

- Compile the first Signal lane-first stricter-adoption pack around the active
  `g09` queue:
  `product-guardrails`, `001-working-rules`, `specs/README`, one active
  migration or lane spec, and bounded batch cards for the current lane.

## First Migration Tranche

The first Signal strict-compliance tranche should stay lane-first and bounded
to the active `g09` queue rather than trying to convert the whole repo in one
move.

### Tranche objective

Install the minimum strict surface that lets Signal carry the fuller execution
grammar on one live lane while keeping the rest of the repo in a healthy
baseline posture.

### Lane anchor

- active generation: `g09`
- active milestone: `g09.005`
- immediate follow-on lane: `g09.006`

The tranche should therefore attach to the live plugin-hosting and runtime
repair queue instead of backfilling older closed generations.

### Exact surfaces to add first

- `docs/architecture/product-guardrails.md`
- `docs/contracts/001-working-rules.md`
- `docs/specs/README.md`
- `docs/roadmaps/g02/batch-cards/README.md`
- one active Signal spec covering the active strict lane
- one or more bounded batch cards for the current `g09` execution chain

### Exact surfaces to refresh in the same tranche

- `docs/README.md`
- `docs/logs/README.md`
- `docs/roadmaps/README.md`
- `docs/roadmaps/g09/README.md`
- `docs/contracts/contract-index.md`

These front doors should point at the active strict lane once the tranche is in
place instead of leaving that state implicit in lower-level roadmap files.

### What the first Signal spec should do

The first strict-lane spec should:

- bind the stricter execution model to the active `g09` queue
- record that Signal is in lane-first stricter adoption rather than full strict
  compliance
- name the current bounded execution chain under `g09.005` and the immediate
  follow-on boundary into `g09.006`
- promote durable guardrails into `product-guardrails` and
  `001-working-rules` rather than letting the spec become shadow authority

### What the first Signal batch-card chain should do

The initial bounded card chain should cover:

1. installing the stricter docs surfaces and front-door currentness updates
2. converting the active `g09.005` closeout batch into explicit strict-lane
   card state
3. leaving the next strict-ready boundary into `g09.006` explicit rather than
   implied

### Deliberately deferred from tranche one

- repo-wide conversion of every active lane to specs and batch cards
- historical backfill for closed generations
- claims of full strict compliance
- any Signal implementation work that is not needed to install or prove the
  stricter docs surface

### Evidence to close tranche one

- Signal carries the minimum strict pack listed above
- Signal front doors point at the active strict lane cleanly
- one active Signal spec and bounded batch-card chain govern the live `g09`
  work
- a Signal log proves the migration tranche landed without changing the
  substance of the product roadmap

## Evidence To Close Current Tranche

- a read-only migration proof log showing the posture classification, satisfied
  checkpoints, blocking gaps, and next tranche for Signal
- one explicit Northstar roadmap lane sequencing the consumer-repo proof work

## Risks

- Risk: the proof turns into direct Signal migration work too early.
- Mitigation: keep this lane read-only on the Signal side until the tranche
  plan is explicit.

- Risk: Northstar widens the migration surface again instead of proving the one
  it already has.
- Mitigation: open only the smallest consumer-proof lane needed to plan the
  first Signal tranche.

## Stop Conditions

- the lane starts editing Signal before the migration tranche is explicitly
  planned
- the proof starts inventing another abstract migration framework
