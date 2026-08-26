# Add Rust Explicit Audit And Repair

Date: 2026-08-25
Roadmap: `g02.030`
Card state: `g02.030/086` complete; `g02.030/087` ready

## Outcome

- added explicit-only Rust audit routing and the thin
  `/northstar-rust-audit` adapter inside the single Northstar skill;
- added separate worktree and repository scope rules, three deliberate review
  passes, finding-first assessment, coherent repair waves, and pre-mutation
  scope extension;
- added the Effigy-native `northstar/rust-quality:record` lifecycle: `init`,
  `assess`, `extend`, `complete`, and `finalize`;
- bound every changed file to a disjoint assessed unit, prior local finding,
  approved action, pre-mutation plan, and passing validation evidence;
- made dirty-state preservation mechanical: initialization fingerprints every
  pre-existing dirty file, and finalization rejects edits to excluded dirty
  files;
- retained strict unsafe/FFI as report-only, slop as
  evaluation-only/report-only, and compatibility-policy mutation as an
  operator decision.

## Deterministic Evidence Boundary

The recorder derives authority from the canonical catalogue, reads and hashes
the repository's strict profile and deviations, and rejects:

- unsupported profiles and undisposed dirty files;
- overlapping unit ownership and cross-unit finding locations;
- unsafe, slop-only, or MSRV-policy repair plans without authority;
- mutation before assessment or scope extension;
- changed files outside an exact applied-repair attribution;
- repair files outside their pre-mutation plan;
- applied repairs without passing local validation;
- changed profile/deviation policy or excluded dirty files at finalization.

It launches no Git, Cargo, shell, package manager, language runtime, Bun, or
`jq` process. Scope and native validation are resolved by the explicit mode;
the recorder only validates supplied records against file and policy state.

## Focused Cases

The recorder self-test passes three positive paths and ten negative paths:

- worktree repair with an unchanged unrelated dirty file and pre-mutation scope
  extension;
- clean repository scope covering the declared manifest and Rust sources;
- operator-owned MSRV policy stop with a derived limitation;
- profile, ownership, dirty-scope, cross-unit, unsafe, slop, MSRV authority,
  temporal mutation, validation, and preservation rejections.

An installed-like public CLI specimen completed `init -> assess -> mutate ->
complete -> finalize`. Its result contained one finding, one repair,
`src/lib.rs` as the exact changed scope, verified preservation, and no remaining
limitations.

## Context And Payload

Relative to card 085, shared Northstar entry surfaces grew by 665 bytes:

- `SKILL.md`: 8,509 to 8,847 bytes (+338);
- router: 11,845 to 12,172 bytes (+327).

The explicit route loads on demand:

- audit mode: 5,005 bytes;
- recorder input contract: 3,892 bytes;
- strict audit projection: 18,055 bytes.

That is 26,952 bytes only for an explicit audit. The 52,920-byte recorder is
executable inert payload and is not loaded as agent instructions. The command
adapter is 708 bytes.

## Validation

- JSON parse over the Rust package and consumer configs — passed;
- skill-creator validation in source and isolated copy — passed;
- `effigy check:rust-quality` — passed with seven explicit/everyday routing
  cases and schema/authority/context invariants;
- `effigy test:rust-quality-recorder` — passed: three positive and ten negative
  paths;
- installed-like recorder and package checks with `PATH=/bin` — passed;
- installed-like public operation lifecycle — passed;
- `effigy check:skill-install <isolated-copy>` — passed for 75 files;
- `effigy check:command-skills` — passed for eight thin adapters;
- `git diff --check`, `effigy qa:docs`, `effigy qa`, and
  `effigy check:posture-advisory` — passed.

## Remaining Limits

- focused deterministic checks are implementation evidence, not the fresh
  blinded production-behavior evidence required by card 087;
- ordinary, high-assurance, combined-default, observable-compaction,
  certification, NASA-grade, and safety-case claims remain unsupported;
- a repository audit is complete only when its supplied inventory covers every
  declared Rust surface. The recorder proves ownership and attribution, not
  semantic completeness of an agent-built inventory.

## Continuation State

Card 086's lane budget is exhausted. Card 087 is ready but does not auto-start
in this run. Pause signal: `budget-exhausted`.
