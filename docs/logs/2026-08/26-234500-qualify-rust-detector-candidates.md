# Qualify Rust Detector Candidates

Date: 2026-08-26
Roadmap: `g02.032/097`
Status: complete

## Changed

- classified 14 finite detector candidates by decidability, false-positive
  class, evidence, and disposition;
- promoted five exact upstream diagnostic groups as enforcement or evidence
  signals under existing rules;
- retained contextual semantics as evaluation-only, manual, or rejected;
- added dual-toolchain valid, invalid, and exception fixtures;
- added checked mapping dispositions and negative authority tests;
- added no custom detector, normative rule, repair authority, or always-loaded
  context;
- made card 098 ready without starting production evidence.

## Evidence

- 19 Cargo integration cases pass on Rust 1.95 and current Rust;
- pedantic Clippy passes with `-D warnings` on both toolchains;
- locked offline install and exact payload verification pass;
- Rust package check and repository QA are recorded in report E.

## Next task

Execute ready card `g02.032/098` as a separate bounded batch. Run fresh isolated
production evidence against the frozen v2 payload; do not distribute it yet.
