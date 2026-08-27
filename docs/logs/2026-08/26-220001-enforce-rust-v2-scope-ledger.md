# Enforce Rust V2 Scope And Ledger

Date: 2026-08-26
Roadmap: `g02.032/095`
Status: complete

## Changed

- promoted the frozen Cargo prototype into a locked Rust 1.95 production crate;
- added payload verification and agent-owned payload-addressed bootstrap;
- enforced root/nested discovery, anchor/context scope, full repository claims,
  complete normative verdicts, three attestations, findings, authority,
  accepted deviations, and structured limitations;
- added `init -> assess -> extend -> complete -> finalize` file-fingerprint and
  mutation-attribution checks with deterministic result/report generation;
- removed the rejected source Effigy/Rhai recorder route;
- kept the main skill, router, and everyday Rust mode byte-identical;
- made card 096 ready without auto-starting it.

## Evidence

- 14 production CLI integration cases pass on Rust 1.95 and current Rust;
- pedantic Clippy passes with `-D warnings` on both toolchains;
- locked offline Cargo installation and absolute checksum verification pass;
- Rust package check, repository QA, docs QA, posture advisory, skill
  validation, and diff validation recorded in the governing report.

## Research record

`bundle-docs/research/prototypes/rust-quality/rust-v2-scope-ledger-report-2026-08-26-c.md`

## Next task

Execute ready card `g02.032/096` as a separate bounded batch. It adds mechanical
evidence adapters and the compact everyday closeout seam, not detector rules.
