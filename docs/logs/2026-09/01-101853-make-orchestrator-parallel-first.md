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

Capacity stayed provider-neutral. It is whatever the active control plane
actually offers; with no control plane the orchestrator publishes one handoff per
selected lane and hands the operator every absolute path at once, so operator
launch throughput is the limit. No worker count, provider, model, profile name,
or scheduler daemon is encoded anywhere.

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
| `scripts/lib/northstar-repo-contract-data.rhai` | no parallel assertions | 13 new assertions across contract, doctrine, copy-ready contract, skill mode, and handoff template |

## Scenario matrix

| Scenario | Expected behavior | Where it is settled |
| --- | --- | --- |
| Two independent lanes in different repos | both launch up to capacity, no second operator prompt | working rules; doctrine 07; orchestrator step 6 and `## Parallel lane dispatch` |
| Lane B consumes lane A's artifact | B stays queued and the A -> B edge is named | frontier condition "no ordering, data, or generated-artifact dependency" plus the named-reason rule |
| Two same-repo cards both edit the generation README | partition the closeout surface or reserve a named orchestrator integration step before launch; handoffs record owned surfaces | same-repository clause in all four surfaces; handoff template `Surfaces this lane owns` / `Integration ownership` |
| Three lanes ready, capacity two, one worker finishes | roadmap priority picks the first two, the third stays queued, the freed slot refills immediately | capacity/refill paragraph; orchestrator step 12 refills after merge |
| A reported defect could be split into diagnosis and patch workers | reproduce-through-fix stays one outcome lane | "never a reason to … split one coherent issue-fix lane" plus the existing issue-fix dispatch boundary |
| One same-repo PR merges while a sibling PR is open | remaining heads refresh against current `main`; any changed head is reviewed again | orchestrator step 12; worker file contract; handoff template `Merge ordering` and PR step 4 |

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
