# g03

Status: active

`g03` makes Northstar compact by default: one strict lifecycle, bounded current
state, explicit artifact pruning, and closed-generation roll-ups.

## Generation Runway

| Goal | State | Governing refs | Next milestone |
| --- | --- | --- | --- |
| Replace permanent live-tree history with lifecycle-bound artifacts and lossless operational compaction. | active | spec 038, contract 001 | `g03.001` |
| Make the compact lifecycle the only normal consumer posture. | README correction ready | spec 038 | `g03.001/132` |
| Reduce repeated protocol enumerations and retire genuinely redundant modes without merging distinct behavior blindly. | planned | spec 038, later usage evidence | pending after `g03.001` |
| Keep unresolved operator feedback visible without pinning old generations open. | watch | spec 038, contract 001 | bounded watchlist below |

## Approved frontier

- Cards 130 and 131 merged; card 132's initial implementation also merged.
- Only card `g03.001/132`'s bounded root-README correction is ready.
- Chatterbox owns milestone reconciliation after that correction.

## Bounded watchlist

- Economical-coordinator observation continues passively through the tenth
  natural PR lane or `2026-09-18 17:00 Europe/London`, whichever comes first.
  It does not block `g03` work or synthesize project activity. Chatterbox owns
  the final reconciliation. This rehomes the unfinished evidence obligation
  from `g02.051/126` without keeping `g02` active.
- Atlas, triage/cleanup, and language-package feedback remain operator-provided
  evidence only. They are not ready Northstar execution lanes.

## Milestones

- `001-compact-default-lifecycle.md` — active

## Next task

Complete card `g03.001/132`'s root-README correction, then reconcile `g03.001`.
