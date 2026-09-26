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
   buried in task cards, into their owning knowledge files. Do the same for
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
   terms = ["roadmap card", "generation index", "lifecycle record", "northstar:lifecycle", "chatterbox handoff"]
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
   shape, and update links.
7. **Checks.** Search QA configuration (`effigy.toml`, CI) and tests for paths
   and headings from the old layout, and update or remove those checks in the
   same PR. Say which ones changed in the PR description.
8. **Verify.** Run the repository's QA and
   `effigy skill run northstar-lean/retired-concepts`.

Review the cut like any PR: nothing current lost, no fact with two owners, and
every link resolving.

### After the cut

Submit new work as briefs. Release held tasks only once they are rebriefed, or
confirmed to fit the new shape.
