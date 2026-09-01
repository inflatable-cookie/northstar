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
The operator remains the authority boundary; transport may be direct through an
available control plane or operator-relayed.

**Paseo dispatch is implicit inside Paseo.** When the current orchestrator
thread exposes Paseo's profile, workspace, agent, and follow-up tools, that
injected tool surface authorizes routine dispatch of an already-approved, ready
Northstar worker lane. Do not ask for permission or merely suggest Paseo before
using it. A repository `paseo.json` alone is project capability configuration,
not evidence that the current thread is running in Paseo. When the required
tools are absent, give the operator the handoff's **absolute path** for manual
launch and relay. Neither route widens authority for missing planning choices,
permission requests, destructive workspace cleanup, review, or merge. Merge
authority comes from the orchestrator lane's accepted review/check gate, not
from the transport adapter.

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
When a note is promoted into a roadmap, remove the triage file in the same
planning batch. If the note also contains unresolved material, preserve that
material in a separate open note before removing the promoted source; do not
leave promoted content in triage.
Do not silently delete an uncertain note; ask the operator when its meaning,
owner, destination, or removal is unclear. Triage notes are not authority for
execution until their useful content is promoted into the normal planning
surfaces.

## Conversational planning delegates

When the operator explicitly asks to spin off planning for a named topic, the
orchestrator may create a frontier planning delegate and continue unrelated
work. This is not implementation worker mode. The delegate owns one direct
conversation with the operator and one reviewable triage/research packet; the
orchestrator retains canonical promotion, readiness, implementation routing, PR
review, and merge.

Use `assets/templates/northstar-discovery-delegate.md.template`. Its frontmatter
must declare `handoff_mode: planning-delegate`,
`planning_mode: conversational-discovery`,
`dispatch_authority: orchestrator`, and
`promotion_authority: orchestrator`. Commit and push the handoff on `main`
before launch, give the operator its absolute path, and use it as the only
initial prompt. The handoff names the topic, base, canonical context, isolated
branch/worktree, allowed `docs/triage/` and optional `docs/research/` paths,
required sibling links or `none`, opening questions, research boundary,
concurrent non-overlapping work, stop conditions, validation, and planning-PR
contract.

Select a frontier/high-reasoning conversational-planning profile from current
adapter notes. An operator-named profile wins; Sol is one possible local
choice, not a Northstar dependency. In Paseo, create one `branch-off` worktree
workspace from pushed `origin/main`, materialize that profile into
`create_agent`, retain the agent/workspace IDs, and let the operator converse in
the new thread. Before launch, verify every named sibling link exists in the
workspace container directory and resolves to its declared primary checkout.
Do not proxy the planning conversation or poll it. Without Paseo, the operator
launches a manually isolated thread from the absolute handoff.

The delegate records operator-confirmed decisions, its recommendations,
alternatives, evidence, non-goals, and unresolved questions distinctly. It may
spawn bounded read-only research subagents or advisors. They return sourced
findings to the delegate; they do not edit, create worktrees/branches/PRs,
contact the operator, or start nested orchestrator or implementation lanes. The
delegate reconciles their output before writing the packet. Select research
profiles from current notes by evidence risk: fast/low-cost for bounded source
collection, frontier/high reasoning for ambiguous synthesis or high-stakes
claims. Do not store those local profile names in Northstar.

While the delegate is active, reserve its topic: continue only work that does
not depend on its conclusions or mutate its named packet. When it opens a PR,
review the exact head for fidelity to the handoff and recorded operator
confirmations, evidence quality, scope, and clean separation of confirmed
decisions, recommendations, and open questions. Ask the operator when decision
ownership remains unclear; private thread history is not repository authority.
Post requested changes and explicitly wake the same delegate. After accepted
review, passing checks, mergeability, and no stricter rule or operator pause,
merge without another approval prompt.

Merge is intake, not promotion. Re-read the merged packet against current
`main`, resolve drift or contradictory decisions with the operator, choose the
canonical destinations, promote settled meaning, and remove or split resolved
triage notes. Only after that separate promotion batch may the orchestrator
decide readiness or dispatch implementation. Mechanical documentation
projection may materialize the already-settled promotion, but cannot choose it.

## Mechanical documentation projection

Keep discovery, planning, promotion, readiness, review-oracle design, worker
routing, PR review, and merge in the frontier orchestrator. After those choices
are settled, a fast/low-cost subagent may project a meaningful mechanical batch
into named documentation surfaces. Use the current profile notes rather than a
hard-coded model name; Luna is one possible local profile, not a Northstar
dependency.

When Paseo exposes profiles and agent creation, list current profiles, choose
the one whose notes fit fast/low-cost documentation projection, and create the
subagent in the current planning workspace. Do not create a worker workspace or
ask for another permission prompt. If the current planning workspace cannot be
identified safely, do not guess; use an available provider-native subagent or
keep the projection in the orchestrator.

Use `assets/templates/northstar-documentation-projection.md.template` as the
brief. It must name the authority owner, settled decisions, canonical refs,
allowed paths, exact facts/evidence, required state transitions, forbidden
judgments, validation, and stop conditions. Delegable work includes:

- materializing already-settled roadmap, card, log, front-door, index, handoff,
  template, parity, and evidence updates;
- synchronizing exact settled wording across named source/install surfaces;
- running deterministic docs, link, parity, and diff checks.

The projection subagent must not choose a canonical home, invent or reinterpret
intent, add acceptance/stop/review-oracle policy, decide ready/complete/next
state, resolve a contradiction, edit product code, commit, push, review, or
merge. It stops and returns the question when the brief does not settle a choice.

Run projection serially in the planning context, not as worker mode: no worker
handoff, worktree, branch, or PR. Capture dirty state and allowed paths before
dispatch, wait for it to finish before resuming overlapping edits, then inspect
the complete diff for semantic fidelity. The orchestrator owns every Git
mutation. Delegate roughly three or more related projection surfaces, or another
batch large enough to repay dispatch and review; keep tiny edits local.

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
   Remove each triage file promoted into that roadmap runway in the same
   planning batch, after preserving any still-unresolved material in a separate
   open note.
   Mark a card `ready` only when the existing Northstar rubric is satisfied:
   bounded scope, current governing refs, acceptance, validation, evidence, stop
   conditions, and explicit continuation state.
   Add a compact review oracle when acceptance crosses concurrency, lifecycle,
   identity, persistence, security, public API, deployment, multi-version, or a
   universal/exact/negative claim. Name the invariant, smallest adversarial
   counterexample, expected failure or stop point, and required proof. The
   reviewer must not need to invent material acceptance during review.
   For a reported defect, make the card outcome-scoped. State the observed
   failure, expected behavior, reproduction or acceptance evidence, boundaries,
   validation, and stop conditions. Do not require a known root cause or
   preselect the exact edit: diagnosis is part of the implementation lane.
   Once meaning is settled, use mechanical documentation projection for a
   worthwhile named batch. Review the returned diff before marking cards ready,
   publishing planning, or making any Git mutation.
6. **Refresh the dependency frontier and dispatch all of it.** Parallelism is
   the default schedule, not an option to offer. Map the runway's meaningful
   lanes as a dependency graph, identify the current ready frontier, and select
   every safe lane that fits available capacity. Record why any otherwise-ready
   lane stays queued or serial, then plan one worktree, branch, and handoff per
   selected lane. Do not wait for the operator to ask for concurrency. Full
   rules are in **Parallel lane dispatch** below.
   An operator-requested planning delegate may run beside unrelated work, but
   reserve its topic and do not dispatch or promote work that depends on its
   conclusions until its PR is reviewed, merged, and promoted.
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
   worker handoff under `docs/handoffs/YYYYMMDD-HHMMSS-<slug>.md` per selected
   frontier lane. A same-repository lane's handoff also names the surfaces it
   owns, the sibling lanes running beside it, and the closeout partition or
   reserved orchestrator integration step. Each file must keep the seven core
   handoff sections and add explicit worker-mode/PR instructions inside
   `## Completion Protocol`. Every
   worker handoff must declare `handoff_mode: worker-pr-loop`,
   `worker_mode: implementation`, and `dispatch_authority: orchestrator` in its
   frontmatter. This metadata is what activates worker mode; a normal thread
   must not infer it from a worktree, branch, or launch harness. Every handoff is
   mandatory, must be committed and pushed on `main`, and must contain the
   complete dispatch state, refs, runway, planning base verification,
   worktree/branch command, reporting rules, stop conditions, and PR contract.
   Treat it as a dispatch overlay: point to card steps, acceptance, review
   oracles, and general doctrine instead of copying them. If the handoff rivals
   its owning card or repeats multi-paragraph protocol text, compress it.
   Give the operator each worker's handoff as an **absolute path**. Do not
   provide only a repository-relative path, a second prompt, or copied
   context. The handoff must list required sibling worktree links (or
   `none`) so worktree initiation can symlink those primary checkouts into the
   worktree container directory (the worker worktree's parent).

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
9. **Dispatch through an available control plane.** Only after the handoff is
   committed and pushed, use Paseo automatically when the current thread exposes
   its required orchestration tools:
   - call `list_profiles` and read every profile's notes; select by the role and
     risk rules below, not by a remembered profile or model name. A profile the
     operator explicitly names for the lane overrides this selection;
   - call `create_workspace` once per dispatched lane with
     `isolation: worktree`, `mode: branch-off`, `baseBranch: origin/main`, the
     intended branch, and the source checkout path. Read the control plane's
     real capacity rather than assuming a worker count, and dispatch the whole
     selected frontier rather than one lane at a time;
   - before launching the worker, verify every sibling link named by the handoff
     exists in the managed worktree's **container directory** (the worktree's
     parent), resolves to the declared primary checkout, and was available before
     any project bootstrap step that needs it. Project lifecycle hooks may create
     these links; otherwise stop on absence or conflict rather than leaving the
     worker to discover a broken dependency topology;
   - materialize the selected profile into `create_agent`: combine its provider
     and model as the provider value, copy mode/thinking/features into settings,
     place it in that workspace, leave finish notification enabled, and use only
     `Read and follow <absolute-handoff-path>.` as the initial prompt;
   - retain the returned agent and workspace IDs as lane transport state so
     review follow-ups target the originating worker rather than a replacement;
   - trust finish and permission notifications; do not poll agent status. Use
     `send_agent_prompt` on the same agent for bounded continuation or requested
     changes;
   - return permission requests to the operator unless existing explicit
     authority settles the exact action.

   Do not invoke `/paseo-handoff` for a worker or planning delegate: it creates a
   second briefing and would compete with the committed Northstar handoff. If
   required tools are absent, use manual
   dispatch without treating `paseo.json` as a substitute runtime signal. If
   setup fails, preserve and report any created workspace or agent identity; do
   not silently retry into a duplicate worker.
10. **Handle worker reports.** Treat direct adapter reports and operator-relayed
    reports as status evidence, not authority. After each chunk, reconcile
    card/log state and name the next report or action needed. If the worker
    reports a planning gap or scope change, pause and repair the canonical
    planning surfaces before giving permission to continue.
11. **Review the PR.** On the PR URL, inspect metadata, commits, diff, checks, and
   changed files against the spec, milestone, cards, and contracts. Review
   independently of the worker narrative. Record an evidence-backed verdict in
   the provider's review surface. If the orchestrator and worker share a GitHub
   identity, formal self-approval is unavailable: post the verdict as a PR
   comment and treat that comment as the canonical review record. Leave precise
   comments when changes are needed. Classify each blocking finding as
   `execution-miss`, `oracle-gap`, `planning-change`, `validation-gap`, or
   `integration-drift`. A `planning-change` pauses worker revision while the
   orchestrator repairs canonical planning.
   Posting review comments does not wake a finished worker. After every
   `changes requested` verdict is recorded on the PR, send an explicit follow-up
   to the originating worker through the active adapter. In Paseo, call
   `send_agent_prompt` with the retained agent ID and tell it to read the posted
   PR findings, repair only the in-bounds requested scope, validate, push, and
   notify on finish. If the original worker is unavailable, give the review to
   the operator for relay; do not silently create a replacement worker. A
   `planning-change` still returns to canonical planning before this follow-up.
   For a planning-delegate PR, replace card/implementation conformance with the
   planning-packet checks above. Requested changes still wake the originating
   delegate; accepted merge is followed by a separate orchestrator promotion
   batch.
12. **Merge and close out.** Before closeout, revisit the run's triage notes and
    give each one a clear disposition: promote or rework it into canonical docs,
    merge it with another note, keep it explicitly open, or remove it when it is
    implemented, superseded, or no longer useful. Ask the operator instead of
    guessing when the disposition is uncertain. Once the provider holds an
    accepted verdict for the exact current PR head, every required check passes,
    the PR is mergeable into the intended base, and no stricter repository rule
    or explicit operator pause applies, merge without asking for another
    approval. If the head changed after review, review it again. If merge state
    or the merge result is ambiguous, stop before retrying. Same-repository PRs
    merge one at a time: after each merge, refresh every remaining head against
    current `main`, re-review any head that changed or needed conflict
    resolution, and refill the freed capacity slot from the queued frontier.
    Then update card, milestone, log, front-door currentness, continuation/pause
    state, and the single next task. If the lane continues, identify the next
    ready card; if it ends, name the next planning checkpoint.

## Worker file contract

The orchestrator creates exactly one concrete worker handoff from the shared
handoff template per worker lane, commits it to `main`, pushes `main`, and
verifies the remote tip before dispatch. When independent roadmap lanes are
selected together on the ready frontier, create one such handoff per lane;
never merge multiple lane instructions into an ambiguous shared prompt. The
handoff records the planning base commit from before the handoff was created;
it must not contain a self-referential hash for the commit that contains the
handoff. An available
control plane may start each fresh worker thread in its managed worktree;
otherwise the operator starts it manually. The operator is always given the
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
- run
  `GIT_SSH_COMMAND="ssh -o ConnectTimeout=10 -o BatchMode=yes" git fetch origin`,
  confirm `HEAD == origin/main`, confirm the recorded planning base is an
  ancestor of `HEAD`, and confirm the repository-relative handoff exists in
  that `HEAD`. Load the tracked blob; if the absolute dispatch file differs,
  stop. The committed `HEAD` copy is canonical;
- after that check, verify each **required sibling worktree link** from the
  tracked handoff in the worktree container directory. For a launcher-managed
  worktree, require the lifecycle hook to have created it before project setup;
  stop if it is absent. For a manual fallback, canonicalize source and
  destination and create it when absent. In either lane, reuse only when an
  existing symlink resolves to the declared source. Stop on a mismatched
  symlink, directory, or file. Never delete, replace, or overwrite. If a listed
  source is missing, stop and report. Do not skip a required catalog member. If
  the list is `none`, skip this step;
- continue from the tracked handoff; all canonical refs and instructions needed
  for the run are named inside it;
- execute only the ordered ready cards;
- when sibling frontier lanes are running, write only inside the surfaces this
  lane owns, leave partitioned or integration-reserved closeout surfaces to
  their named owner, and stop and report any shared mutable scope or hidden
  dependency instead of resolving it. If a sibling lane merges first, refresh
  this branch against current `main`, revalidate, and expect another review of
  the changed head;
- when a card assigns a reported issue fix, own the full reproduce, diagnose,
  implement, clean up temporary diagnostics, validate, and evidence loop. Use
  ordinary causal and code-level judgment inside the card's boundaries; do not
  stop after diagnostics or open a diagnostics-only PR;
- report meaningful chunks through the active control plane or the operator with
  changed files, validation, remaining cards, and blockers;
- stop on missing contracts, ambiguous intent, scope expansion, or validation
  failure that changes the plan;
- update execution evidence and closeout surfaces as required by the cards;
- before PR creation or revision, try to falsify the diff: enumerate universal,
  exact, and negative claims, exercise each review-oracle counterexample, map it
  to proof, and reconcile card, roadmap, log, handoff, and front-door state;
- return a newly discovered product threshold, contract choice, or acceptance
  rule to planning instead of choosing it in implementation;
- finish the assigned runway with a pushed branch and a reviewable PR;
- do not merge or invent a new architecture; merge belongs to the orchestrator
  after its accepted review/check gate.

The only external worker handoff is the absolute path, for example:

```text
Read and follow `/Users/tom/Dev/projects/soundcheck/docs/handoffs/20260816-143500-soundcheck-worker.md`.
```

## Parallel lane dispatch

Parallelism is a scheduling default. Refresh the ready frontier while compiling
a runway and again at every dispatch checkpoint, across the active project and
any operator-approved portfolio work already in scope.

A lane joins the frontier only when all of these hold:

- no shared mutable files or overlapping write scope;
- no ordering, data, or generated-artifact dependency;
- no overlapping authority decision or unresolved intent;
- its own ready cards, acceptance, validation, evidence, and stop conditions;
- its own worktree, branch, and committed handoff.

Same-repository lanes must additionally partition their mutable and
closeout/front-door surfaces, or reserve one named orchestrator integration step
before launch. Two workers never own the same front door.

When a condition fails, keep only that edge or lane serial and name the exact
reason: the dependency edge, the shared surface, the unresolved authority, or
the capacity limit. Do not serialize unrelated ready work around one blocked
edge. Do not manufacture parallelism by inventing speculative cards or by
splitting one coherent issue-fix lane into diagnosis and repair workers.

Available capacity is whatever the active control plane actually offers. With no
control plane, publish a handoff per selected lane and give the operator every
absolute path at once; their launch throughput is the real limit. Never encode a
fixed worker count, provider, model, or profile name.

When capacity is smaller than the frontier, roadmap priority picks the first
lanes and the rest stay queued. Refill each freed slot from that queue as soon
as a worker finishes. While workers run, keep doing non-overlapping planning,
review, revision routing, merge, and closeout rather than idling on one lane.

Each parallel worker follows the same startup worktree-safety, PR, review-comment
fallback, and accepted-review/check-gated merge protocol independently.
Same-repository PRs merge one at a time; step 12 covers the refresh and
re-review of the remaining heads.

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
- operator-facing planning delegate: frontier conversational-planning profile,
  high reasoning; an explicitly named profile wins;
- exact mechanical documentation projection: fast/low-cost profile, low or
  medium reasoning, with the orchestrator retaining semantic review;
- bounded, mechanically direct worker: capable coding model, medium reasoning;
- reconnaissance and log reduction: fast model or deterministic command;
- security, persistence, concurrency, public API, deployment, multi-version, or
  ambiguous work: frontier worker with high reasoning and frontier review;
  pause before dispatch when the review oracle is not explicit.

Provider-native worktrees, subagents, session messaging, JSON output, and PR
commands are optional adapters. When an adapter exposes profiles, list them and
read their current notes at dispatch time; do not store local profile names in
Northstar. Adapter identities and messages are transport metadata, not planning
or completion authority. The protocol remains valid with manual worktree
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
- the current PR head lacks an accepted orchestrator verdict, required checks
  are not passing, mergeability or target base is unclear, a stricter repository
  rule requires human action, or the operator explicitly paused merge;
- a manual worktree is needed but the local path contract has not been satisfied;
- control-plane launch state is ambiguous enough that retrying could create a
  duplicate workspace or worker;
- an implementation worker or ordinary subagent would need to start a nested
  orchestrator or worker lane. A planning delegate may use only the bounded
  read-only research subagents defined above.

## Checkpoint shape

When a summary is useful, lead it with:

1. what is now true;
2. current state (`discovery`, `planning`, `planning-delegate-in-flight`,
   `planning-pr-awaiting-review`, `planning-promotion`, `ready-to-launch`,
   `worker-in-flight`, `awaiting-review`, `changes-requested`, `merged`, or
   `paused`);
3. the next operator action or information needed.

Keep protocol detail underneath that summary. The orchestrator is successful
only when the worker's implementation is represented by a reviewable PR and the
Northstar planning/log surfaces reflect the actual outcome. Do not force the
checkpoint shape into ordinary exploratory conversation.
