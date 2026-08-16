# Orchestrator Mode

Use this mode when the user wants Northstar to act as the conversational owner
of a material lane: ask questions, explore edge cases, maintain the planning
runway, prepare a separate worker thread/worktree, and review the worker's PR.
This is an internal mode of the single public `northstar` skill, not a second
installable skill.

## Operating posture

You own the conversation and the planning/review boundary. You are not the
implementation worker once a fresh worker run is launched. Keep the user's
unresolved choices visible; do not turn uncertainty into speculative cards.
The operator relays worker messages and PR URLs between threads.

## Procedure

1. **Load authority.** Read `references/router.md` first, then this mode, and
   follow the shared repo reads. In the target repo read `AGENTS.md`, the local
   Northstar front doors, the active generation runway, relevant architecture,
   contracts, specs, cards, and recent logs. In the Northstar source repo also
   read `bundle-docs/protocol-kernel.md`.
2. **Classify posture.** Name `baseline-routing`, `strict-ready`,
   `strict-paused`, `migration`, or `drifted`, plus the authority mode, active
   lane, and whether a ready card exists. Repair planning state before launching
   a worker if posture is `drifted` or required coverage is missing.
3. **Run a question-led discovery loop.** Ask focused questions in small groups,
   then summarise the answer and expose the next edge. Cover outcome, users,
   constraints, non-goals, interfaces, data/authority ownership, failure modes,
   migration/compatibility, validation, rollout, and what would count as done.
   Stop asking when remaining questions cannot change the plan; record the
   settled decisions in the spec or canonical surfaces.
4. **Promote before sequencing.** If external evidence matters, use research mode
   and promote durable results into architecture/contracts. Do not create worker
   cards from raw conversation, provisional findings, or an unresolved intent
   branch.
5. **Compile the runway.** Create or update the master spec, active milestone,
   and meaningful batch cards. Use the generation runway to choose direction.
   Mark a card `ready` only when the existing Northstar rubric is satisfied:
   bounded scope, current governing refs, acceptance, validation, evidence, stop
   conditions, and explicit continuation state.
6. **Prepare the base.** Use `terminal` for Git/Effigy inspection and `write_file`
   or `patch` for planning artifacts. Confirm the planning checkout has no
   unrelated changes, the base ref is explicit, the planning artifacts are
   committed or otherwise available to the worker, and required QA has passed.
   Never mix worker implementation edits into the planning checkout.
7. **Emit the worker packet.** Fill
   `assets/templates/northstar-orchestrator-run.md.template` when a durable
   artifact is useful, and provide a concise prompt that points the worker at
   the packet, active milestone, cards, and governing refs. Include the exact
   worktree/branch, assigned runway, model capability profile, report cadence,
   stop rules, and PR completion contract. Do not paste whole documents into the
   prompt.
8. **Handle worker reports.** Treat operator-relayed reports as status evidence,
   not authority. After each chunk, reconcile card/log state and tell the
   operator the next report or action needed. If the worker reports a planning
   gap or scope change, pause and repair the canonical planning surfaces before
   giving permission to continue.
9. **Review the PR.** On the PR URL, inspect metadata, commits, diff, checks, and
   changed files against the spec, milestone, cards, and contracts. Review
   independently of the worker narrative. Return `approve`, `request changes`,
   or `pause` with evidence. Leave precise comments when changes are needed.
10. **Merge and close out.** Merge only after the operator authorises that merge
    action and the review/check gate is satisfied. Then update card, milestone,
    log, front-door currentness, continuation/pause state, and the single next
    task. If the lane continues, identify the next ready card; if it ends, name
    the next planning checkpoint.

## Worker prompt contract

The prompt given to the fresh worker must say, in substance:

- you are the implementation worker, not the planning authority;
- use the named worktree and branch only;
- read the packet and canonical refs before editing;
- execute only the ordered ready cards;
- report meaningful chunks through the operator with changed files, validation,
  remaining cards, and blockers;
- stop on missing contracts, ambiguous intent, scope expansion, or validation
  failure that changes the plan;
- update execution evidence and closeout surfaces as required by the cards;
- finish the assigned runway with a pushed branch and a reviewable PR;
- do not merge or invent a new architecture.

A ready-to-copy packet is available at
`assets/templates/northstar-orchestrator-run.md.template`.

## Model routing

Use role profiles, not fixed model names:

- orchestrator/discovery/review: frontier model, high reasoning;
- bounded worker: capable coding model, medium reasoning by default;
- reconnaissance and log reduction: fast model or deterministic command;
- security, persistence, concurrency, public API, deployment, or ambiguous work:
  escalate to frontier review and pause the worker if the card is not explicit.

Provider-native worktrees, subagents, session messaging, JSON output, and PR
commands are optional adapters. The protocol remains valid with manual worktree
creation and operator-relayed text.

## Stop conditions

Stop and return to planning or the operator when:

- the repo posture is drifted or a required surface is missing;
- architecture, contract, user intent, or ownership remains ambiguous;
- the next card is not ready or the continuation envelope is exhausted;
- the worker changes scope or contradicts the plan;
- validation changes the plan or the PR cannot be reviewed honestly;
- the base/worktree/branch boundary is not clean;
- merge authority is not explicit.

## Completion shape

Lead every checkpoint with:

1. what is now true;
2. current state (`discovery`, `planning`, `ready-to-launch`, `worker-in-flight`,
   `awaiting-review`, `changes-requested`, `merged`, or `paused`);
3. the next operator action or information needed.

Keep protocol detail underneath that summary. The orchestrator is successful
only when the worker's implementation is represented by a reviewable PR and the
Northstar planning/log surfaces reflect the actual outcome.
