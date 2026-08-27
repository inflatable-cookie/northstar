# Retire Language Quality Prototypes

Date: 2026-08-27
Status: complete

## Changed

- removed the Rust and TypeScript quality prototype corpora after promotion;
- removed 15,904 superseded tracked files, including frozen trial archives,
  rejected revisions, temporary fixtures, orchestration, and scoring machinery;
- removed ignored Cargo, Bun, and Effigy output beneath those prototype trees;
- moved the seven-file Rust v2 deterministic regression harness to
  `scripts/tests/rust-quality-production/` and kept it in `effigy validate`;
- preserved Convergence live-use findings and final Rust/TypeScript
  qualification boundaries in compact project logs;
- replaced every prototype reference with its canonical contract, spec,
  closeout log, production tool, or retained regression test;
- stripped the retired prototype paths from Git history and force-updated the
  affected remote branch.

## Retention decision

Before cleanup, the prototype trees held 15,911 of 16,545 tracked files and
78.5 MB of uncompressed tracked content. With ignored dependencies and build
output present, they occupied 528 MB of the 734 MB checkout.

The raw corpora had completed their promotion role and were not production
authority. Durable behavior remains in `docs/contracts/004-language-quality-pack.md`,
the retired-in-place master specs, and `skills/northstar/`. Qualification
claims remain in the final closeout logs; rejected intermediate evidence is no
longer carried as an active repository surface.

## Validation

- retained Rust production harness self-test passes from its promoted path;
- `effigy qa` and `effigy qa:docs` pass after the removal;
- repository history contains no object path beneath
  `bundle-docs/research/prototypes/`.
