# g03.012 — Enforce sole-source lifecycle currentness

Owner: repo maintainers
Created: 2026-09-13
Governing refs: contract 001, bundle section 12, lifecycle reference
Depends on: `g03.011` complete at `99bbc94`
UI classification: none

## Outcome

Lifecycle adoption actually removes duplicate mechanical Markdown state. The
portable checker detects stale task headers and front-door currentness outside
generated regions, closeout cannot delete a handoff that durable Markdown still
links to, and a bounded repair route identifies the exact consumer repositories
that need correction.

## Ready-State Rubric

- [x] The failure is reproduced in Silo: `g01.071` is complete in canonical JSON
      and all generated projections while its task header and three declared
      front doors still say it is ready.
- [x] Northstar's own g03 front door reproduces the same contradiction for
      completed `g03.011`.
- [x] The current adoption fixture retains `Status: ready` and human currentness
      prose, so the existing oracle cannot prove the published contract.
- [x] Silo also proves the transient-reference failure: a durable implementation
      log links to the exact handoff consumed at closeout.
- [x] The desired authority boundary, detection scope, repair sequence, and
      negative controls are settled.
- [x] UI classification is `none`.

## Decisions

- Per-task JSON is the sole mechanical status and delivery authority after
  adoption. A lifecycle-managed task file contains no hand-maintained `Status:`
  header. Its dispatch manifest and semantic continuation remain authored
  planning.
- Generated regions are the sole mechanical currentness inside declared
  projection targets. Human prose may explain goals, history, and policy, but
  current-task or ready-frontier sections must not repeat a lifecycle-managed
  task's mutable status outside the generated region.
- Detection is structural and bounded. It examines lifecycle-record task paths,
  declared projection targets, and links to the exact consumable handoff. It
  does not classify arbitrary prose across the repository or rewrite semantic
  planning automatically.
- A closeout handoff is transient transport. Before deletion, the hook resolves
  Markdown links from tracked durable files and refuses atomically if any still
  target that exact handoff. Git and the terminal record preserve its identity;
  prose evidence links to permanent task, contract, PR, commit, or log surfaces.
- The adoption proof must contain the failures seen in Silo and must fail until
  the duplicate status, stale frontier, and consumed-handoff backlink are
  removed. A retrospective statement about prior state remains legal and must
  not be mistaken for currentness.
- Portfolio correction follows this task. The worker ships a reusable bounded
  audit/repair prompt or command surface; Chatterbox runs it against the adopted
  portfolio after the stricter oracle lands and dispatches only confirmed
  repairs.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready after this planning commit is pushed; one Northstar core lane,
  no concurrent sibling and no automatic successor.
- **Completion:** implementation and independent exact-head review pass; PR
  merges; the Effigy-hosted closeout publishes `g03.012` terminal state without
  stale status/frontier prose or a dangling handoff link; the exact consumer
  audit/repair route is ready for the portfolio follow-up.
- **Owned mutable paths:** lifecycle core and Queue adapter under
  `skills/northstar/**`; lifecycle fixtures and focused checks under
  `scripts/tests/**`; matching contracts, reusable doctrine, templates,
  architecture, task, roadmap, handoff guidance, and one reusable portfolio
  repair surface.
- **Reserved closeout surfaces:** `.northstar/lifecycle/v1/tasks/g03.012.json`,
  declared generated projection blocks, and deletion of this task's exact
  handoff belong exclusively to the required Queue hook after merge.
- **Worker:** automatic complex implementation pool; reviewer must use an
  independent provider/model identity.
- **Serial edges:** this is the only Northstar writer lane. Portfolio repair
  waits for its terminal hook publication and installed-skill parity.
- **Excluded:** edits to consumer repositories, Queue or Effigy source, live
  Queue data, automatic semantic prose rewriting, synthetic historic records,
  release or CI changes, and Paseo thread/workspace disposal.
- **Escalation:** Chatterbox owns ambiguity over whether prose is semantic
  history or mutable currentness. The worker stops rather than deleting meaning.

## Work

1. Add a focused currentness audit over lifecycle-managed task paths and
   declared projection targets. Report exact file, section, task ID, and reason
   in stable machine-readable output.
2. Replace the permissive adoption fixture with positive and negative cutover
   cases. Reproduce a terminal JSON record beside `Status: Ready`, a declared
   `Next Task` or frontier pointing at that terminal task, and a durable link to
   the soon-consumed handoff.
3. Tighten starter, normalize, refresh, and lifecycle doctrine so adoption
   removes duplicate mechanical fields and pointers while preserving semantic
   outcome, decisions, dependencies, and continuation.
4. Guard exact handoff consumption against tracked Markdown backlinks. Resolve
   relative links, ignore external URLs and the handoff itself, bound traversal,
   and refuse before any byte changes.
5. Correct Northstar's own lifecycle-managed currentness and handoff index so
   this task self-hosts the stricter rules. Do not hand-edit generated blocks.
6. Ship the bounded portfolio audit/repair route. It must inventory first,
   distinguish definite violations from prose needing Chatterbox judgment, edit
   no product files, preserve active planning, and validate each repository.
7. Run the lifecycle core/adoption suites, docs QA, complete QA, installed-skill
   parity, and a real closeout proof through the configured Effigy route.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| One status authority | JSON says `complete` while the recorded task path says `Status: Ready` | Audit rejects the exact Silo-shaped fixture and accepts a lifecycle task with no status header |
| One currentness authority | A declared front door's `Next Task` or frontier names a terminal recorded task | Structural audit rejects each duplicate section outside the generated block; retrospective history control remains accepted |
| Safe transient deletion | A durable implementation log links to the submitted handoff and closeout deletes it | Hook refuses before changing record, projection, or handoff bytes and reports the backlink path |
| Exact link resolution | External GitHub URLs or unrelated similarly named handoffs block closeout | Relative, rooted, fragment, external, mismatch, and same-name controls prove only an exact local target blocks |
| No semantic rewriting | Repair deletes roadmap goals or rewrites the next product decision | Repair fixture preserves semantic prose byte-for-byte outside exact accepted removals; ambiguous findings are reported only |
| Real adoption proof | The fixture still calls duplicated `Status: ready` and front-door prose valid | Focused suite fails on the old fixture and passes only after the cutover matches contract 001 |
| Portfolio route is bounded | Rollout blindly refreshes or edits every project | Dry-run inventory identifies exact violations and requires repository-local validation before a repair is dispatched |
| Self-hosted closeout | g03.012 completes while Northstar still names it ready or strands its handoff link | Terminal tree, hook result, lifecycle audit, docs QA, and Queue detail agree with no agent-authored closeout |

## Stop conditions

Stop if correctness requires parsing arbitrary natural-language history,
automatically choosing the next task, mutating consumer repositories in this
lane, preserving duplicate status for compatibility, deleting a referenced
handoff, or weakening the generated-block/JSON authority chain.

## Evidence

Planning evidence is the reproduced Silo `g01.071` contradiction, Northstar's
own stale `g03.011` prose, the permissive adoption fixture, and the preliminary
33-repository audit. Record implementation evidence through the lifecycle JSON
and generated projection; do not add a routine prose closeout log.

## Next task

After terminal closeout and installed-skill parity, run the bounded portfolio
audit and promote only confirmed repository repair tasks. Return ambiguous prose
to each project's Chatterbox rather than rewriting it mechanically.
