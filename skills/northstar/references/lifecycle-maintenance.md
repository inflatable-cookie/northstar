# Lifecycle maintenance: closed-generation compaction

Shared procedure for refresh, normalization, authorized docs cleanup, and
generation rollover. Load it from those modes. Do not load it from the main
skill up front.

This file is the installed, self-contained operating procedure. Do not require
a Northstar source checkout, `bundle-docs/`, or a Northstar-only contract path
for routine consumer maintenance.

## Callers and authorization

| Caller | Mutation | Extra confirmation |
| --- | --- | --- |
| Project refresh with documentation repair authorized | Apply this procedure | None. Repair authorization already covers bounded compaction. |
| Project refresh without repair authorization | Inventory, classify, and propose only | Do not mutate. |
| Normalize docs (spine hygiene, bootstrap, migration) | Apply this procedure for already-closed generations and for a rollover this mode is already performing | None for classified closed generations. Opening a new generation still follows rollover gates. |
| Docs cleanup with bounded repair authorized | Apply this procedure | None after that authorization. |
| Docs cleanup read-only | Inventory, classify, and propose only | Do not mutate. |
| Compile-roadmaps rollover closeout | Apply this procedure as the closeout, then open the next generation only if rollover conditions already hold | Rollover is a separate sequencing decision, not a prerequisite for compacting already-closed generations. |

Do not ask for a second blanket confirmation after repair is already
authorized. Do not treat compaction of a classified closed generation as a
request to open a new generation.

## Stop semantics

Stop, leave the target intact, and name the blocking decision when:

- unique current authority has no safe canonical destination, or two destinations
  conflict;
- an open commitment has no active home and no explicit removal;
- a generation's active/closed signals conflict and sequential mode cannot
  settle them;
- explicit parallel active generations are present; inspect, do not close them
  by counting folders;
- ownership, meaning, or deletion consequence of a classified source is
  uncertain;
- required access is missing.

An unresolved generation stays expanded. Report `unresolved` with the precise
blocker. Do not label lifecycle state `current` while a classified closed
generation remains expanded unless that unresolved blocker or a bounded
migration disposition is explicit.

A completed milestone alone does not close a generation.

## Procedure

Work from the consumer repository root. Record a preservation manifest before
any deletion.

### 1. Inventory content and references

Walk `docs/` recursively. For each expanded `docs/roadmaps/gNN/` directory,
collect:

- generation README, milestones, batch cards, and nested files;
- inbound Markdown links from current front doors and other live docs;
- unique durable rules (statements that do not already exist on a current
  canonical contract, architecture, or vision surface);
- open or deferred commitments;
- selected material evidence: PR numbers, merge/commit SHAs, releases,
  validation records worth keeping after the files are gone.

Front doors to scan:

- `docs/README.md`
- `docs/roadmaps/README.md`
- `docs/roadmaps/generation-index.md`
- `docs/roadmaps/gNN/README.md` for every expanded generation
- `docs/contracts/contract-index.md` when present
- `docs/logs/README.md`

Also note `docs/roadmaps/archive/gNN.md` roll-ups that already exist.

### 2. Classify each expanded generation

From content and references, not from folder count:

- **active** — the sequential current generation, or an explicit parallel
  active generation named as active by front doors;
- **safely closed** — generation-index or equivalent closure record says
  closed, no milestone or card remains executable, and no unresolved
  preservation blocker remains after promotion/rehoming in the later steps;
- **unresolved** — conflicting active/closed state, missing ownership, unique
  authority or open commitment without a destination, or explicit parallel
  actives that still need inspection.

Pre-existing closed generations are in scope even when no new rollover is
happening. A pending-migration note that already names a roll-up destination
does not block compaction once the preservation oracle can pass.

### 3. Preservation manifest

Before rewriting or deleting, freeze:

- classified sources to remove (exact paths);
- unique authority and its chosen destination;
- open commitments and their new active homes;
- selected evidence to keep in the roll-up;
- current links that still point at classified sources.

Do not delete anything that is not on that exact list.

### 4. Promote and rehome

For each safely closed generation:

1. Copy unique durable rules onto their current canonical destination. Do not
   leave the only statement of a live rule inside a file you will delete.
2. Move open and deferred commitments onto the active generation's bounded
   watchlist, backlog, or another current destination. Record an explicit
   removal only when the commitment is deliberately dropped.
3. Keep selected PR, commit, release, and validation references for the
   roll-up. Git remains the full-fidelity archive.

### 5. Write the roll-up

Create or replace `docs/roadmaps/archive/gNN.md` for each safely closed
generation. Required sections:

- generation intent and boundary;
- shipped outcomes grouped by durable capability;
- current canonical destinations for lasting decisions;
- material migrations, compatibility limits, and retained risks;
- deferred or unresolved items and their new destinations;
- selected PR, commit, release, and validation references;
- the succeeding generation.

Required markers: `Status: archived` or `Kind: roll-up` (both is fine).

Must not contain:

- `Status: active`, `Status: ready`, or `Status: in-flight`;
- `## Steps`, `## Execution Plan`, or `## Acceptance Criteria`;
- `Auto-start next card: yes`;
- copied old steps, card instructions, or detailed status narration.

### 6. Rewrite current links

Update every live front door and current caller that pointed at a classified
source so it points at the roll-up, the promoted canonical destination, or the
active generation. Current work must remain legible without opening an
archive. Do not leave an active page pointing into a directory you are about
to remove.

### 7. Delete only classified sources

Remove the exact paths on the preservation manifest: the expanded `gNN/`
tree for each safely closed generation, plus any other classified files listed
there. Do not sweep unclassified files. Do not delete the active generation.

### 8. Validate

Confirm:

- only the active sequential generation remains expanded, unless an explicit
  unresolved or parallel-active disposition remains;
- each compacted generation has a non-procedural `archive/gNN.md`;
- unique rules and open commitments are reachable on current surfaces;
- current Markdown links from front doors no longer target removed paths;
- the preservation oracle below holds.

Run the consumer's cheap docs checks when they exist. Do not invent Northstar
source-only validation.

## Preservation oracle

| Invariant | Fail if |
| --- | --- |
| Current authority is unchanged or deliberately promoted | A deleted file held the only current rule |
| Every open commitment remains reachable | Deferred work exists only in removed history |
| Material outcomes remain traceable | A lasting migration has no PR, commit, release, or retained evidence |
| Historical procedure cannot be mistaken for current authority | A roll-up contains runnable steps or active status |
| Current work is legible without archive reads | The next lane requires opening a roll-up |
| Deletion is exact and reviewable | A broad cleanup removes an unclassified file |

## Report

Return:

- classification of each expanded generation;
- preservation manifest (authority, commitments, evidence, exact deletions);
- mutations applied, or proposals if the caller is read-only;
- unresolved blockers;
- whether lifecycle state may be reported `current`.

Repeat runs on an already compacted consumer must not re-expand closed
generations or churn roll-up content.
