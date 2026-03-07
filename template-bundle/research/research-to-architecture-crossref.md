# Research-to-Architecture Cross-Reference

Status: Draft
Owner:
Last updated:
Purpose: Map promoted research findings to architecture documents, identify gaps, and track promotion status.

## How To Use This File

- Add one section per translation memo or promoted research theme.
- Classify each pairing as `Aligned`, `Partially Aligned`, `Missing`, or `Conflicting`.
- Use this file to drive architecture updates and prototype ordering, not as a replacement for the architecture docs themselves.

## Gap Analysis Results

### Memo `<NNN>`: `<title>` -> `<promotion target>`

| Research finding | Architecture doc | Alignment | Gap description |
| --- | --- | --- | --- |
| `<finding>` | `<doc>` | `Aligned` | `<note>` |

## Critical Gaps

| Gap | Related research | Architecture area | Status |
| --- | --- | --- | --- |
| `<gap>` | `<memo or track>` | `<doc>` | `<open / in progress / resolved>` |

## Areas Already Aligned

| Finding | Research source | Architecture doc |
| --- | --- | --- |
| `<finding>` | `<memo or track>` | `<doc>` |

## Prototype Dependency Ordering

### Tier 1: Architecture-blocking

1. `<prototype>` - `<why it gates downstream work>`

### Tier 2: Design-constraining

1. `<prototype>` - `<why it refines architecture>`

### Tier 3: Refinement

1. `<prototype>` - `<why it can follow after earlier data>`

## Next Task

Run the first memo-to-architecture audit and record which gaps are direct doc edits versus prototype-gated decisions.
