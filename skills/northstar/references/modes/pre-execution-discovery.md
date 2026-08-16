# Pre-execution discovery mode

Use this internal mode when the request is about readiness mapping, intent
rounds, project language, decision prototypes, or questionnaires before ordinary
Northstar planning begins. It is a procedure inside the single public
`northstar` skill, not a second installable skill or an execution permission.

## Authority and posture

Name the repo posture (`baseline-routing`, `strict-ready`, `strict-paused`,
`migration`, or `drifted`) and identify the destination before asking questions.
The readiness map and its linked decision records remain the canonical planning
surfaces:

```text
docs/specs/<destination-slug>/README.md
docs/specs/<destination-slug>/decisions/<decision-id>-<slug>.md
```

Read the current map, its links, and the governing spec, architecture, contract,
and roadmap. Run the repository's deterministic readiness-map check when it is
available. Work from the checker's frontier; do not create a parallel question
list, shadow glossary, external tracker, or private state store.

If the map is missing, malformed, has missing references, cycles, orphan records,
or otherwise cannot produce a trustworthy frontier, stop and report the planning
gap. Use the normal planning route to establish or repair canonical coverage;
do not infer a destination or manufacture a new map as part of this mode.

## Shared intent-round procedure

1. **Inspect first.** Resolve repository-answerable facts with repository
   inspection, deterministic commands, or bounded research. Record the fact in
   the canonical decision record, or explicitly record why it is non-material.
   Do not ask the operator to supply an answer the environment can establish.
2. **Read the frontier.** Treat a decision as on the frontier only when it is
   open, not out of scope, not already claimed by an active planning session,
   and all of its blockers are resolved. Preserve the stable decision IDs and
   dependency direction reported by the map/checker.
3. **Ask a small breadth-first group.** Select only a few independent questions
   from the live frontier. Link every question to its canonical decision ID and
   explain why it matters. Keep the round broad enough to expose independent
   unknowns, but do not turn it into an exhaustive questionnaire or waterfall
   design exercise.
4. **Choose the right route.** Keep operator decisions, research, prototypes,
   and task work distinct. Use the route below that matches the unresolved
   question instead of silently answering it in prose.
5. **Recompute.** After recorded evidence or an explicit operator response,
   recompute the frontier from repository state. A new blocker, invalid state,
   or unresolved authority returns the route to a stop rather than being guessed
   through.
6. **Stop deliberately.** Stop when the questions are answered, routed to an
   appropriate evidence path, accepted as non-material, or explicitly left as
   accepted uncertainty. A clear frontier is input to the normal promotion and
   roadmap gates; it is not permission to execute.

## Project language route

Use project language when a destination has terms, aliases, or boundaries that
need clarification. Read and update only the destination-local project-language
surface named or linked by the readiness map. Keep entries explicit about the
preferred term, aliases, meaning, authority, status, and rejected ambiguity.
Project language improves shared understanding; it does not resolve a decision or
change execution authority.

Keep local wording local by default. If a term appears stable and useful across
projects, make the possible promotion to the global glossary visible as a
separate operator-owned or normally promoted planning decision. Never promote a
local term to global doctrine automatically, and never use a global glossary
entry to hide a destination-specific decision.

If the map does not identify a project-language surface, record that missing
contract as a planning gap rather than inventing an ungoverned glossary path.

## Decision-prototype route

Use a decision prototype when conversation and repository facts cannot settle a
bounded technical or behavioural question and throwaway evidence can help. Keep
the prototype question-specific and plan-only. Record the following in the
canonical `kind: prototype`, `mode: prototype` decision record or its linked
evidence surface:

- the question and the hypothesis or options under test;
- the bounded scope and evaluation method;
- the evidence collected and the resulting verdict;
- limitations, rejected interpretations, and the promotion target.

A prototype may inform a decision, but its verdict is not operator authority. It
cannot resolve an operator-owned decision, mark a map cleared, make a card ready,
or edit production code through this route. Promote durable structural or policy
outcomes through the normal architecture, contract, spec, and roadmap gates;
leave inconclusive evidence as explicit uncertainty.

## Questionnaire route

Use a questionnaire when the unresolved item belongs to the operator and needs
to survive across turns or sessions. Preserve it in the canonical operator-owned
decision record, including:

- the context and decision being requested;
- constraints, options, and any clearly labelled recommendation;
- the operator's response and its authority/evidence;
- the resulting status, or an explicit unresolved/accepted-uncertainty state.

A questionnaire is not an external tracker or a second decision store. An agent
recommendation, prototype verdict, research result, or previous conversation
summary must not be substituted for the operator's response. Keep the record
unresolved until explicit operator evidence supports a normal resolution.

## Route outputs and boundaries

The default route is read-only. When the operator asks to record progress, update
only existing map-linked planning evidence and canonical decision records; keep
all changes provider-neutral and non-mutating by default. Report the destination,
frontier used, questions asked, route selected, canonical record IDs, evidence or
operator response, promotion target, and remaining blockers.

This mode must never:

- edit production code or require a provider-specific API, database, network
  service, external tracker, or automatic cross-session messaging;
- create a second readiness map, decision-record authority, glossary, or hidden
  question list;
- mark a readiness map cleared, make a roadmap card ready, or bypass normal
  spec, promotion, roadmap, validation, or operator gates;
- turn prototype evidence or questionnaire material into a silent operator
  decision;
- expand into starter templates, architecture refocus, reframe, consumer-repo
  dogfood, or changes to the worker/PR contract.

Stop and return to planning or the operator when the frontier is invalid, a
canonical link or authority is missing, the question exceeds the bounded route,
or the requested next step would cross one of these boundaries. Once the
frontier is genuinely clear, continue through the existing planning mode rather
than treating this mode as a replacement for specs, contracts, roadmaps, or
handoffs.
