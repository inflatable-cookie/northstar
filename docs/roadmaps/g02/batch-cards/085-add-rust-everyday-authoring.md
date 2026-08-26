# 085 - Add Rust Everyday Authoring

Status: complete
Owner: repo maintainers
Updated: 2026-08-25
Master spec refs: `docs/specs/031-rust-quality-authoring-and-audit.md`
Roadmap ref: `g02.030`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`docs/contracts/003-agent-instruction-surface.md`, card 084
Auto-start next card: no

## Ready-State Checks

- [x] Card 084 promoted one strict-only catalogue and both checked projections.
- [x] The installed payload check passes from source and a standalone copy.
- [x] `SKILL.md` and the router remained unchanged during payload promotion.
- [x] Mode, activation, profile, deviation, and validation paths are frozen.
- [x] The card excludes explicit-audit routing and recorder implementation.

## Objective

Add a compact Rust-authoring mode to the single Northstar skill, with automatic
Rust-task routing, selective references, and a changed-tranche exit check that
re-enters the same catalogue.

## Scope

- router and skill-description activation for Rust writing, review, and
  refactoring;
- one compact everyday mode and domain-selective references;
- copy-ready path-scoped activation and strict-profile instructions;
- task-start and coherent-batch-exit checks;
- repository-native Effigy task discovery without a universal Cargo graph.

## Frozen Integration

- mode: `skills/northstar/references/modes/rust-quality-authoring.md`;
- shared view: `skills/northstar/references/language-quality/rust/strict-authoring.json`;
- activation template: `skills/northstar/assets/templates/language-quality/rust/AGENTS.md`;
- consumer profile templates: `rust-quality-profile.json` and
  `rust-quality-deviations.json` in the same template directory;
- canonical consumer copies: `docs/contracts/rust-quality-profile.json` and
  `docs/contracts/rust-quality-deviations.json`;
- package parity check: `northstar/check:rust-quality`.

## Implementation Steps

1. Add Rust everyday-authoring intent to the central router and skill metadata.
2. Implement the compact mode using the production authoring projection.
3. Add selective domain references and the copy-ready scoped activation surface.
4. Exercise task-start, changed-tranche exit, deviation, and native-validation
   fixtures.
5. Measure instruction size and prove ordinary coding does not route to audit.

## Acceptance Criteria

- [x] Normal Rust coding activates everyday authoring without explicit audit.
- [x] The mode loads only applicable detail and stays within the instruction
      budget defined by contract 003.
- [x] Exit review resolves the full changed tranche, direct correctness surface,
      deviations, and native validation.
- [x] The mode cannot scan or rewrite unrelated repository code.
- [x] Long-context behavior is described as re-entry, not a compaction claim.

## Validation

Run routing fixtures, projection parity, instruction-surface audit, command
checks, bundle/docs QA, and source/install parity.

## Evidence

Recorded in the card closeout log: activation and workflow cases, context
measurements, negative explicit-audit routing, source/install parity, and
repository validation.

## Stop Conditions

- stop if everyday activation requires loading the full audit procedure;
- stop if the route implies repository-wide mutation;
- stop if consumer setup must duplicate the catalogue.

## Next Task

Card 086 is ready. Stop at the card 085 lane budget before implementing it.
