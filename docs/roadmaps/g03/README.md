# g03

Status: active

`g03` makes Northstar compact by default: one strict lifecycle, bounded current
state, explicit artifact pruning, and closed-generation roll-ups.

## Generation Runway

| Goal | State | Governing refs | Next milestone |
| --- | --- | --- | --- |
| Replace permanent live-tree history with lifecycle-bound artifacts and lossless operational compaction. | complete through `g03.001` | contract 001 | observe normal use |
| Make the compact lifecycle the only normal consumer posture. | complete through card 132 and PR 40 | contract 001 | observe normal use |
| Reduce repeated protocol enumerations and retire genuinely redundant modes without merging distinct behavior blindly. | planned | contract 001, later usage evidence | pending after `g03.001` |
| Keep unresolved operator feedback visible without pinning old generations open. | watch | contract 001 | bounded watchlist below |

## Approved frontier

None. `g03.001` is complete. Chatterbox and the operator must select and promote
the next tranche before the coordinator dispatches more work.

## Bounded watchlist

- Economical-coordinator observation continues passively through the tenth
  natural PR lane or `2026-09-18 17:00 Europe/London`, whichever comes first.
  It does not block `g03` work or synthesize project activity. Chatterbox owns
  the final reconciliation. This rehomes the unfinished evidence obligation
  from `g02.051/126` without keeping `g02` active.
- Discovery starter surfaces from `g02.026/078` remain deferred; revisit only
  through fresh planning if operator evidence makes them relevant.
- Atlas, triage/cleanup, and language-package feedback remain operator-provided
  evidence only. They are not ready Northstar execution lanes.

## Milestones

- `001-compact-default-lifecycle.md` — complete

## Next task

Discuss the next `g03` simplification tranche with the operator. Do not turn a
watchlist item into execution work without fresh planning and confirmation.
