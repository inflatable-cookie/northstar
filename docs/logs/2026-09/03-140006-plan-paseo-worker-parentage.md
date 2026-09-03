# Plan Paseo Worker Parentage

Date: 2026-09-03
Roadmap: `g02.049`
Card: `123`
Status: ready for dispatch

## Outcome

The operator reported that several Paseo-backed orchestrators created workers
as detached root threads. Those workers had dedicated workspaces but no parent
notification route, so their originating orchestrators missed completion.

The Paseo reference already separates placement from ownership: an
orchestrator-scoped `create_agent` call remains a child even when it targets a
workspace returned by a separate `create_workspace` call. Northstar required
both operations but did not explicitly bind them into one scoped sequence or
reject top-level substitutes.

Spec 026 now settles that sequence. Milestone `g02.049` and card 123 bound the
propagation, six adversarial review rows, validation, and stop conditions. No
Paseo product change or provider-specific parent override is needed.

## Scheduling

Card 123 is the sole newly selected lane. Card 120 remains ready but serial
behind it because both lanes own the Northstar skill payload and roadmap/front-
door closeout surfaces. The card-123 launch itself is the live positive proof:
create a worktree workspace first, then create the worker from this
orchestrator's scoped agent surface with that workspace ID and finish
notifications enabled.

## Next Task

Commit and push one worker handoff, then launch card 123 through the scoped
cross-workspace child sequence.
