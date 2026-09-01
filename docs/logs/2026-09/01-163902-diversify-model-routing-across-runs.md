# Diversify Model Routing Across Runs

Date: 2026-09-01
Roadmap: `g02.047`
Card: `g02.047/115`
Status: complete; awaiting exact-head review

## Result

Model routing now treats configured profiles as a portfolio instead of
repeating one best-fit route. At every worker, planning-delegate, and
fresh-orchestrator dispatch the orchestrator builds the adequate pool for the
role from current notes and explicit adapter cost metadata, prefers the
cheapest adequate tier, then varies provider/model identity before reusing a
recent route. Adequacy filters before price or rotation. Adapter-visible
recent-agent history is used when available; otherwise the orchestrator
remembers only the routes it launched in the current run. Northstar keeps no
durable usage ledger and stores no provider, model, price, balance, or
allowance value. The rule covers ordinary, mechanical, settled-material,
frontier, planning-delegate, and fresh-orchestrator dispatches. Frontier
selection still requires the residual-reasoning explanation and now rotates
within its own adequate pool. Explicit operator selection overrides rotation;
route refusals stay lane-local.

## Changed surfaces (before/after)

| Surface | Before | After |
| --- | --- | --- |
| `skills/northstar/references/modes/orchestrator.md` | role-based single best-fit selection; "try another configured profile" same-role fallback; successor/delegate selection picked one profile | portfolio intro (pool, cheapest tier, recent-use rotation, optional history, no ledger); capability bullets name pools; frontier exception requires residual-reasoning explanation and rotates; refusals choose another adequate route from the lane's diversified pool; delegate and successor steps use the diversified rule |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | "Economical worker routing" selected one non-frontier profile; "try another same-class profile" fallback; delegate/Sol selection singular | diversified rule paragraph; same-class fallback replaced by adequate-route-from-pool; delegate selection rotates; fresh-orchestrator profile selection under the diversified rule; parallel-scheduling refusal sentence updated |
| `template-bundle/contracts/001-working-rules-template.md` | copy-ready routing bullets mirrored the single-default rule | copy-ready bullets state pool, tier, rotation, optional history, no ledger, frontier rotation, review-strength separation, lane-local refusal |
| `skills/northstar/SKILL.md` | orchestrator outcome said "economical day-to-day worker default" | "diversified economical worker routing (adequate pool, cheapest adequate tier, recent-use rotation)" |
| `bundle-docs/operators/operator-quick-start.md` | "tries another matching profile of the same class"; ordinary workers "use a matching non-frontier day-to-day profile" | reroute from the lane's diversified pool; ordinary workers draw from the cheapest adequate pool and vary provider/model between runs |
| `bundle-docs/protocol-kernel.md` | routing row named only the doctrine home | routing row carries the compact diversified meaning |
| `skills/northstar/references/handoff-contract.md` | worker handoff recorded "the model capability profile" | profile recorded as selected under the diversified-routing rule |
| `scripts/check-northstar-model-routing.rhai` | did not exist | new focused checker: per-surface positive assertions for all ten oracle rows plus negative scans |
| `effigy.toml`, `scripts/lib/northstar-repo-contract-data.rhai`, `scripts/test-northstar-repo-contract.rhai` | `qa:docs` without routing assertions | `check:model-routing` task wired into `qa:docs`; machine-contract pin and fixtures updated |
| `docs/specs/026`, `docs/contracts/001-working-rules.md`, `docs/architecture/system-architecture.md` | settled on the planning base `b30e288` | unchanged; they already carried the diversified policy and are now assertion targets |

`docs/architecture/system-inventory.md` keeps its compact "economical
day-to-day default" wording, which remains true under the diversified rule;
no contradiction was introduced.

## Ten oracle rows falsified

| Milestone 047 oracle row | Adversarial scenario | Result | Proof in `check:model-routing` |
| --- | --- | --- | --- |
| Adequacy precedes preference | cheap profile lacks the role capability | inadequate route excluded before price or rotation | "Adequacy comes before price or rotation" / "Adequacy filters before price or rotation" / "adequate profile pool" assertions across mode, doctrine, template, spec, contract, architecture |
| Cheap adequate routes are used | cheap and expensive profiles equally adequate | cheapest adequate tier wins | "cheapest adequate tier" assertions in seven surfaces |
| Successful routes do not become permanent defaults | last route and a same-tier alternative both adequate | less-recent provider/model chosen | "vary provider/model identity" / "recent-use rotation" assertions |
| History is optional | adapter exposes profiles but no recent-agent history | current-run route memory; no ledger invented | "recent-agent history" + "current orchestrator run" + "durable usage ledger" (negative-existence) assertions |
| Orchestrators rotate too | fresh successor always copies the same profile | same pool and recent-use rule apply | "adequate orchestrator-role pool" assertions in spec, architecture, mode, doctrine |
| Review strength is not worker price | material but fully settled lane with strong oracle | economical pool used; orchestrator keeps material review | "review-strength control" / "keeps material review" / "material lanes use that economical pool" assertions |
| Frontier cost is exceptional | lane merely high-priority, broad, or security-labelled | no frontier selection from the label alone | "remaining reasoning" residual-reasoning assertions in six surfaces |
| Operator intent wins | operator names an adequate profile rotation would not choose | named profile used | "operator-named profile" / "operator-selected profile still wins" / "name a profile to" assertions |
| Route failure stays local | provider refuses after transport identity | only that route removed for the attempt; unrelated lanes continue | "only for that attempt" / "mark only that route unavailable" / "lane's diversified pool" assertions |
| Northstar stays portable | checker or instruction names a local model, price, or fixed wording | implementation rejected | negative scans: `(?i)\b(opus|grok|glm|sonnet|haiku|gemini)\b`, `\$\s?[0-9]`, `same-class`, `matching non-frontier day-to-day profile`, `best-fit` across all ten routing surfaces; live-contract and copy-ready template assert the same markers, so drift between them fails a named row |

## Assertion discrimination proof

- Pre-change tree (current `effigy.toml` + checker copied over `git archive
  HEAD`): `effigy --repo <tree> check:model-routing` fails with
  `[northstar:model-routing] oracle 'adequacy precedes preference': 'Adequacy
  comes before price or rotation' missing from orchestrator mode`.
- Mutated current tree (doctrine appended with "try another same-class
  profile", "opus-4", and a `$3` price): fails with
  `oracle 'northstar stays portable': forbidden pattern '(?i)\b(opus|grok|glm|
  sonnet|haiku|gemini)\b' found in doctrine 07`.
- Current tree: passes all ten rows.

## Stale-wording sweep

`same-class`, `best-fit`, `matching non-frontier day-to-day profile`, and
model-name/price tokens return no hits in `skills/`, `bundle-docs/`,
`template-bundle/`, `docs/specs/`, `docs/contracts/`, `docs/architecture/`,
`AGENTS.md`, `README.md`, or `scripts/` outside the checker's own denylist
literals and shell/regex `$1` positional tokens. Sol and Luna survive only as
the established "one possible local choice, not a Northstar dependency"
examples.

## Validation

- `effigy check:command-skills` — pass (9 adapters, aggregate descriptions
  460 chars);
- isolated `effigy check:skill-install` (rsync of `skills/northstar/`) —
  pass, exact parity, 127 files;
- `effigy qa:docs` — pass, including the new `check:model-routing` task;
- `effigy qa` — pass (validate board + docs QA);
- `git diff --check` — clean.

## Limits

No live dispatch was re-run against current adapter notes; the behavior is
documented protocol plus deterministic assertions, not a measured cost or
rotation delta. The checker asserts the routing contract only — it does not
restore the generic editorial validation removed by `g02.045/113`, and the
reduced repo-contract checker is untouched except for the new required script
path and the `qa:docs` wiring pin. Adequacy and cost tiers still come from
profile notes and explicit adapter metadata; Northstar gained no usage
accounting.

## PR

https://github.com/inflatable-cookie/northstar/pull/20 — opened at
`006504c1bd41a48566620b3688842c9bd2c0b99d` with validation recorded above.
The orchestrator owns exact-head review and merge.
