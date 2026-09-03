# Open Chatterbox Intake Channel

Date: 2026-09-03
Roadmap: `g02.050`
Card: `g02.050/124`
Status: ready; handoff published

## Result

Card 120 passed exact-head review and merged through PR 30 as `aa9a005`.
The installed Northstar skill was refreshed from that merge and contains the
111-file generic core. Its skill/router/command ownership is released.

Card 124's remaining readiness checks now pass. No other implementation worker
owns orchestrator mode, the router, command adapters, or its closeout surfaces.
Spec 035 already settles the mode, shared-checkout unique-file protocol,
idle-only Paseo ping, authority refusals, and eight-row oracle. No product or
planning choice is delegated.

## Next Task

Launch one day-to-day implementation child from
`docs/handoffs/20260903-181459-add-chatterbox-intake-channel.md` in a dedicated
Paseo worktree workspace. Stop for exact-head review of its PR.
