# Add Posture Advisory Effigy Checks

Roadmap refs: g02.021  
Governing refs: docs/contracts/001-working-rules.md,
bundle-docs/sections/10-automation-runtime-policy.md

## What changed

- Added `scripts/check-northstar-posture-advisory.ts`: advisory-only checks
  (always exit `0`) for generation-index vs `docs/roadmaps/gNN/`, specs archive
  README when numbered `docs/specs/NNN-*.md` exist, and empty `batch-cards/`
  folders.
- Wired **`effigy check:posture-advisory`** in `effigy.toml` (not part of `qa` /
  `qa:docs` so baseline repos stay quiet).
- Documented semantics and smoke examples in `scripts/README.md`, root
  `README.md`, `AGENTS.md`, `bundle-docs/cheat-sheet.md`,
  `bundle-docs/protocol-kernel.md`, and `bundle-docs/sections/10-automation-runtime-policy.md`.

## Validation

```text
$ effigy check:posture-advisory
Northstar posture advisory checks: OK (0 warnings)

$ effigy qa && effigy qa:docs
Northstar bundle checks: OK
Northstar repo contract checks: OK
```

Smoke (temporary trees): missing active `gNN/` dir and missing
`docs/specs/archive/README.md` with numbered specs each emit one
`[northstar:advisory]` line (see `scripts/README.md`).

## Next task

Run `effigy check:posture-advisory` (or `effigy --repo <PATH> check:posture-advisory`
when Effigy supports it) on the next strict consumer repo and open a new `g02`
milestone if findings warrant more than local triage.
