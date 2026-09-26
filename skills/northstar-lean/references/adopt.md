# Adopt

## A new repository

1. Copy the contents of this skill's `template/` directory into the repository
   root, including the hidden `.paseo/`.
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
   blocked ones individually. No task in the repository may be active.
2. **Switch the manifest.** Set `.paseo/queue.json` to
   `{ "schema": "paseo.queue.control.v5", "closeout": "queue", "hooks": [] }`
   once Queue supports it. The old Northstar lifecycle, pre-dispatch and
   pre-merge hooks go with it.
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
  and let the rest go to Git history.
- **Process:** roadmaps, cards, handoffs, lifecycle records, routine logs and
  completed sweep runs. Removed.

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
   into `questions.md` as pointers; unanswered ones stay open there.
3. **Retirements.** Record known retired concepts in `retired.toml`, and fix
   the live references the check finds. Always retire the old process itself,
   so it can't creep back:

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
   triage notes.
10. **Checks.** Search QA configuration (`effigy.toml`, CI), tests, scripts
    and receipts for paths, headings and selector names from the old layout.
    Code reads docs too: `include_str!`, census scripts, adoption receipts that
    embed log paths. Update or remove those checks in the same PR, and say
    which ones changed in the PR description.
11. **Verify.** Run the repository's QA, then
    `effigy skill run northstar-lean/retired-concepts` and
    `effigy skill run northstar-lean/cut -- check-links`, which checks
    Markdown links and anchors across the whole repository and not just the
    docs catalog. The checks find the stragglers the steps above missed; fix
    them rather than widening `allow`. When you work in a worktree, confirm
    which tree each check actually ran against: container-routed tasks may
    mount the main checkout instead.

Review the cut like any PR: nothing current lost, no fact with two owners, and
every link resolving.

### After the cut

Submit new work as briefs. Release held tasks only once they are rebriefed, or
confirmed to fit the new shape.
