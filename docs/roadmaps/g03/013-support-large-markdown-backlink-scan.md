# g03.013 — Support large Markdown backlink scanning

Owner: repo maintainers
Created: 2026-09-13
Governing refs: contract 001, g03.012 safe transient deletion
Depends on: `g03.012` complete at `a074c95`
UI classification: none

## Outcome

The closeout backlink guard safely scans normal large tracked Markdown files instead of refusing repositories with established changelogs or evidence ledgers. Traversal remains bounded and exact handoff links still block before mutation.

## Ready-State Rubric

- [x] Monkey reproduces the defect with a 531,294-byte `CHANGELOG.md` and a held g14.002 closeout.
- [x] Poodle has a 370,853-byte tracked evidence ledger and would hit the same guard.
- [x] Neither repository requires a local workaround; the bound belongs to Northstar.
- [x] Scope and regression controls are explicit.
- [x] UI classification is `none`.

## Decisions

- Raise the tracked Markdown per-file scan bound from 256 KiB to 4 MiB. The scanner reads one file at a time, so memory stays bounded by one accepted file plus the existing 5,000-file traversal cap.
- Files above 4 MiB still refuse before any byte change. Do not skip, truncate, or whitelist changelogs and evidence directories.
- A large file containing no exact handoff target passes. A large file containing an exact supported link blocks atomically.
- Preserve the fail-closed lexical link boundary from g03.012, including link-shaped examples.
- Consumer closeout retries wait for this source change to merge and the global Northstar installation to update.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready; one Northstar core repair lane.
- **Owned mutable paths:** backlink scan bound and comments under `skills/northstar/**`; lifecycle adoption fixtures; matching reusable doctrine only if it states the old numeric bound; this task and g03 task-file index.
- **Reserved closeout surfaces:** g03.013 lifecycle record, declared generated projections, and deletion of this submitted handoff belong to the repository hook.
- **Worker:** automatic general pool; independent exact-head review required.
- **Serial edges:** Monkey g14.002 and Poodle g18.035 closeout retries wait for merge plus installed-skill update.
- **Excluded:** consumer repository edits, hook bypasses, path whitelists, unbounded reads, Queue/Effigy source, releases, and Paseo thread/workspace disposal.

## Work

1. Raise the per-file Markdown backlink scan bound to 4 MiB without weakening exact-link resolution or atomic refusal.
2. Add a fixture above 256 KiB with no exact handoff link that scans successfully.
3. Add the same-sized fixture with an exact local handoff link and prove closeout refuses before record, projection, or handoff bytes change.
4. Retain an above-4-MiB refusal control and the existing file-count bound.
5. Run lifecycle adoption/core checks, docs QA, full QA, installed-skill parity, and `git diff --check`.

## Acceptance and review oracle

- A 531,294-byte clean Markdown file no longer blocks closeout solely for size.
- A large Markdown file containing the exact handoff target is detected and blocks atomically.
- A file above 4 MiB still refuses before mutation with a stable diagnostic.
- Existing relative, rooted, fragment, titled, reference, external, mismatch, conservative-code, and file-count controls remain green.
- Installed bundle parity, docs QA, full QA, and diff checks pass.

## Stop conditions

Stop if the repair requires skipping tracked Markdown, weakening exact-link refusal, reading files without a finite bound, editing consumers, bypassing the held hook, or changing Queue/Effigy runtime behavior.

## Evidence

Monkey g14.002 is held on hook event `1e778aa5-fd73-4822-849f-c762df1f7f8d`: `CHANGELOG.md` is 531,294 bytes and contains no repair-handoff reference. Poodle's tracked `docs/evidence/nucleus/parity-evidence-ledger.md` is 370,853 bytes. No other repository in the 25-project repair wave exceeds the old bound.

## Next task

After merge and global skill update, retry the exact held Monkey hook and any Poodle closeout held by the same bound. Then continue the portfolio repair wave.
