# g03.014 — Bound tracked-file listing output

Owner: repo maintainers
Created: 2026-09-14
Governing refs: contract 001, g03.012 safe transient deletion, g03.013 large Markdown scanning
Depends on: `g03.013` complete at `dcef5df`
UI classification: none

## Outcome

The closeout backlink guard scans repositories whose tracked-file listing is
larger than Node's default synchronous-process buffer while preserving a finite
listing bound and atomic handoff refusal.

## Ready-State Rubric

- [x] Bovine publishing reproduces the defect on a real held closeout.
- [x] The failure is isolated to the Northstar hook rather than Queue, Effigy,
  Git, or repository state.
- [x] The required bounded behavior and failure diagnostic are settled.
- [x] Scope and regression controls are explicit.
- [x] UI classification is `none`.

## Decisions

- Keep tracked-file discovery finite. Supply `git ls-files -z` an explicit,
  documented output cap above the proven 1,797,383-byte Bovine listing; do not
  replace it with an unbounded read.
- Preserve the existing 5,000 tracked-Markdown-file bound and g03.013's 4 MiB
  per-file bound. The listing cap is an earlier transport bound, not permission
  to scan more files or larger files.
- Treat process spawn errors, signals, null status, and non-zero exit as
  malfunctions before any lifecycle mutation. Include the bounded process error
  identity in the diagnostic instead of reporting empty stderr.
- Keep the hook repository-agnostic. Bovine is acceptance evidence only.
- After merge and installed-skill refresh, retry the exact retained Bovine
  closeout occurrence. No consumer edit or replacement task is required.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready; one Northstar core repair lane.
- **Owned mutable paths:** tracked-file backlink discovery and diagnostics under
  `skills/northstar/**`; focused lifecycle fixtures; matching reusable doctrine
  only where it describes the bounds; this task and the g03 task index.
- **Reserved closeout surfaces:** g03.014 lifecycle record, declared generated
  projections, and deletion of this submitted handoff belong to the repository
  hook.
- **Worker:** automatic general pool; independent exact-head review required.
- **Serial edges:** Bovine Queue task
  `9c2ca547-5156-4b72-860d-1cff4c4c764a` closeout retry waits for merge plus
  installed-skill refresh.
- **Excluded:** consumer repository edits, hook bypasses, path whitelists,
  unbounded reads, Queue/Effigy source, releases, and Paseo thread/workspace
  disposal.

## Work

1. Give tracked-file discovery a finite explicit output cap that admits the
   1,797,383-byte real listing without weakening later file-count or file-size
   checks.
2. Report `spawnSync` errors and abnormal termination with a stable bounded
   diagnostic.
3. Add a fixture whose NUL-delimited tracked-file listing exceeds 1 MiB and
   prove backlink scanning reaches the existing Markdown controls.
4. Retain controls for listing overflow, non-zero Git exit, the 5,000-file
   limit, the 4 MiB per-file limit, and exact-link atomic refusal.
5. Run lifecycle adoption/core checks, docs QA, full QA, installed-skill parity,
   and `git diff --check`.

## Acceptance and review oracle

- Bovine's 1,797,383-byte `git ls-files -z` result no longer terminates with
  `ENOBUFS`.
- A listing above the new finite cap fails before record, projection, or handoff
  bytes change.
- A Git discovery failure names the process error or exit evidence instead of
  producing `git ls-files failed:` with an empty suffix.
- Existing file-count, per-file size, link-resolution, and atomic-refusal tests
  remain green.

## Stop conditions

Stop if the repair requires an unbounded process buffer, skipping tracked
Markdown, weakening exact-link refusal, editing a consumer, bypassing the held
hook, or changing Queue/Effigy runtime behavior.

## Evidence

Bovine task `9c2ca547-5156-4b72-860d-1cff4c4c764a` is held at closeout hook
`413d2663-f871-4d3e-a870-06ca7f90eb96`. In its clean synchronized repository,
plain `git ls-files -z` succeeds with 1,797,383 output bytes. The hook's current
Node `spawnSync` call instead returns status `null`, signal `SIGTERM`, error code
`ENOBUFS`, 1,114,112 buffered stdout bytes, and empty stderr because it relies
on Node's default 1 MiB buffer.

## Next task

After merge and global skill refresh, retry the exact held Bovine hook. Then
return to Chatterbox; no successor is automatic.
