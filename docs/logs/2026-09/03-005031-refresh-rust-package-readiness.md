# Refresh Rust Package Readiness

Date: 2026-09-03
Roadmap: `g02.048`
Cards: `g02.048/119`, `g02.048/121`
Result: Rust inventory and canary selected; execution blocked on a TypeScript
package adapter repair

## Outcome

The operator selected Convergence as the Rust package canary. The Rust source
boundary is now exact. Card 119 is otherwise coherent, but it is not ready:
the accepted TypeScript package advertises a standalone command skill whose
first instruction loads a file absent from that package. Card 121 isolates the
repair and replacement registry pin before Rust copies the package shape.

## Rust Source Inventory

The inventory is frozen from Northstar
`4f534b204211b241fd5da17f4a7b845f969b0bc` and contains 54 tracked files:

- 24 under `skills/northstar/references/language-quality/rust/`;
- two routed modes, `rust-quality-authoring.md` and
  `rust-quality-audit.md`;
- two Rhai scripts, `rust-quality-setup.rhai` and
  `check-rust-quality.rhai`;
- 22 tracked files under `skills/northstar/tools/rust-quality/`;
- `skills/northstar/commands/northstar-rust-audit/SKILL.md`;
- three Rust activation/profile/deviation templates.

Inventory method: sort the 54 repository-relative paths, run GNU `sha256sum`
on each path in that order, then hash the resulting
`<file-sha256>  <path>\n` listing. Listing digest:
`2f8515afce33c87e9b38f103b9c41440ed7f182142fc2c65fed4d10d9264040b`.
The earlier 120-file number proves distribution of the whole configured
Northstar skill. It is not the Rust extraction boundary.

## Consumer Canary

Convergence was clean at
`1f05db1e507aa67f73a68eccc2325e23dfc1d478`. It has six Cargo manifests and
already activates both Rust routes. Its accepted repository audit merged
through PR 3. Current policy identities:

- profile:
  `5049d861115f819db5368dcd9ab2dc45381d1be6c5ae3c9947aa1e595fc281a4`;
- deviations:
  `d6d876aeb6e70da9fec368201350b6d16f345a7363309dde4169284c51c2fcd0`.

This gives card 119 a bounded consumer with recent audit evidence and no
hardware-dependent test prerequisite.

## Blocking Finding

`northstar-language-packs/packages/typescript/SKILL.md` says to load
`references/router.md` from the main Northstar skill. The package contains no
such file. Its package-owned proof executes setup and recorder tasks, so it
does not cover direct use of `$northstar-typescript-audit`.

The correction is bounded: route the adapter to the package's declared local
mode, prove package-relative path closure from a materialized installed copy,
merge the replacement source identity, then repin it in Northstar. No package
policy or generic protocol decision is required.

## Sequencing

1. deliver and review the TypeScript source repair in
   `northstar-language-packs`;
2. merge the replacement immutable identity;
3. repin and review that identity in Northstar;
4. refresh card 119 against merged main;
5. only then dispatch Rust source, registry, and Convergence canary work.

This planning batch performed no implementation, registry mutation, or
consumer mutation.
