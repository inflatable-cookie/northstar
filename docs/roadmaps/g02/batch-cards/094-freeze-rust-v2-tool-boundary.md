# 094 - Freeze Rust V2 Tool Boundary

Status: complete
Owner: repo maintainers
Updated: 2026-08-26
Master spec refs: `docs/specs/033-rust-audit-v2-tool-enforcement.md`
Roadmap ref: `g02.032`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`docs/contracts/003-agent-instruction-surface.md`,
`bundle-docs/skills/README.md`
Auto-start next card: no

## Ready-state checks

- [x] Convergence evidence identifies the scope and completeness failures.
- [x] Contract 004 owns anchor scope, unit-rule verdicts, attestations, tool
  evidence, structured limitations, and authority boundaries.
- [x] Spec 033 separates deterministic enforcement from agent judgment.
- [x] The work is a bounded portability and interface proof with no production
  payload mutation.
- [x] Acceptance, validation, evidence, and stop conditions are explicit.

## Objective

Prove and freeze the smallest Cargo-native Rust v2 tool boundary before changing
the distributed recorder or skill procedure.

## Scope

- compare raw Cargo instructions, a skill-shipped crate, a managed Cargo
  subcommand, repository-local xtask, Effigy bundle, and custom-lint options;
- prove automatic locked installation into a Northstar-owned cache without
  global PATH or Cargo-state mutation;
- prove root and nested mixed-repository Cargo discovery;
- freeze command names, paths, input/output schemas, lifecycle transitions, and
  version compatibility;
- freeze dirty-anchor discovery, context-relation, unit ownership, applicable-
  rule ledger, three-pass attestation, and structured-limitation shapes;
- define raw diagnostic preservation and failure stages for compiler, lint,
  docs, test, and optional graph/scanner evidence;
- define the lightweight shared evidence seam available to everyday
  changed-tranche closeout without loading explicit-audit instructions;
- build focused positive and negative prototype fixtures outside the
  production payload.

## Acceptance criteria

- [x] the chosen boundary needs only Cargo and Git; it needs no Effigy, Node,
  Bun, JavaScript package manager, `jq`, Northstar source checkout, or human
  installation;
- [x] the same installed binary discovers root Rust and nested Rust inside a
  mixed repository;
- [x] worktree scope generation rejects an empty Rust-anchor set and unowned or
  relation-free context;
- [x] repository scope alone can claim full workspace coverage;
- [x] ledger finalization rejects missing, duplicate, contradictory, and
  evidence-free rule verdicts plus empty review attestations;
- [x] tool failures and warnings cannot become clean source evidence;
- [x] custom detectors remain optional candidates and cannot authorize repair;
- [x] router, everyday mode, and explicit mode stay within current context
  budgets.

## Validation

Run focused prototype fixtures, `effigy qa:docs`, `effigy qa`,
`effigy check:posture-advisory`, and `git diff --check` after the batch.

## Evidence

Record the evaluated runtime options, selected task split, commands, schemas,
failure semantics, fixture matrix, rejected alternatives, context-size impact,
and next-card readiness in a bounded production-boundary report and closeout
log.

## Stop conditions

- stop on an undeclared consumer runtime or mandatory third-party dependency;
- stop if scope discovery needs mutation or cannot preserve dirty state;
- stop if a detector output is indistinguishable from a reviewed finding;
- stop if the design duplicates the catalogue or expands always-loaded context;
- do not edit the production Rust recorder, projections, mode, or install copy.

## Next task

Card 095 is ready with the frozen interfaces. Do not auto-start it.

## Completion evidence

- rejected the separate Effigy/Rhai task split after operator review exposed
  the installed-catalogue/consumer-root mismatch;
- selected one locked Rust 1.95 CLI crate, automatic payload-addressed managed
  installation, and absolute-path invocation;
- passed root-workspace, nested mixed-repository, and anchorless-worktree CLI
  cases plus format and strict Clippy;
- installed the locked crate into an isolated cache root and invoked it without
  PATH mutation;
- retained report A's ledger, attestation, evidence, detector-authority,
  structured-limitation, and context-budget semantics;
- bounded report:
  `bundle-docs/research/prototypes/rust-quality/rust-v2-boundary-report-2026-08-26-b.md`.
