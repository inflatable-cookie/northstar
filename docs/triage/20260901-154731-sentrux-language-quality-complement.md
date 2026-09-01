# Sentrux as an optional language-quality complement

Status: open; reassess while shaping spec 034
Owner: Northstar orchestrator
Source: operator review of [sentrux/sentrux](https://github.com/sentrux/sentrux)

Sentrux looks useful as an opt-in cross-language structural-analysis provider.
It could complement Northstar's language packages with repository-wide shape,
complexity, dependency, dead-code, and duplication signals without making the
root Northstar skill language-specific.

The intended fit is narrow:

- Northstar core discovers and routes compatible optional packages.
- A language package may declare Sentrux as one evidence provider where its
  grammar and analysis coverage are suitable.
- Repository-owned profiles decide whether the provider is enabled, which
  paths it owns, and how findings affect repair authority.
- Sentrux evidence remains diagnostic input. It does not replace Northstar's
  catalogues, finding-first recorders, repository-native compiler/linter/test
  evidence, or human architecture review.

Do not adopt it into the root payload or make it a required dependency yet.
The assessment found several boundaries that need falsification: tracked-files
scope, generated/vendor exclusion, machine-readable output, grammar pinning and
verification, automatic downloads, telemetry defaults, and open correctness
reports around some metrics. These may be acceptable for an opt-in provider,
but not as silent or authoritative behavior.

## Proposed evaluation

Run a small three-repository cohort after spec 034 has a draft provider/package
contract:

1. one Rust-heavy repository;
2. one TypeScript/Svelte repository;
3. one mixed-language repository with generated or vendored content.

For each subject, compare Sentrux output with the existing Northstar audit
record and repository-owned tools. Measure signal overlap, novel actionable
findings, false positives, exclusion fidelity, deterministic repeatability,
offline behavior, install/runtime cost, and whether stable machine-readable
evidence can be captured without scraping presentation output.

Promote only if the cohort shows useful additional signal and the integration
can stay optional, pinned, explicit, and provider-neutral. Otherwise retain it
as a recommended operator tool or close this note without changing spec 034.

## Spec 034 checkpoint

The first package-protocol pass keeps Sentrux out of both Northstar core and the
initial Rust/TypeScript extraction. It is an optional evidence provider, not a
replacement language pack: a compatible pack may name the provider and its
supported grammar surface, while the consumer profile owns activation, scope,
exclusions, and finding authority.

Effigy catalog packs do not change that route. Their current schema is fixed to
Effigy service fragments and selects one active catalog pack; `effigy skill
run` executes an already-resolved path but does not acquire it. The provider
cohort should therefore follow a provider-neutral package manifest draft and
must not make Effigy or its catalog store a Sentrux prerequisite.
