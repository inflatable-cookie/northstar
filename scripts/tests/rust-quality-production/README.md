# Rust V2 Production Qualification Regression

This retained harness reconstructs the three packet-only explicit-audit subject
shapes used to qualify the distributed Rust v2 payload. Its self-test checks
the worktree, mixed-repository, degraded-evidence, scoring, and negative-path
contracts without retaining the original research cohorts.

Runtime cohorts live outside the repository. They are immutable after
`prepare`; halt and prepare a new revision on any packet, oracle, isolation, or
scoring defect.

```text
./prepare.sh <cohort-dir>
./run-subject.sh <cohort-dir> <subject-id>
./score.sh subjects <cohort-dir>
./prepare-reviews.sh <cohort-dir>
./run-reviewer.sh <cohort-dir> <review-id>
./score.sh final <cohort-dir>
```

The harness never distributes the skill or mutates a consumer repository.
