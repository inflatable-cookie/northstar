# g02.025 Dogfood Orchestrator Worker PR Loop

Status: complete
Owner: repo maintainers
Date: 2026-08-16
Master spec: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Roadmap milestone: `g02.025`
Batch cards: `g02.025/072`, `g02.025/074`

## Outcome

The Northstar orchestrator/worker boundary completed one bounded documentation
lane from a committed handoff through a dedicated worktree, worker commit,
reviewable PR, orchestrator review, explicit merge authorization, and squash
merge.

- Worker handoff:
  `docs/handoffs/20260816-175731-g02-025-074-docs-front-door-worker.md`
- Worker worktree: `/tmp/northstar-worker-g02-025-074`
- Worker branch: `dogfood/g02-025-074-docs-front-door-crosslink`
- Worker commit: `203d9b9ed11f10ce717c7f9f61410f8368e6fd13`
- PR: https://github.com/inflatable-cookie/northstar/pull/2
- Merge commit: `a09ac108b2d6c9562544dc506d0f3f5ca70a1b43`
- Changed surface: `docs/specs/README.md` only
- Final `main` state: local `HEAD == origin/main` at the merge commit

The worker added a concise `Active planning` section linking spec 027 and its
source-backed translation memo. No implementation code, skill content, roadmap
scope, or contract text was changed by the worker.

## Boundary evidence

The successful worker verified all of the repaired launch invariants before
editing:

- dedicated worktree and expected branch;
- local `HEAD == origin/main`;
- recorded planning base `f9d6eb27990387ed6ed7c5e2d845f564c6f5fe3a` is an ancestor;
- handoff file exists at `HEAD`;
- only the assigned target file changed.

The worker reported the final changed file, validation, commit, and PR URL
through the operator. The transcript contains one completion report and no
separate interim chunk report; this is a remaining reporting-ergonomics gap,
not a scope or correctness failure.

## Validation and review

Worker validation:

- `git diff --check` — passed;
- `effigy qa:docs` — passed;
- final changed-file check — `docs/specs/README.md` only.

Independent orchestrator validation repeated the diff check and docs QA, and
confirmed both linked targets exist. GitHub reported no automated checks for
this documentation-only PR. Formal GitHub approval was unavailable because the
PR author and reviewer were the same account, so the orchestrator verdict was
recorded as a PR comment. The user then explicitly authorized the merge.

Review cycles: one; requested-change cycles: zero; merge: one authorized squash
merge. The cleanup flag on `gh pr merge --delete-branch` could not delete the
local branch while its worktree was present; the worktree and local/remote
branches were removed separately after verifying the merge.

## Measured friction

Three worker dispatch attempts were made:

1. first preflight stop: handoff recorded a stale pre-handoff base;
2. second preflight stop: the handoff still demanded an impossible exact tip
   after the handoff commit, exposing the self-referential-SHA flaw;
3. successful run: 199 seconds from worker start to completed PR report.

The first two stops were protocol repairs, not worker implementation failures.
The repaired contract now records a planning ancestor and verifies the live
remote tip dynamically. Two new papercuts are recorded in `PAPERCUTS.md`: a
relative handoff lookup resolving under the wrong file-tool root, and a stale
Git remote-head lock blocking the initial fetch.

## Decision and next task

Keep the provider-neutral, operator-mediated worker path as the default until
more evidence justifies an adapter or automatic cross-session messaging. Begin
`g02.026` planning from spec 027 now that the g02.025 dogfood is closed. Do not
create implementation cards until the new pre-execution discovery contract and
readiness gates have been compiled into a settled first batch.

NEVER include API keys, tokens, passwords, secrets, credentials, or connection strings in the summary — replace any that appear with [REDACTED].
