# g03

Status: active

`g03` makes Northstar compact by default: one strict lifecycle, bounded current
state, explicit artifact pruning, and closed-generation roll-ups.

## Generation Runway

| Goal | State | Governing refs | Next task |
| --- | --- | --- | --- |
| Replace permanent live-tree history with lifecycle-bound artifacts and lossless operational compaction. | complete through `g03.001` | contract 001 | observe normal use |
| Complete consumer compaction through maintenance routes. | complete as `g03.002`; delivery evidence absorbed | contract 001 | no further compaction lane |
| Flatten milestone/card execution into one generation task unit. | complete as `g03.003` | contract 001 | return to Chatterbox planning checkpoint |
| Move material UI design decisions before dispatch and require rendered exact-head delivery review. | complete as `g03.004` | section 11, contract 001 | observe first natural consumer lanes |
| Replace agent-written mechanical lifecycle bookkeeping with a portable core and deterministic projections. | active; `g03.005` ready | spec 040, system architecture, contract 001 | implement portable core, then standalone adoption |
| Integrate rich runtimes without making Northstar or Queue depend on each other's internal structure. | planned after core freeze | spec 040; Queue-owned generic hook contract | Queue hook lane, then Northstar adapter proof |
| Reduce repeated protocol enumerations and retire genuinely redundant modes without merging distinct behavior blindly. | planned | contract 001, later usage evidence | pending after `g03.001` |
| Keep unresolved operator feedback visible without pinning old generations open. | watch | contract 001 | bounded watchlist below |

## Approved frontier

`g03.005` is the sole approved ready task. It has no concurrent sibling and no
automatic successor. Queue repository work remains separately owned and is not
part of this frontier.

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

## Tasks

- `001-compact-default-lifecycle.md` — complete
- `002-complete-consumer-compaction.md` — complete
- `003-flatten-execution-tasks.md` — complete
- `004-ui-design-planning-and-delivery.md` — complete
- `005-portable-lifecycle-core.md` — ready

## Next task

Execute `g03.005`. After merge, return to Chatterbox to compile standalone
adoption and relay the frozen generic hook boundary to Queue planning.
