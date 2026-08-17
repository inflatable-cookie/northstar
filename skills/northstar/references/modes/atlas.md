# Atlas — Long-Horizon Planning Mode

Use Atlas when the operator wants to understand or shape the long-horizon
strategic form of a significant project, product, platform, or portfolio. Atlas
is Northstar's question-led strategy and runway route; it is not a health check
of existing docs, a short-term roadmap compiler, or an execution loop.

The public trigger may be `northstar atlas`, `/northstar-atlas`, or an equivalent
request to shape the long-term direction and meaningful planning horizons.

## Scale test

Atlas is appropriate when the work:

- spans multiple meaningful milestones, batches, or planning horizons;
- has strategic choices whose consequences outlast the next implementation lane;
- crosses domains, packages, repositories, products, or ownership boundaries;
- needs a durable runway rather than a single next card;
- requires explicit non-goals, sequencing, dependencies, or rollover conditions.

Do not use Atlas for a small change, a single seam, a currentness audit, or a
coherent plan that only needs milestones. Route those requests to the normal
planning, architecture-refocus, readiness-review, or roadmap-compilation mode.

## Authority and posture

Atlas is plan-only and operator-owned. It may inspect and propose, but it does
not silently decide strategic direction or authorize execution.

- Vision owns long-horizon outcomes and strategic constraints.
- Architecture owns system shape, boundaries, and invariants.
- Contracts own durable authority and behavioural rules.
- Specs own provisional realization strategy until promotion.
- Roadmaps own time-ordered milestones and generation runways.
- The operator owns strategic commitments, trade-offs, accepted uncertainty, and
  any decision that changes product or project direction.

Atlas must not edit production code, create workers or worktrees, prepare a PR,
merge anything, select consumer dogfood targets, or treat a recommendation as
operator approval.

## Required reads

Identify the target project, portfolio, or bounded strategic destination first.
Then inspect the available canonical surfaces, stopping when a surface is absent
rather than inventing a parallel one:

- `README.md` and `AGENTS.md`;
- `docs/vision/` and the active vision front door;
- `docs/architecture/`, including system architecture, inventory, and authority
  maps where they exist;
- `docs/contracts/` and the governing contract index;
- active specs and research promotion records;
- `docs/roadmaps/gNN/README.md`, `docs/roadmaps/generation-index.md`, active
  milestones, and runway state;
- recent logs, handoffs, papercuts, and current operator evidence;
- deterministic planning checks available in the target repository.

When working in the Northstar source repository, read
`bundle-docs/protocol-kernel.md` and the relevant doctrine sections. In a
consumer repository, the absence of `bundle-docs/` is normal.

## Atlas procedure

1. **Name the destination and scale.** State what project, product, platform,
   or portfolio is being shaped; why the horizon is material; and what is
   explicitly out of scope.
2. **Separate direction from realization.** Extract the existing long-horizon
   outcomes and constraints from vision. Keep implementation details, current
   backlog items, and attractive ideas from masquerading as strategy.
3. **Map the current shape.** Compare vision, architecture, contracts, research,
   specs, active generation runway, and roadmap state. Identify contradictions,
   missing authority, stale assumptions, and duplicated direction.
4. **Build the horizon model.** Describe a small number of meaningful horizons
   or strategic phases. For each, state the outcome, capabilities or boundaries
   it depends on, what it unlocks, what it deliberately excludes, and what would
   cause a strategy review or rollover.
5. **Identify strategic bets and dependencies.** Group work by durable outcome,
   not by agent task. Expose cross-domain dependencies, authority boundaries,
   irreversible choices, sequencing constraints, and accepted uncertainty.
6. **Ask a breadth-first strategy round.** Resolve repository-answerable facts
   first. Ask only the smallest set of independent operator questions needed to
   distinguish the viable horizon models. Do not run a serial interrogation or
   ask implementation questions prematurely.
7. **Synthesize a runway.** Produce a coarse, durable runway that connects the
   chosen or provisional strategy to the active generation and its next meaningful
   milestone transitions. Do not generate a waterfall or pretend every future
   card is known.
8. **Choose the promotion route.** Distinguish what belongs in vision,
   architecture, contracts, specs, research, readiness decisions, or roadmaps.
   State which outcomes are recommendations, which require operator confirmation,
   and which remain accepted uncertainty.
9. **Recompute and stop.** Recheck the canonical surfaces after recorded evidence
   or an operator response. Stop when the horizon model is coherent enough for
   promotion, when the operator must decide, or when a narrower route is now the
   correct next step.

## Horizon model output

Return a compact but strategic result containing:

- **Destination and horizon:** the project and why this is long-horizon work;
- **Strategic direction:** outcomes and constraints, separated from realization;
- **Current shape:** the canonical evidence and material contradictions;
- **Horizon model:** meaningful phases, outcomes, dependencies, and unlocks;
- **Strategic bets:** options, trade-offs, non-goals, and irreversible choices;
- **Open operator decisions:** only questions the operator must own;
- **Runway:** the next meaningful milestone transitions, not a task queue;
- **Promotion map:** vision, architecture, contract, spec, research, or roadmap
  destinations;
- **Recommended next route:** one bounded route, with execution status.

If the existing strategy is already coherent and only milestones are missing,
recommend roadmap compilation. If the direction is unclear, route to discovery or
an operator questionnaire. If canonical state is stale, route to recovery. If
code and intended shape disagree, route to architecture refocus.

## Durable writes

The default Atlas pass is read-only. If the operator explicitly asks to record
or promote the result, update only the canonical surfaces named by the promotion
map. Keep the changes bounded and provider-neutral:

- strategic outcomes and constraints → `docs/vision/`;
- accepted system shape and invariants → `docs/architecture/`;
- durable authority or behaviour → `docs/contracts/`;
- unresolved or provisional realization strategy → `docs/specs/`;
- time-ordered horizons and milestone sequencing → `docs/roadmaps/`;
- evidence and decisions → `docs/logs/` or the linked canonical record.

Do not create an Atlas-specific shadow database, strategy tracker, glossary,
roadmap queue, or private state store.

## Stop conditions

Stop and route elsewhere when:

- the destination or strategic question cannot be identified;
- the task is small enough for a normal bounded plan;
- currentness drift makes the canonical state untrustworthy;
- the project lacks the architecture, authority, or contract surface needed to
  make the strategic question meaningful;
- an operator-owned direction or trade-off is unresolved;
- the request crosses into implementation, worker setup, PR review, or merge
  authority;
- the horizon model would become a speculative waterfall or a list of every
  conceivable future feature.
