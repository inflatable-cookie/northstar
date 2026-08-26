# Rust Quality Explicit Audit And Repair

Use only when the operator explicitly requests a Rust quality audit, no-slop
pass, or audit-and-fix action. This mode may repair recorded findings inside the
resolved scope. Ordinary Rust coding never selects it.

Load the strict audit projection at
`../language-quality/rust/strict-audit.json` and the recorder contract at
`../language-quality/rust/audit-recording.md`. Do not load the everyday
authoring projection.

## Resolve before mutation

1. Read applicable repository instructions,
   `docs/contracts/rust-quality-profile.json`, and
   `docs/contracts/rust-quality-deviations.json`. Require production-valid
   `strict`. Resolve every declared Cargo manifest, toolchain policy path,
   exclusion, and effective MSRV. Stop on unresolved version policy.
2. Resolve scope from explicit intent:
   - **worktree** for current, uncommitted, staged, unstaged, tranche, or diff
     requests;
   - **repository** for whole repository, codebase, workspace, or all-crates
     requests.
   Ask when neither meaning is safely recoverable.
3. Use read-only Git state to inventory staged, unstaged, deleted, and relevant
   untracked files. Worktree scope includes relevant Rust source, manifests,
   build files, tests, and directly affected docs. Give every dirty file an
   in-scope or explicitly excluded disposition.
4. For repository scope, inventory all declared workspace members, packages,
   targets, feature surfaces, public APIs, unsafe/FFI and async boundaries,
   tests, build files, and governed docs. Apply only repository-declared
   generated/vendor exclusions. A repository audit is full coverage, not
   blanket rewrite authority.
5. Read project architecture and error/API policy. Record a missing foreign
   error-signaling policy as `change_foreign_error_policy`; its authority is
   `operator_decision`. Breaking API choices, architecture replacement, and
   compatibility-policy changes are also operator decisions. Record and report
   them; stop before mutation.
6. Partition scope into non-empty assessed units with disjoint `owned_files`.
   Capture the initial dirty state and initialize the deterministic recorder
   before recording findings or editing files.

The recorder hashes scope, repository policy, accepted deviations, and all
pre-existing dirty files. It rejects overlapping units and undisposed dirty
files. It launches no Git, Cargo, package manager, language runtime, or shell.

## Assess before editing

For every unit, run three distinct passes:

1. **Correctness and assurance:** failure paths, panics, unsafe/FFI contracts,
   async suspension and cancellation, MSRV, invariants, and repository-native
   mechanical evidence.
2. **Architecture:** responsibility boundaries, public API semantics, coupling,
   unnecessary indirection, and consistency with repository policy.
3. **Human quality:** naming, direct control flow, cognitive load, local
   reasoning, comments, and justified abstractions.

Mechanical tools supply leads and evidence; inspect source and direct call paths
before creating a finding. Record exact file plus symbol or line span, evidence,
action, confidence, disposition, and effective authority. Record the complete
unit assessment before any mutation.

- `report_only`: report; never create a repair plan.
- `review_required`: create a bounded plan naming owned files and protected
  behavior, then repair only under that plan.
- `operator_decision`: record the stop and do not mutate.
- accepted deviation: use only an exact repository-owned deviation record.
- `RUST-SLOP-001`: evaluation-only/report-only. Build a total candidate ledger;
  every exact-forwarder candidate needs a recorded `report_only` or `retain`
  disposition. Apply `RUST-READ-001` independently: public visibility alone is
  not a stable façade without a documented boundary or concrete repository
  evidence. It never authorizes repair.
- `RUST-UNSAFE-001`: mandatory assessment, report-only repair authority.

## Repair in coherent waves

- Treat one assessed unit as one coherent repair wave. Make the smallest change
  that resolves its approved findings while preserving named behavior.
- If a repair must include a direct caller, test, doc, or contract outside the
  unit, run `extend` before editing. The recorder rejects late or cross-unit
  extension.
- Never run blanket formatting, blanket lint fixing, unrelated cleanup,
  architecture replacement, or interface breakage. Format only files already
  changed by an authorized repair, never an entire unit, package, or worktree.
- Units with only `report_only`, `blocked`, `retain`, deviation, or no-finding
  outcomes must remain byte-for-byte identical. Verify their initial hashes
  before completing the wave.
- Run focused repository-native validation for the wave. Complete the unit with
  exact changed-file attribution and validation evidence before moving on.
- On failed validation, repair within existing authority or revert only the
  audit's own wave. Never discard pre-existing user work.

## Finalize and report

Finalize only after every unit is completed. The recorder reconstructs the
result from unit-local records and rejects hidden mutation, cross-unit
attribution, changed policy, or modification of excluded dirty files.

Report workflow and profile, resolved scope, catalogue hash, findings and
dispositions, repair waves, deviations, changed scope, scope extensions,
preservation proof, native validation, operator stops, and remaining
limitations. A completed audit is not certification, NASA compliance, a safety
case, high-assurance validation, or proof of context-compaction resilience.
