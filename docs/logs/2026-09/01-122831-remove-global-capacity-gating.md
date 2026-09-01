# Remove Global Capacity Gating

Date: 2026-09-01
Roadmap: `g02.044`
Card: `g02.044/112`
Status: complete

## Result

The orchestrator now launches every safe ready-frontier lane without a global
worker-slot budget. A provider, model, or profile spend, quota, rate, or
availability failure is route-local: try another configured profile of the same
role and capability, never promote an ordinary lane to frontier for
availability, and pause only that lane when no suitable route remains.
Ambiguous workspace or agent creation preserves returned identities and does
not retry into a duplicate worker. Unrelated ready lanes keep launching.
Dependency, shared-surface, authority, and same-repo merge-order gates are
unchanged.

A worker-finish notification starts review of that lane. It does not refill a
global launch queue, because unrelated ready work should already have launched
at the dispatch checkpoint.

## Before/after live wording

| Phrase that encoded the false global scheduler | After |
| --- | --- |
| `up to available capacity` | `without a global thread budget` / `without a global worker-slot budget` |
| `the first explicit launch refusal` as that checkpoint's capacity | provider/profile refusal is `not a control-plane capacity signal` |
| `A worker-finish notification frees a capacity slot immediately` | finish starts review; `it does not refill a global launch queue` |
| `capacity refusal ends launching for this checkpoint` | pause only the refused lane; continue unrelated ready lanes |
| `queued against that named adapter limit` | gone from live reusable surfaces |
| `Capacity is discovered, never guessed` / `Discover capacity; do not guess it` | gone; no global slot value is inferred |
| serial reason `or capacity limit` | serial reasons are dependency, shared surface, or unresolved authority |

Historical logs, handoffs, and closed cards keep the superseded rule as
evidence. The live dogfood triage buffer is unchanged except that it already
points at this correction.

## Changed surfaces

| Surface | Before | After |
| --- | --- | --- |
| `docs/specs/026-…md` | already lane-local on the planning base | unchanged |
| `docs/architecture/system-architecture.md` | first-refusal capacity discovery, slot refill, capacity-limit serial reason | no global thread budget; lane-local provider/transport; identity preservation |
| `docs/architecture/system-inventory.md` | worker/orchestrator rows silent on provider locality | lane-local provider/profile routing |
| `docs/contracts/001-working-rules.md` | discovered capacity, first refusal, slot refill | no global thread budget; same-class retry; pause-one-lane; no queue refill |
| `bundle-docs/sections/07-…md` | capacity discovery and refill paragraphs | lane-local routing, identity preservation, no queue refill |
| `template-bundle/contracts/001-working-rules-template.md` | Discover capacity / slot refill | matching compact contract |
| `skills/northstar/references/modes/orchestrator.md` | steps 6, 9, 10, 12 and `## Parallel lane dispatch` encoded global slots | dispatch all safe lanes; route-local refusal; finish is review not refill |
| `skills/northstar/SKILL.md` | `up to available capacity` | no global thread budget; lane-local provider/profile routing |
| `bundle-docs/operators/operator-quick-start.md` | first launch refusal is capacity | provider cap pauses one lane; unrelated work keeps launching |
| `bundle-docs/protocol-kernel.md` | **Parallel lane scheduling and capacity** | **Parallel lane scheduling and lane-local provider routing** |
| `scripts/lib/northstar-repo-contract-data.rhai` | first-refusal / slot-refill / capacity-discovery positives | seven-row positives plus 14 negatives that fail if the old global scheduler returns |

## Scenario matrix (seven review-oracle rows)

| Scenario | Expected behavior | Where it is settled |
| --- | --- | --- |
| Two independent safe lanes, no adapter limit declared | launch both; do not queue one or wait for a finish event | `without a global thread budget`; `It does not impose a global thread count`; negative `up to available capacity` |
| Lane A hits a monthly spend limit; lane B uses an unrelated available route | pause or reroute A and still launch B | `not a control-plane capacity signal`; `unrelated ready work keeps launching` |
| A day-to-day route is unavailable but another day-to-day profile fits | retry through the matching alternative; do not promote frontier | `Do not promote an ordinary lane to frontier merely`; `same-class profile rather than spending a frontier worker` |
| A lane has no suitable available profile | preserve handoff/workspace, report the gap, continue unrelated lanes | `pause only that lane`; orchestrator no-fit / same-class clauses |
| Workspace or agent creation returns an identity then fails ambiguously | retain the identity, stop retrying that lane, continue clear lanes | `ambiguous attempt is not duplicated` |
| Lane B consumes lane A's harness evidence, or both own one front door | keep only that edge serial and name it | frontier conditions plus named serial reason without capacity limit |
| Two same-repo PRs finish together | merge one, refresh the other, re-review a changed head | orchestrator step 12; handoff `Merge ordering`; unchanged merge-order assertions |

## Validation

- `effigy check:command-skills` — pass (9 adapters, aggregate descriptions=460 chars);
- `effigy check:skill-install` against an isolated rsync of `skills/northstar/`
  — pass, exact parity, 127 files;
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- `git diff --check` — clean.

Negative assertions now fail if these live phrases return:

- `first explicit launch refusal`
- `A worker-finish notification frees a capacity slot immediately`
- `capacity refusal ends launching for this checkpoint`
- `Capacity is discovered rather than guessed`
- `Capacity is discovered, never guessed`
- `Discover capacity; do not guess it`
- `the first explicit launch refusal from an adapter`
- `up to available capacity`
- `Parallel lane scheduling and capacity`

## Limitations

No live dispatch was re-run against a provider spend cap. The behavior is
documented protocol and deterministic assertions, not a measured recovery of
the six-to-ten-thread dogfood window. No Paseo, profile, provider, quota, or
worker-count constants were added. Serial, review, and same-repo merge gates
were not weakened. The live dogfood triage buffer remains operator-owned
evidence.

## PR

https://github.com/inflatable-cookie/northstar/pull/17 — accepted head
`72dc48f94db29de61ef56807de375249a12bb00a`, merged at `e5e8060` after one
metadata-only revision.

The global install matches the source payload exactly at 127 files. The seven
other active `Orchestrator`-labelled workspaces were told to re-read the
corrected mode and refresh their ready frontiers.

## Next

Continue passive dogfood intake. A later provider-limit observation may test
the correction; Northstar does not create that work itself.
