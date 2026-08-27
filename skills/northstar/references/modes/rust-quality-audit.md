# Rust Quality Explicit Audit And Repair

Use only when the operator explicitly requests a Rust quality audit, no-slop
pass, or audit-and-fix action. This mode may repair recorded findings inside the
resolved scope. Ordinary Rust coding never selects it.

Load the strict audit projection at
`../language-quality/rust/strict-audit.json` and the recorder contract at
`../language-quality/rust/audit-recording.md`. Follow
`../language-quality/rust/tool-bootstrap.md` to ensure the current Cargo-native
tool without human installation. Load
`../language-quality/rust/evidence-collection.md` only when resolving or
collecting mechanical evidence. Do not load the everyday authoring projection.

## Resolve before mutation

1. Check for the marked Rust activation block in the applicable `AGENTS.md`,
   `docs/contracts/rust-quality-profile.json`, and
   `docs/contracts/rust-quality-deviations.json`. If any are missing, choose the
   narrowest Rust-owning directory and run
   `effigy --repo <installed-northstar> northstar/rust-quality:setup apply <absolute-target-root> <scope-directory>`.
   Do not ask the operator to copy templates or populate discoverable paths.
   Then require production-valid `strict` and resolve every declared Cargo
   manifest, toolchain policy path, exclusion, and effective MSRV. Stop only on
   unresolved repository policy or conflicting existing setup.
2. Resolve scope from explicit intent:
   - **worktree** for current, uncommitted, staged, unstaged, tranche, or diff
     requests;
   - **repository** for whole repository, codebase, workspace, or all-crates
     requests.
   Ask when neither meaning is safely recoverable.
3. Run the verified tool's `inspect` operation. It uses Git state for staged,
   unstaged, deleted, and untracked worktree evidence and Cargo metadata for
   nested workspaces, packages, targets, features, and MSRV declarations.
   Worktree scope fails closed without a dirty Rust anchor.
4. Build and run the checked `plan` operation. Give every dirty file an owned
   anchor/context or explicitly excluded disposition. For repository scope,
   supply the exact discovered workspace/package/target/feature inventory plus
   explicit public API surfaces and unsafe/FFI, async, and other risk
   boundaries. Full coverage is not blanket rewrite authority.
5. Read project architecture and error/API policy. Record a missing foreign
   error-signaling policy as `change_foreign_error_policy`; its authority is
   `operator_decision`. Breaking API choices, architecture replacement, and
   compatibility-policy changes are also operator decisions. Record and report
   them; stop before mutation.
6. Partition scope into non-empty assessed units with disjoint mutable anchors
   and related read-only context. Run `init` with the discovery, scope plan, and
   installed strict projection before recording findings or editing files.

The Cargo-native engine stores case-local records in repository Git metadata.
It hashes checked scope, policy, mutable files, context, and excluded dirty
files. It rejects stale discovery, overlapping ownership, and undisposed dirt.
It requires Git and Cargo but no consumer Effigy task or global PATH change.

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
   unit, run `extend` before editing. The tool rejects late or cross-unit
  extension.
- Never run blanket formatting, blanket lint fixing, unrelated cleanup,
  architecture replacement, or interface breakage. Format only files already
  changed by an authorized repair, never an entire unit, package, or worktree.
- Units with only `report_only`, `blocked`, `retain`, deviation, or no-finding
  outcomes must remain byte-for-byte identical. Verify their initial hashes
  before completing the wave.
- Resolve and run an explicit checked evidence plan for the wave. Complete the
  unit with exact changed-file attribution and immutable evidence IDs before
  moving on.
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
