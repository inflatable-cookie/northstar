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

## Uncertain workspace creation: the supported route

When a transport failure lands mid-dispatch, a task can keep `workspaceIntent:
true` with no `agentId` and no workspace. The adapter's `recover()` deliberately
refuses to replay creation, because a dropped response can hide a workspace that
does exist. The escape is the operator control:

```sh
node bin/queue-cli.mjs task  # {"taskId":..., "version":..., "action":"retry_validation"}
```

It proves absence through `findWorkspaces` and only then clears the intent and
replays the same create. Preconditions: `workspaceIntent: true`, no
`agentIntent`, no `agentId`, exactly zero workspaces found, queue not paused. The
three batch-2 lanes met all of them and were replayed on 2026-09-21 (nucleus,
loophole, longhorn); nucleus and loophole then waited on the queue-wide
workspace admission budget rather than on transport, and longhorn dispatched.

Blind retries are not a substitute: the proof is what makes the replay safe.

## Batch 3 (dispatched 2026-09-21)

| Repository | Task | Queue task |
| --- | --- | --- |
| figmatic | `g01.044` | `1d195d78` |
| praxis | `g01.005` | `704ba7df` |
| signal | `g11.006` | `d5615e27` |
| songsprout | `g02.009` | `853c9deb` |
| soundcheck-library | `g01.009` | `2671b38a` |

Each task file uses the repository's own heading convention for its final
section, detected from its sibling tasks rather than assumed. Five repositories
remain: acowtancy, soundcheck, swallowtail, underlay-reference and zoho-bozo.
New lanes queue on the queue-wide workspace admission budget, so dispatch order
is Queue's, not the submission order.

## Batch 4 (dispatched 2026-09-21) — census complete

| Repository | Task | Queue task |
| --- | --- | --- |
| acowtancy | `g05.175` | `b0c1cb25` |
| soundcheck | `g04.035` | `44e77b73` |
| swallowtail | `g06.007` | `0b90c5de` |
| underlay-reference | `g01.017` | `0fa117da` |
| zoho-bozo | `g01.003` | `a12415ba` |

All twenty v3 consumers in the census now carry a configuration-only migration
task and a dispatched Queue lane. Per-repository differences handled on the way:
zoho-bozo had no `docs/handoffs/` directory, created for the handoff, and no
`qa:docs` task, so its documentation check ran through `effigy docs`; swallowtail
indexes roadmap entries from its `## Tasks` list, so its entry lives there rather
than in a separate maintenance section; its `qa:docs` also enforces roadmap
number-collision and status-drift checks.

Dispatch is paced by Queue's own workspace admission budget, so lanes leave
`queued` in the order workspaces free rather than in submission order.

## Closeout metadata cap, and what it revealed (2026-09-21)

The accepted closeout revision put whole `currentness_violations` objects into
hook-result metadata while a 32 KiB guard refused anything larger by
malfunctioning. Six merged bovine lanes were held on that, one per merged lane.
The hook now bounds the payload by construction — at most eight violations, each
field truncated to 256 bytes, with `currentness_violation_count` carrying the
true total and the human detail still in the bounded summary — and the guard
degrades to a correlation stub instead of failing. Fix landed at `ad83012`;
installed hook digest is now
`sha256:3e4b3d40986179aed8fb783cfaa68d0f759f5369ff6ee6fed59c5157dbd757a2`.

The cap removed a reporting trap that mattered more than the size limit: the
bounded summary shows eight findings plus `+N more`, which reads like a total. It
is not. Bovine's closeouts were blocked by 772 real findings, not eight.

Verified in production rather than by the self-test: figmatic's closeout now
returns `blocked` with its actual findings, and bovine's six retries moved from
the metadata malfunction to the next real blocker.

## Census currentness sweep (2026-09-21)

Standalone audit of every census repository, run from the installed skill:

| Repository | Findings | Composition |
| --- | --- | --- |
| bovine-accelerator | 772 | 726 duplicate-status-header, 42 missing-task-file, 4 stale-frontier |
| acowtancy | 104 | 97 duplicate-status-header, 7 stale-frontier |
| figmatic | 12 | 10 duplicate-status-header, 2 stale-frontier |
| swallowtail | 2 | 1 duplicate-status-header, 1 stale-frontier |
| bughunt | 1 | stale-frontier |
| monkey | 1 | stale-frontier |
| poodle-lab | 1 | stale-frontier |

The other thirteen are clean. Because the closeout audit covers every state
record's task path, a red repository blocks closeout for every lane in it:
migration lanes in acowtancy, figmatic and swallowtail are already at that wall.
The repairs Queue Spec 006 anticipates as a separate bounded consumer lane, or a
deliberate narrowing of the closeout gate's scope, are the two routes; the
operator decision is open and nothing here preempts it.

## Operational note: running the audit against a consumer

`effigy lifecycle:run ... --repo <consumer>` does not work: `--repo` retargets
the catalog, and the consumer does not define that task. From the Northstar
checkout, run the core script directly:

```sh
bun run <installed-skill>/scripts/lifecycle-core.ts audit-currentness --repo <consumer>
```

The documented `--repo` form is wrong and is recorded in `PAPERCUTS.md` rather
than corrected in place, because the lifecycle reference is part of the
installed interface identity Queue currently pins.

## Currentness repair lanes (dispatched 2026-09-21)

The census sweep predicted that red repositories would block their own migration
lanes at closeout; acowtancy and figmatic did, and swallowtail was next. Queue
Spec 006 names the bounded repair for a consumer already left red, and the
portfolio has used the same lane shape before, so these three are dispatched
rather than left waiting on the gate-scope question.

| Repository | Task | Queue task | Findings |
| --- | --- | --- | --- |
| acowtancy | `g05.176` | `b3a92286` | 97 duplicate-status-header, 7 stale-frontier |
| figmatic | `g01.045` | `960d13cb` | 10 duplicate-status-header, 2 stale-frontier |
| swallowtail | `g06.008` | `074a997f` | 1 duplicate-status-header, 1 stale-frontier |

Each card carries the audit's exact inventory, forbids renumbering or semantic
rewriting, and stops on any finding that needs product direction. Bovine is
deliberately excluded: 42 of its findings are records orphaned by generations
archived without closure receipts, which is a generation-closure decision in
that repository rather than a header sweep. bughunt, monkey and poodle-lab hold
one `stale-frontier` finding each that does not block closeout, so they are
portfolio hygiene rather than blockers.

## Outcome (2026-09-21)

The rollout is complete. All twenty census repositories now declare
`paseo.queue.control.v4` with the pre-merge hook at `prospective_merge`,
verified from each repository's own manifest rather than from prose.

The operator-led incident that followed cleared every stuck closeout: thirteen
original holds plus workspace cleanup, seventeen workspaces released (37 to 20),
including the three currentness repairs dispatched here and underlay-reference.
The three repair lanes met their oracle — acowtancy, figmatic and swallowtail all
report `audit-currentness` clean — and bovine's own repair (`fe00e8fec`,
`4ce01bee4`) leaves it clean for currentness and record integrity.

Two closures worth keeping:

- The closeout metadata trap is fixed and installed (`ad83012`): holdings now
  report their real findings instead of a 32 KiB malfunction, which is what made
  the difference between "eight violations" and 772 legible.
- The drifted-record-path class needed no adapter change after all. Restoring the
  corrupted record bytes from their original committed blob, plus historical
  pointer cards with provenance for reissued lanes, preserved identity without
  mutating immutable state or adding a verb.

One hundred and fourteen pending tasks remain held by the operator and are not to
be released without their instruction; no `retry_hook` work remains here.

## Portfolio currentness repair batch (dispatched 2026-09-24)

The 2026-09-21 sweep left six repositories red, and a re-audit on 2026-09-24 still
found the same twelve findings. `effigy` and `paseo-northstar-queue` had cleared
without a lane from this thread. Tom approved the batch on 2026-09-24, and each
repository received the `g06.008` lane shape: the audit's exact inventory in
Evidence, header removal and task-free frontier replacement only, and a clean
`audit-currentness` as the oracle. The 114-task hold recorded above had been
lifted by the time of dispatch.

| Repository | Task | Queue task | Findings |
| --- | --- | --- | --- |
| poodle | `g18.040` | `345a792c` | 1 duplicate-status-header, 3 stale-frontier |
| underlay | `g12.006` | `ea911bcd` | 3 duplicate-status-header, 1 stale-frontier |
| nightfire | `g01.019` | `dd2f9d3b` | 1 stale-frontier |
| bughunt | `g01.005` | `d5c54a50` | 1 stale-frontier |
| monkey | `g14.004` | `b2ff6365` | 1 stale-frontier |
| poodle-lab | `g02.004` | `5473681d` | 1 stale-frontier |

Underlay's lane sits in `g12`, beside its migration lane, and covers findings in
both `g12` and `g13`. The triage lead that held this debt is retired; these cards
are now its authority.

On 2026-09-24 the poodle and poodle-lab lanes blocked on unrelated normal-QA
failures. Tom approved revising their acceptance to the audit, projection
verification, docs QA, `git diff --check` and an audited-paths-only diff, with
the failure recorded in the PR. Both workers resumed with that instruction. All
six lanes closed on 2026-09-24, and every repository audits `ok`.

