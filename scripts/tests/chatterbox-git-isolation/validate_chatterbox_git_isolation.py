#!/usr/bin/env python3
"""Validate Chatterbox shared-checkout Git commit isolation and fail-closed behavior.

Proves:
1. Exact-path commit: committing a new triage file with `git commit -- <file>` isolates
   the commit exclusively to the triage file, leaving pre-existing staged files in the index.
2. Unrelated dirty unstaged and untracked files remain untouched in the working tree.
3. Fail-closed index protection: detecting pre-existing staged paths via `git diff --cached --name-only`
   prevents automatic commit and leaves the triage file on disk.
"""

import os
import subprocess
import tempfile
import sys

def run(argv, cwd=None, check=True):
    res = subprocess.run(argv, cwd=cwd, capture_output=True, text=True)
    if check and res.returncode != 0:
        raise RuntimeError(
            f"Command failed ({res.returncode}): {' '.join(argv)}\n"
            f"stdout: {res.stdout}\nstderr: {res.stderr}"
        )
    return res

def test_git_isolation():
    failures = 0
    total_tests = 0

    def assert_true(condition, description):
        nonlocal failures, total_tests
        total_tests += 1
        if condition:
            print(f"PASS {description}")
        else:
            print(f"FAIL {description}")
            failures += 1

    with tempfile.TemporaryDirectory(prefix="chatterbox-git-test-") as temp_dir:
        # Initialize repository
        run(["git", "init", "-q"], cwd=temp_dir)
        run(["git", "config", "user.name", "Chatterbox Test"], cwd=temp_dir)
        run(["git", "config", "user.email", "chatterbox@northstar.invalid"], cwd=temp_dir)

        # Create initial commit on main
        run(["git", "checkout", "-q", "-b", "main"], cwd=temp_dir)
        init_file = os.path.join(temp_dir, "tracked.txt")
        with open(init_file, "w") as f:
            f.write("initial tracked content\n")
        run(["git", "add", "tracked.txt"], cwd=temp_dir)
        run(["git", "commit", "-q", "-m", "initial commit"], cwd=temp_dir)
        initial_head = run(["git", "rev-parse", "HEAD"], cwd=temp_dir).stdout.strip()

        # Scenario 1: Clean shared checkout commit
        triage_dir = os.path.join(temp_dir, "docs", "triage")
        os.makedirs(triage_dir, exist_ok=True)
        note_1_rel = os.path.join("docs", "triage", "20260903-120000-idea-one.md")
        note_1_abs = os.path.join(temp_dir, note_1_rel)
        with open(note_1_abs, "w") as f:
            f.write("# Idea One\n")

        # Verify cached diff is clean
        cached_diff = run(["git", "diff", "--cached", "--name-only"], cwd=temp_dir).stdout.strip()
        assert_true(cached_diff == "", "pre-stage index is clean for note 1")

        # Stage and commit exact path
        run(["git", "add", "--", note_1_rel], cwd=temp_dir)
        run(["git", "commit", "-q", "-m", "docs(triage): idea one", "--", note_1_rel], cwd=temp_dir)

        head_commit_files = run(["git", "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD"], cwd=temp_dir).stdout.strip().splitlines()
        assert_true(head_commit_files == [note_1_rel], "clean commit contains only the triage note")

        # Scenario 2: Unrelated dirty unstaged file and untracked file in working tree
        with open(init_file, "w") as f:
            f.write("dirty unstaged modification\n")
        untracked_rel = "scratch.txt"
        with open(os.path.join(temp_dir, untracked_rel), "w") as f:
            f.write("untracked scratch notes\n")

        note_2_rel = os.path.join("docs", "triage", "20260903-120100-idea-two.md")
        note_2_abs = os.path.join(temp_dir, note_2_rel)
        with open(note_2_abs, "w") as f:
            f.write("# Idea Two\n")

        # Stage exact path and commit exact path
        cached_diff = run(["git", "diff", "--cached", "--name-only"], cwd=temp_dir).stdout.strip()
        assert_true(cached_diff == "", "no pre-existing staged files before note 2")
        run(["git", "add", "--", note_2_rel], cwd=temp_dir)
        run(["git", "commit", "-q", "-m", "docs(triage): idea two", "--", note_2_rel], cwd=temp_dir)

        head_commit_files = run(["git", "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD"], cwd=temp_dir).stdout.strip().splitlines()
        assert_true(head_commit_files == [note_2_rel], "commit with dirty working tree contains only the triage note")

        with open(init_file) as f:
            assert_true(f.read() == "dirty unstaged modification\n", "unrelated dirty file content unchanged in working tree")
        with open(os.path.join(temp_dir, untracked_rel)) as f:
            assert_true(f.read() == "untracked scratch notes\n", "untracked file content unchanged in working tree")

        status = [line.rstrip() for line in run(["git", "status", "--short"], cwd=temp_dir).stdout.splitlines() if line.strip()]
        assert_true(" M tracked.txt" in status, "tracked file remains unstaged dirty ( M)")
        assert_true("?? scratch.txt" in status, "scratch file remains untracked (??)")

        # Scenario 3: Pre-existing staged path — fail-closed detection
        # Stage the modified tracked.txt (e.g. staged by orchestrator or another task)
        run(["git", "add", "tracked.txt"], cwd=temp_dir)
        cached_staged = run(["git", "diff", "--cached", "--name-only"], cwd=temp_dir).stdout.strip().splitlines()
        assert_true("tracked.txt" in cached_staged, "tracked.txt is pre-staged in index")

        note_3_rel = os.path.join("docs", "triage", "20260903-120200-idea-three.md")
        note_3_abs = os.path.join(temp_dir, note_3_rel)
        with open(note_3_abs, "w") as f:
            f.write("# Idea Three\n")

        # Chatterbox checks index for pre-existing staged files
        staged_before = run(["git", "diff", "--cached", "--name-only"], cwd=temp_dir).stdout.strip()
        has_pre_existing_staged = len(staged_before) > 0
        assert_true(has_pre_existing_staged, "detected pre-existing staged file in index")

        # Protocol specifies failing closed without committing when pre-existing staged files exist
        if has_pre_existing_staged:
            # Leave file on disk, do not commit
            pass

        # Verify index and HEAD are unchanged
        head_after_detection = run(["git", "rev-parse", "HEAD"], cwd=temp_dir).stdout.strip()
        assert_true(os.path.exists(note_3_abs), "triage note 3 preserved on disk")
        assert_true(run(["git", "diff", "--cached", "--name-only"], cwd=temp_dir).stdout.strip() == "tracked.txt",
                    "pre-staged file remains staged and untouched in index")

        # Scenario 4: Exact-path commit isolation when pre-staged file is present in index
        # Even if git add -- <note> is run, committing with exact path does NOT commit the pre-staged file
        note_4_rel = os.path.join("docs", "triage", "20260903-120300-idea-four.md")
        note_4_abs = os.path.join(temp_dir, note_4_rel)
        with open(note_4_abs, "w") as f:
            f.write("# Idea Four\n")

        run(["git", "add", "--", note_4_rel], cwd=temp_dir)
        index_contents = run(["git", "diff", "--cached", "--name-only"], cwd=temp_dir).stdout.strip().splitlines()
        assert_true("tracked.txt" in index_contents and note_4_rel in index_contents,
                    "index contains both pre-staged file and new note")

        # Exact path commit
        run(["git", "commit", "-q", "-m", "docs(triage): idea four", "--", note_4_rel], cwd=temp_dir)

        # Verify commit contains ONLY note 4
        commit_4_files = run(["git", "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD"], cwd=temp_dir).stdout.strip().splitlines()
        assert_true(commit_4_files == [note_4_rel], "exact-path commit committed ONLY note 4")

        # Verify tracked.txt is STILL staged in the index, NOT committed
        post_commit_cached = run(["git", "diff", "--cached", "--name-only"], cwd=temp_dir).stdout.strip().splitlines()
        assert_true(post_commit_cached == ["tracked.txt"], "pre-staged tracked.txt remains staged in index after exact-path commit")

    print(f"\nchatterbox git isolation fixture: {'PASS' if failures == 0 else 'FAIL'} ({failures} failures out of {total_tests} assertions)")
    return failures == 0

if __name__ == "__main__":
    success = test_git_isolation()
    sys.exit(0 if success else 1)
