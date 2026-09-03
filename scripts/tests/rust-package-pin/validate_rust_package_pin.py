#!/usr/bin/env python3
"""Card 119 deterministic real-package lifecycle oracle.

Replays the accepted @northstar/rust-quality 0.1.0 registry promotion against
the read-only package-source sibling: materializes the pinned merge, reproduces
both spec-034 digests with an independent implementation, drives the public
language-package-host.v1 surface through acquisition, both workflow routes,
offline routing, drift, refusal, retained inventory, and the frozen fallback,
then runs the package's reviewed installed-route prover on the installed
payload. Fails on any deviation; mutates nothing outside its temp root.
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
PIN_COMMIT = "56b2e1107b80f369807cff88e1b0253df035c700"
PIN_TREE = "sha256:e5cf9c5da4a30c0f5164f2ea0c5e9d87d544c0c32f09f3c139a386c56154dba0"
PIN_MANIFEST = "sha256:dd71d04efd67cc7805f417a79666dd920ea1811ee252d941108dfbeca8aab612"
PACKAGE_ID = "@northstar/rust-quality"
PIN_VERSION = "0.1.0"
SURFACE = os.path.join(REPO, "skills/northstar/scripts/language-package-lifecycle.ts")
REGISTRY = os.path.join(REPO, "skills/northstar/references/packages/official-registry.json")
OVERLAP = os.path.join(REPO, "skills/northstar/references/packages/overlap-windows.json")
FALLBACK = os.path.join(REPO, "skills/northstar/assets/fixtures/language-packages/fallback")

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


def git_object_framing_digests(repo, commit):
    """Independent spec-034 digest reproduction from the git object store."""
    listing = run(["git", "-C", repo, "ls-tree", "-r", "-z", commit, "--", "packages/rust"]).stdout
    entries = []
    for record in listing.split("\0"):
        if not record:
            continue
        meta, path = record.split("\t", 1)
        mode, _otype, osha = meta.split()
        entries.append((path[len("packages/rust/"):].encode(), mode, osha))
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
    manifest_line = run(["git", "-C", repo, "ls-tree", commit, "--", "packages/rust/northstar-package.json"]).stdout
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
    state = root
    os.makedirs(state, exist_ok=True)
    trust = {"schema_version": "1.0.0", "revision": "1", "allowlist": allowlist, "revocations": []}
    with open(os.path.join(state, "operator-trust.json"), "w") as handle:
        json.dump(trust, handle)
    return state


def allowlist_entry(version, path, tree, manifest, reason="card 119 registry-promotion real-package oracle"):
    return {
        "package_id": PACKAGE_ID,
        "version": version,
        "source_identity": {"type": "local_path", "path": path},
        "tree_digest": tree,
        "manifest_digest": manifest,
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


def host_request(state, name, operation, intent, **overrides):
    base = {
        "protocol_version": "1.0.0",
        "request_id": f"req-rust-pin-oracle-{name}",
        "operation": operation,
        "intent": intent,
        "package_id": PACKAGE_ID,
        "version": PIN_VERSION,
        "language": "rust",
        "workflow": "explicit_audit_repair",
        "core_version": "0.2.0",
        "consumer_dir": os.path.join(ROOT, "consumer"),
        "state_root": state,
    }
    base.update(overrides)
    return base


def snapshot(directory):
    hashes = []
    for dirpath, _dirnames, filenames in os.walk(directory):
        for name in filenames:
            full = os.path.join(dirpath, name)
            with open(full, "rb") as handle:
                hashes.append(os.path.relpath(full, directory) + " " + hashlib.sha256(handle.read()).hexdigest())
    return sorted(hashes)


def main():
    global ROOT
    missing = [name for name in ("bun", "effigy", "cargo", "git", "python3") if shutil.which(name) is None]
    ok(not missing, "required tools present", f"missing {missing}")
    if missing:
        return 1

    ok(os.path.isdir(os.path.join(SIBLING, ".git")), "package-source sibling resolved", SIBLING)
    if run(["git", "-C", SIBLING, "cat-file", "-e", f"{PIN_COMMIT}^{{commit}}"], check=False).returncode != 0:
        run(["git", "-C", SIBLING, "fetch", "origin"])
    run(["git", "-C", SIBLING, "cat-file", "-e", f"{PIN_COMMIT}^{{commit}}"])
    print("PASS accepted merge present in the sibling object store")

    ROOT = tempfile.mkdtemp(prefix="rust-pin-oracle-")
    try:
        source = os.path.join(ROOT, "src", "packages", "rust")
        archive = subprocess.run(["git", "-C", SIBLING, "archive", PIN_COMMIT, "packages/rust"],
                                 capture_output=True, check=True).stdout
        source_parent = os.path.join(ROOT, "src")
        os.makedirs(source_parent)
        source = os.path.join(source_parent, "packages", "rust")
        archive = subprocess.run(["git", "-C", SIBLING, "archive", PIN_COMMIT, "packages/rust"],
                                 capture_output=True, check=True).stdout
        extraction = subprocess.run(["tar", "-x", "-C", source_parent], input=archive)
        if extraction.returncode != 0:
            raise RuntimeError("git archive extraction failed")
        tree, manifest, expected_files = git_object_framing_digests(SIBLING, PIN_COMMIT)
        ok(tree == PIN_TREE and manifest == PIN_MANIFEST and len(expected_files) == 59,
           "independent spec-034 digests reproduce the pin (59 files)",
           f"tree {tree} manifest {manifest}")

        consumer = os.path.join(ROOT, "consumer")
        os.makedirs(os.path.join(consumer, "src"))
        with open(os.path.join(consumer, "marker.txt"), "w") as handle:
            handle.write("card-119 consumer marker\n")
        with open(os.path.join(consumer, "src", "lib.rs"), "w") as handle:
            handle.write("pub fn x() {}\n")
        before = snapshot(consumer)

        def unchanged():
            return snapshot(consumer) == before

        good = allowlist_entry(PIN_VERSION, source, PIN_TREE, PIN_MANIFEST)
        state = write_state(os.path.join(ROOT, "state"), [])

        result = host_call(ROOT, "official-stop",
                           host_request(state, "official-stop", "acquire_activate", "workflow_request"), REGISTRY)
        ok(result["status"] == "stopped"
           and "@northstar/rust-quality@0.1.0" in result["notice"]
           and "manual or local-path installation route required" in result["notice"]
           and "frozen embedded" not in result["notice"],
           "official git-source acquire stops visibly with the manual route", json.dumps(result))
        result = host_call(ROOT, "detection",
                           host_request(state, "detection", "acquire_activate", "detection"), REGISTRY)
        ok(result["status"] == "stopped" and "no acquisition without explicit workflow intent" in result["notice"],
           "detection never acquires", json.dumps(result))
        ok(unchanged(), "consumer unchanged after failure cases")

        state = write_state(state, [good])
        result = host_call(ROOT, "bypass",
                           host_request(state, "bypass", "acquire_activate", "workflow_request"), REGISTRY)
        ok(result["status"] == "stopped" and "manual or local-path installation route required" in result["notice"],
           "allowlist cannot bypass the official pin", json.dumps(result))
        ok(unchanged(), "consumer unchanged after bypass attempt")

        result = host_call(ROOT, "acquire",
                           host_request(state, "acquire", "acquire_activate", "workflow_request"), None)
        ok(result["status"] == "activated"
           and result["tree_digest"] == PIN_TREE and result["manifest_digest"] == PIN_MANIFEST,
           "real acquisition activates with the exact pinned identity including the real self-check", json.dumps(result))
        if result["status"] != "activated":
            return 1
        with open(os.path.join(state, "receipts", result["receipt_digest"] + ".json")) as handle:
            receipt = json.load(handle)
        ok(receipt["trust_class"]["type"] == "operator_allowlist" and receipt["source"]["path"] == source,
           "receipt records its provenance truthfully", json.dumps(receipt["trust_class"]))
        installed = result["installed_path"]
        ok(spec034_tree_digest(installed) == PIN_TREE, "installed tree digest matches the pin")

        result = host_call(ROOT, "resolve-offline",
                           host_request(state, "resolve-offline", "resolve", "workflow_request"), None)
        ok(result["status"] == "routed" and result["tree_digest"] == PIN_TREE and result["installed_path"] == installed,
           "offline resolve routes local-only to the exact identity", json.dumps(result))
        result = host_call(ROOT, "resolve-audit",
                           host_request(state, "resolve-audit", "resolve", "workflow_request"), REGISTRY)
        ok(result["status"] == "routed" and result["tree_digest"] == PIN_TREE,
           "explicit audit resolve routes through the shipped registry", json.dumps(result))
        result = host_call(ROOT, "resolve-authoring",
                           host_request(state, "resolve-authoring", "resolve", "workflow_request",
                                        workflow="everyday_authoring"), REGISTRY)
        ok(result["status"] == "routed" and result["tree_digest"] == PIN_TREE,
           "everyday authoring resolve routes to the same identity", json.dumps(result))

        probe = os.path.join(installed, "references/language-quality/rust/catalogue.json")
        with open(probe, "rb") as handle:
            original = handle.read()
        with open(probe, "ab") as handle:
            handle.write(b"\n<!-- drift -->\n")
        result = host_call(ROOT, "resolve-drift",
                           host_request(state, "resolve-drift", "resolve", "workflow_request"), REGISTRY)
        ok(result["status"] == "stopped", "drifted installed bytes stop the route", json.dumps(result))
        with open(probe, "wb") as handle:
            handle.write(original)
        result = host_call(ROOT, "resolve-restored",
                           host_request(state, "resolve-restored", "resolve", "workflow_request"), REGISTRY)
        ok(result["status"] == "routed" and result["tree_digest"] == PIN_TREE,
           "byte-exact restore reopens the route", json.dumps(result))

        ts_state = write_state(os.path.join(ROOT, "state-ts"), [{
            "package_id": "@northstar/typescript-quality",
            "version": "0.1.0",
            "source_identity": {"type": "local_path", "path": source},
            "tree_digest": "sha256:259cccdbacd7e2e293389efaf72cab005d0c275bd7cb600c99f30bfbfe071843",
            "manifest_digest": "sha256:e5e32f2baeda2e901b8c327436adf0bfd5955a9de080887660684ad4583185ca",
            "compatible_core_range": ">=0.2.0 <1.0.0",
            "actor": "northstar-source-qa",
            "timestamp": "2026-09-03T00:00:00Z",
            "reason": "TypeScript-under-Rust identity guard negative",
        }])
        result = host_call(ROOT, "ts-guard",
                           host_request(ts_state, "ts-guard", "acquire_activate", "workflow_request",
                                        package_id="@northstar/typescript-quality"), None)
        ok(result["status"] == "stopped" and "staged manifest identity does not match pin" in result["notice"],
           "a TypeScript request never activates from the Rust tree", json.dumps(result))

        wrong_tree = write_state(os.path.join(ROOT, "state-wrong-tree"),
                                 [allowlist_entry(PIN_VERSION, source, "sha256:" + "0" * 64, PIN_MANIFEST,
                                                  reason="wrong-tree negative")])
        result = host_call(ROOT, "wrong-tree",
                           host_request(wrong_tree, "wrong-tree", "acquire_activate", "workflow_request"), None)
        ok(result["status"] == "stopped" and "staged tree identity does not match pin" in result["notice"],
           "wrong tree digest fails closed", json.dumps(result))
        wrong_manifest = write_state(os.path.join(ROOT, "state-wrong-manifest"),
                                     [allowlist_entry(PIN_VERSION, source, PIN_TREE, "sha256:" + "0" * 64,
                                                      reason="wrong-manifest negative")])
        result = host_call(ROOT, "wrong-manifest",
                           host_request(wrong_manifest, "wrong-manifest", "acquire_activate", "workflow_request"), None)
        ok(result["status"] == "stopped" and "staged manifest identity does not match pin" in result["notice"],
           "wrong manifest digest fails closed", json.dumps(result))

        variant = os.path.join(ROOT, "variant")
        shutil.copytree(source, variant)
        with open(os.path.join(source, "northstar-package.json")) as handle:
            variant_manifest = json.load(handle)
        variant_manifest["version"] = "0.2.0"
        with open(os.path.join(variant, "northstar-package.json"), "w") as handle:
            json.dump(variant_manifest, handle, indent=2)
            handle.write("\n")
        variant_tree = spec034_tree_digest(variant)
        with open(os.path.join(variant, "northstar-package.json"), "rb") as handle:
            variant_manifest_digest = "sha256:" + hashlib.sha256(handle.read()).hexdigest()
        write_state(state, [good, allowlist_entry("0.2.0", variant, variant_tree, variant_manifest_digest,
                                                  reason="version-drifted variant negative")])
        result = host_call(ROOT, "variant-update",
                           host_request(state, "variant-update", "acquire_activate", "workflow_request",
                                        version="0.2.0"), None)
        ok(result["status"] == "stopped" and "package version drifted" in result["notice"],
           "version-drifted variant refused by the package's own self-check", json.dumps(result))
        ok(unchanged(), "consumer unchanged through the refused update")

        notice_path = os.path.join(ROOT, "fallback-notice.txt")
        fallback = run(["bun", SURFACE, "fallback",
                        os.path.join(FALLBACK, "rust-quality-shaped-request.json"),
                        os.path.join(FALLBACK, "rust-quality-shaped-result.json"),
                        OVERLAP, notice_path], check=False)
        notice = open(notice_path).read() if os.path.exists(notice_path) else ""
        ok(fallback.returncode == 0
           and "@northstar/rust-quality@0.1.0" in notice
           and "manual or local-path installation route required" in notice
           and "using the frozen embedded Rust payload during the bounded overlap window" in notice,
           "frozen fallback notice names the failed identity and the frozen Rust payload", notice)

        inventory = run(["python3", "-c", INVARIANT_SNIPPET, state, source])
        ok(inventory.returncode == 0, "Rust-only retained inventory (exact 59-file payload, no TypeScript)",
           inventory.stdout + inventory.stderr)

        parity_root = REPO
        common_dir = run(["git", "-C", REPO, "rev-parse", "--git-common-dir"], check=False)
        if common_dir.returncode == 0 and not os.path.isdir(os.path.join(REPO, ".git")):
            parity_root = os.path.dirname(os.path.abspath(common_dir.stdout.strip()))
        os.symlink(parity_root, os.path.join(state, "northstar"))
        prover = run(["sh", os.path.join(installed, "scripts", "prove-installed-invocation.sh"),
                      installed, PIN_TREE], check=False)
        ok(prover.returncode == 0 and "Rust quality installed route: OK" in prover.stdout + prover.stderr,
           "package installed-route prover passes on the installed payload",
           (prover.stdout + prover.stderr)[-1500:])

        ok(unchanged(), "consumer byte-identical at the end of the transcript")
        print(f"rust package pin oracle: {'PASS' if failures == 0 else 'FAIL'} ({failures} failures)")
        return 0 if failures == 0 else 1
    finally:
        shutil.rmtree(ROOT, ignore_errors=True)


INVARIANT_SNIPPET = """
import hashlib, os, sys
state, src = sys.argv[1], sys.argv[2]
expected = {}
for dirpath, _dirnames, filenames in os.walk(src):
    for name in filenames:
        full = os.path.join(dirpath, name)
        expected[os.path.relpath(full, src)] = hashlib.sha256(open(full, 'rb').read()).hexdigest()
installed_root = os.path.join(state, 'installed')
assert os.listdir(installed_root) == ['@northstar'], os.listdir(installed_root)
pkg_dirs = os.listdir(os.path.join(installed_root, '@northstar'))
assert len(pkg_dirs) == 1 and pkg_dirs[0].startswith('rust-quality@0.1.0-'), pkg_dirs
payload = os.path.join(installed_root, '@northstar', pkg_dirs[0])
seen = {}
for dirpath, dirnames, filenames in os.walk(payload):
    assert '.effigy' not in dirnames, '.effigy pollution'
    assert 'target' not in dirnames, 'cargo target pollution'
    for name in filenames:
        full = os.path.join(dirpath, name)
        seen[os.path.relpath(full, payload)] = hashlib.sha256(open(full, 'rb').read()).hexdigest()
assert seen == expected, 'installed inventory differs from the pinned tree'
assert sorted(os.listdir(state)) == ['installed', 'lifecycle-state.json', 'operator-trust.json', 'receipts']
for dirpath, dirnames, filenames in os.walk(state):
    for name in dirnames + filenames:
        lowered = name.lower()
        assert 'typescript' not in lowered and 'svelte' not in lowered, name
print('inventory ok: %d files' % len(seen))
"""

if __name__ == "__main__":
    sys.exit(main())
