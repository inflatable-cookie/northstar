#!/usr/bin/env python3
# Provider-neutral language-package-host.v1 conforming host (reference 2).
#
# Implements the resolve operation of the language package host protocol with
# the Python standard library only: canonical manifest/tree digests over exact
# bytes, operator-owned lifecycle state, immutable digest-addressed receipts,
# revocation, semver compatibility, and manifest-field matching. A host that
# lacks a required capability returns a scoped `stopped` result instead of
# failing. No bundled language runtime or control plane is a consumer
# prerequisite: this file runs under any python3 and proves the protocol is
# host-neutral.
#
# usage: language-package-host.py <request-file> <result-file> [capability-denial]
#   capability-denial: comma-separated capability names to deny (e.g. atomic)

import hashlib
import json
import os
import re
import stat
import sys

PROTOCOL_VERSION = "1.0.0"
PORTABLE_PATH = re.compile(r"^[a-zA-Z0-9_-][a-zA-Z0-9_.-]*(?:/[a-zA-Z0-9_-][a-zA-Z0-9_.-]*)*$")
SEMVER = re.compile(r"^[0-9]+\.[0-9]+\.[0-9]+$")
PACKAGE_ID = re.compile(r"^@[a-z0-9-]+/[a-z0-9-]+$")
DIGEST = re.compile(r"^sha256:[0-9a-f]{64}$")

OP_CAPABILITIES = {
    "resolve": ["catalogue", "identity"],
    "acquire_activate": ["catalogue", "identity", "atomic", "process", "acquisition"],
    "rollback": ["catalogue", "identity", "atomic"],
}


def notice(message):
    sys.stdout.write("[northstar:language-packages] notice: " + message + "\n")


def sha256_hex(data):
    return hashlib.sha256(data).hexdigest()


def file_bytes(path):
    with open(path, "rb") as handle:
        return handle.read()


def manifest_digest_of(manifest_path):
    return "sha256:" + sha256_hex(file_bytes(manifest_path))


def is_safe_relative_path(value):
    if not isinstance(value, str) or value == "":
        return False
    if value.startswith("/") or value.startswith("\\") or "//" in value or value.endswith("/"):
        return False
    for part in value.split("/"):
        if part in ("", ".", ".."):
            return False
    return PORTABLE_PATH.match(value) is not None


def collect_file_records(package_root):
    records = []
    seen_fold = set()
    for dirpath, dirnames, filenames in os.walk(package_root):
        for name in filenames:
            full = os.path.join(dirpath, name)
            rel = os.path.relpath(full, package_root).replace(os.sep, "/")
            mode = os.lstat(full).st_mode
            if stat.S_ISLNK(mode):
                raise RuntimeError("symbolic link (rejected, never followed): " + rel)
            if not stat.S_ISREG(mode):
                raise RuntimeError("special file (rejected): " + rel)
            if not is_safe_relative_path(rel):
                raise RuntimeError("non-portable package path: " + rel)
            fold = rel.lower()
            if fold in seen_fold:
                raise RuntimeError("case-fold path collision: " + rel)
            seen_fold.add(fold)
            executable = 1 if (mode & 0o111) else 0
            with open(full, "rb") as handle:
                content = handle.read()
            records.append((rel.encode("utf-8"), executable, content))
    records.sort(key=lambda r: r[0])
    return records


def canonical_tree_digest(package_root):
    chunks = []
    for path_bytes, executable, content in collect_file_records(package_root):
        chunks.append(b"F\0")
        chunks.append(str(len(path_bytes)).encode())
        chunks.append(b"\0")
        chunks.append(path_bytes)
        chunks.append(b"\0")
        chunks.append(str(executable).encode())
        chunks.append(b"\0")
        chunks.append(str(len(content)).encode())
        chunks.append(b"\0")
        chunks.append(content)
    return "sha256:" + sha256_hex(b"".join(chunks))


def parse_semver(value):
    if not SEMVER.match(value):
        return None
    return [int(part) for part in value.split(".")]


def semver_compatible(range_str, core_version):
    core = parse_semver(core_version)
    if core is None:
        return False
    if range_str == "*":
        return True
    if SEMVER.match(range_str):
        return core == parse_semver(range_str)
    caret = re.match(r"^\^([0-9]+\.[0-9]+\.[0-9]+)$", range_str)
    if caret:
        base = parse_semver(caret.group(1))
        if base is None or core < base:
            return False
        if base[0] > 0:
            return core[0] < base[0] + 1
        if base[1] > 0:
            return core[0] == 0 and core[1] < base[1] + 1
        return core[0] == 0 and core[1] == 0 and core[2] < base[2] + 1
    bounded = re.match(r"^>=([0-9]+\.[0-9]+\.[0-9]+) <([0-9]+\.[0-9]+\.[0-9]+)$", range_str)
    if bounded:
        minimum = parse_semver(bounded.group(1))
        maximum = parse_semver(bounded.group(2))
        return minimum is not None and maximum is not None and minimum <= core < maximum
    ge = re.match(r"^>=([0-9]+\.[0-9]+\.[0-9]+)$", range_str)
    if ge:
        minimum = parse_semver(ge.group(1))
        return minimum is not None and core >= minimum
    lt = re.match(r"^<([0-9]+\.[0-9]+\.[0-9]+)$", range_str)
    if lt:
        maximum = parse_semver(lt.group(1))
        return maximum is not None and core < maximum
    return False


def parse_trust_doc(raw):
    doc = raw if isinstance(raw, dict) else {}
    return {"schema_version": "1.0.0", "revision": "0", "allowlist": [], "revocations": [],
            **{k: v for k, v in doc.items() if k in ("schema_version", "revision", "allowlist", "revocations")}}


def host_trust_doc(state_root):
    path = os.path.join(state_root, "operator-trust.json")
    if not os.path.isfile(path):
        return {"schema_version": "1.0.0", "revision": "0", "allowlist": [], "revocations": []}
    with open(path, "r", encoding="utf-8") as handle:
        return parse_trust_doc(json.load(handle))


def find_revocation(trust_doc, package_id, tree_digest, manifest_digest):
    for rec in trust_doc.get("revocations", []):
        if rec.get("package_id") == package_id and rec.get("tree_digest") == tree_digest and rec.get("manifest_digest") == manifest_digest:
            return rec
    return None


def read_state_doc(state_root):
    path = os.path.join(state_root, "lifecycle-state.json")
    if not os.path.isfile(path):
        return None
    with open(path, "r", encoding="utf-8") as handle:
        return json.load(handle)


def load_receipt(state_root, receipt_digest):
    if not isinstance(receipt_digest, str) or not DIGEST.match(receipt_digest):
        return None
    path = os.path.join(state_root, "receipts", receipt_digest + ".json")
    if not os.path.isfile(path):
        return None
    body = file_bytes(path)
    if sha256_hex(body) != receipt_digest[7:]:
        return None
    try:
        return json.loads(body.decode("utf-8"))
    except Exception:
        return None


def verify_installed_identity(installed_path, reference):
    manifest_path = os.path.join(installed_path, "northstar-package.json")
    if not os.path.isdir(installed_path) or not os.path.isfile(manifest_path):
        raise RuntimeError("installed manifest missing")
    if not isinstance(reference.get("tree_digest"), str) or not DIGEST.match(reference["tree_digest"]):
        raise RuntimeError("non-canonical tree digest")
    if not isinstance(reference.get("manifest_digest"), str) or not DIGEST.match(reference["manifest_digest"]):
        raise RuntimeError("non-canonical manifest digest")
    if manifest_digest_of(manifest_path) != reference["manifest_digest"]:
        raise RuntimeError("installed manifest identity drifted from receipt")
    if canonical_tree_digest(installed_path) != reference["tree_digest"]:
        raise RuntimeError("installed tree identity drifted from receipt")
    with open(manifest_path, "r", encoding="utf-8") as handle:
        return json.load(handle)


def receipt_matches(receipt, reference):
    return (isinstance(receipt, dict) and receipt.get("package_id") == reference.get("package_id")
            and receipt.get("version") == reference.get("version")
            and isinstance(receipt.get("content_identity"), dict)
            and receipt["content_identity"].get("package_tree_digest") == reference.get("tree_digest")
            and receipt["content_identity"].get("manifest_digest") == reference.get("manifest_digest")
            and isinstance(receipt.get("installation"), dict)
            and receipt["installation"].get("installed_path") == reference.get("installed_path"))


def resolve_installed(state_root, trust_doc, package_id, version, language, workflow, core_version):
    state_doc = read_state_doc(state_root)
    if state_doc is None:
        return None
    for reference in state_doc.get("packages", []):
        if reference.get("package_id") != package_id or reference.get("version") != version:
            continue
        if reference.get("selection") != "selected":
            continue
        if find_revocation(trust_doc, package_id, reference.get("tree_digest"), reference.get("manifest_digest")):
            continue
        receipt = load_receipt(state_root, reference.get("receipt_digest"))
        if receipt is None or not receipt_matches(receipt, reference):
            continue
        manifest = verify_installed_identity(reference.get("installed_path"), reference)
        if manifest.get("kind") != "language-quality":
            continue
        if language not in manifest.get("supported_languages", []):
            continue
        if workflow not in manifest.get("available_workflows", []):
            continue
        if manifest.get("package_id") != package_id or manifest.get("version") != version:
            continue
        if not semver_compatible(manifest.get("compatible_core_range", ""), core_version):
            continue
        return reference, manifest, receipt
    return None


def execute_host_request(request, denied):
    operation = request.get("operation")
    missing = [cap for cap in OP_CAPABILITIES.get(operation, []) if cap in denied]
    if missing:
        message = "host capability missing: " + missing[0] + " for operation " + operation
        notice(message)
        return {"protocol_version": PROTOCOL_VERSION, "status": "stopped", "notice": message}
    try:
        state_root = request["state_root"]
        trust_doc = host_trust_doc(state_root)
        resolved = resolve_installed(state_root, trust_doc, request["package_id"], request["version"],
                                     request["language"], request["workflow"], request["core_version"])
        if resolved is None:
            message = "no compatible installed package for " + request["package_id"] + "@" + request["version"] + " (" + request["workflow"] + ")"
            notice(message)
            return {"protocol_version": PROTOCOL_VERSION, "status": "stopped", "notice": message}
        reference, _manifest, _receipt = resolved
        message = "routed " + request["package_id"] + " " + request["workflow"] + " local-only identity=" + reference["tree_digest"]
        notice(message)
        return {
            "protocol_version": PROTOCOL_VERSION,
            "status": "routed",
            "notice": message,
            "tree_digest": reference["tree_digest"],
            "manifest_digest": reference["manifest_digest"],
            "installed_path": reference["installed_path"],
            "receipt_digest": reference["receipt_digest"],
        }
    except Exception as err:  # noqa: BLE001 - protocol stops scoped on any host failure
        message = "workflow " + request.get("workflow", "?") + " for " + request.get("package_id", "?") + " stopped: " + str(err)
        notice(message)
        return {"protocol_version": PROTOCOL_VERSION, "status": "stopped", "notice": message}


def main(argv):
    if len(argv) < 2:
        raise SystemExit("usage: language-package-host.py <request-file> <result-file> [capability-denial]")
    with open(argv[0], "r", encoding="utf-8") as handle:
        request = json.load(handle)
    denied = set()
    if len(argv) >= 3 and argv[2]:
        denied = set(argv[2].split(","))
    result = execute_host_request(request, denied)
    with open(argv[1], "w", encoding="utf-8") as handle:
        json.dump(result, handle)
        handle.write("\n")


if __name__ == "__main__":
    main(sys.argv[1:])
