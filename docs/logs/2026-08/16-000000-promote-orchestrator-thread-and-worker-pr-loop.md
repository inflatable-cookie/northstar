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
- extended the working-rules contract with authority, single-file handoff,
  commit/push-before-dispatch, chunk-reporting,
  stop, PR-review, requested-changes, and merge-boundary rules;
- added the internal `orchestrator` mode to the single public `northstar` skill;
- added a reusable `northstar-orchestrator-run.md.template` single-file handoff;
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
- `effigy check:skill-install /Users/tom/.agents/skills/northstar`: passed
  (`Northstar skill install parity: OK (32 files)`)
- direct source/install tree comparison: source 32 files, installed 32; no missing,
  extra, or differing files; both orchestrator assets are present;
- negative-path parity probe: removing the orchestrator mode produced the expected
  non-zero `missing: references/modes/orchestrator.md` failure;
- therefore the source feature is implemented, distributed, and parity-proven.


## Follow-up protocol clarification

The launch contract is intentionally stricter than the initial design: the
orchestrator publishes planning state on `main`, creates one concrete run file,
commits and pushes that file, verifies `HEAD == origin/main`, creates the worker
worktree from that pushed commit, and gives the worker only the run-file path.
The worker does not receive a second prompt or copied transcript context.


## Next task

Run `g02.025/072` through a fresh worker thread, dedicated worktree, operator-
relayed chunk report, and reviewable PR before adding adapters or automatic
cross-session messaging.
