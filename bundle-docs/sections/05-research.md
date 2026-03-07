# 05 Research

Status: active
Updated: 2026-03-07

## Why this section matters now

Comparative and source-backed research helps projects learn from external systems before architecture or roadmap pressure locks bad assumptions.
Jetstream and Loophole both showed that durable research docs become much more useful when they are structured, source-aware, and explicitly separated from execution planning.

## Scope

Define where to keep specimen studies, cross-cutting syntheses, source hierarchies, and project-facing translation memos.
Do not turn research docs into roadmap backlogs or architecture contracts before the promotion rule is satisfied.

## Template layout

- `docs/research/README.md`
- `docs/research/master-index.md` (recommended once the corpus grows)
- `docs/research/research-to-implementation-playbook.md` (recommended when research regularly shapes delivery)
- `docs/research/quick-start-checklist.md` (recommended when multiple contributors consume the corpus)
- `docs/research/research-to-architecture-crossref.md` (recommended when memo promotion needs explicit tracking)
- `docs/research/gaps-found-during-implementation.md` (recommended when implementation uncovers missing research)
- `docs/research/specimen-dossiers/README.md`
- `docs/research/value-tracks/README.md`
- `docs/research/source-hubs/README.md`
- `docs/research/translation-memos/README.md`
- `docs/research/templates/README.md`
- `docs/research/templates/specimen-dossier-template.md`
- `docs/research/templates/value-track-synthesis-template.md`
- `docs/research/templates/translation-memo-template.md`
- `docs/research/templates/source-hub-template.md`
- `docs/research/templates/implementation-decision-record-template.md` (recommended when implementation choices need research traceability)
- `docs/research/templates/discovery-intake-template.md` (optional)
- `docs/research/templates/discovery-triage-log-template.md` (optional)

## Default vs optional

- `research/` is an optional add-on section.
- Create it when comparative research, source mapping, or repeated external benchmarking becomes a durable project need.
- Keep it absent in projects that do not need sustained research.

## Naming and ordering

- Use descriptive slugs for dossiers and value-track syntheses.
- Use `NNN-<slug>.md` where sequence clarity matters, especially for source hubs and translation memos.
- Keep the four output classes explicit: `specimen-dossiers`, `value-tracks`, `source-hubs`, `translation-memos`.

## Operating model

1. Start with a problem, not a fandom list.
2. Gather primary sources before secondary commentary.
3. Record strengths, chronic failures, and between-version corrections together.
4. Convert findings into project implications only after cross-specimen comparison.
5. Promote stable conclusions into architecture or roadmaps only when the recommendation, tradeoffs, and validation needs are explicit.
6. Once the corpus becomes implementation-critical, maintain explicit navigation, promotion, and gap-capture artifacts so the research remains usable under delivery pressure.

## Implementation bridge artifacts

Recommended once research repeatedly shapes active implementation:

- `master-index.md`: map architecture areas, implementation concerns, or prototypes to the relevant research artifacts
- `research-to-implementation-playbook.md`: define the expected workflow from discovery through coding, validation, and review
- `quick-start-checklist.md`: short daily checklist for contributors consuming research during delivery
- `research-to-architecture-crossref.md`: track where memo findings align, conflict, or remain missing in architecture
- `gaps-found-during-implementation.md`: capture missing research discovered while building
- `templates/implementation-decision-record-template.md`: record research-informed implementation choices and justified deviations

## Source hierarchy

Prefer sources in this order:
1. official docs, source trees, release notes, technical talks, white papers, standards, and postmortems
2. first-party or partner technical programs with concrete claims
3. engineering blogs, staff interviews, and conference notes with specific evidence
4. community synthesis only when it points back to stronger sources or documents observable behavior

## Content contract (specimen dossier)

1. `Status`, `Owner`, `Last updated`, `Scope`
2. `## Why this specimen matters`
3. `## Product and era context`
4. `## Defining bets`
5. `## Standout strengths`
6. `## Chronic weaknesses and recurring costs`
7. `## Between-version corrections`
8. `## Project-relevant lessons`
9. `## Source inventory`
10. `## Open questions`
11. `## Next Task`

## Content contract (value-track synthesis)

1. `Status`, `Track`, `Owner`, `Last updated`
2. `## Problem statement`
3. `## Why this track matters`
4. `## Cross-specimen comparison`
5. `## Repeated patterns`
6. `## Frontier signals`
7. `## Project implications`
8. `## Source inventory`
9. `## Decision state`
10. `## Next Task`

## Content contract (translation memo)

1. `Status`, `Memo`, `Owner`, `Last updated`, `Related track`
2. `## Project problem statement`
3. `## External evidence summary`
4. `## Recommendation`
5. `## Tradeoffs the project would accept`
6. `## What must be true before adoption`
7. `## Required prototype or validation work`
8. `## Promotion target`
9. `## Sources`
10. `## Next Task`

## Promotion rule

Keep tentative findings in `research/` until they can answer all of:
- what problem the project is solving
- which evidence supports the recommendation
- which tradeoffs the project accepts
- what must be measured or prototyped before adoption

## Dependencies

- Research can feed architecture, contracts, roadmaps, and logs.
- Architecture and roadmap docs should link back to the translation memo that justified a research-driven bet.
- Implementation decision records and research-to-architecture crossrefs are optional support artifacts inside `research/`, not replacements for canonical architecture or roadmap docs.

## Next task

Pilot the starter pack in one live project and confirm whether Northstar should keep the generic `specimen-dossiers/` naming or document approved aliases per domain.
