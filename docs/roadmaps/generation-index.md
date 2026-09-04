# Roadmap Generation Index

Status: active
Updated: 2026-09-04
Mode: sequential

## Active generation

- `g03`
- Runway: `g03/README.md`
- Active milestone: `g03.001`
- Approved frontier: card 130; cards 131 and 132 become concurrent-ready after
  card 130 merges

## Generation log

| Generation | State | Boundary | History disposition |
| --- | --- | --- | --- |
| `g01` | closed | Internal Northstar-on-Northstar foundation | card 130 roll-up pilot |
| `g02` | closed | External proof and execution hardening | card 131 roll-up |
| `g03` | active | Compact default lifecycle and protocol reduction | expanded active generation |

## Rollover rule

Open a generation when the sequencing baseline materially changes. Close the
old generation by promoting durable meaning, rehoming unresolved commitments,
and removing its execution authority. Keep only the active sequential
generation expanded; compact closed generations under `archive/` after the
preservation oracle in spec 038 passes.

## Next task

Dispatch `g03.001/130` from the planning commit that opened `g03`.
