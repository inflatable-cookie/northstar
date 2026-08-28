# Worker handoff dispatch uses absolute paths and sibling links

Date: 2026-08-28
Surface: orchestrator worker-PR loop; Northstar skill

Consumer papercuts showed T3 starting the wrong repo from a relative
`docs/handoffs/...` path, and launcher worktrees missing `../underlay`,
`../poodle`, and `../longhorn` while catalog members still hard-fail.

This is encoded in Northstar, not T3:

- the operator-facing dispatch path is always the handoff's absolute path;
- the committed handoff in the selected worktree `HEAD` is canonical and
  is verified before any sibling-path mutation;
- each worker handoff lists required sibling worktree links (absolute
  primary checkouts and the link name beside the worktree) or `none`;
- sibling setup is create-if-absent, reuse-if-already-correct, stop-on-
  conflict; never delete or overwrite.

Changed: skill `SKILL.md`, router, handoff mode, handoff contract,
orchestrator mode, worker handoff template, contract 001, spec 026,
system architecture, operator quick start, promoted orchestrator memo.
