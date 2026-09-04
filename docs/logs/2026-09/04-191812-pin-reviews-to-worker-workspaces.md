# Pin Reviews To Worker Workspaces

Date: 2026-09-04  
Status: complete

## Result

Northstar now treats reviewer placement and reuse as exact transport invariants.
For a worker PR, the coordinator records the worker's `workspaceId`, passes that
same ID explicitly to reviewer creation, creates no review workspace, and
verifies the returned reviewer placement before accepting the run.

The coordinator also retains the reviewer `agentId`. After worker changes, it
resumes that same reviewer with `send_agent_prompt` once the revised clean head
is ready. Finished or idle reviewers remain reusable. Replacement requires
definitive unavailability, still uses the worker workspace, and starts a fresh
complete review.

## Failure fixed

The prior contract repeatedly said “existing worker workspace” but left enough
procedural slack for a coordinator to create a review workspace first. Older
superseded sections also retained direct instructions to create a dedicated PR
workspace. “Use the same reviewer when available” likewise allowed ordinary
re-review to become a new thread without proving the first reviewer was
unavailable.

## Evidence

- current doctrine, architecture, contracts, specs, operator guidance, skill
  entrypoint, router, orchestrator mode, PR-review mode, and worker template use
  the same exact placement and reuse rule;
- stale dedicated-review-workspace instructions were removed from canonical
  architecture and spec surfaces;
- behavioral fixtures accept exact worker-workspace placement and same-agent
  re-review, while rejecting a new review workspace, omitted or mismatched
  `workspaceId`, unnecessary new reviewer, ambiguous replacement, and a
  replacement in another workspace;
- skill-creator validation, `effigy check:command-skills`, `effigy qa:docs`,
  and `effigy qa` pass;
- the installed Northstar copy matches source exactly: 111 files.

## Next

Dogfood the next changes-requested loop. The original reviewer tab should wake
inside the worker workspace and review the new exact head.
