# Review a PR

Part of `pr-etiquette`; its noise rules apply here too.

Skip drafts, closed PRs, and PRs you have already reviewed at this head.

1. Read the description, linked issue, project rules, and the diff, and run
   the covering checks if available (otherwise inspect CI results).
2. Draft findings privately and rate confidence out of 10: **9–10** proven
   in code or a run; **8** verified against surrounding code or rules as a
   real bug, risk, missing failure-path test, real gap, or misleading
   description; **7 or below** unverified hunch, preference, or nit. Verify
   candidates at 7+ against surrounding code, callers, or a test run, then
   post only those holding at 8+ — as blocking issues when they must be fixed
   before merge, or non-blocking suggestions when they are verified real gaps
   that don't block. Drop nits.
3. Don't flag issues outside the diff, anything a linter or compiler catches,
   style preferences, speculation, or anything deliberately silenced in code.
4. Score the PR out of 10 (change and description together): **10** nothing
   worth changing; **9** ready to merge, minor polish at most; **8** sound,
   no bugs, minor real gaps; **7** a bug, a missing failure-path test, or a
   misleading description; **5–6** structural problems, several bugs, or an
   oversized PR to split; **below 5** wrong approach or unsafe.
   **Target is 8**: approve sound PRs and leave minor gaps as non-blocking
   suggestions, since each round of requested changes costs a full author
   run and re-review. A task brief or the project's agent instructions can
   set another with a line such as `PR review target: 9`; the most specific
   wins.
5. Keep score and action honest: a score below target needs a blocking
   finding to explain it, and a finding caps the score at its anchor (a bug
   caps it at 7). Approve at or above target; request changes (or comment,
   if you can't) below it.
6. Post one review opening with a single line giving the score, target, and
   what stands between them, such as `7/10, target 8: one blocking bug in
   retry handling.` A clean PR gets that line alone. If a task system
   publishes reviews (you report a verdict and it posts), report through its
   protocol instead of posting your own review, keeping the score line and
   labels in the report where its format allows.

Label inline comments `issue (blocking):`, `suggestion (non-blocking):`,
or `question:` (only when ambiguity could hide a real problem). Each blocking
comment says why it matters and what resolves it. Post one comment per issue,
listing all locations for a repeated pattern. Offer a suggestion block only
when committing it fixes the problem completely. Link code by full commit
SHA. No opening praise and no diff summary.

On re-review after new commits, check prior blockers and regressions in the
new diff without inventing fresh minor issues on untouched code, then
re-score.
