#!/usr/bin/env python3
"""Validate post-merge local integration reconciliation and fail-closed behavior.

Proves:
1. Happy path: provider merge -> remote fetch -> local main fast-forward ->
   exact local/remote-head verification occurs before closeout and next dispatch.
2. Provider-merge unverified: fails closed before fetch, emits blocker, blocks dispatch.
3. Fetch failure: fails closed, preserves local state untouched, emits blocker, blocks dispatch.
4. Dirty checkout: fails closed, preserves all dirty working-tree and staged changes
   completely untouched (no reset, stash, rebase, or discard), emits blocker, blocks dispatch.
5. Wrong branch: fails closed without switching branch, emits blocker, blocks dispatch.
6. Divergent local main: fails closed without rebase, reset, or force-merge, preserves
   unpushed commits, emits blocker, blocks dispatch.
7. Head mismatch: fails closed when local and remote heads do not match exactly, emits blocker.
8. Stale-head dispatch prevention: proves that any coordinator action chain strictly
   blocks closeout and downstream worker dispatch if reconciliation has not succeeded
   at the exact current synchronized remote head.
"""

import os
import subprocess
import sys
import tempfile


def run(argv, cwd=None, check=True):
    res = subprocess.run(argv, cwd=cwd, capture_output=True, text=True)
    if check and res.returncode != 0:
        raise RuntimeError(
            f"Command failed ({res.returncode}): {' '.join(argv)}\n"
            f"stdout: {res.stdout}\nstderr: {res.stderr}"
        )
    return res


def reconcile_post_merge(local_repo, remote_name="origin", branch="main", provider_merge_verified=True, simulated_mismatch=False):
    """Execute mandatory post-merge local integration reconciliation.

    Returns:
        dict: {
            "success": bool,
            "synchronized_head": str,
            "blocker_capsule": dict or None,
            "error_reason": str or None,
        }
    """
    # 1. Verify provider merge
    if not provider_merge_verified:
        return {
            "success": False,
            "synchronized_head": None,
            "error_reason": "provider-merge-unverified",
            "blocker_capsule": {
                "type": "reconciliation-blocker",
                "reason": "provider-merge-unverified",
                "detail": "Provider reports PR is not merged or merge state unverified",
            },
        }

    # 2. Fetch integration remote (safe fetch only)
    fetch_res = run(["git", "fetch", remote_name, branch], cwd=local_repo, check=False)
    if fetch_res.returncode != 0:
        return {
            "success": False,
            "synchronized_head": None,
            "error_reason": "fetch-failure",
            "blocker_capsule": {
                "type": "reconciliation-blocker",
                "reason": "fetch-failure",
                "detail": f"Failed to fetch {remote_name}/{branch}: {fetch_res.stderr.strip()}",
            },
        }

    remote_ref = f"{remote_name}/{branch}"
    remote_head = run(["git", "rev-parse", remote_ref], cwd=local_repo).stdout.strip()

    # 3. Fail closed if not on main
    branch_res = run(["git", "symbolic-ref", "--short", "HEAD"], cwd=local_repo, check=False)
    current_branch = branch_res.stdout.strip() if branch_res.returncode == 0 else ""
    if current_branch != branch:
        return {
            "success": False,
            "synchronized_head": None,
            "error_reason": "wrong-branch",
            "blocker_capsule": {
                "type": "reconciliation-blocker",
                "reason": "wrong-branch",
                "detail": f"Integration checkout is on branch '{current_branch}', expected '{branch}'",
                "current_branch": current_branch,
            },
        }

    # 4. Fail closed on dirty working tree or staged index
    status = run(["git", "status", "--porcelain"], cwd=local_repo).stdout.strip()
    if status != "":
        return {
            "success": False,
            "synchronized_head": None,
            "error_reason": "dirty-checkout",
            "blocker_capsule": {
                "type": "reconciliation-blocker",
                "reason": "dirty-checkout",
                "detail": "Local integration checkout has uncommitted or staged changes",
                "status": status.splitlines(),
            },
        }

    # 5. Fail closed if local is divergent (cannot fast-forward)
    local_head_before = run(["git", "rev-parse", "HEAD"], cwd=local_repo).stdout.strip()
    is_ancestor = run(["git", "merge-base", "--is-ancestor", local_head_before, remote_ref], cwd=local_repo, check=False)
    if is_ancestor.returncode != 0:
        return {
            "success": False,
            "synchronized_head": None,
            "error_reason": "divergent",
            "blocker_capsule": {
                "type": "reconciliation-blocker",
                "reason": "divergent",
                "detail": f"Local checkout has diverged from {remote_ref}; cannot fast-forward",
                "local_head": local_head_before,
                "remote_head": remote_head,
            },
        }

    # 6. Fast-forward local checkout to remote
    ff_res = run(["git", "merge", "--ff-only", remote_ref], cwd=local_repo, check=False)
    if ff_res.returncode != 0:
        return {
            "success": False,
            "synchronized_head": None,
            "error_reason": "fast-forward-failed",
            "blocker_capsule": {
                "type": "reconciliation-blocker",
                "reason": "fast-forward-failed",
                "detail": ff_res.stderr.strip(),
            },
        }

    # 7. Assert exact local and remote head equality
    local_head_after = run(["git", "rev-parse", "HEAD"], cwd=local_repo).stdout.strip()
    if simulated_mismatch:
        local_head_after = "mismatched_0000000000000000000000000000000000000000"

    if local_head_after != remote_head:
        return {
            "success": False,
            "synchronized_head": None,
            "error_reason": "head-mismatch",
            "blocker_capsule": {
                "type": "reconciliation-blocker",
                "reason": "head-mismatch",
                "detail": f"Local head ({local_head_after}) does not match {remote_ref} ({remote_head})",
                "local_head": local_head_after,
                "remote_head": remote_head,
            },
        }

    return {
        "success": True,
        "synchronized_head": local_head_after,
        "error_reason": None,
        "blocker_capsule": None,
    }


def coordinator_dispatch_gate(reconciliation_result, requested_base_sha):
    """Enforce the mandatory coordinator dispatch gate.

    Closeout and subsequent worker dispatch are strictly prohibited unless
    reconciliation succeeded and the dispatch base matches the synchronized head.
    """
    if not reconciliation_result.get("success"):
        raise PermissionError(
            f"Coordinator gate blocked: reconciliation failed ({reconciliation_result.get('error_reason')}). "
            f"Stale-head dispatch is strictly forbidden."
        )
    sync_head = reconciliation_result.get("synchronized_head")
    if requested_base_sha != sync_head:
        raise ValueError(
            f"Coordinator gate blocked: requested dispatch base {requested_base_sha} does not "
            f"match synchronized integration head {sync_head}."
        )
    return {
        "status": "ready-for-dispatch",
        "dispatch_base": sync_head,
    }


def test_post_merge_reconciliation():
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

    with tempfile.TemporaryDirectory(prefix="northstar-post-merge-test-") as temp_dir:
        # 1. Setup bare origin repo
        bare_origin = os.path.join(temp_dir, "origin.git")
        run(["git", "init", "--bare", "-q", bare_origin])
        run(["git", "symbolic-ref", "HEAD", "refs/heads/main"], cwd=bare_origin)

        # 2. Setup initial seed repo to push initial main
        seed_dir = os.path.join(temp_dir, "seed")
        run(["git", "init", "-q", seed_dir])
        run(["git", "config", "user.name", "Seed Author"], cwd=seed_dir)
        run(["git", "config", "user.email", "seed@northstar.invalid"], cwd=seed_dir)
        run(["git", "checkout", "-q", "-b", "main"], cwd=seed_dir)

        initial_file = os.path.join(seed_dir, "README.md")
        with open(initial_file, "w") as f:
            f.write("# Project Main\nInitial content\n")
        run(["git", "add", "README.md"], cwd=seed_dir)
        run(["git", "commit", "-q", "-m", "initial main commit"], cwd=seed_dir)
        initial_sha = run(["git", "rev-parse", "HEAD"], cwd=seed_dir).stdout.strip()

        run(["git", "remote", "add", "origin", bare_origin], cwd=seed_dir)
        run(["git", "push", "-q", "origin", "main"], cwd=seed_dir)

        # 3. Setup local integration checkout
        local_dir = os.path.join(temp_dir, "local-main")
        run(["git", "clone", "-q", bare_origin, local_dir])
        run(["git", "config", "user.name", "Local Coordinator"], cwd=local_dir)
        run(["git", "config", "user.email", "coordinator@northstar.invalid"], cwd=local_dir)

        # Helper to simulate a PR merge on origin via seed
        def simulate_remote_pr_merge(commit_msg, file_content):
            with open(initial_file, "a") as f:
                f.write(file_content + "\n")
            run(["git", "commit", "-q", "-am", commit_msg], cwd=seed_dir)
            run(["git", "push", "-q", "origin", "main"], cwd=seed_dir)
            return run(["git", "rev-parse", "HEAD"], cwd=seed_dir).stdout.strip()

        # ====================================================================
        # Scenario 1: Happy Path
        # ====================================================================
        merged_sha_1 = simulate_remote_pr_merge("feat: card 101 landed", "Card 101 features")

        # Local is clean and at initial_sha
        assert_true(run(["git", "rev-parse", "HEAD"], cwd=local_dir).stdout.strip() == initial_sha,
                    "Scenario 1: local head is behind remote before reconciliation")

        res_1 = reconcile_post_merge(local_dir, provider_merge_verified=True)
        assert_true(res_1["success"], "Scenario 1: happy path reconciliation succeeds")
        assert_true(res_1["synchronized_head"] == merged_sha_1, "Scenario 1: synchronized head matches remote merged head")

        local_head_after_1 = run(["git", "rev-parse", "HEAD"], cwd=local_dir).stdout.strip()
        assert_true(local_head_after_1 == merged_sha_1, "Scenario 1: local checkout fast-forwarded to exact remote head")
        assert_true(run(["git", "status", "--porcelain"], cwd=local_dir).stdout.strip() == "",
                    "Scenario 1: local checkout remains clean after fast-forward")

        # Coordinator gate permits closeout and dispatch at synchronized head
        gate_res_1 = coordinator_dispatch_gate(res_1, requested_base_sha=merged_sha_1)
        assert_true(gate_res_1["status"] == "ready-for-dispatch", "Scenario 1: dispatch gate opens on synchronized head")

        # ====================================================================
        # Scenario 2: Provider Merge Unverified
        # ====================================================================
        res_2 = reconcile_post_merge(local_dir, provider_merge_verified=False)
        assert_true(not res_2["success"], "Scenario 2: fails closed when provider merge is unverified")
        assert_true(res_2["error_reason"] == "provider-merge-unverified", "Scenario 2: error reason is provider-merge-unverified")
        assert_true(res_2["blocker_capsule"]["type"] == "reconciliation-blocker", "Scenario 2: emits reconciliation blocker capsule")

        # Stale dispatch is blocked
        try:
            coordinator_dispatch_gate(res_2, requested_base_sha=local_head_after_1)
            assert_true(False, "Scenario 2: stale dispatch must be blocked")
        except PermissionError as e:
            assert_true("Coordinator gate blocked" in str(e), "Scenario 2: coordinator gate blocks stale dispatch")

        # ====================================================================
        # Scenario 3: Fetch Failure
        # ====================================================================
        res_3 = reconcile_post_merge(local_dir, remote_name="nonexistent_remote", provider_merge_verified=True)
        assert_true(not res_3["success"], "Scenario 3: fails closed on fetch failure")
        assert_true(res_3["error_reason"] == "fetch-failure", "Scenario 3: error reason is fetch-failure")
        assert_true(run(["git", "rev-parse", "HEAD"], cwd=local_dir).stdout.strip() == local_head_after_1,
                    "Scenario 3: local checkout preserved untouched after fetch failure")

        try:
            coordinator_dispatch_gate(res_3, requested_base_sha=local_head_after_1)
            assert_true(False, "Scenario 3: stale dispatch must be blocked on fetch failure")
        except PermissionError:
            assert_true(True, "Scenario 3: coordinator gate blocks dispatch on fetch failure")

        # ====================================================================
        # Scenario 4: Dirty Checkout (fail-closed, untouched working tree)
        # ====================================================================
        merged_sha_2 = simulate_remote_pr_merge("feat: card 102 landed", "Card 102 features")

        # Create both unstaged modification and staged new file
        dirty_tracked = os.path.join(local_dir, "README.md")
        with open(dirty_tracked, "a") as f:
            f.write("uncommitted local modification\n")

        dirty_staged = os.path.join(local_dir, "staged_draft.txt")
        with open(dirty_staged, "w") as f:
            f.write("pre-existing staged file\n")
        run(["git", "add", "staged_draft.txt"], cwd=local_dir)

        status_before_reconcile = run(["git", "status", "--porcelain"], cwd=local_dir).stdout.strip()
        assert_true("M README.md" in status_before_reconcile and "A  staged_draft.txt" in status_before_reconcile,
                    "Scenario 4: working tree has dirty modifications before reconciliation")

        res_4 = reconcile_post_merge(local_dir, provider_merge_verified=True)
        assert_true(not res_4["success"], "Scenario 4: fails closed on dirty checkout")
        assert_true(res_4["error_reason"] == "dirty-checkout", "Scenario 4: error reason is dirty-checkout")

        # CRITICAL INVARIANT: Working tree and index must NOT be mutated (no reset, stash, or discard)
        status_after_reconcile = run(["git", "status", "--porcelain"], cwd=local_dir).stdout.strip()
        assert_true(status_after_reconcile == status_before_reconcile,
                    "Scenario 4: dirty working-tree and staged changes remain 100% untouched")
        assert_true(run(["git", "rev-parse", "HEAD"], cwd=local_dir).stdout.strip() == local_head_after_1,
                    "Scenario 4: local HEAD was NOT advanced past dirty state")

        try:
            coordinator_dispatch_gate(res_4, requested_base_sha=local_head_after_1)
            assert_true(False, "Scenario 4: stale dispatch must be blocked on dirty checkout")
        except PermissionError:
            assert_true(True, "Scenario 4: coordinator gate blocks dispatch on dirty checkout")

        # Clean up dirty files for subsequent scenarios
        run(["git", "reset", "--hard", "HEAD"], cwd=local_dir)
        run(["git", "clean", "-fd"], cwd=local_dir)

        # ====================================================================
        # Scenario 5: Wrong Branch
        # ====================================================================
        run(["git", "checkout", "-q", "-b", "worker/card-103-lane"], cwd=local_dir)
        res_5 = reconcile_post_merge(local_dir, provider_merge_verified=True)
        assert_true(not res_5["success"], "Scenario 5: fails closed on wrong branch")
        assert_true(res_5["error_reason"] == "wrong-branch", "Scenario 5: error reason is wrong-branch")

        # Branch was NOT forcibly switched
        current_branch_5 = run(["git", "symbolic-ref", "--short", "HEAD"], cwd=local_dir).stdout.strip()
        assert_true(current_branch_5 == "worker/card-103-lane", "Scenario 5: checkout remains on worker branch without forced switch")

        try:
            coordinator_dispatch_gate(res_5, requested_base_sha=local_head_after_1)
            assert_true(False, "Scenario 5: stale dispatch must be blocked on wrong branch")
        except PermissionError:
            assert_true(True, "Scenario 5: coordinator gate blocks dispatch on wrong branch")

        # Switch back to main for remaining scenarios
        run(["git", "checkout", "-q", "main"], cwd=local_dir)

        # ====================================================================
        # Scenario 6: Divergent Branch (cannot fast-forward)
        # ====================================================================
        # Commit an unpushed change locally on main to create divergent history
        divergent_file = os.path.join(local_dir, "divergent.txt")
        with open(divergent_file, "w") as f:
            f.write("local divergent commit on main\n")
        run(["git", "add", "divergent.txt"], cwd=local_dir)
        run(["git", "commit", "-q", "-m", "chore: local divergent work"], cwd=local_dir)
        divergent_local_sha = run(["git", "rev-parse", "HEAD"], cwd=local_dir).stdout.strip()

        res_6 = reconcile_post_merge(local_dir, provider_merge_verified=True)
        assert_true(not res_6["success"], "Scenario 6: fails closed on divergent branch")
        assert_true(res_6["error_reason"] == "divergent", "Scenario 6: error reason is divergent")

        # Unpushed local commit is NOT discarded, reset, or rebased
        assert_true(run(["git", "rev-parse", "HEAD"], cwd=local_dir).stdout.strip() == divergent_local_sha,
                    "Scenario 6: unpushed local commit is preserved untouched (no rebase or reset)")

        try:
            coordinator_dispatch_gate(res_6, requested_base_sha=divergent_local_sha)
            assert_true(False, "Scenario 6: stale dispatch must be blocked on divergent branch")
        except PermissionError:
            assert_true(True, "Scenario 6: coordinator gate blocks dispatch on divergent branch")

        # Reset back to local_head_after_1 for Scenario 7
        run(["git", "reset", "--hard", local_head_after_1], cwd=local_dir)

        # ====================================================================
        # Scenario 7: Head Mismatch (post-ff equality check failure)
        # ====================================================================
        res_7 = reconcile_post_merge(local_dir, provider_merge_verified=True, simulated_mismatch=True)
        assert_true(not res_7["success"], "Scenario 7: fails closed on simulated head mismatch")
        assert_true(res_7["error_reason"] == "head-mismatch", "Scenario 7: error reason is head-mismatch")

        try:
            coordinator_dispatch_gate(res_7, requested_base_sha=local_head_after_1)
            assert_true(False, "Scenario 7: stale dispatch must be blocked on head mismatch")
        except PermissionError:
            assert_true(True, "Scenario 7: coordinator gate blocks dispatch on head mismatch")

        # ====================================================================
        # Scenario 8: Stale-Head Dispatch Prevention Invariant
        # ====================================================================
        # Reconcile successfully to merged_sha_2
        res_8 = reconcile_post_merge(local_dir, provider_merge_verified=True)
        assert_true(res_8["success"], "Scenario 8: reconciliation succeeds to latest merged head")
        assert_true(res_8["synchronized_head"] == merged_sha_2, "Scenario 8: synchronized head is merged_sha_2")

        # Attempting dispatch with the old stale SHA (merged_sha_1) MUST be rejected even though res_8 is success
        try:
            coordinator_dispatch_gate(res_8, requested_base_sha=merged_sha_1)
            assert_true(False, "Scenario 8: dispatch with stale base SHA must be rejected")
        except ValueError as e:
            assert_true("does not match synchronized integration head" in str(e),
                        "Scenario 8: dispatch gate rejects stale base SHA against synchronized head")

        # Dispatch with the true synchronized SHA succeeds
        gate_res_8 = coordinator_dispatch_gate(res_8, requested_base_sha=merged_sha_2)
        assert_true(gate_res_8["status"] == "ready-for-dispatch", "Scenario 8: dispatch permitted with exact synchronized head")

    print(f"\nPost-merge reconciliation behavioral test results: {total_tests - failures}/{total_tests} passed")
    if failures > 0:
        print(f"FAILED: {failures} assertions failed")
        sys.exit(1)
    else:
        print("All post-merge reconciliation behavioral assertions PASSED.")


if __name__ == "__main__":
    test_post_merge_reconciliation()
