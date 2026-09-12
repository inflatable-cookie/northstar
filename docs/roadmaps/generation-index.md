# Roadmap Generation Index

Status: active
Updated: 2026-09-12
Mode: sequential

## Active generation

- `g03`
- Runway: `g03/README.md`
- Current task, ready frontier, and delivery state are projected in the
  generated lifecycle blocks under `docs/README.md`, `docs/roadmaps/README.md`,
  and `g03/README.md`; this index stays strategic.
- Next sequencing decision after the open lane closes: return to Chatterbox;
  no automatic successor.

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

The open lane runs until the closeout hook publishes its terminal record;
after that, return to Chatterbox. No automatic successor is approved.
