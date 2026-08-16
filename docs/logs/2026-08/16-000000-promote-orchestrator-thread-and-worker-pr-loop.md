# Promote Orchestrator Thread And Worker PR Loop

Roadmap refs: g02.025, cards 070-072
Master spec: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Research: `bundle-docs/research/translation-memos/northstar-orchestrator-thread.md`

## What changed

- reviewed Northstar's architecture, contracts, roadmap/card, handoff, autonomy,
  Effigy, and installed-skill surfaces;
- reviewed current official Codex, Claude Code, OpenCode, and GitHub review
  workflows and translated only durable, provider-neutral lessons;
- promoted an explicit orchestrator/worker/worktree/PR topology into architecture;
- extended the working-rules contract with authority, packet, chunk-reporting,
  stop, PR-review, requested-changes, and merge-boundary rules;
- added the internal `orchestrator` mode to the single public `northstar` skill;
- added a reusable `northstar-orchestrator-run.md.template` launch packet;
- created g02.025 and marked its design/contract cards complete, with the real
  dogfood card ready and deliberately not auto-started.

## Evidence

- repository inspection covered `AGENTS.md`, protocol kernel, architecture,
  inventory, contracts, handoff, autonomy, roadmap, logs, installed skill
  source, and Effigy orientation;
- source-backed memo links official vendor documentation and GitHub review
  guidance with retrieval date 2026-08-16;
- no provider-specific messaging or model ID is required by the protocol;
- model routing is capability-based: frontier orchestrator/reviewer, capable
  bounded worker, fast reconnaissance.

## Lane state

- g02.025 design batches 25.1 and 25.2 complete
- g02.025/072 ready
- continuation envelope exhausted for this design batch
- lane budget complete
- pause signal: `handoff-required`

## Papercut

Recorded one actionable root-queue entry for Markdown hard-break whitespace in
`bundle-docs/research/master-index.md`, then removed the whitespace so
`git diff --check` can validate edited lines cleanly.

## Validation

- `effigy qa`: passed (`Northstar bundle checks: OK`; `Northstar repo contract checks: OK`)
- `effigy qa:docs`: passed (`Northstar repo contract checks: OK`)
- `git diff --check`: passed
- targeted mode, packet, spec, roadmap, dogfood-card, and log existence/content
  checks: passed
- changed-file Markdown link/table-shape check: passed
- source/install parity command: blocked by existing Effigy `join(array, ...)`
  runtime error;
- direct read-only tree comparison: source 32 files, installed 30; installed
  copy missing `assets/templates/northstar-orchestrator-run.md.template` and
  `references/modes/orchestrator.md`, with differing `SKILL.md` and router;
- therefore the source feature is implemented, but the currently installed
  skill is not yet refreshed or parity-proven.


## Next task

Complete `g02.025/073` first: repair the parity-checker runtime path and refresh
the installed skill. Then dogfood `g02.025/072` with one fresh worker thread,
one dedicated worktree, and one reviewable PR before adding adapters or automatic
cross-session messaging.
