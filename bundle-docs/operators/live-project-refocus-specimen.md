# Live Project Refocus Specimen

This specimen shows how to recover a drifting project without pretending the
current roadmap is still trustworthy.

Use it when:

- roadmap work has outrun architecture or contracts
- multi-repo ownership is unclear
- research-driven bets were never promoted into contracts
- a project needs to be reorganized around strict planning before execution can
  continue

## Scenario

A product team has three active repos:

- `product-web`
- `product-api`
- `product-worker`

The active roadmap generation is `g01`.
`g01.001` shipped a foundation batch successfully.
`g01.002` started describing analytics export work, but the downstream sink repo
was never contracted and ownership is unclear.
Agents started sketching likely export behavior in roadmap prose and partial
implementation notes.

The refocus goal is to stop that drift, repair the planning surfaces, and hand
execution back only when a valid roadmap batch exists again.

## Step 1: Audit Before Editing

Read these surfaces first:

- `docs/architecture/system-architecture.md`
- `docs/architecture/system-inventory.md`
- `docs/architecture/repo-authority-map.md`
- `docs/contracts/contract-index.md`
- active contracts in `docs/contracts/`
- active roadmap milestones in `docs/roadmaps/g01/`
- latest relevant logs in `docs/logs/YYYY-MM/`
- `docs/research/translation-memos/` when the seam is research-driven

Expected findings in this specimen:

- `g01.002` describes work that depends on `analytics-export`
- `analytics-export` is missing or unresolved in planning artifacts
- no seam contract exists for the export boundary
- roadmap prose implies behavior that no contract currently authorizes

## Step 2: Freeze Invalid Execution

Do not keep the milestone half-alive while “figuring it out.”

Valid actions:

- mark the affected milestone `blocked`
- add `Planning Gaps` entries for the missing seam and authority owner
- stop implementation batches that depend on the missing contract

In the template-bundle specimen, this state is represented by:

- [002-example-analytics-export.md](~/Dev/projects/northstar/template-bundle/roadmaps/g01/002-example-analytics-export.md)
- [02-100000-example-planning-gap-g01-002-analytics-export.md](~/Dev/projects/northstar/template-bundle/logs/YYYY-MM/02-100000-example-planning-gap-g01-002-analytics-export.md)

## Step 3: Repair Planning Coverage

Repair the planning surfaces before touching roadmap execution again.

Checklist:

1. Update `system-inventory.md` so the unresolved seam is visible.
2. Update `repo-authority-map.md` so the source repo, consumer repo, and
   authority owner are explicit.
3. Update `contract-index.md` so the seam appears as pending or active instead
   of being implied only by roadmap prose.
4. Create or update the governing contract once ownership is resolved.

In the specimen chain:

- [example-system-inventory.md](~/Dev/projects/northstar/template-bundle/architecture/example-system-inventory.md) shows the seam as a planning gap.
- [example-repo-authority-map.md](~/Dev/projects/northstar/template-bundle/architecture/example-repo-authority-map.md) shows the cross-repo authority surface.
- [example-contract-index.md](~/Dev/projects/northstar/template-bundle/contracts/example-contract-index.md) shows the seam blocked until contracted.

## Step 4: Record the Contract Delta

Once the missing seam has an owner, promote it into a contract and record the
change in the log flow.

Why this matters:

- it makes the replan visible
- it shows which planning gap was closed
- it keeps roadmap recompilation tied to explicit contract movement

In the specimen chain:

- [03-110000-example-contract-delta-g01-002-analytics-export.md](~/Dev/projects/northstar/template-bundle/logs/YYYY-MM/03-110000-example-contract-delta-g01-002-analytics-export.md)

## Step 5: Decide Recompile vs `g02` Rollover

Do not patch the old roadmap by instinct.
Make the choice explicitly.

Recompile inside the current generation when all are true:

- the affected work is localized to one or a few milestones
- the generation’s overall sequencing logic still holds
- contract repairs do not invalidate the rest of the active queue

Open `g02` when any are true:

- the contract shift changes the sequencing baseline across the program
- multiple milestones in `g01` now depend on the repaired boundary
- ownership or repo topology changed broadly enough that the old queue is
  misleading
- maintainers can no longer tell which `g01` items are still valid without a
  broad rewrite

In this specimen, `g01.002` is recompiled in-place because the export seam is a
localized correction and `g01.001` remains valid.

## Step 6: Recompile the Milestone

Once planning is coherent again:

- update contract refs
- change planning state from `blocked` to `ready` only if the contract chain is
  complete
- replace planning-repair-only tasks with the first contract-valid execution
  batch
- update evidence requirements so the next execution log validates the new seam

In the specimen chain:

- [04-120000-example-roadmap-recompile-g01-002.md](~/Dev/projects/northstar/template-bundle/logs/YYYY-MM/04-120000-example-roadmap-recompile-g01-002.md)

## Step 7: Hand Execution Back Cleanly

Only hand execution back once there is a trustworthy starting point.

The handoff target should be:

- one roadmap milestone with `Planning state: ready`
- direct `Contract refs`
- explicit acceptance criteria and evidence requirements
- no unresolved planning gaps that still govern the next batch

At that point, execution can continue from the first newly valid batch.
If the project uses a continuation artifact, create it after the recompile, not
before.

## Failure Modes To Reject

- keeping a stale milestone “mostly active” while the contract is still missing
- moving implementation ahead and promising to backfill the contract later
- hiding a planning gap inside `Risks and Mitigations`
- treating cross-repo ownership as “obvious” without writing it down
- preserving `g01` out of inertia when a new generation boundary is clearly
  needed

## Recommended Operator Sequence

1. Run the sweep pack, especially [08-planning-gate-sweep.md](~/Dev/projects/northstar/bundle-docs/sweeps/08-planning-gate-sweep.md).
2. Use the refocus prompt at [project-refocus-starter-prompt.md](~/Dev/projects/northstar/bundle-docs/operators/project-refocus-starter-prompt.md) or the `northstar` skill router mode `refocus-drifted-project` at [skills/northstar/references/router.md](~/Dev/projects/northstar/skills/northstar/references/router.md).
3. Freeze invalid roadmap work.
4. Repair planning surfaces and contracts.
5. Decide recompile versus rollover explicitly.
6. Hand execution back from the first contract-valid batch.

## Next task

For the harder rollover case, use these companion artifacts:

- [001-example-platform-reset.md](~/Dev/projects/northstar/template-bundle/roadmaps/g02/001-example-platform-reset.md)
- [05-130000-example-rollover-decision-g02.md](~/Dev/projects/northstar/template-bundle/logs/YYYY-MM/05-130000-example-rollover-decision-g02.md)
- [06-140000-example-contract-delta-g02-platform-reset.md](~/Dev/projects/northstar/template-bundle/logs/YYYY-MM/06-140000-example-contract-delta-g02-platform-reset.md)
- [07-150000-example-first-batch-g02-001.md](~/Dev/projects/northstar/template-bundle/logs/YYYY-MM/07-150000-example-first-batch-g02-001.md)

Next task: add a compact operator checklist that compares the strict-planning,
refocus, roadmap-compiler, and replan skills so teams know which entry point to
invoke for each planning situation.
