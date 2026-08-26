# 083 - Prove Rust Quality Production Boundary

Status: complete
Owner: repo maintainers
Updated: 2026-08-25
Master spec refs: `docs/specs/031-rust-quality-authoring-and-audit.md`
Roadmap ref: `g02.030`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`docs/contracts/003-agent-instruction-surface.md`,
`bundle-docs/skills/README.md`
Auto-start next card: no

## Ready-State Checks

- [x] Contract 004 and the initial strict catalogue are active.
- [x] Revisions F and M provide valid replicated evidence for both required
      workflows.
- [x] The one-installable-skill and compact-context boundaries are current.
- [x] The unresolved work is a bounded technical portability decision, not
      operator-owned product intent.
- [x] Evaluation criteria, evidence, and stop conditions are explicit.

## Objective

Prove and freeze the smallest portable production boundary for the Rust quality
catalogue, projections, consumer profile, and deterministic case-local audit
recorder before any production mode or command is scaffolded.

## Scope

- compare a skill-local Effigy/Rhai implementation, the repo-default Bun and
  TypeScript path, and the retained shell/`jq` approach only against concrete
  portability and determinism requirements;
- require no undeclared consumer dependency and no Northstar-source checkout;
- freeze paths for the shared catalogue, schemas, projections, recorder, modes,
  activation template, and audit adapter;
- freeze strict profile resolution, repository-owned MSRV/exclusion/deviation
  inputs, and unsupported-profile failure behavior;
- exercise init, pre-mutation assessment, post-mutation completion, final
  assembly, cross-unit rejection,
  unattributed-mutation rejection, and action-override resolution on disposable
  fixtures;
- record the decision in architecture/roadmap authority, not only a prototype
  note.

## Implementation Steps

1. Create one disposable consumer-like Rust repository and dependency inventory.
2. Build the minimum init/record/finalize probe for each viable runtime path.
3. Run the same positive and negative record cases against each candidate.
4. Select the smallest path that satisfies portability, determinism, and skill
   distribution constraints; record why the others fail.
5. Freeze payload paths, profile resolution, commands, and adapter name in the
   roadmap authority and make downstream cards exact.

## Acceptance Criteria

- [x] One runtime path works from the installed `northstar` skill against a
      consumer-like temporary repository.
- [x] The path needs only declared Northstar/Effigy prerequisites or records an
      explicit install requirement suitable for the product contract.
- [x] Local records deterministically bind rule, scope, disposition, mutation,
      and validation evidence before final assembly.
- [x] Negative tests reject cross-unit evidence, unattributed mutation,
      report-only repair, slop-only repair, and MSRV policy mutation without an
      operator decision.
- [x] The production payload and public adapter paths are frozen without adding
      a second installable skill.
- [x] Cards 084 through 088 are updated with exact paths, commands, and
      dependencies before any becomes ready.

## Validation

- focused disposable-repository recorder tests;
- production-payload link and dependency inventory;
- prototype `trial-runner.sh check` and `self-test` remain green;
- `git diff --check`;
- `effigy qa:docs`;
- `effigy qa`.

## Evidence

See `docs/logs/2026-08/25-172511-prove-rust-quality-production-boundary.md` and
`bundle-docs/research/prototypes/rust-quality/production-boundary/README.md`.

## Stop Conditions

- stop if no candidate satisfies deterministic case-local assembly without an
  undeclared consumer dependency;
- stop if the selected shape needs a second installable skill;
- stop if consumer profile or deviation semantics contradict contract 004;
- stop and ask if candidates are materially tied after the bounded proof.

## Next Task

Card 084 is ready with the frozen paths. The card-083 continuation envelope and
Batch 30.1 lane budget are exhausted; do not auto-start implementation.
