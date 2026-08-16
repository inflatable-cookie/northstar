# 076 - Implement Deterministic Readiness Frontier Checks

Status: planned
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/027-northstar-native-pre-execution-discovery.md`
Governing refs: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `docs/roadmaps/g02/batch-cards/075-define-readiness-map-file-contract.md`, `g02.026`
Depends on: `g02.026/075`
Auto-start next card: no

## Planning Gate

This card is not ready until card 075 has promoted the exact file contract and
validation command. Do not implement a checker against the provisional schema
in spec 027 alone.

## Objective

Add deterministic, fail-closed validation for readiness-map and decision-record
integrity using the promoted Batch 26.1 file contract.

## Intended Scope

- validate destination layout and Markdown/YAML frontmatter;
- validate stable IDs, allowed kinds/modes/statuses, and required fields;
- validate relative links and canonical-reference boundaries;
- report missing references, orphan records, dependency cycles, invalid states,
  and the calculated open frontier;
- expose the check through the repository's Effigy-native validation surface;
- add fixtures or test cases for valid, invalid, cyclic, orphaned, and
  operator-blocked maps;
- keep the check read-only and independent of provider-specific tooling.

## Acceptance Criteria

- the checker consumes only the promoted repository files;
- invalid dependency state exits non-zero with actionable diagnostics;
- a valid map produces deterministic frontier output;
- operator-owned decisions cannot be marked resolved by checker inference;
- tests cover missing references, cycles, orphan records, and invalid states;
- `effigy qa`, `effigy qa:docs`, and the targeted checker tests pass.

## Stop Conditions

- stop if the contract card is not merged or the schema is still disputed;
- stop if the checker requires a database, network, or provider adapter;
- stop if frontier calculation requires guessing missing authority or dependencies;
- stop if implementation changes the map or decision records as a side effect.

## Next Task

Prepare this card by defining the exact Effigy-native checker command, targeted
test command, and ready-state evidence. Mark it ready only after those surfaces
are explicit and the implementation boundary remains read-only and fail-closed.
