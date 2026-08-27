# 100 - Apply Language Quality Live-Use Corrections

Status: complete
Owner: repo maintainers
Updated: 2026-08-27
Roadmap ref: `g02.033`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`bundle-docs/skills/README.md`, Jetstream PR 2 live-use report
Auto-start next card: no

## Objective

Correct the three blocking failures from Jetstream's mixed-repository audit
without increasing always-loaded context or inventing repair authority.

## Scope

- full-depth Skills CLI distribution for the front door and thin adapters;
- TypeScript recorder retained/report-only completion for locally reviewable
  findings;
- pinned audit-only `stopslop` installation and evidence parsing;
- focused regression checks, full QA, consumer install proof, and closeout docs;
- no consumer changes, release mutation, or unrelated language-rule expansion.

## Acceptance criteria

- [x] published installation surfaces all named adapters;
- [x] TypeScript retained findings need no fake repair plan;
- [x] the final TypeScript result names retained work as a limitation;
- [x] Rust forwarder scanning uses pinned tool output, not prose or ad-hoc grep;
- [x] scanner JSON maps only to evaluation evidence;
- [x] the scanner is absent from everyday authoring activation;
- [x] source checks, skill validation, full QA, and clean install proof pass.

## Validation

Run the Rust engine test suite and format check; TypeScript recorder and package
checks; Rust package and command-surface checks; skill validation; `effigy qa`;
`effigy qa:docs`; diff checks; and a disposable full-depth Skills CLI install.

## Stop conditions

- stop if a named adapter requires duplicated canonical procedure;
- stop if retained TypeScript findings can hide mutation;
- stop if scanner installation is unpinned or mutates the consumer repository;
- stop if scanner findings gain repair authority;
- stop before release or consumer-repository mutation.

## Next task

Lane complete. Accept operator-provided live-use feedback.
