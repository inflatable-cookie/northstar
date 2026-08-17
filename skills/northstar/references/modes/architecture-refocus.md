# Architecture Refocus Mode

Use this mode for `northstar architecture refocus` or
`northstar codebase architecture review`. It is the Northstar-native equivalent
of an evidence-led codebase architecture improvement review.

This is a normal-mode, plan-only review. It does not run worker-mode worktree
preflight, inspect worker-local path configuration, edit production code, create
a worker, or silently turn a candidate into a roadmap commitment.

## Scope

Scope the review to one active roadmap lane, named subsystem, package, service,
or architectural seam. If the operator does not name an area, use the current
active lane from the repository's canonical roadmap and state that scope
explicitly. Do not perform an undirected whole-codebase refactor scan.

Stop and ask when no bounded area can be established from the repository's
current authority surfaces.

## Evidence pass

Inspect only the evidence relevant to the selected scope:

1. current `AGENTS.md` and local contracts;
2. `docs/architecture/system-architecture.md`, system inventory, and repo
   authority map where present;
3. governing contracts, active spec, roadmap milestone, and ready cards;
4. relevant source modules, public interfaces, dependency edges, tests, and
   validation surfaces;
5. recent logs, changes, and the owning repository's `PAPERCUTS.md`;
6. research or decision records that explain why the current boundary exists.

Use repository facts and deterministic inspection before asking the operator or
proposing a change. Keep the review offline-safe and bounded to the selected
area.

## Candidate loop

Produce a small candidate set, normally no more than three candidates. For each
candidate record:

- the observed seam or architectural pressure;
- concrete evidence and file paths;
- the user or delivery consequence;
- the boundary or invariant that would improve;
- alternatives considered and why they were rejected;
- likely risk, migration cost, and validation surface;
- the correct promotion route: research, decision prototype, spec, architecture,
  contract, or roadmap;
- confidence and the question that still needs operator authority, if any.

Prefer candidates that reduce authority ambiguity, duplicated state, accidental
coupling, validation blind spots, or repeated delivery friction. Do not optimize
for novelty or stylistic consistency alone.

## Recommendation and promotion

Recommend one candidate, or recommend no change when the current architecture is
adequate. A candidate is not a decision and the review does not grant execution
authority. Promote a selected candidate through the normal route:

- unresolved evidence -> research;
- bounded technical uncertainty -> decision prototype;
- provisional structural change -> spec;
- durable structure -> architecture;
- durable boundary or policy -> contract;
- executable approved work -> roadmap and ready card.

Do not edit production code in this mode. If the operator selects a candidate,
return to the appropriate planning mode and record the decision once in the
canonical surface.

## Output

Return:

- selected scope and repository posture;
- evidence inspected;
- current architecture verdict: `sound`, `strained`, `drifting`, or
  `insufficiently specified`;
- the small candidate set with evidence and promotion routes;
- the recommended candidate or explicit no-change verdict;
- unresolved operator decisions;
- exactly one next route;
- whether implementation is currently authorized: normally `no`.

The useful result is a sharper architectural decision and a trustworthy promotion
path, not a large report or an impressive list of refactoring ideas.
