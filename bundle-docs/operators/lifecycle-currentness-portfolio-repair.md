# Lifecycle Currentness Portfolio Repair Prompt

Run this against each adopted portfolio repository after the `g03.012`
terminal hook publishes and installed-skill parity holds. Give it to the
owning project's Chatterbox — never run it from Northstar as a cross-repo
mutation lane. One repository at a time; each repository validates locally
before the next repair is dispatched.

The prompt inventories duplicate mechanical currentness first, repairs only
exact accepted removals, returns ambiguous prose to judgment instead of
rewriting it, and edits no product files.

## Copy/paste prompt

```text
Run the bounded lifecycle-currentness repair for this repository.

This message authorizes inventory, classification, and the exact accepted
removals listed below on documentation and planning surfaces only. It does
not authorize product code, releases, a new product lane, generation
rollover or compaction, abandonment of queued work, or any rewrite of
semantic prose (goals, history, policy, decisions, continuation). When in
doubt, report the finding and stop; do not reword around it.

Use the currently installed Northstar skill. Confirm it exposes
`lifecycle:run audit-currentness` and that the Queue hook refuses closeout
when tracked durable Markdown still links to the exact submitted handoff.
If either is missing, stop and report that exact blocker.

Phase 1: dry-run inventory (no edits)

1. Record the repository, integration branch, exact head, worktree state,
   and active generation set from the committed
   `.northstar/lifecycle/v1/projection-targets.json`.
2. Run `effigy lifecycle:run audit-currentness --repo .` and keep its exact
   violations (file, section, task, reason).
3. For every unreferenced worker handoff under `docs/handoffs/` (a handoff
   whose task already has a terminal record or a pending closeout), search
   tracked Markdown for links resolving to that exact path. Relative, rooted,
   and reference-style spellings (resolved through their definitions) count;
   external URLs and similarly named files do not.
4. Classify each finding:
   - Definite: `duplicate-status-header` on a lifecycle-record task path or
     declared target; `stale-frontier` or `stale-next-task-column` naming a
     terminal task; an exact Markdown backlink to a transient handoff.
   - Needs judgment: task IDs in ambiguous prose outside a live-currentness
     section, goal wording that could be history or could be a stale claim,
     or any finding whose removal would touch semantic meaning. Return these
     to Chatterbox with the exact file and lines. Do not repair them here.

Phase 2: exact repair only

Apply definite findings and nothing else:

- Delete the hand-maintained `Status:` header line on lifecycle-record task
  paths and declared targets. Leave every surrounding semantic line
  byte-identical.
- Replace a Next-task section or table cell naming a terminal task with
  sequencing intent that names no lifecycle-managed task (for example
  `no further lane`, `return to Chatterbox planning checkpoint`). Leave
  Goal/State history cells (`complete as gNN.NNN`) untouched.
- Remove the exact backlink to a transient handoff, or repoint it at the
  permanent surface (task, contract, PR, commit, or log). Never delete the
  handoff file itself; the closeout hook owns that.
- Preserve active planning: nonterminal lanes keep their outcome, decisions,
  dependencies, acceptance, and continuation exactly. Goal history and
  retrospective sections stay legal and are never "cleaned up".

Phase 3: prove and land per repository

- `effigy lifecycle:run audit-currentness --repo .` is clean.
- The lifecycle projection verifies (`verify` reports no drift) and the
  generated blocks are byte-unchanged except through the record/projection
  path.
- Run the repository's docs checks and normal QA required for documentation
  changes. Run `git diff --check`.
- Land through the repository's normal review, merge, and closeout flow.
  The hook's backlink guard is the final proof: closeout must not refuse.

Return one final report containing:

- inventory (violations plus backlink search results);
- definite versus needs-judgment classification with exact paths;
- exact lines removed or replaced (no paraphrase);
- validation evidence;
- needs-judgment items returned untouched;
- whether the repository is current.

Keep operator notifications to a decision-changing blocker or this final
report. Do not send routine progress commentary.
```

## Completion boundary

The portfolio repair is complete when every adopted repository either audits
clean with hook closeout unblocked, or carries an explicit Chatterbox-owned
judgment queue for its ambiguous prose. This prompt is repair authority only;
later product work still needs its normal ready task.
