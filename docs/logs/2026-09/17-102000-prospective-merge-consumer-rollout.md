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
