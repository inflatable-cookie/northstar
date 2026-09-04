# Place review child in the worker workspace

Status: decision-ready; operator-confirmed correction
Disposition: promote with
`docs/triage/20260904-100224-chatterbox-planning-and-private-review-children.md`

## Correction

The earlier packet correctly rejects a new Paseo workspace per PR review, but
places the private review child in the coordinator workspace. Replace that
placement with a serial lease of the existing worker workspace.

Paseo parentage and workspace placement are independent. The coordinator uses
its agent-scoped child-creation call with the existing worker `workspaceId`:

- the reviewer remains a child of the coordinator;
- `notifyOnFinish` remains true so completion returns to the coordinator;
- the reviewer appears as a normal visible agent tab in the worker workspace;
- no review-only workspace or sidebar entry is created.

## Required topology

`coordinator parent -> review child placed in worker workspace -> exact-head provider verdict -> coordinator merge gate`

The worker and reviewer must use the workspace serially:

1. The worker finishes, commits, and pushes the PR head.
2. The coordinator pauses the worker and verifies that the workspace `HEAD`
   equals the PR head, the index and tracked worktree are clean, and no Git
   operation is active.
3. The coordinator creates the review child with that worker `workspaceId` and
   finish notification enabled.
4. The reviewer inspects the checked-out exact head and may run required checks,
   but does not edit tracked files, commit, push, change branches, or contact the
   worker directly.
5. The reviewer posts a durable provider verdict naming the exact reviewed head
   and finishes, notifying the coordinator.
6. Before returning the lease to the worker for requested changes, the
   coordinator verifies the workspace is still on the reviewed head with a clean
   index and tracked worktree.
7. A revised head repeats the same lease and exact-head review cycle.

Review independence comes from separate agent context, canonical references,
the confirmed packet, and the review oracle. It does not require a second
filesystem. Do not pass the worker's private transcript to the reviewer.

## Stop conditions

- worker and reviewer would operate in the workspace concurrently;
- workspace `HEAD` does not equal the PR head;
- the index or tracked worktree is dirty at either lease boundary;
- a Git operation or unresolved conflict is active;
- the reviewer would need to mutate the branch or tracked files;
- agent creation cannot preserve coordinator parentage, worker-workspace
  placement, a visible agent tab, and finish notification together.

Do not fall back to the coordinator workspace, create a review-only workspace,
or weaken the independent exact-head gate when a stop condition is hit. Return
the routing failure to the operator.

## Canonical delta to the earlier packet

Every destination already named in the earlier packet remains correct. Where
it says that reviewers run in the coordinator's existing workspace, substitute:

- coordinator-owned child;
- placed in the existing worker workspace through its `workspaceId`;
- visible as a normal agent tab there;
- `notifyOnFinish: true`;
- strict worker/reviewer serial lease with clean exact-head handoffs.

The private-review acceptance evidence should assert this topology and prove
that no additional workspace is created. The earlier requirement for a
reviewer to avoid checkout or branch mutation remains, but inspection and tests
now run against the worker's already-checked-out exact PR head.

## Non-goals

- no change to worker workspace creation or ownership;
- no concurrent reviewer and worker activity;
- no hidden or detached reviewer;
- no review-only workspace;
- no weakening of provider verdict, exact-head, revision, or merge gates;
- no direct coordinator review of the worker diff.

## Acceptance evidence

- A Paseo launch assertion shows agent-scoped reviewer creation with the worker
  `workspaceId`, coordinator parentage, a visible worker-workspace tab, and
  finish notification enabled.
- Workspace inventory before and after launch contains no new review workspace.
- Pre-review and post-review evidence records the same exact PR head and a clean
  index/tracked worktree.
- A requested-changes scenario proves the worker is resumed only after the
  reviewer finishes and the coordinator reclaims a clean workspace lease.
- A revised-head scenario requires a fresh verdict naming the new head.
- Negative scenarios fail closed on concurrent access, dirty state, wrong head,
  missing parentage, or missing completion notification.

## Unresolved questions

None. The Paseo agent contract explicitly permits an agent-scoped child to be
placed in another workspace by `workspaceId`; cross-workspace placement does
not change parentage, and the child appears as a normal tab in that workspace.
