# 133 - Complete Consumer Compaction

Status: ready
Owner: repo maintainers
Created: 2026-09-05
Master roadmap: g03.002
Governing refs: docs/contracts/001-working-rules.md (consumer maintenance and preservation oracle)
Auto-start next card: no

## Objective

An authorized maintenance run on an existing consumer compacts safely closed
roadmap generations, preserves authority and open commitments, and cannot
silently label unhandled historical expansion current.

## Approved dispatch manifest

- Lane: g03.002/133; ready after this planning commit is on clean synchronized main.
- Completion: shipped route and consumer fixture proof, independent exact-head
  review, installed parity, merge and local-main reconciliation.
- Concurrent siblings: none. Serial edges: none; g03.001 is complete.
- Worker class: economical implementation agent competent in documentation
  workflows and deterministic checks. Reviewer: independent semantic reviewer
  with a different provider/model identity.
- Escalation owner: Chatterbox for unresolved authority or scope decisions.
- Owned paths: lifecycle doctrine under bundle-docs; lifecycle starter material
  under template-bundle; maintenance/rollover routing and its shared references
  under skills/northstar; lifecycle checker and relevant fixtures/tests/direct
  callers under scripts; effigy.toml only for necessary validation routing;
  installed Northstar skill destination through the existing parity route.
- Reserved closeout: this card, g03.002, g03/README.md and batch-cards/README.md,
  docs/roadmaps/README.md, generation-index.md and docs/README.md.
- Excluded: live sibling consumers, releases, .github/workflows, new service or
  runtime compaction engine, unrelated mode consolidation, historical PR rewrites.

## Work batch

1. Read contract 001 and map the existing source/install maintenance routes,
   rollover guidance, reusable doctrine, templates and checks. Preserve the
   distinct refresh, normalize and read-only cleanup authorization boundaries.
2. Establish one shared procedure used by those routes: content/reference
   inventory; active/closed/unresolved classification; preservation manifest;
   canonical promotion and open-commitment rehoming; concise non-procedural
   archive/gNN.md; current-link rewrite; exact classified deletion; validation.
   Cover pre-existing closed generations as well as new rollover. Do not make
   explicit repair authorization require a second blanket confirmation.
3. Align starter/doctrine with the same procedure and stop semantics. Keep
   installed operation self-contained; do not depend on Northstar-only contract
   paths or silently require a source checkout for routine maintenance.
4. Build a disposable consumer fixture with two closed expanded generations and
   one active generation, stale front-door references, unique durable rules,
   a deferred commitment and selected material PR/commit evidence. Exercise the
   shipped installed route in a recorded agent replay, then inspect actual
   before/after artifacts with deterministic preservation/link checks. Do not
   call a handcrafted expected output proof that the route performed compaction.
5. Test negative controls below and a repeat run. Separate executable structural
   assertions from semantic review; no prose-exact tests pretending to prove
   agent behavior. Run focused checks, effigy qa (including docs), diff check,
   and installed-skill parity after the full batch.
6. Record actual evidence, limits, accepted head/PR/merge here. Coordinator
   synchronizes main before closeout. No next lane is authorized.

## Acceptance and review oracle

| Invariant | Adversarial case | Required proof |
| --- | --- | --- |
| Existing closed generations compact without another rollover | Maintenance only updates front doors and reports success | Installed-route replay removes both classified expanded generations, creates two roll-ups and preserves the active generation |
| Authority and commitments survive | Old card holds the only rule or deferred obligation | Before/after destination manifest and content verification; unresolved destination blocks deletion |
| Material history remains traceable without executable archives | Roll-up copies old steps or loses PR evidence | Selected evidence survives; no active status, runnable procedure or auto-start in roll-up |
| References remain valid | Current page points into removed generation | Current caller rewrites and link checks on actual output |
| Uncertainty is visible and non-destructive | Conflicting active/closed states, unresolved ownership or legitimate parallel active generations | Target remains intact; precise unresolved disposition; no false current result |
| Authorization is respected | Read-only cleanup request | Inspection/proposal only, no file mutations |
| Checks prove behavior, not wording | Expected fixture is manufactured without running route | Retained replay provenance plus independent before/after assertions; no claim of agent-route proof from static tests alone |
| Repeat maintenance is stable | Run again on already compacted consumer | No content churn or re-expansion |

## Stop conditions

Stop for an authority conflict the preservation oracle cannot settle, a required
consumer mutation outside disposable fixtures, unavailable installed-route replay
capability, path ownership collision, or validation failure that changes the plan.
Do not substitute manual expected-output construction for missing replay access.

## Implementation evidence

Status remains ready for coordinator closeout. Worker delivery is the shared
procedure, disposable fixture, recorded installed-skill replays, and
independent before/after assertions.

Installed-skill route: `$HOME/.agents/skills/northstar` via
`references/lifecycle-maintenance.md`. Provider `codex/gpt-5.6-luna`,
`full-access`, `xhigh`. Replay artifacts:
`scripts/tests/consumer-compaction/evidence/`.

| Scenario | Agent | Result |
| --- | --- | --- |
| Happy authorized refresh | `70fbe934-62fa-431f-a183-1db9ecb5c0af` | Removed expanded `g01`/`g02`; wrote `archive/g01.md` and `archive/g02.md`; preserved `g03` and `ACTIVE-GEN-ONLY-TOKEN`; promoted `UNIQUE-RULE-WIDGET-PREFIX`; rehomed `DEFERRED-COMMITMENT-WIDGET-AUDIT`; retained PR 101/`c0ffee101` and PR 202/`c0ffee202`; rewrote stale `g01/`/`g02/` front-door links |
| Read-only cleanup | `0ea21e44-e63a-4927-93f6-2a8698d693d9` | Proposal only; byte-identical tree |
| Unresolved ownership | `b3ac3ec8-d1a8-4df7-a8a3-c72c5dd94989` | `g01` and `UNIQUE-ORPHAN-RULE` left on the source card; no `archive/g01.md`; `g02` compacted as safely closed |
| Active/closed conflict | `2767c19d-82ae-494a-b358-24f432ce46c3` | Stopped; no mutations; `CONFLICT-ACTIVE-CLOSED` retained |
| Repeat refresh | `3b9de735-b7c0-40d2-9f43-5a700eb524e1` | No docs content churn; no re-expansion |

Validation on this checkout: `git diff --check`, `effigy check:consumer-compaction`
(123/0), `effigy qa:docs`, `effigy qa`, and
`effigy check:skill-install $HOME/.agents/skills/northstar` (112 files) all pass.

Limits: live consumers were not migrated. Repeat input is the recorded happy
after-tree, not a second live consumer. Coordinator owns merge, installed
parity on the integration checkout, and reserved front-door closeout.
