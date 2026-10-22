#!/usr/bin/env python3
"""Task 020 two-package installed-route and core-only containment oracle.

The root payload no longer embeds any language implementation. This oracle
replays both accepted registry pins (@northstar/typescript-quality 0.2.2 and
@northstar/rust-quality 0.2.3, both at 4cdc876) against the read-only
package-source sibling: it materializes both pinned package trees, reproduces
all four spec-034 digests with an independent implementation, proves that a
package-less core stops each language workflow visibly with the manual install
route, installs both packages into one shared state root, and proves each
routes independently with its exact receipt, isolated payload, drift stop, and
reviewed installed-route prover. Fails on any deviation; mutates nothing
outside its temp root and nothing inside the sibling.
"""

import hashlib
import json
import os
import shutil
import stat
import subprocess
import sys
import tempfile

REPO = subprocess.run(["git", "rev-parse", "--show-toplevel"],
                      cwd=os.path.dirname(os.path.abspath(__file__)),
                      capture_output=True, text=True, check=True).stdout.strip()
SIBLING = os.environ.get(
    "NORTHSTAR_LANGUAGE_PACKS_ROOT",
    os.path.join(os.path.dirname(REPO), "northstar-language-packs"),
)

TS = {
    "label": "TypeScript",
    "package_id": "@northstar/typescript-quality",
    "version": "0.2.2",
    "subpath": "packages/typescript",
    "commit": "4cdc876b2d0f8c75358a4429c46377f66146b787",
    "tree": "sha256:06725f4ca633e660db18cabed65ceb76e61f43708271446697bf48a0b83e80f3",
    "manifest": "sha256:e776287f93fe9ef2e74817dafd980b15c0c90846baf7cbb5bfa06e6d53e8abc1",
    "language": "typescript",
    "workflow": "explicit_audit_repair",
    "foreign_markers": ("rust-quality", "cargo"),
}
RUST = {
    "label": "Rust",
    "package_id": "@northstar/rust-quality",
    "version": "0.2.3",
    "subpath": "packages/rust",
    "commit": "4cdc876b2d0f8c75358a4429c46377f66146b787",
    "tree": "sha256:67261b22f5cb766e83606f87425e793b385dd952baf1fae1f6348b257270ab39",
    "manifest": "sha256:4c88e2213937a8ec1c9025c10c1187173e25476b3d8b02cc5d7a18da31350334",
    "language": "rust",
    "workflow": "explicit_audit_repair",
    "foreign_markers": ("typescript-quality", "svelte"),
}
PACKAGES = (TS, RUST)
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


def run(argv, cwd=None, check=True):
    result = subprocess.run(argv, cwd=cwd, capture_output=True, text=True)
    if check and result.returncode != 0:
        raise RuntimeError(f"{' '.join(argv)} failed:\n{result.stdout}\n{result.stderr}")
    return result


def git_object_framing_digests(repo, commit, subpath):
    """Independent spec-034 digest reproduction from the git object store."""
    listing = run(["git", "-C", repo, "ls-tree", "-r", "-z", commit, "--", subpath]).stdout
    entries = []
    for record in listing.split("\0"):
        if not record:
            continue
        meta, path = record.split("\t", 1)
        mode, _otype, osha = meta.split()
        entries.append((path[len(subpath) + 1:].encode(), mode, osha))
    entries.sort(key=lambda e: e[0])
    digest = hashlib.sha256()
    seen = set()
    for rel, mode, osha in entries:
        seen.add(rel)
        content = subprocess.run(["git", "-C", repo, "cat-file", "blob", osha],
                                 capture_output=True, check=True).stdout
        digest.update(b"F\0" + str(len(rel)).encode() + b"\0" + rel + b"\0")
        digest.update(b"1" if mode == "100755" else b"0")
        digest.update(b"\0" + str(len(content)).encode() + b"\0" + content)
    tree = "sha256:" + digest.hexdigest()
    manifest_line = run(["git", "-C", repo, "ls-tree", commit, "--",
                         f"{subpath}/northstar-package.json"]).stdout
    manifest_bytes = subprocess.run(
        ["git", "-C", repo, "cat-file", "blob", manifest_line.split()[2]],
        capture_output=True, check=True).stdout
    manifest = "sha256:" + hashlib.sha256(manifest_bytes).hexdigest()
    return tree, manifest, seen


def spec034_tree_digest(root):
    files = []
    for dirpath, _dirnames, filenames in os.walk(root):
        for name in filenames:
            full = os.path.join(dirpath, name)
            files.append((os.path.relpath(full, root).encode(), full))
    files.sort(key=lambda e: e[0])
    digest = hashlib.sha256()
    for rel, full in files:
        with open(full, "rb") as handle:
            content = handle.read()
        executable = b"1" if os.stat(full).st_mode & stat.S_IXUSR else b"0"
        digest.update(b"F\0" + str(len(rel)).encode() + b"\0" + rel + b"\0")
        digest.update(executable + b"\0" + str(len(content)).encode() + b"\0" + content)
    return "sha256:" + digest.hexdigest()


def write_state(root, allowlist):
    os.makedirs(root, exist_ok=True)
    trust = {"schema_version": "1.0.0", "revision": "1", "allowlist": allowlist, "revocations": []}
    with open(os.path.join(root, "operator-trust.json"), "w") as handle:
        json.dump(trust, handle)
    return root


def allowlist_entry(package, path, reason):
    return {
        "package_id": package["package_id"],
        "version": package["version"],
        "source_identity": {"type": "local_path", "path": path},
        "tree_digest": package["tree"],
        "manifest_digest": package["manifest"],
        "compatible_core_range": ">=0.2.0 <1.0.0",
        "actor": "northstar-source-qa",
        "timestamp": "2026-09-03T00:00:00Z",
        "reason": reason,
    }


def host_call(work, name, request, registry_path):
    req = os.path.join(work, f"req-{name}.json")
    res = os.path.join(work, f"res-{name}.json")
    with open(req, "w") as handle:
        json.dump(request, handle)
    argv = ["bun", SURFACE, "host", req, res]
    if registry_path is not None:
        argv.append(registry_path)
    run(argv)
    with open(res) as handle:
        return json.load(handle)


def host_request(state, name, package, operation, intent, **overrides):
    base = {
        "protocol_version": "1.0.0",
        "request_id": f"req-package-routes-{name}",
        "operation": operation,
        "intent": intent,
        "package_id": package["package_id"],
        "version": package["version"],
        "language": package["language"],
        "workflow": package["workflow"],
        "core_version": "0.2.0",
        "consumer_dir": os.path.join(ROOT, "consumer"),
        "state_root": state,
    }
    base.update(overrides)
    return base


def materialize(work, package):
    """Extract the pinned package tree from the sibling object store."""
    parent = os.path.join(work, "src", "packages")
    os.makedirs(parent, exist_ok=True)
    archive = subprocess.run(
        ["git", "-C", SIBLING, "archive", package["commit"], package["subpath"]],
        capture_output=True, check=True).stdout
    extraction = subprocess.run(["tar", "-x", "-C", parent], input=archive)
    if extraction.returncode != 0:
        raise RuntimeError("git archive extraction failed")
    return os.path.join(parent, *package["subpath"].split("/"))


def payload_inventory(root):
    seen = {}
    for dirpath, _dirnames, filenames in os.walk(root):
        for name in filenames:
            full = os.path.join(dirpath, name)
            seen[os.path.relpath(full, root)] = \
                hashlib.sha256(open(full, "rb").read()).hexdigest()
    return seen


def snapshot(directory):
    hashes = []
    for dirpath, _dirnames, filenames in os.walk(directory):
        for name in filenames:
            full = os.path.join(dirpath, name)
            with open(full, "rb") as handle:
                hashes.append(os.path.relpath(full, directory) + " " +
                              hashlib.sha256(handle.read()).hexdigest())
    return sorted(hashes)


def main():
    global ROOT
    missing = [name for name in ("bun", "effigy", "cargo", "git", "python3")
               if shutil.which(name) is None]
    ok(not missing, "required tools present", f"missing {missing}")
    if missing:
        return 1

    ok(os.path.isdir(os.path.join(SIBLING, ".git")), "package-source sibling resolved", SIBLING)
    for package in PACKAGES:
        commit = package["commit"] + "^{commit}"
        if run(["git", "-C", SIBLING, "cat-file", "-e", commit],
               check=False).returncode != 0:
            run(["git", "-C", SIBLING, "fetch", "origin"])
        run(["git", "-C", SIBLING, "cat-file", "-e", commit])
    print("PASS both accepted pin merges present in the sibling object store")

    with open(REGISTRY) as handle:
        registry_doc = json.load(handle)
    entries = {entry["package_id"]: entry for entry in registry_doc["packages"]}
    ok(registry_doc.get("registry_version") == "1.8.0",
       "shipped registry is the rust-0.2.3 and typescript-0.2.2 revision 1.8.0",
       registry_doc.get("registry_version"))
    for package in PACKAGES:
        entry = entries.get(package["package_id"], {})
        ok(entry.get("version") == package["version"] and
           entry.get("commit") == package["commit"] and
           entry.get("tree_digest") == package["tree"] and
           entry.get("manifest_digest") == package["manifest"],
           f"shipped registry pins the exact {package['label']} identity",
           json.dumps(entry))

    ROOT = tempfile.mkdtemp(prefix="language-package-routes-")
    try:
        sources = {}
        for package in PACKAGES:
            tree, manifest, seen = git_object_framing_digests(
                SIBLING, package["commit"], package["subpath"])
            ok(tree == package["tree"] and manifest == package["manifest"],
               f"independent spec-034 digests reproduce the {package['label']} pin",
               f"tree {tree} manifest {manifest}")
            sources[package["package_id"]] = materialize(ROOT, package)

        consumer = os.path.join(ROOT, "consumer")
        os.makedirs(os.path.join(consumer, "src"))
        with open(os.path.join(consumer, "marker.txt"), "w") as handle:
            handle.write("card-120 consumer marker\n")
        with open(os.path.join(consumer, "src", "lib.rs"), "w") as handle:
            handle.write("pub fn x() {}\n")
        before = snapshot(consumer)

        def unchanged():
            return snapshot(consumer) == before

        # ---- core-only containment: no allowlist, no installed package ----
        empty_state = write_state(os.path.join(ROOT, "state-empty"), [])
        for package in PACKAGES:
            result = host_call(ROOT, f"contain-{package['language']}",
                               host_request(empty_state, f"contain-{package['language']}",
                                            package, "acquire_activate", "workflow_request"),
                               REGISTRY)
            other = RUST if package is TS else TS
            ok(result["status"] == "stopped" and
               package["package_id"] + "@" + package["version"] in result["notice"] and
               "manual or local-path installation route required" in result["notice"] and
               other["package_id"] not in result["notice"] and
               "frozen embedded" not in result["notice"],
               f"{package['label']} workflow stops visibly with its manual route",
               json.dumps(result))
        ok(unchanged(), "consumer unchanged after both containment stops")

        # ---- two-package installed route in one shared state root ----
        state = write_state(
            os.path.join(ROOT, "state"),
            [allowlist_entry(package, sources[package["package_id"]],
                             "card 120 two-package installed-route oracle")
             for package in PACKAGES])

        activated = {}
        for package in PACKAGES:
            result = host_call(ROOT, f"acquire-{package['language']}",
                               host_request(state, f"acquire-{package['language']}",
                                            package, "acquire_activate", "workflow_request"),
                               None)
            ok(result["status"] == "activated" and
               result["tree_digest"] == package["tree"] and
               result["manifest_digest"] == package["manifest"],
               f"{package['label']} acquisition activates with the exact pinned identity",
               json.dumps(result))
            activated[package["package_id"]] = result
        ok(activated[TS["package_id"]]["installed_path"] !=
           activated[RUST["package_id"]]["installed_path"],
           "the two packages install at independent addresses")
        ok(unchanged(), "consumer unchanged through both activations")

        for package in PACKAGES:
            result = host_call(ROOT, f"resolve-{package['language']}",
                               host_request(state, f"resolve-{package['language']}",
                                            package, "resolve", "workflow_request"),
                               REGISTRY)
            ok(result["status"] == "routed" and
               result["tree_digest"] == package["tree"] and
               result["installed_path"] == activated[package["package_id"]]["installed_path"],
               f"{package['label']} resolve routes local-only to its exact identity",
               json.dumps(result))
            inventory = payload_inventory(result["installed_path"])
            ok(spec034_tree_digest(result["installed_path"]) == package["tree"],
               f"installed {package['label']} payload reproduces the pinned tree digest")
            foreign = [rel for rel in inventory
                       if any(marker in rel for marker in package["foreign_markers"])]
            ok(not foreign,
               f"installed {package['label']} payload carries no {package['language'] == 'rust' and 'TypeScript' or 'Rust'} files",
               str(foreign[:5]))
            with open(os.path.join(state, "receipts",
                                   activated[package["package_id"]]["receipt_digest"] + ".json")) as handle:
                receipt = json.load(handle)
            ok(receipt["trust_class"]["type"] == "operator_allowlist" and
               receipt["source"]["path"] == sources[package["package_id"]],
               f"{package['label']} receipt records its provenance truthfully",
               json.dumps(receipt["trust_class"]))

        # ---- public installed-skill route: durable state + official git pins ----
        public_registry = json.loads(json.dumps(registry_doc))
        for entry in public_registry["packages"]:
            entry["repository"] = SIBLING
        public_registry_path = os.path.join(ROOT, "public-registry.json")
        with open(public_registry_path, "w") as handle:
            json.dump(public_registry, handle)
        public_state = os.path.join(ROOT, "public-state")
        public_results = {}
        for package in PACKAGES:
            result_path = os.path.join(ROOT, f"public-{package['language']}.json")
            routed = run([
                "effigy", "skill", "run", "--path", os.path.join(REPO, "skills", "northstar"),
                "northstar/language:route", "--repo", os.path.join(REPO, "skills", "northstar"),
                "--",
                "--registry", public_registry_path,
                "--consumer", consumer,
                "--state-root", public_state,
                "--language", package["language"],
                "--workflow", package["workflow"],
                "--json", result_path,
            ], check=False)
            result = json.load(open(result_path)) if os.path.exists(result_path) else {}
            ok(routed.returncode == 0 and result.get("status") == "activated" and
               result.get("tree_digest") == package["tree"] and
               os.path.isfile(result.get("entrypoint_path", "")),
               f"public route acquires and resolves the {package['label']} entrypoint",
               routed.stdout + routed.stderr)
            public_results[package["package_id"]] = result
        ok(public_results[TS["package_id"]].get("installed_path") !=
           public_results[RUST["package_id"]].get("installed_path"),
           "public route keeps official packages independently addressed")
        rust_tools = public_results[RUST["package_id"]].get("tools") or []
        rust_installed = public_results[RUST["package_id"]].get("installed_path", "")
        ok(len(rust_tools) == 1 and
           rust_tools[0].get("id") == "rust-quality" and
           os.path.isabs(rust_tools[0].get("path", "")) and
           os.path.isfile(rust_tools[0]["path"]) and
           os.access(rust_tools[0]["path"], os.X_OK) and
           not rust_tools[0]["path"].startswith(rust_installed + os.sep),
           "official Rust route returns its lifecycle-built absolute tool path",
           json.dumps(rust_tools))
        ok(spec034_tree_digest(rust_installed) == RUST["tree"],
           "Rust install keeps its pinned tree digest after the tool build")
        with open(os.path.join(public_state, "receipts",
                               public_results[RUST["package_id"]]["receipt_digest"] + ".json")) as handle:
            rust_receipt = json.load(handle)
        ok(rust_receipt.get("tools") and rust_receipt["tools"][0]["path"] == rust_tools[0]["path"],
           "Rust installation receipt records the built tool", json.dumps(rust_receipt.get("tools")))

        marker_consumer = os.path.join(ROOT, "marker-consumer")
        os.makedirs(os.path.join(marker_consumer, "docs/knowledge/contracts"))
        with open(os.path.join(marker_consumer, "AGENTS.md"), "w") as handle:
            handle.write("<!-- northstar:rust-quality:start -->\n<!-- northstar:rust-quality:end -->\n")
        with open(os.path.join(marker_consumer, "docs/knowledge/contracts",
                               "language-quality-activation.json"), "w") as handle:
            json.dump({
                "package_id": RUST["package_id"],
                "version": RUST["version"],
                "everyday_authoring": True,
            }, handle)
        marker_result_path = os.path.join(ROOT, "public-marker.json")
        marker_run = run([
            "effigy", "skill", "run", "--path", os.path.join(REPO, "skills", "northstar"),
            "northstar/language:route", "--repo", os.path.join(REPO, "skills", "northstar"),
            "--",
            "--registry", public_registry_path,
            "--consumer", marker_consumer,
            "--state-root", public_state,
            "--marker", "northstar:rust-quality",
            "--workflow", "everyday_authoring",
            "--json", marker_result_path,
        ], check=False)
        marker_result = json.load(open(marker_result_path)) if os.path.exists(marker_result_path) else {}
        ok(marker_run.returncode == 0 and marker_result.get("status") == "routed" and
           marker_result.get("package_id") == RUST["package_id"] and
           marker_result.get("workflow") == "everyday_authoring",
           "public route honors an exact AGENTS activation marker from durable state",
           marker_run.stdout + marker_run.stderr)

        # ---- everyday authoring is opt-in; a missing pack degrades, never blocks ----
        unopted = os.path.join(ROOT, "unopted-consumer")
        os.makedirs(unopted)
        unopted_path = os.path.join(ROOT, "unopted.json")
        unopted_run = run([
            "effigy", "skill", "run", "--path", os.path.join(REPO, "skills", "northstar"),
            "northstar/language:route", "--repo", os.path.join(REPO, "skills", "northstar"),
            "--",
            "--registry", public_registry_path,
            "--consumer", unopted,
            "--state-root", public_state,
            "--language", "rust",
            "--workflow", "everyday_authoring",
            "--json", unopted_path,
        ], check=False)
        unopted_result = json.load(open(unopted_path)) if os.path.exists(unopted_path) else {}
        ok(unopted_run.returncode == 0 and unopted_result.get("status") == "unavailable" and
           "opt-in" in unopted_result.get("notice", "") and
           unopted_result.get("tools") == [],
           "everyday authoring without the repository setting is unavailable and exits clean",
           unopted_run.stdout + unopted_run.stderr)

        # A repository that opted in keeps working when the pack cannot resolve:
        # everyday reports the failure and points at its own validation while the
        # explicit audit route still fails closed.
        no_rust_registry = json.loads(json.dumps(public_registry))
        no_rust_registry["packages"] = [entry for entry in no_rust_registry["packages"]
                                        if entry["package_id"] != RUST["package_id"]]
        no_rust_path = os.path.join(ROOT, "no-rust-registry.json")
        with open(no_rust_path, "w") as handle:
            json.dump(no_rust_registry, handle)
        degraded_state = os.path.join(ROOT, "degraded-state")
        degraded_path = os.path.join(ROOT, "degraded.json")
        degraded_run = run([
            "effigy", "skill", "run", "--path", os.path.join(REPO, "skills", "northstar"),
            "northstar/language:route", "--repo", os.path.join(REPO, "skills", "northstar"),
            "--",
            "--registry", no_rust_path,
            "--consumer", marker_consumer,
            "--state-root", degraded_state,
            "--language", "rust",
            "--workflow", "everyday_authoring",
            "--json", degraded_path,
        ], check=False)
        degraded_result = json.load(open(degraded_path)) if os.path.exists(degraded_path) else {}
        ok(degraded_run.returncode == 0 and degraded_result.get("status") == "degraded" and
           "Validate" in degraded_result.get("notice", "") and
           "installed_path" in degraded_result and degraded_result["installed_path"] is None,
           "an opted-in everyday route degrades to repository validation when the pack cannot resolve",
           degraded_run.stdout + degraded_run.stderr)
        audit_path = os.path.join(ROOT, "degraded-audit.json")
        audit_run = run([
            "effigy", "skill", "run", "--path", os.path.join(REPO, "skills", "northstar"),
            "northstar/language:route", "--repo", os.path.join(REPO, "skills", "northstar"),
            "--",
            "--registry", no_rust_path,
            "--consumer", marker_consumer,
            "--state-root", degraded_state,
            "--language", "rust",
            "--workflow", "explicit_audit_repair",
            "--json", audit_path,
        ], check=False)
        ok(audit_run.returncode != 0 and not os.path.exists(audit_path),
           "explicit audit still fails closed when the pack cannot resolve",
           audit_run.stdout + audit_run.stderr)

        # Registry resolution failures stay inside the everyday fallback:
        # missing and malformed registry files degrade an opted-in consumer,
        # while explicit audit and an unopted consumer keep their behaviour.
        malformed_registry = os.path.join(ROOT, "malformed-registry.json")
        with open(malformed_registry, "w") as handle:
            handle.write("{not json")

        def route_with_registry(name, consumer_dir, registry_path, workflow):
            output = os.path.join(ROOT, name + ".json")
            result = run([
                "effigy", "skill", "run", "--path", os.path.join(REPO, "skills", "northstar"),
                "northstar/language:route", "--repo", os.path.join(REPO, "skills", "northstar"),
                "--",
                "--registry", registry_path,
                "--consumer", consumer_dir,
                "--state-root", os.path.join(ROOT, name + "-state"),
                "--language", "rust",
                "--workflow", workflow,
                "--json", output,
            ], check=False)
            parsed = json.load(open(output)) if os.path.exists(output) else {}
            return result, parsed

        missing_registry = os.path.join(ROOT, "no-such-registry.json")
        for name, registry_path in (
                ("degraded-missing-registry", missing_registry),
                ("degraded-malformed-registry", malformed_registry)):
            result, parsed = route_with_registry(name, marker_consumer, registry_path,
                                                 "everyday_authoring")
            ok(result.returncode == 0 and parsed.get("status") == "degraded" and
               "Validate" in parsed.get("notice", ""),
               f"everyday route degrades on {name.split('-', 1)[1]}",
               result.stdout + result.stderr)
        result, parsed = route_with_registry("audit-malformed-registry", marker_consumer,
                                             malformed_registry, "explicit_audit_repair")
        ok(result.returncode != 0 and not parsed,
           "explicit audit fails closed on a malformed registry",
           result.stdout + result.stderr)
        result, parsed = route_with_registry("unopted-missing-registry", unopted,
                                             missing_registry, "everyday_authoring")
        ok(result.returncode == 0 and parsed.get("status") == "unavailable" and
           "opt-in" in parsed.get("notice", ""),
           "an unopted everyday route is unavailable even when the registry is missing",
           result.stdout + result.stderr)
        with open(os.path.join(public_state, "lifecycle-state.json")) as handle:
            public_lifecycle = json.load(handle)
        ok(len(public_lifecycle.get("packages", [])) == 2 and
           all(ref.get("selection") == "selected" for ref in public_lifecycle["packages"]),
           "public route persists both selected packages in one operator state root",
           json.dumps(public_lifecycle))

        # ---- drift is scoped to one package; the other keeps routing ----
        ts_probe = os.path.join(activated[TS["package_id"]]["installed_path"],
                                "references/language-quality/typescript/catalogue.json")
        with open(ts_probe, "rb") as handle:
            original = handle.read()
        with open(ts_probe, "ab") as handle:
            handle.write(b"\n<!-- drift -->\n")
        drifted_ts = host_call(ROOT, "resolve-ts-drift",
                               host_request(state, "resolve-ts-drift", TS,
                                            "resolve", "workflow_request"), REGISTRY)
        ok(drifted_ts["status"] == "stopped",
           "drifted TypeScript bytes stop the TypeScript route", json.dumps(drifted_ts))
        rust_still = host_call(ROOT, "resolve-rust-alongside-drift",
                               host_request(state, "resolve-rust-alongside-drift", RUST,
                                            "resolve", "workflow_request"), REGISTRY)
        ok(rust_still["status"] == "routed" and rust_still["tree_digest"] == RUST["tree"],
           "Rust route is unaffected by TypeScript drift", json.dumps(rust_still))
        with open(ts_probe, "wb") as handle:
            handle.write(original)
        restored_ts = host_call(ROOT, "resolve-ts-restored",
                                host_request(state, "resolve-ts-restored", TS,
                                             "resolve", "workflow_request"), REGISTRY)
        ok(restored_ts["status"] == "routed" and restored_ts["tree_digest"] == TS["tree"],
           "byte-exact restore reopens the TypeScript route", json.dumps(restored_ts))

        # ---- each package's reviewed installed-route prover ----
        parity_root = REPO
        common_dir = run(["git", "-C", REPO, "rev-parse", "--git-common-dir"], check=False)
        if common_dir.returncode == 0 and not os.path.isdir(os.path.join(REPO, ".git")):
            parity_root = os.path.dirname(os.path.abspath(common_dir.stdout.strip()))
        os.symlink(parity_root, os.path.join(state, "northstar"))
        for package in PACKAGES:
            installed = activated[package["package_id"]]["installed_path"]
            prover = run(["sh", os.path.join(installed, "scripts", "prove-installed-invocation.sh"),
                          installed, package["tree"]], check=False)
            ok(prover.returncode == 0 and
               f"{package['label']} quality installed route: OK" in prover.stdout + prover.stderr,
               f"{package['label']} installed-route prover passes on the installed payload",
               (prover.stdout + prover.stderr)[-1500:])

        ok(unchanged(), "consumer byte-identical at the end of the transcript")
        print(f"language package routes oracle: {'PASS' if failures == 0 else 'FAIL'} ({failures} failures)")
        return 0 if failures == 0 else 1
    finally:
        shutil.rmtree(ROOT, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
