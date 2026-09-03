# Open Embedded Language Payload Removal

Date: 2026-09-03
Roadmap: `g02.048`
Card: `g02.048/120`
Status: ready; dispatching

## Result

PR 29 merged the Paseo worker-parentage correction as `7ebaa9c`. The installed
Northstar skill was refreshed and matches the 199-file source payload. That
clears card 120's final serial edge.

Card 120 is the sole ready implementation lane. It owns the frozen 95-file
embedded and fallback deletion inventory plus the 19 integration surfaces from
`docs/logs/2026-09/03-095021-refresh-embedded-removal-readiness.md`. The generic
registry, trust, lifecycle, selection, and installed-package routing core stays.

The worker needs read-only sibling access to `northstar-language-packs`,
`convergence`, and `jetstream` for accepted package and consumer proofs. It may
not mutate those repositories, add a language, start the Sentrux cohort, or
retain aliases and silent fallbacks.

## Next Task

Publish the card-120 worker handoff, launch one day-to-day child worker in a
dedicated Paseo worktree workspace, then stop for its reviewable PR.
