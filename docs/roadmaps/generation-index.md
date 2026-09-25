# Roadmap Generation Index

Status: active
Updated: 2026-09-25
Mode: sequential

## Active generation

- `g04`
- Runway: `g04/README.md`
- Mechanical task state and delivery evidence are projected in the generated
  lifecycle blocks under `docs/README.md`, `docs/roadmaps/README.md`, and
  `g04/README.md`; this index stays strategic.

## Generation log

| Generation | State | Boundary | History disposition |
| --- | --- | --- | --- |
| `g01` | closed | Internal Northstar-on-Northstar foundation | [archive/g01.md](archive/g01.md) roll-up |
| `g02` | closed | External proof and execution hardening | [archive/g02.md](archive/g02.md) roll-up |
| `g03` | closed | Compact default lifecycle and protocol reduction | [archive/g03.md](archive/g03.md) roll-up |
| `g04` | active | Project knowledge currentness | expanded active generation |

## Rollover rule

Open a generation when the sequencing baseline materially changes. Close the
old generation by promoting durable meaning, rehoming unresolved commitments,
and removing its execution authority. Keep only the active sequential
generation expanded; compact closed generations under `archive/` after the
preservation oracle in contract 001 passes.

In a lifecycle-adopted repository, rollover also changes the declared
projection targets explicitly: the outgoing generation README leaves
`.northstar/lifecycle/v1/projection-targets.json` and the incoming one joins
it in the same rollover change.

## Next task

No lane is dispatched. `g04` opened on 2026-09-25; the next move is operator
approval of spec 042, the lean Northstar design. Consumer repository
maintenance stays a separate per-project Queue task.
