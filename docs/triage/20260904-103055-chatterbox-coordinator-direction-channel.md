# Chatterbox-to-coordinator direction channel

Status: decision-ready; operator-confirmed
Disposition: promote with the Chatterbox/coordinator contract changes

## Issue

The current Chatterbox contract requires the operator to relay every note,
decision, correction, and priority change to the coordinator. That boundary was
based on Chatterbox v1 lacking a safe coordinator-notification path and on a
concern that `send_agent_prompt` could start an unwanted coordinator turn.

Live Paseo use disproved the practical premise for this workspace. Chatterbox
can list workspace agents, identify the named coordinator, inspect its current
state, and send a background prompt directly. Requiring manual operator relay
creates delay and loss precisely where Chatterbox is now intended to own the
operator-facing discovery and planning conversation.

The operator needs Chatterbox to carry important ideas and instructions forward
without becoming an execution orchestrator.

## Operator-confirmed decision

Chatterbox has operator-delegated planning-direction authority over the named
coordinator. When the operator gives Chatterbox a confirmed decision,
instruction, correction, priority change, or stop direction, Chatterbox may
inspect coordinator state and relay it directly. The operator is not required to
copy paths or restate the message in the coordinator tab.

This is a communication and planning-authority channel, not execution authority.

## Message classes and authority

Every Chatterbox-to-coordinator message declares one class:

### Operator-confirmed direction

Use when the operator explicitly confirms or instructs:

- product or planning meaning;
- promotion-envelope acceptance or correction;
- priority, pause, stop, or reroute direction;
- scope expansion or contraction;
- an answer to a coordinator or child escalation;
- a coordinator-role/process correction.

The coordinator treats the relayed meaning as operator authority, subject to
normal safety, current-state, conflict, and destructive-action checks.
Chatterbox must not strengthen, generalize, or silently reinterpret the
operator's statement.

### Chatterbox recommendation

Use when Chatterbox has developed an unconfirmed suggestion, warning, research
finding, or candidate packet. The coordinator records or routes it as intake.
It does not change active work, expand scope, authorize promotion, or make the
recommendation executable without operator confirmation.

### Administrative notice

Use for a committed note path, duplicate warning, supersession link, or other
non-semantic routing fact. The coordinator reconciles it at the next appropriate
checkpoint without treating it as a new assignment.

## Relay procedure

1. Resolve the current project/workspace and list its active agents.
2. Identify the coordinator by retained identity and role label/title. If zero
   or multiple plausible coordinators remain, stop and ask the operator rather
   than guessing.
3. Inspect enough coordinator status/activity to avoid duplicate, stale, or
   contradictory direction. Do not poll a running coordinator repeatedly.
4. Compile one context-complete message containing:
   - message class and operator-confirmation provenance;
   - the decision or instruction in plain language;
   - affected packet/lane/PR/agent identities;
   - relationship to active work: continue, queue, pause, stop, or reconcile;
   - preservation requirements and forbidden destructive actions;
   - the next coordinator action or operator question expected.
5. Send one background prompt to the retained coordinator identity. Do not send
   duplicates because the coordinator remains running or gives no immediate
   reply.
6. Report delivery success or failure to the operator. A successful send does
   not mean the instruction has been completed.

When the coordinator is running, the message may queue behind or join its active
turn according to the control-plane contract. Chatterbox does not cancel the
coordinator, poll for acknowledgement, or open a second coordinator. When the
coordinator is idle, an operator-confirmed direction may wake it for one bounded
turn. The coordinator's report-and-yield contract still applies.

## Coordinator behavior

On receipt, the coordinator:

- verifies the declared message class and named identities;
- treats operator-confirmed meaning as operator authority without asking the
  operator to relay it again;
- reconciles the direction with current branch, worker, PR, and review state;
- preserves useful in-flight work and stops before destructive cancellation,
  duplicate dispatch, or unsafe scope mutation;
- applies safe routing immediately or queues it at the next required boundary;
- asks one context-complete operator question when current state makes the
  direction unsafe or materially ambiguous;
- treats Chatterbox recommendations and administrative notices according to
  their weaker authority classes;
- reports the resulting state, then yields when no immediate action remains.

The coordinator must not reject a valid relay merely because the operator did
not repeat it in the coordinator tab. The durable Chatterbox transcript plus the
provenance-labelled message provides the communication record; canonical
promotion still provides repository authority for long-lived meaning.

## Preserved Chatterbox limits

Chatterbox still cannot:

- create, resume, cancel, or replace implementation/projection/review workers;
- select branches, merge PRs, accept review findings, or bypass checks;
- mutate worker workspaces or canonical planning surfaces;
- turn its own recommendation into an operator-confirmed direction;
- infer destructive authority from a general priority or stop statement;
- supervise worker execution or become the runway-state coordinator;
- poll agents for progress after relaying a message.

If executing an operator instruction requires one of those actions, Chatterbox
relays the instruction and the coordinator owns the safe execution boundary.

## Canonical destination map

| Destination | Required delta |
| --- | --- |
| `docs/specs/035-chatterbox-intake-channel.md` | Replace manual operator-only handoff with an operator-delegated direction channel; define message classes, direct relay, retained limits, and no-poll behavior. |
| `docs/specs/036-economical-orchestrator-coordination.md` | Require the coordinator to accept provenance-labelled Chatterbox relays, reconcile them mechanically, and avoid forcing duplicate operator confirmation. |
| `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md` | Add Chatterbox direction as a valid coordinator event and preserve coordinator ownership of dispatch, cancellation, revision, review, and merge actions. |
| `docs/contracts/001-working-rules.md` | Freeze operator-delegated relay authority, message provenance, identity resolution, duplicate prevention, and preserved execution limits. |
| `docs/architecture/system-architecture.md` | Add the direct Chatterbox-to-coordinator control edge and distinguish it from coordinator-to-worker execution edges. |
| `docs/architecture/system-inventory.md` | Record the direction channel, its inputs/outputs, authority classes, and retained identities. |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | Replace the v1 operator-relay-only doctrine with an optional direct channel when the control plane supports agent discovery and background prompts. |
| `bundle-docs/operators/operator-quick-start.md` | Explain that confirmed decisions given to Chatterbox can be relayed directly and need not be copied into the coordinator tab. |
| `bundle-docs/glossary.md` | Include Chatterbox's operator-delegated planning-direction role without describing it as an orchestrator. |
| `template-bundle/contracts/001-working-rules-template.md` | Carry the portable direct-relay and manual-fallback rules into the copy-ready template. |
| `template-bundle/triage/README.md` | Update the note-notification lifecycle while keeping triage non-authoritative until operator confirmation. |
| `skills/northstar/SKILL.md` | Summarize direct Chatterbox relay and the boundary between planning direction and execution coordination. |
| `skills/northstar/references/router.md` | Preserve Chatterbox routing while allowing its bounded coordinator communication channel. |
| `skills/northstar/references/modes/chatterbox.md` | Replace the blanket no-`send_agent_prompt` rule with the typed relay procedure, agent lookup, provenance, ambiguity stops, and preserved no-dispatch/no-poll rules. |
| `skills/northstar/references/modes/orchestrator.md` | Accept typed Chatterbox events, reconcile confirmed directions without duplicate operator relay, and keep execution actions coordinator-owned. |
| `docs/roadmaps/g02/batch-cards/126-dogfood-economical-orchestrator-coordination.md` | Record manual-relay friction, direct-message delivery, duplicate/wake behavior, and operator-context outcomes in the trial. |
| `docs/README.md` and owned roadmap/front-door indexes | Sequence this channel change without claiming delivery before validation. |

Exact-token search may identify derived source/install parity, notification, and
structural-validation surfaces. Any additional semantic destination returns for
operator confirmation.

## Transport fallback

The direct channel applies when the active environment exposes all of:

- workspace/agent inventory;
- an unambiguous coordinator identity;
- current status or enough activity to prevent obvious duplicate/stale relays;
- a background prompt operation addressed to that identity.

Without those capabilities, Chatterbox reports the absolute note path and a
context-complete relay message for the operator to forward manually. Absence of
the adapter does not remove the planning-direction contract; it changes only
transport.

## Sequencing and dependencies

- Promote with the evolved Chatterbox planning role and coordinator fast-path
  packets:
  - `docs/triage/20260904-100224-chatterbox-planning-and-private-review-children.md`;
  - `docs/triage/20260904-100548-place-review-child-in-worker-workspace.md`;
  - `docs/triage/20260904-101838-coordinator-dispatch-fast-path-and-yield.md`;
  - `docs/triage/20260904-102154-context-complete-operator-escalations.md`.
- Define message provenance and authority classes before enabling direct sends
  in the installed Chatterbox mode.
- Update coordinator event handling and Chatterbox sending behavior together so
  neither side has a half-enabled channel.
- Keep manual relay as the provider-neutral fallback.
- Update source/install parity and structural/semantic fixtures in the same
  delivery batch.

## Acceptance evidence

- A workspace fixture with one Chatterbox and one coordinator resolves the
  coordinator identity and sends one background operator-confirmed direction.
- The coordinator accepts the relay without requiring the operator to repeat it,
  reconciles it against active state, reports the result, and yields.
- A running-coordinator fixture queues one message without polling or duplicate
  prompts.
- Zero-coordinator and multiple-coordinator fixtures stop with a clear operator
  question rather than guessing.
- A recommendation fixture remains intake and cannot change active work until
  the operator confirms it.
- An operator stop/reroute fixture preserves in-flight work and returns
  destructive or materially ambiguous choices to the operator.
- A missing-control-plane fixture produces one absolute path plus a complete
  manual relay message.
- Dogfood records the successful direct relay on 2026-09-04 to coordinator
  `bcf9fd1f-0eda-44bc-b3a7-54990bc9a087`, without making that local identity
  reusable policy.
- Existing Chatterbox unique-file Git isolation, coordinator dispatch and yield,
  worker/reviewer parentage, exact-head review, revision routing, merge-gate,
  bundle, command/router, and source/install parity checks still pass.
- `git diff --check`, `effigy check:chatterbox-git`,
  `effigy check:command-skills`, `effigy check:repo-contract`,
  `effigy check:model-routing`, `effigy qa:docs`, and `effigy qa` pass for the
  eventual delivery batch.

## Unresolved questions

None block promotion. A successful background prompt proves delivery, not
acknowledgement or completion; Chatterbox reports that distinction to the
operator and does not poll.

## Alternatives rejected

- **Keep the operator as mandatory relay.** This adds work and delay while
  discarding available agent inventory and messaging capability.
- **Give Chatterbox full orchestrator authority.** Planning direction does not
  require worker dispatch, review, merge, or workspace mutation authority.
- **Send every idea as operator authority.** Unconfirmed recommendations remain
  intake and must be labelled as such.
- **Wake or interrupt blindly.** Resolve identity, inspect current state once,
  send one background message, and let the coordinator reconcile it.
- **Require an atomic notify-only API before any direct relay.** Background
  addressed prompts plus typed authority and duplicate controls are adequate;
  manual fallback remains available when they are not.
