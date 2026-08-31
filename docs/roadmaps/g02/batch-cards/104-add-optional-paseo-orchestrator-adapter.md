# 104 - Add Optional Paseo Orchestrator Adapter

Status: complete
Owner: repo maintainers
Updated: 2026-08-31
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `docs/architecture/system-architecture.md`,
`docs/contracts/001-working-rules.md`, `g02.036`
Auto-start next card: no

## Objective

Make Northstar orchestrator mode use Paseo's workspace and agent tools when
available and authorized while keeping the protocol fully usable without Paseo.

## Scope

- promote the optional control-plane transport boundary into canonical docs;
- add the conditional Paseo workspace/profile/agent flow to orchestrator mode;
- keep the committed Northstar handoff as the only worker briefing;
- align worker reporting language in the handoff template;
- sync the changed skill surfaces and close the evidence chain.

## Ready-State Checks

- [x] The operator selected the capability-aware adapter recommendation.
- [x] Spec 026 already owns adapter policy and remains active.
- [x] The manual fallback, authority chain, and merge boundary are settled.
- [x] No consumer run or external worker launch is required for this batch.

## Acceptance Criteria

- an authorized Paseo path lists current profiles, selects by notes and risk,
  creates one worktree workspace from `origin/main`, and launches one worker;
- the initial worker prompt contains only the absolute committed handoff path;
- generic task-handoff skills cannot create a second Northstar briefing;
- notifications replace polling, while permission requests return to the
  operator unless existing explicit authority settles them;
- missing tools, missing authorization, or setup failure preserves a clear
  manual dispatch path and never silently duplicates a worker;
- control-plane IDs, profiles, messages, and status remain transport metadata;
- skill/docs checks, source/install parity, and full QA pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Northstar stays portable. | Paseo tools are absent. | Orchestrator returns the absolute handoff for manual launch. | Spec, contract, and mode inspection. |
| The file remains the sole dispatch authority. | `/paseo-handoff` generates a full briefing. | Orchestrator refuses that helper and uses base workspace/agent tools. | Mode and spec inspection. |
| Adapter retries do not duplicate work. | Workspace creation succeeds but agent creation is uncertain. | Orchestrator reports the created identity and stops before another launch. | Mode stop condition and docs QA. |
| Runtime profiles do not become Northstar config. | A local profile name changes. | Orchestrator lists profiles and selects from current notes. | Mode and spec inspection. |

## Evidence Required

- `git diff --check`
- skill validator on `skills/northstar/`
- isolated `effigy check:skill-install`
- configured-install parity after selective sync
- `effigy qa:docs`
- `effigy qa`

## Stop Conditions

- the change makes Paseo, a local profile name, or control-plane state mandatory;
- a second prompt or live message becomes execution authority;
- permission, review, or merge authority widens;
- validation fails in a way that changes the transport design.

## Resolution

- promoted the conditional control-plane boundary into spec, architecture, and
  working rules;
- added profile discovery, Paseo worktree creation, path-only agent launch,
  notifications, follow-ups, permission routing, and duplicate-launch stops to
  orchestrator mode;
- kept manual dispatch complete and excluded `/paseo-handoff` from the worker
  path;
- synced the two changed installed-skill files and passed 122-file parity,
  docs QA, and full QA.

## Next task

Use the next real bounded orchestrator lane to measure launch time, relay
burden, duplicate-workspace prevention, and review behavior.
