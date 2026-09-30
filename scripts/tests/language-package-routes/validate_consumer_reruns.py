#!/usr/bin/env python3
"""Rerun both installed language-package workflows against a local fixture.

The consumer is copied from scripts/fixtures/language-package-reruns into one
fresh temporary root. Official package pins are acquired through the lifecycle
route; no sibling checkout supplies a consumer or package tree. The check
proves exact marker selection, lean policy paths, TypeScript audit recording,
Rust evidence collection and repair, policy preservation, and runtime-only
outputs.
"""

import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO = subprocess.run(
    ["git", "rev-parse", "--show-toplevel"], cwd=SCRIPT_DIR,
    capture_output=True, text=True, check=True).stdout.strip()
FIXTURE = os.path.join(REPO, "scripts/fixtures/language-package-reruns")
SURFACE = os.path.join(REPO, "skills/northstar/scripts/language-package-lifecycle.ts")
REGISTRY = os.path.join(REPO, "skills/northstar/references/packages/official-registry.json")

ROOT = None
failures = 0


def ok(condition, label, detail=""):
    global failures
    if condition:
        print(f"PASS {label}")
    else:
        failures += 1
        print(f"FAIL {label}" + (f": {detail}" if detail else ""))


def run(argv, cwd=None, env=None, stdout=None):
    result = subprocess.run(argv, cwd=cwd, env=env,
                            capture_output=(stdout is None),
                            text=True, stdout=stdout)
    if result.returncode != 0:
        raise RuntimeError(
            f"{' '.join(argv)} failed (exit {result.returncode}):\n"
            f"{result.stdout}\n{result.stderr}")
    return result


def file_digest(path):
    with open(path, "rb") as handle:
        return "sha256:" + hashlib.sha256(handle.read()).hexdigest()


def policy_snapshot(consumer):
    hashes = {}
    for dirpath, dirnames, filenames in os.walk(consumer):
        dirnames[:] = [name for name in dirnames if name not in
                       (".git", ".effigy", "node_modules", "target")]
        for name in filenames:
            if (name == "AGENTS.md" or
                    (name.endswith(("-profile.json", "-deviations.json"))
                     and "quality" in name)):
                path = os.path.join(dirpath, name)
                hashes[os.path.relpath(path, consumer)] = file_digest(path)
    return hashes


def tree_listing(consumer):
    paths = set()
    for dirpath, dirnames, filenames in os.walk(consumer):
        dirnames[:] = [name for name in dirnames if name not in
                       (".git", "node_modules", "target")]
        for name in filenames:
            paths.add(os.path.relpath(os.path.join(dirpath, name), consumer))
    return paths


def copy_fixture(name):
    destination = os.path.join(ROOT, name)
    shutil.copytree(FIXTURE, destination, symlinks=False)
    run(["git", "init", "-q"], cwd=destination)
    run(["git", "config", "user.name", "Northstar rerun fixture"], cwd=destination)
    run(["git", "config", "user.email", "rerun-fixture@northstar.invalid"],
        cwd=destination)
    run(["git", "add", "-A"], cwd=destination)
    run(["git", "commit", "-q", "-m", "fixture baseline"], cwd=destination)
    return destination


def marker_present(consumer, marker):
    with open(os.path.join(consumer, "AGENTS.md")) as handle:
        instructions = handle.read()
    return (f"<!-- {marker}:start -->" in instructions and
            f"<!-- {marker}:end -->" in instructions)


def remove_marker_block(consumer, marker):
    path = os.path.join(consumer, "AGENTS.md")
    with open(path) as handle:
        instructions = handle.read()
    start_token = f"<!-- {marker}:start -->"
    end_token = f"<!-- {marker}:end -->"
    start = instructions.index(start_token)
    end = instructions.index(end_token, start) + len(end_token)
    updated = instructions[:start].rstrip() + "\n"
    updated += instructions[end:].lstrip()
    with open(path, "w") as handle:
        handle.write(updated)


def select_by_marker(marker, output_path):
    run(["bun", "run", SURFACE, "select", REGISTRY, "--marker", marker,
         "--json", output_path])
    with open(output_path) as handle:
        return json.load(handle)


def route_package(consumer, language, workflow):
    state_root = os.path.join(ROOT, f"state-{language}")
    output_path = os.path.join(ROOT, f"route-{language}.json")
    run(["bun", "run", SURFACE, "route", "--consumer", consumer,
         "--language", language, "--workflow", workflow,
         "--state-root", state_root, "--json", output_path])
    with open(output_path) as handle:
        return json.load(handle)


def task(package_root, selector, consumer, *args):
    run(["effigy", "skill", "run", "--path", package_root, selector,
         "--repo", consumer, "--json", "--", *args])


def validate_registry(registry):
    expected = {
        "@northstar/typescript-quality": ("typescript", "explicit_audit_repair"),
        "@northstar/rust-quality": ("rust", "explicit_audit_repair"),
    }
    entries = {entry["package_id"]: entry for entry in registry["packages"]}
    ok(registry.get("registry_version") == "1.5.0" and
       set(entries) == set(expected),
       "official registry contains the expected discovery entries")
    for package_id, (language, workflow) in expected.items():
        entry = entries.get(package_id, {})
        discovery = entry.get("discovery", {})
        ok(entry.get("version") == "0.2.0" and
           entry.get("commit") == "4a6df3c7b4f6ba8622d3c937bfe1fea53a76500f" and
           discovery.get("languages") == [language] and
           workflow in discovery.get("workflows", []),
           f"registry pins {package_id}@0.2.0 at the merged package commit")
    return entries


def rerun_typescript(consumer, package):
    marker = "northstar:typescript-quality"
    selected = select_by_marker(marker, os.path.join(ROOT, "selected-typescript.json"))
    ok(selected.get("package_id") == "@northstar/typescript-quality" and
       selected.get("version") == "0.2.0" and
       selected.get("tree_digest") == package["tree_digest"],
       "fixture TypeScript marker selects the exact 0.2.0 pin",
       json.dumps(selected))

    ts_root = route_package(consumer, "typescript", "explicit_audit_repair")
    ok(ts_root.get("status") in ("activated", "routed") and
       ts_root.get("package_id") == package["package_id"] and
       ts_root.get("version") == "0.2.0" and
       ts_root.get("tree_digest") == package["tree_digest"] and
       ts_root.get("manifest_digest") == package["manifest_digest"],
       "TypeScript package routes from its official 0.2.0 pin",
       json.dumps(ts_root))
    package_root = ts_root["installed_path"]
    profile_files = {path: digest for path, digest in policy_snapshot(consumer).items()
                     if path.endswith(("-profile.json", "-deviations.json"))}
    remove_marker_block(consumer, marker)
    task(package_root, "typescript-quality:setup", consumer,
         "apply", consumer, ".")
    profile_after_setup = {path: digest for path, digest in policy_snapshot(consumer).items()
                           if path.endswith(("-profile.json", "-deviations.json"))}
    ok(profile_after_setup == profile_files,
       "TypeScript setup preserved the existing lean-path profile files")
    ok(marker_present(consumer, marker),
       "TypeScript setup installed its activation block without removing Rust instructions")
    before_policy = policy_snapshot(consumer)
    before_paths = tree_listing(consumer)

    unit_file = "src/unit.ts"
    ok(os.path.isfile(os.path.join(consumer, unit_file)),
       "fixture contains the TypeScript audit unit", unit_file)
    input_root = os.path.join(ROOT, "typescript-inputs")
    os.makedirs(input_root)
    audit_id = "fixture-typescript-rerun"
    inputs = {
        "init.json": {
            "audit_id": audit_id,
            "profile": "strict",
            "scope": "worktree",
            "units": [{"unit_id": "unit-fixture", "primary_file": unit_file,
                       "owned_files": [unit_file]}],
            "initial_state": {
                "dirty_files": [], "in_scope_files": [unit_file],
                "excluded_dirty_files": [],
                "scope_evidence": ["self-contained Northstar rerun fixture"],
            },
        },
        "assess.json": {"unit_id": "unit-fixture", "findings": [],
                         "repair_plans": []},
        "complete.json": {"unit_id": "unit-fixture", "repairs": [],
                           "validation": []},
    }
    for filename, document in inputs.items():
        with open(os.path.join(input_root, filename), "w") as handle:
            json.dump(document, handle)

    record_selector = "typescript-quality:record"
    task(package_root, record_selector, consumer, "init", consumer,
         os.path.join(input_root, "init.json"))
    task(package_root, record_selector, consumer, "assess", consumer, audit_id,
         os.path.join(input_root, "assess.json"))
    task(package_root, record_selector, consumer, "complete", consumer, audit_id,
         os.path.join(input_root, "complete.json"))
    task(package_root, record_selector, consumer, "finalize", consumer, audit_id)

    audit_root = os.path.join(consumer, ".effigy", "typescript-quality",
                              "audits", audit_id)
    manifest = os.path.join(audit_root, "manifest.json")
    result = os.path.join(audit_root, "result.json")
    ok(os.path.isfile(manifest) and os.path.isfile(result),
       "TypeScript rerun wrote its audit record under consumer runtime state")
    after_policy = policy_snapshot(consumer)
    drifted = sorted(path for path in set(before_policy) | set(after_policy)
                     if before_policy.get(path) != after_policy.get(path))
    ok(not drifted,
       "TypeScript policy, profile, and activation files stayed byte-identical",
       str(drifted))
    new_paths = tree_listing(consumer) - before_paths
    stray = sorted(path for path in new_paths if not path.startswith(".effigy/"))
    ok(not stray, "TypeScript rerun wrote only runtime state", str(stray[:8]))
    if os.path.isfile(manifest):
        print(f"HASH TypeScript audit manifest {file_digest(manifest)}")
    if os.path.isfile(result):
        print(f"HASH TypeScript audit result {file_digest(result)}")


def rerun_rust(consumer, package):
    marker = "northstar:rust-quality"
    selected = select_by_marker(marker, os.path.join(ROOT, "selected-rust.json"))
    ok(selected.get("package_id") == "@northstar/rust-quality" and
       selected.get("version") == "0.2.0" and
       selected.get("tree_digest") == package["tree_digest"],
       "fixture Rust marker selects the exact 0.2.0 pin", json.dumps(selected))

    before_policy = policy_snapshot(consumer)
    before_paths = tree_listing(consumer)
    rust_root = route_package(consumer, "rust", "explicit_audit_repair")
    ok(rust_root.get("status") in ("activated", "routed") and
       rust_root.get("package_id") == package["package_id"] and
       rust_root.get("version") == "0.2.0" and
       rust_root.get("tree_digest") == package["tree_digest"] and
       rust_root.get("manifest_digest") == package["manifest_digest"],
       "Rust package routes from its official 0.2.0 pin", json.dumps(rust_root))
    package_root = rust_root["installed_path"]
    task(package_root, "rust-quality:setup", consumer, "apply", consumer, ".")

    rust_env = {**os.environ, "CARGO_NET_OFFLINE": "true",
                "CARGO_TARGET_DIR": os.path.join(ROOT, "cargo-target"),
                "RUSTFLAGS": "--cap-lints=allow"}
    probe_root = os.path.join(ROOT, "rust-probe")
    run(["cargo", "install", "--locked", "--offline", "--path",
         os.path.join(package_root, "tools", "rust-quality"),
         "--root", probe_root], env=rust_env)
    probe = os.path.join(probe_root, "bin", "northstar-rust-quality")

    anchor = "src/lib.rs"
    anchor_path = os.path.join(consumer, anchor)
    with open(anchor_path, "rb") as handle:
        original = handle.read()
    with open(anchor_path, "ab") as handle:
        handle.write(b"\n")

    inputs_root = os.path.join(ROOT, "rust-inputs")
    os.makedirs(inputs_root)
    audit_id = "fixture-rust-rerun"
    discovery = os.path.join(inputs_root, "discovery.json")
    run([probe, "inspect", "--repo", consumer, "--scope", "worktree",
         "--output", discovery], env=rust_env)
    plan_input = os.path.join(inputs_root, "plan-input.json")
    with open(plan_input, "w") as handle:
        json.dump({"audit_id": audit_id,
                   "units": [{"unit_id": "fixture", "anchors": [anchor],
                              "context": []}],
                   "excluded_dirty_files": [], "repository_coverage": None}, handle)
    plan = os.path.join(inputs_root, "plan.json")
    run([probe, "plan", "--discovery", discovery, "--input", plan_input,
         "--output", plan], env=rust_env)

    rules = os.path.join(package_root,
                         "references/language-quality/rust/strict-audit.json")
    profile = os.path.join(consumer, "docs/knowledge/contracts",
                           "rust-quality-profile.json")
    deviations = os.path.join(consumer, "docs/knowledge/contracts",
                              "rust-quality-deviations.json")
    run([probe, "init", "--repo", consumer, "--discovery", discovery,
         "--plan", plan, "--rules", rules, "--profile", profile,
         "--deviations", deviations], env=rust_env)

    assess_input = os.path.join(inputs_root, "assess-input.json")
    with open(assess_input, "w") as handle:
        json.dump({
            "unit_id": "fixture",
            "verdicts": [
                {"rule_id": "RUST-MSRV-001", "verdict": "pass",
                 "inspected_surfaces": ["Cargo.toml"],
                 "evidence": ["fixture declares its MSRV in Cargo.toml"]},
                {"rule_id": "RUST-ERR-001", "verdict": "pass",
                 "inspected_surfaces": [anchor],
                 "evidence": ["no foreign-error policy surfaced"]},
                {"rule_id": "RUST-UNSAFE-001", "verdict": "pass",
                 "inspected_surfaces": [anchor],
                 "evidence": ["no unsafe code surfaced"]},
                {"rule_id": "RUST-API-001", "verdict": "pass",
                 "inspected_surfaces": [anchor],
                 "evidence": ["no API-stability violations surfaced"]},
                {"rule_id": "RUST-ASYNC-001", "verdict": "pass",
                 "inspected_surfaces": [anchor],
                 "evidence": ["no async misuse surfaced"]},
                {"rule_id": "RUST-READ-001", "verdict": "finding",
                 "finding_ids": ["fixture-readability"],
                 "inspected_surfaces": [anchor],
                 "evidence": ["Trailing blank line at end of file"]},
            ],
            "attestations": [
                {"dimension": "correctness_assurance",
                 "inspected_surfaces": [anchor],
                 "evidence": ["Fixture behavior reviewed"]},
                {"dimension": "architecture", "inspected_surfaces": [anchor],
                 "evidence": ["Fixture boundary reviewed"]},
                {"dimension": "human_quality", "inspected_surfaces": [anchor],
                 "evidence": ["Fixture naming and flow reviewed"]},
            ],
            "findings": [{
                "finding_id": "fixture-readability",
                "rule_id": "RUST-READ-001",
                "action": "remove_trailing_blank_line",
                "file": anchor,
                "evidence": "Trailing blank line at end of file",
                "disposition": "repair_planned",
            }],
            "repair_plans": [{
                "plan_id": "fixture-readability-repair",
                "finding_ids": ["fixture-readability"],
                "owned_files": [anchor],
                "preserved_behavior": ["Whitespace-only change; behavior is unchanged"],
            }],
            "limitations": [],
        }, handle)
    run([probe, "assess", "--repo", consumer, "--audit", audit_id,
         "--input", assess_input], env=rust_env)

    collect_input = os.path.join(inputs_root, "collect-input.json")
    cargo_args = ["test", "--offline", "-p", "northstar-rerun-fixture",
                  "--message-format", "json-diagnostic-rendered-ansi"]
    with open(collect_input, "w") as handle:
        json.dump({
            "applicable_classes": ["test"],
            "requests": [{
                "evidence_id": "fixture-cargo-test",
                "unit_id": "fixture",
                "evidence_class": "test",
                "selector": "cargo test --offline -p northstar-rerun-fixture",
                "origin": "cargo_native",
                "package_cwd": ".",
                "environment": "Task 020 fixture; offline Cargo",
                "execution": {"kind": "command", "program": "cargo",
                              "args": cargo_args, "format": "cargo_json"},
            }],
        }, handle)
    run([probe, "collect", "--repo", consumer, "--audit", audit_id,
         "--input", collect_input], env=rust_env)

    with open(anchor_path, "wb") as handle:
        handle.write(original)
    complete_input = os.path.join(inputs_root, "complete-input.json")
    with open(complete_input, "w") as handle:
        json.dump({"unit_id": "fixture", "repairs": [{
            "plan_id": "fixture-readability-repair", "status": "applied",
            "changed_files": [anchor],
        }], "evidence_ids": ["fixture-cargo-test"]}, handle)
    run([probe, "complete", "--repo", consumer, "--audit", audit_id,
         "--input", complete_input], env=rust_env)

    closeout = os.path.join(inputs_root, "closeout.json")
    with open(closeout, "w") as handle:
        run([probe, "finalize", "--repo", consumer, "--audit", audit_id],
            env=rust_env, stdout=handle)
    with open(closeout) as handle:
        closeout_doc = json.load(handle)
    ok(closeout_doc.get("status") == "clean",
       "Rust fixture ledger finalized clean", json.dumps(closeout_doc)[:300])
    ok(file_digest(anchor_path) == "sha256:" + hashlib.sha256(original).hexdigest(),
       "Rust repair restored the anchor byte-for-byte")

    after_policy = policy_snapshot(consumer)
    drifted = sorted(path for path in set(before_policy) | set(after_policy)
                     if before_policy.get(path) != after_policy.get(path))
    ok(not drifted,
       "Rust policy, profile, and activation files stayed byte-identical",
       str(drifted))
    new_paths = tree_listing(consumer) - before_paths
    stray = sorted(path for path in new_paths if not path.startswith(".effigy/"))
    ok(not stray, "Rust rerun wrote no files outside runtime state", str(stray[:8]))
    ledger_result = os.path.join(consumer, ".git", "northstar", "rust-quality",
                                 "audits", audit_id, "result.json")
    ok(os.path.isfile(ledger_result), "Rust ledger result lives under Git runtime state")
    if os.path.isfile(ledger_result):
        print(f"HASH Rust audit result {file_digest(ledger_result)}")
    print(f"HASH Rust closeout {file_digest(closeout)}")


def main():
    global ROOT
    required = ("bun", "effigy", "cargo", "git", "python3")
    missing = [name for name in required if shutil.which(name) is None]
    ok(not missing, "required tools present", f"missing {missing}")
    if missing:
        return 1
    ok(os.path.isdir(FIXTURE), "repository fixture is present", FIXTURE)
    if not os.path.isdir(FIXTURE):
        return 1

    with open(REGISTRY) as handle:
        registry = json.load(handle)
    entries = validate_registry(registry)
    ROOT = tempfile.mkdtemp(prefix="language-consumer-reruns-")
    try:
        consumers = {
            "typescript": copy_fixture("typescript-consumer"),
            "rust": copy_fixture("rust-consumer"),
        }
        for language, consumer in consumers.items():
            marker = f"northstar:{language}-quality"
            ok(marker_present(consumer, marker),
               f"fixture carries the {marker} activation marker")
            filename = f"{language}-quality-profile.json"
            path = os.path.join(consumer, "docs/knowledge/contracts", filename)
            ok(os.path.isfile(path), f"fixture carries the lean {language} profile", path)

        rerun_typescript(consumers["typescript"],
                         entries["@northstar/typescript-quality"])
        rerun_rust(consumers["rust"], entries["@northstar/rust-quality"])
        print(f"consumer reruns oracle: {'PASS' if failures == 0 else 'FAIL'} "
              f"({failures} failures)")
        return 0 if failures == 0 else 1
    finally:
        shutil.rmtree(ROOT, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
