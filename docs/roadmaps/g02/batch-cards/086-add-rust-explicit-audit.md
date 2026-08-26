# 086 - Add Rust Explicit Audit And Repair

Status: complete
Owner: repo maintainers
Updated: 2026-08-25
Master spec refs: `docs/specs/031-rust-quality-authoring-and-audit.md`
Roadmap ref: `g02.030`
Governing refs: `docs/contracts/004-language-quality-pack.md`, cards 083-085
Auto-start next card: no

## Ready-State Checks

- [x] Cards 084 and 085 supply one checked strict catalogue and separate
      everyday routing.
- [x] Explicit audit intent is reserved and cannot degrade into everyday mode.
- [x] Recorder, mode, adapter, record-root, and lifecycle paths are frozen.
- [x] Worktree/repository scope and action-specific authority are settled by
      contract 004 and card 083.
- [x] The card excludes blinded production evidence and distribution work.

## Objective

Add the explicitly triggered Rust audit-and-repair mode, deterministic local
record workflow, and thin `/northstar-rust-audit` adapter.

## Scope

- explicit natural-language and command routing only;
- worktree and repository scope resolution;
- dirty-state snapshot and preservation;
- correctness/assurance, architecture, and human-quality passes;
- findings before mutation, coherent repair waves, scope widening, deviations,
  and completion evidence;
- frozen deterministic recorder path from card 083;
- strict report-only unsafe/FFI and evaluation-only/report-only slop.

## Frozen Integration

- mode: `skills/northstar/references/modes/rust-quality-audit.md`;
- thin adapter: `skills/northstar/commands/northstar-rust-audit/SKILL.md`;
- shared view: `skills/northstar/references/language-quality/rust/strict-audit.json`;
- recorder: `skills/northstar/scripts/rust-quality-recorder.rhai`, exposed as
  `northstar/rust-quality:record`;
- record root: `<target>/.effigy/rust-quality/audits/<audit-id>/`;
- lifecycle: `init`, `assess`, `complete`, `finalize`; add a pre-mutation
  `extend` operation for justified ownership-scope widening;
- an assessed unit owns a non-empty, disjoint `owned_files` set and exact
  finding locations; final changes must be a subset of that set.

Invocation uses
`effigy --repo <installed-northstar> northstar/rust-quality:record <operation>`.
The recorder must not launch Cargo, Git, Bun, `jq`, or another shell utility.

## Implementation Steps

1. Add explicit audit routing and the thin command adapter.
2. Implement worktree/repository scope resolution and dirty-state capture.
3. Wire finding-first local records through the frozen deterministic recorder.
4. Implement the three review passes and coherent repair-wave checkpoints.
5. Exercise scope widening, deviations, report-only preservation, operator stops,
   final assembly, and completion reporting.

## Acceptance Criteria

- [x] Audit cannot activate from ordinary Rust coding alone.
- [x] Worktree scope includes staged, unstaged, and relevant untracked files;
      repository scope covers all declared Rust surfaces.
- [x] Every mutation has a prior local finding and effective repair authority.
- [x] Final assembly rejects cross-unit evidence and hidden mutation.
- [x] Missing external policy, breaking API, architecture, and MSRV policy
      decisions stop before mutation.
- [x] The command adapter contains no duplicate audit procedure.

## Validation

Run routing and scope fixtures, recorder negative tests, report-only preservation
tests, command-surface checks, docs QA, full QA, and installed parity.

## Evidence

Record clean and dirty worktree fixtures, both scope modes, repair-wave output,
negative authority cases, adapter budget, and parity.

## Stop Conditions

- stop if audit becomes implicit;
- stop if repository scope authorizes unbounded rewrite or blanket fixing;
- stop if evidence construction depends on agent bookkeeping alone;
- stop before any operator-owned mutation.

## Next Task

Card 087 is ready. Stop at the card 086 lane budget before running the cohort.
