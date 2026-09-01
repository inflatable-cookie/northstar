# Plan Fresh Orchestrator Continuation

Date: 2026-09-01
Status: planning promoted; implementation blocked on PR 18 merge
Roadmap: `g02.046`
Card: `g02.046/114`

## Outcome

The operator settled a fresh-orchestrator continuation path for Paseo. The
source orchestrator writes and pushes one ordinary seven-section handoff with
explicit orchestrator activation, creates a separate local workspace for the
same project, launches a current orchestrator-profile agent with the capitalized
`Orchestrator` label and only the absolute handoff prompt, then yields the lane.

The current MCP and CLI expose local workspace creation and agent labels. They
do not expose sidebar pin/reorder state. Pin placement is therefore manual;
Northstar must not use browser, computer-use, Chrome, plugin, or other UI
automation to imitate it.

## Sequencing

PR 18 remains in changes-requested revision and owns the current Northstar
front-door closeout. Card 114 is deliberately blocked behind its accepted merge
rather than creating a same-repository shared-surface worker race. After that
merge, the orchestrator refreshes `main`, marks card 114 ready, publishes one
worker handoff, and dispatches the implementation lane.

## Evidence

- Paseo `create_workspace` supports `local` isolation and same-project/path
  placement.
- Paseo `create_agent` and `paseo run --label <key=value>` support agent labels.
- Current MCP and `paseo workspace` / `paseo run` help expose no native sidebar
  pin/reorder control.

## Next Task

Complete PR 18 review/merge, then dispatch card 114 from refreshed `main`.
