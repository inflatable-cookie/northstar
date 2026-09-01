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

### 002 — Figmatic g01.016 / card 016-19 Frame and truthful Ungroup

Status: provisional; refreshed implementation complete, substantive review
pending

- Worker class: `frontier`, dispatched before the economical-routing refresh
  for a material schema migration and a cross-layer structural, geometry, and
  capability invariant. This is baseline routing evidence.
- Ready frontier: launched beside the independent app-command ACL papercut.
  Card 016-20 stays serial behind 016-19 because both own OrganisationPanel,
  container, and drop semantics.
- Outcome: Figmatic PR 62 is open and mergeable at refreshed exact head
  `fd81c99e60145cfbbdd0945b256de9ddbefe1a32`. The Frame classifier, schema 27,
  and native proof are complete. It is not merged.
- Operator intervention after dispatch: none affecting implementation. The
  later routing update explicitly left the active worker unchanged.
- Review: one preliminary integration round found `integration-drift` after the
  parallel ACL PR merged first. The same worker rebased cleanly and revalidated;
  exact-head substantive review is pending.
- Control-plane friction: same-repository serial merge required a post-merge
  ancestry check and an explicit Paseo follow-up. The follow-up returned the
  original worker cleanly; there was no duplicate lane or transcript polling.
- Documentation QA: none. `effigy qa` passed on the refreshed head. Existing
  Studio type and test failures reproduce on base and are repository-owned,
  outside docs QA.
- Reduction fixture: rebase-only docs evidence updates to the base SHA and test
  count, plus a `PAPERCUTS.md` hunk-offset shift that preserves PR 61's resolved
  ACL entry and this lane's four open entries.
- Provider family: not supplied.

### 003 — Swallowtail g05 Contract 061 / card 034 planning gate

Status: paused; second review requires planning repair, provider follow-up
unavailable

- Worker class: `frontier`, dispatched before the economical-routing refresh
  for a materially consequential and semantically coupled adapter-public
  baseline gate. This is baseline routing evidence.
- Ready frontier: one serial main-lane edge. PR 148 review and merge block card
  034 implementation. Shared roadmap, triage, log, and `Next Task` surfaces also
  serialize the queued Swallowtail papercut and currentness closeouts.
- Outcome: Swallowtail PR 148 is pushed at repaired exact head
  `9e722e804da118473754e3b627150c5d63be4bfc` and is not merged. A requested
  evidence-stop repair produced no new head. The change remains docs-only; the
  75-emitted / 14-withheld planning ledger is unchanged.
- Operator intervention after dispatch: none on product semantics. The operator
  supplied refreshed global routing rules and this passive dogfood protocol
  while the lane was active.
- Review: two completed rounds. Round one produced four `oracle-gap` findings
  and one `integration-drift`; the same worker repaired all five. Round two
  produced one `planning-change` because there is no honest runtime vocabulary
  for catalogue observation, one public-baseline oracle defect covering compound
  half and state loss (counted as `oracle-gap` in the cohort taxonomy), and two
  `integration-drift` findings covering load/resume profile conditionality and
  an impossible Kimi Platform catalogue emitter.
- Control-plane friction: the first finish notification truncated the worker
  report tail, but its structured summary retained enough evidence for review.
  The round-two follow-up then failed at the provider boundary because the Claude
  monthly spend limit had been reached; the reported reset is 12:50
  Europe/London. It produced no code or docs result. No transcript mining was
  used.
- Documentation QA: none. `qa:docs` and `qa:northstar` passed; the blockers were
  semantic planning and oracle defects, not checker behavior.
- Reduction fixture: none.
- Provider family: not supplied.

### 004 — Signal papercuts wave 41 LocalRuntimeHost Send boundary

Status: provisional; implementation complete, material-risk review pending

- Worker class: `day-to-day`. This is post-refresh routing evidence: the lane
  was a bounded local Rust and API-boundary repair with no exceptional
  post-planning reasoning, while material consequence stayed with orchestrator
  review.
- Ready frontier: one independent Signal repair was ready. The named serial edge
  is `Signal PR 20 merge -> Loophole wave 40 broker-contract closeout resume`;
  no other lane was coupled.
- Outcome: Signal PR 20 is open at exact head
  `0052fba3e8a332e6bafa9e7621863ad0bb9ee589` and is not merged.
  `LocalRuntimeHost` now requires `Box<dyn HardwareBackend + Send>`; the shared
  trait is unchanged, with no unsafe, runtime, or protocol change.
- Operator intervention after dispatch: none.
- Review: the worker completed one pass and no revision round. A downstream
  compile failure at the existing `TransportDriver: Send` boundary was resolved
  by the narrow host object bound; this was worker validation, not yet an
  orchestrator finding classification. Material-risk review is pending.
- Control-plane friction: workspace creation could not apply labels directly,
  so the capitalized `Papercuts` label needed separate local WebSocket assignment
  and verification. The handoff named `fmt:rust:check`, while Signal exposes
  `fmt`; the worker used the repository selector.
- Documentation QA: none. Formatting, docs QA, Northstar QA, and diff checks
  passed.
- Reduction fixture: the single-entry `PAPERCUTS.md` closeout plus timestamped
  evidence log; no docs false positive occurred.
- Provider family: not supplied.

### 005 — Poodle interactive drag-and-drop papercuts session

Status: provisional kickoff; waiting for the first reproduction

- Worker class: `day-to-day`. This is post-refresh routing evidence for bounded
  diagnosis and surgical repair from operator-supplied component reproductions,
  with no exceptional architecture decision authorized.
- Ready frontier: this independent diagnostic lane may run beside g16.033.
  Diagnosis has no serial edge. Any public API, contract, cross-runtime
  architecture, or breaking-migration finding stops and returns to the Poodle
  orchestrator before implementation.
- Outcome: kickoff is complete at `9bdcf03e7` on
  `papercuts/drag-drop-interactive-fixes`. The tree is clean; there is no code or
  PR, and the worker is waiting for the first real reproduction.
- Operator intervention after dispatch: one explicit request to create the
  interactive thread; no bug details have been supplied yet.
- Review: zero rounds and no blocking finding.
- Control-plane friction: none. The worker completed kickoff and remains
  available for a Paseo follow-up carrying the first reproduction.
- Documentation QA: none.
- Reduction fixture: none.
- Provider family: not supplied.

### 006 — Effigy g08.040 / card 1095 catalog-pack acquisition prototype

Status: provisional; three repair rounds complete, orchestrator review pending

- Worker class: `frontier`. The lane combined exceptional post-planning
  reasoning across content identity, cross-process state, corruption recovery,
  and trust boundaries with materially consequential machine-global persistence
  and public CLI and JSON behavior.
- Ready frontier: one lane only. The next Effigy papercut stays serial because
  the operator gated promotion on card 1095 and both lanes own shared closeout
  and front-door surfaces.
- Outcome: Effigy PR 68 is complete and reported mergeable at exact head
  `1ff1407f9367990b0897f72152b6a0e941035d9d`; orchestrator review is pending.
- Operator intervention after dispatch: one substantive product decision—do
  not prune packs automatically; retain installed content and defer garbage
  collection and retention policy. Canonical planning was repaired on `main`
  before worker revision. The later routing refresh changed process guidance,
  not lane scope.
- Review: three changes-requested rounds. Round one found one `planning-change`
  on retention and five `execution-miss` findings covering stored-content
  validation, silent fallback propagation, store locking, symlink traversal,
  and truncated identity and reuse. Round two found three `execution-miss`
  findings covering root and manifest no-follow, injective path identity, and
  rollback and doctor target validation. Round three found one `execution-miss`
  on unreadable or dangling store-metadata repair. No `oracle-gap`,
  `validation-gap`, or `integration-drift` was reported.
- Control-plane friction: shared GitHub identity prevented formal
  request-changes and approval, so canonical verdicts used PR comments after one
  failed formal-review attempt. Paseo follow-ups reliably resumed the retained
  worker and workspace; there was no duplicate lane, transcript mining, or
  polling.
- Documentation QA: none. Repository-owned `qa:docs` and full Effigy QA passed.
- Reduction fixture: commit `a5098502f`, a docs-only synchronization of the
  operator-confirmed no-pruning decision across seven canonical planning,
  handoff, and log surfaces. Docs QA and the diff check passed.
- Provider family: not supplied.

## Cohort progress

- Observations received: 6.
- Completed cohort lanes: 0 of 8. Five implementation or planning results await
  final review, and observation 005 is only a diagnostic kickoff.
- Projects represented: 5, exceeding the four-project breadth gate (`Poodle`,
  `Figmatic`, `Swallowtail`, `Signal`, and `Effigy`).
- Provider families counted: 0 of 2; no packet has supplied one.
- Worker routing: observations 001–003 are pre-refresh frontier baselines;
  observations 004–005 are post-refresh day-to-day choices; observation 006 is
  a frontier lane whose two escalation axes are explicit.
- Natural parallel shapes: 2 provisional frontier candidates of 2. Observation
  001 paired implementation with disjoint research; observation 002 paired two
  independent implementation lanes. Observation 005 adds a day-to-day
  diagnostic lane beside 001 but has not started substantive work.
- Completed review rounds: 6. Recorded blockers total two `planning-change`,
  nine `execution-miss`, five `oracle-gap`, and four `integration-drift` findings.
- Validation-reduction fixtures: four—one token-scanner boundary false positive
  and three benign accepted docs shapes from observations 002, 004, and 006.
- Control-plane or task-routing friction appears in observations 001–004 and
  006; observation 005 reports none.

## Closeout

When the cohort gate is met, promote the reconciled evidence into one dated log,
compile the bounded validation-reduction card, and remove this triage buffer.
Keep modular language-package extraction and mode consolidation planned but
unimplemented during the protocol freeze.
