# g03.022 — Scale the handoff backlink guard past corpus-size bounds

Owner: repo maintainers
Created: 2026-09-22
Governing refs: contract 001, lifecycle reference; `fa510fd`
Depends on: none
UI classification: none

## Outcome

The handoff backlink guard (`findHandoffBacklinks` in
`skills/northstar/scripts/lifecycle-backlink.ts`) costs work proportional to
the files that mention the handoff, not to the repository's Markdown corpus.
A consumer with 100,000+ tracked Markdown files merges and closes out without
the guard refusing on size.

## Ready-State Rubric

- [x] Bovine hit the 64 MiB aggregate bound on 2026-09-22; `fa510fd` raised it
  to 128 MiB as a stopgap.
- [x] Bovine now tracks 21,073 Markdown files (67 MB) of 27,199 files; the
  25,000-file bound and the 4 MiB `git ls-files` listing bound (2.4 MB now)
  are next. Tom expects well over 100,000 files once papers are complete.
- [x] Tom approved this lane on 2026-09-22 ("Go for it") through the Bovine
  Chatterbox, with the Northstar Chatterbox closed.

## Decisions

- Prefilter, then parse. Run `git grep -l -z -F <handoff basename> -- '*.md'`
  over the tracked tree and run the existing link parser only over the hits.
  Every link form the parser resolves (inline, autolink, reference
  definitions) carries the target basename literally, so a file without the
  basename cannot hold a backlink.
- Refuse the prefilter, not the guard, when the basename could be
  percent-encoded or otherwise escaped in a link target (anything outside
  `[A-Za-z0-9._-]`): fall back to the full scan for that handoff only.
- Keep bounds, move them. Replace the whole-corpus file, listing and aggregate
  bounds with bounds on the hit set (hit count, per-file size, hit aggregate).
  An oversized hit set still refuses, never skips.
- Guard results must be identical to the current scan on every existing
  fixture. Refusal wording stays identical across pre-merge and closeout gates.

## Dispatch manifest

- **State:** ready; Chatterbox dispatches it through Northstar Queue, which owns
  worker placement, review and merge.
- **Owned mutable paths:** `skills/northstar/scripts/lifecycle-backlink.ts`,
  `skills/northstar/references/lifecycle/README.md`,
  `scripts/tests/lifecycle-adoption/self-test.sh`, the lifecycle backlink
  fixtures, this task and the `g03` front doors.
- **Reserved closeout surfaces:** the `g03.022` lifecycle record and generated
  projections belong to the repository hook.
- **Worker:** automatic complex-capable pool with independent exact-head review.
- **Excluded:** Queue implementation, consumer repository edits, other
  lifecycle gates, release or CI mutation.
- **Escalation:** Chatterbox if equivalence with the current scan cannot be
  proven on the fixtures.

## Work

1. Add the `git grep` prefilter with the escaped-basename fallback.
2. Replace the corpus-size bounds with hit-set bounds.
3. Prove equivalence: every existing backlink fixture gives the same result;
   add fixtures for inline, autolink, full/collapsed/shortcut reference links,
   a hook-generated block that mentions the handoff, and a synthetic corpus
   larger than the old bounds that passes.
4. Record the install step the operator must run to refresh the installed skill
   (`~/.agents/skills/northstar`) after merge.
