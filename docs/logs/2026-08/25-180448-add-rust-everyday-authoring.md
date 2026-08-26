# Add Rust Everyday Authoring

Date: 2026-08-25
Roadmap: `g02.030`
Card state: `g02.030/085` complete; `g02.030/086` ready

## Outcome

- added repository-activated Rust writing, review, and refactoring to the
  central router and single Northstar skill;
- added one compact everyday-authoring mode with strict-profile resolution,
  repository-derived MSRV, task-start and batch-closeout re-entry, and
  repository-native validation discovery;
- split the checked authoring projection into seven trigger-selected rule
  references without creating a second catalogue;
- added copy-ready scoped instructions plus strict profile and deviation
  templates, with matching Northstar consumer copies;
- reserved audit, no-slop pass, whole-repository review, and audit-and-fix
  intent for the explicit route. Unavailable audit cannot fall back to everyday
  authoring;
- extended the Effigy-native package check with six routing cases, six workflow
  cases, selective-reference parity, profile/deviation checks, and context
  ceilings.

## Routing And Retention

Everyday activation requires both an applicable repository instruction and a
Rust writing, review, or refactoring task. Unactivated Rust work, non-Rust work,
and explicit audit intent select other routes. The retention mechanism is
deliberate re-entry at task start and coherent-batch closeout. It does not claim
survival across an unobservable runtime compaction boundary.

Closeout reviews the whole task-attributable tranche plus direct callers,
tests, docs, and contracts needed for correctness. It forbids unrelated scans,
blanket formatting, lint fixing, and rewrites. Unsafe/FFI and prototype slop
authority remain report-only.

## Context Measurement

Card 084 baselines were 8,193 bytes for `SKILL.md` and 11,264 bytes for the
router. Card 085 results are 8,509 and 11,845 bytes: a 897-byte total increase
to the shared Northstar entry surfaces.

Repository activation adds a 947-byte scoped `AGENTS.md`. Once the Rust route
is selected, the mode is 3,316 bytes and each applicable rule reference is
1,672 to 2,247 bytes. All seven selective references total 13,679 bytes. The
route does not load the 15,327-byte complete authoring projection or the
18,055-byte audit projection.

## Validation

- `effigy check:rust-quality` — passed: seven rules, six negative paths, six
  routing cases, and six authoring-workflow cases;
- source and isolated-copy skill-creator validation — passed;
- standalone copied skill check with `PATH=/bin` — passed without an undeclared
  helper runtime;
- `effigy check:skill-install <isolated-copy>` — passed for 71 files;
- `effigy check:command-skills` — passed for seven existing adapters;
- `effigy check:agent-instructions` — completed with only existing advisory
  classifications;
- `git diff --check`, `effigy qa:docs`, `effigy qa`, and
  `effigy check:posture-advisory` — passed.

## Remaining Limits

- explicit audit routing, recorder, command adapter, repair waves, and final
  audit evidence remain card 086 work;
- ordinary, high-assurance, combined-default, observable-compaction, and
  certification claims remain unsupported;
- Northstar itself declares no Rust Cargo roots, so its consumer profile stops
  rather than inventing an MSRV until a real Rust scope is declared.

## Continuation State

Card 085's lane budget is exhausted. Card 086 is ready but does not auto-start
in this run. Pause signal: `budget-exhausted`.
