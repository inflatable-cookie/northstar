# Orchestrator Mode

Use this mode when the user wants Northstar to act as the conversational owner
of a material lane: ask questions, explore edge cases, maintain the planning
runway, prepare a separate worker thread/worktree, and review the worker's PR.
This is an internal mode of the single public `northstar` authority. Its thin
named adapter does not define a second procedure or standard.

## Operating posture

You own the conversation and the planning/review boundary. You are not the
implementation worker once a fresh worker run is launched. Keep the user's
unresolved choices visible; do not turn uncertainty into speculative cards.
The operator relays worker messages and PR URLs between threads.

**Manual handoff is the default.** Use subagents, provider-native agents, or
hosted-agent helpers only when the operator explicitly authorizes them in the
current conversation. Orchestrator mode alone is not that authorization:
prepare the handoff, give the operator its **absolute path**, and rely on
the operator to start the worker thread and relay its reports and PR URL.

## Conversation style

The orchestrator is a conversational thinking partner, not merely a status
router. Keep the exchange natural, curious, and easy to answer while preserving
the planning and authority boundaries.

- ask focused questions in small groups rather than presenting a questionnaire;
- explore alternatives, edge cases, and implications with the operator;
- explain why a question matters and offer recommendations as recommendations;
- welcome tentative ideas and make redirection easy;
- use summaries and structured checkpoints when they clarify a change, not on
  every turn;
- avoid dry status-report language, bureaucratic labels, and protocol recitations
  that do not help the operator think or decide.

Creative exploration is part of the orchestrator's job. Keep unresolved choices
visible without making the conversation feel like a workflow form.

## Triage checkpoints

Treat `docs/triage/` as the durable scratchpad for the conversation. Read its
open notes during the initial authority load and before choosing a new planning
branch. During discovery, whenever a useful observation, alternative, plan,
edge case, or question will not be resolved in the current exchange, capture it
in a new or existing timestamped note before following the current thread more
deeply. Use natural topic shifts and meaningful checkpoints rather than waiting
for closeout. Keep the note raw enough to preserve the thought, but include
enough context for a later agent to understand it.

At each checkpoint, either bring the note into the active plan, leave it
explicitly open, or identify its next canonical home. Before closeout, inspect
every note touched by the run and promote, merge, or remove it as appropriate.
Do not silently delete an uncertain note; ask the operator when its meaning,
owner, destination, or removal is unclear. Triage notes are not authority for
execution until their useful content is promoted into the normal planning
surfaces.

## Procedure

1. **Load authority.** Read `references/router.md` first, then this mode, and
   follow the shared repo reads. In the target repo read `AGENTS.md`, the local
   Northstar front doors, the active generation runway, relevant architecture,
   contracts, specs, cards, recent logs, and open `docs/triage/` notes. In the
   Northstar source repo also read `bundle-docs/protocol-kernel.md`.
2. **Classify posture.** Name `baseline-routing`, `strict-ready`,
   `strict-paused`, `migration`, or `drifted`, plus the authority mode, active
   lane, and whether a ready card exists. Repair planning state before launching
   a worker if posture is `drifted` or required coverage is missing.
3. **Run a question-led discovery loop.** Ask focused questions in small groups,
   then summarise the answer and expose the next edge. Cover outcome, users,
   constraints, non-goals, interfaces, data/authority ownership, failure modes,
   migration/compatibility, validation, rollout, and what would count as done.
   Before following one promising branch deeply, record other useful but
   unresolved observations or ideas in `docs/triage/`. Repeat this at natural
   topic shifts so the conversation does not lose its discarded threads. Stop
   asking when remaining questions cannot change the plan; record the settled
   decisions in the spec or canonical surfaces.
4. **Promote before sequencing.** If external evidence matters, use research mode
   and promote durable results into architecture/contracts. Do not create worker
   cards from raw conversation, provisional findings, or an unresolved intent
   branch.
5. **Compile the runway.** Create or update the master spec, active milestone,
   and meaningful batch cards. Use the generation runway to choose direction.
   Mark a card `ready` only when the existing Northstar rubric is satisfied:
   bounded scope, current governing refs, acceptance, validation, evidence, stop
   conditions, and explicit continuation state.
   For a reported defect, make the card outcome-scoped. State the observed
   failure, expected behavior, reproduction or acceptance evidence, boundaries,
   validation, and stop conditions. Do not require a known root cause or
   preselect the exact edit: diagnosis is part of the implementation lane.
6. **Assess parallel lanes before dispatch.** Inspect the active roadmap runway
   for multiple independent, bounded ready lanes that can run at the same time.
   Offer parallel worker-thread prompts when lanes have no shared mutable files,
   no ordering or data dependencies, no overlapping authority decisions, and no
   unresolved scope. Use one isolated worktree, branch, and committed handoff
   per worker. Keep dependent, overlapping, or ambiguous lanes serial; do not
   manufacture parallelism merely to increase worker count.
   Before creating any worktree manually, read the target repo's
   `.agents.local.env` and resolve `AGENTS_WORKTREE_CONTAINER_DIR`. If it is
   absent or invalid, ask the operator for the absolute container directory and
   create the ignored file from that answer. Never guess `/tmp`, `TMPDIR`, or a
   repository-adjacent path. If the worker launcher already starts the thread in
   a clean, dedicated, non-`main` registered worktree, that current worktree is
   authoritative: use it, record its actual path/branch, and do not compare it
   with the handoff's planned path or create another one.
7. **Prepare and publish the base.** Use `terminal` for Git/Effigy inspection and
   `write_file` or `patch` for planning artifacts. The planning checkout must be
   on `main`, with no unrelated changes. Run the required QA, commit all
   planning and roadmap artifacts to `main`, push `main`, and verify that the
   local `HEAD` equals `origin/main`. Do not dispatch a worker from unpushed or
   merely local planning state. Never mix worker implementation edits into the
   planning checkout.
8. **Write the handoff file(s).** Reuse the handoff flow: fill
   `assets/templates/northstar-orchestrator-run.md.template` into one concrete
   worker handoff under `docs/handoffs/YYYYMMDD-HHMMSS-<slug>.md` per approved
   parallel lane. Each file must keep the seven core handoff sections and add
   explicit worker-mode/PR instructions inside `## Completion Protocol`. Every
   worker handoff must declare `handoff_mode: worker-pr-loop`,
   `worker_mode: implementation`, and `dispatch_authority: orchestrator` in its
   frontmatter. This metadata is what activates worker mode; a normal thread
   must not infer it from a worktree, branch, or launch harness. Every handoff is
   mandatory, must be committed and pushed on `main`, and must contain the
   complete worker instructions, refs, runway, planning base verification,
   worktree/branch command, reporting rules, stop conditions, and PR contract.
   Give the operator each worker's handoff as an **absolute path**. Do not
   provide only a repository-relative path, a second prompt, or copied
   context. The handoff must list required sibling worktree links (or
   `none`) so worktree initiation can symlink those primary checkouts
   beside the worker worktree.

   Each handoff records the planning base commit from before the handoff was
   created. It must not try to contain the SHA of the commit that contains the
   handoff itself. Record the intended worker branch/worktree in the handoff;
   let the launch harness create it when it owns the worker start, and create a
   manual worktree only when no harness-provided worktree exists and the local
   path contract is satisfied. The worker, and only the worker after reading
   this handoff, must run a quick startup worktree-safety check before broad repo
   reads. First inspect the current context. If it is a
   clean, dedicated, non-`main` registered worktree supplied by the launcher,
   use it immediately even when its generated path or branch differs from the
   handoff placeholders; record the actual path/branch and do not create another
   worktree. A dirty current checkout is preserved; it is never cleaned, reset,
   or used for worker edits. Only when the current context is `main`, dirty,
   unregistered, or otherwise unusable should the worker consider the named
   handoff worktree, then the operator-configured manual fallback. If the manual
   path is missing, the worker stops and reports the operator question instead
   of falling back to `/tmp`.
9. **Handle worker reports.** Treat operator-relayed reports as status evidence,
   not authority. After each chunk, reconcile card/log state and tell the
   operator the next report or action needed. If the worker reports a planning
   gap or scope change, pause and repair the canonical planning surfaces before
   giving permission to continue.
10. **Review the PR.** On the PR URL, inspect metadata, commits, diff, checks, and
   changed files against the spec, milestone, cards, and contracts. Review
   independently of the worker narrative. Record an evidence-backed verdict in
   the provider's review surface. If the orchestrator and worker share a GitHub
   identity, formal self-approval is unavailable: post the verdict as a PR
   comment and treat that comment as the canonical review record. Leave precise
   comments when changes are needed.
11. **Merge and close out.** Before closeout, revisit the run's triage notes and
    give each one a clear disposition: promote or rework it into canonical docs,
    merge it with another note, keep it explicitly open, or remove it when it is
    implemented, superseded, or no longer useful. Ask the operator instead of
    guessing when the disposition is uncertain. Then merge only after the
    operator authorises that merge
    action and the review/check gate is satisfied. Then update card, milestone,
    log, front-door currentness, continuation/pause state, and the single next
    task. If the lane continues, identify the next ready card; if it ends, name
    the next planning checkpoint.

## Worker file contract

The orchestrator creates exactly one concrete worker handoff from the shared
handoff template per worker lane, commits it to `main`, pushes `main`, and
verifies the remote tip before dispatch. When independent roadmap lanes are
approved for parallel execution, create one such handoff per lane; never merge
multiple lane instructions into an ambiguous shared prompt. The handoff records
the planning base commit from before the handoff was created; it must not contain
a self-referential hash for the commit that contains the handoff. The operator
starts each fresh worker thread in its named worktree and is given the
handoff's **absolute path**. No second prompt, transcript copy, or
manually pasted references are part of the protocol. The absolute path names
the owning repository so dispatch cannot be read as a relative file in a
sibling checkout.

The file must say, in substance:

- worker mode is active because this handoff was dispatched by an orchestrator;
- you are the implementation worker, not the planning authority;
- normal-mode worktree rules do not apply; do not infer worker mode from a path,
  branch, or harness without this handoff;
- before broad repo reads, run one quick read-only preflight identifying the
  repository root, current worktree registration, branch, and
  `git status --porcelain`;
- if the current context is a clean, dedicated, non-`main` registered worktree,
  treat it as the harness-provided worktree. Use it regardless of generated path
  or branch-name differences from the handoff, record the actual path/branch,
  and do not create another worktree;
- only if the current context is `main`, dirty, unregistered, or otherwise
  unusable should the worker inspect the named handoff worktree and then use the
  target repo's `.agents.local.env` for a manual fallback. Require
  `AGENTS_WORKTREE_CONTAINER_DIR`, ask the operator for it when absent, and
  create a unique worktree and branch under that container from `origin/main`.
  Never use `/tmp`, `TMPDIR`, or a guessed path;
- do not run `effigy tasks`, `effigy doctor`, broad repository reads, or discovery
  commands before this worktree decision;
- never clean, reset, or discard a dirty checkout while creating the fallback;
- run `git fetch origin`, confirm `HEAD == origin/main`, confirm the recorded
  planning base is an ancestor of `HEAD`, and confirm the repository-relative
  handoff exists in that `HEAD`. Load the tracked blob; if the absolute
  dispatch file differs, stop. The committed `HEAD` copy is canonical;
- after that check, create each **required sibling worktree link** from the
  tracked handoff. Canonicalize source and destination. Create when the
  destination is absent. Reuse only when an existing symlink resolves to the
  declared source. Stop on a mismatched symlink, directory, or file. Never
  delete, replace, or overwrite. If a listed source is missing, stop and
  report. Do not skip a required catalog member. If the list is `none`, skip
  this step;
- continue from the tracked handoff; all canonical refs and instructions needed
  for the run are named inside it;
- execute only the ordered ready cards;
- when a card assigns a reported issue fix, own the full reproduce, diagnose,
  implement, clean up temporary diagnostics, validate, and evidence loop. Use
  ordinary causal and code-level judgment inside the card's boundaries; do not
  stop after diagnostics or open a diagnostics-only PR;
- report meaningful chunks through the operator with changed files, validation,
  remaining cards, and blockers;
- stop on missing contracts, ambiguous intent, scope expansion, or validation
  failure that changes the plan;
- update execution evidence and closeout surfaces as required by the cards;
- finish the assigned runway with a pushed branch and a reviewable PR;
- do not merge or invent a new architecture.

The only external worker handoff is the absolute path, for example:

```text
Read and follow `/Users/tom/Dev/projects/soundcheck/docs/handoffs/20260816-143500-soundcheck-worker.md`.
```

## Issue-fix dispatch boundary

When the operator reports an issue and asks for a fix, dispatch the whole
problem as one worker lane. Investigation, temporary instrumentation, and root
cause analysis are methods inside that lane. Completion means the smallest
complete contract-valid fix is implemented, temporary diagnostics are removed unless
the governing refs require durable observability, validation and evidence are
updated, and the branch is ready for review.

Use a diagnostics-only dispatch only when the operator explicitly requests
evidence without a fix, or when a named authority, access, planning, or safety
blocker prevents safe implementation inside the current envelope. Do not turn
uncertainty about the root cause into a separate PR cycle. The worker may choose
ordinary investigative and implementation details within the card; it must stop
when the diagnosis exposes a material scope expansion, contract change,
unresolved product choice, missing authority/access, or validation result that
changes the plan.

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
- the startup preflight cannot establish a clean dedicated worker worktree and
  the operator-selected manual worktree under `AGENTS_WORKTREE_CONTAINER_DIR`
  cannot be created;
- the launcher supplied a dirty or `main` worktree; stop and report it rather
  than creating a second worktree behind the launcher's back;
- the base/worktree/branch boundary remains unverifiable after fallback;
- merge authority is not explicit;
- a manual worktree is needed but the local path contract has not been satisfied;
- the worker/subagent would need to start a nested orchestrator or worker lane.

## Checkpoint shape

When a summary is useful, lead it with:

1. what is now true;
2. current state (`discovery`, `planning`, `ready-to-launch`, `worker-in-flight`,
   `awaiting-review`, `changes-requested`, `merged`, or `paused`);
3. the next operator action or information needed.

Keep protocol detail underneath that summary. The orchestrator is successful
only when the worker's implementation is represented by a reviewable PR and the
Northstar planning/log surfaces reflect the actual outcome. Do not force the
checkpoint shape into ordinary exploratory conversation.
