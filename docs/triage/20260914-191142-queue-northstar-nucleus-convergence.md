# Queue, Northstar, and Nucleus convergence

Status: open
Owner: operator and Chatterbox
Captured: 2026-09-14
Execution authority: none

## Issue

Northstar, Queue, Effigy, and the current host integrations are prototypes of
parts of one larger system. Their end goal is a coherent Nucleus product that
brings planning, durable orchestration, execution, review, collaboration, and
project knowledge into one environment.

That destination is settled. Its architecture, deployment boundaries, security
model, migration path, and product packaging still need discovery before any
implementation lane is approved.

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

- Nucleus is the end product that brings the disparate subprojects together.
- Nucleus owns the coherent environment and user experience. Queue becomes its
  durable orchestration subsystem, Northstar contributes an optional planning
  and project-knowledge methodology, and Effigy supplies repository task and
  tool execution.
- The same hosted control plane should support a deployment continuum: embedded
  on a laptop and started with the app, run on a dedicated personal or team
  server, or offered as a managed service. These are deployment choices for the
  same system and protocol, not separate products.
- Threads are views into durable work. A thread must not be the sole owner of a
  decision, task, request, review, or recovery state.
- A project must be usable without adopting the Northstar documentation spine.
  The spine remains available when its durable planning and knowledge structure
  is valuable.
- Do not start a cross-harness Queue extraction or Northstar package split from
  this conversation.
- Treat the current Northstar and Paseo Queue work as a useful prototype for a
  more deeply integrated system.
- Effort spent adapting uneven third-party app capabilities may be less valuable
  than developing Nucleus as the environment that owns the whole experience.
- Northstar's skill pieces depend on each other and currently derive much of
  their value from being installed as one coherent system. Splitting them is not
  assumed to be desirable or straightforward.
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

## Ideal product shape

Nucleus is a collaborative project operating system for humans and agents. A
user connects a repository and providers, describes an outcome, makes the
decisions that require human judgment, and can see the resulting work move
through one durable system.

The core records are first-class objects rather than facts reconstructed from
chat history:

- project;
- decision;
- task;
- run;
- workspace lease;
- review;
- request or approval;
- artifact and evidence;
- human, agent, and service principal.

The normal workflow is continuous: intake, planning conversation, risk-based
Oracle consultation, operator approval, dispatch, implementation, review,
revision, merge, closeout, and durable knowledge capture. Each step has an
explicit owner, state, evidence, and recovery path. The UI presents the same
work through planning rooms, task views, code workspaces, review surfaces, and
operator inboxes without making any one conversation authoritative.

## Product boundaries

- **Nucleus** is the complete product and working environment.
- **Queue** is the internal durable orchestration, scheduling, recovery, and
  audit subsystem.
- **Northstar** is an optional planning and project-knowledge pack. Its doctrine
  informs Nucleus, but its documentation tree is not a prerequisite.
- **Effigy** is the repository-local task and tool execution layer used by
  agents and automation.
- **Host adapters** may expose selected Nucleus capabilities in other apps, but
  universal compatibility with every thread model is not the product's centre.

These are intended responsibilities, not commitments to preserve today's
repositories, package names, or process boundaries. The current projects are
evidence and implementation prototypes.

## Deployment and execution boundary

The hosted-service frame must work at several scales without changing the
domain model:

1. A desktop app starts the service locally for one person.
2. A persistent service runs on a personal machine or dedicated server.
3. A team shares a self-hosted service.
4. A managed service hosts the shared control plane.

The control plane should own shared project metadata, task state, scheduling,
identity, messages, decisions, approvals, and audit history. Execution nodes
should own access to repositories, worktrees, local tools, provider credentials,
secrets, and model processes. A laptop can host both roles. A remote deployment
can use authenticated outbound connections from trusted execution nodes so a
central service need not receive unrestricted machine credentials.

The boundary must support local-only work, self-hosting, managed hosting, and
mixed teams without inventing a different workflow for each topology.

## Multiplayer requirements

- Humans, agents, and services have durable identities and scoped organization
  and project roles.
- Decisions and approvals name the person or role allowed to make them.
- Workspace, branch, merge, and planning leases prevent two actors from
  silently owning the same mutable work.
- Compare-and-swap state transitions and idempotent callbacks make reconnects,
  retries, and duplicate delivery safe.
- Permission requests and sensitive information reach the correct person and
  device without leaking into unrelated project or agent contexts.
- Presence is useful context, while correctness cannot depend on every client
  remaining online.
- Recovery reconstructs work from durable records after a client, runner,
  provider, or network failure.

## Adoption shape

The minimum trial should be: install Nucleus, connect a repository and provider,
and start work. It must not require reorganising the repository or adopting a
documentation doctrine.

Projects can opt into the Northstar pack when they want its vision,
architecture, contract, roadmap, triage, and evidence spine. Queue should accept
work originating from a Northstar task, an issue, an API request, a concise
brief, or a planning conversation. Skills and role instructions should be
versioned job dependencies selected and injected by the environment, rather
than assumed global state on an agent's machine.

Portability comes from an explicit API, event model, and exportable durable
records. It does not require reducing the product to the least capable host.

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
11. Which records live in the shared control plane, which remain on execution
    nodes, and which need encrypted or replicated forms in both places?
12. What identity, authentication, authorization, secret-handling, and audit
    model works across local, self-hosted, and managed deployments?
13. How should current Northstar, Queue, Effigy, Paseo, and Nucleus users migrate
    without importing accidental prototype constraints into the final design?
14. What hosting and business model can sustain the shared service while
    preserving a credible local and self-hosted path?

## Non-goals

- No headless provider runner.
- No current Northstar or Queue dependency change.
- No renaming, splitting, or publishing of packages.
- No T3, BB, Paseo, or Nucleus adapter work.
- No remote server, account, synchronization, or multiplayer implementation.
- No changes to existing agent threads or workspaces.

## Next check

Return through an explicit architecture-discovery conversation when the operator
wants to invest in the Nucleus product boundary. Begin with three complete user
journeys: one person working locally, two remote collaborators sharing a
project, and a security-sensitive team keeping execution local. Model identity,
authority, data placement, leases, failure recovery, and adoption across those
journeys before choosing packages, protocols, or host integrations.

This note records the destination only. It grants no execution authority.
