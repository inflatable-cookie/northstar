# Roadmap Generation Index

Status: active
Updated: 2026-09-02

## Mode

- `sequential` (default)

## Active generation

- `g02`
- Generation runway: `g02/README.md`

## Generation log

| Generation | Started | Reason | Notes |
| --- | --- | --- | --- |
| `g01` | 2026-04-08 | Initial live Northstar-on-Northstar sequence | Establish the repo's own docs spine and pilot the delivery layer before promoting it into the reusable bundle and skills |
| `g02` | 2026-04-09 | Move from internal proof to external consumer-repo validation | Long-running external-proof and execution-hardening generation. Started with the first real consumer-repo pilot, then continues through operator simplification, stronger execution guardrails, and longer-autonomy improvement lanes |

## Rollover policy

Create a new generation when:

- the sequencing baseline itself materially changes
- the current generation has been fully closed out and a fresh boundary is now
  genuinely clearer for execution
- maintainers explicitly decide the queue needs a clean reset

Northstar generations should usually be substantial. The default expectation is
that one generation will cover many milestone files before rollover. As a
judgment guardrail, expect something closer to 20 to 50 milestones before
rollover is worth considering. Do not open `g03` just because `g02.001` closed
or because one pilot lane completed.

### Batch completion does not close the generation

Finishing a batch, suite, or lane of roadmaps does **not** mark the generation
as complete. The generation remains open until the rollover conditions above are
met. After closing one batch, compile or continue the next batch inside the same
generation. Do not treat the end of a planned sequence as a generation closeout
event.

Before opening the next generation in sequential mode:

- close, supersede, or rehome every milestone in the current generation
- refresh the roadmap front doors so the old generation is visibly closed
- purge stale specs from `docs/specs/` so the active specs tree
  no longer carries debris from the closing generation

If that cleanup has not happened, stay in the current generation and finish the
closeout there first.

### Parallel mode

Switch to `parallel` mode only when:
- genuinely independent work streams need separate generations without blocking
  each other
- each stream has distinct contracts, milestones, and lane context
- front doors can accurately track all active generations without collision

In parallel mode, each active generation operates as its own queue. Opening a
new generation does not require closing prior generations. Each generation's
`gNN/README.md` and milestone files remain the authoritative front door for
that thread.

## Runway rule

Each active generation's `gNN/README.md` owns its `## Generation Runway`: a
short, coarse goal list for the generation. Use it to choose the next milestone
when a lane closes instead of inventing a new direction from recent context.
Keep the runway stable between real strategy, milestone, or rollover changes.
It should be written for a significant generation, not a four-or-five-roadmap
sequence.

## Next Task

Roadmaps `g02.038` through `g02.047` are implemented. The
first-principles audit and closed dogfood cohort produced the structural
validation reduction, active-authority reconciliation, machine-contract checks,
and fixture proof; PR 18 merged at `1f6647a`. Fresh-orchestrator continuation
merged through PR 19 at `b99d19c`. Card 115 diversified model routing across
workers, delegates, and fresh orchestrators; PR 20 merged at `08ad810` after
exact-head review. Spec 034's modular-language-package design is promoted and
compiled into `g02.048`. Card 116 merged through PR 21 at `eaeac88`. Card 117
merged its generic lifecycle proof through PR 22 at `75db6f5`. Card 118's
public source repository merged package PR 1 as `09ef174` for
`@northstar/typescript-quality` `0.1.0`; its invocation repair merged as
`d18dc33b`. Core registry/routing PR 23 merged as `5951dfb`. Jetstream PR 4
passed exact-head review at `177b75c80e5310d84fdd227d0229b261d59d6271` and
squash-merged as `dbf7561d3845bf344f9ae4fae3296d1601b074bf`. The accepted
bounded canary proof preserves installed routing, fallback visibility, and
consumer/package bytes; four pre-existing editor failures and current-Poodle
`ResolvedIconGeometry` API drift remain limits. The Rust readiness refresh
selected Convergence and froze a 54-file source boundary, but also found the
TypeScript package's standalone `SKILL.md` loaded an absent router.
Package-source PR 3 repaired it and merged as `c9ef2a2`; card 121's registry
`1.3.0` pin merged as `69e4d5d`. Rust package-source PR 4 passed review at
`7cc4cd0` and merged as `56b2e11`; card 119's registry promotion pinned that
identity at registry version `1.4.0` with the reproduced 59-file tree, proved
the real-package lifecycle transcript and installed engine integrity, and
merged as `256d0f7`. The Convergence `g02.031/102` consumer canary repaired its
evidence gap and merged as `dff19c9`. Card 119 is complete. The exact removal
inventory exposed a missing generic intent/activation selector. Card 122
implemented it and merged as `ddaae0d`; card 120 is ready after its post-merge
refresh. Operator evidence then exposed detached Paseo root workers that do not
notify their orchestrators. `g02.049/123` rejected its prose-coupled checker,
proved the behavior through the live child lane and same-child revisions, and
merged as `7ebaa9c`; installed-skill parity is current. Card 120 then removed
the embedded payloads and fallback, closing `g02.048`'s Batch D: core is
generic-only (111-file payload) and both installed routes are proven; the PR
awaits exact-head review and merge, and the installed-skill refresh follows
merge.

`g02.030` is complete. Cards `g02.030/083-088` proved the Effigy-native
boundary, promoted the shared production foundation, added both routed
workflows, passed both production tracks, and distributed the 76-file payload
with agent-owned activation.
`g02.026/078` remains ready but deferred. The instruction-surface lane is
complete after card 101; Atlas, triage/cleanup, and language-quality live-use
measurements still require operator-provided evidence. Northstar does not
select or dispatch those consumer runs.
`g02.031` is complete. Cards `g02.031/089-093` distributed the explicit-only
TypeScript/Svelte audit with revision-S production evidence and 93-file
source/install parity. Everyday TypeScript remains unavailable. Accept
operator-provided live-use feedback; do not dispatch a consumer audit.
Rust v2 live-use research is promoted. Roadmap `g02.032` is complete; cards
094-099 implemented the Cargo-native lifecycle, immutable mechanical evidence,
compact closeout, detector qualification, revision-E production proof, and
exact 120-file configured distribution.
Jetstream live-use corrections are complete under `g02.033/100`: explicit
adapters install at full depth, TypeScript may retain review-required findings
honestly, and Rust captures pinned `stopslop` forwarder evidence without adding
repair authority or everyday context.
Direct PR-review routing is complete under `g02.034/102`: fresh review threads
publish their verdict and every blocking finding on the provider surface, with
chat retained as summary only.
Worker-review correction is complete under `g02.035/103`: risky cards carry
review oracles, workers try to falsify their diffs before PR creation and
revision, review findings are reason-coded, and handoffs remain compact dispatch
overlays rather than duplicate authority.
Optional control-plane dispatch is complete under `g02.036/104`: Paseo can
select current profiles, create the lane worktree, launch from the absolute
handoff, notify, and carry follow-ups while manual dispatch remains complete.
Operator feedback is complete under `g02.037/105`: injected Paseo tools replace
the redundant per-run permission prompt without making project config or the
control plane repository authority.
The follow-up lifecycle correction is complete under `g02.038/106`: consumer
projects no longer own copied Rhai code, sibling links live in the worktree
container before setup, changes-requested reviews explicitly wake the
originating Paseo worker, and a real Figmatic Paseo lifecycle passed. Accepted
exact-head orchestrator review plus passing checks authorizes merge without
another operator prompt.
Mechanical documentation projection `g02.039/107` is complete: Sol retains
meaning authority and a provider-neutral, profile-driven subagent applies only
exact bounded documentation briefs; Sol reviews the full diff before closeout.
Conversational planning delegation `g02.040/108` is complete. Its planning
delegate remains provider-neutral, research helpers are read-only, merge is
intake, and promotion remains a separate orchestrator batch.
