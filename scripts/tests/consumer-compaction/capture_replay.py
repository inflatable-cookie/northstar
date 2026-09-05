#!/usr/bin/env python3
"""Capture a recorded consumer-compaction replay from an agent workspace."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import sys
from datetime import datetime, timezone

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
FIXTURES = os.path.join(REPO, "scripts", "fixtures", "consumer-compaction")
EVIDENCE = os.path.join(HERE, "evidence")
PROCEDURE = os.path.join(
    REPO, "skills", "northstar", "references", "lifecycle-maintenance.md")


def digest_file(path):
    with open(path, "rb") as handle:
        return "sha256:" + hashlib.sha256(handle.read()).hexdigest()


SKIP_DIRS = {".git", ".effigy"}


def tree_manifest(root):
    files = {}
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [name for name in dirnames if name not in SKIP_DIRS]
        for name in filenames:
            full = os.path.join(dirpath, name)
            rel = os.path.relpath(full, root).replace(os.sep, "/")
            files[rel] = digest_file(full)
    return dict(sorted(files.items()))


def copy_tree(src, dest):
    if os.path.exists(dest):
        shutil.rmtree(dest)
    os.makedirs(dest)
    for dirpath, dirnames, filenames in os.walk(src):
        dirnames[:] = [name for name in dirnames if name not in SKIP_DIRS]
        rel_dir = os.path.relpath(dirpath, src)
        target_dir = dest if rel_dir == "." else os.path.join(dest, rel_dir)
        os.makedirs(target_dir, exist_ok=True)
        for name in filenames:
            shutil.copy2(os.path.join(dirpath, name), os.path.join(target_dir, name))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--scenario", required=True)
    parser.add_argument("--workspace", required=True)
    parser.add_argument("--agent-id", required=True)
    parser.add_argument("--route", required=True)
    parser.add_argument("--authorization", required=True)
    parser.add_argument("--before-fixture", default="")
    parser.add_argument("--before-root", default="")
    parser.add_argument("--skill-path", required=True)
    parser.add_argument("--prompt-file", required=True)
    parser.add_argument("--started-at", required=True)
    parser.add_argument("--finished-at", required=True)
    parser.add_argument("--provider", default="")
    parser.add_argument("--workspace-id", default="")
    parser.add_argument("--activity-note", default="")
    args = parser.parse_args()

    before_root = args.before_root or os.path.join(FIXTURES, args.before_fixture)
    if not args.before_fixture and not args.before_root:
        raise SystemExit("need --before-fixture or --before-root")
    if not os.path.isdir(before_root):
        raise SystemExit(f"missing before tree {before_root}")
    if not os.path.isdir(args.workspace):
        raise SystemExit(f"missing workspace {args.workspace}")

    dest = os.path.join(EVIDENCE, args.scenario)
    after_dest = os.path.join(dest, "after")
    os.makedirs(dest, exist_ok=True)
    copy_tree(args.workspace, after_dest)

    before_manifest = {"files": tree_manifest(before_root)}
    after_manifest = {"files": tree_manifest(after_dest)}
    with open(args.prompt_file, "rb") as handle:
        prompt_digest = "sha256:" + hashlib.sha256(handle.read()).hexdigest()

    provenance = {
        "scenario": args.scenario,
        "route": args.route,
        "authorization": args.authorization,
        "before_fixture": args.before_fixture or os.path.basename(os.path.abspath(before_root)),
        "agent_id": args.agent_id,
        "provider": args.provider,
        "workspace_id": args.workspace_id,
        "skill_path": os.path.abspath(args.skill_path),
        "skill_procedure_relative": "references/lifecycle-maintenance.md",
        "skill_procedure_sha256": digest_file(PROCEDURE),
        "prompt_sha256": prompt_digest,
        "started_at": args.started_at,
        "finished_at": args.finished_at,
        "activity_note": args.activity_note,
        "captured_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    }
    with open(os.path.join(dest, "before-manifest.json"), "w") as handle:
        json.dump(before_manifest, handle, indent=2, sort_keys=True)
        handle.write("\n")
    with open(os.path.join(dest, "after-manifest.json"), "w") as handle:
        json.dump(after_manifest, handle, indent=2, sort_keys=True)
        handle.write("\n")
    with open(os.path.join(dest, "provenance.json"), "w") as handle:
        json.dump(provenance, handle, indent=2, sort_keys=True)
        handle.write("\n")
    print(dest)


if __name__ == "__main__":
    main()
