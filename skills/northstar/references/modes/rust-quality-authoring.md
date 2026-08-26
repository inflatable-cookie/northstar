# Rust Quality Everyday Authoring

Use only for ordinary Rust writing, review, or refactoring in a repository whose
applicable instructions activate Northstar Rust quality. This mode guides the
current task; it does not authorize an audit of the worktree or repository.

## Resolve before editing

1. Read the applicable repository instructions and
   `docs/contracts/rust-quality-profile.json`. Require language `rust` and
   profile `strict`; stop if the file is absent, unsupported, or ambiguous.
2. Read the declared Cargo manifests and explicit toolchain policy paths.
   Resolve the effective MSRV per package. Never infer a universal version;
   stop on a version-sensitive choice when policy is unsettled.
3. Read `docs/contracts/rust-quality-deviations.json` plus relevant project
   architecture and error/API policy. Existing deviations are evidence, not
   permission to broaden their scope.
4. Capture initial repository state and the files the task may change. Preserve
   pre-existing and unrelated work.
5. Use `effigy tasks` when repository-native validation selectors are unknown.
   Do not invent a universal Cargo command graph.

## Load only applicable rules

Open only the matching files under
`../language-quality/rust/authoring/`:

| Trigger | Rule reference |
| --- | --- |
| new or materially changed function, module, control flow, or abstraction | `rust-read-001.json` |
| new or changed public type or public API traits | `rust-api-001.json` |
| fallibility, untrusted input, panic-capable operation, assertion, or indexing | `rust-err-001.json` |
| unsafe operation, raw pointer, unsafe API, or FFI boundary | `rust-unsafe-001.json` |
| async code, suspension, blocking lock, cancellation, or shared state | `rust-async-001.json` |
| version-sensitive syntax, API, lint, dependency, edition, or toolchain choice | `rust-msrv-001.json` |
| a newly introduced or materially changed pass-through wrapper | `rust-slop-001.json` |

Do not load `strict-audit.json` or the audit procedure. `RUST-SLOP-001` is only
a candidate signal and never authorizes a change. Strict unsafe/FFI quality
findings are report-only; do not alter an existing boundary merely to satisfy
this pack. A separately applicable approved rule and the user's task must supply
any mutation authority.

## Work and closeout

- Implement the smallest coherent change that satisfies the task, selected
  rules, repository architecture, and protected behavior.
- Before each coherent batch ends, re-open this mode and the same applicable
  rule files. Review the entire task-attributable changed tranche plus direct
  callers, tests, docs, and contracts needed to establish correctness.
- Compress the final diff after correctness is established. Keep each changed
  line, derive, trait implementation, branch, and helper only when it carries a
  task requirement, governing invariant, or necessary diagnostic responsibility.
- Do not scan, format, lint-fix, or rewrite unrelated repository code.
- Resolve every applicable rule as compliant, a concrete finding repaired under
  existing authority, an accepted recorded deviation, report-only, or blocked.
- Run the repository-native focused validation first, then its normal broader
  closeout selector when proportionate. Record selectors and outcomes.
- Report changed scope, applicable rules, deviations or blockers, validation,
  and remaining limitations.

Re-entry at task start and coherent batch closeout is the retention mechanism.
Do not claim that it proves behavior across runtime context compaction.
