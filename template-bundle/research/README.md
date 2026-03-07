# Research

Purpose: give the project a durable place to study external systems, standards, competitors, and research programs without mixing raw research into architecture docs or execution roadmaps.

## When to use this section

- architecture or roadmap decisions depend on external comparison or source-backed learning
- the team needs durable source maps and syntheses instead of ad hoc notes
- repeated discovery work would otherwise be lost in logs or scattered notes

## Structure

- `master-index.md`: research navigation by architecture area, concern, or prototype
- `research-to-implementation-playbook.md`: workflow for carrying research into delivery
- `quick-start-checklist.md`: short daily checklist for contributors using the corpus
- `research-to-architecture-crossref.md`: promotion and gap-tracking map between research and architecture
- `gaps-found-during-implementation.md`: implementation-discovered research gaps
- `specimen-dossiers/`: per-system or per-specimen studies
- `value-tracks/`: cross-specimen syntheses by problem area
- `source-hubs/`: curated source maps and source-quality hierarchy
- `translation-memos/`: project-facing recommendations derived from research
- `templates/`: reusable templates for the research workflow
- `discovery-intake.md` (optional): rules for triaging inbound signals
- `discovery-triage-log.md` (optional): staging area for research-now vs watchlist items

## Operating model

1. Start with a problem, not a product wishlist.
2. Gather primary sources before secondary commentary.
3. Record strengths, chronic failures, and between-version corrections together.
4. Convert findings into project implications only after cross-specimen comparison.
5. Promote stable conclusions into architecture or roadmaps only when the recommendation is specific enough to constrain design or execution.

## Source hierarchy

Prefer sources in this order:
1. official docs, source trees, release notes, talks, white papers, standards, and postmortems
2. first-party or partner technical programs with concrete claims
3. engineering blogs, staff interviews, and conference material with specific evidence
4. community synthesis only when it points back to stronger sources or documents observable behavior

## Promotion rule

Keep tentative findings here until they can answer all of:
- what problem the project is solving
- which evidence supports the recommendation
- which tradeoffs the project accepts
- what must be measured or prototyped before adoption

## Using This Research During Delivery

As the corpus grows:
- use `master-index.md` to find the right memo, value track, dossier, or prototype quickly
- use `research-to-implementation-playbook.md` to keep implementation work research-aware
- use `research-to-architecture-crossref.md` to track where memo findings are aligned, missing, or conflicting in architecture
- use `gaps-found-during-implementation.md` to capture missing research instead of losing it in PR chatter
- use `templates/implementation-decision-record-template.md` when a build decision needs explicit research traceability

## Templates

- `templates/specimen-dossier-template.md`
- `templates/value-track-synthesis-template.md`
- `templates/translation-memo-template.md`
- `templates/source-hub-template.md`
- `templates/implementation-decision-record-template.md`
- `templates/discovery-intake-template.md` (optional)
- `templates/discovery-triage-log-template.md` (optional)

## Next task

Start with a source hub and one specimen dossier for the first problem area, then add the master index and playbook once research starts actively shaping implementation work.
