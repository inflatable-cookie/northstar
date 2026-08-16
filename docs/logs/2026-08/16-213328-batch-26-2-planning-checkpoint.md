# Batch 26.2 Planning Checkpoint

- Date: 2026-08-16
- Milestone: `g02.026`
- Planning spec: `docs/specs/027-northstar-native-pre-execution-discovery.md`
- Contract: `docs/contracts/001-working-rules.md`
- Architecture: `docs/architecture/system-architecture.md`
- Next card: `g02.026/077`

## Decisions

- First dogfood sequence: **Figmatic, then Poodle**.
- Figmatic is first because its boundary between deterministic componentization
  and human-directed responsive behaviour is active and materially ambiguous.
- Poodle follows as a larger cross-runtime contract and vocabulary test.
- Project language is local by default. A destination-local vocabulary may be
  promoted to the global glossary only when a term proves stable across projects.
- Architecture owns structural concepts and boundaries.
- Contracts own authority terms, behavioural meanings, and rejected ambiguities.
- Readiness records own destination-specific decisions.

## Route contract

Batch 26.2 now has four bounded, provider-neutral, plan-only routes:

- intent rounds: small breadth-first questions over the live frontier, with
  repository-answerable facts resolved first;
- project language: destination-local preferred terms, aliases, meanings,
  authority, status, and rejected ambiguity;
- decision prototypes: throwaway question-specific evidence with a recorded
  verdict, limitations, and promotion target;
- questionnaires: durable operator-owned questions and responses in canonical
  decision records across turns or sessions.

No route can clear a readiness map, make a card ready, bypass promotion gates,
or silently resolve an operator-owned decision. Routes are non-mutating by
default and leave a traceable path to the map and canonical records.

## Outcome

The planning checkpoint is complete. Card `g02.026/077` is ready to implement
the four routes and router activation through the isolated worker/PR loop.
Starter templates, architecture refocus, reframe, and consumer dogfood remain
later work.

## Validation

- `effigy tasks` — passed;
- `effigy doctor` — `ok:19 warn:0 err:0`;
- operator choices were recorded in this spec and log;
- card 077 has explicit scope, acceptance, evidence, and stop conditions.
