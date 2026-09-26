# Adopt

## A new repository

1. Copy the contents of this skill's `template/` directory into the repository
   root. Leave out `.paseo/` once Queue's no-manifest default (`g01.053`) is
   live; until then, include it if the repository will get Queue work. Omit
   template folders and index rows with nothing true to say yet, such as
   `domain/`.
2. Fill in `AGENTS.md` and `docs/knowledge/vision.md`. Leave the other files
   short until there is something true to say.
3. Write `docs/knowledge/contracts/release.md`, even if the answer is "not
   released yet". Every project documents how it releases.
4. If the repository uses Queue, keep `.paseo/queue.json` at v5 with
   `closeout: "queue"`. Leave out `validation` until Queue supports plain
   pre-merge validation; see below.

## Migrating from the older Northstar shape

The migration is one deliberate cut, done when nothing is in flight.

### Before the cut

1. **Drain.** Hold queued tasks, let running workers finish, and resolve
   blocked ones individually. If one task will run for hours, you don't need to
   wait: Queue chooses closeout from the manifest at the task's merge commit, so
   a task that merges after the cutover gets Queue closeout. Its PR must not
   touch the files the cutover removes (task cards, handoffs), or it will
   conflict; send its worker a revision instruction if it does. While old v4
   closeouts keep landing on `main`, rebase the cutover branch before merging.
2. **Switch the manifest**, and commit it before running the cut tool, because
   `apply` stages its moves and removals and the next commit would sweep them
   in. Set `.paseo/queue.json` to
   `{ "schema": "paseo.queue.control.v5", "closeout": "queue", "hooks": [] }`.
   The old Northstar lifecycle, pre-dispatch and pre-merge hooks go with it. A
   repository with no manifest needs nothing here: don't add one. It moves to
   Queue closeout automatically when Queue's no-manifest default (`g01.053`)
   ships, and until then it should get no Queue work.
3. **Validation command.** Queue does not run plain pre-merge validation yet
   (spec 042 item 3), so the manifest has no `validation` field for now. Work
   out which command will be used: it must validate a fresh disposable checkout,
   install its own dependencies, and exit 0 on pass. A command that needs a
   clean pushed head or a prepared workspace doesn't qualify yet; note that in
   `PAPERCUTS.md`.

### What moves and what stays

Sort every docs folder before cutting:

- **Knowledge:** current truth the project runs on (vision, architecture,
  contracts, domain rules). Moves into `docs/knowledge/`.
- **Product documentation:** guides, usage docs, API references and patterns
  written for the project's users or consumers. Stays where it is, and the
  knowledge index links to it. It is the product, not process.
- **Evidence:** research and audits that still support a current decision.
  Keep the part that matters as a short section in the owning knowledge file,
  and let the rest go to Git history. When a large corpus is cited line by line
  from current knowledge (for example an evidence ledger quoting `#L48`),
  folding it would break those citations. Keep it in place as retained, frozen
  evidence, and list it in `allow`.
- **Executable evidence:** models, proof harnesses and their checker logs or
  receipts (for example a TLA+ model under `docs/research/`). Move them next to
  the code or harness they prove, mark their receipts frozen, and list those in
  `allow`.
- **Process:** roadmaps, cards, handoffs, lifecycle records, routine logs and
  completed sweep runs. Removed. This means Northstar's process records only.
  Evidence logs that the product itself owns and cites (for example
  `system/logs/` read by manifests or skills) stay; freeze them and list them in
  `allow`. So do scripts that read another repository's historical records at a
  pinned commit.

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
   deleted. Re-anchor them to a plan item's lane key (`plan:<key>`, matching
   "(lane `<key>`)" in `docs/plan.md`) or to a `questions.md` ID. Lane keys are
   stable identifiers that other files can cite.
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
   replacement = "Knowledge in docs/knowledge/, intent in docs/plan.md; tasks, briefs, status and outcomes live in Queue."
   owner = "docs/knowledge/README.md"
   terms = ["roadmap card", "generation index", "northstar:lifecycle", "chatterbox handoff"]
   paths = [".northstar/lifecycle/", "docs/roadmaps/", "docs/handoffs/", "docs/logs/"]
   config_keys = ["northstar/queue:hook", "paseo.queue.control.v4"]
   allow = ["CHANGELOG.md"]
   ```
4. **Plan.** Replace roadmaps, generations, runways and workstream tables with
   a short `docs/plan.md`. Held tasks become plan items, and are rebriefed or
   released after the cut.
5. **Remove process records:** `.northstar/lifecycle/`, `docs/roadmaps/`,
   `docs/handoffs/`, and routine `docs/logs/`. Keep a log only if it records an
   incident or a ruling that isn't captured elsewhere yet, and promote that
   ruling. Git keeps everything removed.
6. **Orientation.** Rewrite `AGENTS.md` and `docs/README.md` to the template's
   shape.
7. **Moves and links.** Use the skill's cut tool rather than moving files by
   hand: write the moves, removals and frozen paths into a small JSON plan
   (the format is at the top of `scripts/cut.py`), then run
   `effigy skill run northstar-lean/cut -- apply <plan.json> --dry-run`, then
   again without `--dry-run`. It moves and removes with Git, and recomputes
   every reference from each file's old location: Markdown links, backticked
   paths, and repo-root or `../` paths in code and config (for example
   `include_str!`). Links into removed records become plain text or Git-history
   pointers. Mark immutable artefacts as frozen: released suites, vendored
   mirrors, fixtures, digested receipts and applied migrations are never
   rewritten.
8. **Leftover process in knowledge.** Remove "Next Task" sections, status
   narration ("no generation is active") and "open a roadmap card" wording
   from knowledge files. Product docs that teach the old conventions, such as a
   guide to writing AGENTS files, get updated too.
9. **Housekeeping.** Delete closed papercuts and closed or already-promoted
   triage notes. `PAPERCUTS.md` lives at the repository root, where Effigy's
   papercuts tooling reads it (package-level copies such as
   `apps/<app>/PAPERCUTS.md` are fine). Fold any stray copy, such as
   `docs/PAPERCUTS.md`, into the root file and delete it.
10. **Checks.** Search QA configuration (`effigy.toml`, CI), tests, scripts,
    receipts, repo-local skills (for example `.cursor/skills/`, `.agents/`) and
    agent instruction files for paths, headings, selector names and old-loop
    habits (Next Task, card numbering, generation rules) from the old layout.
    Rewrite skills that encode the old loop; don't just repoint them.
    Code reads docs too: `include_str!`, census scripts, adoption receipts that
    embed log paths. Update or remove those checks in the same PR, and say
    which ones changed in the PR description. Don't wire the retired-concepts
    check into repository QA: it needs the Northstar skill installed, so it is
    run through `effigy skill`. If a pre-push hook refuses several
    docs-touching commits, squash the cut into one commit.
11. **Verify.** Run the repository's QA, then
    `effigy skill run northstar-lean/retired-concepts` and
    `effigy skill run northstar-lean/cut -- check-links --plan <plan.json>`
    (the plan supplies the frozen paths), which checks
    Markdown links and anchors across the whole repository and not just the
    docs catalog. It is stricter than `effigy docs check links` and also
    catches broken anchors. The checks find the stragglers the steps above
    missed; fix them rather than widening `allow`. The one exception is frozen
    artefacts from your cut plan: the retired-concepts check doesn't read that
    plan, so list those in `allow` as well. When you work in a worktree, confirm
    which tree each check actually ran against: container-routed tasks may
    mount the main checkout instead.

Review the cut like any PR: nothing current lost, no fact with two owners, and
every link resolving.

### After the cut

Submit new work as briefs. Release held tasks only once they are rebriefed, or
confirmed to fit the new shape.
