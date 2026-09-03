# Pin Rust Package Candidate

Date: 2026-09-03
Roadmap: `g02.048`
Card: `g02.048/119`
Status: implemented; awaiting exact-head review

## Outcome

The official registry pins the accepted Rust package identity at registry
version `1.4.0`, the Rust overlap window is open, and the checker, oracle, and
real-package transcripts prove acquisition, installed and offline routing,
drift rejection, Rust-only retained inventory, source-payload engine
integrity, and the exact visible frozen fallback. Convergence remains the
next serial step; nothing in this batch executes the consumer canary.

## Registry pin

Registry version advanced from `1.3.0` to `1.4.0`. The new entry is
`@northstar/rust-quality` `0.1.0` at
`inflatable-cookie/northstar-language-packs` subpath `packages/rust`, core
range `>=0.2.0 <1.0.0`:

- commit `56b2e1107b80f369807cff88e1b0253df035c700` (package-source PR 4)
- tree `sha256:e5cf9c5da4a30c0f5164f2ea0c5e9d87d544c0c32f09f3c139a386c56154dba0`
- manifest `sha256:dd71d04efd67cc7805f417a79666dd920ea1811ee252d941108dfbeca8aab612`

The TypeScript canary entry is byte-unchanged. `overlap-windows.json` gains
the open Rust window (`payload_label` `Rust`) beside the TypeScript window;
the frozen-fallback decision needed no language branch.

## Independent identity proof

The accepted merge was materialized with `git archive` from the read-only
package-source sibling at `origin/main = 56b2e11`. Two independent
implementations of the spec-034 framing (a Python reader over the sibling's
git object store, and a separate filesystem walk of the materialized copy)
reproduced the same 59-file inventory and both digests exactly. The worker
fetched the sibling's `origin/main`; its working tree stayed clean and
unmodified.

## Real-package lifecycle transcript

Driven through the public `language-package-host.v1` CLI against the shipped
registry and the materialized pinned tree:

- official git-source acquire through the transport-less reference host stops
  visibly, names `@northstar/rust-quality@0.1.0` and the manual/local-path
  route, and never claims the frozen payload;
- detection intent does not acquire; the operator local-path allowlist cannot
  bypass the official pin while the transport is missing;
- operator local-path trust for the exact pinned identity activates through
  the lifecycle surface, including the real declared self-check
  (`effigy check:rust-quality`); the receipt records its operator-allowlist
  provenance truthfully;
- resolve routes offline (no registry argument) and through the shipped
  registry, for both `explicit_audit_repair` and `everyday_authoring`, always
  naming the pinned tree identity;
- drifted installed bytes stop the route; a byte-exact restore reopens it;
- a TypeScript request staged from the Rust tree fails closed on manifest
  identity, and wrong-tree or wrong-manifest staging fails closed before any
  package code runs — no TypeScript payload is ever fetched or installed;
- a hand-made version-drifted `0.2.0` variant is refused by the package's own
  self-check (`package version drifted`); the refusal leaves the prior
  selection, receipts, and consumer bytes unchanged. Because the package
  enforces its own version, a second real receipt is not constructible;
  two-receipt rollback semantics stay with oracle-14's generic proof in the
  suite, and the real-payload failed-update transactionality is proven
  directly;
- the `fallback` CLI consumes the Rust-shaped stopped pair plus
  `overlap-windows.json` and emits the exact notice: failed identity, host
  stop reason, and `using the frozen embedded Rust payload during the bounded
  overlap window`;
- retained inventory over the whole state root is exactly the 59-file pinned
  payload (byte-identical, no `.effigy` or cargo pollution, no TypeScript or
  Svelte artefacts); the consumer directory is byte-identical across every
  failure case.

## Installed-route and engine integrity proof

The package's reviewed `prove-installed-invocation.sh` ran against the
lifecycle `installed_path` and passed: spec-034 canonical digest plus
mutation rejection; 54-source deterministic parity against Northstar
`69e4d5d` (44 byte-exact, 4 eof-normalized, 6 recorded adaptations with
pinned digests) plus unrecorded-rewrite rejection; producer engine built from
the pinned commit with mismatched-sibling rejection; cross-boundary
pre-extraction v2 ledger migration with byte preservation; public skill-run
setup, relay sentinels, decoy-catalogue isolation; engine cargo tests,
embedded source-payload tamper rejection, and probe `verify-install`;
adapter grammar and exact-command closure.

## Validation

- `effigy check:language-packages`
- isolated `effigy check:skill-install skills/northstar`
- `effigy qa:docs`
- `effigy qa`
- `git diff --check`

All passed.

## Limits

The Convergence consumer canary is the next serial step and was not started.
Card 120 stays blocked. Real-package rollback is bounded to the transactional
refusal above for the single-release candidate. The package-source sibling
was fetched but never modified.
