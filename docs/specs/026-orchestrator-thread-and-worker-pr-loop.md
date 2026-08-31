# 026 - Orchestrator Thread And Worker PR Loop

Status: active
Owner: repo maintainers
Created: 2026-08-16
Updated: 2026-08-31
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
canonical review evidence in that case. Merge remains a separate,
operator-authorized action.

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

## Non-goals

- requiring automatic cross-session messaging or one named control plane;
- a second public Northstar skill;
- parallel write-heavy workers in one active lane;
- automatic merge without a review/check gate and operator authorisation;
- replacing Effigy, Git, or the hosting provider's PR system;
- a universal provider-specific command wrapper.

## Roles and authority

| Role | Owns | Must not assume |
| --- | --- | --- |
| Operator | answers unresolved questions, may override the selected worker profile, starts or relays manual runs, resolves material permission requests, grants merge authority | that one thread can see another thread's private history |
| Orchestrator | discovery, intent summary, promoted planning, ready runway, per-worker handoff, optional adapter dispatch, PR review verdict, closeout | that a worker's narrative or control-plane state substitutes for repository/diff/check evidence |
| Worker | bounded diagnosis and implementation in its worktree, card execution, tests, commits, evidence, PR creation | new architecture, missing contracts, or scope expansion |

## Parallel lane dispatch

Before preparing a worker, the orchestrator inspects the active roadmap runway
for multiple independent, bounded ready lanes that can run at the same time. It
should offer multiple worker-thread prompts when all of the following hold:

- lanes have no shared mutable files or overlapping write scope;
- lanes have no ordering, data, or generated-artifact dependencies;
- lanes do not contain overlapping authority decisions or unresolved intent;
- each lane has its own ready cards, acceptance, validation, evidence, and stop
  conditions;
- each worker can use its own worktree, branch, and committed handoff.

If any condition fails, keep the work serial and name the dependency or
ambiguity. Parallelism is an offered execution shape, not a reason to split an
unclear lane. Each parallel worker follows the same startup worktree-safety,
PR, review-comment fallback, and explicit operator-authorised merge protocol
independently.

## State model

Use these states in the worker handoff or log when the run spans turns:

- `discovery` — questions and edge cases are still being surfaced;
- `planning` — spec/architecture/contracts/roadmap are being aligned;
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
2. assess whether independent roadmap lanes can run in parallel; if so, keep one
   worktree/branch/handoff plan per lane;
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
3. creates the worker in that workspace with finish notification enabled and
   the single initial prompt `Read and follow <absolute-handoff-path>.`;
4. trusts the finish/permission notification instead of polling, reconciles the
   returned report with canonical state, and uses a follow-up prompt on the same
   agent for bounded continuation or requested changes;
5. returns permission requests to the operator unless existing explicit
   authority already settles the exact action.

Do not use a generic task-handoff skill, including `/paseo-handoff`, for a
Northstar worker dispatch. Such a skill generates a second briefing and would
compete with the committed Northstar handoff. Use the base workspace and agent
tools directly. Tool injection authorizes transport only: it does not authorize
unready work, missing product or contract choices, material permission requests,
destructive workspace archival or cleanup, review, merge, or a duplicate retry.
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
- required sibling worktree links (absolute primary-checkout sources and
  the link name beside the worktree) or `none`;
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
   file differs. That `HEAD` copy is canonical. Only then create each required
   sibling link: canonicalize source and destination; create when absent;
   reuse only a symlink that already resolves to the declared source; stop
   on any other existing path; never delete, replace, or overwrite. Skip
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
7. merge only when checks and review are satisfactory and the operator has
   authorised the merge action;
8. after merge, update roadmap/card/log/currentness surfaces and identify the next
   planning or execution move.

If changes are requested, the orchestrator sends the review to the same worker
branch/thread through the active adapter, or the operator relays it in a manual
run. The worker fixes only the requested scope, pushes again, and the
orchestrator repeats the review. A new worker thread is not required unless the
original worktree or branch is no longer usable.

## Model and runtime policy

Model IDs are runtime configuration, not Northstar contract values. Select by
capability:

- frontier/high effort for the orchestrator and material review;
- capable/medium effort for bounded, mechanically direct implementation;
- fast/low effort for read-only reconnaissance and log reduction;
- frontier/high effort for a worker card touching security, persistence,
  concurrency, public APIs, deployment, multi-version behavior, or multiple
  plausible designs; pause before dispatch when its review oracle is not explicit.

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
- roadmap, card, log, and next-task surfaces remain coherent after closeout.

Record elapsed time, worker rework, number of review cycles, finding reason
codes, validation outcome, and transport/relay burden. Raw cycle count does not
diagnose handoff quality. Do not generalise from one run without this evidence.

## Open questions

- What is the minimum provider-neutral PR metadata contract for non-GitHub hosts?
- Which merge permissions should be required in consumer repositories?
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
