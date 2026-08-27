# Post Direct PR Review Findings

Date: 2026-08-27
Roadmap: `g02.034`
Card: `g02.034/102`
Status: complete

## Result

Northstar now has a direct route for a fresh thread asked to review an existing
PR. The thread reviews the PR and canonical repository authority independently,
then posts its verdict and every merge-blocking finding on the provider review
surface before summarizing in chat.

Formal changes-requested review is preferred. When reviewer and author share a
GitHub identity, the canonical fallback is one PR comment headed
`Changes required`. Authentication, permission, or posting failure leaves the
review blocked; it cannot be disguised as a complete chat-only review.

## Promoted boundary

- reusable doctrine owns the full direct-review behavior;
- the copy-ready working-rules template carries the compact binding rule;
- Northstar's contract, architecture, inventory, and orchestrator/worker spec
  now recognize direct review as a smaller entry path;
- the installed skill router selects `pr-review.md` for an existing PR URL or
  number without activating worker startup;
- the main skill description and runtime prompt make direct PR review
  discoverable;
- deterministic repo checks hold the provider-record and same-identity fallback
  wording.

## Validation

- `effigy qa:docs` — pass after shortening the main discovery description to
  the existing 460-character aggregate command-surface budget;
- `effigy qa` — pass;
- `effigy check:skill-install /Users/tom/.agents/skills/northstar` — pass, 121
  source-identical files after local development sync;
- skill-creator quick validation — source and installed skill pass;
- `git diff --check` — pass.

## Lane state

Card 102 and `g02.034` are complete. The continuation envelope and lane budget
are exhausted with pause signal `lane-complete`.

## Next

No blocking follow-up. Accept operator feedback from a real direct PR-review
thread when it appears.
