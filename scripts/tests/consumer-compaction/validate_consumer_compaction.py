#!/usr/bin/env python3
"""Inspect recorded consumer-compaction replay artifacts.

Independent structural assertions over actual before/after trees and retained
replay provenance. Does not treat a handcrafted expected tree as proof that the
installed route ran, and does not re-execute the agent.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
FIXTURES = os.path.join(REPO, "scripts", "fixtures", "consumer-compaction")
EVIDENCE = os.path.join(HERE, "evidence")
PROCEDURE = os.path.join(
    REPO, "skills", "northstar", "references", "lifecycle-maintenance.md")

FAILURES = 0
CHECKS = 0


def ok(condition, label, detail=""):
    global FAILURES, CHECKS
    CHECKS += 1
    if condition:
        print(f"PASS {label}")
    else:
        FAILURES += 1
        print(f"FAIL {label}" + (f": {detail}" if detail else ""))


def digest_bytes(data):
    return "sha256:" + hashlib.sha256(data).hexdigest()


def file_digest(path):
    with open(path, "rb") as handle:
        return digest_bytes(handle.read())


def read_text(path):
    with open(path, encoding="utf-8") as handle:
        return handle.read()


def tree_manifest(root):
    files = {}
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [name for name in dirnames if name not in (".git", ".effigy")]
        for name in filenames:
            full = os.path.join(dirpath, name)
            rel = os.path.relpath(full, root)
            files[rel.replace(os.sep, "/")] = file_digest(full)
    return files


def load_json(path):
    with open(path, encoding="utf-8") as handle:
        return json.load(handle)


def evidence_dir(scenario):
    return os.path.join(EVIDENCE, scenario)


def require_evidence(scenario):
    root = evidence_dir(scenario)
    after = os.path.join(root, "after")
    provenance_path = os.path.join(root, "provenance.json")
    before_manifest_path = os.path.join(root, "before-manifest.json")
    after_manifest_path = os.path.join(root, "after-manifest.json")
    ok(os.path.isdir(after), f"{scenario} after tree exists", after)
    ok(os.path.isfile(provenance_path), f"{scenario} provenance exists")
    ok(os.path.isfile(before_manifest_path), f"{scenario} before manifest exists")
    ok(os.path.isfile(after_manifest_path), f"{scenario} after manifest exists")
    if not os.path.isdir(after) or not os.path.isfile(provenance_path):
        return None
    return {
        "root": root,
        "after": after,
        "provenance": load_json(provenance_path),
        "before_manifest": load_json(before_manifest_path),
        "after_manifest": load_json(after_manifest_path),
        "after_files": tree_manifest(after),
    }


def procedure_digest():
    return file_digest(PROCEDURE)


def check_provenance(scenario, payload, expected_route, expected_auth, before_files=None):
    prov = payload["provenance"]
    ok(prov.get("scenario") == scenario, f"{scenario} provenance scenario")
    ok(prov.get("route") == expected_route, f"{scenario} provenance route",
       str(prov.get("route")))
    ok(prov.get("authorization") == expected_auth,
       f"{scenario} provenance authorization", str(prov.get("authorization")))
    ok(bool(prov.get("agent_id")), f"{scenario} records agent id")
    ok(bool(prov.get("skill_path")), f"{scenario} records skill path")
    ok(os.path.isdir(prov.get("skill_path", "")),
       f"{scenario} skill path exists", str(prov.get("skill_path")))
    ok(prov.get("skill_procedure_relative") ==
       "references/lifecycle-maintenance.md",
       f"{scenario} names installed procedure")
    ok(prov.get("skill_procedure_sha256") == procedure_digest(),
       f"{scenario} procedure digest matches committed skill",
       str(prov.get("skill_procedure_sha256")))
    ok(bool(prov.get("prompt_sha256")), f"{scenario} records prompt digest")
    ok(bool(prov.get("started_at")) and bool(prov.get("finished_at")),
       f"{scenario} records replay times")
    after_files = payload["after_files"]
    recorded_after = payload["after_manifest"].get("files", {})
    ok(after_files == recorded_after,
       f"{scenario} after manifest matches after tree")
    if before_files is None:
        before_files = tree_manifest(os.path.join(FIXTURES, prov["before_fixture"]))
    recorded_before = payload["before_manifest"].get("files", {})
    ok(before_files == recorded_before,
       f"{scenario} before manifest matches source tree")


def has_active_status(text):
    return bool(re.search(
        r"(?m)^Status:\s*(?:active|ready|in-flight)\b", text))


def has_procedure_heading(text):
    return bool(re.search(
        r"(?m)^##\s*(?:Steps|Execution Plan|Acceptance Criteria)\b", text))


def has_autostart(text):
    return bool(re.search(r"(?m)^Auto-start next card:\s*yes\b", text))


def front_door_texts(after_root):
    paths = [
        "docs/README.md",
        "docs/roadmaps/README.md",
        "docs/roadmaps/generation-index.md",
        "docs/logs/README.md",
    ]
    texts = {}
    for rel in paths:
        full = os.path.join(after_root, rel)
        if os.path.isfile(full):
            texts[rel] = read_text(full)
    return texts


def check_happy(payload):
    after = payload["after"]
    ok(not os.path.isdir(os.path.join(after, "docs/roadmaps/g01")),
       "happy removed expanded g01")
    ok(not os.path.isdir(os.path.join(after, "docs/roadmaps/g02")),
       "happy removed expanded g02")
    ok(os.path.isdir(os.path.join(after, "docs/roadmaps/g03")),
       "happy preserved expanded g03")
    g01_roll = os.path.join(after, "docs/roadmaps/archive/g01.md")
    g02_roll = os.path.join(after, "docs/roadmaps/archive/g02.md")
    ok(os.path.isfile(g01_roll), "happy created g01 roll-up")
    ok(os.path.isfile(g02_roll), "happy created g02 roll-up")
    if not (os.path.isfile(g01_roll) and os.path.isfile(g02_roll)):
        return
    g01_text = read_text(g01_roll)
    g02_text = read_text(g02_roll)
    ok("EVIDENCE-PR-101" in g01_text and "c0ffee101" in g01_text,
       "happy retained g01 PR/commit evidence")
    ok("EVIDENCE-PR-202" in g02_text and "c0ffee202" in g02_text,
       "happy retained g02 PR/commit evidence")
    ok("PROCEDURAL-STEP-DO-NOT-COPY" not in g01_text,
       "happy g01 roll-up has no copied procedure token")
    ok("PROCEDURAL-STEP-DO-NOT-COPY" not in g02_text,
       "happy g02 roll-up has no copied procedure token")
    ok(not has_active_status(g01_text) and not has_procedure_heading(g01_text)
       and not has_autostart(g01_text),
       "happy g01 roll-up is non-procedural")
    ok(not has_active_status(g02_text) and not has_procedure_heading(g02_text)
       and not has_autostart(g02_text),
       "happy g02 roll-up is non-procedural")
    ok("Status: archived" in g01_text or "Kind: roll-up" in g01_text,
       "happy g01 roll-up declares non-authority")
    ok("Status: archived" in g02_text or "Kind: roll-up" in g02_text,
       "happy g02 roll-up declares non-authority")
    contracts = read_text(os.path.join(after, "docs/contracts/001-working-rules.md"))
    ok("UNIQUE-RULE-WIDGET-PREFIX" in contracts,
       "happy promoted unique durable rule")
    g03_readme = read_text(os.path.join(after, "docs/roadmaps/g03/README.md"))
    ok("DEFERRED-COMMITMENT-WIDGET-AUDIT" in g03_readme,
       "happy rehomed deferred commitment")
    active_card = read_text(
        os.path.join(after, "docs/roadmaps/g03/001-active-lane.md"))
    ok("ACTIVE-GEN-ONLY-TOKEN" in active_card,
       "happy preserved active generation token")
    for rel, text in front_door_texts(after).items():
        ok("g01/" not in text, f"happy front door {rel} dropped g01/ links")
        ok("g02/" not in text, f"happy front door {rel} dropped g02/ links")
    deleted = sorted(
        path for path in payload["before_manifest"]["files"]
        if path not in payload["after_manifest"]["files"])
    ok(all(path.startswith("docs/roadmaps/g01/")
           or path.startswith("docs/roadmaps/g02/")
           for path in deleted),
       "happy deleted only classified closed-generation sources",
       ", ".join(deleted))


def check_readonly(payload):
    ok(payload["before_manifest"]["files"] == payload["after_manifest"]["files"],
       "readonly cleanup mutated no files")
    after = payload["after"]
    ok(os.path.isdir(os.path.join(after, "docs/roadmaps/g01")),
       "readonly left g01 expanded")
    ok(os.path.isdir(os.path.join(after, "docs/roadmaps/g02")),
       "readonly left g02 expanded")
    ok(not os.path.isfile(os.path.join(after, "docs/roadmaps/archive/g01.md")),
       "readonly did not create g01 roll-up")
    ok(not os.path.isfile(os.path.join(after, "docs/roadmaps/archive/g02.md")),
       "readonly did not create g02 roll-up")


def check_unresolved(payload):
    after = payload["after"]
    g01_card = os.path.join(
        after, "docs/roadmaps/g01/001-establish-widget-ids.md")
    ok(os.path.isfile(g01_card), "unresolved left g01 card intact")
    ok(not os.path.isfile(os.path.join(after, "docs/roadmaps/archive/g01.md")),
       "unresolved did not delete g01 into a roll-up")
    if os.path.isfile(g01_card):
        ok("UNIQUE-ORPHAN-RULE" in read_text(g01_card),
           "unresolved kept orphan rule on its source card")
    contracts = read_text(os.path.join(after, "docs/contracts/001-working-rules.md"))
    architecture = read_text(
        os.path.join(after, "docs/architecture/system-architecture.md"))
    ok("Widget export keys must be signed" not in contracts,
       "unresolved did not guess a contracts destination")
    ok("Widget export keys must be signed" not in architecture,
       "unresolved did not guess an architecture destination")
    ok(os.path.isdir(os.path.join(after, "docs/roadmaps/g03")),
       "unresolved preserved the active generation")


def check_conflict(payload):
    after = payload["after"]
    g01_readme = os.path.join(after, "docs/roadmaps/g01/README.md")
    ok(os.path.isfile(g01_readme), "conflict left g01 expanded")
    ok(not os.path.isfile(os.path.join(after, "docs/roadmaps/archive/g01.md")),
       "conflict did not compact contested g01")
    if os.path.isfile(g01_readme):
        ok("CONFLICT-ACTIVE-CLOSED" in read_text(g01_readme),
           "conflict preserved contested active/closed marker")
    ok(os.path.isdir(os.path.join(after, "docs/roadmaps/g03")),
       "conflict preserved the named active generation")


def check_repeat(payload, happy_payload):
    after_files = payload["after_files"]
    happy_files = happy_payload["after_files"]
    docs_after = {path: digest for path, digest in after_files.items()
                  if path.startswith("docs/")}
    docs_happy = {path: digest for path, digest in happy_files.items()
                  if path.startswith("docs/")}
    ok(docs_after == docs_happy,
       "repeat run did not churn docs content")
    ok(not any(path.startswith("docs/roadmaps/g01/") for path in after_files),
       "repeat run did not re-expand g01")
    ok(not any(path.startswith("docs/roadmaps/g02/") for path in after_files),
       "repeat run did not re-expand g02")


def main():
    happy = require_evidence("happy")
    readonly = require_evidence("readonly")
    unresolved = require_evidence("unresolved")
    conflict = require_evidence("active-conflict")
    repeat = require_evidence("repeat")
    if happy:
        check_provenance(
            "happy", happy,
            "installed-northstar-project-refresh", "repair-authorized")
        check_happy(happy)
    if readonly:
        check_provenance(
            "readonly", readonly,
            "installed-northstar-docs-cleanup", "read-only")
        check_readonly(readonly)
    if unresolved:
        check_provenance(
            "unresolved", unresolved,
            "installed-northstar-project-refresh", "repair-authorized")
        check_unresolved(unresolved)
    if conflict:
        check_provenance(
            "active-conflict", conflict,
            "installed-northstar-project-refresh", "repair-authorized")
        check_conflict(conflict)
    if repeat and happy:
        check_provenance(
            "repeat", repeat,
            "installed-northstar-project-refresh", "repair-authorized",
            before_files=happy["after_files"])
        check_repeat(repeat, happy)

    print(f"{CHECKS} checks, {FAILURES} failures")
    if FAILURES:
        sys.exit(1)


if __name__ == "__main__":
    main()
