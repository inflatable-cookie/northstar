# Worker handoff dispatch uses absolute paths and sibling links

Date: 2026-08-28
Surface: orchestrator worker-PR loop; Northstar skill

Consumer papercuts showed T3 starting the wrong repo from a relative
`docs/handoffs/...` path, and launcher worktrees missing `../underlay`,
`../poodle`, and `../longhorn` while catalog members still hard-fail.

This is encoded in Northstar, not T3:

- the operator-facing dispatch path is always the handoff's absolute path;
- each worker handoff lists required sibling worktree links (absolute
  primary checkouts and the link name beside the worktree) or `none`;
- after the worker accepts the worktree, it creates those symlinks and
  stops if a listed source is missing.

Changed: skill `SKILL.md`, router, handoff mode, handoff contract,
orchestrator mode, worker handoff template, contract 001, spec 026,
system architecture, operator quick start.
