# 076 - Implement Deterministic Readiness Frontier Checks

Status: complete
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/027-northstar-native-pre-execution-discovery.md`
Governing refs: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `docs/roadmaps/g02/batch-cards/075-define-readiness-map-file-contract.md`, `g02.026`
Depends on: `g02.026/075`
Auto-start next card: no

## Planning Gate

The planning gate is satisfied:

- card 075 is merged and the exact map/record contract is canonical;
- the checker command surface and fixture-test command are fixed below;
- the implementation remains read-only, fail-closed, and provider-independent;
- no unresolved architecture, authority, or command-routing choice governs this
  card.

## Execution Command Contract

Implement these exact Effigy-native commands:

- `effigy check:readiness-map` runs
  `scripts/check-northstar-readiness-map.rhai` against live readiness maps under
  `docs/specs/` by default. It accepts one optional positional root so a
  destination or fixture root can be checked explicitly, following the existing
  `check:posture-advisory` argument convention.
- `effigy test:readiness-map` runs
  `scripts/test-northstar-readiness-map.rhai` against the committed fixture
  corpus under `scripts/fixtures/readiness-map/` and asserts both successful
  and expected-failure cases.
- `effigy qa:docs` invokes `check:repo-contract`, `check:readiness-map`, and
  `test:readiness-map` in that order. A repository with no live readiness maps
  passes the live check with deterministic zero-map output; fixtures provide
  the behavioural coverage.

The fixture corpus must include `valid`, `missing-reference`, `cycle`, `orphan`,
and `operator-blocked` cases. The checker and test script may share parsing and
validation functions through `scripts/lib/`, but no database, network, provider
adapter, or mutation of map/record files is allowed.

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
- `effigy check:readiness-map` passes the live zero-map case and the valid fixture;
- `effigy test:readiness-map` proves the expected failure cases;
- `effigy qa`, `effigy qa:docs`, and the targeted fixture tests pass;
- checker execution does not mutate maps, records, or fixture files.

## Evidence Required

- exact changed-file list;
- command output for `effigy check:readiness-map`;
- fixture matrix showing valid pass and each invalid case failing for the intended
  reason;
- deterministic frontier output from a valid fixture;
- `effigy test:readiness-map`, `effigy qa`, and `effigy qa:docs` output;
- explicit confirmation that no map or record file was mutated.

## Resolution

Implemented, independently reviewed, and merged through the Northstar
worker/PR loop:

- `effigy check:readiness-map`;
- `effigy test:readiness-map`;
- `effigy qa:docs` integration;
- shared deterministic Rhai validation/parser logic;
- committed valid, missing-reference, cycle, orphan, and operator-blocked
  fixtures;
- script documentation and repo-contract assertions.

The implementation was merged in PR
[inflatable-cookie/northstar#4](https://github.com/inflatable-cookie/northstar/pull/4)
as squash commit `36fe4559290dc0878aaaa2d5c49fa15f6350f1cd`.

## Validation Evidence

- `git diff --check` — passed;
- `effigy tasks` — both readiness commands registered;
- `effigy doctor` — `ok:19 warn:0 err:0` after refreshing the derived graph index;
- `effigy check:readiness-map` — live zero-map case passed;
- valid fixture frontier — deterministic `choose-runtime, document-task`;
- `effigy test:readiness-map` — five fixture cases passed;
- invalid fixture commands — non-zero exits with actionable diagnostics;
- consecutive valid-fixture runs — byte-identical output;
- checker/test execution — no map, record, or fixture mutation;
- `effigy qa` — passed;
- `effigy qa:docs` — passed;
- orchestrator review — `PASS`, recorded on PR #4.

## Continuation Envelope

- Auto-start next card: no
- In-bounds next card: none; the next transition is a planning checkpoint for
  Batch 26.2
- Remaining ready chain after this card: 0
- Transition proof required before the next card becomes ready: checker behavior,
  fixture evidence, and the next planning checkpoint are recorded

## Stop Conditions

- stop if the contract card is not merged or the schema is still disputed;
- stop if the checker requires a database, network, or provider adapter;
- stop if frontier calculation requires guessing missing authority or dependencies;
- stop if implementation changes the map or decision records as a side effect.

## Next Task

Use the next planning checkpoint to shape Batch 26.2 — intent rounds, project
language, decision prototypes, and questionnaire routes. Do not mark a new
implementation card ready until its governing contracts, acceptance criteria,
validation, and evidence requirements are explicit.
