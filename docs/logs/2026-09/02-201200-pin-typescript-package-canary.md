# Pin TypeScript Package Canary

Date: 2026-09-02
Roadmap: `g02.048`
Card: `g02.048/118`
Status: registry/routing worker complete; PR open for exact-head review

## What Was Built

The registry/routing step of card 118 (execution plan step 4) is implemented on
`worker/pin-typescript-package-canary`. The worker ran from a clean Paseo
worktree against pushed `main` at `e36838c`, with the tracked handoff verified
byte-for-byte before mutation.

- Official registry pin: `official-registry.json` now carries exactly the
  accepted canary identity `@northstar/typescript-quality` `0.1.0` from
  `inflatable-cookie/northstar-language-packs` subpath `packages/typescript` at
  commit `09ef1743dd8fc18bae3bf04fae791f1d7d4e5daf` (tree
  `sha256:0fcd5c58296f168895b66f2472621d49761f7786ea2ad1ebeefb801040967d6b`,
  manifest
  `sha256:ed95883c428ef43f0f02d38d60bf8d50e6e29313f5751c1b2a5744157a5b5362`,
  core range `>=0.2.0 <1.0.0`), under registry version `1.1.0`.
- Generic installed-package route: `references/packages/installed-package-route.md`
  defines the language-agnostic route procedure (resolve, acquire under
  explicit intent, route, frozen fallback) over `language-package-host.v1`.
  The router's TypeScript/Svelte explicit-audit section routes through the
  installed package first and names the pinned identity; the embedded payload
  runs only after the route doc's visible fallback notice.
- Truthful receipt provenance: official receipts now record the actual
  authorizing registry document version and entry digest instead of a
  hardcoded `1.0.0` constant.
- Visible frozen fallback: the fallback notice template names the failed
  package identity and the frozen embedded payload; failure stops only the
  requested language workflow.

## Canary Finding Fixed

The first real-package acquisition exposed a card-117 interaction defect: the
declared self-check (cwd = package root) runs the package-owned Effigy check,
which writes `.effigy/` receipts into the executed root. The polluted tree then
failed selection re-verification, so routing could never succeed after a real
self-check. Fix: `runPackageSelfCheck` executes the candidate on a byte-exact
throwaway copy of the verified staged root and discards it; the installed
payload keeps the pinned identity. Oracle 11 gained argv/cwd proof on the
execution copy plus a pollution regression (a polluting self-check cannot
mutate the verified staged payload, and an acquired polluting package still
routes afterwards).

## Falsification

- `oracle-14 official-pin-route` (hermetic, canary-shaped registry): official
  git-source pin through a transport-less host stops visibly naming the
  package and the manual route; detection with the pin present never
  acquires; the official pin outranks the operator allowlist; a conforming
  transport install routes offline; drifted installed bytes stop instead of
  routing and exact restoration reopens the route; rollback reopens the route
  without fetching; official receipts record registry version `1.1.0` and the
  entry digest.
- Registry identity proof: an independent Python implementation of the spec-034
  framing over the materialized accepted commit reproduced both pinned digests
  (20 files; manifest and tree digests exact).
- Real-package route transcript (sibling checkout, read-only; no sibling
  mutation): official-registry acquire stops visibly (fallback trigger);
  detection does not acquire; operator local-path trust for the exact pinned
  identity activates through the lifecycle surface including the real
  package self-check; resolve routes offline through the real registry; the
  installed payload contains no `.effigy` pollution; the declared direct
  self-check exits 0 from an installed-root-shaped copy; drift stops the
  route and a byte-exact restore reopens it. Consumer-directory hashes were
  unchanged across every failure case.

## Validation

Standalone oracle with Effigy absent, `effigy check:language-packages`,
isolated skill-install parity (`179 files`), `effigy qa:docs`, `effigy qa`,
and `git diff --check origin/main...HEAD` all pass. The 17 embedded
TypeScript payload files are byte-identical to `origin/main`.

## Limits

Registry promotion completes when the orchestrator merges the PR. Fresh
Jetstream consumer evidence (installed-package audit identity, route identity,
overlays, rollback, offline, forced-fallback runs, consumer before/after
hashes) remains serial behind the accepted head, per the handoff.
