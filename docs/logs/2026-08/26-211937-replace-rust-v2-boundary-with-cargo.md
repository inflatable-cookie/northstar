# Replace Rust V2 Boundary With Cargo

Status: complete
Date: 2026-08-26
Roadmap: `g02.032`
Card: `g02.032/094`

## What changed

Operator review rejected the skill-local Effigy task split because its selected
catalogue and the consumer repository are different execution roots. The
boundary now uses one Cargo-native binary shipped inside the Northstar skill.
Effigy is optional repository evidence, not the audit host.

A disposable Rust 1.95 prototype now discovers root and nested Cargo workspaces,
captures Git dirty anchors, emits deterministic JSON, and rejects anchorless
worktree scope. The locked crate installed into an isolated cache root and ran
through its absolute path without global PATH changes.

## Evidence

- root and mixed nested-repository integration cases passed;
- anchorless worktree negative case passed;
- format, test, and strict Clippy passed on Rust 1.97.1 and the declared 1.95.0
  floor;
- locked managed installation and absolute invocation passed;
- report:
  `bundle-docs/research/prototypes/rust-quality/rust-v2-boundary-report-2026-08-26-b.md`.

## Next

Execute card 095. Promote the crate into the installed skill and implement
managed bootstrap, scope provenance, and the complete assessment ledger.
