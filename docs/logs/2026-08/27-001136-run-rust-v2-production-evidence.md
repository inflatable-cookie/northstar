# Run Rust V2 Production Evidence

Date: 2026-08-27
Roadmap: `g02.032/098`
Status: complete

## Changed

- added a reproducible, isolated three-subject production harness and scorer;
- exercised worktree, repository, nested mixed-package, degradation, repair,
  preservation, authority, and limitation paths;
- halted revisions A-D on harness, fixture, and blind-review defects without
  patching scored cohorts in place;
- passed revision E with the exact frozen production payload;
- made card 099 ready without distributing the payload.

## Evidence

- `3/3` deterministic subject results passed with exact `4/4` primary findings;
- `18/18` unit-rule verdicts and `9/9` attestations are recorded;
- `3/3` blind reviewers accepted, all `15/15` dimensions scored at least four,
  and no reviewer recorded a concern;
- the degraded subject retained three explicit limitations;
- payload SHA-256 remained
  `dab44a149ee02bc17777e575f42b8857685031a2e0ee21cbc66a981624ff471f`.

## Research record

`bundle-docs/research/prototypes/rust-quality/rust-v2-production-evidence-report-2026-08-27-e.md`

## Validation

- production harness shell analysis and self-test pass;
- Rust 1.97 package tests and pedantic Clippy pass (`19/19` tests);
- Rust and TypeScript package checks, setup/recorder tests, full `effigy qa`,
  docs QA, posture advisory, and diff checks pass;
- the agent-instruction audit completes with its existing advisory findings;
- full QA now ignores generated Cargo target binaries in the command-surface
  text scan, resolving the recurring UTF-8 failure.

## Continuation

Card 098 exhausted its one-card continuation envelope. The evidence gate now
makes card 099 ready. Distribution starts only as a separate bounded batch.

## Next task

Execute ready card `g02.032/099`: distribute the exact passing v2 payload,
prove source/install parity, and close the lane.
