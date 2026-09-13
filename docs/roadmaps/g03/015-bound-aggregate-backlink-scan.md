# g03.015 — Bound aggregate backlink scanning

Owner: repo maintainers
Created: 2026-09-14
Governing refs: contract 001, g03.012 safe transient deletion, g03.013–014 scan bounds
Depends on: `g03.014` complete at `a8af8d4`
UI classification: none

## Outcome

The transient-handoff backlink guard scans large legitimate tracked Markdown
sets within explicit file-count, aggregate-byte, and per-file limits.

## Ready-State Rubric

- [x] The post-g03.014 Bovine retry proves the remaining refusal exactly.
- [x] Bovine's tracked Markdown count and aggregate bytes are measured.
- [x] No generated, vendor, or irrelevant path class can be excluded safely.
- [x] The replacement finite-bound model and atomic controls are explicit.
- [x] UI classification is `none`.

## Decisions

- Replace the standalone 5,000-Markdown-file refusal with two complementary
  bounds: at most 25,000 tracked Markdown files and at most 64 MiB of aggregate
  Markdown bytes. Bovine's 18,190 files and 37.52 MiB fit with material margin.
- Retain g03.013's 4 MiB per-file limit and g03.014's 4 MiB tracked-listing
  transport cap. Every limit fails closed before lifecycle mutation.
- Compute the aggregate from `lstat` sizes before reading file content. Refuse
  once the total would exceed the cap; do not partially scan or silently skip.
- Keep traversal repository- and document-structure-agnostic. Do not special
  case Bovine, syllabus paths, generated content, or directory names.
- After merge and installed-skill refresh, retry Bovine's exact retained hook
  occurrence again.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready; one Northstar core repair lane.
- **Owned mutable paths:** backlink traversal bounds under `skills/northstar/**`;
  focused lifecycle fixtures; matching reusable doctrine only where it states
  the bounds; this task and g03 indexes.
- **Reserved closeout surfaces:** g03.015 lifecycle record, declared generated
  projections, and deletion of this submitted handoff belong to the repository
  hook.
- **Worker:** automatic general pool; independent exact-head review required.
- **Serial edges:** Bovine Queue task
  `9c2ca547-5156-4b72-860d-1cff4c4c764a` closeout retry waits for merge plus
  installed-skill refresh.
- **Excluded:** consumer edits, path exclusions, partial scans, unbounded reads,
  Queue/Effigy source, releases, and Paseo thread/workspace disposal.

## Work

1. Replace the 5,000-file-only refusal with the settled 25,000-file and 64 MiB
   aggregate-byte bounds while retaining the 4 MiB per-file cap.
2. Preflight aggregate sizes before reading content and before any lifecycle
   mutation.
3. Add focused fixtures for Bovine-shaped success, file-count overflow,
   aggregate-byte overflow, per-file overflow, and exact-link atomic refusal.
4. Run lifecycle adoption/core checks, docs QA, full QA, installed-skill parity,
   and `git diff --check`.

## Acceptance and review oracle

- A synthetic 18,190-file, roughly 37.5 MiB tracked Markdown set reaches normal
  backlink scanning without a size-only refusal.
- More than 25,000 Markdown files refuse atomically.
- More than 64 MiB aggregate Markdown content refuses atomically even when each
  file is below 4 MiB.
- One file above 4 MiB and every exact supported handoff link still refuse
  atomically.
- Listing transport remains bounded and existing link-resolution controls stay
  green.

## Stop conditions

Stop if success requires path-specific exclusions, partial scanning, an
unbounded aggregate, weakening exact-link refusal, editing a consumer, or
changing Queue/Effigy.

## Evidence

After g03.014 fixed `ENOBUFS`, Bovine's exact hook attempt 3 reached the next
guard and refused because 18,190 tracked Markdown files exceed 5,000. Those
files total 39,344,682 bytes (37.52 MiB), the largest is 194,658 bytes, and none
exceeds 4 MiB. The largest groups are legitimate syllabus documents; no generic
path exclusion follows from the evidence.

## Next task

After merge and global skill refresh, retry the exact held Bovine hook. Then
return to Chatterbox; no successor is automatic.
