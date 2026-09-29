# Adopt

## A new repository

1. Copy the contents of this skill's `template/` directory into the repository
   root. The repository carries no Queue files: Queue gives a repository
   without `.paseo/queue.json` Queue closeout by default, and per-repository
   overrides live in Queue's repository settings (`repository.set`). Omit
   template folders and index rows with nothing true to say yet, such as
   `domain/`.
2. Fill in `AGENTS.md` and `docs/knowledge/vision.md`. Leave the other files
   short until there is something true to say. The template is a minimum, not
   a maximum: keep hard-won project lessons in `AGENTS.md`. Split
   `architecture.md` into an `architecture/` folder once it outgrows a page.
   Language quality profiles stay wherever their optional module expects
   them.
3. Write `docs/knowledge/contracts/release.md`, even if the answer is "not
   released yet". Every project documents how it releases.
4. Set up planning in Queue: a lane per outcome the project is pursuing, each
   with a lane document, then the order with `plan.set`. See
   [plan](plan.md).

## Migrating from the older Northstar shape

The migration is one deliberate cut. Draining first is simplest; cutting with
tasks in flight is safe if their handoffs stay.

### Before the cut

1. **Drain, or keep in-flight handoffs.** Either hold queued tasks, let
   running workers finish and resolve blocked ones individually, or cut with
   tasks still in flight. Queue chooses closeout from the manifest at the
   task's merge commit, so a task that merges after the cutover gets Queue
   closeout. Queue also re-reads a handoff-mode task's committed handoff at
   dispatch, at dispatch-base rebinding and at worker readiness (after the
   worker merges `main`). A handoff deleted while its task is queued or working
   leaves that task in needs_attention with no retry route. So keep the handoff
   file of every task still in flight, list it in `allow`, and delete both the
   file and its `allow` entry as the task closes.
   A worker's PR must not touch the files the cutover removes either; send it a
   revision instruction if it does. While old v4 closeouts keep landing on
   `main`, rebase the cutover branch before merging.
2. **Drop the manifest.** Delete `.paseo/queue.json`, and with it the old
   Northstar lifecycle, pre-dispatch and pre-merge hooks. Queue gives a
   repository without a manifest Queue closeout by default. Commit this before
   running the cut tool, because `apply` stages its moves and removals and the
   next commit would sweep them in.
3. **No per-task validation command.** Queue can run a repository command
   before every merge (`repository.set` `validation`), but leave it unset:
   full QA per task costs more machine time than it saves (Tom, 2026-09-30).
   Tasks run targeted checks, and the planner runs full QA on `main` at
   milestones.

### What moves and what stays

Sort every docs folder before cutting:

- **Knowledge:** current truth the project runs on (vision, architecture,
  contracts, domain rules). Moves into `docs/knowledge/` whole. Lean means no
  process records, not shorter knowledge: keep detailed design detailed, and
  cut only process narration, duplication and what is no longer true. Merge
  documents only where they overlap.
- **Product documentation:** guides, usage docs, API references and patterns
  written for the project's users or consumers. Stays where it is, and the
  knowledge index links to it. It is the product, not process. That includes
  public API contracts a product already publishes (for example at
  `docs/contracts/`): they stay put, and `docs/knowledge/contracts/` holds the
  project's internal rules. The knowledge index names both.
- **Evidence:** research and audits that still support a current decision.
  Keep the part that matters as a short section in the owning knowledge file,
  and let the rest go to Git history. When a large corpus is cited line by line
  from current knowledge (for example an evidence ledger quoting `#L48`),
  folding it would break those citations. Keep it in place as retained, frozen
  evidence, and list it in `allow`.
- **Executable evidence:** models, proof harnesses and their checker logs or
  receipts (for example a TLA+ model under `docs/research/`). Move them next to
  the code or harness they prove, mark their receipts frozen, and list those in
  `allow`. An existing evidence folder that scripts own and whose receipts
  embed their own paths can stay where it is (for example `docs/evidence/`);
  freeze it rather than regenerating it.
- **Process:** roadmaps, cards, handoffs, lifecycle records, routine logs and
  completed sweep runs. Removed. This means Northstar's process records only.
  Evidence logs that the product itself owns and cites (for example
  `system/logs/` read by manifests or skills) stay; freeze them and list them in
  `allow`. So do scripts that read another repository's historical records at a
  pinned commit. A repository that implements the old protocol for others (Queue
  itself, which serves v1–v4 manifests, handoff paths and lifecycle records)
  lists its implementation paths in `allow`: there they are product, not
  process.

A reusable checklist, such as a security sweep procedure, is knowledge. A
record of one run of it is process.

### The cut, in one PR

1. **Knowledge.** Move current contracts, architecture, vision and domain docs
   into `docs/knowledge/`, and write its index with one owner per topic. Merge
   duplicates as you go; where two files disagree, ask the operator and record
   the ruling.
2. **Rulings and procedures.** Fold decision registers, and the decisions
   buried in task cards, into their owning knowledge files. At scale: a
   register row whose authority names an owning file has already landed there;
   a row with no owner gets folded by hand; rows about process or dispatch go
   to Git. Rulings buried in hundreds of logs can't all be swept during the
   cut, so add "sweep removed records for rulings" to the plan instead. Do the same for
   procedures that live in cards or logs. The release procedure is required:
   it goes into `docs/knowledge/contracts/release.md`. Answered questions go
   into `questions.md` as pointers; unanswered ones stay open there. Rules that
   cite a task (for example "a gap must name its open card") can't simply be
   deleted. Re-anchor them to a Queue lane key (`lane:<key>`) or to a
   `questions.md` ID. Lane keys are stable identifiers that other files can
   cite.
3. **Retirements.** Record known retired concepts in `retired.toml`, and fix
   the live references the check finds. Always retire the old process itself,
   so it can't creep back:

   Keep retired terms multi-word and specific to the old process. A bare word
   like "generation" collides with ordinary domain vocabulary. Retire the
   process paths you removed, not the knowledge paths you moved: generic paths
   such as `docs/contracts/` also appear in quoted paths from other
   repositories.

   ```toml
   [[retired]]
   id = "northstar-process-records"
   retired = "<cut date>"
   replacement = "Knowledge in docs/knowledge/; the plan, leads, papercuts, briefs, tasks, status and outcomes live in Queue."
   owner = "docs/knowledge/README.md"
   terms = ["roadmap card", "generation index", "northstar:lifecycle", "chatterbox handoff"]
   paths = [".northstar/lifecycle/", "docs/roadmaps/", "docs/handoffs/", "docs/logs/"]
   config_keys = ["northstar/queue:hook", "paseo.queue.control.v4"]
   allow = ["CHANGELOG.md"]

   [[retired]]
   id = "repository-planning-files"
   retired = "<cut date>"
   replacement = "The plan is Queue lanes, lane documents and plan order; leads are Queue records (lead.add)."
   owner = "docs/knowledge/README.md"
   paths = ["docs/plan.md", "docs/triage/"]
   allow = ["CHANGELOG.md"]
   ```
4. **Plan.** Replace roadmaps, generations, runways and workstream tables with
   Queue lanes, lane documents and a project plan (see [plan](plan.md)).
   Mapping prose to lanes is judgment, so do it by hand. Held tasks either join
   a lane or become leads, and are rebriefed or released after the cut.
5. **Remove process records:** `.northstar/lifecycle/`, `docs/roadmaps/`,
   `docs/handoffs/` (except handoffs of tasks still in flight; see step 1),
   and routine `docs/logs/`. Keep a log only if it records an
   incident or a ruling that isn't captured elsewhere yet, and promote that
   ruling. Git keeps everything removed.
6. **Orientation.** Rewrite `AGENTS.md` and `docs/README.md` to the template's
   shape.
7. **Moves and links.** Use the skill's cut tool rather than moving files by
   hand: write the moves, removals and frozen paths into a small JSON plan
   (the format is at the top of `scripts/cut.py`), then run
   `effigy skill run northstar/cut -- apply <plan.json> --dry-run`, then
   again without `--dry-run`. It moves and removes with Git, and recomputes
   every reference from each file's old location: Markdown links, backticked
   paths, and repo-root or `../` paths in code and config (for example
   `include_str!`). Links into removed records become plain text or Git-history
   pointers. Write any history pointer you add by hand in the same style,
   `` `name.md` (Git history) ``, without the removed path: the
   retired-concepts check flags removed paths. Mark immutable artefacts as
   frozen: released suites, vendored
   mirrors, fixtures, digested receipts and applied migrations are never
   rewritten.
8. **Leftover process in knowledge.** Remove "Next Task" sections, status
   narration ("no generation is active") and "open a roadmap card" wording
   from knowledge files. Rewrite working-rules or delivery-grammar contracts
   that encode the old loop (roadmap delivery grammar, "a bare continue runs
   the next roadmap task") around Queue's plan and briefs. Product docs that teach the old conventions, such as a
   guide to writing AGENTS files, get updated too.
9. **Housekeeping.** Delete closed or already-promoted triage notes, and
   import the rest with `lead.import` (`repository: {origin, path}`, `path` to
   the absolute `docs/triage` directory, `dryRun: true` first); then delete `docs/triage/`. Import
   the repository's papercuts into Queue with `papercut.import` (use
   `root: true` to include package copies such as `apps/<app>/PAPERCUTS.md`,
   and do a dry run first). Check the report: every open entry imported,
   nothing but boilerplate unparsed. Then delete every `PAPERCUTS.md` and
   update any instruction that tells agents to write to it.
10. **Checks.** Search QA configuration (`effigy.toml`, CI), tests, scripts,
    receipts, repo-local skills (for example `.cursor/skills/`, `.agents/`),
    agent instruction files, and release/CI scope or admission policies that
    require or admit process paths (for example a release gate that demands a
    `docs/logs/` record), for paths, headings, selector names and old-loop
    habits (Next Task, card numbering, generation rules) from the old layout.
    Rewrite skills that encode the old loop; don't just repoint them. The cut
    tool can't see paths built from segments (`path.join(root, "docs",
    "architecture")`), so search for those too. Evidence gates that pin source
    trees byte for byte (receipts over a runtime folder) break when the cut
    rewrites comments or links inside them: freeze those trees in the cut plan,
    or schedule an evidence repin. A gate
    that reads task status from process files (for example to detect stale
    rows) must be redesigned, because status now lives in Queue: make it
    refuse task IDs, or anchor it to plan lane keys.
    Code reads docs too: `include_str!`, census scripts, adoption receipts that
    embed log paths, and tests that use a doc file as a fixture target (for
    example a symlink test pointing at `PAPERCUTS.md`). Update or remove those checks in the same PR, and say
    which ones changed in the PR description. Don't wire the retired-concepts
    check into repository QA: it needs the Northstar skill installed, so it is
    run through `effigy skill`. If a pre-push hook refuses several
    docs-touching commits, squash the cut into one commit.
11. **Verify.** Run the repository's QA, then
    `effigy skill run northstar/retired-concepts` and
    `effigy skill run northstar/check-links -- --plan <plan.json>`
    (the plan supplies the frozen paths). Copy the plan's frozen paths into
    `retired.toml`'s top-level `frozen` list (as globs), so later runs need no
    plan. It checks
    Markdown links and anchors across the whole repository and not just the
    docs catalog. It is stricter than `effigy docs check links` and also
    catches broken anchors. The checks find the stragglers the steps above
    missed; fix them rather than widening `allow`. The one exception is frozen
    artefacts from your cut plan: the retired-concepts check doesn't read that
    plan, so list those in `allow` as well. When you work in a worktree, confirm
    which tree each check actually ran against: container-routed tasks may
    mount the main checkout instead.

The planner lands the cut as its own PR and merges it itself when the
repository's QA passes, and CI where it exists. The operator doesn't review
planner PRs. If CI only runs on manual dispatch, run it on the branch
(`gh workflow run ci.yml --ref <branch>`). Without CI, the local board is the
gate. Under heavy machine load, rerun each failing or hung test file alone and
run the same files on `main`. A failure that also appears on `main`, or passes
alone, is load, not the cut. Don't wait for the load to clear: file each
load-sensitive test as a papercut so it gets fixed.

Review the cut like any PR: nothing current lost, no fact with two owners, and
every link resolving.

### After the cut

Submit new work as briefs in Queue leads (see [brief](brief.md)). Release held tasks only once they are rebriefed, or
confirmed to fit the new shape.

## Moving an already-lean repository's plan and triage into Queue

Repositories that migrated before planning moved to Queue still carry
`docs/plan.md` and `docs/triage/`. Move them in one small change on `main`:

1. **Lanes.** For each plan item under Now or Next, find or create its lane
   (`lane.upsert`; keep an existing lane's title, aim and full repository
   list). Write the item's intent into the lane document
   (`lane.document.edit`): outcome, why, dependencies, question IDs, caveats.
   Merge it into an existing document rather than overwriting.
2. **Order.** `plan.get`, then `plan.set` with the lanes in plan order, Now as
   horizon `now` and Next as `later`, with the one-line note from the item.
   Keep other lanes already in the plan.
3. **Deferrals.** Each Not now item becomes an open lead (`lead.add`) whose body
   says why it waits.
4. **Leads.** Delete triage notes that are closed or already promoted. Import
   the rest with `lead.import` (`repository: {origin, path}`, `path` to the
   absolute `docs/triage` directory, `dryRun: true` first), and check that the
   report shows every note imported; the directory `README.md` is reported as
   unparsed, which is expected.
5. **Remove and retire.** Remove both paths with the cut tool, not by hand, so
   links into them become plain text: a cut plan with
   `"removed": ["docs/plan.md", "docs/triage/"]` and the `frozen` list from
   `retired.toml`, dry run first. The tool never rewrites frozen evidence, so a
   frozen file that links into either path keeps a dead link: exclude frozen
   paths from the repository's own link check, as `check-links` already does. Add
   the `repository-planning-files` entry from step 3 of the migration above to
   `retired.toml`. Then fix the live references it finds:
   - `AGENTS.md` and `docs/README.md`: use the template's wording, which
     describes the change without naming the retired paths;
   - rules anchored to `docs/plan.md` items: re-anchor them to `lane:<key>`.
     An offline check can validate only the key's form, not that the lane is
     still open, so name the lane in the rule's text and let review catch a
     closed one;
   - docs checks, scripts and required-file lists that expect either path.
   Product code or tests that use a file named `plan.md` for their own
   purposes are not planning files; list them in `allow`.
6. **Verify.** Run the repository's docs checks, then `retired-concepts` and
   `check-links`, and check the exit codes. Commit straight to `main`.
