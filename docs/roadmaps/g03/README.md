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
| Replace agent-written mechanical lifecycle bookkeeping with a portable core and deterministic projections. | complete as `g03.005` | system architecture, contract 001, bundle section 12 | continue with `g03.006` adoption |
| Integrate rich runtimes without making Northstar or Queue depend on each other's internal structure. | complete as `g03.006`; terminal record and projections published as `d244d83` | bundle section 12; Queue contract v1 | Chatterbox next planning direction |
| Finish hook-owned mechanical closeout and remove duplicate mutable Markdown state. | delivered as `g03.007`; exact handoff cleanup missed because the launcher resolved stale installed code | system architecture, contract 001, bundle section 12; Queue g01.010 | correct the execution boundary in `g03.008` |
| Pin the complete Queue hook runtime to repository bytes and repeat the live self-hosting proof. | active as `g03.008` | system architecture, contract 001, bundle section 12; `g03.007` live evidence | one corrective self-hosting lane |
| Reduce repeated protocol enumerations and retire genuinely redundant modes without merging distinct behavior blindly. | next | contract 001, later usage evidence | Chatterbox sequencing after the active goal |
| Keep unresolved operator feedback visible without pinning old generations open. | watch | contract 001 | bounded watchlist below |

Task mechanical state — status, stage, revision, delivery digests — is the
generated lifecycle block at the end of this file, refreshed by the closeout
hook at publication. Runway rows above stay coarse goal-sequencing intent and
are not a per-task status mirror.

## Current lane

One lane executes at a time. Dispatch authorization for an open lane is its
committed handoff plus the task's own dispatch manifest; no concurrent sibling
and no automatic successor are authorized. Queue repository work remains
separately owned and is not part of this runway.

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

## Task files

- `001-compact-default-lifecycle.md`
- `002-complete-consumer-compaction.md`
- `003-flatten-execution-tasks.md`
- `004-ui-design-planning-and-delivery.md`
- `005-portable-lifecycle-core.md`
- `006-adopt-portable-lifecycle.md`
- `007-finish-hook-owned-closeout.md`
- `008-pin-queue-hook-runtime.md`

Mechanical status lives in the lifecycle records: adopted tasks (`g03.006`
onward) project it in the generated block below, earlier tasks keep their
completion in the runway above and in Git history.

## Next task

An open lane runs until the closeout hook publishes its terminal record into
the generated block below. After a lane closes, return to Chatterbox; do not
dispatch a successor automatically.
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v1 digest=sha256:7a403d04c442c6d5f2b982e60644fd318f2ff7cb6241afbbbb6ff7f9bac44e9b -->
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
| g03.006 | complete | none | 8 | sha256:025066786b2d9af4821307a2b06b15b6cab8bf47a4a816db22bed66b9faa8c9b |
| g03.007 | complete | none | 8 | sha256:a5b8006f700e791ff4bb68f504746a9f2431bb1711abd70292673e536a80b9ad |
| g03.008 | complete | none | 8 | sha256:888d75786d747f9965efa51b4b492c005aaf967a8f6504715e3b6be0f2760099 |
<!-- northstar:lifecycle:end -->
