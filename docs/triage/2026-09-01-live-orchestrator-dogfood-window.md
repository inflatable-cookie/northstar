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

### 001 — Poodle g16.033 HistoryCenter rejection surface

Status: provisional; implementation complete, exact-head review in progress

- Worker class: `frontier`, dispatched before the economical-routing refresh.
  The lane was the highest-priority runway closeout and combined an exact public
  semantic union and copy boundary across TypeScript, Rust, web, and GPUI with a
  non-vacuous installed-tarball negative type proof. This is baseline evidence,
  not evidence that the refreshed routing rule selected the worker correctly.
- Ready frontier: g16.033 was the sole implementation edge after merged
  g16.028. A design-intelligence research-only dossier ran in parallel with
  disjoint writes. The named serial edge was
  `g16.028 -> g16.033 -> host-level motion policy`; the policy must be promoted
  and readiness-checked, and block sliders follow its outcome.
- Outcome: implementation complete. Poodle PR 120 is open and clean at exact
  head `ec2aa7f2469c5613f9a98de4f863761d85e7c16c`; orchestrator review is in
  progress.
- Operator intervention after dispatch: none. Planning had already settled the
  structured-code choice, three new categories and their exact copy, the
  installed-tarball proof, the `Papercuts` label, and repository ownership.
- Review: zero completed rounds and no blocking finding class yet. Do not count
  this as a completed cohort lane until its owning orchestrator reports the
  review or merge disposition.
- Control-plane friction: the worker emitted two natural-finish notifications
  before reaching its handoff boundary while long validation stages still ran.
  The orchestrator reactivated the same agent twice to reach commit, push, and
  PR. It created neither a replacement worker nor a duplicate lane.
- Documentation QA: reported as a prose-coupling false positive. More narrowly,
  this is a token-scanner boundary defect rather than an exact-prose
  `required_content` or `forbidden_content` assertion: `audit:security` matched
  `sk-plus-translated-hi` inside the benign phrase
  `mask-plus-translated-highlight` already on `main`. All other reported boards
  were green.
- Reduction fixture: one Markdown line containing
  `mask-plus-translated-highlight` reproduces the false OpenAI-token finding;
  no standalone secret-like token is needed.
- Provider family: not supplied. Do not infer it from the worker class or
  transport.

## Cohort progress

- Observations received: 1.
- Completed cohort lanes: 0 of 8; observation 001 is awaiting review outcome.
- Projects represented: 1 of 4 (`Poodle`).
- Provider families counted: 0 of 2; observation 001 did not supply one.
- Natural parallel shapes: 1 candidate of 2. This was one implementation lane
  plus disjoint research, not two implementation lanes, and remains
  provisional with the lane.
- Validation-reduction fixtures: 1 token-scanner boundary false positive.
- Control-plane lifecycle friction cases: 1 premature-finish sequence.

## Closeout

When the cohort gate is met, promote the reconciled evidence into one dated log,
compile the bounded validation-reduction card, and remove this triage buffer.
Keep modular language-package extraction and mode consolidation planned but
unimplemented during the protocol freeze.
