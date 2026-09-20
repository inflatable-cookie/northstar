# Prospective-merge consumer rollout

Date: 2026-09-17
Authority: Northstar `g03.020`'s ready-state rubric records Tom's 2026-09-16
authorization of the producer update and the consumer rollout; this thread
continues it under
`docs/handoffs/20260917-095200-northstar-chatterbox-refresh.md`.

## Parity and reconciliation

The merged `g03.020` skill source and the installed copy under
`~/.agents/skills/northstar` and `~/.pi/agent/skills/northstar` are identical in
content, so installed parity holds. Northstar's own roadmap front doors still
named the terminal `g03.020` as the approved lane; they were reconciled at
`8906a7b` and `lifecycle:run audit-currentness --repo .` is clean.

## Census

Thirty-one repository checkouts under `/Users/tom/Dev/projects` carry a
`.paseo/queue.json`. Eleven already declare `paseo.queue.control.v4`. Twenty
remain conforming v3 with one read-only `task.pre_merge` hook at
`reviewed_head`; each is clean on `main` and accepted, unchanged, by
`effigy skill run northstar/lifecycle:migrate-premerge --repo <path>` in
dry-run mode with exactly the two expected changes.

The refresh handoff's "30 remaining consumers" is stale. An earlier sweep
migrated Northstar, Queue, Poodle, Effigy, Underlay, Convergence, Keepsake,
Compli-me, Contact Patch and Nightfire between 09:49 and 10:14 on 2026-09-16,
then stopped; no migration task was left open in Queue.

## Batch 1 (dispatched)

Each repository received one configuration-only maintenance task, one worker
handoff under `docs/handoffs/`, and a roadmap front-door entry, committed and
pushed on its own `main` before Queue submission. No repository's manifest was
edited from Northstar.

| Repository | Task | Queue task |
| --- | --- | --- |
| book | `g01.007` | `ffbbce79-834f-4e1b-b241-cdfd66e5eae7` |
| bughunt | `g01.004` | `96142560-a863-4525-bb4a-f89f044e238a` |
| monkey | `g14.003` | `a015cb7d-442c-46e1-ad10-6ad4fccecef7` |
| northstar-language-packs | `g01.002` | `ac880170-4a94-4e88-a2cd-4b3e9eb376ae` |
| poodle-lab | `g02.003` | `8a217a82-9733-48e7-8d22-d5884f4f69fb` |

## Remaining

acowtancy, figmatic, finch, jetstream, longhorn, loophole, nucleus, praxis,
signal, songsprout, soundcheck, soundcheck-library, swallowtail,
underlay-reference and zoho-bozo.

## Limits

Origins are this thread: no project Chatterbox was live at dispatch, so closeout
notifications stay off. Each migration is proved by its repository's own task,
PR and review, not by this log. acowtancy already carries six in-flight lanes,
so its migration waits on Queue pacing rather than competing for integration
turns.

## Batch 1 outcome

All five closed out through their own Queue lanes on 2026-09-20. Each repository
now declares `paseo.queue.control.v4` with the pre-merge hook at
`prospective_merge`, and each retains its terminal lifecycle record:

| Repository | Task | Terminal record |
| --- | --- | --- |
| book | `g01.007` | `3f6861d` |
| bughunt | `g01.004` | `c618bf7` |
| monkey | `g14.003` | `07417dc` |
| northstar-language-packs | `g01.002` | `ec3a9ca` |
| poodle-lab | `g02.003` | `befae89` |

Fifteen repositories remain in the census. They continue in bounded batches
rather than one cross-repository loop, because each migration is that
repository's own configuration task.

## Batch 2 (dispatched 2026-09-21)

Same shape as batch 1: one configuration-only maintenance task, one worker
handoff and one roadmap front-door entry per repository, committed and pushed on
that repository's own `main` before submission.

| Repository | Task | Queue task |
| --- | --- | --- |
| finch | `g05.014` | `e35b80d5` |
| jetstream | `g06.018` | `01984a3e` |
| longhorn | `g02.040` | `5de1ef01` |
| loophole | `g01.057` | `9bca8ce9` |
| nucleus | `g06.004` | `879638ae` |

The loophole submission returned a transport `handler_error` after the task was
already created durably; the unchanged handoff re-submission resolved to the
same task, so no duplicate lane exists.

Ten repositories remain: acowtancy, figmatic, praxis, signal, songsprout,
soundcheck, soundcheck-library, swallowtail, underlay-reference and zoho-bozo.

## Service transport outage (2026-09-20 19:00 – 23:30)

Queue's service-to-daemon transport dropped silently while its own client
reported `connected`. `g03.021` and the rest of the queue stopped dispatching
for four and a half hours; recovery was a plugin reload, not a Paseo restart.
This is recorded for the rollout's own timeline, not as Northstar work.

## Batch 2 status (2026-09-21 01:15)

- finch `g05.014`: `verifying` at the exact intended head with a published review
  (PR #9).
- jetstream `g06.018`: `awaiting_review` (PR #11).
- nucleus `g06.004`, loophole `g01.057`, longhorn `g02.040`: fenced in
  `needs_attention` with a `workspace_state` incident. The 23:55 transport drop
  lost the workspace-creation response and no workspace was created — verified
  against Paseo workspaces, `~/.paseo/worktrees`, and `git worktree list`. The
  adapter's recovery path only adopts an existing workspace, so creation cannot
  be retried from this side; Queue owns the escape.

Batch 3 (ten repositories) is held until the queue sweeps cleanly again.
