# 017 - Formalize Nested Docs-Authority Setup

Status: complete
Owner: repo maintainers
Created: 2026-04-10
Depends on: g02.016
Vision tags: `setup`, `docs-authority`, `strict-migration`, `effigy`
Governing refs: `docs/contracts/001-working-rules.md`, `docs/specs/020-formalize-nested-docs-authority-setup.md`
Planning state: complete

## Problem

Northstar can recover and strict-upgrade nested docs-authority repos, but the
reusable package still treats them as adaptations rather than a first-class
setup mode. That shows up as repeated manual Effigy task fixes and repo-local
special casing during migrations.

## Goals

- [x] identify nested docs-authority repos as a recurring setup mode
- [x] promote that mode into doctrine, setup guidance, and templates
- [x] leave Northstar with one copy-ready nested-authority native Effigy template

## Execution Plan

### Batch 17.1 - Promote Nested Docs-Authority Support Into Setup

- [x] close the cohort lane with the setup lesson captured
- [x] update doctrine and template-bundle guidance for nested docs-authority repos
- [x] update `northstar-setup` and templates for nested native Effigy validation

## Acceptance Criteria

- [x] nested docs-authority repos are a first-class setup mode in the package
- [x] setup docs explain how to wire native docs checks for nested authority roots
- [x] the next migration should not need bespoke nested Effigy task repair

## Next Task

Open the follow-on specimen lane so workspace-container adoption has one
concrete reusable example instead of doctrine alone.
