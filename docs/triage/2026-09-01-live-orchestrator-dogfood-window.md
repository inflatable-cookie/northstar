# Live orchestrator dogfood window

Status: active observation buffer
Opened: 2026-09-01
Owner: Northstar orchestrator
Source: operator-approved live worker lanes already running across consumer
projects

This note collects a bounded real-work cohort for the first-principles reduction
experiment. It is evidence, not execution authority. Do not start synthetic
dogfood work from it.

## Collection boundary

- Reuse worker lanes their own project orchestrators already planned and
  dispatched.
- Do not change a worker handoff, add validation, delay review, or ask a worker
  to produce Northstar evidence.
- Do not poll workers or mine transcripts. The owning orchestrator reports once
  at a natural worker-finish, review, revision, or merge checkpoint.
- Record capability classes and outcomes, not private prompts, secrets, or
  provider/model names.
- Consumer project authority, review, merge, and closeout remain with that
  project's orchestrator.

## Observation packet

Each completed lane reports:

- project and lane/card;
- worker class: `day-to-day`, `mechanical`, or `frontier`, plus the short reason;
- ready-frontier shape: lanes launched together and any named serial edge;
- outcome: PR or bounded result, with merge state when known;
- operator interventions after dispatch, excluding ordinary approval already
  encoded by the plan;
- review rounds and blocking finding classes;
- protocol or control-plane friction;
- documentation QA result, distinguishing structural failure, prose-coupling
  false positive, repository-owned failure, or none;
- any benign documentation edit suitable for the validation-reduction corpus.

`none` is useful evidence. A lane does not need to touch documentation to count
toward orchestration dogfood.

## Cohort gate

Review after at least eight completed worker lanes across four projects and two
provider families, including at least two multi-lane frontier observations when
live work naturally supplies them. Do not manufacture concurrency to satisfy
the gate.

The cohort may close earlier only if a material protocol or validation defect
changes the plan. It may stay open beyond eight lanes when a required shape has
not occurred naturally.

## Reduction use

- Real prose-coupling failures become candidate assertions to remove or replace.
- Benign docs edits become falsification cases: structural validation should
  accept them without requiring exact editorial wording.
- Real structural failures remain protected cases.
- A later Northstar worker may build a shadow structural checker and mutation
  fixtures from this evidence. The current primary gate stays unchanged until
  exact-head review shows missing structure, broken refs, invalid identifiers,
  state inconsistency, and source/install drift still fail.

## Observations

No observations recorded yet.

## Closeout

When the cohort gate is met, promote the reconciled evidence into one dated log,
compile the bounded validation-reduction card, and remove this triage buffer.
Keep modular language-package extraction and mode consolidation planned but
unimplemented during the protocol freeze.
