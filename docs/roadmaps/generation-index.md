# Roadmap Generation Index

Status: active
Updated: 2026-09-21
Mode: sequential

## Active generation

- `g03`
- Runway: `g03/README.md`
- Mechanical task state and delivery evidence are projected in the generated
  lifecycle blocks under `docs/README.md`, `docs/roadmaps/README.md`, and
  `g03/README.md`; this index stays strategic.
- `g03.022` is approved and ready (backlink guard scaling, 2026-09-22).

## Generation log

| Generation | State | Boundary | History disposition |
| --- | --- | --- | --- |
| `g01` | closed | Internal Northstar-on-Northstar foundation | [archive/g01.md](archive/g01.md) roll-up |
| `g02` | closed | External proof and execution hardening | [archive/g02.md](archive/g02.md) roll-up |
| `g03` | active | Compact default lifecycle and protocol reduction | expanded active generation |

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

No lane is approved. `g03` is exhausted and awaiting a rollover or a fresh
planning lane. The accepted closeout-convergence revision is merged and its
installed interface identity has been handed to Queue for `g01.019`.
Operator-authorized consumer manifest migrations continue as separate
per-project maintenance tasks.
