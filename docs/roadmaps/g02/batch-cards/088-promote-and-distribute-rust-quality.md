# 088 - Promote And Distribute Rust Quality

Status: ready
Owner: repo maintainers
Updated: 2026-08-26
Master spec refs: `docs/specs/031-rust-quality-authoring-and-audit.md`
Roadmap ref: `g02.030`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`bundle-docs/skills/README.md`, card 087, production evidence revisions K and M
Auto-start next card: no

## Objective

Promote the evidenced Rust quality modes into the copy-ready, documented, and
install-verifiable Northstar product surface, then close the implementation
lane without overstating assurance.

## Scope

- skill/router/adapter documentation and source checks;
- copy-ready activation/profile surface;
- skill-local Effigy task inventory selected by card 083;
- source/install parity;
- architecture, inventory, contract index, spec, roadmap, and log closeout;
- operator-facing setup and explicit-audit invocation.

The promoted command is `/northstar-rust-audit`; its source is
`skills/northstar/commands/northstar-rust-audit/SKILL.md`. Distribution must
include the frozen `references/language-quality/rust/` payload, both Rust modes,
the two Rhai scripts, and the three skill-local selectors
`northstar/check:rust-quality`, `northstar/test:rust-quality-recorder`, and
`northstar/rust-quality:record`.

## Implementation Steps

1. Promote the exact evidenced payload into source and copy-ready surfaces.
2. Update router, adapter, task, bundle, and instruction checks.
3. Update setup, operator, architecture, inventory, and supported-claim docs.
4. Verify a real installed payload against source and command inventories.
5. Close cards, milestone, spec, logs, and front doors only after full QA.

## Acceptance Criteria

- [ ] One installed `northstar` skill exposes compact Rust authoring and the
      explicit audit adapter.
- [ ] Copy-ready setup declares strict profile resolution and repository-owned
      MSRV, exclusions, and deviations.
- [ ] Deterministic checks reject catalogue drift and command duplication.
- [ ] Full source/install parity and repository QA pass.
- [ ] Documentation states that ordinary, high assurance, combined-default, and
      observable-compaction claims remain unsupported.
- [ ] Spec 031 is archived or retired only after every durable outcome and
      remaining evidence gap has a canonical home.

## Validation

- `effigy check:command-skills`;
- Rust quality package checks selected by card 083;
- `effigy check:skill-install <installed-path>`;
- `effigy check:agent-instructions`;
- `effigy check:posture-advisory`;
- `effigy qa:docs`;
- `effigy qa`;
- `git diff --check`.

## Evidence

Record the production catalogue hash, command inventory, installed file parity,
QA output, changed surfaces, supported claims, and unresolved evidence gaps in
the closeout log.

## Stop Conditions

- stop if distribution differs from the evidenced payload;
- stop if documentation implies a second installable skill or hidden setup;
- stop if any unsupported assurance or certification claim appears;
- stop before release mutation or consumer-repository changes.

## Next Task

After implementation closeout, seek operator-provided live-use feedback; do not
dispatch a consumer run from Northstar.
