# Papercuts

Small, actionable friction found during agent work. Agents append entries when
they hit a solvable hurdle; they do not stop the current task to fix one.

## Open

<!-- Keep entries short. Append newest entries at the top. Do not include secrets. -->

- **2026-08-17 — harness worktree path mismatch duplicated a worker checkout:**
  t3code launched a clean registered worktree under `~/.t3/worktrees`, but the
  worker preflight treated its generated path/branch as invalid because they did
  not match handoff placeholders and created another worktree under a manual
  container; impact was 59 tool calls and an unwanted duplicate checkout;
  plausible fix is to make the current clean registered non-`main` worktree
  authoritative and run the four-command probe before Effigy orientation;
  affected surfaces are the worker handoff template, orchestrator mode, router,
  AGENTS guidance, and worktree contracts.

- **2026-08-17 — installed-skill audit discoverability:** `SKILL.md`, the
  router, and normalize-docs mode do not name `effigy
  check:agent-instructions` or contract 003, so the Poodle consumer review
  required searching the Northstar source checkout; impact is that an agent
  will not discover the review process without an operator hint; plausible fix
  is to route AGENTS review requests explicitly from normalize-docs; affected
  surfaces are the installed Northstar skill and normalize-docs reference.

- **2026-08-17 — agent-instruction audit target bridge scope:** auditing
  `../poodle/AGENTS.md` still checked Northstar's root/template Claude bridges
  and reported both OK while Poodle's bridge lacked exact `@AGENTS.md`; impact
  is a false-green consumer bridge result; plausible fix is to derive the
  bridge from each target root or accept explicit bridge paths; affected
  surface is `scripts/check-northstar-agent-instructions.rhai`.

- **2026-08-17 — agent-instruction audit byte metric:** the audit reports
  `text.len()` as bytes, but Poodle's Unicode-bearing `AGENTS.md` measured 5,413
  bytes with `wc -c` while the audit reported 5,397; impact is understated byte
  and approximate-token evidence; plausible fix is to count encoded bytes;
  affected surface is `scripts/check-northstar-agent-instructions.rhai`.

- **2026-08-16 — path-only worker handoff resolution:** the fresh worker's first
  relative `read_file` lookup resolved under `/Users/tom` instead of the named
  worktree and required repository search to recover the handoff path; impact is
  that a path-only brief is not yet uniformly consumable by every file-tool
  backend; plausible fix is to make worker file resolution explicitly root at
  the selected worktree; affected surfaces are the worker launcher/tool adapter
  and `skills/northstar/references/modes/orchestrator.md`.

- **2026-08-16 — stale remote HEAD lock during worker preflight:** `git fetch
  origin` was blocked by a leftover `refs/remotes/origin/HEAD.lock`; after
  confirming no Git process was active, removing the stale lock restored fetch;
  impact is avoidable launch friction; plausible fix is a guarded preflight that
  detects and reports stale locks without deleting live locks; affected surfaces
  are the orchestrator launch procedure and local Git preflight.

- **2026-08-16 — skill parity checker runtime (resolved):** `effigy
  check:skill-install` failed before comparison because the runtime did not
  provide array `.join(...)`; impact was that source/install parity could not be
  proven; fixed by using an explicit separator loop in
  `scripts/check-northstar-skill-install.rhai`; parity now passes for 32 files.

- **2026-08-16 — roadmap provenance check:** the docs QA also requires the phrase
  `consumer papercuts evidence` in the g02 front door after the next-task rewrite;
  impact is that provenance disappears from a currentness update; plausible fix is
  to make provenance a structured field rather than a prose contains-check;
  affected surface is `docs/roadmaps/README.md`.

- **2026-08-16 — roadmap currentness check:** the docs QA contains-check still
  requires the historical completion phrase `` `g02.024` is complete `` after a
  next-task rewrite; impact is that legitimate currentness edits fail QA;
  plausible fix is to assert structured status instead of stale prose; affected
  surface is `docs/roadmaps/g02/README.md`.

- **2026-08-16 — research index hard-break whitespace:** `git diff --check`
  flags Markdown hard-break spaces on a metadata line when that line is edited;
  impact is noisy diff validation; plausible fix is to use ordinary newline style
  or exclude intentional Markdown hard breaks from the check; affected surface is
  `bundle-docs/research/master-index.md`.
