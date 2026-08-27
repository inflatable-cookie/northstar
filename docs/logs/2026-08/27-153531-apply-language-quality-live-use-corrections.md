# Apply Language Quality Live-Use Corrections

Date: 2026-08-27
Status: complete

## Changed

- replaced the false nested-adapter discovery assumption with one full-depth
  package install that surfaces the front door and all nine thin adapters;
- added a TypeScript `review_required` plus `reported` path that finalizes
  without a repair plan or mutation and remains visible as a limitation;
- pinned `stopslop 0.5.1` as an agent-owned, audit-only Cargo installation;
- taught the Cargo-native Rust evidence engine to parse scanner JSON, retain raw
  output, and map `SLOP039` to evaluation-only `RUST-SLOP-001` evidence;
- kept the scanner outside everyday Rust activation and preserved the existing
  routed, on-demand context boundary;
- excluded the Rust tool's declared Cargo build cache from source/install
  parity after the published install exposed generated-state drift.

## Evidence

- Jetstream PR 2 supplied the mixed-repository live-use report and all three
  blocking findings;
- a disposable consumer install listed `northstar`, `northstar-rust-audit`, and
  `northstar-typescript-audit` as separate project skill entries;
- a pinned Cargo install produced `stopslop 0.5.1` and emitted structured
  `SLOP039` JSON for a Rust exact-forwarder fixture;
- Rust parser tests cover valid mapping and malformed scanner output;
- the TypeScript recorder self-test covers retained review-required findings.

## Validation

- Rust engine: 22 tests passed, including 3 scanner parser tests;
- TypeScript recorder and package checks passed;
- Rust package and command-surface checks passed;
- main and explicit audit skill validation passed;
- `effigy qa` and `effigy qa:docs` passed;
- clean full-depth consumer install and skill inventory passed.

## Result

The explicit entrypoints are now installable contracts rather than nested files
that only some routers can see. TypeScript can report an honest no-repair audit,
and Rust has the tool-backed forwarder candidate surface its rule already
claimed. No scanner or audit payload enters ordinary authoring context.
