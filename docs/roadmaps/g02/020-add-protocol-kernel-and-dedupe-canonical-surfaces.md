# 020 - Add Protocol Kernel And Dedupe Canonical Surfaces

Status: complete
Owner: repo maintainers
Created: 2026-05-19
Depends on: g02.019
Vision tags: `doctrine`, `operator-flow`, `skills`, `bundle-docs`
Governing refs: `docs/contracts/001-working-rules.md`,
`docs/specs/023-protocol-kernel-and-dedupe.md`,
`bundle-docs/sections/06-planning-and-contract-gates.md`,
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`
Planning state: complete

## Problem

Northstar’s protocol is spread across `bundle-docs/sections/`, the template
bundle, five installable skills, operator prompts, and live contracts. The same
norms (for example batch-card contents, ready-state rubric, closeout shape) are
repeated with small wording drift risk. Operators and agents lack one short
canonical “protocol kernel” that everything else points to.

## Goals

- [x] add a compact protocol kernel surface (likely under `bundle-docs/`) that
      links into sections `06` and `07` for depth
- [x] choose one normative home for repeated lists (batch card fields,
      ready-state rubric, closeout summary shape) and replace duplicates with
      pointers
- [x] refresh skills and template-bundle references so setup/plan/recover route
      to the kernel instead of restating doctrine
- [x] keep baseline versus strict messaging obvious so the kernel does not read
      like mandatory ceremony for small repos

## Non-Goals

- [ ] merging `06` and `07` into a single mega-section without a readability pass
- [ ] adding a new public skill for “protocol navigation”

## Execution Plan

### Batch 20.1 - Define Kernel Scope And Canonical List Homes

- [x] inventory duplicate normative lists across bundle-docs, skills, and
      `template-bundle/`
- [x] draft the kernel outline and decide which lists stay authoritative in
      existing sections versus move

### Batch 20.2 - Author Kernel And Dedupe References

- [x] land the kernel doc and wire bundle-docs README / visual map / cheat
      sheet entry points
- [x] dedupe skill and template references to the single canonical lists

### Batch 20.3 - Prove Operator Path

- [x] run one fresh-thread operator read-through from visual map through kernel
- [x] fix any broken routing or missing links found in that pass

## Acceptance Criteria

- [x] one short kernel doc exists and is linked from primary operator and
      maintainer entry paths
- [x] no competing duplicate definitions for the same normative list remain in
      the default skill + bundle surfaces without an explicit “see §” pointer
- [x] baseline versus strict expectations remain clear in the kernel’s opening
      framing

## Evidence

- `docs/logs/2026-05/19-164500-finish-protocol-kernel-batch-20-3.md`

## Next Task

Execute `g02.021` and log the checker batch when advisory posture/archive rules
land in Effigy.
