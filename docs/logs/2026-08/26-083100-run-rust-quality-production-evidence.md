# Run Rust Quality Production Evidence

Date: 2026-08-26
Roadmap: `g02.030`
Card state: `g02.030/087` complete; `g02.030/088` ready

## Outcome

Both independent strict production tracks are eligible. Revision K passed
explicit audit 3/3. Revision M passed everyday authoring 3/3 after the final-diff
responsibility correction brought all churn ratios below the frozen `1.25`
ceiling. All valid runs received 5/5 median correctness and readability.

Card 087 is complete. Card 088 is ready but did not start. The continuation
envelope is exhausted and the lane pause signal is `budget-exhausted`.

## Evidence

- explicit audit: production revision K, 3/3, perfect recall/precision/locality,
  seven authorized repairs per run, exact preservation, no regressions;
- everyday authoring: production revision M, 3/3, churn `0.975`, `1.097`, and
  `1.143`, no residuals/regressions/scope widening, 5/5 blind scores;
- immutable archives:
  `bundle-docs/research/prototypes/rust-quality/trial-results/2026-08-26-cohort-production-k`
  and `2026-08-26-cohort-production-m`;
- bounded reports:
  `production-evidence-report-2026-08-26-k.md` and
  `production-evidence-report-2026-08-26-m.md`;
- revision M raw manifest:
  `b5084114aad6705968045cc8efcbbc04321953574b0d824ad2124f2d0d74143e`;
- revision M decision:
  `a23c6c38fef03449c6c2f5bf6de23c74638d6187ed972a70f843918d13ec728c`.

Revision L halted unscored after the CLI auto-updated mid-cohort. Its archive is
retained at `trial-results/2026-08-26-cohort-production-l`. Both isolated
runners now fail before model launch when the live CLI, model, or reasoning
differs from the frozen cohort cell.

## Claim Boundary

The evidence supports compact strict everyday Rust authoring and explicitly
triggered strict audit-and-repair. It does not support ordinary or
high-assurance profiles, a combined default, observable compaction resilience,
cross-language behavior, certification, or completed distribution.

## Validation

- Rust trial harness and all self-tests: pass;
- `effigy check:rust-quality`: pass;
- skill structural validation: pass;
- `effigy qa`: pass;
- `effigy qa:docs`: pass;
- `effigy check:agent-instructions`: advisory complete; no files changed;
- `effigy check:posture-advisory`: pass with zero warnings;
- shell syntax and `git diff --check`: pass.

## Next Task

On fresh operator continuation, execute `g02.030/088`: promote the evidenced
payload into copy-ready and installed surfaces, verify exact source/install
parity, update supported-claim docs, and close the lane. Do not perform release
mutations or consumer-repository runs.
