# Chatterbox Sibling Agent Tabs

Date: 2026-09-04
Roadmap: `g02.052`
Card: `g02.052/127`
Status: complete; reviewable PR pending

## Result

Corrected the Paseo chatterbox spawn topology recorded by card 124. A spawned
chatterbox is now a parent-attached child agent in the coordinator's current
workspace, created through the agent-scoped creation call, and appears as a
sibling agent tab beside the coordinator. Several independent chatterboxes may
coexist as sibling tabs in that workspace. The superseded separate
`local`-workspace instruction is removed from every live surface, and the
transport plan must now be rejected when it creates a separate workspace, uses
`branch-off` worktree isolation, or attaches a different project path.

Everything else about the role is unchanged: the capitalized `Chatterbox=true`
label, `notifyOnFinish: false`, diversified operator-facing conversational
routing with the operator's topic as the initial prompt, identity retention
without polling, the manual same-checkout fallback without Paseo, and the
exact-file triage-note Git protocol with fail-closed pre-stage index checks.
Worker, review-child, and fresh-orchestrator-continuation workspace parentage
rules are untouched, and card 126 remains blocked on its observation packet
and stop date.

`check:command-skills` gained a structural machine contract for the mode
section: the chatterbox spawn section must name a parent-attached child agent,
the current workspace, and the agent-scoped creation call, and must not
contain the separate `local` workspace. The assertion falsified the first
draft (the prose wrapped the pinned phrases across lines) and passes on the
final text.

## Changed Surfaces

| Surface | Before | After |
| --- | --- | --- |
| `skills/northstar/references/modes/orchestrator.md` | `## Chatterbox spawn and intake` ordered a separate `local` workspace and retained workspace plus agent identities | Spawn is a parent-attached child agent through the agent-scoped creation call in the current workspace; separate, `branch-off`, and different-project transports are rejected; sibling-tab coexistence named; agent identity alone retained |
| `docs/specs/035-chatterbox-intake-channel.md` | Start paths and acceptance criterion said a separate `local` workspace; oracle row rejected only `branch-off` | Start paths and acceptance criterion attach the sibling child in the coordinator's current workspace; rejection covers any separate workspace; oracle row proves no new workspace is created |
| `docs/contracts/001-working-rules.md` | Chatterbox paragraph created a `local` workspace | Paragraph spawns a parent-attached sibling child in the current workspace, never a separate workspace |
| `template-bundle/contracts/001-working-rules-template.md` | Copy-ready chatterbox bullet created a `local` workspace | Copy-ready bullet carries the sibling-child rule |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | Paseo spawn bullet created a `local` workspace | Paseo spawn bullet defines the sibling child, rejects new-workspace transports, and names sibling-tab coexistence |
| `docs/architecture/system-architecture.md` | Architecture said chatterboxes spawn in a `local` workspace | Architecture names the parent-attached sibling child in the current workspace |
| `scripts/check-northstar-command-skills.rhai` | No chatterbox spawn contract | Structural contract pins parent-attached child, current workspace, agent-scoped creation call, and no `local` workspace |
| Front doors | `docs/README.md`, `docs/roadmaps/README.md`, `docs/roadmaps/g02/README.md`, and `docs/roadmaps/generation-index.md` recorded only card 124's separate-workspace lane | All four record the `g02.052`/card 127 correction with the review PR open; `docs/logs/README.md` carries this log |
| Milestone 052 / card 127 / handoff | not present / not present / ready-to-launch brief | compiled / complete with reviewable PR pending / outcome fields appended; card 126 untouched |

Historical evidence is untouched: card 124, milestone 050, earlier logs, and
the card-124 handoff record the decisions made at their time.

## Validation

- `effigy check:command-skills` — PASS (8 adapters, aggregate descriptions
  428 chars; new chatterbox spawn contract included and regression-falsified
  before the rewrap)
- isolated `effigy check:skill-install skills/northstar` — PASS (113 files)
- `effigy qa:docs` — PASS
- `effigy qa` — PASS (full board, including consumer reruns, language-package
  routes, and the Paseo worktree self-test)
- `git diff --check` — clean

## Next Task

Exact-head review and merge of the card-127 PR against `main`; the installed
skill refresh follows merge. Card 126 stays blocked on its observation packet
and stop date.
