# Changelog

All notable changes to Northstar are documented here.

## [Unreleased]

### Changed
- Northstar is lean (2026-09-26). The `northstar` skill is now the lean skill:
  planning, briefs, review and knowledge upkeep, with a copy-ready
  `template/`, the retired-concepts check and the `cut` migration tool. Task
  state, briefs, closeout and papercuts live in Queue.
- Northstar's own docs follow the lean shape: `docs/knowledge/`,
  `docs/plan.md`, `docs/triage/`.

- The plan, triage leads and brief drafts live in Queue (2026-09-27). The
  skill's `plan` and `brief` references use lanes, lane documents, `plan.set`,
  leads and drafts; the template drops `docs/plan.md` and `docs/triage/`, and
  `adopt.md` has the move for already-lean repositories.

### Removed
- `bundle-docs/`, `template-bundle/`, the router and modes, the command
  skills, the working-rules contract, roadmaps, logs, handoffs, lifecycle
  records, `PAPERCUTS.md`, and the checks that served them. Git keeps them.

### Added
- Added the initial `skills/northstar-effigy/` scaffold so agents can apply the
  Northstar + Effigy repo contract from a reusable source of truth.
- Added native and compatibility `effigy.toml` starter variants plus a
  `monkey` native-cutover reference so the skill can choose the right adoption
  path based on the actual Effigy surface on `PATH`.
- Added `skills/northstar-handoff/` plus a reusable log-level handoff template
  so Northstar can generate execution-ready continuation briefs that stay tied
  to vision, roadmap, and log context.

### Changed
- Updated Northstar's own Effigy guidance to use current-repo defaults without
  redundant `--repo .`, and added repo-local docs QA for that contract.
- Compressed `northstar-effigy` into a smaller portable bundle by trimming
  `SKILL.md`, reducing the reference set, and making the installable unit more
  explicit in the repo front door.
- Extend `northstar-effigy` so it now treats thin workspace roots plus nested
  docs-authority repos as a first-class adoption mode instead of assuming every
  consuming project should carry one root-level docs/changelog/release surface.
- Tightened the `northstar-effigy` source-of-truth docs so native Effigy mode
  is now the default target, compatibility mode is clearly a fallback, and the
  boundary between skill-owned scaffolding and Effigy-owned validation/runtime
  surfaces is described consistently across the bundle.
