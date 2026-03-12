# Changelog

All notable changes to Northstar are documented here.

## [Unreleased]

### Added
- Added the initial `skills/northstar-effigy/` scaffold so agents can apply the
  Northstar + Effigy repo contract from a reusable source of truth.
- Added native and compatibility `effigy.toml` starter variants plus a
  `monkey` native-cutover reference so the skill can choose the right adoption
  path based on the actual Effigy surface on `PATH`.

### Changed
- Updated Northstar's own Effigy guidance to use current-repo defaults without
  redundant `--repo .`, and added repo-local docs QA for that contract.
- Compressed `northstar-effigy` into a smaller portable bundle by trimming
  `SKILL.md`, reducing the reference set, and making the installable unit more
  explicit in the repo front door.
- Extend `northstar-effigy` so it now treats thin workspace roots plus nested
  docs-authority repos as a first-class adoption mode instead of assuming every
  consuming project should carry one root-level docs/changelog/release surface.
