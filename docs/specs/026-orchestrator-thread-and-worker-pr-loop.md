# 026 - Orchestrator Thread And Worker PR Loop

Status: active
Owner: repo maintainers
Created: 2026-08-16
Updated: 2026-09-01
Related research: `bundle-docs/research/translation-memos/northstar-orchestrator-thread.md`
Governing architecture: `docs/architecture/system-architecture.md`
Governing contracts: `docs/contracts/001-working-rules.md`, `docs/contracts/002-agent-local-paths.md`

## Problem

Northstar can plan a strict runway and can continue through ready cards, but it
does not yet define the most useful split for current coding agents:

- a conversational orchestrator thread that asks questions, explores edges,
  settles intent, maintains the planning runway, and reviews delivery;
- a fresh worker thread that receives a durable file-based brief, works in its
  own worktree, reports bounded chunks through an optional control plane or the
  operator, and creates a PR;
- an explicit review loop that ends in approval/merge or precise requested
  changes.

The orchestrator is deliberately a human conversational surface, not a status
dashboard. It should make room for creative exploration, tentative ideas,
recommendations, and easy redirection while keeping scope, authority, and
evidence boundaries explicit.

## Target operating model

The operator starts or resumes one Northstar `orchestrator` mode in the planning
checkout. The orchestrator owns discovery, planning, architecture/contracts,
roadmap readiness, launch preparation, and PR review. It does not implement the
feature in the planning checkout once the worker boundary is declared.

On explicit operator request, the orchestrator may split one named discovery
topic into a frontier planning delegate while it continues unrelated work. The
delegate receives a committed handoff, talks directly with the operator in its
own thread, and writes only a bounded triage/research packet on an isolated
branch. It may coordinate read-only research subagents, then opens a planning PR.
The orchestrator reviews and merges that packet and separately promotes settled
meaning against current `main`; the packet never becomes execution authority by
merge alone.

On a separate explicit request, the orchestrator may transfer its whole current
lane to a fresh orchestrator thread. It first closes the repository state and
writes one committed continuation handoff using the normal seven-section
handoff shape. The successor owns the same planning/review lane; the source
stops mutating that lane after launch. This is neither worker mode nor a
planning delegate, and it does not create an implementation worktree or PR.

For each approved independent lane, the orchestrator uses a control-plane
adapter when the current thread exposes its orchestration tools, or gives the
operator the handoff path for manual launch. Injected Paseo tools are the
runtime authorization signal; a repository `paseo.json` alone is not. Either
route creates a fresh worker thread in a
dedicated worktree from pushed `main`. When the harness creates that worktree
before the worker starts, the current launch context is authoritative
even if the harness-generated path or branch differs from a handoff placeholder;
the worker reuses it rather than creating a second worktree. The orchestrator has
already committed and pushed the planning artifacts and one concrete worker
handoff under `docs/handoffs/` per worker. The worker receives the absolute path to that
handoff; the file contains the complete worker instructions, canonical
references, and required sibling worktree links. The worker owns only the ready cards
named in that file. At startup, it quickly verifies that its current context is
a clean, dedicated, non-`main` registered worktree. If the harness did not
provide one, or the context is `main`, dirty, unregistered, or otherwise
unusable, the worker first considers the named handoff worktree, then reads
`.agents.local.env` and requires `AGENTS_WORKTREE_CONTAINER_DIR` before
creating a unique manual worktree and branch from pushed `origin/main`, records
that resolved path, and continues only there without cleaning or discarding the
original checkout. A dirty or `main` harness checkout is reported, not silently
duplicated. It can execute several bounded cards in one thread, reports
after each meaningful chunk, updates execution evidence, and stops whenever the
contract says planning or operator intent is required. When the assigned runway
is complete, it opens a PR against the prepared base and returns the URL plus
evidence.

Worker reports and the PR URL return through the active control plane when
it supports direct parent/child messaging; otherwise the operator relays them.
The orchestrator reviews the exact diff and checks against the canonical refs, then
records one of these evidence-backed outcomes in the hosting provider's review
surface: ready for merge, changes requested with line-specific or card-specific
comments, or pause with a named planning gap. When the orchestrator and worker
use the same GitHub identity, GitHub blocks formal self-approval; the
orchestrator must post the verdict as a PR comment instead. A review comment is
canonical review evidence in that case. An accepted orchestrator verdict plus
passing required checks authorizes merge of that lane's current reviewed PR head
without another operator prompt.

For a reported defect, the orchestrator dispatches the whole outcome rather
than a diagnostic phase. The worker owns reproduction, causal investigation,
temporary instrumentation when useful, the smallest complete contract-valid repair,
cleanup, validation, evidence, and PR creation inside the named boundaries. The
handoff does not need to guess the root cause or exact edit before launch. A
diagnostics-only outcome is valid only when the operator asked for evidence
without a fix, or when a named authority, access, planning, or safety blocker
makes implementation unsafe or impossible inside the lane.

A fresh thread asked only to review an existing PR enters the same review
boundary directly. It does not reconstruct or take ownership of the surrounding
orchestrator/worker lane. The explicit review request authorizes posting the
review on the named PR, and every merge-blocking finding must be posted there
before chat summarizes the result.

## Goals

- Keep exploratory conversation and implementation context separate while making
  the orchestrator thread natural, creative, and easy to converse with.
- Make the worker handoff a single committed, pushed, self-contained file path.
- Reuse existing Northstar specs, roadmaps, batch cards, logs, and handoff rules.
- Make worktree, branch, PR, review, stop, and merge boundaries explicit.
- Give fresh direct-review threads a small route that publishes required changes
  on the PR instead of leaving them only in chat.
- Route model effort by role and risk without hard-coding provider model IDs.
- Preserve a provider-neutral protocol while allowing Codex, Claude Code, or
  OpenCode adapters.
- Use an available control plane automatically for profile selection, worktree
  placement, notifications, and follow-ups without making it protocol authority.
- Keep frontier reasoning on discovery, planning, review, and merge while a
  fast/low-cost subagent handles bounded mechanical documentation projection.
- Let an operator-requested frontier planning delegate explore one topic in a
  separate conversation while the orchestrator continues non-overlapping work.
- Let an operator-requested successor orchestrator continue the whole live lane
  from one durable handoff without sharing mutation authority with the source.
- Make parallel scheduling the orchestrator default: plan a dependency frontier
  and launch every safe ready lane without treating provider availability as a
  global worker limit or waiting for the operator to ask again.

## Non-goals

- requiring automatic cross-session messaging or one named control plane;
- requiring sidebar pin/reorder support or automating the Paseo UI when it is
  absent;
- a second public Northstar skill;
- parallel workers with shared mutable scope, unresolved authority, or hidden
  ordering/data/generated-artifact dependencies;
- splitting one coherent issue-fix lane into separate diagnosis and repair PRs
  merely to increase worker count;
- automatic merge before an accepted review of the current head and passing
  required checks;
- replacing Effigy, Git, or the hosting provider's PR system;
- a universal provider-specific command wrapper.
- treating a planning-packet merge as canonical promotion or implementation
  readiness.

## Roles and authority

| Role | Owns | Must not assume |
| --- | --- | --- |
| Operator | answers unresolved questions, may override the selected worker profile, starts or relays manual runs, resolves material permission requests, and may pause or override a merge | that one thread can see another thread's private history |
| Orchestrator | discovery, intent summary, promoted planning, ready runway, per-worker handoff, optional adapter dispatch, PR review verdict, gated merge, closeout | that a worker's narrative or control-plane state substitutes for repository/diff/check evidence |
| Planning delegate | direct operator discovery for one named topic, bounded triage/research capture, read-only research coordination, commits, and planning PR | canonical promotion, readiness, implementation, merge, or authority outside its handoff |
| Documentation projection subagent | mechanically materializes an exact orchestrator brief into named docs and deterministic validation | planning choices, semantic promotion, readiness/completion judgment, code edits, commit/push, review, or merge |
| Worker | bounded diagnosis and implementation in its worktree, card execution, tests, commits, evidence, PR creation | new architecture, missing contracts, or scope expansion |

## Documentation projection

The orchestrator may use a fast, low-cost profile for a meaningful mechanical
documentation batch after it has finished the relevant planning. This is a
serial subagent operation in the planning context, not a worker lane. It does
not use the worker handoff, create another worktree, or gain implementation
authority.

The orchestrator supplies an exact projection brief containing:

- authority owner and settled decisions;
- canonical refs and allowed paths;
- exact facts, evidence, and required state transitions;
- forbidden judgments, validation, and stop conditions.

The subagent may update named roadmap, card, log, front-door, index, handoff,
template, parity, and evidence surfaces. It stops on a missing choice,
contradiction, unlisted path, or validation result that needs interpretation. It
does not invent wording that changes meaning, choose canonical ownership, add
acceptance/stop/review-oracle policy, decide ready/complete/next state, edit
product code, commit, push, review, or merge.

Before dispatch, the orchestrator records dirty state and the allowed path set.
After return, it reviews the complete diff for semantic fidelity and owns every
Git mutation. Use this split for roughly three or more related projection
surfaces, or another batch large enough to repay dispatch and review overhead;
keep smaller edits in the orchestrator.

## Conversational planning delegation

The lane starts only when the operator asks the orchestrator to spin off a
planning conversation for a named topic. The orchestrator writes
`skills/northstar/assets/templates/northstar-discovery-delegate.md.template` to
one concrete committed handoff under `docs/handoffs/`. Its frontmatter declares
`handoff_mode: planning-delegate`,
`planning_mode: conversational-discovery`,
`dispatch_authority: orchestrator`, and
`promotion_authority: orchestrator`. This is not worker-mode activation.

The handoff fixes the topic, base SHA, canonical context, isolated branch and
worktree, allowed triage/research paths, opening questions, research boundary,
required sibling links or `none`, non-goals, current non-overlapping
orchestrator work, validation, stop conditions, and PR contract. The delegate
receives only the absolute handoff path as its initial prompt and then converses
directly with the operator. It captures operator-confirmed decisions,
recommendations, alternatives, evidence, non-goals, and unresolved questions
distinctly.

The delegate may spawn bounded read-only research subagents or advisors. They
return sourced findings to the delegate and do not edit the repository, create
worktrees/branches/PRs, contact the operator, or start nested orchestrator or
implementation lanes. The delegate reconciles their results into the named
packet. Its own branch diff contains only those named `docs/triage/` and optional
`docs/research/` paths. It does not edit code or canonical planning, choose
promotion destinations, decide readiness, or dispatch implementation.

The orchestrator reserves the topic while the delegate runs. It may continue
only work that neither depends on the topic nor mutates the packet paths. The
planning PR is reviewed at its exact head for scope, evidence, conversational
fidelity to the handoff and recorded operator confirmations, and clear
separation between confirmed decisions, recommendations, and open questions. If
decision ownership remains unclear, the orchestrator asks the operator rather
than relying on private thread history. Requested changes return to the same
delegate. Accepted review plus passing checks and mergeability permits
orchestrator merge without another approval prompt unless a stricter rule or
explicit pause applies.

After merge, the orchestrator re-reads the packet against current `main`,
resolves drift or contradictory operator decisions, selects canonical homes,
promotes settled meaning, and removes or splits resolved triage material. Only
that separate promotion batch may update architecture, contracts, specs,
roadmaps, cards, or readiness. Mechanical documentation projection may apply an
already-settled promotion map; it cannot choose the map.

## Fresh orchestrator continuation

This path starts only when the operator explicitly asks the current
orchestrator to hand its live lane to a fresh orchestrator thread. It is an
ownership transfer, not a way to multiply planners over one repository state.

The source orchestrator uses the normal handoff template and adds:

```yaml
handoff_mode: orchestrator-continuation
orchestrator_mode: planning-and-review
dispatch_authority: orchestrator
```

The handoff records the current authority chain, open operator questions,
active and paused lanes, ready frontier, worker and PR transport identities,
review/merge state, touched triage notes, repository state, and the next
orchestrator action. Before automatic dispatch, the source reconciles the live
card, roadmap, log, handoff, and front doors, commits and pushes that coherent
state, and verifies the remote tip. It then stops planning, dispatch, review,
merge, and closeout mutations for the transferred lane. It remains available
for explicit clarification but does not compete with the successor.

The successor receives only `Read and follow <absolute-handoff-path>.` It reads
the committed handoff, enters normal orchestrator mode, reloads current
repository authority, and checks that the recorded state still matches current
`main`. It does not activate worker mode, run the worker worktree preflight, or
inherit private conversation as authority.

When Paseo tools are injected, the source:

1. resolves its current project and repository checkout without guessing an
   ambiguous workspace;
2. lists current profiles and selects one whose notes cover orchestrator
   planning, operator conversation, dispatch, and review, unless the operator
   named a profile;
3. creates a separate `local` workspace for that same project and checkout;
4. creates the successor agent there with the capitalized label
   `Orchestrator=true`, copied profile settings, finish notifications enabled,
   and the single absolute-handoff prompt;
5. retains and reports both returned identities without polling or duplicate
   retry.

Paseo workspace pin order is optional display state. If the injected adapter or
CLI explicitly exposes a native pin/reorder operation, the source may place the
successor beside its own workspace. When no such operation exists, it says the
new workspace is ready and asks the operator to pin/place it manually. It must
not use browser control, computer use, Chrome control, plugin code, or another
UI automation route to simulate unsupported pinning.

Without Paseo, the source returns the absolute handoff path for manual launch.
The transfer never archives, deletes, kills, or unpins the source workspace or
thread automatically.

## Parallel lane dispatch

Parallelism is a planning and scheduling default, not an operator-requested
optimization. While compiling or refreshing a runway, the orchestrator maps the
meaningful lanes as a dependency graph and identifies the current ready
frontier. Before every dispatch checkpoint it refreshes that frontier across
the active project and any operator-approved portfolio work already in scope.

The orchestrator launches every safe ready-frontier lane. It does not merely
offer parallel prompts, wait for the operator to ask for concurrency, impose a
global thread count, or wait for another worker to finish before creating a new
thread. A control-plane workspace or agent creation failure belongs to that
lane's transport state; preserve every returned workspace or agent identity so
an ambiguous attempt is not duplicated, then continue launching unrelated
lanes whose transport state is clear.

A provider, model, or profile quota, spend, rate, or availability failure is
not a control-plane capacity signal. Mark only that route unavailable for the
attempt and try another configured profile whose current notes fit the same
worker role and capability. Do not promote an ordinary lane to frontier merely
because its day-to-day route is unavailable. If no suitable route remains,
pause only that lane, preserve its committed handoff and workspace state, report
the provider/profile gap, and continue every unrelated ready lane. Recovery
reuses the retained authority chain; it does not create a duplicate worker or
require a rebrief.

When no control plane is available, publish one committed handoff per selected
lane and give the operator every absolute path together. While workers run, the
orchestrator continues non-overlapping planning, dispatch, review, revision
routing, merge, and closeout work instead of idling on one lane.

A lane belongs on the parallel frontier only when all of the following hold:

- lanes have no shared mutable files or overlapping write scope;
- lanes have no ordering, data, or generated-artifact dependencies;
- lanes do not contain overlapping authority decisions or unresolved intent;
- each lane has its own ready cards, acceptance, validation, evidence, and stop
  conditions;
- each worker can use its own worktree, branch, and committed handoff.

For same-repository lanes, the plan must also partition closeout/currentness
surfaces or reserve one named orchestrator integration step; two workers must
not both own the same front door. If any condition fails, keep only that edge or
lane serial and record the exact dependency, shared surface, or ambiguity. A
  provider/profile availability failure is lane-local and must not serialize
  unrelated ready work.

Parallelism is not a reason to split an unclear lane or turn one outcome-scoped
defect into diagnostic and repair workers. Each parallel worker follows the same
startup worktree-safety, PR, review-comment fallback, and accepted-review/check-
gated merge protocol independently. Same-repository PRs merge one at a time;
after each merge the orchestrator refreshes the remaining heads against current
`main` and re-reviews any changed or conflict-resolved head.

## State model

Use these states in the worker handoff or log when the run spans turns:

- `discovery` — questions and edge cases are still being surfaced;
- `planning` — spec/architecture/contracts/roadmap are being aligned;
- `planning-delegate-in-flight` — the operator and delegate are exploring one
  reserved topic in the isolated planning branch;
- `planning-pr-awaiting-review` — the bounded triage/research packet is in a PR;
- `planning-promotion` — the packet is merged and the orchestrator is
  reconciling/promoting it against current `main`;
- `ready-to-launch` — base and cards are ready; the worker-handoff path can be
  handed to a worker;
- `worker-in-flight` — worker is executing the assigned runway;
- `awaiting-review` — worker has opened a PR and returned evidence;
- `changes-requested` — orchestrator review found required fixes;
- `merged` — PR is merged and Northstar closeout is complete;
- `paused` — a named stop condition, planning gap, or operator decision blocks work.

## Dispatch protocol

The orchestrator/worker boundary is a strict sequence:

1. finish discovery and promote the spec, architecture, contract, and ready cards;
2. build or refresh the ready dependency frontier, select every independent
   lane that should launch after publication, and record why
   any otherwise-ready lane stays queued or serial; keep one
   worktree/branch/handoff plan per selected worker lane;
3. put the planning checkout on `main` and remove unrelated changes;
4. run required QA;
5. commit all planning and roadmap artifacts to `main`; this is the planning
   base recorded in each handoff as `BASE_REF`;
6. create one concrete worker handoff from
   `skills/northstar/assets/templates/northstar-orchestrator-run.md.template`
   under `docs/handoffs/YYYYMMDD-HHMMSS-<slug>.md` per approved worker lane;
7. commit the handoff set to `main`, push `main`, and verify local `HEAD` equals
   `origin/main`;
8. set `handoff_mode: worker-pr-loop`, `worker_mode: implementation`, and
   `dispatch_authority: orchestrator` in each handoff. These fields explicitly
   activate worker mode; normal-mode agents and the orchestrator do not run the
   worker worktree preflight. Then record the intended worker branch/worktree in
   each handoff. Let the launch
   harness create the worktree when it owns the worker start; create a manual
   worktree only when no harness-provided worktree exists and the local-path
   contract is satisfied. Do not try to include any handoff commit's own SHA in
   its handoff file; that would be self-referential because changing the file
   changes the commit SHA;
9. give the operator each worker's handoff as an absolute path, and list
   required sibling worktree links (or `none`) inside the file;
10. when the current thread exposes the required control-plane orchestration
    tools, use that adapter without another permission prompt to create the
    isolated workspace and worker. Otherwise stop at `ready-to-launch` and use
    manual dispatch. Do not use `paseo.json` alone as the runtime signal.

## Optional control-plane adapter

The adapter changes transport, not authority. The committed worker handoff,
canonical repository state, branch, PR, checks, and provider review record stay
authoritative.

When Paseo tools are injected into the current orchestrator thread, the
orchestrator uses them automatically for a ready lane:

1. lists configured agent profiles and reads every profile's notes; it selects
   by the Northstar role/risk profile and never hard-codes a local profile name,
   unless the operator explicitly named a profile for that lane;
2. creates one Paseo worktree workspace per worker with `branch-off` isolation
   from `origin/main`, using the lane's intended branch and source checkout;
3. verifies every handoff-declared sibling checkout is symlinked into the
   managed worktree's container directory before project bootstrap needs it;
   it stops on a missing source, wrong symlink, or conflicting path;
4. creates the worker in that workspace with finish notification enabled and
   the single initial prompt `Read and follow <absolute-handoff-path>.`;
5. retains the returned agent and workspace IDs as lane transport state;
6. trusts the finish/permission notification instead of polling, reconciles the
   returned report with canonical state, and uses a follow-up prompt on the same
   agent for bounded continuation or requested changes;
7. returns permission requests to the operator unless existing explicit
   authority already settles the exact action.

For an operator-requested planning delegate, use the same injected-tool signal
without another permission prompt, but select a frontier conversational-
planning profile and create a dedicated `branch-off` worktree workspace. The
operator converses with that new agent directly. Verify handoff-named sibling
links in the workspace container before launch. Retain its agent/workspace IDs,
trust notifications rather than polling, and use the same agent for requested
planning-PR revisions. Sol may be an explicitly selected local profile; it is
not a stored Northstar model dependency.

Do not use a generic task-handoff skill, including `/paseo-handoff`, for a
Northstar worker or planning-delegate dispatch. Such a skill generates a second
briefing and would compete with the committed Northstar handoff. Use the base
workspace and agent tools directly. Tool injection authorizes transport only:
it does not
independently authorize unready work, missing product or contract choices,
material permission requests, destructive workspace archival or cleanup,
review, merge, or a duplicate retry. Merge authority comes from the active
orchestrator lane after its review/check gate, not from the adapter.
If required tools are absent or setup fails before launch, preserve any created
workspace identity, report the exact state, and fall back to the manual
absolute-path handoff without creating a second worker silently.

The worker must not require a separately copied prompt, transcript, or list of
canonical refs. The handoff may point at canonical repository files, but it is
the only external handoff artifact. After reading a handoff with the explicit
worker-mode metadata, and before broad repo reads or editing, the worker runs one
quick startup worktree-safety preflight. If the current root is a
registered worktree, `git status --porcelain` is empty, and the branch is not
`main`, it reuses that launcher-provided worktree regardless of generated path or
branch-name differences from the handoff, records the actual path and branch, and
does not create another. Otherwise it considers the named worktree, then reads
`.agents.local.env`, requires `AGENTS_WORKTREE_CONTAINER_DIR`, and creates a
unique manual worktree and branch under that container from pushed `origin/main`,
records the actual path and branch, and continues only there. A dirty original
checkout is never cleaned, reset, or discarded; a dirty or `main` launcher
checkout is reported rather than duplicated. From the selected worktree, the worker then
confirms `HEAD == origin/main`, the recorded planning base is an ancestor of
`HEAD`, and the repository-relative handoff exists in that `HEAD`. The
tracked blob is canonical; if the absolute dispatch file differs, the worker
stops. Only then does it create required sibling links (create when
absent, reuse a correct symlink, stop on conflict, never overwrite).

## Required per-worker handoff

The orchestrator must create one concrete worker handoff from
`skills/northstar/assets/templates/northstar-orchestrator-run.md.template` before
each worker starts. Parallel lanes therefore receive separate handoff files;
workers must not share an ambiguous combined brief. Each handoff must preserve
the seven core handoff sections, add the worker/PR flow inside
`## Completion Protocol`, be committed to `main`, pushed, and verified against
`origin/main`. Each worker is dispatched with that file's absolute path.

The file must contain or point to all information required for execution. Its
frontmatter must include `handoff_mode: worker-pr-loop`,
`worker_mode: implementation`, and `dispatch_authority: orchestrator`:

- planning base commit, remote-tip verification, worker branch, and worktree command;
- required sibling worktree links (absolute primary-checkout sources and the
  link name in the worktree container directory) or `none`;
- startup worktree-safety preflight and local-path manual-worktree instructions;
- active vision/architecture/contract refs;
- active master spec and roadmap milestone;
- ordered ready batch cards and allowed runway length;
- acceptance, validation, evidence, and stop conditions;
- worker model capability profile and tool restrictions;
- chunk-reporting cadence and operator relay rule;
- PR base/head requirements and expected PR body contents;
- explicit out-of-scope boundaries.
- for an issue fix, the observed failure, expected behavior, reproduction or
  acceptance evidence, and authority for the worker to diagnose and implement
  the smallest complete in-bounds repair without a second dispatch.

The handoff is a dispatch overlay, not a second execution authority. It names
the cards, review-oracle refs, dispatch state, runtime boundaries, and PR
contract; it does not copy full card steps, acceptance prose, or general
doctrine. Completeness comes from a committed, resolvable authority chain plus
the dispatch-specific state.

## Worker protocol

1. Read the supplied handoff path first (absolute; a relative path is
   valid only once the current root is the owning repo) and verify its
   worker-mode metadata. Only then, before broad repo reads, run the startup
   worktree-safety preflight: identify the repository
   root, current worktree, branch, and `git status --porcelain`.
2. If the current context is a clean, dedicated, non-`main` registered worktree,
   use it as the harness-provided worktree even when its generated path or branch
   differs from the handoff; record the actual path/branch and do not create
   another. Only if it is `main`, dirty, unregistered, or otherwise unusable may
   the worker consider the named worktree and then create a manual worktree and
   branch from pushed `origin/main`. Never clean, reset, or discard a dirty
   checkout; report a dirty or `main` launcher checkout instead of duplicating it.
3. From the selected worktree, confirm `HEAD == origin/main`, the recorded
   planning base is an ancestor of `HEAD`, and the repository-relative handoff
   exists in that `HEAD`. Load the tracked blob; stop if the absolute dispatch
   file differs. That `HEAD` copy is canonical. Only then verify each required
   sibling link in the worktree container directory. In a launcher-managed
   worktree it must already exist before project setup; stop if it is absent.
   In a manual fallback, canonicalize source and destination and create it when
   absent. Reuse only a symlink that already resolves to the declared source;
   stop on any other existing path; never delete, replace, or overwrite. Skip
   sibling setup when the list is `none`.
4. Read the active milestone, every assigned card, and governing refs.
5. Run the repo's cheap orientation and relevant graph/query commands before code
   changes.
6. Execute only ready cards in the stated order. For an issue-fix card, continue
   from reproduction and diagnosis into the smallest complete in-bounds repair; temporary
   diagnostics are not completion. Keep commits and reports aligned to
   meaningful chunks, not arbitrary model turns.
7. After each chunk, report changed surfaces, validation, remaining cards, and
   blockers for the operator to relay. Do not require live agent-to-agent access.
8. Stop on a planning gap, contract contradiction, unresolved product choice,
   failed validation that changes the plan, missing authority/access, or scope
   expansion. Record the stop in the card/log state.
9. When the assigned runway is complete, run the required final checks, then
   perform an adversarial pre-PR pass. Enumerate universal, exact, and negative
   claims; try every named counterexample; map each review-oracle row to proof;
   and reconcile card, roadmap, log, handoff, and front-door state. Return a new
   product threshold, contract choice, or acceptance rule to planning.
10. Update evidence and closeout surfaces, push the selected branch, and create
    a PR. Do not merge.

## Review protocol

The orchestrator, or a fresh thread using direct PR-review mode, must review
from the PR and canonical refs, not only from the worker's report:

1. inspect PR metadata, commits, changed files, and checks;
2. compare implementation to the active spec, milestone, cards, and contracts;
3. check that out-of-scope files, hidden planning decisions, and missing tests are
   not smuggled into the diff;
4. run or inspect the relevant validation independently where practical;
5. classify every merge-blocking finding as `execution-miss`, `oracle-gap`,
   `planning-change`, `validation-gap`, or `integration-drift`; return a
   `planning-change` to canonical planning before asking the worker to revise;
6. record an evidence-backed verdict in the hosting provider's review surface,
   with every merge-blocking finding posted there rather than only in chat;
   when formal approval is unavailable because the orchestrator and worker share
   a GitHub identity, post a canonical `Changes required` PR comment for blocking
   findings and treat that comment as the review record;
7. if the exact reviewed head is still current, every required check passes, the
   PR is mergeable into its intended base, and no stricter repository rule or
   explicit operator pause applies, merge without another operator prompt;
8. after merge, update roadmap/card/log/currentness surfaces and identify the next
   planning or execution move.

If changes are requested, posting the provider review is necessary but does not
wake a finished worker. After the findings are on the PR, the orchestrator sends
an explicit follow-up to the originating worker branch/thread through the active
adapter. With Paseo it uses `send_agent_prompt` and the retained agent ID. The
follow-up tells the worker to read the posted findings, fix only the requested
scope, validate, push, and report again. The operator relays the same instruction
in a manual run. Do not silently create a replacement when the originating
worker is unavailable. A `planning-change` returns to canonical planning before
implementation resumes; otherwise the orchestrator repeats review after the
worker pushes.

## Model and runtime policy

Model IDs are runtime configuration, not Northstar contract values. Select by
current role-profile notes. Worker routing is economical by default: choose a
non-frontier profile whose notes cover ordinary day-to-day implementation,
bounded audits, or mechanical work before considering a frontier worker. Task
size, file count, duration, or the bare presence of a security, persistence,
concurrency, public-API, deployment, or multi-version surface does not by itself
make a worker lane frontier work.

Select by capability:

- frontier/high effort for the orchestrator and material review;
- frontier/high effort for an operator-facing planning delegate;
- fast/low-cost for exact mechanical documentation projection after the
  orchestrator settles meaning;
- capable/medium effort for bounded, mechanically direct implementation;
- fast/low effort for read-only reconnaissance and log reduction;
- fast/low-cost or mechanically oriented profiles for long audits, broad
  documentation work, and other token-heavy jobs whose decisions and repair
  boundaries are already settled;
- frontier/high effort for an implementation worker only when the lane is both
  highest-priority or materially consequential **and** exceptionally difficult
  to reason through after planning, and the selected profile's notes explicitly
  fit that combination. Record both reasons in the handoff. Priority alone,
  complexity alone, broad scope, or a risk-domain label is insufficient.

Risky surfaces still require a clear review oracle and frontier review. When
multiple plausible designs or an unresolved contract choice remain, return to
planning rather than spending a frontier worker to choose architecture. If no
configured non-frontier profile fits an ordinary lane, report the profile gap
instead of silently promoting it to frontier. An operator-named profile remains
an explicit override.

Use deterministic Effigy, Git, test, diff, and PR-check commands for evidence.
Provider-native subagents, worktree managers, JSON output, resume, and PR helpers
are adapters that may improve ergonomics but must not change the protocol. When
an adapter exposes named profiles, select them from current notes at dispatch
time rather than storing profile or model names in Northstar.

## Validation strategy

The initial Northstar dogfood must prove:

- the worker handoff path can be handed to a fresh thread without private chat
  context;
- the worker remains in a clean dedicated worktree and branch, or safely creates a
  worktree under the operator-selected `AGENTS_WORKTREE_CONTAINER_DIR` from
  pushed `origin/main` when the harness context is not suitable;
- the worker never edits `main` or discards dirty state while selecting its
  worktree;
- the worker completes at least one bounded card and reports evidence;
- an issue-fix handoff carries diagnosis through implementation and does not
  close on temporary diagnostics or a root-cause report;
- the worker opens a reviewable PR against the prepared base;
- the orchestrator can find at least one real issue or explicitly record a clean
  review;
- the requested-changes loop or approval path is exercised;
- a planning delegate can converse directly with the operator, coordinate a
  read-only research subagent, open a triage/research-only PR, and leave
  promotion to the orchestrator after merge;
- an accepted exact-head review plus passing required checks reaches merge
  without another operator prompt;
- a changed head, explicit operator pause, stricter repository rule, or
  ambiguous merge state stops or re-enters review rather than merging blindly;
- roadmap, card, log, and next-task surfaces remain coherent after closeout.

Record elapsed time, worker rework, number of review cycles, finding reason
codes, validation outcome, and transport/relay burden. Raw cycle count does not
diagnose handoff quality. Do not generalise from one run without this evidence.

## Open questions

- What is the minimum provider-neutral PR metadata contract for non-GitHub hosts?
- Which provider permissions and branch-protection settings should consumer
  repositories require for orchestrator-owned merge?
- Which workspace cleanup actions, if any, should a control-plane adapter take
  automatically after merge?

These questions do not block the protocol shape; they block only adapter and
rollout defaults.

## Promotion notes

Durable role and boundary rules are promoted into the live architecture and
working-rules contract. This spec remains active until dogfood evidence settles
control-plane transport, workspace cleanup, and review-cycle ergonomics.

## Next task

Use the next real bounded lane as a Paseo-backed dogfood run when Paseo tools
are injected. Confirm that the adapter launches from the committed
handoff, preserves the manual fallback and authority chain, and reduces relay
burden without weakening review or merge gates.
