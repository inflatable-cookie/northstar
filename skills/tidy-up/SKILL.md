---
name: tidy-up
description: Clean up repository litter — merged or abandoned local and remote branches, worktrees, stashes, orphaned PRs, and stray scratch, summary or backup files — removing what is proven safe without touching work in flight. Use when asked to tidy, clean up or declutter repositories, prune branches, worktrees or PRs, or run scheduled hygiene.
---

# Tidy up

Parallel agents leave branches, worktrees, PRs and stray files behind. Clean on
evidence, never age or appearance: a wrong keep costs a glance, while a wrong
delete loses work that exists nowhere else. When evidence is missing, keep it.

Remove proven-safe items without asking; list the rest to pick by name, number
or explicit group. Unattended runs remove only proven-safe items. Code-level
rot (dead code, unused deps, duplicated helpers) is out of scope.

## 1. Inventory

Change nothing yet. If one repo fails to scan, note the error and continue.

- Fetch remotes with `--no-prune` so tracking refs survive forge auto-deletes,
  and resolve `<default>` to the fetched default branch (or local default when
  local-only).
- Inspect local branches with reflogs, live remote heads vs tracking refs,
  `archive/*` tags, stashes, worktrees, forge PRs and branch protection.
- Scan for untracked litter (including scratch folders) and tracked litter:
  summary, plan or report markdown outside `docs/`, backups (`*.bak`,
  `*.old.*`, `*_v2.*`, `* copy.*`), committed logs or outputs, and unreferenced
  scripts.
- Check live processes alongside recent commits, edits and active git
  operations — paused agents hold no process.
- Query the task system if present; having none is normal (note it), while an
  unreadable one makes liveness unknown.

## 2. Classify

Evaluate **Unknown** and **In flight** first, then **Proven safe**; everything
else goes to **Needs a name**. Never touch non-owned remotes like `upstream`.

### Unknown (keep and report)

Missing required evidence — such as an unreachable forge in a remote-backed
repo (blocking remote deletes, PR proofs, open-PR and protection checks) or an
unreadable task system.

### In flight (keep and don't touch)

- Main or current checkout, locked worktrees, and worktrees with a live
  process, active git operation (rebase, merge, cherry-pick, bisect) or live
  task.
- Active or recently touched dirty worktrees (uncommitted edits, untracked
  files or dirty submodules).
- Branches and worktrees created within ~24 hours with no merged work (only a
  creation reflog entry, no merged PR or merge commit), so fresh work isn't
  swept away before it starts.
- Current, `<default>`, protected or long-lived branches (`develop`, `staging`,
  `release/*`, forge-protected), plus any branch in an in-flight worktree, in a
  live task, with an active open PR (any author), or serving as an open PR's
  base.
- Open PRs with a live task, recent activity or active child PRs, and stashes
  tied to an in-flight branch or worktree.

### Proof that work is in `<default>`

Age, `[gone]` upstreams, similar names, matching PR titles, and `git branch -d`
succeeding are not proof (`git branch -d` accepts branches merged only into
their upstream). Only these three prove it:

- **Merged PR** (preferred for squash/rebase; required for live remote
  branches): merged into `<default>` (or a base proven merged into it), head
  SHA matching tip, head repo matching this remote.
- **No unique commits** (local branches and stale tracking refs):
  `git merge-base --is-ancestor <ref> <default>` succeeds. Deleting it loses no
  commits, so old merged branches with expired reflogs qualify once past the
  recency guard or backed by merged-work evidence.
- **Patch IDs** (local branches without a forge PR):
  `git cherry <default> <branch>` gives at least one `-` and no `+` line. For
  multi-commit squashes, test a temporary `git commit-tree` from the
  merge-base; if `<default>` later changed those lines, rely on a merged PR or
  **Needs a name**.

### Proven safe (remove without asking)

- Local branches proven in `<default>` with no open PR (even stale), not in a
  kept worktree, and no unmerged commits on a live remote counterpart.
- Owned-remote branches with a merged PR at tip, and stale tracking refs
  already deleted remotely whose tip is proven in `<default>`.
- Clean agent or harness worktrees whose branch is proven safe, and unlocked
  missing-directory worktree records.

### Needs a name (list and ask)

- Remaining local and owned-remote branches, plus unmerged stale tracking refs
  (possibly the last local copy).
- Stale open PRs (note author and age), stashes, stale `archive/*` tags,
  detached or human worktrees, idle dirty worktrees (with change summary), and
  agent worktrees on unmerged branches.
- Tracked and untracked litter (including stale scratch files — git holds no
  copy) and attributable idle scratch DBs or containers.

## 3. Remove

- Re-check each item right before deleting it, even if you gathered inventory
  in parallel.
- Remove worktrees before branches, one item per command, quoting refnames
  after `--` so one failure won't halt the rest or parse as a flag.
- Prune missing-directory worktrees with `git worktree prune` (never `--force`,
  which drops locked ones); use `git worktree remove --force` only on a named
  dirty worktree.
- Delete live remote branches atomically with
  `git push --force-with-lease="refs/heads/<branch>:<sha>" --delete "<remote>" "refs/heads/<branch>"`
  so late pushes abort and tags aren't hit.
- Use `git branch -D -- "<branch>"` only on proven-safe or named branches —
  never carry `-D` or `--force` into unproven loops. Drop proven-safe stale
  tracking refs with `git branch -dr`.
- Act on **Needs a name** only when picked by name, number or explicit group
  (e.g. "all closed-PR branches"). "OK" or "go ahead" selects nothing;
  untracked files need explicit selection, never a group.
- Before deleting a named unmerged branch, create local `archive/<branch>`
  (suffix date or short SHA if taken; never `-f` or push `archive/*`) and
  verify it resolves. Record every deleted tip SHA.
- Drop selected stashes highest index first, re-verifying each SHA as indices
  shift.
- Close selected PRs with a one-line reason; delete the branch only if also
  selected (archive-tagging if unmerged) or proven safe.
- Remove tracked litter via a commit or PR; move anything worth keeping into
  `docs/` with history and fix inbound links.
- Stop orphaned processes pointing at a deleted worktree; drop scratch DBs or
  containers only when named.

## 4. Prevent recurrence

Propose a gitignored scratch folder or worktree ignore rule if missing. When
the same litter recurs, name its source (instruction or tool default) rather
than only cleaning it again.

## Report

One report across all repos:

- repos scanned and skipped, with reasons;
- removals per repo, with deleted tip SHAs and `archive/*` tags;
- items awaiting a name, numbered continuously (naming the repo when scanning
  several);
- in-flight items kept, unknowns with reasons, and what couldn't be checked.
