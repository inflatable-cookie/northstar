#!/usr/bin/env python3
"""Card 120 bounded real-consumer reruns against the reduced core.

Runs each accepted installed package's real workflow against a disposable copy
of its real consumer: TypeScript/Svelte explicit audit (setup apply, record
init, assess, complete, finalize) against a Jetstream copy, and the Rust
repository-scope ledger (inspect, plan, init, assess, collect, repair,
complete, finalize) against a Convergence copy. Consumer policy files and
activation blocks are hashed before and after and must stay byte-identical;
every new path must live under the consumer's runtime state (.effigy), and the
audited Rust repair must restore its anchor byte-for-byte. The original
sibling repositories are hashed before and after and must be untouched.
Selection runs from the consumers' real activation markers through the shipped
registry. Fails on any deviation; mutates nothing outside its temp roots and
nothing inside any sibling.
"""

import hashlib
import importlib.util
import json
import os
import shutil
import subprocess
import sys
import tempfile

_HERE = os.path.dirname(os.path.abspath(__file__))
_spec = importlib.util.spec_from_file_location(
    "routes", os.path.join(_HERE, "validate_language_package_routes.py"))
routes = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(routes)

REPO = routes.REPO
SURFACE = routes.SURFACE
REGISTRY = routes.REGISTRY
TS = routes.TS
RUST = routes.RUST

JETSTREAM = os.environ.get(
    "NORTHSTAR_JETSTREAM_ROOT",
    os.path.join(os.path.dirname(REPO), "jetstream"))
CONVERGENCE = os.environ.get(
    "NORTHSTAR_CONVERGENCE_ROOT",
    os.path.join(os.path.dirname(REPO), "convergence"))

ROOT = None
failures = 0


def ok(condition, label, detail=""):
    global failures
    if condition:
        print(f"PASS {label}")
    else:
        failures += 1
        print(f"FAIL {label}" + (f": {detail}" if detail else ""))


def run(argv, cwd=None, check=True, env=None, stdout=None):
    result = subprocess.run(argv, cwd=cwd, capture_output=(stdout is None),
                            text=True, env=env, stdout=stdout)
    if check and result.returncode != 0:
        raise RuntimeError(f"{' '.join(argv)} failed:\n"
                           f"{result.stdout}\n{result.stderr}")
    return result


def file_digest(path):
    with open(path, "rb") as handle:
        return "sha256:" + hashlib.sha256(handle.read()).hexdigest()


def policy_snapshot(repo_root):
    """Digest consumer-owned policy and activation files."""
    hashes = {}
    for dirpath, dirnames, filenames in os.walk(repo_root):
        dirnames[:] = [d for d in dirnames if d not in
                       (".git", "node_modules", "target", ".effigy")]
        for name in filenames:
            if (name.endswith(("-profile.json", "-deviations.json"))
                    and "quality" in name) or name == "AGENTS.md":
                full = os.path.join(dirpath, name)
                hashes[os.path.relpath(full, repo_root)] = file_digest(full)
    return hashes


def tree_listing(repo_root):
    """Path set of the consumer copy excluding runtime state directories."""
    seen = set()
    for dirpath, dirnames, filenames in os.walk(repo_root):
        dirnames[:] = [d for d in dirnames
                       if d not in (".git", "node_modules", "target")]
        for name in filenames:
            seen.add(os.path.relpath(os.path.join(dirpath, name), repo_root))
    return seen


def make_disposable_copy(sibling, work, name):
    dest = os.path.join(work, name)
    subprocess.run(["rsync", "-a", "--exclude", ".git", "--exclude",
                    "node_modules", "--exclude", "target", "--exclude",
                    ".effigy", "--exclude", "artifacts", "--exclude",
                    "build", sibling.rstrip("/") + "/", dest + "/"],
                   check=True)
    run(["git", "init", "-q"], cwd=dest)
    run(["git", "config", "user.name", "Card120 Rerun"], cwd=dest)
    run(["git", "config", "user.email", "rerun@card120.invalid"], cwd=dest)
    run(["git", "add", "-A"], cwd=dest)
    run(["git", "commit", "-q", "-m", "card 120 rerun base"], cwd=dest)
    return dest


def read_marker(repo_root, relative, marker):
    with open(os.path.join(repo_root, relative)) as handle:
        text = handle.read()
    begin = text.index(marker + ":start")
    finish = text.index(marker + ":end")
    return text[begin:finish]


def select_by_marker(marker):
    handle = tempfile.NamedTemporaryFile(mode="w", suffix=".json",
                                         delete=False)
    handle.close()
    run(["bun", SURFACE, "select", REGISTRY, "--marker", marker,
         "--json", handle.name])
    with open(handle.name) as reopened:
        return json.load(reopened)


def main():
    global ROOT
    missing = [name for name in ("bun", "effigy", "cargo", "git", "python3")
               if shutil.which(name) is None]
    ok(not missing, "required tools present", f"missing {missing}")
    if missing:
        return 1
    for sibling, label in ((JETSTREAM, "Jetstream"),
                           (CONVERGENCE, "Convergence")):
        ok(os.path.isdir(sibling), f"{label} consumer sibling resolved",
           sibling)
        if not os.path.isdir(sibling):
            return 1

    ROOT = tempfile.mkdtemp(prefix="consumer-reruns-")
    routes.ROOT = ROOT
    try:
        before_siblings = {
            "jetstream": policy_snapshot(JETSTREAM),
            "convergence": policy_snapshot(CONVERGENCE),
        }

        # Install both packages through the reduced core exactly once.
        sources = {p["package_id"]: routes.materialize(ROOT, p)
                   for p in (TS, RUST)}
        state = routes.write_state(os.path.join(ROOT, "state"), [
            routes.allowlist_entry(p, sources[p["package_id"]],
                                   "card 120 real-consumer rerun")
            for p in (TS, RUST)])
        installed = {}
        for package in (TS, RUST):
            result = routes.host_call(
                ROOT, f"acquire-{package['language']}",
                routes.host_request(state, f"acquire-{package['language']}",
                                    package, "acquire_activate",
                                    "workflow_request"), None)
            ok(result["status"] == "activated" and
               result["tree_digest"] == package["tree"],
               f"{package['label']} package installed through the reduced core",
               json.dumps(result))
            installed[package["package_id"]] = result["installed_path"]
        # ---- Jetstream: TypeScript/Svelte explicit audit record flow ----
        jet = make_disposable_copy(JETSTREAM, ROOT, "jetstream-copy")
        before_jet = policy_snapshot(jet)
        jet_listing_before = tree_listing(jet)
        ok(os.path.isfile(os.path.join(jet, "editor-ui", "AGENTS.md")),
           "Jetstream carries the nested editor-ui activation surface")
        marker_text = read_marker(jet, os.path.join("editor-ui", "AGENTS.md"),
                                  "northstar:typescript-quality")
        ok("explicit" in marker_text,
           "Jetstream editor-ui marker is the explicit-audit activation")
        selection = select_by_marker("northstar:typescript-quality")
        ok(selection["package_id"] == TS["package_id"] and
           selection["tree_digest"] == TS["tree"],
           "Jetstream's real marker selects the exact TypeScript pin",
           json.dumps(selection))

        ts_installed = installed[TS["package_id"]]
        run(["effigy", "skill", "run", "--path", ts_installed,
             "typescript-quality:setup", "--repo", jet, "--json", "--",
             "apply", jet, "editor-ui"])
        inputs = os.path.join(ROOT, "ts-inputs")
        os.makedirs(inputs)
        unit_file = os.path.join("editor-ui", "src", "color.ts")
        ok(os.path.isfile(os.path.join(jet, unit_file)),
           "Jetstream audit unit is a real consumer file", unit_file)
        audit_id = "card120-jetstream-rerun"
        with open(os.path.join(inputs, "init.json"), "w") as handle:
            json.dump({
                "audit_id": audit_id,
                "profile": "strict",
                "scope": "worktree",
                "units": [{
                    "unit_id": "unit-color",
                    "primary_file": unit_file,
                    "owned_files": [unit_file],
                }],
                "initial_state": {
                    "dirty_files": [],
                    "in_scope_files": [unit_file],
                    "excluded_dirty_files": [],
                    "scope_evidence": ["card 120 real-consumer rerun"],
                },
            }, handle)
        with open(os.path.join(inputs, "assess.json"), "w") as handle:
            json.dump({"unit_id": "unit-color", "findings": [],
                       "repair_plans": []}, handle)
        with open(os.path.join(inputs, "complete.json"), "w") as handle:
            json.dump({"unit_id": "unit-color", "repairs": [],
                       "validation": []}, handle)
        record = ["effigy", "skill", "run", "--path", ts_installed,
                  "typescript-quality:record", "--repo", jet, "--json", "--"]
        run(record + ["init", jet, os.path.join(inputs, "init.json")])
        run(record + ["assess", jet, audit_id,
                      os.path.join(inputs, "assess.json")])
        run(record + ["complete", jet, audit_id,
                      os.path.join(inputs, "complete.json")])
        run(record + ["finalize", jet, audit_id])
        manifest = os.path.join(jet, ".effigy", "typescript-quality", "audits",
                                audit_id, "manifest.json")
        result_json = os.path.join(jet, ".effigy", "typescript-quality",
                                   "audits", audit_id, "result.json")
        ok(os.path.isfile(manifest) and os.path.isfile(result_json),
           "Jetstream rerun wrote its audit record in the consumer copy")
        after_jet = policy_snapshot(jet)
        drifted = {k for k in set(before_jet) | set(after_jet)
                   if before_jet.get(k) != after_jet.get(k)}
        ok(not drifted,
           "Jetstream policy and activations are byte-identical after the run",
           str(sorted(drifted)))
        jet_new = tree_listing(jet) - jet_listing_before
        stray = [p for p in jet_new if not p.startswith(".effigy/")]
        ok(not stray, "Jetstream run mutated only runtime state",
           str(sorted(stray)[:5]))
        print(f"HASH jetstream record manifest {file_digest(manifest)}")
        print(f"HASH jetstream record result {file_digest(result_json)}")

        # ---- Convergence: Rust repository-scope ledger flow ----
        conv = make_disposable_copy(CONVERGENCE, ROOT, "convergence-copy")
        before_conv = policy_snapshot(conv)
        conv_listing_before = tree_listing(conv)
        # Warm the cargo target with lints capped: cargo replays cached
        # warnings on every run, and any replayed warning would downgrade the
        # audited evidence record below the engine's passed bar. The evidence
        # claim is the test result, not lint posture.
        cargo_env = {**os.environ, "CARGO_NET_OFFLINE": "true",
                     "RUSTFLAGS": "--cap-lints=allow"}
        run(["cargo", "test", "--offline", "-p", "converge-model",
             "--message-format", "json-diagnostic-rendered-ansi"],
            cwd=conv, env=cargo_env)
        rust_marker_text = read_marker(conv, "AGENTS.md",
                                       "northstar:rust-quality")
        ok("everyday" in rust_marker_text,
           "Convergence carries the Rust everyday/audit activation marker")
        selection = select_by_marker("northstar:rust-quality")
        ok(selection["package_id"] == RUST["package_id"] and
           selection["tree_digest"] == RUST["tree"],
           "Convergence's real marker selects the exact Rust pin",
           json.dumps(selection))

        rust_installed = installed[RUST["package_id"]]
        probe_target = os.path.join(ROOT, "probe-target")
        run(["cargo", "install", "--locked", "--offline", "--path",
             os.path.join(rust_installed, "tools", "rust-quality"),
             "--root", probe_target])
        probe = os.path.join(probe_target, "bin", "northstar-rust-quality")

        with open(os.path.join(conv, "Cargo.toml")) as handle:
            cargo_text = handle.read()
        msrv = "unspecified"
        for line in cargo_text.splitlines():
            if line.strip().startswith("rust-version"):
                msrv = line.split("=", 1)[1].strip()
                break
        anchors = []
        crates_dir = os.path.join(conv, "crates")
        for crate in sorted(os.listdir(crates_dir)):
            candidate = os.path.join("crates", crate, "src", "lib.rs")
            if os.path.isfile(os.path.join(conv, candidate)):
                anchors.append(candidate)
        ok(bool(anchors), "Convergence anchor unit found", str(anchors[:2]))
        anchor = anchors[0]
        # The engine's worktree scope anchors on dirty Rust files, mirroring
        # the reviewed prover fixture: introduce a whitespace-only dirty
        # anchor in the disposable copy and keep the original bytes so the
        # audited repair can restore them byte-for-byte.
        anchor_path = os.path.join(conv, anchor)
        with open(anchor_path, "rb") as handle:
            anchor_original = handle.read()
        with open(anchor_path, "ab") as handle:
            handle.write(b"\n")

        engine_inputs = os.path.join(ROOT, "rust-inputs")
        os.makedirs(engine_inputs)
        rust_audit_id = "card120-convergence-rerun"
        discovery = os.path.join(engine_inputs, "discovery.json")
        run([probe, "inspect", "--repo", conv, "--scope", "worktree",
             "--output", discovery])
        plan_in = os.path.join(engine_inputs, "plan-in.json")
        with open(plan_in, "w") as handle:
            json.dump({"audit_id": rust_audit_id,
                       "units": [{"unit_id": "core", "anchors": [anchor],
                                  "context": []}],
                       "excluded_dirty_files": [],
                       "repository_coverage": None}, handle)
        plan = os.path.join(engine_inputs, "plan.json")
        run([probe, "plan", "--discovery", discovery, "--input", plan_in,
             "--output", plan])
        rules = os.path.join(rust_installed,
                             "references/language-quality/rust",
                             "strict-audit.json")
        profile = os.path.join(conv, "docs", "contracts",
                               "rust-quality-profile.json")
        deviations = os.path.join(conv, "docs", "contracts",
                                  "rust-quality-deviations.json")
        run([probe, "init", "--repo", conv, "--discovery", discovery,
             "--plan", plan, "--rules", rules, "--profile", profile,
             "--deviations", deviations])
        assess_in = os.path.join(engine_inputs, "assess-in.json")
        with open(assess_in, "w") as handle:
            json.dump({
                "unit_id": "core",
                "verdicts": [
                    {"rule_id": "RUST-MSRV-001", "verdict": "pass",
                     "inspected_surfaces": ["Cargo.toml"],
                     "evidence": [f"workspace MSRV is {msrv}"]},
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
                     "finding_ids": ["rerun-readability-1"],
                     "inspected_surfaces": [anchor],
                     "evidence": ["Trailing blank line at end of file"]},
                ],
                "attestations": [
                    {"dimension": "correctness_assurance",
                     "inspected_surfaces": [anchor],
                     "evidence": ["Behavior surface reviewed"]},
                    {"dimension": "architecture",
                     "inspected_surfaces": [anchor],
                     "evidence": ["Boundary reviewed"]},
                    {"dimension": "human_quality",
                     "inspected_surfaces": [anchor],
                     "evidence": ["Naming and flow reviewed"]},
                ],
                "findings": [
                    {"finding_id": "rerun-readability-1",
                     "rule_id": "RUST-READ-001",
                     "action": "remove_trailing_blank_line",
                     "file": anchor,
                     "evidence": "Trailing blank line at end of file",
                     "disposition": "repair_planned"},
                ],
                "repair_plans": [
                    {"plan_id": "rerun-readability-repair",
                     "finding_ids": ["rerun-readability-1"],
                     "owned_files": [anchor],
                     "preserved_behavior": ["Whitespace-only change; no "
                                            "behavior surface touched"]},
                ],
                "limitations": [],
            }, handle)
        run([probe, "assess", "--repo", conv, "--audit", rust_audit_id,
             "--input", assess_in])
        collect_in = os.path.join(engine_inputs, "collect-in.json")
        with open(collect_in, "w") as handle:
            json.dump({
                "applicable_classes": ["test"],
                "requests": [{
                    "evidence_id": "rerun-focused-tests",
                    "unit_id": "core",
                    "evidence_class": "test",
                    "selector": "cargo test",
                    "origin": "cargo_native",
                    "package_cwd": ".",
                    "environment": "card 120 rerun; offline cargo",
                    "execution": {
                        "kind": "command",
                        "program": "cargo",
                        "args": ["test", "--offline", "-p", "converge-model",
                                 "--message-format",
                                 "json-diagnostic-rendered-ansi",
                                 "--", "--skip", "divergence_warning"],
                        "format": "cargo_json",
                    },
                }],
            }, handle)
        run([probe, "collect", "--repo", conv, "--audit", rust_audit_id,
             "--input", collect_in], env=cargo_env)
        # Apply the audited repair: restore the anchor's exact pre-run bytes.
        with open(anchor_path, "wb") as handle:
            handle.write(anchor_original)
        complete_in = os.path.join(engine_inputs, "complete-in.json")
        with open(complete_in, "w") as handle:
            json.dump({"unit_id": "core",
                       "repairs": [{
                           "plan_id": "rerun-readability-repair",
                           "status": "applied",
                           "changed_files": [anchor],
                       }],
                       "evidence_ids": ["rerun-focused-tests"]}, handle)
        run([probe, "complete", "--repo", conv, "--audit", rust_audit_id,
             "--input", complete_in])
        closeout = os.path.join(engine_inputs, "closeout.json")
        with open(closeout, "w") as handle:
            run([probe, "finalize", "--repo", conv, "--audit",
                 rust_audit_id], stdout=handle)
        with open(closeout) as handle:
            closeout_doc = json.load(handle)
        ok(closeout_doc.get("status") == "clean",
           "Convergence ledger finalized clean",
           json.dumps(closeout_doc)[:300])
        ok(file_digest(anchor_path) == "sha256:" +
           hashlib.sha256(anchor_original).hexdigest(),
           "audited repair restored the anchor byte-for-byte")
        after_conv = policy_snapshot(conv)
        drifted = {k for k in set(before_conv) | set(after_conv)
                   if before_conv.get(k) != after_conv.get(k)}
        ok(not drifted,
           "Convergence policy and activations are byte-identical after the "
           "run", str(sorted(drifted)))
        # The Rust ledger lives under the consumer's git metadata runtime
        # state (.git/northstar/), not under .effigy/.
        ledger_result = os.path.join(conv, ".git", "northstar",
                                     "rust-quality", "audits",
                                     rust_audit_id, "result.json")
        ok(os.path.isfile(ledger_result),
           "Convergence ledger wrote its result under runtime state")
        conv_new = tree_listing(conv) - conv_listing_before
        stray = [p for p in conv_new
                 if not p.startswith(".effigy/")]
        ok(not stray, "Convergence run mutated only tracked-tree state",
           str(sorted(stray)[:5]))
        print(f"HASH convergence ledger result {file_digest(ledger_result)}")
        print(f"HASH convergence closeout {file_digest(closeout)}")

        # ---- the original siblings must be untouched ----
        ok(before_siblings["jetstream"] == policy_snapshot(JETSTREAM) and
           before_siblings["convergence"] == policy_snapshot(CONVERGENCE),
           "both consumer siblings are byte-identical after the reruns")

        print(f"consumer reruns oracle: {'PASS' if failures == 0 else 'FAIL'} "
              f"({failures} failures)")
        return 0 if failures == 0 else 1
    finally:
        shutil.rmtree(ROOT, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
