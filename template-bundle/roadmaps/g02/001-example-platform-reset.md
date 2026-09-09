# 001 - Example Platform Reset

**Type: EXAMPLE** -- Illustrates a generation rollover. Remove from your project after reading.

Status: ready
Owner: Core Team
Created: YYYY-MM-DD
Governing refs: `004-platform-topology-contract.md`, `005-runtime-boundary-contract.md`
Depends on: none

## Outcome

The original `g01` roadmap assumed a stable three-repo topology, but refocus
work revealed a broader platform split and ownership change that invalidated
multiple queued tasks. Replace stale `g01` assumptions with a new
contract-backed platform sequence and re-establish one trustworthy active
queue under `g02`.

## Decisions

Rollover to `g02` rather than in-generation repair: the old generation is no
longer a trustworthy execution baseline.

## Dispatch manifest

- **State:** ready; single task, no siblings
- **Completion:** `generation-index.md` records why `g02` replaced `g01`; active work no longer depends on stale topology assumptions
- **Owned mutable paths:** `docs/roadmaps/g02/001-<slug>.md`, `docs/logs/YYYY-MM/`
- **Reserved closeout surfaces:** none
- **Worker:** day-to-day implementation pool
- **Excluded:** further execution from superseded `g01` tasks; compatibility storytelling that preserves the old sequencing baseline
- **Escalation:** repo maintainers for scope or contract questions

## Work

1. Mark stale `g01` tasks superseded and update references to the new generation.
2. Confirm `g02` contract refs match architecture, inventory, and authority surfaces.
3. Execute the first platform-reset step against the new topology.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| `generation-index.md` clearly records why `g02` replaced `g01` | Teams keep reading `g01` as active because the rollover was only implied | Rollover decision log |
| Active roadmap work no longer depends on stale topology assumptions | A `g02` step imports the old repo split | Contract-delta log for the new topology contracts |
| The first `g02` step is directly backed by current contracts | Execution starts on prose promises | Task closure log for the first `g02` execution slice |

## Stop conditions

- Stop when a planning gap, contract contradiction, or failed evidence gate changes the plan.

## Evidence

None yet; record rollover decision, contract delta, and closure logs on completion.

## Next task

Execute the work steps above and publish the first `g02` closure log after stale `g01`
items are explicitly superseded.
