# Make Orchestrator Scheduling Parallel-First

Date: 2026-09-01
Roadmap: `g02.042`
Card: `g02.042/110`
Status: complete

## Result

Parallel dispatch is now the Northstar orchestrator's default schedule rather
than an offer. The orchestrator maps runway lanes as a dependency graph, keeps a
ready frontier refreshed at every dispatch checkpoint, and launches every safe
frontier lane up to available capacity without a second operator request. Queued
lanes refill each slot a finishing worker frees, and the orchestrator keeps doing
non-overlapping planning, review, revision routing, merge, and closeout while
workers run.

The safety boundaries stayed serial and explicit. A lane joins the frontier only
with no shared mutable scope, no ordering/data/generated-artifact dependency, no
overlapping authority, and its own cards, validation, evidence, stop conditions,
worktree, branch, and handoff. Same-repository lanes must partition their mutable
and closeout/front-door surfaces or reserve one named orchestrator integration
step. Any serial decision must name the dependency edge, shared surface,
unresolved authority, or capacity limit, and unrelated ready work is never
serialized around one blocked edge.

Capacity stayed provider-neutral and, after review, executable. It is an
explicit control-plane value when one is surfaced. When an adapter can launch
workers but exposes no capacity signal — as Paseo's profile, workspace, agent,
and list tools do not — the orchestrator attempts safe lanes in roadmap-priority
order and treats the first explicit launch refusal as that checkpoint's capacity:
created workspace and agent identities are preserved, the refused and remaining
lanes queue against that named adapter limit, and the retained lane state is
retried when a slot frees. With no control plane at all, it publishes one handoff
per selected lane and hands the operator every absolute path at once. No worker
count, provider, model, profile name, or scheduler daemon is encoded anywhere,
and the operator is never asked to guess a count.

Capacity refills at the worker-finish notification, not at merge. The next queued
lane starts before or alongside exact-head review of the finished lane's PR. The
post-merge same-repository head refresh is a separate rule.

## Changed surfaces

| Surface | Before | After |
| --- | --- | --- |
| `docs/specs/026-…md` | already parallel-first on the planning base | unchanged |
| `docs/architecture/system-architecture.md` | "Independent roadmap lanes **may** use parallel worker threads" | parallel-first topology, capacity source, named serial reasons, merge ordering |
| `docs/contracts/001-working-rules.md` | "assesses whether … lanes can run concurrently. Parallel dispatch is appropriate only when…" | parallel dispatch is the default schedule, with frontier conditions, partitioning, capacity, refill, and merge order |
| `bundle-docs/sections/07-…md` | no parallel-lane doctrine | new `## Parallel lane scheduling` |
| `template-bundle/contracts/001-working-rules-template.md` | no parallel dispatch clause | new `### Parallel lane scheduling` |
| `skills/northstar/references/modes/orchestrator.md` | step 6 "Assess parallel lanes … **Offer** parallel worker-thread prompts" | step 6 refreshes and dispatches the frontier; new `## Parallel lane dispatch`; steps 8, 9, 12 and the worker file contract carry lane ownership, capacity, and merge order |
| `skills/northstar/SKILL.md` | orchestrator outcome silent on scheduling | names parallel-first frontier dispatch and one handoff per launched lane |
| `skills/northstar/assets/templates/northstar-orchestrator-run.md.template` | `Dispatch topology` + `Parallel safety check` only | adds owned surfaces, integration ownership, merge ordering, concurrent-write boundary, and sibling-merge refresh step |
| `skills/northstar/references/handoff-contract.md` | no concurrency ownership in `Current State` | requires sibling lanes, owned surfaces, closeout partition or integration step, and serial reasons |
| `bundle-docs/operators/operator-quick-start.md` | parallelism unmentioned | operator does not have to ask; capacity, queueing, named serial reasons, merge order |
| `bundle-docs/protocol-kernel.md` | no canonical home row | new **Parallel lane scheduling and capacity** row |
| `scripts/lib/northstar-repo-contract-data.rhai` | no parallel assertions | 13 positive assertions plus 5 negative assertions that fail if any of the three inventoried permissive forms returns |
| `docs/logs/README.md` | recent-evidence window started at the prior Rust-evidence repair | this log added at the head of the bounded window |

## Scenario matrix (seven review-oracle rows)

| Scenario | Expected behavior | Where it is settled |
| --- | --- | --- |
| Two independent lanes in different repos | both launch up to capacity, no second operator prompt | working rules; doctrine 07; orchestrator step 6 and `## Parallel lane dispatch` |
| Lane B consumes lane A's artifact | B stays queued and the A -> B edge is named | frontier condition "no ordering, data, or generated-artifact dependency" plus the named-reason rule |
| Two same-repo cards both edit the generation README | partition the closeout surface or reserve a named orchestrator integration step before launch; handoffs record owned surfaces | same-repository clause in all four surfaces; handoff template `Surfaces this lane owns` / `Integration ownership` |
| Three lanes ready, capacity two, one worker finishes | roadmap priority picks the first two, the third stays queued, and the freed slot refills at the finish notification rather than at merge | capacity/refill paragraph in all four surfaces; orchestrator step 10 |
| Adapter can launch workers but surfaces no slot count | launch in priority order until an explicit refusal, preserve created lane state, queue the rest, retry when a finish frees a slot | orchestrator step 9 and `## Parallel lane dispatch`; working rules; doctrine 07; copy-ready contract; operator quick start |
| A reported defect could be split into diagnosis and patch workers | reproduce-through-fix stays one outcome lane | "never a reason to … split one coherent issue-fix lane" plus the existing issue-fix dispatch boundary |
| One same-repo PR merges while a sibling PR is open | remaining heads refresh against current `main`; any changed head is reviewed again | orchestrator step 12; worker file contract; handoff template `Merge ordering` and PR step 4 |

## Review revision

Exact-head review of `2a32da0` recorded four blocking findings; all four were
repaired on this branch after refreshing onto planning commit `da0cf50`.

- `planning-change` — capacity discovery was not executable on an adapter that
  exposes no capacity value. Spec 026 settled the fallback on `main`; the
  implementation now follows it in the skill mode, contract, architecture,
  doctrine, copy-ready contract, and operator guidance.
- `oracle-gap` — the 13 positive substring assertions still passed if step 6
  regressed to the old permissive wording. Five negative assertions now fail on
  the exact pre-change forms: `Offer parallel worker-thread prompts`,
  `Assess parallel lanes before dispatch`,
  `Parallel dispatch is appropriate only when`,
  `assesses whether multiple independent roadmap`, and
  `may use parallel worker threads`. Each was verified present at `24e4303` and
  absent now, so none is a vacuous guard.
- `execution-miss` — the numbered procedure only refilled capacity after merge.
  Step 10 now refills at the worker-finish notification; step 12 keeps only the
  post-merge same-repository head refresh.
- `integration-drift` — this log is now at the head of the bounded
  recent-evidence window in `docs/logs/README.md`.

The card's review-oracle pointer was also corrected from six to seven scenarios,
matching the row the planning commit added to milestone `g02.042`.

## Validation

- `effigy check:command-skills` — pass;
- `effigy check:skill-install` against an isolated rsync of `skills/northstar/`
  — pass, exact parity;
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- `git diff --check` — clean.

## Limitations

No live multi-worker dogfood was run. The behavior is documented protocol and
deterministic assertions, not an executed concurrent dispatch. No scheduler
implementation, worker-count default, provider binding, or Paseo product change
was added.

## Next

The orchestrator reviews the exact PR head, merges it, then chooses the next
`g02` milestone from the generation runway.
