# Prove TypeScript Audit Production Boundary

Date: 2026-08-26
Roadmap: `g02.031`
Card state: `g02.031/089` complete; `g02.031/090` ready

## Outcome

The TypeScript/Svelte explicit-audit production boundary is frozen without
scaffolding the production catalogue, route, recorder, or command.

Effigy-native Rhai remains the portable substrate at minimum Effigy `0.8.4`.
Bun/Node, package-manager scripts, and shell/`jq` were rejected as undeclared or
platform-specific consumer prerequisites. The TypeScript recorder will remain
language-specific while preserving Rust's proven case-local lifecycle; this
avoids destabilizing the production Rust recorder through premature shared-core
extraction.

The product paths, five selectors, `/northstar-typescript-audit` adapter,
strict profile/deviation files, audit evidence root, setup behavior, recorder
lifecycle, and repository-native tool-evidence fields are fixed in the bounded
report.

Scope discovery now supports repositories with no root `package.json`: nested
TypeScript/Svelte package manifests become independent owning roots. Repositories
with a declared root workspace still report undeclared nested packages rather
than absorbing them. Svelte and SvelteKit remain dependency/version/semantic-
surface overlays, not repository-wide switches.

## Evidence

- `production-boundary-report-2026-08-26-k.md`;
- rootless and declared-workspace scope-discovery self-test;
- copied-skill Rhai boundary probe with `PATH=/bin`;
- public `init -> assess -> complete -> finalize` lifecycle;
- one positive and seven negative authority/locality paths;
- three hash-valid TypeScript repair archives.

## Claim limits

Initial ownership is package-json based. Deno-only and source-only roots remain
unsupported. Svelte 5 and SvelteKit 2 are the initial promoted framework
semantics. Everyday, combined, deferred toolchain/testing rules, and production
distribution remain unavailable.

## Next task

Execute `g02.031/090`. Promote only the frozen catalogue and strict audit
projection; do not add routing or recording in that card.
