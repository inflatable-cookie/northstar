# Automation Runtime Policy

Status: active
Updated: 2026-04-08

## Purpose

Keep Northstar repo automation coherent by using a clear runtime hierarchy
instead of letting Bash, Python, and TypeScript accumulate without intent.

## Default Runtime Stack

Northstar should prefer this order:

1. `effigy` when it already covers the operation
2. `TypeScript` run with `bun` for repo-owned automation logic
3. another runtime only when a concrete technical reason justifies it

## Why

- one main scripting language keeps repo logic easier to read and maintain
- Bun keeps TypeScript scripts lightweight and direct
- Effigy remains the first-choice bootstrap and maintenance layer instead of
  shell scripts becoming a second workflow system

## Exceptions

- `bash` is acceptable only for very thin glue, compatibility boundaries, or
  environment edges that Effigy or Bun/TypeScript cannot express cleanly
- `python` is acceptable only when a required library ecosystem or existing
  owned surface gives a real technical advantage
- every non-TypeScript runtime should have an explicit local reason, not just
  historical drift or convenience

## Setup Impact

Setup guidance should make this hierarchy explicit for new repos:

- reach for Effigy first
- when custom scripts are still needed, default to TypeScript+Bun
- avoid introducing Bash or Python as routine repo automation surfaces

## Repo Impact

Northstar itself should follow the same rule so the published protocol is
credible.

## Quick reference

- [Cheat sheet: Effigy commands](../cheat-sheet.md#effigy-commands)

## Next Task

Keep the setup skill, live repo scripts, and reusable working-rules template
aligned with this runtime hierarchy.
