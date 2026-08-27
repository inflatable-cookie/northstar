# 033 - Apply Language Quality Live-Use Corrections

Status: complete
Owner: repo maintainers
Created: 2026-08-27
Depends on: `g02.031`, `g02.032`, contract `004-language-quality-pack`
Vision tags: `language-quality`, `dogfood`, `distribution`, `tool-enforcement`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`bundle-docs/skills/README.md`, Jetstream PR 2 live-use report
Planning state: card 100 complete

## Problem

Jetstream exercised both explicit audits in a large mixed Rust, TypeScript, and
Svelte repository. It found useful Rust work, but also exposed three product
failures: nested audit adapters were present but not activatable, the TypeScript
recorder could not honestly retain a review-required finding, and Rust named a
forwarder scanner that the skill did not install or capture.

## Goals

- [x] make every thin command adapter a real Skills CLI entry while preserving
  one canonical package and router;
- [x] let TypeScript audits retain review-required findings without fake plans
  or mutation;
- [x] install and capture pinned `stopslop` forwarder evidence through Cargo;
- [x] keep the new scanner out of everyday Rust authoring;
- [x] prove package checks, full QA, and clean consumer installation.

## Non-goals

- no second language-quality authority or duplicated audit procedure;
- no heuristic repair authority from `stopslop`;
- no always-loaded catalogue, scanner, or audit context;
- no consumer-repository mutation, release mutation, or assurance claim.

## Execution plan

Card `g02.033/100` applies the three live-use corrections as one bounded batch,
adds deterministic regression coverage, reproves the full package, and updates
the published install path.

## Acceptance criteria

- [x] a clean full-depth install lists `northstar`,
  `northstar-rust-audit`, and `northstar-typescript-audit` as activatable skills;
- [x] `review_required` plus `reported` finalizes without a repair plan, mutation,
  or dishonest completion record;
- [x] `stopslop 0.5.1` is agent-installed, version-checked, invoked by absolute
  path, parsed into immutable evidence, and mapped as evaluation-only;
- [x] scanner absence is a structured limitation and scanner findings never
  authorize repair;
- [x] ordinary Rust routing and context remain unchanged and scanner-free;
- [x] focused checks, full QA, docs QA, and consumer install proof pass.

## Next task

Lane complete. Accept the next operator-provided live-use report; do not dispatch
a consumer audit or broaden language-quality authority without new evidence.
