# Direct PR Review Mode

Use this mode when the operator asks the current thread to review an existing
pull request. It is the fresh-thread review entrypoint; it does not start an
orchestrator or worker lane.

## Authority boundary

An explicit request to review a PR authorizes review mutations on that PR:
submitting a provider review, adding inline review comments, or posting the
same-identity fallback comment below. It does not authorize branch edits,
commits, pushes, merge, closeout changes, or unrelated provider mutations.

The provider review surface is the durable result. Chat is a short summary, not
the only home of a finding. Never leave a blocking finding only in chat.

An orchestrator launches this mode in the existing worker workspace under a
serial clean exact-head lease for a worker PR. The boundaries are identical:
independent review from the PR and canonical refs, no branch mutation, and the
durable verdict posted on the provider. Under that lease:
- verify index and worktree are clean before review;
- run inspection and test/check commands without editing tracked files,
  committing, pushing, or changing branches;
- post the durable verdict on the provider naming the exact head SHA reviewed.

The review child must use a different underlying provider/model identity from
the authoring worker; profile renames, reasoning level changes, and fresh
threads using the same provider/model do not qualify. Use the same distinct
reviewer for revision rounds when available; a replacement reviewer starts a
complete fresh review and never inherits an unseen verdict.

## Procedure

1. Resolve the named PR and target repository. Read the applicable `AGENTS.md`
   files plus the canonical architecture, contracts, specs, cards, or issue
   refs named by the PR or needed to judge its changed paths. Do not run worker
   startup or inspect worker-local path configuration.
2. Inspect the PR metadata, base and head, commits, changed files, full diff,
   existing review discussion, and checks. Review the evidence independently
   of the PR description or author narrative.
3. Look for correctness, regressions, missing promised behavior or tests,
   contract violations, hidden scope, and unsafe boundary changes. Keep
   non-blocking taste separate from changes required for merge.
4. Finish the review pass before publishing. For every blocking finding, record
   the impact, evidence, precise file/line or changed surface, and the condition
   that would resolve it. Prefer inline comments where the provider supports
   them; otherwise include exact path and line references in the review body.
5. Publish one coherent provider review before replying in chat:
   - when blocking findings exist and the provider permits it, submit a
     changes-requested review containing every required change;
   - when formal changes-requested review is unavailable because reviewer and
     author share an identity, post a top-level PR comment headed
     `Changes required` containing every blocking finding and treat it as the
     canonical review record;
   - when no blocking finding exists, approve when permitted, otherwise post a
     concise verdict comment;
   - when checks or missing authority prevent an honest verdict, post the
     bounded status on the PR when possible and name what remains unresolved.
6. Reply in chat with the verdict, count of blocking findings, and the posted
   review or comment link when available. Do not introduce a new required
   change in chat that is absent from the PR.

If authentication, permissions, or provider failure prevents posting, say so
plainly. Include the intended review text in chat so it is not lost, but do not
claim the review is complete or posted.

## Review quality

- Findings come first, ordered by severity and then file location.
- A blocking finding states a concrete defect and merge condition, not a vague
  request to improve or reconsider.
- Avoid duplicate comments for one root cause unless separate locations need
  distinct fixes.
- Do not request branch changes merely for optional style preferences.
- Re-review the current PR head after fixes; do not approve from an obsolete
  diff or the worker's summary.

## Stop conditions

Stop without inventing a verdict when the PR cannot be resolved, the relevant
base or canonical authority is unavailable, the diff cannot be inspected, or
the requested review would require branch mutation. Posting failure is a
reported blocker, not permission to silently fall back to chat-only review.
