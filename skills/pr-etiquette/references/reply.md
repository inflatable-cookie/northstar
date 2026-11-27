# Reply to review feedback

Part of `pr-etiquette`; its noise rules apply here too.

- Fetch every unresolved thread before starting. GitHub returns threads
  oldest first, so page through all of them.
- Work through actionable threads in one batch: verify each point against the
  code, fix and commit cleanly (never push empty commits to re-run checks),
  run checks, push once, then reply inline in each thread with the commit
  SHA and a sentence on what changed.
- Resolve threads opened by agents once fixed. Leave a human's thread for
  them to resolve unless they asked otherwise.
- Disagree inline with a technical reason. No performed agreement or thanks.
- Never reply "Acknowledged", "Done" without a SHA, or "tracked as follow-up"
  without a link to the tracked item.
- Leave threads needing a human decision open, stating the question once.
- Skip non-actionable comments silently: bot summaries, CI notices,
  approvals, and threads you have already answered.
- Before asking for re-review, score the PR yourself against the reviewer's
  rubric and target ([review.md](review.md)), and sync the description if
  the diff moved.
