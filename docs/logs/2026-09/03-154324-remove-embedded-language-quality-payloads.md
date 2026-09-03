# Remove Embedded Language Quality Payloads

Date: 2026-09-03
Roadmap: `g02.048`
Card: `g02.048/120`
Status: complete; reviewable PR pending orchestrator review

## Result

Card 120 deleted the frozen embedded TypeScript and Rust quality payloads and
every bounded migration fallback from the root skill, then rewired the routing,
checker, and operator surfaces to the generic installed-package route. Northstar
core keeps only generic package discovery, registry, trust, lifecycle, receipts,
host protocol, and routing. The source payload is now 111 files (was 199). A
missing package stops only that language workflow and names the manual
installation route; planning, orchestration, review, and docs workflows are
proven usable with no package installed.

Commit `380d20b`: 96 deletions, 14 mutations, 1 addition, 1 rename (97 files
removed including the two retired `rust-package-pin` scripts).

## Deletion inventory

The frozen inventory from
`docs/logs/2026-09/03-095021-refresh-embedded-removal-readiness.md` was
reproduced exactly before deletion: 95 tracked files matching every closed path
set in that log's table (24 rust references, 4 Rust modes/scripts, 22
`tools/rust-quality` files excluding `target/`, 4 Rust adapter/template files,
8 typescript references, 4 TypeScript modes/scripts, 5 TypeScript
adapter/template files, 2 `overlap-windows` files, 13 fallback fixtures, 2
negative-overlap fixtures, 7 `rust-quality-production` harness files).

Pre-delete evidence, recorded here in a documented format (C-locale sorted
newline-terminated `git ls-files` path list, then ordered `sha256sum` rows over
the same order):

- path-list SHA-256: `5931c27112f6ba3eb2ff67643a317cee443f72d1fc761702b35ff2323eccda65`
- content-row SHA-256: `bf73151ce435019c9ab2d2625c971d54ae4dca3ade747829df192543eac4cd1a`

The frozen log's two hashes (`a903af88…`, `9e8c3de6…`) were computed with an
undocumented serialization and could not be byte-reproduced; the 95-file set
itself matched every named group count exactly, and the last commit touching any
of the 95 files (`256d0f7`, 08:19) predates the freeze (09:50), so the bytes are
the frozen bytes.

## Integration surfaces

All 19 surfaces from the frozen inventory were mutated or replaced; none was
blindly kept:

- routing: `references/router.md` replaced the three per-language branches with
  one generic language-quality section (explicit intent or exact activation
  marker, no package IDs, no embedded content);
  `references/packages/installed-package-route.md` replaced the failed-
  acquisition fallback rule with the scoped visible stop;
  `references/modes/normalize-docs.md` replaced the embedded Rust setup
  instruction with the installed-package route.
- lifecycle/discovery: `language-package-lifecycle.ts` lost `decideFrozenFallback`,
  `parseOverlapRegistry`, the `OverlapWindow` type, the `fallback` CLI
  subcommand, and the frozen-fallback oracle; it keeps the negative assertion
  that a host stop never claims a frozen fallback.
  `scripts/check-language-packages.rhai` lost the overlap schema/document
  validation, the fallback CLI proofs, and `expect_fallback_cli_failure`; the
  shipped registry (still the acquisition trust root, discovery metadata
  intact) and all selection proofs stay.
- catalogues/checkers: root and skill `effigy.toml` lost the embedded
  rust/typescript tasks; root `validate` is now wiring, bundle,
  language-packages, language-package-routes, paseo-worktree.
  `check-northstar-command-skills.rhai` validates seven adapters and no longer
  requires the deleted audit adapters; `check-northstar-skill-install.rhai`
  ignores only `.effigy/`; repo-contract data and fixtures match the reduced
  board; `scripts/README.md` documents the reduced core and the replacement
  routes oracle; `template-bundle/README.md` and
  `bundle-docs/skills/README.md` describe installed packages, not embedded
  setup tasks.
- integration proof: `scripts/tests/rust-package-pin/` was retired and replaced
  by `scripts/tests/language-package-routes/` (validator + self-test), wired as
  `check:language-package-routes`.

## Proof

`effigy check:language-package-routes` (0 failures, ~30s) replays both accepted
pins from the read-only sibling and falsifies the card oracle:

- exact negative inventory: post-delete path and content scans over
  `skills/northstar` return zero implementation remnants (registry package IDs,
  exact activation-marker test strings, and the negative fallback-claim
  assertion are the only remaining language strings and are policy/test data);
- core-only: isolated rsync install passes `check:skill-install` (111 files),
  and the installed copy runs a non-language workflow
  (`check:agent-instructions`) cleanly;
- scoped failure: with no allowlist and no installed package, each language's
  `acquire_activate` stops visibly with its own identity and the manual route,
  never naming the other package or a frozen fallback; consumer bytes
  unchanged;
- two-package installed route: TypeScript (`c9ef2a2`) and Rust (`56b2e11`)
  materialize from the sibling object store, reproduce all four spec-034
  digests with an independent implementation, install into one shared state
  root at independent addresses, resolve local-only to their exact receipts,
  keep foreign-language files out of each payload, scope a drift stop to
  TypeScript while Rust keeps routing, and both pass their own reviewed
  `prove-installed-invocation.sh`;
- consumer authority: Northstar's own consumer profile and deviations are
  byte-identical to the pre-change HEAD; Jetstream and Convergence activation
  markers (`northstar:rust-quality`) are untouched in their repositories, and
  the checker proves those exact markers still select their registry entries;
- no compatibility theatre: deleted mode/adapter/tool paths have zero
  references anywhere in the payload; the router's generic section states the
  no-fallback rule; the lifecycle oracle's host-stop assertion rejects any
  frozen-payload claim.

## Validation

`effigy qa` passes end to end: `check:bundle`, `check:language-packages`
(6 schemas), `check:language-package-routes`, `test:paseo-worktree`,
`check:repo-contract-wiring`, `check:repo-contract`, `test:repo-contract`
(11 fixtures), `check:readiness-map`, `check:command-skills` (7 adapters),
`check:model-routing`, and `qa:docs`. `git diff --check` is clean on the
branch.

## Limits and disposition

- The orchestrator-side frozen inventory hashes were not byte-reproduced
  (serialization undocumented); the set and the underlying file bytes are
  proven as above.
- Pre-removal consumer evidence (Jetstream PR 4, Convergence PR 4) remains
  accepted history; no consumer policy or evidence was rewritten.
- Spec 034 stays retained as planning history with the extraction lane closed;
  the Sentrux triage note and any new-language cohort remain operator
  decisions, out of this lane's scope.
- The live installed skill at `~/.agents/skills/northstar` was not synced from
  this lane; the orchestrator owns the installed-skill refresh after merge.

## Next Task

Orchestrator: exact-head review of the PR against `main`, then merge and
refresh the installed skill. No new language or Sentrux integration starts
from this lane.
