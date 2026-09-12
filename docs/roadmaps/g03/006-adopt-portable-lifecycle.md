# g03.006 Adopt Portable Lifecycle

Status: ready
Owner: repo maintainers
Created: 2026-09-12
Governing refs: spec 040, system architecture, contract 001
Depends on: `g03.005` complete; Queue PR #8 merged as `7da4eeb` and installed
UI classification: none

## Outcome

Adopt the portable lifecycle records and deterministic projections in the
Northstar starter and in Northstar itself. Ship the thin repository hook that
maps generic Queue events into the same transition envelopes as the standalone
adapter. Retire agent-written mechanical closeout only after standalone and
Queue execution produce the same terminal receipt and one live shadow closeout
passes.

## Ready-State Rubric

- [x] The provider-neutral core and standalone oracle are complete in `g03.005`.
- [x] Queue's generic control manifest, event/result contracts, transactional
      hook intent, and integration writer are merged and installed.
- [x] The exact Queue contract version and supported event set are recorded in
      this task before dispatch.
- [x] Scope, authority, portability, and terminal-equivalence boundaries are
      fixed by spec 040.
- [x] UI classification is `none`.
- [x] No Northstar task is executable while the external prerequisite is open.

## Decisions

- Portable records begin at the adoption boundary. Do not reconstruct
  `g03.001` through `g03.005` as synthetic lifecycle history; their task
  closeouts and Git/provider evidence remain authoritative provenance.
- Northstar owns the hook translation and `.paseo/queue.json` starter. Queue
  owns only generic event delivery, hook execution, integration publication,
  and reconciliation.
- The standalone adapter remains complete and supported. Queue is an optional
  driver of the same reducer, not a second lifecycle implementation.
- Mechanical task state and delivery evidence move to per-task JSON. Generated
  Markdown blocks become the only duplicated status view. Semantic outcome,
  acceptance, limits, priority, and continuation remain human-owned Markdown.
- A live authority switch requires one shadow closeout whose manually checked
  facts and hook-produced terminal record agree exactly. Failure keeps the old
  closeout route active and returns to Chatterbox.
- If this task cannot prove its own live cutover after merge, close it with the
  adapter and equivalence proof complete and promote one small cutover task.
  Do not fake same-task evidence or keep two permanent routes.

## Queue prerequisite

- Queue task `g01.007` / `3ca4a65b-dfde-4d2d-85c1-df4ccb68ea4a` shipped in
  PR #8. Accepted implementation head: `0f9b1bb34eb441dbecac8f741e60a66562c69d07`;
  merge: `7da4eeba73c4f1ce7d8c7967acd6e11fbf83c7f6`.
- Frozen schemas: `paseo.queue.control.v1`, `paseo.queue.event.v1`, and
  `paseo.queue.hook-result.v1`.
- Supported events: `task.pre_dispatch`, `task.blocked`, `task.cancelled`, and
  `task.closeout`. Pre-dispatch is read-only; the other events may use
  read-only or integration-write mode.
- Queue main was clean and synchronized at
  `2c528543b00147556acd4a5ed74b3784d0fee056` during readiness review. Paseo's
  plugin log records a successful directory-plugin reload after that commit.
- The contract keeps manifest absence compatible, treats instructions as
  opaque committed artifacts, executes fixed argv without a shell, records
  durable hook intent, and makes Queue own validated integration publication
  and uncertain-effect reconciliation.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready after this planning commit is pushed; one lane, no concurrent
  sibling and no automatic successor.
- **Completion:** the Northstar hook adapter, starter manifest, projection
  targets, installed-consumer proof, repository adoption boundary, standalone
  shadow proof, Queue equivalence proof, and live cutover satisfy the oracle;
  independent review accepts the exact head; the PR merges; the integration
  checkout is synchronized; the live shadow closeout either passes and removes
  manual mechanical bookkeeping or produces a separately planned cutover task.
- **Owned mutable paths:** lifecycle scripts, schemas, references, fixtures, and
  templates under `skills/northstar/**`; matching reusable doctrine and starter
  surfaces under `bundle-docs/**` and `template-bundle/**`; `.paseo/queue.json`;
  `.northstar/lifecycle/**`; necessary `effigy.toml` and focused test wiring;
  generated blocks and directly displaced mechanical instructions.
- **Reserved closeout surfaces:** architecture, contract 001, spec 040, this
  task, g03 runway and roadmap indexes, project/docs front doors, lifecycle
  receipts and projections, consumed handoff, and justified compact evidence.
- **Worker:** automatic adequate complex implementation pool; reviewer must use
  an independent provider/model identity.
- **Serial edges:** Queue generic hooks first; this task second; generation
  compaction receipt adoption only after live parity.
- **Excluded:** Queue source changes, Queue-specific state vocabulary in the
  core, retroactive synthetic records, a shared task ledger, automatic semantic
  priority, remote webhooks, `.github/workflows/`, releases, and compatibility
  aliases that preserve the retired manual route indefinitely.
- **Escalation:** Chatterbox owns lifecycle authority, migration, parity, and
  cutover decisions. Queue's planning authority owns its generic hook design.

## Work

1. Record the exact merged Queue hook schema/version and verify it remains
   document-system agnostic. Reject any contract that imports Northstar or
   assumes Northstar paths, commands, IDs, or Markdown.
2. Harden explicit-path containment for lifecycle `render` and `compact`, then
   add repository-declared multi-target projection handling that validates all
   targets and reports exact changed paths without staging or publishing them.
3. Add the installed Northstar hook adapter. Validate generic Queue input,
   reconstruct exact task/planning identity, map supported events to canonical
   transition envelopes, invoke the existing reducer, and return only the
   Queue-owned generic result schema. Keep Queue metadata opaque and additive.
4. Ship a copy-ready `.paseo/queue.json` and standalone adoption guidance. The
   manifest pins executable arguments, modes, limits, allowed paths, and commit
   subject policy without shell interpolation or source-checkout dependence.
5. Define the adoption boundary and generated projection blocks for task,
   generation, roadmap, and project currentness. Preserve all human-owned
   semantic text outside sentinels and remove hand-maintained duplicates when
   the switch occurs.
6. Prove an isolated installed consumer can execute the full standalone path
   with no Paseo, Queue, network, or Northstar source checkout. Repeated runs
   must be byte-stable and stale, dirty, escaping, or interrupted writes must
   preserve prior bytes.
7. Replay equivalent standalone and generic Queue event sequences in both task
   orders. Require the same portable digest and canonical portable fields;
   only isolated source-adapter metadata may differ.
8. Dogfood the adoption boundary in this repository. Run one live shadow
   closeout against independently checked PR, review, merge, synchronized-main,
   validation, and continuation facts. Switch authority only when parity and
   projection drift checks pass.
9. Update orchestrator, maintenance, roadmap, starter, and closeout doctrine so
   agents write semantic decisions and exceptions only. The lifecycle command
   owns mechanical state, evidence, generated blocks, and changed-path output.
10. Run the focused lifecycle/adoption/equivalence fixtures, installed parity,
    `effigy qa:docs`, `effigy qa`, and `git diff --check`.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| Standalone remains first-class | Adoption needs Queue, Paseo, network access, or the Northstar checkout | Isolated installed-consumer closeout and projection proof |
| Queue stays document-agnostic | Queue imports Northstar, invokes a built-in Northstar command, or admits Northstar paths in core | Generic manifest/event/result fixtures plus a non-Northstar hook |
| Both adapters share one truth | Equivalent evidence produces different portable fields, digests, or status vocabularies | Terminal-equivalence oracle over canonical portable fields and digest |
| Writes stay bounded | Explicit render/compact or a hook escapes the repo, follows a symlink, edits an undeclared path, or publishes from dirty/stale main | Containment, manifest pin, changed-path, CAS, dirty-tree, and uncertain-publication negatives |
| Currentness becomes mechanical | Task/front-door status still needs manual copying or generated content has two authorities | Golden multi-target projections and removal of displaced manual fields after cutover |
| Semantics remain human-owned | Automation chooses priority, invents continuation, retires a spec, or overwrites narrative | `planning_required`, sentinel preservation, and semantic-drift negatives |
| History stays honest | Adoption fabricates receipts for pre-boundary tasks or upgrades attestations | Boundary proof and evidence-level assertions |
| Cutover is earned | Manual route retires before a live shadow closeout matches exact delivery evidence | Published shadow receipt, exact-head review, merge/validation binding, and no-diff replay |
| Failure is recoverable | Required hook failure advances Queue or an uncertain commit/push is repeated blindly | Required/advisory, idempotency, and reconciliation fixtures |

## Stop conditions

Stop if Queue must know Northstar structure, the Northstar adapter must query
Queue's database, live publication requires a shared mutable task ledger, the
hook can interpolate event data into a shell command, multi-target writes can
escape their declared paths, or parity would require weakening evidence levels.
Stop before cutover if the live shadow receipt differs or semantic currentness
would be lost. Promote a bounded successor rather than retaining two permanent
closeout routes.

## Evidence

Queue prerequisite evidence is recorded above. Delivery evidence is pending.

## Next task

Dispatch this task only after explicit execution authorization. If its live
shadow cannot prove same-task cutover after merge, return to Chatterbox for one
bounded cutover task.
