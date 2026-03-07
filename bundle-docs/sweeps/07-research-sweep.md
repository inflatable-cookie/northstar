# 07 Research Sweep

## Goal

Ensure optional Northstar research docs stay problem-led, source-backed, and clearly separated from architecture or roadmap commitments until promotion is explicit.

## Applies When

- `docs/research/` exists
- comparative studies or source maps live elsewhere and should be normalized into `docs/research/`

## Canonical Structure

- `docs/research/README.md`
- `docs/research/specimen-dossiers/`
- `docs/research/value-tracks/`
- `docs/research/source-hubs/`
- `docs/research/translation-memos/`
- `docs/research/templates/`

Optional when justified:
- `docs/research/master-index.md`
- `docs/research/research-to-implementation-playbook.md`
- `docs/research/quick-start-checklist.md`
- `docs/research/research-to-architecture-crossref.md`
- `docs/research/gaps-found-during-implementation.md`
- `docs/research/discovery-intake.md`
- `docs/research/discovery-triage-log.md`

## Required Contract Signals

- Research README explains purpose, operating model, source hierarchy, and promotion rule.
- Specimen dossiers capture strengths, chronic weaknesses, between-version corrections, source inventory, and open questions.
- Value-track syntheses compare multiple specimens and end with an explicit decision state.
- Translation memos state recommendation, tradeoffs, validation/prototype needs, and promotion target.
- Source hubs record authority, currency, likely bias, and which tracks they should feed.
- When implementation relies heavily on research, navigation and promotion-tracking artifacts exist and reflect current architecture/memo status.

## Drift Patterns

- Raw research notes mixed directly into `architecture/` or `roadmaps/`
- Recommendations written before cross-specimen synthesis exists
- Source maps with links but no authority/currency/bias notes
- Empty or template-only `docs/research/` folders left around with no real use
- Research findings promoted without an explicit memo or evidence plan
- Large research corpora with no master index, no promotion crossref, or no implementation gap capture despite active use

## Fix Rules

- Move comparative/source-backed material into the research doc type it actually is.
- Add explicit source inventories and confidence/authority notes.
- Keep tentative findings in research until translation memo criteria are satisfied.
- If research is not a durable need, remove the unused add-on folder instead of preserving dead scaffolding.
- Update architecture/roadmap references in the same batch when promotion targets move.
- Add or refresh implementation bridge artifacts when contributors can no longer find or apply research quickly.

## Fast Checks

```bash
find docs/research -maxdepth 3 -type f | sort
rg -n "Source inventory|Decision state|Promotion target|Open questions|Project problem statement" docs/research
rg -n "master-index|research-to-implementation|gaps-found-during-implementation|implementation decision record|Alignment|Gap Description" docs/research
```

## Completion Criteria

- `docs/research/` exists only when justified and follows the Northstar layout.
- Research recommendations promote cleanly into architecture/roadmaps/logs with explicit links.
- Source hierarchy and promotion state are clear in every audited research thread.
- Implementation-heavy research areas have enough navigation and gap-tracking to remain operationally useful.
