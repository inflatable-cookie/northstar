# Queue, Northstar, and Nucleus convergence

Status: open
Owner: operator and Chatterbox
Captured: 2026-09-14
Execution authority: none

## Issue

The successful Northstar and Queue prototype suggests a deeper integrated
product, but generalising the current system across unrelated agent apps may
cost more than applying the same effort to Nucleus as a coherent public product.
The architecture and adoption boundary are not settled.

## Why it matters

Queue orchestration is useful because Paseo supplies a working environment:
thread discovery and creation, workspace isolation, callbacks, permissions, and
operator UI. A durable task database without an environment capable of starting
and controlling work is incomplete. Generalising that control across apps with
different or absent orchestration APIs creates a large adapter and compatibility
burden.

Remote and multiplayer use changes the system again. A local Queue cannot drive
work for remote collaborators unless the control plane, execution environment,
or both become remotely reachable. That introduces identity, authorization,
repository ownership, secrets, connectivity, concurrency, and recovery design
that the current local prototype does not solve.

## Operator-confirmed direction

- Do not start a cross-harness Queue extraction or Northstar package split from
  this conversation.
- Treat the current Northstar and Paseo Queue work as a useful prototype for a
  more deeply integrated system.
- Effort spent adapting uneven third-party app capabilities may be less valuable
  than developing Nucleus as the environment that owns the whole experience.
- Northstar's skill pieces depend on each other and currently derive much of
  their value from being installed as one coherent system. Splitting them is not
  assumed to be desirable or straightforward.
- A project must not have to adopt the Northstar documentation spine merely to
  try Queue orchestration.
- Queue alone is not a complete product. It needs a compatible working
  environment with task execution, thread/workspace control, feedback, and
  operator interaction.
- Remote and multiplayer operation must be designed deliberately rather than
  inferred from the single-user local model.

## Known

- The present Paseo integration can coordinate complete worker, review,
  revision, merge, recovery, and closeout loops because Paseo exposes the needed
  environment controls.
- Queue's repository hooks and instruction transport are increasingly generic,
  but its working execution adapter and UI remain Paseo-hosted.
- Other apps expose different capability sets. Emerging same-project
  orchestration can cover part of the workflow, while cross-project operation,
  retained-thread resumption, callbacks, plugin APIs, and workspace binding may
  remain unavailable or unstable.
- Northstar currently combines semantic planning, a documentation spine, role
  skills, execution handoffs, lifecycle state, and repository maintenance.
  Those surfaces are coupled and have not been proven as independently useful
  packages.
- The current design assumes one operator, local repositories, local provider
  credentials, and one authoritative Queue database.

## Tentative direction

A future Nucleus architecture may connect the environment, tools, workflow,
durable state, and user experience as one product. Northstar could remain the
planning and protocol prototype informing that design rather than becoming a
universal compatibility layer. Queue concepts may become part of that product
instead of a server expected to compensate for every host application's missing
features.

This remains a hypothesis. No repository, product, package, or ownership
boundary follows from it yet.

## Questions to resolve

1. What is the product boundary between Northstar, Queue, Paseo, and Nucleus?
2. Which parts of the prototype are durable domain concepts, and which are
   workarounds for the current host?
3. What is the smallest useful Queue adoption that requires neither the
   Northstar documentation spine nor a bespoke environment build?
4. Does a future control plane run locally, remotely, or as a coordinated pair?
   Which side owns task state, provider processes, repositories, and secrets?
5. How do multiple people share task visibility and authority without sharing
   unrestricted machine or provider credentials?
6. How are repository identity, worktree leases, branch ownership, merge turns,
   approvals, and recovery serialized across machines and intermittent clients?
7. How are operator decisions, permission requests, and sensitive information
   routed to the correct person and device?
8. Which state must be committed to Git for portability and audit, and which
   belongs only in the server database?
9. Can the full Northstar skill remain cohesive while its documentation spine
   becomes optional for Queue users, or does that require a different product
   boundary rather than a package split?
10. Is cross-harness interoperability valuable enough to justify its adapter and
    testing surface before Nucleus owns an end-to-end environment?

## Non-goals

- No headless provider runner.
- No current Northstar or Queue dependency change.
- No renaming, splitting, or publishing of packages.
- No T3, BB, Paseo, or Nucleus adapter work.
- No remote server, account, synchronization, or multiplayer implementation.
- No changes to existing agent threads or workspaces.

## Next check

Return through an explicit architecture-discovery conversation when the operator
wants to invest in the Nucleus product boundary. Start from user adoption and
multiplayer scenarios, then model identity, authority, state placement, and
failure recovery before choosing packages, protocols, or host integrations.
