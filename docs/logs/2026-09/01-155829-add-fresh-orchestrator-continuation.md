# Add Fresh Orchestrator Continuation

Date: 2026-09-01
Status: implementation complete; awaiting exact-head review
Roadmap: `g02.046`
Card: `g02.046/114`

## Outcome

Northstar can now hand one live orchestrator lane to a fresh orchestrator
through the generic seven-section handoff. The successor enters normal
orchestrator mode from `handoff_mode: orchestrator-continuation`. It is not a
worker, planning delegate, or handoff-writing thread. Paseo launch uses a
separate `local` workspace for the same project, a current orchestrator-role
profile, the capitalized `Orchestrator=true` label, and only the absolute
handoff path as the prompt. Missing sidebar pin support stays manual.

The worker branch is ready for orchestrator exact-head review. Spec 034 and the
diversified model-routing triage note remain out of scope.

## Before/after activation

| Surface | Before | After |
| --- | --- | --- |
| Router | worker and planning-delegate activation only | continuation activation opens orchestrator mode and rejects worker/delegate/handoff routing |
| Handoff contract | worker and delegate overlays | generic seven-section overlay with the three continuation fields |
| Orchestrator mode | no source-yield/successor-entry path | local-workspace launch, yield, capitalized label, exact prompt, manual pin, identity preservation, manual fallback |
| Skill outcome | worker and delegate distinction | continuation is a third distinct orchestrator activation |
| Generic template | seven sections, no `handoff_mode` | unchanged; no continuation template added |
| Doctrine / kernel / operator / copy-ready contract | continuation only in live architecture and working rules | compact reusable rule propagated |

## Scenario matrix (eight review-oracle rows)

| Scenario | Expected behavior | Proof |
| --- | --- | --- |
| Successor aimed at handoff, worker, or planning-delegate mode | reject before launch | router continuation section; negative `handoff_mode: worker-pr-loop` in the continuation procedure |
| Source keeps dispatching or merging after the successor starts | transfer stops; source yields | `stops planning, dispatch, review` and `does not compete with the successor` |
| Launch uses `branch-off` worktree isolation or a different project path | reject the transport plan | `local` workspace plus `branch-off` rejection |
| Agent creation omits or lowercases the `Orchestrator` label | reject launch configuration | capitalized `Orchestrator=true` and omitted-or-lowercased rejection |
| Initial prompt includes a transcript or second task | reject before agent creation | only `Read and follow <absolute-handoff-path>.` |
| Source uses browser/computer-use pinning, or treats missing pin as fatal | report manual placement and continue | missing pin is not a launch failure; UI automation forbidden |
| Workspace/agent creation returns an identity then fails ambiguously | preserve the identity and stop that attempt | no duplicate successor retry |
| Required Paseo tools are absent | return the absolute handoff path | `Without Paseo` manual fallback |

## Validation

- `effigy check:command-skills` — pass (9 adapters, aggregate descriptions=460 chars, eight continuation oracle rows)
- isolated `effigy check:skill-install` against an rsync of `skills/northstar/` — pass, exact parity, 127 files
- `effigy qa:docs` — pass
- `effigy qa` — pass
- `git diff --check` — clean

The original 14-file WIP was preserved and integrated onto `origin/main`
`94604a4`. No live successor was launched.

## Limitations

No live successor was launched. No Paseo, plugin, or pin API was added. Worker
and planning-delegate semantics are unchanged. Current `origin/main` at
`94604a4` added `docs/triage/20260901-155605-diversified-model-routing.md`;
this PR integrates that commit and does not edit or implement it.

## Next

Orchestrator exact-head review of the PR. The worker does not merge.
