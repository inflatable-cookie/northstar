# Promote And Distribute Rust Quality

Date: 2026-08-26
Roadmap: `g02.030`
Card state: `g02.030/088` complete; milestone complete

## Outcome

The evidenced strict Rust quality payload is distributed through the single
published `northstar` skill. The configured global install was updated from
`inflatable-cookie/northstar` after source commit `c7b64c9` reached `main`, then
matched the source payload at all 75 distributable files.

Copy-ready and operator docs now explain scoped everyday activation, explicit
worktree or repository audit, strict profile resolution, and repository-owned
MSRV, toolchain policy, exclusions, architecture, and deviations. Spec 031 is
retired in place after its durable behavior moved into contract 004 and system
architecture.

## Distribution Evidence

- catalogue SHA-256:
  `8178f34d38d25489e452e63586595f81adbf6918393c4e017c635b480935d981`;
- source/install parity: 75 files;
- install source: `inflatable-cookie/northstar`;
- explicit command inventory: eight thin adapters, including
  `/northstar-rust-audit`;
- installed Rust task inventory:
  `northstar/check:rust-quality`,
  `northstar/test:rust-quality-recorder`, and
  `northstar/rust-quality:record`;
- installed shared task:
  `northstar/check:agent-instructions`;
- package result: seven rules, strict-only, seven negative paths, seven Rust
  routes, and six authoring workflow cases;
- recorder result: three positive paths and ten negative paths.

The installed task catalogue has no Northstar source-checkout dependency and
does not expose the source repository's full QA board.

## Supported Claims

Production revisions K and M support compact strict everyday Rust authoring and
explicitly triggered strict audit-and-repair as separate workflows. The router
loads one selected mode, and individual rule detail loads only when applicable;
the catalogue does not become general always-loaded Northstar context.

The evidence does not support ordinary or high-assurance activation, a combined
default, observable context-compaction resilience, cross-language behavior,
unsafe/FFI repair under strict, certification, NASA compliance, a safety
integrity level, or a safety case.

## Changed Surfaces

- skill, operator, template-bundle, and scripts documentation;
- system architecture, inventory, and contract index;
- spec, card, milestone, generation, and roadmap front doors;
- research status and prototype exit-state indexes;
- this closeout log.

The frozen skill payload itself did not change during card 088. Distribution
therefore matches the production-evidenced source from cards 084 through 087.

## Validation

- `effigy check:command-skills` — pass: eight adapters, 428 aggregate
  description characters;
- `effigy check:rust-quality` — pass;
- `effigy test:rust-quality-recorder` — pass;
- installed `northstar/check:rust-quality` — pass;
- installed `northstar/test:rust-quality-recorder` — pass;
- `effigy check:skill-install /Users/tom/.agents/skills/northstar` — pass:
  75 files;
- `effigy check:agent-instructions` — advisory complete; no files changed;
- `effigy check:posture-advisory` — pass with zero warnings;
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- `git diff --check` — pass.

## Next Task

The Northstar-owned Rust implementation lane is complete. Accept
operator-provided live-use feedback when available; do not select or dispatch a
consumer run from this repository.
