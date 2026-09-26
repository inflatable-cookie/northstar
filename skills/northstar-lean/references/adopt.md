# Adopt

## A new repository

1. Copy the contents of this skill's `template/` directory into the repository
   root, including the hidden `.paseo/`.
2. Fill in `AGENTS.md` and `docs/knowledge/vision.md`. Leave the other files
   short until there is something true to say.
3. If the repository uses Queue, keep `.paseo/queue.json` at v5 with
   `closeout: "queue"`, and add `validation` once the repository has a command
   that validates a fresh checkout.

## Migrating from the older Northstar shape

The migration is one deliberate cut, done when nothing is in flight.

### Before the cut

1. **Drain.** Hold queued tasks, let running workers finish, and resolve
   blocked ones individually. No task in the repository may be active.
2. **Switch the manifest.** Set `.paseo/queue.json` to
   `{ "schema": "paseo.queue.control.v5", "closeout": "queue", "hooks": [] }`
   once Queue supports it. The old Northstar lifecycle, pre-dispatch and
   pre-merge hooks go with it.
3. **Validation command.** Define a command that validates a fresh checkout
   (it installs its own dependencies and exits 0 on pass). Add it as the
   manifest's `validation` once Queue supports plain pre-merge validation.

### The cut, in one PR

1. **Knowledge.** Move current contracts, architecture, vision and domain docs
   into `docs/knowledge/`, and write its index with one owner per topic. Merge
   duplicates as you go; where two files disagree, ask the operator and record
   the ruling.
2. **Rulings.** Fold decision registers, and the decisions buried in task
   cards, into their owning knowledge files. Answered questions go into
   `questions.md` as pointers; unanswered ones stay open there.
3. **Retirements.** Record known retired concepts in `retired.toml`, and fix
   the live references the check finds.
4. **Plan.** Replace roadmaps, generations, runways and workstream tables with
   a short `docs/plan.md`. Held tasks become plan items, and are rebriefed or
   released after the cut.
5. **Remove process records:** `.northstar/lifecycle/`, `docs/roadmaps/`,
   `docs/handoffs/`, and routine `docs/logs/`. Keep a log only if it records an
   incident or a ruling that isn't captured elsewhere yet, and promote that
   ruling. Git keeps everything removed.
6. **Orientation.** Rewrite `AGENTS.md` and `docs/README.md` to the template's
   shape, and update links.

Review the cut like any PR: nothing current lost, no fact with two owners, and
every link resolving.

### After the cut

Submit new work as briefs. Release held tasks only once they are rebriefed, or
confirmed to fit the new shape.
