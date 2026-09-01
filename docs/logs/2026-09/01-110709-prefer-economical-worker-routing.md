# Prefer Economical Worker Routing

Date: 2026-09-01
Roadmap: `g02.043`
Card: `g02.043/111`
Status: complete

## Result

Ordinary implementation workers now select a matching non-frontier day-to-day
profile by default. Frontier workers are a conjunctive exception: the lane must
be both exceptionally difficult to reason through after planning and
highest-priority or materially consequential, and the handoff records both
reasons. Risk-domain labels, file count, duration, and generic “high complexity”
no longer auto-escalate the worker. Risky surfaces still keep an explicit review
oracle and frontier review.

## Current-profile note inventory

Local adapter notes distinguish, without those names entering reusable policy:

- several notes cover ordinary day-to-day worker handoffs, including the
  majority of ordinary implementation;
- one note covers long, mechanically oriented audit and documentation work;
- one note reserves a worker for the highest-priority, highest-complexity
  combination;
- orchestrator notes remain planning, operator conversation, dispatch, and
  review.

This is dispatch evidence for the overspend defect. Northstar still selects by
current notes at launch time and does not store profile or model names.

## Before/after automatic frontier triggers

| Trigger that used to spend a frontier worker | After |
| --- | --- |
| `security, persistence, concurrency, public API, deployment, multi-version, or ambiguous work: frontier worker with high reasoning and frontier review` | Removed. Those surfaces keep a review oracle and frontier **review**. They do not by themselves select a frontier **worker**. |
| Generic “high complexity” or capable-medium wording without a day-to-day default | Ordinary bounded implementation uses a matching non-frontier day-to-day profile. |
| Ambiguous architecture or product choice | Return to planning. Do not spend a frontier worker to choose. |

## Changed surfaces

| Surface | Before | After |
| --- | --- | --- |
| `docs/specs/026-…md` | already two-axis on the planning base | unchanged |
| `docs/architecture/system-architecture.md` | worker topology silent on model class | economical default, conjunctive frontier, review kept, planning-return, no-fit report |
| `docs/architecture/system-inventory.md` | worker row silent on routing | day-to-day default; both axes required for frontier |
| `docs/contracts/001-working-rules.md` | operator may override worker-profile; no default class | economical default, two-axis exception, review kept, planning-return, no-fit |
| `bundle-docs/sections/07-…md` | no worker-routing doctrine | new `## Economical worker routing` |
| `template-bundle/contracts/001-working-rules-template.md` | no worker-routing clause | new `### Economical worker routing` |
| `skills/northstar/references/modes/orchestrator.md` | risk-domain list auto-selected a frontier worker | economical default; mechanical class; conjunctive frontier; both reasons; planning-return; no-fit |
| `skills/northstar/SKILL.md` | orchestrator outcome silent on worker class | economical day-to-day default; frontier only when both axes hold |
| `skills/northstar/assets/templates/northstar-orchestrator-run.md.template` | `Model capability profile` only | adds `Frontier-worker justification` / `BOTH_AXES_OR_NONE` |
| `skills/northstar/references/handoff-contract.md` | no frontier-reason field | worker handoff records both axes or `none` |
| `bundle-docs/operators/operator-quick-start.md` | worker class unmentioned | ordinary non-frontier default; rare two-axis frontier; review kept |
| `bundle-docs/protocol-kernel.md` | no canonical-home row | new **Economical worker routing** row |
| `scripts/lib/northstar-repo-contract-data.rhai` | no routing assertions | 21 positive assertions plus 3 negative assertions that fail if the old automatic frontier rule returns |

## Scenario matrix (seven review-oracle rows)

| Scenario | Expected behavior | Where it is settled |
| --- | --- | --- |
| Bounded ordinary fix labelled “high complexity” without exceptional reasoning | matching non-frontier day-to-day profile | orchestrator model routing; working rules; operator quick start; skill outcome |
| Repository-wide docs or audit following settled mechanical rules | fast/low-cost or mechanically oriented profile | orchestrator mechanical class; doctrine; working rules |
| Well-specified persistence or public-API change with a complete oracle | capable non-frontier worker; frontier review retained | “does not by itself make a worker lane frontier work”; well-specified capable-non-frontier clause; negative assertion on the old risk-domain trigger |
| High priority but mechanically simple, or very difficult but low priority | not frontier unless both axes hold | “Priority alone, complexity alone”; conjunctive exception; two single-axis negatives in one named-insufficient rule |
| Highest-priority, materially consequential lane that still needs exceptional reasoning after planning | matching frontier profile; both reasons recorded | conjunctive exception; `Record both reasons in the handoff`; template `Frontier-worker justification` |
| Two product or architecture designs remain plausible | return to planning; do not spend a frontier worker to choose | “return to planning rather than spending a frontier worker”; negative assertion on `ambiguous work: frontier worker…` |
| No configured non-frontier profile fits an ordinary lane | report the gap; do not silently promote to frontier | “report the profile gap”; orchestrator stop condition |

## Validation

- `effigy check:command-skills` — pass (9 adapters, aggregate descriptions=460 chars);
- `effigy check:skill-install` against an isolated rsync of `skills/northstar/`
  — pass, exact parity, 127 files;
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- `git diff --check` — clean.

Negative assertions were verified present at `463d12e` and absent now:

- `ambiguous work: frontier worker with high reasoning and frontier review`
- `security, persistence, concurrency, public API, deployment, multi-version, or`
- `bounded, mechanically direct worker: capable coding model, medium reasoning`

## Limitations

No live dispatch was re-run against current adapter notes. The behavior is
documented protocol and deterministic assertions, not a measured cost delta.
No provider prices, model IDs, local profile names, Paseo profile mutations, or
mid-run replacement protocol were added. Review-oracle and frontier-review
gates for risky surfaces were not weakened.

## PR

https://github.com/inflatable-cookie/northstar/pull/15

## Next

Orchestrator exact-head review of that PR. The worker does not merge.
