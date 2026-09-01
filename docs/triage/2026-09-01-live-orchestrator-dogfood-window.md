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

Status: complete; reviewed and merged

- Worker class: `day-to-day`. This is post-refresh routing evidence: the lane
  was a bounded local Rust and API-boundary repair with no exceptional
  post-planning reasoning, while material consequence stayed with orchestrator
  review.
- Ready frontier: one independent Signal repair was ready. The named serial edge
  is `Signal PR 20 merge -> Loophole wave 40 broker-contract closeout resume`;
  no other lane was coupled.
- Outcome: Signal PR 20 merged at
  `36242aacb010f14a3c7f4d70fe3e73c516bdf671`; the reviewed head was
  `0052fba3e8a332e6bafa9e7621863ad0bb9ee589`. `LocalRuntimeHost` now requires
  `Box<dyn HardwareBackend + Send>`; the shared trait, runtime, and protocol are
  unchanged.
- Operator intervention after dispatch: none.
- Review: one orchestrator round, no revision requested. The downstream compile
  failure at the existing `TransportDriver: Send` boundary was resolved by the
  narrow host object bound. Required CI and mergeability were green.
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

### 007 — Acowtancy/Market card 161 Farmyard managed-DB harness integrity

Status: provisional; exact-head review passed, merge pending at observation

- Worker class: `day-to-day`. The lane was a bounded harness-contract repair and
  broad mechanical caller sweep with no exceptional post-planning reasoning.
- Ready frontier: one lane. The named serial edge is `card 161 -> card 160`
  because both own the Farmyard API-test surface and card 160 consumes this
  harness evidence.
- Outcome: Market PR 87 is open at exact head
  `0021c946dcc7a29ea5c1cf737c79b2efcc133c26`; exact-head orchestrator review
  passed and merge was pending at the observation checkpoint.
- Operator intervention after dispatch: none.
- Review: one round and no blocking finding.
- Control-plane friction: the worker bypassed locked-vault, TTY-only
  `effigy container up` by starting the already-owned Compose Postgres service
  on `127.0.0.1:22432`. The orchestrator first ran a raw Cargo oracle from the
  monorepo root, got a non-evidentiary missing-manifest error, and reran it from
  `apps/farmyard`.
- Documentation QA: none. Docs QA and Northstar QA passed.
- Reduction fixture: card 161 status and acceptance closeout plus one Farmyard
  `PAPERCUTS.md` checkbox and resolution-line edit. Structure should be checked;
  editorial wording should not be coupled.
- Provider family: not supplied.

### 008 — Acowtancy/Market card 160 student-safe quiz delivery

Status: paused before implementation; provider route unavailable

- Worker class: `frontier`. The lane combines exceptional reasoning across 13
  closed quiz projections, drag-and-drop deassociation, immutable snapshots,
  and server/client/schema parity with the materially consequential live student
  boundary over canonical grading data.
- Ready frontier: one lane. `card 161 -> card 160` was cleared before dispatch.
  Atomic assessment response/submission remains serial behind card 160; four
  other findings remain held and are not ready.
- Outcome: provider stop before implementation or PR. The monthly spend limit
  reports a 12:50 Europe/London reset.
- Operator intervention after dispatch: none.
- Review: zero rounds and no blocking finding because no implementation head
  exists.
- Control-plane friction: one provider spend cap stopped the worker before it
  began. The committed handoff and worktree remain intact, so recovery can reuse
  the authority chain without rebriefing or duplication. This is direct evidence
  that provider availability is lane-local, not global worker capacity.
- Documentation QA: none; no worker diff or validation ran.
- Reduction fixture: none.
- Provider family: not supplied.

### 009 — Poodle design-guidance evaluation pilot planning delegate

Status: provisional opening checkpoint; operator conversation active

- Worker class: `frontier planning`, not implementation. Direct operator-facing
  choices over the guidance candidate, ownership, scoring, and pre-result
  thresholds require high reasoning and materially shape whether Poodle adds a
  maintained guidance and evaluation surface.
- Ready frontier: launched beside the independent motion-policy planning
  delegate and drag-bug session. Any pilot implementation stays serial behind
  this planning PR's review, merge, canonical promotion, and readiness check.
- Outcome: opening checkpoint only. The delegate recommends evaluating a
  compact repository-local contributor router that links existing authority
  without restating its rules. No files or PR exist yet.
- Operator intervention after dispatch: none.
- Review: zero rounds and no blocking finding.
- Control-plane friction: none. The delegate completed its opening-question
  turn and remains available for direct Paseo follow-up.
- Documentation QA: none.
- Reduction fixture: none.
- Provider family: not supplied.

### 010 — Loophole papercuts wave 40 Signal sandbox-broker contract

Status: complete; corrected exact head reviewed and merged

- Worker class: `day-to-day`. The lane was bounded consumer and test-contract
  adoption with local reasoning and no exceptional post-planning difficulty or
  frontier implementation need.
- Ready frontier: Loophole became ready only after the named upstream Signal PR
  20 merge. The serial edge `Signal PR 20 -> Loophole PR 25` is settled; no
  other lane was coupled.
- Outcome: Loophole PR 25 merged at
  `97bc0216938bbc3a3f7546952cb3b8d118cddc96`; the accepted exact head was
  `c476bca3b6334fc03b87048310e981ab5fac8fa1`. Loophole now requires
  `SIGNAL_PLUGIN_SANDBOX_BROKER_COMMAND`, uses explicit Signal
  `broker:provision`, and no longer builds the broker during consumer startup or
  tests. The matching broker papercut is closed; the independent Effigy banner
  observation remains open.
- Operator intervention after dispatch: one same-worker continuation after
  Signal PR 20 merged, then one review correction on the same branch. The
  handoff and scope were unchanged; no replacement lane was created.
- Review: the initial worker pass stopped before PR because the downstream
  non-`Send` `HardwareBackend` boundary blocked required proof. That cause was
  repaired in the separate Signal PR 20. The resumed pass completed. The first
  PR review found one `integration-drift` finding: tracker currentness still
  carried the superseded upstream `Send` issue. The same worker applied the
  docs-only correction; the second exact-head review passed with no remaining
  blocker.
- Control-plane friction: workspace labeling required a separate local
  WebSocket assignment. The first agent-create payload omitted Paseo's combined
  `provider/model` form; retry created no duplicate worker. The cross-repo Signal
  prerequisite stayed explicit. There was no worker-state polling or transcript
  mining.
- Documentation QA: none. Original package formatting, docs QA, Northstar QA,
  and diff checks passed. The workspace formatting gate was skipped for
  unrelated pre-existing drift. The docs-only revision was not revalidated
  during the passive window.
- Reduction fixture: one matching `PAPERCUTS.md` closeout plus a timestamped
  evidence log. No docs false positive occurred.
- Provider family: not supplied.

### 011 — Poodle shared motion-policy planning delegate

Status: provisional packet; operator decisions remain open

- Worker class: `frontier planning`, not implementation. Operator-facing host
  API, inheritance, and lifecycle decisions cross runtime boundaries and need
  direct high-reasoning conversation.
- Ready frontier: ran beside the design-guidance planning delegate and drag-bug
  session. Motion implementation waits for planning PR review, merge, canonical
  promotion, and readiness. Block sliders follow the first motion outcome;
  icon and shimmer gates remain downstream.
- Outcome: the delegate worktree contains
  `docs/triage/20260901-121255-motion-policy-decision.md`; no PR exists yet.
  Full-default behavior and reduced-opacity with a frozen endpoint are settled.
  Host shape and inheritance remain unresolved in the delegate thread.
- Operator intervention after dispatch: answered the first two motion choices.
- Review: zero rounds. The open items are operator decisions, not review
  blockers.
- Control-plane friction: material. A `request_user_input` permission was
  mirrored into the parent after the delegate had already asked directly,
  producing duplicate operator questions. The next permission was denied
  without interrupt and instructed the delegate to keep questions in its own
  thread; the delegate then finished without a selection. The direct delegate
  conversation remains the source of truth.
- Documentation QA: none.
- Reduction fixture: none.
- Provider family: not supplied.

### 012 — Poodle post-g16 ready-frontier refresh

Status: scheduling checkpoint; all safe current lanes already launched

- Worker class: orchestrator scheduling checkpoint, not a new worker lane. The
  existing motion-policy and design-guidance lanes remain `frontier planning`
  because each owns unresolved operator decisions. Interactive drag fixes
  remain `day-to-day` because they are bounded and reproduction-led.
- Ready frontier: motion planning, design-guidance planning, and interactive
  drag fixes are all already launched. No global thread budget was applied.
  Motion implementation remains serial on the motion delegate PR's review,
  merge, canonical promotion, and readiness check. Block sliders follow the
  first motion outcome; icon and shimmer work remain downstream of motion
  policy. Publication needs explicit release authority, while CS20 and keyboard
  work still depend on unresolved external or design decisions.
- Outcome: no new PR or launch was warranted. Poodle `main` was clean and
  synchronized at `0c81fbc22`; the refresh found no newly ready canonical card.
- Operator intervention after dispatch: the corrected scheduler rule, plus the
  earlier instruction that worker questions stay in their worker threads.
- Review: zero rounds at this checkpoint. The remaining blocks are real
  dependency or authority edges, not execution or transport failures.
- Control-plane friction: none. The corrected rule removed the temptation to
  infer a global slot ceiling. No provider route was attempted because no
  additional lane was ready.
- Documentation QA: none.
- Reduction fixture: none.
- Provider family: not supplied.

### 013 — Figmatic g01.018 / card 018-01 detached component-root runtime

Status: route recovered; replacement worker active, no PR yet

- Worker class: `frontier`. The lane combines exceptional post-planning
  reasoning about projection identity and history with materially consequential
  canonical-component corruption and undo behavior.
- Ready frontier: card 018-01 was the only launchable lane. Card 016-20 waits
  for merged-main Time and Frame operator acceptance. Card 018-02 joins the
  accepted results of 018-01 and 016-20.
- Outcome: the initial Claude-family route stopped before work at a monthly
  spend limit. The committed handoff `f1d35932`, workspace
  `wks_5a668f5e4ca3432f`, and clean untouched branch were retained. After the
  operator selected the alternate xAI-family route, a replacement agent record
  launched in the same workspace. No PR exists yet.
- Operator intervention after dispatch: explicitly selected the alternate
  provider route. Lane authority and scope did not change.
- Review: zero rounds and no blocking finding.
- Control-plane friction: the spend failure stayed lane-local. Paseo cannot
  retarget the provider on an existing agent record, so recovery after the
  terminal pre-work failure required a replacement agent record. It did not
  require a new handoff, workspace, branch, or rebrief, and it did not create
  two active workers for the lane.
- Documentation QA: none.
- Reduction fixture: committing the handoff removed the fully promoted,
  110-line `docs/triage/2026-09-01-sidebar-component-modes.md`. This is a benign
  triage-lifecycle deletion rather than planning loss.
- Provider families: Claude and xAI, both supplied explicitly.

### 014 — Poodle shared motion-policy planning delegate

Status: complete; planning PR accepted and merged

- Worker class: `frontier conversational planning`. Unresolved cross-runtime
  public policy, inheritance, lifecycle, and five-family contract decisions
  required direct operator interaction and high reasoning.
- Ready frontier: the delegate ran beside design-guidance planning and
  interactive drag fixes. Motion implementation remains serial on accepted
  planning intake, canonical promotion, and readiness. Block sliders follow
  the first motion outcome; icon and shimmer remain downstream.
- Outcome: Poodle PR 121 was accepted at exact head
  `94da3f588e168cb565624698691531ef0e3d91a1` and merged as
  `7f718dd42a5301f57a61ae605f18b762bc594f68`.
- Operator intervention after dispatch: answered policy questions in the
  delegate thread. After one correction, the parent stopped proxying duplicate
  questions.
- Review: one round, accepted with no blocking finding. Material contract
  expansions for a moving Tabs underline and focused-toast removal were
  recorded explicitly as later promotion work.
- Control-plane friction: `gh pr merge --delete-branch` merged successfully and
  deleted the remote branch, but could not delete the local branch because the
  Paseo worktree still owns it. PR and merge-commit verification removed any
  outcome ambiguity; local branch cleanup remains a worktree-lifecycle concern.
- Documentation QA: none.
- Reduction fixture: excluded. The 515-line single-file decision packet is
  useful long-form planning evidence, but it contains material semantic
  decisions rather than a benign copy-only edit.
- Provider family: not supplied.

### 015 — Acowtancy/Market card 160 student-safe quiz delivery

Status: changes requested after first review round

- Worker class: `frontier`. The lane combines exceptional reasoning across 13
  closed projection families, drag-and-drop deassociation, and immutable
  Rust/API/TypeScript/UI binding with the highest-priority risk of exposing
  canonical grading keys.
- Ready frontier: the serial edge `card 161 -> card 160` was cleared. The atomic
  response card remains downstream. Independent cards 162 and 163 launched
  concurrently, with same-repository merge order kept serial.
- Outcome: Market PR 88 is open at exact head
  `2884582c05d293fa8b51902bb211cc8c89854216`; changes were requested after the
  first review round.
- Operator intervention after dispatch: treated the initial Claude-family quota
  failure as route-local. After recovery exposed conflicting retained state,
  the operator selected an xAI-family route and supplied a recovery handoff.
  The viable implementation commit was recovered onto post-card-161 `main`.
- Review: one changes-requested round found three blocking areas. Runtime schema
  closure still accepted unknown grading fields; missing-token request
  ingestion produced Axum 422/null rather than the required oracle behavior;
  and the public attempt UUID exposed the deterministic deassociation seed.
  Northstar finding codes were not supplied for these three blockers.
- Control-plane friction: killing the bound owner during an attempted
  same-workspace fallback archived the shared workspace and automatically
  closed its replacement. An older complete but unpushed implementation was
  not surfaced by initial routing. It was preserved; an empty duplicate was
  cancelled. The provider refusal itself stayed lane-local.
- Documentation QA: none.
- Reduction fixture: two conflict resolutions preserved both card 160's
  pending-review state and card 161's merged state. This is benign concurrent
  closeout reconciliation, not new planning meaning.
- Provider families: Claude and xAI, both supplied explicitly.

### 016 — Acowtancy/Market card 163 Farmyard worktree Cargo routing

Status: complete; evidence-only PR merged

- Worker class: `day-to-day`. This was bounded evidence verification with no
  exceptional post-planning reasoning.
- Ready frontier: parallel-safe with cards 160 and 162. Same-repository merge
  ordering remained the named serial edge.
- Outcome: Market PR 89 at exact head
  `fd8a59d85742e9c63228b512bd90ab9d63def460` merged as
  `fcf8b9eb677fcc8896db746073c404151f5567cd`. It changed evidence only.
- Operator intervention after dispatch: none.
- Review: no blocking review round was recorded before the external merge.
- Control-plane friction: the inherited Effigy health route required an
  interactive, unlocked vault, while the governed Cargo check passed.
- Documentation QA: none.
- Reduction fixture: a `PAPERCUTS.md` closeout, card status transition, and
  evidence log with no Cargo or configuration change.
- Provider family: not supplied.

### 017 — Acowtancy/Market card 162 Cream container-routed test

Status: complete; exact head reviewed and merged

- Worker class: `day-to-day`. This was a bounded Effigy routing papercut with no
  exceptional post-planning reasoning.
- Ready frontier: parallel-safe with cards 160 and 163. The named
  same-repository merge and rebase edge was observed and is settled for this
  lane.
- Outcome: Market PR 90 was accepted at exact head
  `b39989584027ae6a51a7b47ea560e09656e578d7` and merged as
  `66d2db029dc407f5e5448f8b7bb4305a2a87cabf`.
- Operator intervention after dispatch: exact-head replay and merge only.
- Review: one round, passed with no blocking finding. Independent replay covered
  the configured plan, all 24 container tests, docs QA, Northstar QA, and the
  diff check.
- Control-plane friction: the pure Cream suite starts in `apps/cream` and cannot
  see root container configuration. The worker used a Cream-local board rather
  than widening Effigy's routing contract. `gh pr merge --delete-branch`
  completed the provider merge but returned nonzero because the local branch
  remained checked out in its Paseo worktree; merge state required separate
  verification.
- Documentation QA: none.
- Reduction fixture: card, `PAPERCUTS.md`, and evidence-log closeout around one
  Effigy routing edit.
- Provider family: not supplied.

### 018 — Poodle g16.034 shared motion policy and five-family pilot

Status: day-to-day implementation worker active; PR pending

- Worker class: `day-to-day`. The public semantics are material, but canonical
  planning is fully settled and carries an explicit eleven-row review oracle.
  Implementation therefore does not meet the exceptional post-planning
  reasoning threshold for a frontier worker.
- Ready frontier: g16.034 launched beside the operator-driven interactive drag
  lane and design-guidance planning. If the drag lane names a pilot component
  or shared file, only that overlapping chunk stops; unrelated motion work
  continues. Block sliders remain serial after g16.034, with icon and shimmer
  downstream.
- Outcome: canonical promotion landed as `b89c11275`; the worker handoff landed
  as `60eea0e25`. Paseo launched agent
  `48433232-36da-411a-b3fa-953b5e23a61e` in workspace
  `wks_67387cd23d65f7d5`. No PR exists yet.
- Operator intervention after dispatch: none.
- Review: readiness review was coherent with no blocker. Implementation review
  is pending.
- Control-plane friction: none. Current profile notes selected the first
  matching non-frontier day-to-day route; launch succeeded without fallback.
- Documentation QA: none. `docs:lint` and `docs:check` passed during promotion.
- Reduction fixture: two promoted triage notes totalling 914 lines were replaced
  by one 96-line unresolved post-motion queue. This is useful structural
  lifecycle and pruning evidence, but not a copy-only prose fixture because the
  replacement also advances authority state.
- Provider family: xAI, supplied explicitly.

### 019 — Poodle contributor design-guidance pilot planning delegate

Status: complete; planning PR accepted and merged

- Worker class: `frontier conversational planning`. Candidate ownership,
  blinded evaluation design, numeric verdict thresholds, privacy, retention,
  and recurrence policy required direct operator decisions and high reasoning.
- Ready frontier: planning ran independently beside motion planning and drag
  fixes. Pilot execution remains serial on canonical router and pilot-kit
  promotion plus named human-review availability. It does not block g16.034.
- Outcome: Poodle PR 122 was accepted at refreshed exact head
  `56f1712a0ae880dd8948d2469450432a15a5e993` and merged as
  `4b87baabaec83a65d1cd1adccccdc41c624897fc`.
- Operator intervention after dispatch: made decisions directly in the
  delegate thread. The parent did not proxy questions after the earlier
  duplicate-question correction.
- Review: one accepted round after the required same-repository rebase, with no
  blocking finding.
- Control-plane friction: the merge produced the same local-branch cleanup
  warning as PR 121 because the Paseo worktree still owned the delegate branch;
  provider state confirmed the merge. Rebase correctly reused the original
  agent and workspace identity.
- Documentation QA: none.
- Reduction fixture: none. The packet is decision-dense rather than a benign
  copy-only cleanup.
- Provider family: not supplied.

### 020 — Acowtancy/Market card 164 card-162 closeout repair

Status: complete; reviewed and merged

- Worker class: `day-to-day`. This is a bounded documentation and papercut
  evidence repair with no exceptional post-planning reasoning.
- Ready frontier: ran safely beside card 160. Same-repository Market merge
  ordering remains the named serial edge.
- Outcome: Market PR 91 opened at initial head `792c365c3`; changes were
  requested. The orchestrator corrected canonical planning on `main` at
  `5ef3e677d`, resumed the same worker, accepted replacement head `63f694d1c`,
  and merged it at `a621361d2`. The card-160 worker was then told to integrate
  current `main`.
- Operator intervention after dispatch: relayed only that PR 91 was ready. The
  orchestrator independently reviewed the diff and corrected the card and
  handoff.
- Review: two rounds. Round one found one blocking `planning-change`: dispatch
  had incorrectly authorized appending to a historical log despite
  `docs/AGENTS.md`; base and merge provenance wording also needed correction.
  Round two accepted the corrected exact head with no blocker.
- Control-plane friction: the originating worker ID was absent from scoped MCP
  `list_agents`. Global `paseo ls --global --all --json` resolved the retained
  identity. The same worker resumed and no duplicate lane was created.
- Documentation QA: repository-owned. Automated docs and Northstar gates
  passed, but the repository's historical-log immutability rule still required
  human review.
- Reduction fixture: move the card-164 post-merge appendix out of the immutable
  `docs/logs/2026-09/01-125428-card-162-cream-container-routed-test.md` and into
  its already-created timestamped card-164 log while preserving the open
  papercut link.
- Provider family: not recorded; the supplied route was a local profile name,
  omitted from durable evidence.

### 021 — Effigy g08.041/card 1096 catalog fragment listing papercut

Status: provisional; implementation complete, exact-head review starting

- Worker class: `day-to-day`. This was a bounded direct Rust repair with
  settled acceptance, so a non-frontier implementation profile fit.
- Ready frontier: one safe lane with no sibling lanes. Exact-head review and a
  check-gated merge are the named serial edge before same-repository `main`
  refreshes.
- Outcome: the worker finished and opened Effigy PR 70 at exact head
  `ef549abb`; orchestrator review is starting. Do not count this as a completed
  cohort lane until the owning orchestrator reports an accepted merge.
- Operator intervention after dispatch: none.
- Review: zero completed rounds and no blocking finding class yet.
- Control-plane friction: none.
- Documentation QA: structural. Planning publication initially needed
  index-compatible path wording, then passed.
- Reduction fixture: the roadmap, card, log, and front-door closeout edits for
  the one-line bundled-inventory papercut.
- Provider family: not supplied.

### 022 — Effigy Papercuts environment-lock audit

Status: complete; reviewed and merged

- Worker class: `mechanical`. The lane was a long exhaustive test-only audit of
  environment reads with a settled repair boundary.
- Ready frontier: one lane. PR review and revision followed by same-repository
  merge were the named serial edge.
- Outcome: Effigy PR 69 merged at `54d67af8`.
- Operator intervention after dispatch: none.
- Review: two rounds. One blocking `execution-miss` found helper-hidden
  runtime-DNS reads of `HOME`; the revised head passed.
- Control-plane friction: none.
- Documentation QA: none.
- Reduction fixture: the `PAPERCUTS.md` closeout and short evidence-log update.
- Provider family: not supplied.

## Material protocol defect

The operator observed active orchestrator threads drop from roughly six-to-ten
to three after provider-limit failures. Northstar's live rule told orchestrators
to treat the first refusal as a global capacity answer and wait for a worker to
finish. Observation 008 shows the refused lane retained a valid handoff and
workspace; observation 007 shows a genuine serial dependency edge separately.
Observation 010 shows the complementary recovery path: once a real dependency
cleared, the retained worker and authority chain resumed without a replacement
or rebrief.

The settled correction is promoted to `g02.044/112` and spec 026. Provider,
model, and profile availability is lane-local routing state. It may reroute or
pause that lane, but it does not stop unrelated ready launches. The dogfood
window stays open for the planned validation-reduction experiment; no consumer
lane is changed to manufacture proof. Observation 012 is the first post-install
scheduling checkpoint: every safe Poodle lane was already launched, no global
slot budget was inferred, and the remaining serial edges were named from real
dependency or authority constraints. Observation 013 is the first actual
post-install provider reroute. The failure stayed lane-local and the handoff,
workspace, and branch survived, but Paseo could not retarget the terminal agent
record to another provider. A replacement agent record was therefore required
in the same workspace. This is not a duplicate active worker; it is a narrower
transport distinction between retained lane authority and reusable agent
identity to assess after the freeze.

Observation 015 exposes a separate recovery-lifecycle problem. Terminating an
agent that owns a shared workspace can archive the workspace and close a
replacement agent, while older viable unpushed work may not appear in initial
routing. The operator recovered this lane without widening the global-capacity
rule, but agent termination, workspace ownership, and retained-work discovery
need a post-freeze control-plane assessment. No protocol change is inferred
from this packet alone.

Observations 014, 017, and 019 show a recurring merge-adapter distinction: the
provider merge can succeed while local branch deletion fails because a Paseo
worktree still owns the branch. The nonzero command exit is not the merge
outcome. Each merge was verified from the PR and merge commit before
proceeding, so no ambiguous retry or duplicate merge occurred.

The operator settled the intended ownership for post-freeze planning. Inside
Paseo, a worker or orchestrator verifies the merge but does not delete its local
branch or worktree. Explicit workspace archive owns teardown and should remove
the managed worktree safely. Agent termination is a separate action and must
not implicitly archive a shared workspace or discard another retained agent's
work. Outside Paseo, Northstar keeps a provider-neutral manual cleanup path.
This decision is evidence for the closeout card; it does not mutate the live
protocol during the freeze.

Observation 020 exposes a narrower retained-agent discovery problem. The
originating worker existed but was absent from the current MCP scope, so the
orchestrator needed a global Paseo CLI listing to recover its identity. The
follow-up reused that worker and created no duplicate. Post-freeze adapter work
should support direct retained-ID lookup or follow-up without requiring scoped
enumeration; this packet does not justify polling workers.

## Cohort progress

- Observations received: 22.
- Completed cohort lanes: 8 of 8. Signal observation 004, Loophole observation
  010, Poodle observations 014 and 019, Market observations 016–017 and 020,
  and Effigy observation 022 are merged. The minimum cohort gate is met;
  observation 021 remains provisional, observation 015 has changes requested,
  observation 007 passed review but was not yet merged, and observation 005 is
  only a diagnostic kickoff.
- Projects represented: 7, exceeding the four-project breadth gate (`Poodle`,
  `Figmatic`, `Swallowtail`, `Signal`, `Effigy`, `Acowtancy/Market`, and
  `Loophole`).
- Provider families counted: 2 of 2. Swallowtail, Figmatic, and Market supplied
  Claude explicitly; Figmatic, Market, and Poodle supplied xAI.
- Worker routing: observations 001–003 are pre-refresh frontier baselines;
  observations 004–005 are post-refresh day-to-day choices; observation 006 is
  a frontier lane whose two escalation axes are explicit; observation 009 is a
  frontier planning delegate rather than an implementation worker; observation
  010 is another bounded day-to-day implementation choice; observation 011 is
  the second frontier planning delegate in the same Poodle frontier;
  observation 012 is a post-install scheduling checkpoint, not another worker
  lane; observation 013 is a post-install frontier choice with both escalation
  axes explicit and a provider route recovered before work began; observation
  014 completes the frontier conversational-planning lane opened in observation
  011; observation 015 continues the frontier Market lane from observation 008;
  observations 016–017 are economical day-to-day choices; observation 018 is
  a post-refresh day-to-day choice for material but fully settled public
  semantics; observation 019 completes the frontier conversational-planning
  lane opened in observation 009; observation 020 is another economical
  day-to-day repair choice; observation 021 is a bounded day-to-day Rust
  repair; observation 022 is a long mechanical audit with settled boundaries.
- Natural parallel shapes: 6. Observation 001 paired implementation with
  disjoint research; observation 002 paired two independent implementation
  lanes; observation 009 paired two planning delegates and an independent
  diagnostic session while preserving the serial promotion/readiness edge;
  observations 015–017 ran one frontier lane beside two independent day-to-day
  lanes while keeping same-repository merge order serial; observation 018
  launched settled motion implementation beside interactive diagnosis and
  planning while limiting any future overlap to the named chunk; observation
  020 refilled a safe day-to-day closeout lane beside continuing card 160. The
  required two multi-lane frontier observations are present in observations 002
  and 015.
- Completed review rounds: 18. Recorded blockers total three `planning-change`,
  ten `execution-miss`, five `oracle-gap`, and five `integration-drift`
  findings, plus three observation-015 blockers whose Northstar codes were not
  supplied.
- Validation-reduction fixtures: fourteen—one token-scanner boundary false positive,
  five benign accepted docs shapes from observations 002, 004, 006, 007, and
  010, the promoted-triage deletion from observation 013, and three concurrent
  closeout shapes from observations 015–017, plus the authority-aware triage
  compaction from observation 018 and historical-log repair from observation
  020, the bundled-inventory closeout from observation 021, and the compact
  papercut closeout from observation 022.
- Control-plane or task-routing friction appears in observations 001–004 and
  006–008, 010–011, 013–017, and 019–020; observations 005, 009, 012, and
  018 and 021–022 report none.

## Closeout

The cohort gate is met. Next, promote the reconciled evidence into one dated
log, compile the bounded validation-reduction card, carry the settled Paseo
archive and teardown ownership into post-freeze planning, and remove this
triage buffer. Keep modular language-package extraction and mode consolidation
planned but unimplemented during the protocol freeze.
