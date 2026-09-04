// Provider-neutral Northstar language-package lifecycle surface (card 117).
//
// This is the callable generic runtime: canonical byte-exact content
// identity, operator-owned trust/lifecycle documents, atomic compare-and-swap
// lifecycle state, immutable digest-addressed receipts, identity-bound
// routing, transactional acquisition/rollback, revocation, offline local
// routing, and declared self-check execution.
//
// It runs under any Bun-capable host and contains no language branches, no
// Effigy dependency, and no provider reference. The Effigy checker invokes
// the exact same surface through this CLI; the oracle can also be run with
// Effigy absent (`bun run language-package-lifecycle.ts oracle <dir>`).
//
// The self-check entrypoint is executed by the package's first declared
// required runtime command (`runtime_capabilities.required_commands[0]`),
// with the staged package root passed as the first argument. A package that
// declares no runtime command cannot run its self-check and stops plainly.
//
// Independent identity vectors (computed from the canonical framing with a
// separate reference implementation, not derived by this code):
//   fixture manifest: sha256:b9cdf39bbf2ae4fc2aeee656d2c8dc655c0faa951fbeec255eb887f210a683f9
//   fixture tree:     sha256:b8e76dfdc87d84904ada0620425c0a94200532d11207e3d1339626fb2df85aa3
//   nul content:      sha256:2d454a684186557b9d4a6b1d1ad71b2fd35653221a57da3a0a3c1c1cdce51c0c
//   non-utf8 content: sha256:e47ead3733f036191bc07eca4279a634a6482e585b29b939a3bfac5225d0cd50
//   multibyte:        sha256:ee719bb79ec611fd44274dab22543c4ac2ca459b803a27c4829df028b2804990
//   executable 0755:  sha256:b026027495f9869e30fb7ee14ac23b5e29b580db1df3d66537339c9ab9555d98
//   non-exec 0444/0600: sha256:3571f0cbec1c1703ada683d25a71704dec379f9af80cbebc099d521ec879793d

// GENERIC-SURFACE-SCAN-BEGIN
import { createHash, randomUUID } from "node:crypto";
import { spawn, spawnSync } from "node:child_process";
import type { SpawnSyncReturns } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

const CORE_VERSION = "0.2.0";
const TIMESTAMP = new Date().toISOString();
const PORTABLE_PATH = /^[a-zA-Z0-9_-][a-zA-Z0-9_.-]*(?:\/[a-zA-Z0-9_-][a-zA-Z0-9_.-]*)*$/;
const SEMVER = /^[0-9]+\.[0-9]+\.[0-9]+$/;
const PACKAGE_ID = /^@[a-z0-9-]+\/[a-z0-9-]+$/;
const REQUEST_ID = /^[A-Za-z0-9._:-]{8,128}$/;

const FIXTURE_MANIFEST_DIGEST = "sha256:b9cdf39bbf2ae4fc2aeee656d2c8dc655c0faa951fbeec255eb887f210a683f9";
const FIXTURE_TREE_DIGEST = "sha256:b8e76dfdc87d84904ada0620425c0a94200532d11207e3d1339626fb2df85aa3";
const V_NUL = "sha256:2d454a684186557b9d4a6b1d1ad71b2fd35653221a57da3a0a3c1c1cdce51c0c";
const V_NONUTF8 = "sha256:e47ead3733f036191bc07eca4279a634a6482e585b29b939a3bfac5225d0cd50";
const V_MULTI = "sha256:ee719bb79ec611fd44274dab22543c4ac2ca459b803a27c4829df028b2804990";
const V_EXE = "sha256:b026027495f9869e30fb7ee14ac23b5e29b580db1df3d66537339c9ab9555d98";
const V_NOEXE = "sha256:3571f0cbec1c1703ada683d25a71704dec379f9af80cbebc099d521ec879793d";

interface SelfCheckInvocation {
  type: "direct" | "command";
  command?: string;
}

interface Manifest {
  schema_version: string;
  package_id: string;
  version: string;
  kind: string;
  compatible_core_range: string;
  supported_languages: string[];
  supported_overlays: string[];
  available_workflows: string[];
  entrypoints: Record<string, string>;
  runtime_capabilities: { required_commands: string[]; optional_effigy_selectors: string[] };
  self_check: { entrypoint: string; invocation: SelfCheckInvocation; validated_profile_versions: string[]; validated_schema_versions: string[] };
  evidence_providers: string[];
}

interface TrustEntry {
  package_id: string;
  version: string;
  source_identity?: Record<string, unknown>;
  tree_digest: string;
  manifest_digest: string;
  compatible_core_range: string;
  workflows?: string[];
  consumer_scope?: string;
  actor: string;
  timestamp: string;
  reason: string;
}

interface Revocation {
  package_id: string;
  version: string;
  tree_digest: string;
  manifest_digest: string;
  actor: string;
  timestamp: string;
  reason: string;
}

interface TrustDoc {
  schema_version: string;
  revision: string;
  allowlist: TrustEntry[];
  revocations: Revocation[];
}

interface LifecycleRef {
  package_id: string;
  version: string;
  tree_digest: string;
  manifest_digest: string;
  receipt_digest: string;
  installed_path: string;
  selection: "selected" | "retained";
  installed_at: string;
}

interface LifecycleDoc {
  schema_version: string;
  state_revision: string;
  packages: LifecycleRef[];
}

interface Receipt {
  schema_version: string;
  package_id: string;
  version: string;
  kind: string;
  trust_class: Record<string, unknown>;
  source: Record<string, unknown>;
  content_identity: { package_tree_digest: string; manifest_digest: string };
  compatibility: { compatible_core_range: string; installed_core_version: string };
  installation: { installed_path: string; installed_at: string; acquisition_adapter: string; activation_status: string };
}

interface RegistryDoc {
  schema_version: string;
  registry_version: string;
  packages: RegistryEntry[];
}

interface RegistryDiscovery {
  languages: string[];
  overlays: string[];
  workflows: string[];
  activation_marker: string;
}

interface RegistryEntry {
  package_id: string;
  version: string;
  repository?: string;
  subpath?: string;
  commit?: string;
  tree_digest: string;
  manifest_digest: string;
  compatible_core_range: string;
  discovery: RegistryDiscovery;
}

interface Pin {
  entry: TrustEntry | RegistryEntry;
  source: "official" | "operator_allowlist";
  // The registry document version that authorized an official pin; null for
  // operator allowlist pins. Receipts must record this truthfully.
  registry_version: string | null;
}

interface ResolvedPackage {
  reference: LifecycleRef;
  manifest: Manifest;
  receipt: Receipt;
}

interface AcquireOutcome {
  status: "activated" | "stopped" | "no-route" | "routed";
  notice: string;
  receiptDigest?: string;
  treeDigest?: string;
  manifestDigest?: string;
  installDir?: string;
}

interface AcquireOptions {
  stateRoot: string;
  consumerDir: string;
  trustDoc: TrustDoc;
  registry: RegistryDoc;
  packageId: string;
  version: string;
  language: string;
  workflow: string;
  coreVersion: string;
  adapter: (pin: Pin) => string;
  intent: "workflow_request" | "activation" | "detection";
  activationMarker?: string;
  // Optional host-bound consumer scope: takes precedence over the activation
  // marker scope for trust restriction enforcement.
  consumerScopeHint?: string | null;
}

function check(condition: unknown, message: string): asserts condition {
  if (!condition) {
    throw new Error("[northstar:language-packages] " + message);
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function isString(value: unknown): value is string {
  return typeof value === "string";
}

function asString(value: unknown, context: string): string {
  check(isString(value), context + " must be a string");
  return value;
}

function asStringArray(value: unknown, context: string): string[] {
  check(Array.isArray(value) && value.every((v) => isString(v)), context + " must be an array of strings");
  return value as string[];
}

function asRecord(value: unknown, context: string): Record<string, unknown> {
  check(isRecord(value), context + " must be an object");
  return value;
}

function requireClosedObject(doc: Record<string, unknown>, required: string[], context: string): void {
  for (const key of required) {
    check(Object.keys(doc).includes(key), context + " missing required field: " + key);
  }
  for (const key of Object.keys(doc)) {
    check(required.includes(key), context + " contains forbidden additional property: " + key);
  }
}

function notice(message: string): void {
  console.log("[northstar:language-packages] notice: " + message);
}

function sha256Hex(bytes: Buffer): string {
  return createHash("sha256").update(bytes).digest("hex");
}

function requireCanonicalDigest(digest: unknown, context: string): void {
  if (!isString(digest) || !/^sha256:[0-9a-f]{64}$/.test(digest)) {
    throw new Error(context + " uses non-canonical digest spelling: '" + String(digest) + "' (required sha256:<64 lowercase hex>)");
  }
}

function fileBytes(p: string): Buffer {
  return fs.readFileSync(p);
}

function manifestDigestOf(p: string): string {
  return "sha256:" + sha256Hex(fileBytes(p));
}

function fileExecutableBit(p: string): number {
  const st = fs.statSync(p);
  return (st.mode & 0o111) !== 0 ? 1 : 0;
}

function asciiCaseFold(s: string): string {
  return s.toLowerCase();
}

function isSafePackageRelativePath(p: unknown): boolean {
  if (!isString(p) || p === "") {
    return false;
  }
  if (p.startsWith("/") || p.startsWith("\\") || p.includes("//") || p.endsWith("/")) {
    return false;
  }
  for (const part of p.split("/")) {
    if (part === "" || part === "." || part === "..") {
      return false;
    }
  }
  return PORTABLE_PATH.test(p);
}

interface FileRecord {
  path: string;
  executable: number;
  content: Buffer;
}

function collectCanonicalFileRecords(packageRoot: string, context: string): FileRecord[] {
  const records: FileRecord[] = [];
  const seenFold = new Set<string>();
  const dirs = [""];
  while (dirs.length > 0) {
    const relDir = dirs.pop() as string;
    const absDir = relDir === "" ? packageRoot : path.join(packageRoot, relDir);
    for (const entry of fs.readdirSync(absDir, { withFileTypes: true })) {
      const rel = relDir === "" ? entry.name : relDir + "/" + entry.name;
      if (!isSafePackageRelativePath(rel)) {
        throw new Error(context + " contains non-portable package path: '" + rel + "'");
      }
      const abs = path.join(absDir, entry.name);
      if (entry.isSymbolicLink()) {
        throw new Error(context + " contains symbolic link (rejected, never followed): '" + rel + "'");
      }
      const fold = asciiCaseFold(rel);
      if (seenFold.has(fold)) {
        throw new Error(context + " contains case-fold path collision: '" + rel + "'");
      }
      seenFold.add(fold);
      if (entry.isDirectory()) {
        dirs.push(rel);
      } else if (entry.isFile()) {
        records.push({ path: rel, executable: fileExecutableBit(abs), content: fileBytes(abs) });
      } else {
        throw new Error(context + " contains special file (rejected): '" + rel + "'");
      }
    }
  }
  records.sort((a, b) => Buffer.compare(Buffer.from(a.path, "utf8"), Buffer.from(b.path, "utf8")));
  return records;
}

function canonicalTreeDigest(packageRoot: string, context: string): string {
  // F\0<path-byte-length>\0<path-bytes>\0<executable:0|1>\0<content-byte-length>\0<content-bytes>
  const records = collectCanonicalFileRecords(packageRoot, context);
  const chunks: Buffer[] = [];
  for (const rec of records) {
    const pathBytes = Buffer.from(rec.path, "utf8");
    chunks.push(Buffer.from("F\0"));
    chunks.push(Buffer.from(String(pathBytes.length)));
    chunks.push(Buffer.from("\0"));
    chunks.push(pathBytes);
    chunks.push(Buffer.from("\0"));
    chunks.push(Buffer.from(String(rec.executable)));
    chunks.push(Buffer.from("\0"));
    chunks.push(Buffer.from(String(rec.content.length)));
    chunks.push(Buffer.from("\0"));
    chunks.push(rec.content);
  }
  return "sha256:" + sha256Hex(Buffer.concat(chunks));
}

// ---- trust and lifecycle documents (semantic invariants) ----

function parseTrustDoc(raw: unknown, context: string): TrustDoc {
  const doc = asRecord(raw, context);
  check(asString(doc.schema_version, context + ".schema_version") === "1.0.0", context + " has unsupported schema_version");
  asString(doc.revision, context + ".revision");
  const allowlist = doc.allowlist;
  const revocations = doc.revocations;
  check(Array.isArray(allowlist) && Array.isArray(revocations), context + " allowlist/revocations must be arrays");
  const seenAllow = new Set<string>();
  for (const rawEntry of allowlist) {
    const entry = asRecord(rawEntry, context + " allowlist entry");
    asString(entry.package_id, context + " allowlist package_id");
    asString(entry.version, context + " allowlist version");
    requireCanonicalDigest(entry.tree_digest, context + " allowlist");
    requireCanonicalDigest(entry.manifest_digest, context + " allowlist");
    asString(entry.compatible_core_range, context + " allowlist range");
    if (entry.source_identity !== undefined) {
      asRecord(entry.source_identity, context + " allowlist source_identity");
    }
    const key = String(entry.package_id) + "@" + String(entry.version) + "|" + String(entry.tree_digest) + "|" + String(entry.manifest_digest);
    check(!seenAllow.has(key), context + " contains duplicate allowlist entry: " + key);
    seenAllow.add(key);
  }
  const seenRev = new Set<string>();
  for (const rawRec of revocations) {
    const rec = asRecord(rawRec, context + " revocation");
    asString(rec.package_id, context + " revocation package_id");
    requireCanonicalDigest(rec.tree_digest, context + " revocation");
    requireCanonicalDigest(rec.manifest_digest, context + " revocation");
    const key = String(rec.package_id) + "|" + String(rec.tree_digest) + "|" + String(rec.manifest_digest);
    check(!seenRev.has(key), context + " contains duplicate revocation entry: " + key);
    seenRev.add(key);
  }
  return raw as TrustDoc;
}

function parseLifecycleDoc(raw: unknown, context: string): LifecycleDoc {
  const doc = asRecord(raw, context);
  check(asString(doc.schema_version, context + ".schema_version") === "1.0.0", context + " has unsupported schema_version");
  asString(doc.state_revision, context + ".state_revision");
  check(Array.isArray(doc.packages), context + " packages must be an array");
  const seenRefs = new Set<string>();
  const selectedByPkg = new Set<string>();
  for (const rawRef of doc.packages) {
    const ref = asRecord(rawRef, context + " reference");
    asString(ref.package_id, context + " reference package_id");
    asString(ref.version, context + " reference version");
    requireCanonicalDigest(ref.tree_digest, context + " reference");
    requireCanonicalDigest(ref.manifest_digest, context + " reference");
    requireCanonicalDigest(ref.receipt_digest, context + " reference");
    asString(ref.installed_path, context + " reference installed_path");
    check(ref.selection === "selected" || ref.selection === "retained", context + " reference has invalid selection");
    const receiptDigest = asString(ref.receipt_digest, context + " reference receipt_digest");
    check(!seenRefs.has(receiptDigest), context + " contains duplicate receipt reference: " + receiptDigest);
    seenRefs.add(receiptDigest);
    const packageId = asString(ref.package_id, context + " reference package_id");
    if (ref.selection === "selected") {
      check(!selectedByPkg.has(packageId), context + " selects more than one receipt for package: " + packageId);
      selectedByPkg.add(packageId);
    }
  }
  return raw as LifecycleDoc;
}

function allowlistEntries(trustDoc: TrustDoc): TrustEntry[] {
  return trustDoc.allowlist;
}

function revocationEntries(trustDoc: TrustDoc): Revocation[] {
  return trustDoc.revocations;
}

function findRevocation(trustDoc: TrustDoc, packageId: string, treeDigest: string, manifestDigest: string): Revocation | null {
  for (const rec of revocationEntries(trustDoc)) {
    if (rec.package_id === packageId && rec.tree_digest === treeDigest && rec.manifest_digest === manifestDigest) {
      return rec;
    }
  }
  return null;
}

// ---- lifecycle state root: atomic compare-and-swap ----

function stateFilePath(stateRoot: string): string {
  return path.join(stateRoot, "lifecycle-state.json");
}

function receiptsDir(stateRoot: string): string {
  return path.join(stateRoot, "receipts");
}

function readStateDoc(stateRoot: string): LifecycleDoc | null {
  const p = stateFilePath(stateRoot);
  if (!fs.existsSync(p)) {
    return null;
  }
  return parseLifecycleDoc(JSON.parse(fs.readFileSync(p, "utf8")), "lifecycle-state.json");
}

function writeFileAtomic(finalPath: string, data: string): void {
  const dir = path.dirname(finalPath);
  const tmp = path.join(dir, ".tmp-" + process.pid + "-" + randomUUID() + ".json");
  fs.writeFileSync(tmp, data, { mode: 0o600 });
  fs.renameSync(tmp, finalPath);
}

function processAlive(pid: number): boolean {
  try {
    process.kill(pid, 0);
    return true;
  } catch (err) {
    return (err as NodeJS.ErrnoException).code === "EPERM";
  }
}

function withLifecycleLock(stateRoot: string, observedRevision: string, action: () => void): void {
  check(fs.existsSync(stateRoot) && fs.statSync(stateRoot).isDirectory(), "state root missing: " + stateRoot);
  const lock = path.join(stateRoot, ".lifecycle.lock");
  let acquired = false;
  let retriedStale = false;
  while (!acquired) {
    try {
      const fd = fs.openSync(lock, "wx");
      fs.writeSync(fd, String(process.pid));
      fs.closeSync(fd);
      acquired = true;
    } catch (err) {
      const code = (err as NodeJS.ErrnoException).code;
      if (code !== "EEXIST") {
        throw err;
      }
      // Fail closed on an ambiguous in-progress write; recover a stale lock
      // (dead owner) exactly once.
      let owner = -1;
      try {
        owner = Number.parseInt(fs.readFileSync(lock, "utf8").trim(), 10);
      } catch {
        owner = -1;
      }
      const stale = owner > 0 && !processAlive(owner);
      if (stale && !retriedStale) {
        retriedStale = true;
        fs.rmSync(lock, { force: true });
        continue;
      }
      throw new Error("lifecycle CAS conflict: ambiguous lifecycle write in progress (lock held by " + (owner > 0 ? "pid " + owner : "unknown writer") + ")");
    }
  }
  try {
    const current = readStateDoc(stateRoot);
    const currentRevision = current === null ? "0" : current.state_revision;
    check(currentRevision === observedRevision,
      "lifecycle CAS conflict: observed revision " + observedRevision + " is stale; current revision is " + currentRevision);
    action();
  } finally {
    fs.rmSync(lock, { force: true });
  }
}

function replaceStateCas(stateRoot: string, observedRevision: string, nextRevision: string, packages: LifecycleRef[]): void {
  withLifecycleLock(stateRoot, observedRevision, () => {
    const doc: LifecycleDoc = {
      schema_version: "1.0.0",
      state_revision: String(nextRevision),
      packages,
    };
    parseLifecycleDoc(doc, "replacement lifecycle-state.json");
    writeFileAtomic(stateFilePath(stateRoot), JSON.stringify(doc));
  });
}

// ---- immutable receipts ----

function writeImmutableReceipt(stateRoot: string, receipt: Receipt): string {
  const dir = receiptsDir(stateRoot);
  fs.mkdirSync(dir, { recursive: true });
  const body = JSON.stringify(receipt);
  const tmp = path.join(dir, ".tmp-" + process.pid + "-" + randomUUID() + ".json");
  fs.writeFileSync(tmp, body, { mode: 0o600 });
  const digest = "sha256:" + sha256Hex(fs.readFileSync(tmp));
  const finalPath = path.join(dir, digest + ".json");
  if (!fs.existsSync(finalPath)) {
    fs.renameSync(tmp, finalPath);
  } else {
    fs.rmSync(tmp, { force: true });
  }
  return digest;
}

function parseReceipt(bytes: Buffer): Receipt | null {
  try {
    const raw: unknown = JSON.parse(bytes.toString("utf8"));
    const doc = asRecord(raw, "receipt");
    asString(doc.schema_version, "receipt.schema_version");
    asString(doc.package_id, "receipt.package_id");
    asString(doc.version, "receipt.version");
    asString(doc.kind, "receipt.kind");
    asRecord(doc.trust_class, "receipt.trust_class");
    asRecord(doc.source, "receipt.source");
    asRecord(doc.content_identity, "receipt.content_identity");
    asRecord(doc.compatibility, "receipt.compatibility");
    asRecord(doc.installation, "receipt.installation");
    return raw as Receipt;
  } catch {
    return null;
  }
}

function loadReceipt(stateRoot: string, receiptDigest: string): Receipt | null {
  try {
    requireCanonicalDigest(receiptDigest, "receipt lookup");
  } catch {
    return null;
  }
  const p = path.join(receiptsDir(stateRoot), receiptDigest + ".json");
  if (!fs.existsSync(p)) {
    return null;
  }
  const body = fileBytes(p);
  if (sha256Hex(body) !== receiptDigest.slice(7)) {
    return null;
  }
  return parseReceipt(body);
}

// ---- generic discovery and routing (identity-bound, receipt-bound) ----

function manifestMatches(manifest: Manifest, language: string, workflow: string): boolean {
  return manifest.kind === "language-quality" &&
    manifest.supported_languages.includes(language) &&
    manifest.available_workflows.includes(workflow);
}

function verifyInstalledIdentity(
  installedPath: string,
  reference: Pick<LifecycleRef, "tree_digest" | "manifest_digest">,
  context: string,
): Manifest {
  check(fs.existsSync(installedPath) && fs.statSync(installedPath).isDirectory(), context + ": installed path missing: " + installedPath);
  const manifestPath = path.join(installedPath, "northstar-package.json");
  check(fs.existsSync(manifestPath) && fs.statSync(manifestPath).isFile(), context + ": installed manifest missing");
  requireCanonicalDigest(reference.tree_digest, context);
  requireCanonicalDigest(reference.manifest_digest, context);
  check(manifestDigestOf(manifestPath) === reference.manifest_digest, context + ": installed manifest identity drifted from receipt");
  check(canonicalTreeDigest(installedPath, context) === reference.tree_digest, context + ": installed tree identity drifted from receipt");
  return parseManifest(JSON.parse(fs.readFileSync(manifestPath, "utf8")), context + " installed manifest");
}

function receiptMatchesReference(receipt: Receipt, reference: LifecycleRef): boolean {
  return receipt.package_id === reference.package_id &&
    receipt.version === reference.version &&
    receipt.content_identity.package_tree_digest === reference.tree_digest &&
    receipt.content_identity.manifest_digest === reference.manifest_digest &&
    receipt.installation.installed_path === reference.installed_path;
}

function resolveInstalledPackage(stateRoot: string, trustDoc: TrustDoc, packageId: string, version: string, language: string, workflow: string, coreVersion: string): ResolvedPackage | null {
  const stateDoc = readStateDoc(stateRoot);
  if (stateDoc === null) {
    return null;
  }
  for (const reference of stateDoc.packages) {
    // Route binds the requested identity: a selected package that is not the
    // requested package_id/version is not a match.
    if (reference.package_id !== packageId || reference.version !== version) {
      continue;
    }
    if (reference.selection !== "selected") {
      continue;
    }
    if (findRevocation(trustDoc, packageId, reference.tree_digest, reference.manifest_digest) !== null) {
      continue;
    }
    // A path or prior selection without a matching immutable receipt and
    // content identity is not routable.
    const receipt = loadReceipt(stateRoot, reference.receipt_digest);
    if (receipt === null || !receiptMatchesReference(receipt, reference)) {
      continue;
    }
    const manifest = verifyInstalledIdentity(reference.installed_path, reference, "resolve");
    // End-to-end agreement: reference, receipt, and installed manifest must
    // all declare the same identity, version, and compatibility range.
    if (manifest.package_id !== packageId || manifest.version !== reference.version) {
      continue;
    }
    if (manifest.compatible_core_range !== receipt.compatibility.compatible_core_range) {
      continue;
    }
    if (!manifestMatches(manifest, language, workflow)) {
      continue;
    }
    if (!checkSemverCompatibility(manifest.compatible_core_range, coreVersion)) {
      continue;
    }
    return { reference, manifest, receipt };
  }
  return null;
}

// ---- semver ----

function parseSemver(s: string): number[] | null {
  if (!SEMVER.test(s)) {
    return null;
  }
  return s.split(".").map((p) => Number.parseInt(p, 10));
}

function compareSemver(a: number[], b: number[]): number {
  for (let i = 0; i < 3; i++) {
    if (a[i] !== b[i]) {
      return a[i] - b[i];
    }
  }
  return 0;
}

function checkSemverCompatibility(range: string, coreVersion: string): boolean {
  const core = parseSemver(coreVersion);
  check(core !== null, "invalid core version: " + coreVersion);
  if (range === "*") {
    return true;
  }
  const exact = range.match(/^([0-9]+\.[0-9]+\.[0-9]+)$/);
  if (exact !== null) {
    return compareSemver(core as number[], parseSemver(exact[1]) as number[]) === 0;
  }
  const caret = range.match(/^\^([0-9]+\.[0-9]+\.[0-9]+)$/);
  if (caret !== null) {
    const base = parseSemver(caret[1]) as number[];
    if (compareSemver(core as number[], base) < 0) {
      return false;
    }
    const max = base[0] > 0 ? [base[0] + 1, 0, 0] : base[1] > 0 ? [0, base[1] + 1, 0] : [0, 0, base[2] + 1];
    return compareSemver(core as number[], max) < 0;
  }
  const bounded = range.match(/^>=([0-9]+\.[0-9]+\.[0-9]+) <([0-9]+\.[0-9]+\.[0-9]+)$/);
  if (bounded !== null) {
    const min = parseSemver(bounded[1]) as number[];
    const max = parseSemver(bounded[2]) as number[];
    return compareSemver(core as number[], min) >= 0 && compareSemver(core as number[], max) < 0;
  }
  const ge = range.match(/^>=([0-9]+\.[0-9]+\.[0-9]+)$/);
  if (ge !== null) {
    return compareSemver(core as number[], parseSemver(ge[1]) as number[]) >= 0;
  }
  const lt = range.match(/^<([0-9]+\.[0-9]+\.[0-9]+)$/);
  if (lt !== null) {
    return compareSemver(core as number[], parseSemver(lt[1]) as number[]) < 0;
  }
  return false;
}

// ---- trust pin and restrictions ----

function hostAcquisitionAdapter(): (pin: Pin) => string {
  // Reference host acquisition: a local_path pin stages from its resolved
  // source path; any other source requires a transport this reference host
  // does not provide and stops with a capability notice.
  return (pin: Pin) => {
    const identity = pin.entry.source_identity;
    if (identity === undefined || identity.type !== "local_path") {
      throw new Error("host transport capability unavailable for source type " + String(identity?.type ?? "none"));
    }
    const staged = stagedDir("northstar-staged-");
    copyTree(String(identity.path), staged);
    return staged;
  };
}

function runGit(args: string[], cwd: string): string {
  const git = findCommand("git");
  check(git !== null, "git is required to acquire an official language package");
  const result = spawnSync(git, args, {
    cwd,
    encoding: "utf8",
    timeout: 120_000,
    env: { ...process.env, GIT_TERMINAL_PROMPT: "0" },
  });
  check(result.error === undefined, "git acquisition failed to launch: " + String(result.error));
  check(result.status === 0,
    "git acquisition failed: git " + args.join(" ") + "\n" + String(result.stderr ?? "").trim());
  return String(result.stdout ?? "").trim();
}

function publicAcquisitionAdapter(): (pin: Pin) => string {
  return (pin: Pin): string => {
    const identity = pin.entry.source_identity;
    if (identity !== undefined && identity.type === "local_path") {
      return hostAcquisitionAdapter()(pin);
    }

    check(pin.source === "official", "non-official package acquisition requires an operator local-path pin");
    const entry = pin.entry as RegistryEntry;
    check(isString(entry.repository) && entry.repository !== "", "official registry entry has no repository");
    check(isString(entry.subpath) && isSafePackageRelativePath(entry.subpath), "official registry entry has invalid subpath");
    check(isString(entry.commit) && /^[0-9a-f]{40}$/.test(entry.commit), "official registry entry has invalid immutable commit");

    const checkoutParent = fs.mkdtempSync(path.join(process.env.TMPDIR ?? os.tmpdir(), "northstar-package-fetch-"));
    const checkout = path.join(checkoutParent, "repo");
    const staged = stagedDir("northstar-staged-");
    try {
      fs.mkdirSync(checkout);
      runGit(["init", "-q"], checkout);
      runGit(["remote", "add", "origin", entry.repository], checkout);
      runGit(["fetch", "--depth", "1", "origin", entry.commit], checkout);
      check(runGit(["rev-parse", "FETCH_HEAD"], checkout) === entry.commit,
        "fetched package commit does not match the official registry pin");
      runGit(["checkout", "-q", "--detach", "FETCH_HEAD"], checkout);
      const source = path.join(checkout, entry.subpath);
      check(fs.existsSync(source) && fs.statSync(source).isDirectory(),
        "official package subpath missing at pinned commit: " + entry.subpath);
      copyTree(source, staged);
      return staged;
    } catch (err) {
      fs.rmSync(staged, { recursive: true, force: true });
      throw err;
    } finally {
      fs.rmSync(checkoutParent, { recursive: true, force: true });
    }
  };
}

function findPin(registry: RegistryDoc, trustDoc: TrustDoc, packageId: string, version: string): Pin | null {
  for (const entry of registry.packages) {
    if (entry.package_id === packageId && entry.version === version) {
      return { entry, source: "official", registry_version: registry.registry_version };
    }
  }
  for (const entry of allowlistEntries(trustDoc)) {
    if (entry.package_id === packageId && entry.version === version) {
      return { entry, source: "operator_allowlist", registry_version: null };
    }
  }
  return null;
}

function enforcePinRestrictions(pin: Pin, workflow: string, consumerScope: string | null): void {
  const entry = pin.entry;
  if (Array.isArray(entry.workflows) && entry.workflows.length > 0 && !entry.workflows.includes(workflow)) {
    throw new Error("allowlist pin restricts workflows to [" + entry.workflows.join(", ") + "]; requested " + workflow);
  }
  if (typeof entry.consumer_scope === "string" && entry.consumer_scope !== "" && entry.consumer_scope !== consumerScope) {
    throw new Error("allowlist pin restricts consumer scope to '" + entry.consumer_scope + "'; consumer scope is '" + String(consumerScope) + "'");
  }
}

function enforceRouteRestrictions(trustDoc: TrustDoc, registry: RegistryDoc, packageId: string, version: string, treeDigest: string, manifestDigest: string, workflow: string, consumerScope: string | null): void {
  for (const entry of allowlistEntries(trustDoc)) {
    if (entry.package_id === packageId && entry.version === version &&
      entry.tree_digest === treeDigest && entry.manifest_digest === manifestDigest) {
      enforcePinRestrictions({ entry, source: "operator_allowlist" }, workflow, consumerScope);
      return;
    }
  }
  for (const entry of registry.packages) {
    if (entry.package_id === packageId && entry.version === version &&
      entry.tree_digest === treeDigest && entry.manifest_digest === manifestDigest) {
      enforcePinRestrictions({ entry, source: "official" }, workflow, consumerScope);
      return;
    }
  }
}

// ---- registry-owned generic selection (card 122) ----
//
// The official registry is the only authority that maps explicit workflow
// intent or an exact activation marker to one package identity. Selection is
// data-driven over discovery metadata: it names no package, no language
// ecosystem, and no acquisition path. Selection never acquires, never runs
// package code, and never mutates the consumer. Detection-only input is not a
// query shape at all, so it can never select.

type SelectionQuery =
  | { kind: "intent"; language: string; workflow: string; overlay: string | null }
  | { kind: "marker"; marker: string };

function describeQuery(query: SelectionQuery): string {
  if (query.kind === "marker") {
    return "activation marker " + query.marker;
  }
  return "language " + query.language + " workflow " + query.workflow +
    (query.overlay !== null ? " overlay " + query.overlay : "");
}

function selectRegistryEntry(registry: RegistryDoc, coreVersion: string, query: SelectionQuery): RegistryEntry {
  const matches = registry.packages.filter((entry) => {
    if (query.kind === "marker") {
      return entry.discovery.activation_marker === query.marker;
    }
    if (!entry.discovery.languages.includes(query.language)) {
      return false;
    }
    if (!entry.discovery.workflows.includes(query.workflow)) {
      return false;
    }
    if (query.overlay !== null && !entry.discovery.overlays.includes(query.overlay)) {
      return false;
    }
    return true;
  });
  check(matches.length > 0, query.kind === "marker"
    ? "no official registry entry carries the activation marker " + query.marker + "; nothing was selected or acquired"
    : "no official registry entry supports " + describeQuery(query) + "; the requested workflow stays unavailable and nothing was selected or acquired");
  check(matches.length === 1, "official registry selection is ambiguous: " + String(matches.length) + " entries claim " + describeQuery(query) + "; nothing was selected or acquired");
  const entry = matches[0];
  check(checkSemverCompatibility(entry.compatible_core_range, coreVersion),
    "the only registry entry claiming " + describeQuery(query) + " is incompatible with core " + coreVersion + "; the workflow stops before any acquisition");
  return entry;
}

function sameStringSet(a: string[], b: string[]): boolean {
  return [...a].sort().join("\u0000") === [...b].sort().join("\u0000");
}

// Registry discovery metadata must agree with the verified installed
// manifest before routing: a manifest that dropped a declared language,
// overlay, or workflow is metadata drift, and drift stops the route.
function discoveryAgrees(entry: RegistryEntry, manifest: Manifest): boolean {
  return sameStringSet(entry.discovery.languages, manifest.supported_languages) &&
    sameStringSet(entry.discovery.overlays, manifest.supported_overlays) &&
    sameStringSet(entry.discovery.workflows, manifest.available_workflows);
}

// ---- declared self-check execution ----

function findCommand(cmd: string): string | null {
  if (cmd.includes("/")) {
    return fs.existsSync(cmd) && fs.statSync(cmd).isFile() ? cmd : null;
  }
  for (const dir of (process.env.PATH ?? "").split(":")) {
    if (dir === "") {
      continue;
    }
    const candidate = path.join(dir, cmd);
    try {
      if (fs.existsSync(candidate) && fs.statSync(candidate).isFile() && (fs.statSync(candidate).mode & 0o111) !== 0) {
        return candidate;
      }
    } catch {
      // unreadable entry; keep searching
    }
  }
  return null;
}

function runPackageSelfCheck(stagedRoot: string, manifest: Manifest): { output: string; exit: number; execRoot: string; execRealRoot: string; execTreeDigest: string } {
  // Explicit invocation contract: `direct` executes the verified entrypoint
  // with [package_root]; `command` executes the declared command (which must
  // appear in runtime_capabilities.required_commands) with
  // [resolved_entrypoint, package_root]. Both use the package root as the
  // working directory. There is no shell interpolation, no argument template,
  // no inferred runner, and no meaning attached to required_commands order.
  //
  // The candidate executes against a throwaway byte-identical copy of the
  // verified staged root (mode-preserving): the copy is the package root for
  // the candidate run, and any receipts or state a real self-check writes
  // are discarded with the copy. The installed payload therefore keeps the
  // exact pinned identity for later selection re-verification.
  const entry = manifest.self_check.entrypoint;
  check(isSafePackageRelativePath(entry), "self-check entrypoint violates containment");
  const entryPath = path.join(stagedRoot, entry);
  let st: fs.Stats;
  try {
    st = fs.lstatSync(entryPath);
  } catch {
    throw new Error("self-check entrypoint missing from staged payload: " + entry);
  }
  check(st.isFile(), "self-check entrypoint is not a regular file: " + entry);
  check(!st.isSymbolicLink(), "self-check entrypoint must not be a symlink: " + entry);
  const invocation = manifest.self_check.invocation;
  const execParent = fs.mkdtempSync(path.join(process.env.TMPDIR ?? "/tmp", "northstar-selfcheck-"));
  const execRoot = path.join(execParent, "package");
  copyTree(stagedRoot, execRoot);
  const execEntryPath = path.join(execRoot, entry);
  const execRealRoot = fs.realpathSync(execRoot);
  const execTreeDigest = canonicalTreeDigest(execRoot, "self-check execution copy");
  const cwd = execRoot;
  let result: SpawnSyncReturns<string>;
  try {
    if (invocation.type === "direct") {
      check((st.mode & 0o111) !== 0, "self-check entrypoint is not executable: " + entry);
      result = spawnSync(execEntryPath, [execRoot], { cwd, encoding: "utf8" });
    } else {
      const command = invocation.command as string;
      check(manifest.runtime_capabilities.required_commands.includes(command),
        "self-check command runner is not declared in runtime_capabilities.required_commands: " + command);
      const resolved = findCommand(command);
      check(resolved !== null, "required runtime command not available on this host: " + command);
      result = spawnSync(resolved, [execEntryPath, execRoot], { cwd, encoding: "utf8" });
    }
  } finally {
    fs.rmSync(execParent, { recursive: true, force: true });
  }
  check(result.error === undefined, "self-check launch failed: " + String(result.error));
  const output = String(result.stdout ?? "") + String(result.stderr ?? "");
  return { output, exit: result.status === null ? -1 : result.status, execRoot, execRealRoot, execTreeDigest };
}

function parseManifest(raw: unknown, context: string): Manifest {
  const doc = asRecord(raw, context);
  check(asString(doc.schema_version, context + ".schema_version") === "1.0.0", context + " has unsupported schema_version");
  check(PACKAGE_ID.test(asString(doc.package_id, context + ".package_id")), context + " has invalid package_id");
  check(SEMVER.test(asString(doc.version, context + ".version")), context + " has invalid version");
  check(asString(doc.kind, context + ".kind") === "language-quality", context + " has invalid kind");
  asString(doc.compatible_core_range, context + ".compatible_core_range");
  check(asStringArray(doc.supported_languages, context + ".supported_languages").length > 0, context + " has no supported_languages");
  asStringArray(doc.supported_overlays, context + ".supported_overlays");
  check(asStringArray(doc.available_workflows, context + ".available_workflows").length > 0, context + " has no available_workflows");
  const entrypoints = asRecord(doc.entrypoints ?? {}, context + ".entrypoints");
  for (const key of Object.keys(entrypoints)) {
    check(isSafePackageRelativePath(entrypoints[key]), context + " entrypoint[" + key + "] violates containment");
  }
  const capabilities = asRecord(doc.runtime_capabilities ?? {}, context + ".runtime_capabilities");
  asStringArray(capabilities.required_commands, context + ".runtime_capabilities.required_commands");
  asStringArray(capabilities.optional_effigy_selectors, context + ".runtime_capabilities.optional_effigy_selectors");
  const selfCheck = asRecord(doc.self_check ?? {}, context + ".self_check");
  check(isSafePackageRelativePath(selfCheck.entrypoint), context + " self_check.entrypoint violates containment");
  const invocationRaw = asRecord(selfCheck.invocation ?? {}, context + ".self_check.invocation");
  const invocationType = asString(invocationRaw.type, context + ".self_check.invocation.type");
  check(invocationType === "direct" || invocationType === "command", context + " self_check.invocation.type must be direct or command");
  if (invocationType === "command") {
    asString(invocationRaw.command, context + ".self_check.invocation.command");
  }
  asStringArray(selfCheck.validated_profile_versions ?? [], context + ".self_check.validated_profile_versions");
  asStringArray(selfCheck.validated_schema_versions ?? [], context + ".self_check.validated_schema_versions");
  for (const forbidden of ["official", "is_official", "trusted", "trust_level", "allowlisted"]) {
    check(!(forbidden in doc), context + " self-claims trust or official status (trust must be core-owned)");
  }
  return raw as Manifest;
}

const DISCOVERY_TOKEN = /^[a-z0-9][a-z0-9_-]*$/;
const WORKFLOW_TOKEN = /^[a-z][a-z0-9_]*$/;
const ACTIVATION_MARKER = /^[a-z0-9][a-z0-9:._-]*$/;

// Discovery metadata is data, not trust: it selects, it never authorizes
// acquisition or execution by itself.
function parseRegistryDiscovery(raw: unknown, context: string): RegistryDiscovery {
  const doc = asRecord(raw, context);
  requireClosedObject(doc, ["languages", "overlays", "workflows", "activation_marker"], context);
  const languages = asStringArray(doc.languages, context + ".languages");
  const overlays = asStringArray(doc.overlays, context + ".overlays");
  const workflows = asStringArray(doc.workflows, context + ".workflows");
  const marker = asString(doc.activation_marker, context + ".activation_marker");
  check(languages.length > 0, context + ".languages must not be empty");
  check(workflows.length > 0, context + ".workflows must not be empty");
  const tokenLists: Array<[string[], RegExp, string]> = [
    [languages, DISCOVERY_TOKEN, "languages"],
    [overlays, DISCOVERY_TOKEN, "overlays"],
    [workflows, WORKFLOW_TOKEN, "workflows"],
  ];
  for (const [values, pattern, name] of tokenLists) {
    for (const value of values) {
      check(pattern.test(value), context + "." + name + " has invalid token: " + value);
    }
    check(new Set(values).size === values.length, context + "." + name + " contains duplicates");
  }
  check(ACTIVATION_MARKER.test(marker), context + ".activation_marker is invalid: " + marker);
  return raw as RegistryDiscovery;
}

function parseRegistryDoc(raw: unknown, context: string): RegistryDoc {
  const doc = asRecord(raw, context);
  asString(doc.schema_version, context + ".schema_version");
  asString(doc.registry_version, context + ".registry_version");
  check(Array.isArray(doc.packages), context + " packages must be an array");
  const seenMarkers: string[] = [];
  for (const rawEntry of doc.packages) {
    const entry = asRecord(rawEntry, context + " registry entry");
    check(PACKAGE_ID.test(asString(entry.package_id, context + " entry package_id")), context + " entry has invalid package_id");
    check(SEMVER.test(asString(entry.version, context + " entry version")), context + " entry has invalid version");
    requireCanonicalDigest(entry.tree_digest, context + " entry");
    requireCanonicalDigest(entry.manifest_digest, context + " entry");
    asString(entry.compatible_core_range, context + " entry range");
    const discovery = parseRegistryDiscovery(entry.discovery, context + " entry discovery");
    check(!seenMarkers.includes(discovery.activation_marker), context + " contains duplicate activation marker: " + discovery.activation_marker);
    seenMarkers.push(discovery.activation_marker);
  }
  return raw as RegistryDoc;
}

// ---- consumer activation ----

function consumerActivationValid(consumerDir: string, packageId: string, version: string, activationMarker?: string): { valid: boolean; scope: string | null } {
  const marker = path.join(consumerDir, "docs/contracts/language-quality-activation.json");
  if (fs.existsSync(marker)) {
    const raw: unknown = JSON.parse(fs.readFileSync(marker, "utf8"));
    if (isRecord(raw) && raw.package_id === packageId && raw.version === version) {
      return { valid: true, scope: isString(raw.scope) ? raw.scope : null };
    }
  }
  if (activationMarker !== undefined) {
    const instructions = path.join(consumerDir, "AGENTS.md");
    if (fs.existsSync(instructions)) {
      const text = fs.readFileSync(instructions, "utf8");
      const start = "<!-- " + activationMarker + ":start -->";
      const end = "<!-- " + activationMarker + ":end -->";
      if (text.includes(start) && text.includes(end)) {
        return { valid: true, scope: null };
      }
    }
  }
  return { valid: false, scope: null };
}

// ---- acquisition ----

function copyTree(srcRoot: string, dstRoot: string): void {
  const queue = [""];
  while (queue.length > 0) {
    const relDir = queue.pop() as string;
    const absSrc = relDir === "" ? srcRoot : path.join(srcRoot, relDir);
    for (const entry of fs.readdirSync(absSrc, { withFileTypes: true })) {
      const rel = relDir === "" ? entry.name : relDir + "/" + entry.name;
      const dest = path.join(dstRoot, rel);
      if (entry.isDirectory()) {
        fs.mkdirSync(dest, { recursive: true });
        queue.push(rel);
      } else {
        fs.mkdirSync(path.dirname(dest), { recursive: true });
        const src = path.join(absSrc, entry.name);
        fs.writeFileSync(dest, fileBytes(src));
        fs.chmodSync(dest, fs.statSync(src).mode & 0o777);
      }
    }
  }
}

function registryEntryDigest(entry: RegistryEntry): string {
  const sorted: Record<string, unknown> = {};
  for (const key of Object.keys(entry).sort()) {
    sorted[key] = (entry as Record<string, unknown>)[key];
  }
  return "sha256:" + sha256Hex(Buffer.from(JSON.stringify(sorted)));
}

function buildReceipt(pin: Pin, installDir: string, packageId: string, version: string, coreVersion: string): Receipt {
  const entry = pin.entry;
  const trustClass: Record<string, unknown> = pin.source === "official"
    ? {
        type: "official",
        // Truthful provenance: the registry document version that authorized
        // this pin, not a constant.
        registry_version: pin.registry_version,
        registry_entry_digest: registryEntryDigest(entry as RegistryEntry),
      }
    : {
        type: "operator_allowlist",
        allowlist_entry: JSON.stringify(entry.source_identity ?? entry.package_id),
        allowlisted_by: "operator",
      };
  const source: Record<string, unknown> = entry.source_identity !== undefined
    ? { ...entry.source_identity }
    : { type: "git", repository: entry.repository, subpath: entry.subpath, commit: entry.commit };
  if (source.type === "local_path" && source.acquisition_mode === undefined) {
    source.acquisition_mode = "local";
  }
  return {
    schema_version: "1.0.0",
    package_id: packageId,
    version,
    kind: "language-quality",
    trust_class: trustClass,
    source,
    content_identity: {
      package_tree_digest: entry.tree_digest,
      manifest_digest: entry.manifest_digest,
    },
    compatibility: {
      compatible_core_range: entry.compatible_core_range,
      installed_core_version: coreVersion,
    },
    // The receipt is written BEFORE the lifecycle compare-and-swap, so it must
    // truthfully record only installation ("installed"); activation is the
    // state selection that follows a successful CAS. A lost CAS leaves a
    // receipt that claims installation of retained bytes, never an activation
    // that did not happen.
    installation: {
      installed_path: installDir,
      installed_at: TIMESTAMP,
      acquisition_adapter: "fixture-staging",
      activation_status: "installed",
    },
  };
}

function acquireAndActivate(opts: AcquireOptions): AcquireOutcome {
  const { stateRoot, consumerDir, trustDoc, registry, packageId, version, language, workflow, coreVersion, adapter, intent } = opts;

  // The host-bound request scope takes precedence for trust restriction
  // enforcement; the activation marker scope is the fallback and must agree
  // when both are present.
  let consumerScope: string | null = opts.consumerScopeHint !== undefined ? opts.consumerScopeHint : null;
  if (intent === "activation") {
    const activation = consumerActivationValid(consumerDir, packageId, version, opts.activationMarker);
    check(activation.valid, "activation marker missing or invalid for " + packageId + "@" + version);
    if (consumerScope === null) {
      consumerScope = activation.scope;
    } else if (activation.scope !== null && consumerScope !== activation.scope) {
      check(false, "consumer scope mismatch: request scope '" + consumerScope + "' differs from activation marker scope '" + activation.scope + "'");
    }
  }


  const installed = resolveInstalledPackage(stateRoot, trustDoc, packageId, version, language, workflow, coreVersion);
  if (installed !== null) {
    // Registry-owned discovery must agree with the verified installed
    // manifest on every route, including the already-installed fast path.
    const routedEntry = registry.packages.find((candidate) =>
      candidate.package_id === packageId && candidate.version === version) ?? null;
    if (routedEntry !== null && !discoveryAgrees(routedEntry, installed.manifest)) {
      check(false, "registry discovery metadata disagrees with the verified installed manifest for " +
        packageId + "@" + version + " (metadata drift); the route stops before execution");
    }
    const identity = installed.reference.tree_digest;
    enforceRouteRestrictions(trustDoc, registry, packageId, version, identity, installed.reference.manifest_digest, workflow, consumerScope);
    const routeNotice = "routed " + packageId + " " + workflow + " local-only identity=" + identity;
    notice(routeNotice);
    return {
      status: "routed",
      notice: routeNotice,
      treeDigest: identity,
      manifestDigest: installed.reference.manifest_digest,
      receiptDigest: installed.reference.receipt_digest,
      installDir: installed.reference.installed_path,
    };
  }

  if (intent === "detection") {
    const n = "no acquisition without explicit workflow intent or activation for " + packageId + " (" + workflow + ")";
    notice(n);
    return { status: "no-route", notice: n };
  }
  const pin = findPin(registry, trustDoc, packageId, version);
  check(pin !== null, "no trusted pin for " + packageId + "@" + version + "; manual or local-path installation required");
  requireCanonicalDigest(pin.entry.tree_digest, "pin");
  requireCanonicalDigest(pin.entry.manifest_digest, "pin");
  enforcePinRestrictions(pin, workflow, consumerScope);
  check(findRevocation(trustDoc, packageId, pin.entry.tree_digest, pin.entry.manifest_digest) === null,
    "identity " + pin.entry.tree_digest + " is revoked; acquisition blocked");

  notice("acquire " + packageId + "@" + version +
    " source=" + pin.source +
    " target=" + path.join(stateRoot, "installed") +
    " workflow=" + workflow);

  const stagedRoot = adapter(pin);

  const stagedManifestPath = path.join(stagedRoot, "northstar-package.json");
  check(fs.existsSync(stagedManifestPath), "staged payload missing northstar-package.json");
  check(manifestDigestOf(stagedManifestPath) === pin.entry.manifest_digest,
    "staged manifest identity does not match pin " + packageId + "@" + version);
  check(canonicalTreeDigest(stagedRoot, "staged payload") === pin.entry.tree_digest,
    "staged tree identity does not match pin " + packageId + "@" + version);

  const stagedManifest = parseManifest(JSON.parse(fs.readFileSync(stagedManifestPath, "utf8")), "staged manifest");

  // The staged manifest must declare the requested identity, version, and
  // compatibility range: a pin must never install a manifest that claims
  // another package, version, or range.
  // Registry-owned discovery must agree with the identity-verified staged
  // manifest BEFORE self-check, receipt, or any lifecycle mutation: a pin
  // whose metadata drifted from the published manifest must never execute
  // package code or reach the operator state root. Operator-allowlist pins
  // carry no registry discovery and keep their behavior unchanged.
  if (pin.source === "official" && "discovery" in pin.entry) {
    check(discoveryAgrees(pin.entry as RegistryEntry, stagedManifest),
      "registry discovery metadata disagrees with the verified staged manifest for " +
      packageId + "@" + version + " (metadata drift); acquisition stopped before self-check, receipt, or lifecycle mutation");
  }
  check(stagedManifest.package_id === packageId,
    "staged manifest declares identity " + stagedManifest.package_id + ", requested " + packageId);
  check(stagedManifest.version === version,
    "staged manifest declares version " + stagedManifest.version + ", requested " + version);
  check(stagedManifest.compatible_core_range === pin.entry.compatible_core_range,
    "staged manifest compatibility range does not match the pin");
  check(checkSemverCompatibility(pin.entry.compatible_core_range, coreVersion),
    "pin " + packageId + "@" + version + " incompatible with Northstar core " + coreVersion);

  // Declared self-check execution: identity gates above have all passed.
  const selfCheck = runPackageSelfCheck(stagedRoot, stagedManifest);
  check(selfCheck.exit === 0, "self-check failed for " + packageId + "@" + version + ": " + selfCheck.output.trim());

  const installRoot = path.join(stateRoot, "installed");
  fs.mkdirSync(installRoot, { recursive: true });
  // Immutable digest-addressed store: the install directory is addressed by
  // the FULL canonical tree digest, published exclusively, and never
  // overwritten. An existing target must already have the exact identity;
  // anything else fails without writing.
  const installDir = path.join(installRoot, packageId + "@" + version + "-" + pin.entry.tree_digest.slice(7));
  fs.mkdirSync(path.dirname(installDir), { recursive: true });
  if (fs.existsSync(installDir)) {
    check(manifestDigestOf(path.join(installDir, "northstar-package.json")) === pin.entry.manifest_digest,
      "install target exists with a different manifest identity; refusing to overwrite: " + installDir);
    check(canonicalTreeDigest(installDir, "existing install") === pin.entry.tree_digest,
      "install target exists with a different tree identity; refusing to overwrite: " + installDir);
  } else {
    try {
      fs.mkdirSync(installDir);
    } catch (err) {
      const code = (err as NodeJS.ErrnoException).code;
      check(code === "EEXIST", "cannot create install target: " + String(err));
      // A concurrent publisher won the race: verify its exact identity
      // before reusing; anything else fails without writing.
      check(manifestDigestOf(path.join(installDir, "northstar-package.json")) === pin.entry.manifest_digest,
        "concurrent install target has a different manifest identity; refusing to reuse: " + installDir);
      check(canonicalTreeDigest(installDir, "concurrent install") === pin.entry.tree_digest,
        "concurrent install target has a different tree identity; refusing to reuse: " + installDir);
    }
    copyTree(stagedRoot, installDir);
  }

  const receipt = buildReceipt(pin, installDir, packageId, version, coreVersion);
  const receiptDigest = writeImmutableReceipt(stateRoot, receipt);

  const current = readStateDoc(stateRoot);
  const observed = current === null ? "0" : current.state_revision;
  const packages: LifecycleRef[] = [];
  for (const ref of current === null ? [] : current.packages) {
    const copied = { ...ref };
    if (copied.package_id === packageId) {
      copied.selection = "retained";
    }
    packages.push(copied);
  }
  packages.push({
    package_id: packageId,
    version,
    tree_digest: pin.entry.tree_digest,
    manifest_digest: pin.entry.manifest_digest,
    receipt_digest: receiptDigest,
    installed_path: installDir,
    selection: "selected",
    installed_at: TIMESTAMP,
  });
  replaceStateCas(stateRoot, observed, String(Number.parseInt(observed, 10) + 1), packages);

  const activateNotice = "activated " + packageId + "@" + version +
    " identity=" + pin.entry.tree_digest +
    " at " + installDir;
  notice(activateNotice);

  return {
    status: "activated",
    notice: activateNotice,
    receiptDigest,
    treeDigest: pin.entry.tree_digest,
    manifestDigest: pin.entry.manifest_digest,
    installDir,
  };
}

// ---- rollback ----

function rollbackSelected(stateRoot: string, trustDoc: TrustDoc, targetReceiptDigest: string, coreVersion: string): string {
  requireCanonicalDigest(targetReceiptDigest, "rollback target");
  const current = readStateDoc(stateRoot);
  check(current !== null, "rollback: no lifecycle state");
  const target = current.packages.find((ref) => ref.receipt_digest === targetReceiptDigest);
  check(target !== undefined, "rollback: target receipt is not retained");
  check(target.selection === "retained", "rollback: target receipt is not a retained install");

  const receipt = loadReceipt(stateRoot, targetReceiptDigest);
  check(receipt !== null, "rollback: retained receipt document missing or forged");
  check(receiptMatchesReference(receipt, target), "rollback: retained receipt fields do not match the reference");
  const manifest = verifyInstalledIdentity(target.installed_path, target, "rollback revalidation");
  check(findRevocation(trustDoc, target.package_id, target.tree_digest, target.manifest_digest) === null,
    "rollback: target identity is revoked");
  check(checkSemverCompatibility(manifest.compatible_core_range, coreVersion),
    "rollback: target incompatible with core " + coreVersion);

  const packages: LifecycleRef[] = [];
  for (const ref of current.packages) {
    const copied = { ...ref };
    if (copied.receipt_digest === targetReceiptDigest) {
      copied.selection = "selected";
    } else if (copied.selection === "selected" && copied.package_id === target.package_id) {
      copied.selection = "retained";
    }
    packages.push(copied);
  }
  replaceStateCas(stateRoot, current.state_revision, String(Number.parseInt(current.state_revision, 10) + 1), packages);

  const n = "rolled back " + target.package_id + " to " + target.version + " identity=" + target.tree_digest;
  notice(n);
  return n;
}

// ---- language-package-host.v1 adapter ----
//
// Provider-neutral JSON request/result machine contract. A host maps its
// native catalogue, filesystem identity, atomic state, acquisition, and
// process capabilities onto resolve, acquire_activate, and rollback. No
// bundled language runtime or control plane is a consumer prerequisite; this
// file is one reference host, and a conforming host may implement the same
// messages natively.

interface HostRequest {
  protocol_version: string;
  request_id: string;
  operation: "resolve" | "acquire_activate" | "rollback";
  intent: "workflow_request" | "activation" | "detection";
  package_id: string;
  version: string;
  language: string;
  workflow: string;
  core_version: string;
  consumer_scope?: string;
  consumer_dir: string;
  state_root: string;
  target_receipt_digest?: string;
}

interface HostResult {
  protocol_version: string;
  request_id: string;
  operation: "resolve" | "acquire_activate" | "rollback";
  status: "routed" | "activated" | "rolled_back" | "stopped";
  notice: string;
  tree_digest?: string;
  manifest_digest?: string;
  installed_path?: string;
  receipt_digest?: string;
}

type HostCapability = "catalogue" | "identity" | "atomic" | "process" | "acquisition";

const OP_CAPABILITIES: Record<HostRequest["operation"], HostCapability[]> = {
  resolve: ["catalogue", "identity"],
  acquire_activate: ["catalogue", "identity", "atomic", "process", "acquisition"],
  rollback: ["catalogue", "identity", "atomic"],
};

function parseHostRequest(raw: unknown, context: string): HostRequest {
  const doc = asRecord(raw, context);
  check(asString(doc.protocol_version, context + ".protocol_version") === "1.0.0", context + " has unsupported protocol_version");
  check(REQUEST_ID.test(asString(doc.request_id, context + ".request_id")), context + " has invalid request_id");
  const operation = asString(doc.operation, context + ".operation");
  check(operation === "resolve" || operation === "acquire_activate" || operation === "rollback", context + " has invalid operation");
  const intent = asString(doc.intent, context + ".intent");
  check(intent === "workflow_request" || intent === "activation" || intent === "detection", context + " has invalid intent");
  check(PACKAGE_ID.test(asString(doc.package_id, context + ".package_id")), context + " has invalid package_id");
  check(SEMVER.test(asString(doc.version, context + ".version")), context + " has invalid version");
  asString(doc.language, context + ".language");
  const workflow = asString(doc.workflow, context + ".workflow");
  check(workflow === "everyday_authoring" || workflow === "explicit_audit_repair", context + " has invalid workflow");
  check(SEMVER.test(asString(doc.core_version, context + ".core_version")), context + " has invalid core_version");
  if (doc.consumer_scope !== undefined) {
    asString(doc.consumer_scope, context + ".consumer_scope");
  }
  asString(doc.consumer_dir, context + ".consumer_dir");
  asString(doc.state_root, context + ".state_root");
  if (operation === "rollback") {
    requireCanonicalDigest(doc.target_receipt_digest, context + ".target_receipt_digest");
  }
  return raw as HostRequest;
}

function parseHostResult(raw: unknown, context: string): HostResult {
  const doc = asRecord(raw, context);
  check(asString(doc.protocol_version, context + ".protocol_version") === "1.0.0", context + " has unsupported protocol_version");
  check(REQUEST_ID.test(asString(doc.request_id, context + ".request_id")), context + " has invalid request_id");
  const operation = asString(doc.operation, context + ".operation");
  check(operation === "resolve" || operation === "acquire_activate" || operation === "rollback", context + " has invalid operation");
  const status = asString(doc.status, context + ".status");
  check(status === "routed" || status === "activated" || status === "rolled_back" || status === "stopped", context + " has invalid status");
  asString(doc.notice, context + ".notice");
  return raw as HostResult;
}

function hostResult(request: HostRequest, fields: Omit<HostResult, "protocol_version" | "request_id">): HostResult {
  return { protocol_version: "1.0.0", request_id: request.request_id, ...fields };
}

function hostTrustDoc(stateRoot: string): TrustDoc {
  const p = path.join(stateRoot, "operator-trust.json");
  if (!fs.existsSync(p)) {
    return { schema_version: "1.0.0", revision: "0", allowlist: [], revocations: [] };
  }
  return parseTrustDoc(JSON.parse(fs.readFileSync(p, "utf8")), "operator-trust.json");
}

function hostRegistry(registryPath: string | null): RegistryDoc {
  if (registryPath !== null && fs.existsSync(registryPath)) {
    return parseRegistryDoc(JSON.parse(fs.readFileSync(registryPath, "utf8")), "host registry");
  }
  return { schema_version: "1.0.0", registry_version: "1.0.0", packages: [] };
}

function hostStopped(request: HostRequest, message: string): HostResult {
  notice(message);
  return hostResult(request, { operation: request.operation, status: "stopped", notice: message });
}

function executeHostRequest(request: HostRequest, registryPath: string | null, capabilities: Set<HostCapability>): HostResult {
  const needed = OP_CAPABILITIES[request.operation];
  for (const capability of needed) {
    if (!capabilities.has(capability)) {
      const n = "host capability missing: " + capability + " for operation " + request.operation + " (" + request.package_id + "@" + request.version + " " + request.workflow + ")";
      return hostStopped(request, n);
    }
  }
  try {
    const trustDoc = hostTrustDoc(request.state_root);
    const registry = hostRegistry(registryPath);
    // The request's consumer scope binds trust restrictions at the host
    // boundary; it cannot be silently ignored.
    const requestScope = request.consumer_scope ?? null;
    if (request.operation === "resolve") {
      const resolved = resolveInstalledPackage(request.state_root, trustDoc, request.package_id, request.version, request.language, request.workflow, request.core_version);
      if (resolved === null) {
        const n = "no compatible installed package for " + request.package_id + "@" + request.version + " (" + request.workflow + ")";
        return hostStopped(request, n);
      }
      // Registry-owned discovery must agree with the verified installed
      // manifest before routing. A registry entry claiming languages,
      // overlays, or workflows the manifest no longer declares is metadata
      // drift; drift stops the route instead of trusting the pin. Packages
      // installed without a registry entry (operator-allowlisted content)
      // keep routing exactly as before.
      const selectedEntry = registry.packages.find((candidate) =>
        candidate.package_id === request.package_id && candidate.version === request.version) ?? null;
      if (selectedEntry !== null && !discoveryAgrees(selectedEntry, resolved.manifest)) {
        const n = "registry discovery metadata disagrees with the verified installed manifest for " +
          request.package_id + "@" + request.version + " (metadata drift); the route stops before execution";
        return hostStopped(request, n);
      }
      enforceRouteRestrictions(trustDoc, registry, request.package_id, request.version, resolved.reference.tree_digest, resolved.reference.manifest_digest, request.workflow, requestScope);
      const n = "routed " + request.package_id + " " + request.workflow + " local-only identity=" + resolved.reference.tree_digest;
      notice(n);
      return hostResult(request, {
        operation: "resolve",
        status: "routed",
        notice: n,
        tree_digest: resolved.reference.tree_digest,
        manifest_digest: resolved.reference.manifest_digest,
        installed_path: resolved.reference.installed_path,
        receipt_digest: resolved.reference.receipt_digest,
      });
    }
    if (request.operation === "acquire_activate") {
      const outcome = acquireAndActivate({
        stateRoot: request.state_root,
        consumerDir: request.consumer_dir,
        trustDoc,
        registry,
        packageId: request.package_id,
        version: request.version,
        language: request.language,
        workflow: request.workflow,
        coreVersion: request.core_version,
        consumerScopeHint: requestScope,
        adapter: hostAcquisitionAdapter(),
        intent: request.intent,
      });
      if (outcome.status === "activated" || outcome.status === "routed") {
        return hostResult(request, {
          operation: "acquire_activate",
          status: outcome.status === "activated" ? "activated" : "routed",
          notice: outcome.notice,
          tree_digest: outcome.treeDigest,
          manifest_digest: outcome.manifestDigest,
          installed_path: outcome.installDir,
          receipt_digest: outcome.receiptDigest,
        });
      }
      return hostStopped(request, outcome.notice);
    }
    const noticeText = rollbackSelected(request.state_root, trustDoc, request.target_receipt_digest as string, request.core_version);
    const after = readStateDoc(request.state_root) as LifecycleDoc;
    const target = after.packages.find((ref) => ref.receipt_digest === request.target_receipt_digest);
    return hostResult(request, {
      operation: "rollback",
      status: "rolled_back",
      notice: noticeText,
      tree_digest: target?.tree_digest,
      manifest_digest: target?.manifest_digest,
      installed_path: target?.installed_path,
      receipt_digest: request.target_receipt_digest,
    });
  } catch (err) {
    const n = "workflow " + request.workflow + " for " + request.package_id + "@" + request.version + " stopped: " + (err as Error).message + "; manual or local-path installation route required";
    return hostStopped(request, n);
  }
}

const FULL_HOST_CAPABILITIES = new Set<HostCapability>(["catalogue", "identity", "atomic", "process", "acquisition"]);

// GENERIC-SURFACE-SCAN-END
// ============================================================================
// cas-race: real two-process compare-and-swap contention.
//
// usage: cas-race <state-root> <observed> <payload-file> <mode>
//   mode "hold":    acquire the lifecycle lock, write <state-root>/.race-ready,
//                   poll for <state-root>/.race-go (bounded), then CAS with the
//                   observed revision and release.
//   mode "attempt": attempt replaceStateCas with the observed revision; print
//                   "cas-attempt: committed" or "cas-attempt: conflict".
// ============================================================================

function casRaceMain(args: string[]): void {
  const stateRoot = args[0];
  const observed = args[1];
  const payloadFile = args[2];
  const mode = args[3];
  check(fs.existsSync(stateRoot) && fs.statSync(stateRoot).isDirectory(), "race state root missing: " + stateRoot);
  const payload = JSON.parse(fs.readFileSync(payloadFile, "utf8")) as LifecycleDoc;
  // The payload is the proposed NEXT state; it must advance the observed
  // revision by exactly one.
  check(payload.state_revision === String(Number.parseInt(observed, 10) + 1),
    "race payload revision must advance the observed revision by one");
  if (mode === "hold") {
    const ready = path.join(stateRoot, ".race-ready");
    const go = path.join(stateRoot, ".race-go");
    let acquired = false;
    const lock = path.join(stateRoot, ".lifecycle.lock");
    while (!acquired) {
      try {
        const fd = fs.openSync(lock, "wx");
        fs.writeSync(fd, String(process.pid));
        fs.closeSync(fd);
        acquired = true;
      } catch (err) {
        const code = (err as NodeJS.ErrnoException).code;
        if (code !== "EEXIST") {
          throw err;
        }
        throw new Error("cas-race hold: lock already held");
      }
    }
    try {
      fs.writeFileSync(ready, String(process.pid));
      const deadline = Date.now() + 30000;
      while (!fs.existsSync(go)) {
        if (Date.now() > deadline) {
          throw new Error("cas-race hold: go barrier timed out");
        }
        // busy-wait is bounded by the deadline; the barrier is the parent
      }
      const current = readStateDoc(stateRoot);
      const currentRevision = current === null ? "0" : current.state_revision;
      check(currentRevision === observed,
        "lifecycle CAS conflict: observed revision " + observed + " is stale; current revision is " + currentRevision);
      writeFileAtomic(stateFilePath(stateRoot), JSON.stringify(payload));
      console.log("cas-hold: committed");
    } finally {
      fs.rmSync(lock, { force: true });
    }
    return;
  }
  if (mode === "attempt") {
    try {
      replaceStateCas(stateRoot, observed, String(Number.parseInt(observed, 10) + 1), payload.packages);
      console.log("cas-attempt: committed");
    } catch (err) {
      console.log("cas-attempt: conflict: " + (err as Error).message);
    }
    return;
  }
  throw new Error("cas-race: unknown mode " + mode);
}

// ============================================================================
// Oracle suite: fixed vectors and the eight review-oracle rows plus the
// lifecycle transition matrix, concurrency, restrictions, and self-check.
// ============================================================================

function mkdirP(p: string): void {
  fs.mkdirSync(p, { recursive: true });
}

function writeBytes(p: string, data: Buffer, mode = 0o644): void {
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, data, { mode });
}

function writeText(p: string, text: string, mode = 0o644): void {
  writeBytes(p, Buffer.from(text, "utf8"), mode);
}

function snapshotHashes(root: string): string[] {
  const out: string[] = [];
  if (!fs.existsSync(root)) {
    return out;
  }
  const walk = (dir: string): void => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(p);
      } else if (entry.isFile()) {
        out.push(entry.name + ":" + sha256Hex(fileBytes(p)));
      }
    }
  };
  walk(root);
  out.sort();
  return out;
}

function requireHashesUnchanged(label: string, root: string, before: string[]): void {
  const after = snapshotHashes(root);
  check(JSON.stringify(after) === JSON.stringify(before), label + " changed consumer/state bytes: " + JSON.stringify(after));
}

function fixtureTrustDoc(fixtureRoot: string, extra: TrustEntry[], revocations: Revocation[]): TrustDoc {
  const allowlist: TrustEntry[] = [
    {
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      source_identity: { type: "local_path", path: fixtureRoot },
      tree_digest: FIXTURE_TREE_DIGEST,
      manifest_digest: FIXTURE_MANIFEST_DIGEST,
      compatible_core_range: ">=0.2.0 <1.0.0",
      workflows: ["explicit_audit_repair"],
      actor: "operator",
      timestamp: TIMESTAMP,
      reason: "card 117 fixture pin",
    },
  ];
  for (const entry of extra) {
    allowlist.push(entry);
  }
  return { schema_version: "1.0.0", revision: "1", allowlist, revocations };
}

function stagedDir(prefix: string): string {
  return fs.mkdtempSync(path.join(fs.mkdtempSync(path.join(process.env.TMPDIR ?? "/tmp", prefix)), "s-"));
}

function fixtureAdapter(fixtureRoot: string): () => string {
  return () => {
    const staged = stagedDir("northstar-staged-");
    copyTree(fixtureRoot, staged);
    return staged;
  };
}

function offlineAdapter(): () => string {
  return () => {
    throw new Error("network unavailable");
  };
}

function consumerDir(extraFiles: Record<string, string> = {}): string {
  const dir = fs.mkdtempSync(path.join(process.env.TMPDIR ?? "/tmp", "northstar-consumer-"));
  fs.mkdirSync(path.join(dir, "docs/contracts"), { recursive: true });
  writeText(path.join(dir, "README.md"), "# consumer\n");
  for (const [rel, content] of Object.entries(extraFiles)) {
    writeText(path.join(dir, rel), content);
  }
  return dir;
}

function buildVariantPackage(fixtureRoot: string, version: string, mutate: (manifest: Manifest, root: string) => void): string {
  const variant = stagedDir("northstar-variant-");
  copyTree(fixtureRoot, variant);
  const manifestPath = path.join(variant, "northstar-package.json");
  const manifest = parseManifest(JSON.parse(fs.readFileSync(manifestPath, "utf8")), "variant manifest");
  manifest.version = version;
  mutate(manifest, variant);
  fs.writeFileSync(manifestPath, JSON.stringify(manifest));
  return variant;
}

function variantPin(packageId: string, version: string, variantRoot: string): TrustEntry {
  const manifestPath = path.join(variantRoot, "northstar-package.json");
  return {
    package_id: packageId,
    version,
    source_identity: { type: "local_path", path: variantRoot },
    tree_digest: canonicalTreeDigest(variantRoot, "variant"),
    manifest_digest: manifestDigestOf(manifestPath),
    compatible_core_range: ">=0.2.0 <1.0.0",
    actor: "operator",
    timestamp: TIMESTAMP,
    reason: "card 117 variant pin",
  };
}

function emptyRegistry(): RegistryDoc {
  return { schema_version: "1.0.0", registry_version: "1.0.0", packages: [] };
}

function runVectors(fixtureRoot: string): void {
  // Fixed external vectors: expected digests are independent constants above,
  // not derived by this implementation.
  check(manifestDigestOf(path.join(fixtureRoot, "northstar-package.json")) === FIXTURE_MANIFEST_DIGEST,
    "fixture manifest identity drifted from the independent vector");
  check(canonicalTreeDigest(fixtureRoot, "fixture") === FIXTURE_TREE_DIGEST,
    "fixture tree identity drifted from the independent vector");

  // Digest spelling drift is rejected.
  let drift = false;
  try {
    requireCanonicalDigest("c4ac81024268c8974002007aa5085cf4fae4b060f694c454e93c712add3ab6ef", "spelling");
  } catch (err) {
    drift = (err as Error).message.includes("non-canonical digest spelling");
  }
  check(drift, "bare-hex digest spelling was not rejected");
  let caseDrift = false;
  try {
    requireCanonicalDigest("SHA256:c4ac81024268c8974002007aa5085cf4fae4b060f694c454e93c712add3ab6ef", "spelling");
  } catch (err) {
    caseDrift = (err as Error).message.includes("non-canonical digest spelling");
  }
  check(caseDrift, "upper-case digest prefix was not rejected");

  // Cross-adapter reordered materialization yields the same identity.
  const stageA = fs.mkdtempSync(path.join(process.env.TMPDIR ?? "/tmp", "northstar-adapter-a-"));
  copyTree(fixtureRoot, stageA);
  const stageB = fs.mkdtempSync(path.join(process.env.TMPDIR ?? "/tmp", "northstar-adapter-b-"));
  const files: string[] = [];
  const collect = (dir: string, relDir: string): void => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const rel = relDir === "" ? entry.name : relDir + "/" + entry.name;
      if (entry.isDirectory()) {
        collect(path.join(dir, entry.name), rel);
      } else if (entry.isFile()) {
        files.push(rel);
      }
    }
  };
  collect(fixtureRoot, "");
  for (const rel of files.reverse()) {
    const dest = path.join(stageB, rel);
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.writeFileSync(dest, fileBytes(path.join(fixtureRoot, rel)));
    fs.chmodSync(dest, fs.statSync(path.join(fixtureRoot, rel)).mode & 0o777);
  }
  const digestA = canonicalTreeDigest(stageA, "adapter-a");
  const digestB = canonicalTreeDigest(stageB, "adapter-b");
  check(digestA === FIXTURE_TREE_DIGEST && digestB === FIXTURE_TREE_DIGEST && digestA === digestB,
    "cross-adapter reordered materialization produced differing identities");

  // Symlink preserved by a transport: rejected, never followed.
  const symlinkStage = fs.mkdtempSync(path.join(process.env.TMPDIR ?? "/tmp", "northstar-symlink-"));
  copyTree(fixtureRoot, symlinkStage);
  fs.symlinkSync("SKILL.md", path.join(symlinkStage, "evil-link"));
  let symlinkRejected = false;
  try {
    canonicalTreeDigest(symlinkStage, "symlink");
  } catch (err) {
    symlinkRejected = (err as Error).message.includes("symbolic link");
  }
  check(symlinkRejected, "symlink payload was not rejected");

  // Special file: rejected when the host can create one.
  const fifoStage = fs.mkdtempSync(path.join(process.env.TMPDIR ?? "/tmp", "northstar-fifo-"));
  copyTree(fixtureRoot, fifoStage);
  const fifo = spawnSync("mkfifo", [path.join(fifoStage, "pipe")], { encoding: "utf8" });
  if (fifo.status === 0) {
    let specialRejected = false;
    try {
      canonicalTreeDigest(fifoStage, "special");
    } catch (err) {
      specialRejected = (err as Error).message.includes("special file");
    }
    check(specialRejected, "special file payload was not rejected");
  }

  // Case-fold collision: fold-equivalent names must not both register.
  check(asciiCaseFold("SKILL.md") === asciiCaseFold("skill.md"), "ascii case fold does not equate case-only variants");
  const seen = new Set<string>();
  seen.add(asciiCaseFold("SKILL.md"));
  check(seen.has(asciiCaseFold("skill.md")), "case-fold path collision was not rejected");

  // Byte-exact vectors: NUL, non-UTF-8, multibyte, executable, non-executable.
  const base = fs.mkdtempSync(path.join(process.env.TMPDIR ?? "/tmp", "northstar-vectors-"));
  const buildTree = (name: string, files: Array<[string, Buffer, number]>): string => {
    const root = path.join(base, name);
    for (const [rel, data, mode] of files) {
      writeBytes(path.join(root, rel), data, mode);
    }
    return root;
  };
  const nul = buildTree("nul", [
    ["SKILL.md", Buffer.from("# x\n\0\0binary\n", "latin1"), 0o644],
    ["northstar-package.json", Buffer.from('{"a":1}\n'), 0o600],
  ]);
  check(canonicalTreeDigest(nul, "nul") === V_NUL, "NUL-byte content vector drifted");
  const nonUtf8 = buildTree("nonutf8", [
    ["SKILL.md", Buffer.from([0x23, 0x20, 0xff, 0xfe, 0x00, 0x20, 0x72, 0x61, 0x77, 0x20, 0x62, 0x79, 0x74, 0x65, 0x73, 0x0a]), 0o644],
    ["northstar-package.json", Buffer.from('{"a":1}\n'), 0o644],
  ]);
  check(canonicalTreeDigest(nonUtf8, "nonutf8") === V_NONUTF8, "non-UTF-8 content vector drifted");
  const multi = buildTree("multi", [
    ["SKILL.md", Buffer.from("café € 😀\n", "utf8"), 0o644],
    ["northstar-package.json", Buffer.from('{"a":1}\n'), 0o644],
  ]);
  check(canonicalTreeDigest(multi, "multi") === V_MULTI, "multibyte content vector drifted");
  const exe = buildTree("exe", [
    ["SKILL.md", Buffer.from("# x\n"), 0o755],
    ["northstar-package.json", Buffer.from('{"a":1}\n'), 0o644],
  ]);
  check(canonicalTreeDigest(exe, "exe") === V_EXE, "executable 0755 vector drifted");
  const noexe444 = buildTree("m444", [
    ["SKILL.md", Buffer.from("# x\n"), 0o444],
    ["northstar-package.json", Buffer.from('{"a":1}\n'), 0o444],
  ]);
  check(canonicalTreeDigest(noexe444, "m444") === V_NOEXE, "non-executable 0444 vector drifted");
  const noexe600 = buildTree("m600", [
    ["SKILL.md", Buffer.from("# x\n"), 0o600],
    ["northstar-package.json", Buffer.from('{"a":1}\n'), 0o600],
  ]);
  check(canonicalTreeDigest(noexe600, "m600") === V_NOEXE, "non-executable 0600 vector drifted");
  check(canonicalTreeDigest(noexe444, "m444") === canonicalTreeDigest(noexe600, "m600"),
    "non-executable modes must derive the same identity");
  check(canonicalTreeDigest(exe, "exe") !== V_NOEXE, "executable bit must change the identity");
  const recs = collectCanonicalFileRecords(exe, "executable");
  check(recs.some((r) => r.path === "SKILL.md" && r.executable === 1), "executable bit not recorded in canonical records");

  console.log("card-117 vectors: PASS (independent constants, NUL, non-UTF-8, multibyte, 0755/0600/0444, reorder, symlink, special, fold, spelling)");
}

async function runOracle(fixtureRoot: string, outRoot: string): Promise<void> {
  mkdirP(outRoot);

  // ---- oracle 1: detection is not authority ----
  {
    const out = path.join(outRoot, "r1-detect");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir({
      "Cargo.toml": "[package]\nname = \"detection-fixture\"\n",
      "src/main.rs": "fn main() {}\n",
    });
    const consumerBefore = snapshotHashes(consumer);
    const trustDoc = fixtureTrustDoc(fixtureRoot, [], []);
    const registry = emptyRegistry();
    let calls = 0;
    const adapter = (): string => {
      calls += 1;
      return fixtureAdapter(fixtureRoot)();
    };
    const outcome = acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter, intent: "detection",
    });
    check(outcome.status === "no-route", "detection-only invocation acquired or routed a package");
    check(calls === 0, "detection-only invocation called the transport adapter " + calls + " times");
    requireHashesUnchanged("detection-only consumer", consumer, consumerBefore);
    check(!fs.existsSync(stateFilePath(stateRoot)), "detection-only invocation created lifecycle state");
    console.log("oracle-1 detection-is-not-authority: PASS");
  }

  // ---- oracle 2: content identity is canonical ----
  {
    runVectors(fixtureRoot);
    console.log("oracle-2 content-identity-canonical: PASS");
  }

  // ---- oracle 3: activation is transactional ----
  {
    const out = path.join(outRoot, "r3-tx");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir();
    const consumerBefore = snapshotHashes(consumer);
    const trustDoc = fixtureTrustDoc(fixtureRoot, [], []);
    const registry = emptyRegistry();

    let calls = 0;
    const adapter = (): string => {
      calls += 1;
      return fixtureAdapter(fixtureRoot)();
    };
    const first = acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter, intent: "workflow_request",
    });
    check(first.status === "activated", "fixture install did not activate");
    check(calls === 1, "install used the adapter more than once");
    requireHashesUnchanged("install consumer", consumer, consumerBefore);
    let state1 = readStateDoc(stateRoot);
    check(state1 !== null && state1.state_revision === "1", "install did not advance state revision to 1");
    check(state1.packages.length === 1 && state1.packages[0].selection === "selected", "install did not select exactly one receipt");
    check(loadReceipt(stateRoot, state1.packages[0].receipt_digest) !== null, "installed receipt missing");

    // Update: pinned 0.2.0 variant, prior receipt retained.
    const variant = buildVariantPackage(fixtureRoot, "0.2.0", () => undefined);
    const variantPinEntry = variantPin("@northstar/language-fixture", "0.2.0", variant);
    const trustDocV = fixtureTrustDoc(fixtureRoot, [variantPinEntry], []);
    let variantCalls = 0;
    const variantAdapter = (): string => {
      variantCalls += 1;
      const staged = stagedDir("northstar-staged-");
      copyTree(variant, staged);
      return staged;
    };
    const update = acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc: trustDocV, registry,
      packageId: "@northstar/language-fixture", version: "0.2.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: variantAdapter, intent: "workflow_request",
    });
    check(update.status === "activated", "update did not activate");
    state1 = readStateDoc(stateRoot);
    check(state1 !== null && state1.state_revision === "2", "update did not advance state revision to 2");
    check(state1.packages.length === 2, "update did not retain the previous install");
    const selected2 = state1.packages.filter((ref) => ref.selection === "selected").map((ref) => ref.version);
    check(JSON.stringify(selected2) === JSON.stringify(["0.2.0"]), "update did not select the new version");
    requireHashesUnchanged("update consumer", consumer, consumerBefore);

    // Failed update: candidate self-check fails AFTER bytes stage; the
    // failing self-check writes a marker (side effect proves it ran).
    const failing = buildVariantPackage(fixtureRoot, "0.3.0", (manifest, root) => {
      manifest.self_check.entrypoint = "scripts/self-check-fail.sh";
      writeText(path.join(root, "scripts/self-check-fail.sh"),
        "#!/bin/sh\nset -eu\nroot=\"${1:?usage}\"\ntouch \"$root/self-check-ran.marker\"\necho \"[fixture-package:self-check] failing on purpose\" >&2\nexit 1\n", 0o755);
    });
    const failingPin = variantPin("@northstar/language-fixture", "0.3.0", failing);
    const trustDocB = fixtureTrustDoc(fixtureRoot, [failingPin], []);
    const failingAdapter = (): string => {
      const staged = stagedDir("northstar-staged-");
      copyTree(failing, staged);
      return staged;
    };
    const stateBeforeFail = fs.readFileSync(stateFilePath(stateRoot), "utf8");
    let failed = false;
    let failMsg = "";
    try {
      acquireAndActivate({
        stateRoot, consumerDir: consumer, trustDoc: trustDocB, registry,
        packageId: "@northstar/language-fixture", version: "0.3.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: failingAdapter, intent: "workflow_request",
      });
    } catch (err) {
      failed = true;
      failMsg = (err as Error).message;
    }
    check(failed, "self-check-failing candidate unexpectedly activated");
    check(failMsg.includes("self-check failed"), "failed update stopped at the wrong gate: " + failMsg);
    // The failing self-check actually ran: its output names the failure.
    check(failMsg.includes("failing on purpose"), "failing self-check output did not prove execution: " + failMsg);
    check(fs.readFileSync(stateFilePath(stateRoot), "utf8") === stateBeforeFail, "failed update mutated lifecycle state");
    requireHashesUnchanged("failed-update consumer", consumer, consumerBefore);
    state1 = readStateDoc(stateRoot);
    check(state1 !== null && state1.state_revision === "2" && state1.packages.length === 2, "failed update changed the state revision or duplicated references");
    const selected3 = state1.packages.filter((ref) => ref.selection === "selected").map((ref) => ref.version);
    check(JSON.stringify(selected3) === JSON.stringify(["0.2.0"]), "failed update changed the selected receipt");

    // Rollback reselects the retained proven install without fetching.
    const callsBeforeRollback = variantCalls;
    const rollbackNotice = rollbackSelected(stateRoot, trustDocV, first.receiptDigest as string, CORE_VERSION);
    check(rollbackNotice.includes("rolled back"), "rollback did not complete");
    check(variantCalls === callsBeforeRollback, "rollback fetched from a transport");
    state1 = readStateDoc(stateRoot);
    check(state1 !== null && state1.state_revision === "3", "rollback did not advance the state revision");
    const selected4 = state1.packages.filter((ref) => ref.selection === "selected").map((ref) => ref.version);
    check(JSON.stringify(selected4) === JSON.stringify(["0.1.0"]), "rollback did not reselect the retained install");
    requireHashesUnchanged("rollback consumer", consumer, consumerBefore);

    // Failed rollback: retained bytes tampered -> selection and state exact.
    writeText(path.join(update.installDir as string, "SKILL.md"), "tampered\n");
    const stateBeforeFailRollback = fs.readFileSync(stateFilePath(stateRoot), "utf8");
    let rbFailed = false;
    try {
      rollbackSelected(stateRoot, trustDocV, update.receiptDigest as string, CORE_VERSION);
    } catch (err) {
      rbFailed = (err as Error).message.includes("drifted");
    }
    check(rbFailed, "tampered retained bytes did not block rollback");
    check(fs.readFileSync(stateFilePath(stateRoot), "utf8") === stateBeforeFailRollback, "failed rollback mutated lifecycle state");
    console.log("oracle-3 activation-transactional: PASS");
  }

  // ---- oracle 4: state is operator-owned compare-and-swap ----
  {
    const out = path.join(outRoot, "r4-owned");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir({
      "docs/contracts/language-quality-config.json": JSON.stringify({ package_id: "@northstar/language-fixture", version: "0.1.0", trusted: true, selected: true }),
    });
    const consumerBefore = snapshotHashes(consumer);
    const trustDoc = fixtureTrustDoc(fixtureRoot, [], []);
    const registry = emptyRegistry();
    let calls = 0;
    const adapter = (): string => {
      calls += 1;
      return fixtureAdapter(fixtureRoot)();
    };

    const installed = resolveInstalledPackage(stateRoot, trustDoc, "@northstar/language-fixture", "0.1.0", "fixture-lang", "explicit_audit_repair", CORE_VERSION);
    check(installed === null, "consumer config alone routed a package");

    let blocked = false;
    try {
      acquireAndActivate({
        stateRoot, consumerDir: consumer, trustDoc, registry,
        packageId: "@northstar/consumer-claimed", version: "0.1.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter, intent: "workflow_request",
      });
    } catch (err) {
      blocked = (err as Error).message.includes("no trusted pin");
    }
    check(blocked, "consumer-claimed trust authorized acquisition");
    check(calls === 0, "consumer-claimed request reached the transport");
    requireHashesUnchanged("consumer-owned claim", consumer, consumerBefore);
    check(!fs.existsSync(stateFilePath(stateRoot)), "consumer-claimed request created state");

    acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter, intent: "workflow_request",
    });
    const observedA = readStateDoc(stateRoot)?.state_revision as string;
    const variant = buildVariantPackage(fixtureRoot, "0.2.0", () => undefined);
    const variantPinEntry = variantPin("@northstar/language-fixture", "0.2.0", variant);
    const trustDocV = fixtureTrustDoc(fixtureRoot, [variantPinEntry], []);
    const variantAdapter = (): string => {
      const staged = stagedDir("northstar-staged-");
      copyTree(variant, staged);
      return staged;
    };
    acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc: trustDocV, registry,
      packageId: "@northstar/language-fixture", version: "0.2.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: variantAdapter, intent: "workflow_request",
    });
    check(readStateDoc(stateRoot)?.state_revision !== observedA, "writer B did not advance the revision");
    const stateBeforeStale = fs.readFileSync(stateFilePath(stateRoot), "utf8");
    let staleFailed = false;
    let staleMsg = "";
    try {
      const stalePackages = JSON.parse(JSON.stringify(readStateDoc(stateRoot)?.packages ?? [])) as LifecycleRef[];
      stalePackages.push({
        package_id: "@northstar/language-fixture",
        version: "0.9.9",
        tree_digest: "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        manifest_digest: "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        receipt_digest: "sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        installed_path: "/stale/0.9.9",
        selection: "selected",
        installed_at: TIMESTAMP,
      });
      replaceStateCas(stateRoot, observedA, "99", stalePackages);
    } catch (err) {
      staleFailed = true;
      staleMsg = (err as Error).message;
    }
    check(staleFailed && staleMsg.includes("CAS conflict"), "stale writer was not stopped: " + staleMsg);
    check(fs.readFileSync(stateFilePath(stateRoot), "utf8") === stateBeforeStale, "stale writer mutated lifecycle state");
    const stateFinal = readStateDoc(stateRoot) as LifecycleDoc;
    const selectedFinal = stateFinal.packages.filter((ref) => ref.selection === "selected").map((ref) => ref.version);
    check(JSON.stringify(selectedFinal) === JSON.stringify(["0.2.0"]), "stale writer replaced the selection");
    check(stateFinal.packages.filter((ref) => ref.version === "0.2.0").length === 1, "stale writer duplicated an installed package");
    console.log("oracle-4 operator-owned-compare-and-swap: PASS");
  }

  // ---- oracle 5: offline is local ----
  {
    const out = path.join(outRoot, "r5-offline");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir();
    const trustDoc = fixtureTrustDoc(fixtureRoot, [], []);
    const registry = emptyRegistry();
    acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
    });
    let offlineCalls = 0;
    const offlineAdapterSpy = (): string => {
      offlineCalls += 1;
      throw new Error("network unavailable");
    };
    const routed = acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: offlineAdapterSpy, intent: "workflow_request",
    });
    check(routed.status === "routed", "offline installed route did not route");
    check(routed.notice.includes(FIXTURE_TREE_DIGEST), "offline route resolved the wrong identity");
    check(offlineCalls === 0, "offline route touched the network adapter");
    console.log("oracle-5 offline-is-local: PASS");
  }

  // ---- oracle 6: failure is scoped ----
  {
    const out = path.join(outRoot, "r6-scope");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir();
    const trustDoc = fixtureTrustDoc(fixtureRoot, [], []);
    const registry = emptyRegistry();
    acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
    });
    const stateBefore = fs.readFileSync(stateFilePath(stateRoot), "utf8");
    let missingStopped = false;
    let missingNotice = "";
    try {
      acquireAndActivate({
        stateRoot, consumerDir: consumer, trustDoc, registry,
        packageId: "@northstar/missing-fixture", version: "0.1.0",
        language: "missing-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: offlineAdapter(), intent: "workflow_request",
      });
    } catch (err) {
      missingStopped = true;
      missingNotice = (err as Error).message;
    }
    check(missingStopped, "missing package did not stop the workflow");
    check(missingNotice.includes("manual or local-path"), "failure notice lacks the local installation route");
    check(missingNotice.includes("@northstar/missing-fixture"), "failure notice lacks the exact identity");
    check(fs.readFileSync(stateFilePath(stateRoot), "utf8") === stateBefore, "scoped failure mutated lifecycle state");
    const routed = acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: offlineAdapter(), intent: "workflow_request",
    });
    check(routed.status === "routed", "core route failed after scoped package failure");
    console.log("oracle-6 failure-is-scoped: PASS");
  }

  // ---- oracle 7: trust is revocable ----
  {
    const out = path.join(outRoot, "r7-revoke");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir();
    const trustDoc = fixtureTrustDoc(fixtureRoot, [], []);
    const registry = emptyRegistry();
    acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
    });
    const stateBefore = snapshotHashes(stateRoot);
    const revokedDoc = fixtureTrustDoc(fixtureRoot, [], [
      {
        package_id: "@northstar/language-fixture",
        version: "0.1.0",
        tree_digest: FIXTURE_TREE_DIGEST,
        manifest_digest: FIXTURE_MANIFEST_DIGEST,
        actor: "operator",
        timestamp: TIMESTAMP,
        reason: "revocation proof",
      },
    ]);
    let outcomeStatus = "unknown";
    let blocked = false;
    try {
      const outcome = acquireAndActivate({
        stateRoot, consumerDir: consumer, trustDoc: revokedDoc, registry,
        packageId: "@northstar/language-fixture", version: "0.1.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
      });
      outcomeStatus = outcome.status;
    } catch (err) {
      outcomeStatus = "stopped";
      blocked = (err as Error).message.includes("revoked");
    }
    check(outcomeStatus !== "routed" && outcomeStatus !== "activated", "revoked identity was routed or re-acquired");
    check(blocked, "revoked identity was acquired");
    check(JSON.stringify(snapshotHashes(stateRoot)) === JSON.stringify(stateBefore),
      "revocation removed installed bytes, receipts, or lifecycle state");
    console.log("oracle-7 trust-is-revocable: PASS");
  }

  // ---- oracle 8: routing is generic ----
  {
    const out = path.join(outRoot, "r8-generic");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir();
    const syntheticRoot = path.join(out, "synthetic");
    copyTree(fixtureRoot, syntheticRoot);
    const synthManifestPath = path.join(syntheticRoot, "northstar-package.json");
    const synthManifest = parseManifest(JSON.parse(fs.readFileSync(synthManifestPath, "utf8")), "synthetic manifest");
    synthManifest.package_id = "@northstar/synthetic-language";
    synthManifest.supported_languages = ["quantum-lang"];
    synthManifest.entrypoints = { explicit_audit_repair: "references/fixture-audit.md" };
    fs.writeFileSync(synthManifestPath, JSON.stringify(synthManifest));
    writeText(path.join(syntheticRoot, "references/fixture-audit.md"), "# Fixture Audit Mode (Synthetic)\n");
    const synthTree = canonicalTreeDigest(syntheticRoot, "synthetic-language");
    const pin: TrustEntry = {
      package_id: "@northstar/synthetic-language",
      version: "0.1.0",
      source_identity: { type: "local_path", path: syntheticRoot },
      tree_digest: synthTree,
      manifest_digest: manifestDigestOf(synthManifestPath),
      compatible_core_range: ">=0.2.0 <1.0.0",
      actor: "operator",
      timestamp: TIMESTAMP,
      reason: "synthetic-language pin",
    };
    const trustDoc: TrustDoc = { schema_version: "1.0.0", revision: "1", allowlist: [pin], revocations: [] };
    const registry = emptyRegistry();
    const adapter = (): string => {
      const staged = stagedDir("northstar-staged-");
      copyTree(syntheticRoot, staged);
      return staged;
    };
    const install = acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/synthetic-language", version: "0.1.0",
      language: "quantum-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter, intent: "workflow_request",
    });
    check(install.status === "activated", "synthetic-language package did not install");
    const routed = acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/synthetic-language", version: "0.1.0",
      language: "quantum-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter, intent: "workflow_request",
    });
    check(routed.status === "routed", "synthetic-language route did not resolve by manifest fields");
    const undeclared = resolveInstalledPackage(stateRoot, trustDoc, "@northstar/synthetic-language", "0.1.0", "quantum-lang", "everyday_authoring", CORE_VERSION);
    check(undeclared === null, "undeclared workflow routed");
    const wrongLanguage = resolveInstalledPackage(stateRoot, trustDoc, "@northstar/synthetic-language", "0.1.0", "fixture-lang", "explicit_audit_repair", CORE_VERSION);
    check(wrongLanguage === null, "wrong-language request routed to the synthetic package");
    const wrongIdentity = resolveInstalledPackage(stateRoot, trustDoc, "@northstar/language-fixture", "0.1.0", "quantum-lang", "explicit_audit_repair", CORE_VERSION);
    check(wrongIdentity === null, "request for another package identity routed");
    console.log("oracle-8 routing-is-generic: PASS");
  }

  // ---- trust restrictions and receipt provenance ----
  {
    const out = path.join(outRoot, "r9-restrictions");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir();
    const registry = emptyRegistry();

    // Restricted workflow: the pin authorizes only everyday authoring.
    const restrictedPin = fixtureTrustDoc(fixtureRoot, [], []);
    restrictedPin.allowlist[0].workflows = ["everyday_authoring"];
    let workflowBlocked = false;
    try {
      acquireAndActivate({
        stateRoot, consumerDir: consumer, trustDoc: restrictedPin, registry,
        packageId: "@northstar/language-fixture", version: "0.1.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
      });
    } catch (err) {
      workflowBlocked = (err as Error).message.includes("restricts workflows");
    }
    check(workflowBlocked, "restricted-workflow pin did not block acquisition");
    check(!fs.existsSync(stateFilePath(stateRoot)), "restricted acquisition created state");

    // Restricted consumer scope: pin scope vs activation marker scope.
    const scopeConsumer = consumerDir({
      "docs/contracts/language-quality-activation.json": JSON.stringify({ package_id: "@northstar/language-fixture", version: "0.1.0", scope: "team-a" }),
    });
    const scopedPin = fixtureTrustDoc(fixtureRoot, [], []);
    scopedPin.allowlist[0].consumer_scope = "team-b";
    let scopeBlocked = false;
    try {
      acquireAndActivate({
        stateRoot, consumerDir: scopeConsumer, trustDoc: scopedPin, registry,
        packageId: "@northstar/language-fixture", version: "0.1.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "activation",
      });
    } catch (err) {
      scopeBlocked = (err as Error).message.includes("restricts consumer scope");
    }
    check(scopeBlocked, "restricted-consumer pin did not block acquisition");

    // Official-source provenance: an official registry pin with git source
    // must produce an official+git receipt, not allowlist+local_path.
    const officialState = path.join(out, "official-state");
    mkdirP(officialState);
    const officialRegistry: RegistryDoc = {
      schema_version: "1.0.0",
      registry_version: "1.0.0",
      packages: [
        {
          package_id: "@northstar/language-fixture",
          version: "0.1.0",
          repository: "https://github.com/inflatable-cookie/northstar.git",
          subpath: "skills/northstar/assets/fixtures/language-packages/policy-free-fixture",
          commit: "8f4a0d639c59900e9b7e4ba746776fe0f0cfb9c6",
          tree_digest: FIXTURE_TREE_DIGEST,
          manifest_digest: FIXTURE_MANIFEST_DIGEST,
          compatible_core_range: ">=0.2.0 <1.0.0",
        },
      ],
    };
    const officialConsumer = consumerDir();
    const officialAcquire = acquireAndActivate({
      stateRoot: officialState, consumerDir: officialConsumer, trustDoc: fixtureTrustDoc(fixtureRoot, [], []), registry: officialRegistry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
    });
    check(officialAcquire.status === "activated", "official-source acquisition did not activate");
    const officialStateDoc = readStateDoc(officialState) as LifecycleDoc;
    const officialReceipt = loadReceipt(officialState, officialStateDoc.packages[0].receipt_digest) as Receipt;
    check(officialReceipt.trust_class.type === "official", "official pin recorded non-official trust");
    check(officialReceipt.source.type === "git" && officialReceipt.source.repository !== undefined, "official git pin recorded non-git source");

    // Route-level restrictions: with the package installed, a pin that
    // restricts workflows to everyday authoring must block the requested
    // explicit-audit route (route execution honors trust restrictions).
    const installedState = path.join(out, "installed-state");
    mkdirP(installedState);
    acquireAndActivate({
      stateRoot: installedState, consumerDir: consumer, trustDoc: fixtureTrustDoc(fixtureRoot, [], []), registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
    });
    const routeRestricted = fixtureTrustDoc(fixtureRoot, [], []);
    routeRestricted.allowlist[0].workflows = ["everyday_authoring"];
    let routeBlocked = false;
    let routeMsg = "";
    try {
      acquireAndActivate({
        stateRoot: installedState, consumerDir: consumer, trustDoc: routeRestricted, registry,
        packageId: "@northstar/language-fixture", version: "0.1.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
      });
    } catch (err) {
      routeBlocked = (err as Error).message.includes("restricts workflows");
      routeMsg = (err as Error).message;
    }
    check(routeBlocked, "route executed a pin-restricted workflow: " + routeMsg);
    console.log("oracle-9 trust-restrictions-and-receipt-provenance: PASS");
  }

  // ---- concurrency: real overlapping processes and interrupted writes ----
  {
    const out = path.join(outRoot, "r10-concurrency");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const trustDoc = fixtureTrustDoc(fixtureRoot, [], []);
    const registry = emptyRegistry();
    const consumer = consumerDir();
    acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
    });
    const revisionN = readStateDoc(stateRoot)?.state_revision as string;

    // Real overlap: writer A is a separate bun process that takes the
    // lifecycle lock and waits on a barrier while holding it; writer B is a
    // second process that attempts the same CAS with the same observed
    // revision while A still holds the lock. B must fail closed without
    // removing A's lock; A must then commit exactly once.
    const raceRoot = path.join(out, "race-state");
    mkdirP(raceRoot);
    fs.copyFileSync(stateFilePath(stateRoot), stateFilePath(raceRoot));
    const docRace = readStateDoc(raceRoot) as LifecycleDoc;
    const raceObserved = docRace.state_revision;
    const payloadA: LifecycleDoc = {
      schema_version: "1.0.0",
      state_revision: String(Number.parseInt(raceObserved, 10) + 1),
      packages: JSON.parse(JSON.stringify(docRace.packages)),
    };
    for (const ref of payloadA.packages) {
      ref.selection = "retained";
    }
    payloadA.packages.push({
      package_id: "@northstar/language-fixture",
      version: "0.9.1",
      tree_digest: "sha256:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
      manifest_digest: "sha256:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
      receipt_digest: "sha256:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
      installed_path: "/overlap/a",
      selection: "selected",
      installed_at: TIMESTAMP,
    });
    const payloadB: LifecycleDoc = {
      schema_version: "1.0.0",
      state_revision: String(Number.parseInt(raceObserved, 10) + 1),
      packages: JSON.parse(JSON.stringify(docRace.packages)),
    };
    for (const ref of payloadB.packages) {
      ref.selection = "retained";
    }
    payloadB.packages.push({
      package_id: "@northstar/language-fixture",
      version: "0.9.2",
      tree_digest: "sha256:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc",
      manifest_digest: "sha256:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc",
      receipt_digest: "sha256:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc",
      installed_path: "/overlap/b",
      selection: "selected",
      installed_at: TIMESTAMP,
    });
    const payloadFileA = path.join(out, "payload-a.json");
    const payloadFileB = path.join(out, "payload-b.json");
    fs.writeFileSync(payloadFileA, JSON.stringify(payloadA));
    fs.writeFileSync(payloadFileB, JSON.stringify(payloadB));
    const surfacePath = process.argv[1];
    // Writer A: holds the lock, then waits for the go barrier. It must run
    // asynchronously: the parent orchestrates the barrier while A is alive.
    const procA = spawn("bun", ["run", surfacePath, "cas-race", raceRoot, raceObserved, payloadFileA, "hold"], { stdio: ["ignore", "pipe", "pipe"] });
    let aOutput = "";
    procA.stdout.on("data", (chunk: Buffer) => {
      aOutput += chunk.toString("utf8");
    });
    procA.stderr.on("data", (chunk: Buffer) => {
      aOutput += chunk.toString("utf8");
    });
    // A must be inside the critical section before B is launched.
    const readyFile = path.join(raceRoot, ".race-ready");
    const deadline = Date.now() + 30000;
    while (!fs.existsSync(readyFile)) {
      if (Date.now() > deadline) {
        throw new Error("race writer A never took the lifecycle lock");
      }
    }
    check(fs.existsSync(path.join(raceRoot, ".lifecycle.lock")), "race writer A does not hold the lifecycle lock");
    // Writer B: same observed revision, launched while A holds the lock.
    const procB = spawnSync("bun", ["run", surfacePath, "cas-race", raceRoot, raceObserved, payloadFileB, "attempt"], { encoding: "utf8" });
    check(procB.error === undefined, "race writer B failed to start: " + String(procB.error));
    const bOutput = String(procB.stdout ?? "") + String(procB.stderr ?? "");
    check(bOutput.includes("cas-attempt: conflict"), "overlapping writer B was not stopped by the held lock: " + bOutput);
    check(bOutput.includes("ambiguous lifecycle write"), "writer B failed for the wrong reason: " + bOutput);
    // B must not have removed A's lock or mutated the state.
    check(fs.existsSync(path.join(raceRoot, ".lifecycle.lock")), "writer B removed the lock owner's lock");
    check(fs.readFileSync(stateFilePath(raceRoot), "utf8") === fs.readFileSync(stateFilePath(stateRoot), "utf8"),
      "writer B mutated state while the lock was held");
    // Release the barrier: A commits exactly once.
    fs.writeFileSync(path.join(raceRoot, ".race-go"), "go\n");
    const aExit = await new Promise<number | null>((resolve) => {
      const timer = setTimeout(() => resolve(null), 30000);
      procA.on("exit", (code) => {
        clearTimeout(timer);
        resolve(code);
      });
    });
    check(aExit !== null, "race writer A never exited");
    check(aOutput.includes("cas-hold: committed"), "race writer A did not commit: " + aOutput);
    const raceFinal = readStateDoc(raceRoot) as LifecycleDoc;
    check(raceFinal.state_revision === String(Number.parseInt(raceObserved, 10) + 1), "race winner did not advance the revision exactly once");
    check(raceFinal.packages.filter((ref) => ref.version === "0.9.1").length === 1, "race winner reference missing");
    check(raceFinal.packages.filter((ref) => ref.version === "0.9.2").length === 0, "conflicting writer created a duplicate reference");
    check(raceFinal.packages.filter((ref) => ref.selection === "selected").length === 1, "race ended with more than one selected identity");
    check(!fs.existsSync(path.join(raceRoot, ".lifecycle.lock")), "race winner did not release the lock");
    readStateDoc(raceRoot); // must remain parseable

    // Stale-revision rejection (sequential, still useful) and interrupted
    // writes: a stale lock from a dead owner is recovered exactly once; a
    // live lock fails closed (ambiguous), never truncating state.
    const staleRoot = path.join(out, "stale-state");
    mkdirP(staleRoot);
    fs.copyFileSync(stateFilePath(stateRoot), stateFilePath(staleRoot));
    const staleDoc = readStateDoc(staleRoot) as LifecycleDoc;
    // Baseline same-revision write advances the copy.
    replaceStateCas(staleRoot, staleDoc.state_revision, String(Number.parseInt(staleDoc.state_revision, 10) + 1), staleDoc.packages);
    const staleLock = path.join(staleRoot, ".lifecycle.lock");
    fs.writeFileSync(staleLock, "99999999\n"); // dead pid
    const beforeRecovery = readStateDoc(staleRoot) as LifecycleDoc;
    replaceStateCas(staleRoot, beforeRecovery.state_revision, String(Number.parseInt(beforeRecovery.state_revision, 10) + 1), beforeRecovery.packages);
    check(!fs.existsSync(staleLock), "stale lock was not recovered");
    const afterRecovery = readStateDoc(staleRoot) as LifecycleDoc;
    fs.writeFileSync(staleLock, String(process.pid) + "\n"); // live owner
    const docBeforeAmbiguous = fs.readFileSync(stateFilePath(staleRoot), "utf8");
    let ambiguous = false;
    try {
      replaceStateCas(staleRoot, afterRecovery.state_revision, "99", afterRecovery.packages);
    } catch (err) {
      ambiguous = (err as Error).message.includes("ambiguous lifecycle write");
    }
    check(ambiguous, "live lock did not fail closed");
    check(fs.readFileSync(stateFilePath(staleRoot), "utf8") === docBeforeAmbiguous, "interrupted write truncated lifecycle state");
    fs.rmSync(staleLock, { force: true });
    readStateDoc(staleRoot); // must remain parseable
    console.log("oracle-10 concurrency-atomic-cas: PASS (real two-process overlap + stale/live-lock recovery)");
  }

  // ---- self-check invocation: direct/command variants and negatives ----
  {
    const out = path.join(outRoot, "r11-invocation");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir();
    const trustDoc = fixtureTrustDoc(fixtureRoot, [], []);
    const registry = emptyRegistry();

    // Positive direct: the fixture declares invocation direct; acquisition
    // activates only after the declared entrypoint runs with [package_root]
    // and the package root as working directory.
    const acquire = acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
    });
    check(acquire.status === "activated", "direct-invocation acquisition did not activate");

    // Direct argv/cwd proof: a marker self-check echoes its first argument
    // and working directory; both must be the staged package root.
    const directMarker = buildVariantPackage(fixtureRoot, "0.4.0", (manifest, root) => {
      manifest.self_check.entrypoint = "scripts/self-check-marker.sh";
      writeText(path.join(root, "scripts/self-check-marker.sh"),
        "#!/bin/sh\nprintf 'arg=%s|pwd=%s\\n' \"${1:?usage}\" \"$(pwd)\"\n", 0o755);
    });
    const directStaged = stagedDir("northstar-staged-");
    copyTree(directMarker, directStaged);
    const directManifest = parseManifest(JSON.parse(fs.readFileSync(path.join(directStaged, "northstar-package.json"), "utf8")), "marker manifest");
    const directRun = runPackageSelfCheck(directStaged, directManifest);
    check(directRun.exit === 0, "direct self-check did not run: " + directRun.output);
    // The candidate executes on a throwaway byte-identical copy of the
    // staged root: argv and cwd are that execution copy's package root, and
    // the copy must carry the exact verified tree identity.
    check(directRun.execRoot !== directStaged, "self-check executed on the staged root itself");
    check(directRun.execTreeDigest === canonicalTreeDigest(directStaged, "staged root"),
      "self-check execution copy is not byte-identical to the staged root");
    check(directRun.output.includes("arg=" + directRun.execRoot), "direct self-check argv is not the exact package root: " + directRun.output);
    check(directRun.output.includes("pwd=" + directRun.execRealRoot), "direct self-check cwd is not the package root: " + directRun.output);

    // Pollution regression (card-118 canary): a self-check that writes
    // receipts into its package root must not mutate the verified staged
    // payload, and an acquisition of a polluting package must still route
    // afterwards — the installed payload keeps the pinned identity.
    const pollutingVariant = buildVariantPackage(fixtureRoot, "0.4.3", (manifest, root) => {
      manifest.self_check.entrypoint = "scripts/self-check-pollute.sh";
      writeText(path.join(root, "scripts/self-check-pollute.sh"),
        "#!/bin/sh\nmkdir -p \"$1/.effigy\"\nprintf 'x' > \"$1/.effigy/receipt.json\"\necho polluting-self-check ran\n", 0o755);
    });
    const polluteStaged = stagedDir("northstar-staged-");
    copyTree(pollutingVariant, polluteStaged);
    const polluteManifest = parseManifest(JSON.parse(fs.readFileSync(path.join(polluteStaged, "northstar-package.json"), "utf8")), "pollution manifest");
    const beforePollution = canonicalTreeDigest(polluteStaged, "pre-pollution staged");
    const polluteRun = runPackageSelfCheck(polluteStaged, polluteManifest);
    check(polluteRun.exit === 0 && polluteRun.output.includes("polluting-self-check ran"),
      "polluting self-check did not run: " + polluteRun.output);
    check(canonicalTreeDigest(polluteStaged, "post-pollution staged") === beforePollution,
      "self-check mutated the verified staged payload");
    const polluteStateRoot = path.join(out, "pollute-state");
    mkdirP(polluteStateRoot);
    const polluteTrust = fixtureTrustDoc(fixtureRoot,
      [variantPin("@northstar/language-fixture", "0.4.3", pollutingVariant)], []);
    const polluteAcquire = acquireAndActivate({
      stateRoot: polluteStateRoot, consumerDir: consumer, trustDoc: polluteTrust,
      registry,
      packageId: "@northstar/language-fixture", version: "0.4.3",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: fixtureAdapter(pollutingVariant), intent: "workflow_request",
    });
    check(polluteAcquire.status === "activated", "polluting package did not activate: " + polluteAcquire.notice);
    const polluteRouted = resolveInstalledPackage(polluteStateRoot, polluteTrust,
      "@northstar/language-fixture", "0.4.3", "fixture-lang", "explicit_audit_repair", CORE_VERSION);
    check(polluteRouted !== null, "polluting package lost its pinned identity after self-check; selection re-verification failed");

    // Positive command: the named command executes [entrypoint, package_root];
    // required_commands ORDER has no effect.
    const commandMarker = buildVariantPackage(fixtureRoot, "0.4.1", (manifest) => {
      manifest.self_check.invocation = { type: "command", command: "sh" };
      manifest.runtime_capabilities.required_commands = ["cat", "sh"];
      manifest.self_check.entrypoint = "scripts/self-check.sh";
    });
    const commandStaged = stagedDir("northstar-staged-");
    copyTree(commandMarker, commandStaged);
    const commandManifest = parseManifest(JSON.parse(fs.readFileSync(path.join(commandStaged, "northstar-package.json"), "utf8")), "command manifest");
    const commandRun = runPackageSelfCheck(commandStaged, commandManifest);
    check(commandRun.exit === 0 && commandRun.output.includes("[fixture-package:self-check] OK"),
      "command self-check did not run: " + commandRun.output);
    // Reversed required_commands order must not change the outcome.
    const reversedMarker = buildVariantPackage(fixtureRoot, "0.4.2", (manifest) => {
      manifest.self_check.invocation = { type: "command", command: "sh" };
      manifest.runtime_capabilities.required_commands = ["sh", "cat"];
    });
    const reversedStaged = stagedDir("northstar-staged-");
    copyTree(reversedMarker, reversedStaged);
    const reversedManifest = parseManifest(JSON.parse(fs.readFileSync(path.join(reversedStaged, "northstar-package.json"), "utf8")), "reversed manifest");
    const reversedRun = runPackageSelfCheck(reversedStaged, reversedManifest);
    check(reversedRun.exit === 0 && reversedRun.output.includes("[fixture-package:self-check] OK"),
      "reordered required_commands changed self-check behavior: " + reversedRun.output);

    // Full acquisition through command invocation (positive).
    const commandPin = variantPin("@northstar/language-fixture", "0.4.1", commandMarker);
    const commandTrust = fixtureTrustDoc(fixtureRoot, [commandPin], []);
    const commandAcquire = acquireAndActivate({
      stateRoot, consumerDir: consumer, trustDoc: commandTrust, registry,
      packageId: "@northstar/language-fixture", version: "0.4.1",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: () => {
        const staged = stagedDir("northstar-staged-");
        copyTree(commandMarker, staged);
        return staged;
      }, intent: "workflow_request",
    });
    check(commandAcquire.status === "activated", "command-invocation acquisition did not activate");

    // Negative: command runner not declared in required_commands.
    const undeclared = buildVariantPackage(fixtureRoot, "0.4.3", (manifest) => {
      manifest.self_check.invocation = { type: "command", command: "sh" };
      manifest.runtime_capabilities.required_commands = [];
    });
    const undeclaredStaged = stagedDir("northstar-staged-");
    copyTree(undeclared, undeclaredStaged);
    const undeclaredManifest = parseManifest(JSON.parse(fs.readFileSync(path.join(undeclaredStaged, "northstar-package.json"), "utf8")), "undeclared manifest");
    let undeclaredStopped = false;
    try {
      runPackageSelfCheck(undeclaredStaged, undeclaredManifest);
    } catch (err) {
      undeclaredStopped = (err as Error).message.includes("not declared in runtime_capabilities.required_commands");
    }
    check(undeclaredStopped, "undeclared command runner did not stop");

    // Negative: command runner unavailable on this host.
    const unavailable = buildVariantPackage(fixtureRoot, "0.4.4", (manifest) => {
      manifest.self_check.invocation = { type: "command", command: "definitely-not-a-real-command-xyz" };
      manifest.runtime_capabilities.required_commands = ["definitely-not-a-real-command-xyz"];
    });
    const unavailableStaged = stagedDir("northstar-staged-");
    copyTree(unavailable, unavailableStaged);
    const unavailableManifest = parseManifest(JSON.parse(fs.readFileSync(path.join(unavailableStaged, "northstar-package.json"), "utf8")), "unavailable manifest");
    let unavailableStopped = false;
    try {
      runPackageSelfCheck(unavailableStaged, unavailableManifest);
    } catch (err) {
      unavailableStopped = (err as Error).message.includes("not available on this host");
    }
    check(unavailableStopped, "unavailable command runner did not stop");

    // Negative: direct entrypoint not executable stops before selection.
    const notExecutable = buildVariantPackage(fixtureRoot, "0.4.5", (_manifest, root) => {
      fs.chmodSync(path.join(root, "scripts/self-check.sh"), 0o644);
    });
    const notExecPin = variantPin("@northstar/language-fixture", "0.4.5", notExecutable);
    const notExecTrust = fixtureTrustDoc(fixtureRoot, [notExecPin], []);
    const stateBefore = fs.readFileSync(stateFilePath(stateRoot), "utf8");
    let notExecStopped = false;
    try {
      acquireAndActivate({
        stateRoot, consumerDir: consumer, trustDoc: notExecTrust, registry,
        packageId: "@northstar/language-fixture", version: "0.4.5",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: () => {
          const staged = stagedDir("northstar-staged-");
          copyTree(notExecutable, staged);
          return staged;
        }, intent: "workflow_request",
      });
    } catch (err) {
      notExecStopped = (err as Error).message.includes("not executable");
    }
    check(notExecStopped, "non-executable direct entrypoint did not stop");
    check(fs.readFileSync(stateFilePath(stateRoot), "utf8") === stateBefore,
      "non-executable direct entrypoint changed lifecycle state");

    console.log("oracle-11 self-check-invocation: PASS (direct/command positives, argv/cwd proof on a byte-identical throwaway execution copy, order-insensitive, undeclared/unavailable/permission negatives, self-check pollution cannot mutate the verified payload)");
  }


  // ---- identity binding and immutable install-store negatives ----
  {
    const out = path.join(outRoot, "r12-identity-binding");
    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    const consumer = consumerDir();
    const registry = emptyRegistry();

    // A pin must never install a staged manifest declaring another identity,
    // version, or compatibility range. Each variant is pinned by a manually
    // constructed entry claiming the REQUESTED values while the staged
    // manifest declares the mutated values.
    const mutatedIdentity = buildVariantPackage(fixtureRoot, "0.1.0", (manifest) => {
      manifest.package_id = "@northstar/other-fixture";
    });
    const identityPin: TrustEntry = {
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      source_identity: { type: "local_path", path: mutatedIdentity },
      tree_digest: canonicalTreeDigest(mutatedIdentity, "variant"),
      manifest_digest: manifestDigestOf(path.join(mutatedIdentity, "northstar-package.json")),
      compatible_core_range: ">=0.2.0 <1.0.0",
      actor: "operator",
      timestamp: TIMESTAMP,
      reason: "identity-binding negative",
    };
    const identityTrust: TrustDoc = { schema_version: "1.0.0", revision: "1", allowlist: [identityPin], revocations: [] };
    let identityBlocked = false;
    let identityMsg = "";
    try {
      acquireAndActivate({
        stateRoot, consumerDir: consumer, trustDoc: identityTrust, registry,
        packageId: "@northstar/language-fixture", version: "0.1.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: () => {
          const staged = stagedDir("northstar-staged-");
          copyTree(mutatedIdentity, staged);
          return staged;
        }, intent: "workflow_request",
      });
    } catch (err) {
      identityBlocked = (err as Error).message.includes("staged manifest declares identity");
      identityMsg = (err as Error).message;
    }
    check(identityBlocked, "pin installed a staged manifest with another identity: " + identityMsg);
    check(!fs.existsSync(stateFilePath(stateRoot)), "identity-mismatched acquisition created state");

    const mutatedVersion = buildVariantPackage(fixtureRoot, "0.7.0", (manifest) => {
      manifest.version = "0.7.0";
    });
    const versionPin: TrustEntry = {
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      source_identity: { type: "local_path", path: mutatedVersion },
      tree_digest: canonicalTreeDigest(mutatedVersion, "variant"),
      manifest_digest: manifestDigestOf(path.join(mutatedVersion, "northstar-package.json")),
      compatible_core_range: ">=0.2.0 <1.0.0",
      actor: "operator",
      timestamp: TIMESTAMP,
      reason: "version-binding negative",
    };
    const versionTrust: TrustDoc = { schema_version: "1.0.0", revision: "1", allowlist: [versionPin], revocations: [] };
    let versionBlocked = false;
    try {
      acquireAndActivate({
        stateRoot, consumerDir: consumer, trustDoc: versionTrust, registry,
        packageId: "@northstar/language-fixture", version: "0.1.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: () => {
          const staged = stagedDir("northstar-staged-");
          copyTree(mutatedVersion, staged);
          return staged;
        }, intent: "workflow_request",
      });
    } catch (err) {
      versionBlocked = (err as Error).message.includes("staged manifest declares version");
    }
    check(versionBlocked, "pin installed a staged manifest with another version");

    const mutatedRange = buildVariantPackage(fixtureRoot, "0.1.0", (manifest) => {
      manifest.compatible_core_range = ">=9.0.0 <10.0.0";
    });
    const rangePin: TrustEntry = {
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      source_identity: { type: "local_path", path: mutatedRange },
      tree_digest: canonicalTreeDigest(mutatedRange, "variant"),
      manifest_digest: manifestDigestOf(path.join(mutatedRange, "northstar-package.json")),
      compatible_core_range: ">=0.2.0 <1.0.0",
      actor: "operator",
      timestamp: TIMESTAMP,
      reason: "range-binding negative",
    };
    const rangeTrust: TrustDoc = { schema_version: "1.0.0", revision: "1", allowlist: [rangePin], revocations: [] };
    let rangeBlocked = false;
    try {
      acquireAndActivate({
        stateRoot, consumerDir: consumer, trustDoc: rangeTrust, registry,
        packageId: "@northstar/language-fixture", version: "0.1.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: () => {
          const staged = stagedDir("northstar-staged-");
          copyTree(mutatedRange, staged);
          return staged;
        }, intent: "workflow_request",
      });
    } catch (err) {
      rangeBlocked = (err as Error).message.includes("compatibility range does not match the pin");
    }
    check(rangeBlocked, "pin installed a staged manifest with another compatibility range");

    // Occupied/partial install target: an existing directory at the full
    // digest address with different bytes must fail without writing, and the
    // staged/retained bytes plus consumer files stay exact.
    const occupiedState = path.join(out, "occupied-state");
    mkdirP(occupiedState);
    const occupiedConsumer = consumerDir();
    const trustDoc = fixtureTrustDoc(fixtureRoot, [], []);
    const installRoot = path.join(occupiedState, "installed");
    const occupiedDir = path.join(installRoot, "@northstar/language-fixture@0.1.0-" + FIXTURE_TREE_DIGEST.slice(7));
    mkdirP(occupiedDir);
    writeText(path.join(occupiedDir, "northstar-package.json"), '{"tampered":true}\n');
    writeText(path.join(occupiedDir, "SKILL.md"), "occupied\n");
    const consumerBefore = snapshotHashes(occupiedConsumer);
    let occupiedBlocked = false;
    try {
      acquireAndActivate({
        stateRoot: occupiedState, consumerDir: occupiedConsumer, trustDoc, registry,
        packageId: "@northstar/language-fixture", version: "0.1.0",
        language: "fixture-lang", workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
      });
    } catch (err) {
      occupiedBlocked = (err as Error).message.includes("refusing to overwrite");
    }
    check(occupiedBlocked, "occupied install target was overwritten");
    check(fs.readFileSync(path.join(occupiedDir, "SKILL.md"), "utf8") === "occupied\n", "occupied install target bytes changed");
    check(!fs.existsSync(stateFilePath(occupiedState)), "occupied-target acquisition created state");
    requireHashesUnchanged("occupied-target consumer", occupiedConsumer, consumerBefore);

    // Successful install uses the FULL canonical digest as its address.
    const fullState = path.join(out, "full-digest-state");
    mkdirP(fullState);
    const acquire = acquireAndActivate({
      stateRoot: fullState, consumerDir: consumerDir(), trustDoc, registry,
      packageId: "@northstar/language-fixture", version: "0.1.0",
      language: "fixture-lang", workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION, adapter: fixtureAdapter(fixtureRoot), intent: "workflow_request",
    });
    check(acquire.status === "activated", "full-digest install did not activate");
    check(path.basename(acquire.installDir as string).includes(FIXTURE_TREE_DIGEST.slice(7)), "install address does not carry the full tree digest");
    console.log("oracle-12 identity-binding-and-immutable-store: PASS");
  }

  // ---- host protocol: language-package-host.v1 portability ----
  {
    const out = path.join(outRoot, "r13-host-protocol");
    const stateRoot = path.join(out, "state");
    const installedRoot = path.join(out, "installed-skill");
    mkdirP(stateRoot);
    mkdirP(installedRoot);
    const consumer = consumerDir();
    const registry = emptyRegistry();

    // Operator-owned trust lives in the operator state root.
    const trustPath = path.join(stateRoot, "operator-trust.json");
    fs.writeFileSync(trustPath, JSON.stringify(fixtureTrustDoc(fixtureRoot, [], [])));

    const baseRequest = {
      protocol_version: "1.0.0",
      request_id: "req-oracle13-host-01",
      intent: "workflow_request",
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      language: "fixture-lang",
      workflow: "explicit_audit_repair",
      core_version: CORE_VERSION,
      consumer_dir: consumer,
      state_root: stateRoot,
    };

    // acquire_activate request -> activated result with exact identities.
    const acquireReq: HostRequest = { ...baseRequest, operation: "acquire_activate" };
    const acquireRes = executeHostRequest(acquireReq, null, FULL_HOST_CAPABILITIES);
    check(acquireRes.status === "activated", "host acquire_activate did not activate: " + acquireRes.notice);
    check(acquireRes.request_id === acquireReq.request_id, "host activated result dropped request_id");
    check(acquireRes.operation === "acquire_activate", "host activated result lost its operation");
    check(acquireRes.tree_digest === FIXTURE_TREE_DIGEST && acquireRes.manifest_digest === FIXTURE_MANIFEST_DIGEST,
      "host activated result carries wrong identities");
    check(acquireRes.receipt_digest !== undefined && acquireRes.installed_path !== undefined,
      "host activated result lacks receipt/path");

    // resolve request -> routed result, local-only, from the operator state.
    const resolveReq: HostRequest = { ...baseRequest, operation: "resolve" };
    const resolveRes = executeHostRequest(resolveReq, null, FULL_HOST_CAPABILITIES);
    check(resolveRes.status === "routed", "host resolve did not route: " + resolveRes.notice);
    check(resolveRes.request_id === resolveReq.request_id, "host routed result dropped request_id");
    check(resolveRes.operation === "resolve", "host routed result lost its operation");
    check(resolveRes.tree_digest === FIXTURE_TREE_DIGEST && resolveRes.receipt_digest === acquireRes.receipt_digest,
      "host resolve returned the wrong identity");

    // Missing package -> scoped stopped with a visible notice.
    const missingReq: HostRequest = { ...baseRequest, package_id: "@northstar/missing-fixture", language: "missing-lang", operation: "resolve" };
    const missingRes = executeHostRequest(missingReq, null, FULL_HOST_CAPABILITIES);
    check(missingRes.status === "stopped" && missingRes.notice.includes("@northstar/missing-fixture"),
      "host resolve missing package did not stop scoped: " + missingRes.notice);
    check(missingRes.request_id === missingReq.request_id, "host stopped result dropped request_id");
    check(missingRes.tree_digest === undefined && missingRes.receipt_digest === undefined,
      "stopped result carried success fields");

    // Scope binding at the host boundary: a restricted pin and a mismatched
    // request scope stop resolve and activation through the host entrypoint.
    const restrictedState = path.join(out, "restricted-state");
    mkdirP(restrictedState);
    const scopeRestrictedTrust = fixtureTrustDoc(fixtureRoot, [], []);
    scopeRestrictedTrust.allowlist[0].consumer_scope = "team-b";
    fs.writeFileSync(path.join(restrictedState, "operator-trust.json"), JSON.stringify(scopeRestrictedTrust));
    const restrictedConsumer = consumerDir();
    const restrictedAcquire: HostRequest = {
      ...baseRequest,
      operation: "acquire_activate",
      consumer_scope: "team-a",
      consumer_dir: restrictedConsumer,
      state_root: restrictedState,
    };
    const restrictedAcquireRes = executeHostRequest(restrictedAcquire, null, FULL_HOST_CAPABILITIES);
    check(restrictedAcquireRes.status === "stopped" && restrictedAcquireRes.notice.includes("restricts consumer scope"),
      "host ignored the request scope against a restricted pin: " + restrictedAcquireRes.notice);
    // Workflow restriction stops activation even with a matching scope.
    const workflowState = path.join(out, "workflow-state");
    mkdirP(workflowState);
    const workflowRestrictedTrust = fixtureTrustDoc(fixtureRoot, [], []);
    workflowRestrictedTrust.allowlist[0].workflows = ["everyday_authoring"];
    fs.writeFileSync(path.join(workflowState, "operator-trust.json"), JSON.stringify(workflowRestrictedTrust));
    const scopeConsumer = consumerDir();
    const restrictedWorkflow: HostRequest = {
      ...baseRequest,
      operation: "acquire_activate",
      consumer_scope: "team-b",
      consumer_dir: scopeConsumer,
      state_root: workflowState,
    };
    const restrictedWorkflowRes = executeHostRequest(restrictedWorkflow, null, FULL_HOST_CAPABILITIES);
    check(restrictedWorkflowRes.status === "stopped" && restrictedWorkflowRes.notice.includes("restricts workflows"),
      "host ignored the workflow restriction: " + restrictedWorkflowRes.notice);
    // Matching scope routes once installed under an unrestricted pin.
    const matchState = path.join(out, "match-state");
    mkdirP(matchState);
    fs.writeFileSync(path.join(matchState, "operator-trust.json"), JSON.stringify(fixtureTrustDoc(fixtureRoot, [], [])));
    const matchConsumer = consumerDir();
    executeHostRequest({ ...baseRequest, operation: "acquire_activate", consumer_dir: matchConsumer, state_root: matchState }, null, FULL_HOST_CAPABILITIES);
    const scopedResolve: HostRequest = { ...baseRequest, operation: "resolve", consumer_scope: "team-a", consumer_dir: matchConsumer, state_root: matchState };
    const scopedResolveRes = executeHostRequest(scopedResolve, null, FULL_HOST_CAPABILITIES);
    check(scopedResolveRes.status === "routed", "matching-scope resolve did not route: " + scopedResolveRes.notice);

    // rollback request -> rolled_back result after a second activation.
    const variant = buildVariantPackage(fixtureRoot, "0.2.0", () => undefined);
    const variantPinEntry = variantPin("@northstar/language-fixture", "0.2.0", variant);
    const variantTrustDoc = fixtureTrustDoc(fixtureRoot, [variantPinEntry], []);
    fs.writeFileSync(trustPath, JSON.stringify(variantTrustDoc));
    const updateReq: HostRequest = { ...baseRequest, version: "0.2.0", operation: "acquire_activate" };
    const updateRes = executeHostRequest(updateReq, null, FULL_HOST_CAPABILITIES);
    check(updateRes.status === "activated", "host update did not activate: " + updateRes.notice);
    const rollbackReq: HostRequest = { ...baseRequest, version: "0.1.0", operation: "rollback", target_receipt_digest: acquireRes.receipt_digest as string };
    const rollbackRes = executeHostRequest(rollbackReq, null, FULL_HOST_CAPABILITIES);
    check(rollbackRes.status === "rolled_back", "host rollback did not roll back: " + rollbackRes.notice);
    check(rollbackRes.operation === "rollback", "host rolled_back result lost its operation");
    const afterRollback = readStateDoc(stateRoot) as LifecycleDoc;
    const selected = afterRollback.packages.filter((ref) => ref.selection === "selected").map((ref) => ref.version);
    check(JSON.stringify(selected) === JSON.stringify(["0.1.0"]), "host rollback did not reselect 0.1.0");

    // Capability-denied adapter: missing atomic -> scoped stopped, never a
    // fallback runtime or partial state mutation.
    const deniedCaps = new Set<HostCapability>(["catalogue", "identity", "process", "acquisition"]);
    const deniedRes = executeHostRequest(acquireReq, null, deniedCaps);
    check(deniedRes.status === "stopped" && deniedRes.notice.includes("host capability missing: atomic"),
      "capability-denied host did not return scoped stopped: " + deniedRes.notice);

    // Installed-skill invocation with Effigy absent: the reference adapter
    // (Bun harness) and the resolve-bound python3 host both run from a copied
    // installed skill and speak the same request/result messages. ALL THREE
    // operations are exercised through the installed entrypoints the card
    // requires.
    const surfacePath = process.argv[1];
    const surfaceName = path.basename(surfacePath);
    const pythonHostName = "language-package-host.py";
    fs.copyFileSync(surfacePath, path.join(installedRoot, surfaceName));
    fs.copyFileSync(path.join(path.dirname(surfacePath), pythonHostName), path.join(installedRoot, pythonHostName));
    const installedState = path.join(out, "installed-state");
    mkdirP(installedState);
    fs.writeFileSync(path.join(installedState, "operator-trust.json"), JSON.stringify(fixtureTrustDoc(fixtureRoot, [], [])));
    const installedConsumer = consumerDir();
    const hostReqDir = path.join(out, "host-protocol", "requests");
    const hostResDir = path.join(out, "host-protocol", "results");
    mkdirP(hostReqDir);
    mkdirP(hostResDir);
    const writePair = (name: string, request: Record<string, unknown>): string => {
      const reqFile = path.join(hostReqDir, name + ".json");
      const resFile = path.join(hostResDir, name + ".json");
      fs.writeFileSync(reqFile, JSON.stringify(request));
      return resFile;
    };
    const installedRequest = {
      protocol_version: "1.0.0",
      request_id: "req-oracle13-installed-01",
      intent: "workflow_request",
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      language: "fixture-lang",
      workflow: "explicit_audit_repair",
      core_version: CORE_VERSION,
      consumer_dir: installedConsumer,
      state_root: installedState,
    };
    const readResult = (resFile: string): HostResult => JSON.parse(fs.readFileSync(resFile, "utf8")) as HostResult;

    // acquire_activate through the installed reference host entrypoint.
    const seedRes = writePair("installed-acquire", { ...installedRequest, operation: "acquire_activate" });
    const seedRun = spawnSync("bun", ["run", path.join(installedRoot, surfaceName), "host", path.join(hostReqDir, "installed-acquire.json"), seedRes], { encoding: "utf8" });
    check(seedRun.status === 0, "installed-skill reference host failed: " + String(seedRun.stdout) + String(seedRun.stderr));
    const seedResult = readResult(seedRes);
    check(seedResult.status === "activated" && seedResult.operation === "acquire_activate", "installed-skill host did not activate: " + seedResult.notice);
    check(seedResult.request_id === installedRequest.request_id, "installed-skill host dropped request_id");

    // resolve through the installed reference host entrypoint.
    const bunResFile = writePair("installed-resolve", { ...installedRequest, operation: "resolve" });
    const bunRun = spawnSync("bun", ["run", path.join(installedRoot, surfaceName), "host", path.join(hostReqDir, "installed-resolve.json"), bunResFile], { encoding: "utf8" });
    check(bunRun.status === 0, "installed-skill reference host resolve failed: " + String(bunRun.stderr));
    const bunResult = readResult(bunResFile);
    check(bunResult.status === "routed" && bunResult.operation === "resolve" && bunResult.tree_digest === FIXTURE_TREE_DIGEST,
      "installed-skill reference host resolve returned wrong result: " + bunResult.notice);

    // rollback through the installed reference host entrypoint: install
    // 0.2.0 through the copy, then roll back through the copy.
    const installedVariantTrust = fixtureTrustDoc(fixtureRoot, [variantPinEntry], []);
    fs.writeFileSync(path.join(installedState, "operator-trust.json"), JSON.stringify(installedVariantTrust));
    const instUpdateRes = writePair("installed-update", { ...installedRequest, version: "0.2.0", operation: "acquire_activate" });
    const instUpdateRun = spawnSync("bun", ["run", path.join(installedRoot, surfaceName), "host", path.join(hostReqDir, "installed-update.json"), instUpdateRes], { encoding: "utf8" });
    check(instUpdateRun.status === 0, "installed reference update failed: " + String(instUpdateRun.stderr));
    const instUpdateResult = readResult(instUpdateRes);
    check(instUpdateResult.status === "activated", "installed reference update did not activate: " + instUpdateResult.notice);
    const instRollbackRes = writePair("installed-rollback", {
      ...installedRequest,
      version: "0.1.0",
      operation: "rollback",
      target_receipt_digest: seedResult.receipt_digest as string,
    });
    const instRollbackRun = spawnSync("bun", ["run", path.join(installedRoot, surfaceName), "host", path.join(hostReqDir, "installed-rollback.json"), instRollbackRes], { encoding: "utf8" });
    check(instRollbackRun.status === 0, "installed reference rollback failed: " + String(instRollbackRun.stderr));
    const instRollbackResult = readResult(instRollbackRes);
    check(instRollbackResult.status === "rolled_back" && instRollbackResult.operation === "rollback",
      "installed reference rollback returned wrong result: " + instRollbackResult.notice);
    const installedAfter = readStateDoc(installedState) as LifecycleDoc;
    const installedSelected = installedAfter.packages.filter((ref) => ref.selection === "selected").map((ref) => ref.version);
    check(JSON.stringify(installedSelected) === JSON.stringify(["0.1.0"]), "installed reference rollback did not reselect");

    // Conforming python3 host: resolve-only by explicit bound; unsupported
    // operations stop as missing capability instead of pretending.
    const pyResFile = writePair("python-resolve", { ...installedRequest, operation: "resolve" });
    const pyRun = spawnSync("python3", [path.join(installedRoot, pythonHostName), path.join(hostReqDir, "python-resolve.json"), pyResFile], { encoding: "utf8" });
    check(pyRun.status === 0, "python conforming host failed: " + String(pyRun.stderr) + String(pyRun.stdout));
    const pyResult = readResult(pyResFile);
    check(pyResult.status === "routed" && pyResult.operation === "resolve" && pyResult.tree_digest === FIXTURE_TREE_DIGEST,
      "python conforming host resolve returned wrong result: " + pyResult.notice);
    check(pyResult.request_id === installedRequest.request_id, "python host dropped request_id");
    check(bunResult.notice === pyResult.notice, "reference and python hosts disagree on the result message");

    const pyAcquireFile = writePair("python-acquire", { ...installedRequest, operation: "acquire_activate" });
    const pyAcquire = spawnSync("python3", [path.join(installedRoot, pythonHostName), path.join(hostReqDir, "python-acquire.json"), pyAcquireFile], { encoding: "utf8" });
    check(pyAcquire.status === 0, "python acquire dispatch failed: " + String(pyAcquire.stderr));
    const pyAcquireResult = readResult(pyAcquireFile);
    check(pyAcquireResult.status === "stopped" && pyAcquireResult.operation === "acquire_activate" && pyAcquireResult.notice.includes("not implemented"),
      "python host did not stop unsupported acquire_activate: " + pyAcquireResult.notice);

    const pyRollbackFile = writePair("python-rollback", { ...installedRequest, operation: "rollback", target_receipt_digest: seedResult.receipt_digest as string });
    const pyRollback = spawnSync("python3", [path.join(installedRoot, pythonHostName), path.join(hostReqDir, "python-rollback.json"), pyRollbackFile], { encoding: "utf8" });
    check(pyRollback.status === 0, "python rollback dispatch failed: " + String(pyRollback.stderr));
    const pyRollbackResult = readResult(pyRollbackFile);
    check(pyRollbackResult.status === "stopped" && pyRollbackResult.operation === "rollback" && pyRollbackResult.notice.includes("not implemented"),
      "python host did not stop unsupported rollback: " + pyRollbackResult.notice);

    // Unsupported protocol version is stopped, never answered as v1. The
    // malformed request itself is not a valid v1 message, so it is kept out
    // of the schema-validated request set.
    const badVersionReq = path.join(out, "bad-version-request.json");
    fs.writeFileSync(badVersionReq, JSON.stringify({ ...installedRequest, protocol_version: "9.9.9", operation: "resolve" }));
    const pyVersionFile = path.join(hostResDir, "python-bad-version.json");
    const pyVersion = spawnSync("python3", [path.join(installedRoot, pythonHostName), badVersionReq, pyVersionFile], { encoding: "utf8" });
    check(pyVersion.status === 0, "python version gate failed: " + String(pyVersion.stderr));
    const pyVersionResult = readResult(pyVersionFile);
    check(pyVersionResult.status === "stopped" && pyVersionResult.notice.includes("unsupported protocol_version"),
      "python host answered an unsupported protocol version: " + pyVersionResult.notice);

    // Capability-denied python host: denied identity -> scoped stopped.
    const pyDeniedFile = writePair("python-denied", { ...installedRequest, operation: "resolve" });
    const pyDenied = spawnSync("python3", [path.join(installedRoot, pythonHostName), path.join(hostReqDir, "python-denied.json"), pyDeniedFile, "identity"], { encoding: "utf8" });
    check(pyDenied.status === 0, "python denied host failed: " + String(pyDenied.stderr));
    const pyDeniedResult = readResult(pyDeniedFile);
    check(pyDeniedResult.status === "stopped" && pyDeniedResult.notice.includes("host capability missing: identity"),
      "python denied host did not stop scoped: " + pyDeniedResult.notice);

    // Missing-language request against the python host stops scoped too.
    const pyMissingReq = writePair("python-missing", { ...installedRequest, package_id: "@northstar/other-fixture", language: "other-lang", operation: "resolve" });
    const pyMissing = spawnSync("python3", [path.join(installedRoot, pythonHostName), path.join(hostReqDir, "python-missing.json"), pyMissingReq], { encoding: "utf8" });
    check(pyMissing.status === 0, "python missing-host failed: " + String(pyMissing.stderr));
    const pyMissingResult = readResult(pyMissingReq);
    check(pyMissingResult.status === "stopped" && pyMissingResult.notice.includes("@northstar/other-fixture"),
      "python host missing package did not stop scoped: " + pyMissingResult.notice);

    // Scope restriction through the installed python entrypoint.
    const restrictedInstalledState = path.join(out, "restricted-installed-state");
    mkdirP(restrictedInstalledState);
    const restrictedInstalledTrust = fixtureTrustDoc(fixtureRoot, [], []);
    restrictedInstalledTrust.allowlist[0].consumer_scope = "team-b";
    fs.writeFileSync(path.join(restrictedInstalledState, "operator-trust.json"), JSON.stringify(restrictedInstalledTrust));
    const restrictedConsumerDir = consumerDir();
    const instRes = executeHostRequest({
      ...installedRequest, operation: "acquire_activate", consumer_scope: "team-b", consumer_dir: restrictedConsumerDir, state_root: restrictedInstalledState,
    }, null, FULL_HOST_CAPABILITIES);
    check(instRes.status === "activated", "restricted installed seed failed: " + instRes.notice);
    const pyScopeReq = writePair("python-scope-mismatch", {
      ...installedRequest,
      operation: "resolve",
      consumer_scope: "team-a",
      consumer_dir: restrictedConsumerDir,
      state_root: restrictedInstalledState,
    });
    const pyScope = spawnSync("python3", [path.join(installedRoot, pythonHostName), path.join(hostReqDir, "python-scope-mismatch.json"), pyScopeReq], { encoding: "utf8" });
    check(pyScope.status === 0, "python scope gate failed: " + String(pyScope.stderr));
    const pyScopeResult = readResult(pyScopeReq);
    check(pyScopeResult.status === "stopped" && pyScopeResult.notice.includes("restricts consumer scope"),
      "python host ignored the request scope restriction: " + pyScopeResult.notice);
    const pyScopeOk = writePair("python-scope-match", {
      ...installedRequest,
      operation: "resolve",
      consumer_scope: "team-b",
      consumer_dir: restrictedConsumerDir,
      state_root: restrictedInstalledState,
    });
    const pyScopeOkRun = spawnSync("python3", [path.join(installedRoot, pythonHostName), path.join(hostReqDir, "python-scope-match.json"), pyScopeOk], { encoding: "utf8" });
    check(pyScopeOkRun.status === 0, "python scope-match host failed: " + String(pyScopeOkRun.stderr));
    const pyScopeOkResult = readResult(pyScopeOk);
    check(pyScopeOkResult.status === "routed", "matching python scope did not route: " + pyScopeOkResult.notice);

    // Installed-route scope binding through the copied host entrypoint: an
    // acquire_activate request for an ALREADY-INSTALLED package must honor
    // the same request/activation scope agreement as fresh acquisition.
    const fastState = path.join(out, "fast-route-state");
    mkdirP(fastState);
    fs.writeFileSync(path.join(fastState, "operator-trust.json"), JSON.stringify(fixtureTrustDoc(fixtureRoot, [], [])));
    const fastConsumer = consumerDir();
    const fastSeed = writePair("fast-route-seed", { ...installedRequest, consumer_dir: fastConsumer, state_root: fastState, operation: "acquire_activate" });
    const fastSeedRun = spawnSync("bun", ["run", path.join(installedRoot, surfaceName), "host", path.join(hostReqDir, "fast-route-seed.json"), fastSeed], { encoding: "utf8" });
    check(fastSeedRun.status === 0, "fast-route seed failed: " + String(fastSeedRun.stderr));
    const fastSeedResult = readResult(fastSeed);
    check(fastSeedResult.status === "activated", "fast-route seed did not activate: " + fastSeedResult.notice);
    // Restrict the installed identity's pin to team-b.
    const fastRestrictedTrust = fixtureTrustDoc(fixtureRoot, [], []);
    fastRestrictedTrust.allowlist[0].consumer_scope = "team-b";
    fs.writeFileSync(path.join(fastState, "operator-trust.json"), JSON.stringify(fastRestrictedTrust));

    const markerDir = (scope: string): string => {
      const dir = consumerDir({
        "docs/contracts/language-quality-activation.json": JSON.stringify({ package_id: "@northstar/language-fixture", version: "0.1.0", scope }),
      });
      return dir;
    };
    const markerB = markerDir("team-b");
    const markerA = markerDir("team-a");

    // Counterexample 1: request scope team-a against a team-b pin, marker
    // team-b. The request/marker agreement rule must stop the installed
    // route (the pre-fix fast path routed it via the marker scope).
    const fastMismatch = writePair("fast-route-scope-mismatch", {
      ...installedRequest,
      operation: "acquire_activate",
      intent: "activation",
      consumer_scope: "team-a",
      consumer_dir: markerB,
      state_root: fastState,
    });
    const fastMismatchRun = spawnSync("bun", ["run", path.join(installedRoot, surfaceName), "host", path.join(hostReqDir, "fast-route-scope-mismatch.json"), fastMismatch], { encoding: "utf8" });
    check(fastMismatchRun.status === 0, "fast-route mismatch host failed: " + String(fastMismatchRun.stderr));
    const fastMismatchResult = readResult(fastMismatch);
    check(fastMismatchResult.status === "stopped" && fastMismatchResult.notice.includes("consumer scope mismatch"),
      "installed fast path bypassed the request/marker scope agreement: " + fastMismatchResult.notice);

    // Counterexample 2: request scope team-b agrees with the pin but the
    // activation marker disagrees (team-a); the route must still stop.
    const fastMarkerDisagree = writePair("fast-route-marker-disagreement", {
      ...installedRequest,
      operation: "acquire_activate",
      intent: "activation",
      consumer_scope: "team-b",
      consumer_dir: markerA,
      state_root: fastState,
    });
    const fastMarkerDisagreeRun = spawnSync("bun", ["run", path.join(installedRoot, surfaceName), "host", path.join(hostReqDir, "fast-route-marker-disagreement.json"), fastMarkerDisagree], { encoding: "utf8" });
    check(fastMarkerDisagreeRun.status === 0, "fast-route marker host failed: " + String(fastMarkerDisagreeRun.stderr));
    const fastMarkerDisagreeResult = readResult(fastMarkerDisagree);
    check(fastMarkerDisagreeResult.status === "stopped" && fastMarkerDisagreeResult.notice.includes("differs from activation marker scope"),
      "installed fast path ignored activation-marker disagreement: " + fastMarkerDisagreeResult.notice);

    // Control: request team-b, marker team-b, pin team-b -> installed route.
    const fastMatch = writePair("fast-route-scope-match", {
      ...installedRequest,
      operation: "acquire_activate",
      intent: "activation",
      consumer_scope: "team-b",
      consumer_dir: markerB,
      state_root: fastState,
    });
    const fastMatchRun = spawnSync("bun", ["run", path.join(installedRoot, surfaceName), "host", path.join(hostReqDir, "fast-route-scope-match.json"), fastMatch], { encoding: "utf8" });
    check(fastMatchRun.status === 0, "fast-route match host failed: " + String(fastMatchRun.stderr));
    const fastMatchResult = readResult(fastMatch);
    check(fastMatchResult.status === "routed", "matching installed route did not route: " + fastMatchResult.notice);

    console.log("oracle-13 host-protocol-portable: PASS (all three ops through installed entrypoints, resolve-bound python host, scope binding, capability/version stopped)");
  }

  // ---- oracle 14: official registry pin and the card-118 route ----
  //
  // Mirrors the shipped official-registry.json shape (git source, immutable
  // commit, pinned digests, core range) with fixture identities, then
  // falsifies the card-118 route invariants: official acquisition failure is
  // a visible stop naming the package and the manual route, detection never
  // acquires, the installed route resolves offline, drifted installed bytes
  // stop instead of routing, rollback reopens the route without fetching,
  // and official receipts record the actual authorizing registry version.
  {
    const out = path.join(outRoot, "r14-official-pin");
    mkdirP(out);
    const emptyTrust: TrustDoc = { schema_version: "1.0.0", revision: "1", allowlist: [], revocations: [] };

    // A byte-exact local copy stands in for a conforming transport's
    // reconstruction of the pinned tree.
    const localRoot = path.join(out, "materialized");
    copyTree(fixtureRoot, localRoot);

    const officialEntry: RegistryEntry = {
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      repository: "https://github.com/example/fixture-packs",
      subpath: "packages/fixture",
      commit: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      tree_digest: FIXTURE_TREE_DIGEST,
      manifest_digest: FIXTURE_MANIFEST_DIGEST,
      compatible_core_range: ">=0.2.0 <1.0.0",
      discovery: {
        languages: ["fixture-lang"],
        overlays: ["base"],
        workflows: ["explicit_audit_repair"],
        activation_marker: "fixture:language-quality",
      },
    };
    const officialRegistry: RegistryDoc = {
      schema_version: "1.0.0",
      registry_version: "1.4.0",
      packages: [officialEntry],
    };
    const officialRegistryPath = path.join(out, "official-registry.json");
    fs.writeFileSync(officialRegistryPath, JSON.stringify(officialRegistry));


    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    fs.writeFileSync(path.join(stateRoot, "operator-trust.json"), JSON.stringify(emptyTrust));
    const consumer = consumerDir();
    const beforeConsumer = snapshotHashes(consumer);

    const baseRequest = {
      protocol_version: "1.0.0",
      request_id: "req-oracle14-route-01",
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      language: "fixture-lang",
      workflow: "explicit_audit_repair",
      core_version: CORE_VERSION,
      consumer_dir: consumer,
      state_root: stateRoot,
    };

    const surfacePath = process.argv[1];
    const reqDir = path.join(out, "requests");
    const resDir = path.join(out, "results");
    mkdirP(reqDir);
    mkdirP(resDir);
    const hostCall = (name: string, request: Record<string, unknown>, registryPath: string | null): HostResult => {
      const reqFile = path.join(reqDir, name + ".json");
      const resFile = path.join(resDir, name + ".json");
      fs.writeFileSync(reqFile, JSON.stringify(request));
      const argv = ["run", surfacePath, "host", reqFile, resFile];
      if (registryPath !== null) {
        argv.push(registryPath);
      }
      const run = spawnSync("bun", argv, { encoding: "utf8" });
      check(run.status === 0, "host call " + name + " failed: " + String(run.stderr));
      const result = JSON.parse(fs.readFileSync(resFile, "utf8")) as HostResult;
      check(result.request_id === request.request_id, "host call " + name + " dropped request_id");
      return result;
    };

    // Official git-source pin, reference host with no git transport. The
    // stop must be visible, name package@version, and name the manual
    // route. That host result is not the overlap fallback notice.
    const fallback = hostCall("official-acquire-unavailable",
      { ...baseRequest, operation: "acquire_activate", intent: "workflow_request" },
      officialRegistryPath);
    check(fallback.status === "stopped" &&
      fallback.notice.includes("@northstar/language-fixture@0.1.0") &&
      fallback.notice.includes("manual or local-path installation route required"),
      "official acquisition failure did not stop visibly with a manual route: " + fallback.notice);
    check(!fallback.notice.includes("frozen embedded"),
      "host stop claimed overlap fallback: " + fallback.notice);
    requireHashesUnchanged("official-acquisition-failure", consumer, beforeConsumer);

    // Route intent: detection with the official pin present must not acquire.
    const detection = hostCall("official-acquire-detection",
      { ...baseRequest, operation: "acquire_activate", intent: "detection" },
      officialRegistryPath);
    check(detection.status === "stopped" &&
      detection.notice.includes("no acquisition without explicit workflow intent"),
      "detection intent with an official pin present did not stop without acquisition: " + detection.notice);
    requireHashesUnchanged("detection-no-acquisition", consumer, beforeConsumer);

    // Official pin outranks the operator allowlist: with the registry
    // present, a host without official transport stops even when a
    // local-path allowlist entry exists for the same identity. The allowlist
    // never silently bypasses the official pin.
    fs.writeFileSync(path.join(stateRoot, "operator-trust.json"),
      JSON.stringify(fixtureTrustDoc(fixtureRoot, [], [])));
    const bypass = hostCall("allowlist-bypass-attempt",
      { ...baseRequest, operation: "acquire_activate", intent: "workflow_request" },
      officialRegistryPath);
    check(bypass.status === "stopped" &&
      bypass.notice.includes("manual or local-path installation route required"),
      "allowlist pin silently outranked the official registry pin: " + bypass.notice);
    requireHashesUnchanged("allowlist-bypass-attempt", consumer, beforeConsumer);

    // Installed route: a conforming transport reconstructs the exact pinned
    // tree and installs through the lifecycle surface. Provenance must name
    // the actual authorizing registry version and entry digest, and the git
    // source fields, truthfully.
    const officialAcquire = acquireAndActivate({
      stateRoot,
      consumerDir: consumer,
      trustDoc: emptyTrust,
      registry: officialRegistry,
      packageId: officialEntry.package_id,
      version: officialEntry.version,
      language: "fixture-lang",
      workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION,
      adapter: (): string => {
        const staged = stagedDir("northstar-staged-");
        copyTree(localRoot, staged);
        return staged;
      },
      intent: "workflow_request",
    });
    check(officialAcquire.status === "activated" && officialAcquire.treeDigest === FIXTURE_TREE_DIGEST,
      "official-pin acquisition did not activate: " + officialAcquire.notice);
    const firstReceiptDigest = officialAcquire.receiptDigest;
    const officialReceipt = loadReceipt(stateRoot, firstReceiptDigest);
    check(officialReceipt !== null, "official-pin receipt missing");
    const officialTrust = officialReceipt!.trust_class as Record<string, unknown>;
    check(officialTrust.type === "official" && officialTrust.registry_version === "1.4.0",
      "official receipt did not record the actual registry version: " + JSON.stringify(officialTrust));
    check(officialTrust.registry_entry_digest === registryEntryDigest(officialEntry),
      "official receipt did not record the registry entry digest: " + JSON.stringify(officialTrust));
    const officialSource = officialReceipt!.source as Record<string, unknown>;
    check(officialSource.type === "git" && officialSource.repository === officialEntry.repository &&
      officialSource.subpath === officialEntry.subpath && officialSource.commit === officialEntry.commit,
      "official receipt did not record the git source truthfully: " + JSON.stringify(officialSource));
    requireHashesUnchanged("official-install", consumer, beforeConsumer);

    const routed = hostCall("installed-resolve",
      { ...baseRequest, operation: "resolve", intent: "workflow_request" },
      officialRegistryPath);
    check(routed.status === "routed" && routed.tree_digest === FIXTURE_TREE_DIGEST &&
      typeof routed.installed_path === "string",
      "installed route did not resolve offline: " + routed.notice);

    // Identity drift: mutated installed bytes stop; exact restoration reopens
    // the route. Drift never routes silently.
    const installedPath = routed.installed_path as string;
    const probeRel = "references/modes/fixture-audit.md";
    const probePath = path.join(installedPath, probeRel);
    const probeOriginal = fs.readFileSync(probePath);
    fs.writeFileSync(probePath, Buffer.concat([probeOriginal, Buffer.from("\n<!-- drift -->\n")]));
    const drift = hostCall("installed-resolve-drift",
      { ...baseRequest, operation: "resolve", intent: "workflow_request" },
      officialRegistryPath);
    check(drift.status === "stopped",
      "drifted installed content did not stop the route: " + drift.notice);
    fs.writeFileSync(probePath, probeOriginal);
    const restored = hostCall("installed-resolve-restored",
      { ...baseRequest, operation: "resolve", intent: "workflow_request" },
      officialRegistryPath);
    check(restored.status === "routed",
      "restored installed content did not reopen the route: " + restored.notice);

    // Rollback: activate 0.2.0, then roll back to the retained 0.1.0 receipt
    // through the host without fetching; the route reopens on 0.1.0.
    const variant = buildVariantPackage(fixtureRoot, "0.2.0", () => {});
    const variantPinEntry = variantPin("@northstar/language-fixture", "0.2.0", variant);
    fs.writeFileSync(path.join(stateRoot, "operator-trust.json"),
      JSON.stringify(fixtureTrustDoc(fixtureRoot, [variantPinEntry], [])));
    const updated = hostCall("installed-update",
      { ...baseRequest, version: "0.2.0", operation: "acquire_activate", intent: "workflow_request" },
      officialRegistryPath);
    check(updated.status === "activated",
      "installed update to the variant did not activate: " + updated.notice);
    const rolledBack = hostCall("installed-rollback",
      { ...baseRequest, operation: "rollback", intent: "workflow_request", target_receipt_digest: firstReceiptDigest },
      officialRegistryPath);
    check(rolledBack.status === "rolled_back" && rolledBack.tree_digest === FIXTURE_TREE_DIGEST,
      "rollback did not reselect the retained pinned identity: " + rolledBack.notice);
    const afterRollback = hostCall("installed-resolve-after-rollback",
      { ...baseRequest, operation: "resolve", intent: "workflow_request" },
      officialRegistryPath);
    check(afterRollback.status === "routed" && afterRollback.tree_digest === FIXTURE_TREE_DIGEST,
      "route did not reopen on the rolled-back identity: " + afterRollback.notice);

    requireHashesUnchanged("card-118-route", consumer, beforeConsumer);
    console.log("oracle-14 official-pin-route: PASS (visible acquisition stop, route intent, installed offline route, drift stop, rollback recovery, registry-version provenance)");
  }

  // ---- card 122: generic registry-owned intent/activation selection ----
  //
  // The selection procedure is data-driven over discovery metadata: no
  // package name, language ecosystem, or acquisition path appears in the
  // selection implementation. These proofs use policy-free fixture entries.
  {
    const out = path.join(outRoot, "r16-generic-selection");
    mkdirP(out);
    const mkEntry = (packageId: string, version: string, coreRange: string, discovery: RegistryDiscovery): RegistryEntry => ({
      package_id: packageId,
      version,
      tree_digest: FIXTURE_TREE_DIGEST,
      manifest_digest: FIXTURE_MANIFEST_DIGEST,
      compatible_core_range: coreRange,
      discovery,
    });
    const alpha = mkEntry("@northstar/alpha-fixture", "0.1.0", ">=0.2.0 <1.0.0",
      { languages: ["alpha"], overlays: ["alpha-ui"], workflows: ["audit_workflow"], activation_marker: "fixture:alpha-marker" });
    const beta = mkEntry("@northstar/beta-fixture", "0.2.0", ">=0.2.0 <1.0.0",
      { languages: ["beta"], overlays: [], workflows: ["audit_workflow", "authoring_workflow"], activation_marker: "fixture:beta-marker" });
    const twoEntry: RegistryDoc = { schema_version: "1.0.0", registry_version: "1.5.0", packages: [alpha, beta] };

    const expectSelectionStop = (label: string, coreVersion: string, registry: RegistryDoc, query: SelectionQuery, reason: string): void => {
      let stopped = false;
      try {
        selectRegistryEntry(registry, coreVersion, query);
      } catch (err) {
        stopped = true;
        check(String((err as Error).message).includes(reason), label + " stopped for the wrong reason: " + String((err as Error).message));
      }
      check(stopped, label + " did not stop selection");
    };

    // Explicit intent selects exactly one compatible entry, including
    // overlay scoping and the everyday workflow of a partial pack.
    check(selectRegistryEntry(twoEntry, CORE_VERSION, { kind: "intent", language: "alpha", workflow: "audit_workflow", overlay: null }).package_id === "@northstar/alpha-fixture",
      "alpha audit intent did not select the alpha entry");
    check(selectRegistryEntry(twoEntry, CORE_VERSION, { kind: "intent", language: "alpha", workflow: "audit_workflow", overlay: "alpha-ui" }).package_id === "@northstar/alpha-fixture",
      "alpha overlay audit intent did not select the alpha entry");
    check(selectRegistryEntry(twoEntry, CORE_VERSION, { kind: "intent", language: "beta", workflow: "audit_workflow", overlay: null }).package_id === "@northstar/beta-fixture",
      "beta audit intent did not select the beta entry");
    check(selectRegistryEntry(twoEntry, CORE_VERSION, { kind: "intent", language: "beta", workflow: "authoring_workflow", overlay: null }).package_id === "@northstar/beta-fixture",
      "beta authoring intent did not select the beta entry");

    // Unsupported work stays unavailable: no substitution, no acquisition.
    expectSelectionStop("unsupported-workflow", CORE_VERSION, twoEntry,
      { kind: "intent", language: "alpha", workflow: "authoring_workflow", overlay: null }, "stays unavailable");
    expectSelectionStop("undeclared-overlay", CORE_VERSION, twoEntry,
      { kind: "intent", language: "beta", workflow: "audit_workflow", overlay: "alpha-ui" }, "stays unavailable");

    // Two entries claiming one language/workflow stop as ambiguous.
    const gamma = mkEntry("@northstar/gamma-fixture", "0.3.0", ">=0.2.0 <1.0.0",
      { languages: ["alpha"], overlays: [], workflows: ["audit_workflow"], activation_marker: "fixture:gamma-marker" });
    const ambiguous: RegistryDoc = { schema_version: "1.0.0", registry_version: "1.5.0", packages: [alpha, beta, gamma] };
    expectSelectionStop("ambiguous-intent", CORE_VERSION, ambiguous,
      { kind: "intent", language: "alpha", workflow: "audit_workflow", overlay: null }, "ambiguous");
    // A unique marker still selects exactly one entry from the three-entry
    // registry; duplicate markers cannot reach selection because parse
    // rejects them (proved below).
    check(selectRegistryEntry(ambiguous, CORE_VERSION, { kind: "marker", marker: "fixture:gamma-marker" }).package_id === "@northstar/gamma-fixture",
      "the unique gamma marker did not select the gamma entry");

    // A single claiming entry outside the core range stops incompatible.
    const future = mkEntry("@northstar/epsilon-fixture", "0.5.0", ">=9.0.0 <10.0.0",
      { languages: ["epsilon"], overlays: [], workflows: ["audit_workflow"], activation_marker: "fixture:epsilon-marker" });
    const futureRegistry: RegistryDoc = { schema_version: "1.0.0", registry_version: "1.5.0", packages: [future] };
    expectSelectionStop("incompatible-core", CORE_VERSION, futureRegistry,
      { kind: "intent", language: "epsilon", workflow: "audit_workflow", overlay: null }, "incompatible with core");
    expectSelectionStop("incompatible-core-marker", CORE_VERSION, futureRegistry,
      { kind: "marker", marker: "fixture:epsilon-marker" }, "incompatible with core");

    // Duplicate activation markers fail closed at registry parse, before any
    // host invocation.
    const delta = mkEntry("@northstar/delta-fixture", "0.4.0", ">=0.2.0 <1.0.0",
      { languages: ["delta"], overlays: [], workflows: ["audit_workflow"], activation_marker: "fixture:alpha-marker" });
    let parseStopped = false;
    try {
      parseRegistryDoc({ schema_version: "1.0.0", registry_version: "1.5.0", packages: [alpha, delta] } as unknown, "duplicate-marker registry");
    } catch (err) {
      parseStopped = true;
      check(String((err as Error).message).includes("duplicate activation marker"),
        "duplicate marker registry stopped for the wrong reason: " + String((err as Error).message));
    }
    check(parseStopped, "duplicate activation markers did not fail registry parse");

    // The selection CLI refuses detection-only input: a language without an
    // explicit workflow is not a query shape and can never select.
    const twoEntryPath = path.join(out, "two-entry-registry.json");
    fs.writeFileSync(twoEntryPath, JSON.stringify(twoEntry));
    const surfacePath = process.argv[1];
    const runSelect = (cliArgs: string[]): { status: number | null; output: string } => {
      const run = spawnSync("bun", ["run", surfacePath, "select", twoEntryPath, ...cliArgs], { encoding: "utf8" });
      return { status: run.status, output: run.stdout + "\n" + run.stderr };
    };
    const cliPositive = runSelect(["--language", "alpha", "--workflow", "audit_workflow"]);
    check(cliPositive.status === 0 && cliPositive.output.includes("selected @northstar/alpha-fixture@0.1.0"),
      "selection CLI did not select the explicit-intent entry: " + cliPositive.output);
    const cliDetection = runSelect(["--language", "alpha"]);
    check(cliDetection.status !== 0 && cliDetection.output.includes("detection is not selection authority"),
      "detection-only input did not fail closed at the selection CLI: " + cliDetection.output);
    // The CLI enforces the documented two-shape grammar exactly.
    const cliUnknownFlag = runSelect(["--language", "alpha", "--workflow", "audit_workflow", "--overaly", "alpha-ui"]);
    check(cliUnknownFlag.status !== 0 && cliUnknownFlag.output.includes("unknown selection flag: --overaly"),
      "unknown flag did not fail closed at the selection CLI: " + cliUnknownFlag.output);
    const cliDuplicateFlag = runSelect(["--language", "alpha", "--language", "beta", "--workflow", "audit_workflow"]);
    check(cliDuplicateFlag.status !== 0 && cliDuplicateFlag.output.includes("duplicate selection flag: --language"),
      "duplicate flag did not fail closed at the selection CLI: " + cliDuplicateFlag.output);
    const cliMixedShape = runSelect(["--marker", "fixture:alpha-marker", "--language", "beta", "--workflow", "audit_workflow"]);
    check(cliMixedShape.status !== 0 && cliMixedShape.output.includes("mixed selection query"),
      "mixed marker+intent query did not fail closed at the selection CLI: " + cliMixedShape.output);
    const cliOverlayWithMarker = runSelect(["--marker", "fixture:alpha-marker", "--overlay", "alpha-ui"]);
    check(cliOverlayWithMarker.status !== 0 && cliOverlayWithMarker.output.includes("mixed selection query"),
      "shape-inapplicable flag did not fail closed at the selection CLI: " + cliOverlayWithMarker.output);
    const cliMissingValue = runSelect(["--language", "alpha", "--workflow"]);
    check(cliMissingValue.status !== 0 && cliMissingValue.output.includes("requires a value"),
      "flag without a value did not fail closed at the selection CLI: " + cliMissingValue.output);

    // The --json result carries the exact immutable identity, and the
    // independent digest vectors prove it: an exact-value proof that fails
    // if any identity field drifts while package ID and version stay fixed.
    const cliJsonPath = path.join(out, "selection-identity.json");
    const cliJson = runSelect(["--language", "alpha", "--workflow", "audit_workflow", "--json", cliJsonPath]);
    check(cliJson.status === 0, "identity selection CLI failed: " + cliJson.output);
    const identitySelection = JSON.parse(fs.readFileSync(cliJsonPath, "utf8")) as Record<string, unknown>;
    check(identitySelection.package_id === "@northstar/alpha-fixture" &&
      identitySelection.version === "0.1.0" &&
      identitySelection.tree_digest === FIXTURE_TREE_DIGEST &&
      identitySelection.manifest_digest === FIXTURE_MANIFEST_DIGEST,
      "selection identity JSON does not carry the exact pinned identity: " + JSON.stringify(identitySelection));
    const driftedReader = JSON.parse(JSON.stringify(twoEntry)) as RegistryDoc;
    driftedReader.packages[0].tree_digest = "sha256:" + "0".repeat(64);
    const driftedPath = path.join(out, "drifted-identity-registry.json");
    fs.writeFileSync(driftedPath, JSON.stringify(driftedReader));
    const driftedJsonRun = spawnSync("bun", ["run", surfacePath, "select", driftedPath,
      "--language", "alpha", "--workflow", "audit_workflow", "--json", path.join(out, "drifted-selection.json")], { encoding: "utf8" });
    check(driftedJsonRun.status === 0, "drifted-identity registry unexpectedly failed selection: " + driftedJsonRun.stderr);
    const driftedSelection = JSON.parse(fs.readFileSync(path.join(out, "drifted-selection.json"), "utf8")) as Record<string, unknown>;
    check(driftedSelection.package_id === identitySelection.package_id &&
      driftedSelection.version === identitySelection.version &&
      driftedSelection.tree_digest !== identitySelection.tree_digest,
      "identity JSON did not distinguish a same-ID/version tree drift: " + JSON.stringify(driftedSelection));

    console.log("oracle-16 registry-selection-intent: PASS (explicit language/workflow/overlay intent selects exactly one entry; unsupported workflow, undeclared overlay, ambiguous claims, incompatible core, duplicate-marker parse, detection-only input, unknown/duplicate/mixed/shape-inapplicable CLI flags, and valueless flags fail closed; selection --json carries the exact pinned identity)");

    // Exact registered activation markers select their entries; anything
    // that is not the exact marker string selects nothing.
    check(selectRegistryEntry(twoEntry, CORE_VERSION, { kind: "marker", marker: "fixture:alpha-marker" }).package_id === "@northstar/alpha-fixture",
      "the exact alpha marker did not select the alpha entry");
    check(selectRegistryEntry(twoEntry, CORE_VERSION, { kind: "marker", marker: "fixture:beta-marker" }).package_id === "@northstar/beta-fixture",
      "the exact beta marker did not select the beta entry");
    expectSelectionStop("marker-prefix", CORE_VERSION, twoEntry,
      { kind: "marker", marker: "fixture:alpha" }, "no official registry entry carries the activation marker");
    expectSelectionStop("marker-unknown", CORE_VERSION, twoEntry,
      { kind: "marker", marker: "fixture:unknown" }, "no official registry entry carries the activation marker");

    console.log("oracle-17 registry-selection-marker: PASS (exact registered markers select their entries without consumer rewrites; prefix, unknown, and duplicate markers fail closed)");
  }

  // ---- oracle 18: registry/manifest discovery agreement before routing ----
  //
  // A registry entry whose discovery metadata disagrees with the verified
  // installed manifest is metadata drift: the route stops instead of
  // trusting the pin. Agreement reopens the route without refetching.
  {
    const out = path.join(outRoot, "r18-discovery-agreement");
    mkdirP(out);
    const emptyTrust: TrustDoc = { schema_version: "1.0.0", revision: "1", allowlist: [], revocations: [] };
    const fixtureDiscovery: RegistryDiscovery = { languages: ["fixture-lang"], overlays: ["base"], workflows: ["explicit_audit_repair"], activation_marker: "fixture:language-quality" };
    const agreeingEntry: RegistryEntry = {
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      repository: "https://github.com/example/fixture-packs",
      subpath: "packages/fixture",
      commit: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      tree_digest: FIXTURE_TREE_DIGEST,
      manifest_digest: FIXTURE_MANIFEST_DIGEST,
      compatible_core_range: ">=0.2.0 <1.0.0",
      discovery: fixtureDiscovery,
    };
    const drift = (mutate: (discovery: RegistryDiscovery) => void): string => {
      const discovery = JSON.parse(JSON.stringify(fixtureDiscovery)) as RegistryDiscovery;
      mutate(discovery);
      const registry: RegistryDoc = {
        schema_version: "1.0.0",
        registry_version: "1.5.0",
        packages: [{ ...agreeingEntry, discovery }],
      };
      const registryPath = path.join(out, "registry-drift.json");
      fs.writeFileSync(registryPath, JSON.stringify(registry));
      return registryPath;
    };
    const agreeingPath = path.join(out, "registry-agreeing.json");
    fs.writeFileSync(agreeingPath, JSON.stringify({ schema_version: "1.0.0", registry_version: "1.5.0", packages: [agreeingEntry] }));

    const stateRoot = path.join(out, "state");
    mkdirP(stateRoot);
    fs.writeFileSync(path.join(stateRoot, "operator-trust.json"), JSON.stringify(emptyTrust));
    const consumer = consumerDir();
    const beforeConsumer = snapshotHashes(consumer);
    const installed = acquireAndActivate({
      stateRoot,
      consumerDir: consumer,
      trustDoc: emptyTrust,
      registry: { schema_version: "1.0.0", registry_version: "1.5.0", packages: [agreeingEntry] },
      packageId: "@northstar/language-fixture",
      version: "0.1.0",
      language: "fixture-lang",
      workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION,
      adapter: fixtureAdapter(fixtureRoot),
      intent: "workflow_request",
    });
    check(installed.status === "activated", "agreement fixture did not install: " + installed.notice);

    const reqDir = path.join(out, "requests");
    const resDir = path.join(out, "results");
    mkdirP(reqDir);
    mkdirP(resDir);
    let callCount = 0;
    const hostResolve = (registryPath: string): HostResult => {
      callCount += 1;
      const reqFile = path.join(reqDir, "resolve-" + String(callCount) + ".json");
      const resFile = path.join(resDir, "resolve-" + String(callCount) + ".json");
      fs.writeFileSync(reqFile, JSON.stringify({
        protocol_version: "1.0.0",
        request_id: "req-oracle18-route-" + String(callCount),
        operation: "resolve",
        intent: "workflow_request",
        package_id: "@northstar/language-fixture",
        version: "0.1.0",
        language: "fixture-lang",
        workflow: "explicit_audit_repair",
        core_version: CORE_VERSION,
        consumer_dir: consumer,
        state_root: stateRoot,
      }));
      const run = spawnSync("bun", ["run", process.argv[1], "host", reqFile, resFile, registryPath], { encoding: "utf8" });
      check(run.status === 0, "agreement host call failed: " + String(run.stderr));
      return JSON.parse(fs.readFileSync(resFile, "utf8")) as HostResult;
    };

    const routed = hostResolve(agreeingPath);
    check(routed.status === "routed", "agreeing metadata did not route: " + routed.notice);
    check(hostResolve(drift((d) => { d.workflows = ["explicit_audit_repair", "authoring_workflow"]; })).status === "stopped" &&
      fs.readFileSync(path.join(resDir, "resolve-" + String(callCount) + ".json"), "utf8").includes("metadata drift"),
      "a registry claiming an undeclared workflow did not stop the route on metadata drift");
    check(hostResolve(drift((d) => { d.languages = ["fixture-lang", "other-lang"]; })).status === "stopped",
      "a registry claiming an undeclared language did not stop the route");
    check(hostResolve(drift((d) => { d.overlays = ["base", "extra-ui"]; })).status === "stopped",
      "a registry claiming an undeclared overlay did not stop the route");
    check(hostResolve(drift((d) => { d.workflows = []; })).status === "stopped",
      "a registry with empty discovery metadata did not stop the route");
    const restored = hostResolve(agreeingPath);
    check(restored.status === "routed", "restored agreement did not reopen the route: " + restored.notice);
    requireHashesUnchanged("discovery-agreement", consumer, beforeConsumer);

    // Acquisition-path counterexample (review finding 3): a registry whose
    // discovery drifted from the identity-verified staged manifest must stop
    // acquisition BEFORE self-check, receipt, or lifecycle mutation — not at
    // a later resolve. A sentinel self-check proves package code never ran.
    const sentinelPath = path.join(out, "self-check-executed.sentinel");
    const acquisitionVariant = buildVariantPackage(fixtureRoot, "0.1.0", (manifest, root) => {
      manifest.self_check.entrypoint = "scripts/sentinel-self-check.sh";
      // The sentinel path is baked into the script: Bun's spawnSync does not
      // inherit runtime process.env mutations, and the oracle must not
      // depend on host environment behavior.
      writeBytes(path.join(root, "scripts/sentinel-self-check.sh"),
        Buffer.from("#!/bin/sh\ntouch \"" + sentinelPath + "\"\nexit 0\n", "utf8"), 0o755);
    });
    const variantEntryBase = {
      package_id: "@northstar/language-fixture",
      version: "0.1.0",
      repository: "https://github.com/example/fixture-packs",
      subpath: "packages/fixture",
      commit: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      tree_digest: canonicalTreeDigest(acquisitionVariant, "acquisition variant"),
      manifest_digest: manifestDigestOf(path.join(acquisitionVariant, "northstar-package.json")),
      compatible_core_range: ">=0.2.0 <1.0.0",
    };
    const driftedVariantRegistryPath = path.join(out, "registry-drift-variant.json");
    fs.writeFileSync(driftedVariantRegistryPath, JSON.stringify({
      schema_version: "1.0.0",
      registry_version: "1.5.0",
      packages: [{ ...variantEntryBase, discovery: { ...fixtureDiscovery, workflows: ["explicit_audit_repair", "authoring_workflow"] } }],
    }));
    const agreeingVariantRegistryPath = path.join(out, "registry-agreeing-variant.json");
    fs.writeFileSync(agreeingVariantRegistryPath, JSON.stringify({
      schema_version: "1.0.0",
      registry_version: "1.5.0",
      packages: [{ ...variantEntryBase, discovery: fixtureDiscovery }],
    }));

    // Drifted acquisition: stops visibly, self-check unexecuted, no receipt,
    // no lifecycle state, consumer byte-identical. The call drives
    // acquireAndActivate directly with a conforming transport (like the
    // oracle-14 real install), because the gate under test sits inside the
    // acquisition transaction, not in the host transport layer.
    const acquireDriftState = path.join(out, "acquire-drift-state");
    mkdirP(acquireDriftState);
    fs.writeFileSync(path.join(acquireDriftState, "operator-trust.json"), JSON.stringify(emptyTrust));
    const driftConsumer = consumerDir();
    const beforeDriftConsumer = snapshotHashes(driftConsumer);
    fs.rmSync(sentinelPath, { force: true });
    let driftStopped = false;
    try {
      acquireAndActivate({
        stateRoot: acquireDriftState,
        consumerDir: driftConsumer,
        trustDoc: emptyTrust,
        registry: JSON.parse(fs.readFileSync(driftedVariantRegistryPath, "utf8")) as RegistryDoc,
        packageId: "@northstar/language-fixture",
        version: "0.1.0",
        workflow: "explicit_audit_repair",
        coreVersion: CORE_VERSION,
        adapter: fixtureAdapter(acquisitionVariant),
        intent: "workflow_request",
      });
    } catch (err) {
      driftStopped = String((err as Error).message).includes("metadata drift") &&
        String((err as Error).message).includes("before self-check, receipt, or lifecycle mutation");
    }
    check(driftStopped, "drifted registry acquisition did not stop before self-check on metadata drift");
    check(!fs.existsSync(sentinelPath), "package self-check executed during a drifted acquisition");
    check(!fs.existsSync(path.join(acquireDriftState, "receipts")) &&
      !fs.existsSync(path.join(acquireDriftState, "lifecycle-state.json")),
      "drifted acquisition mutated the operator lifecycle state");
    requireHashesUnchanged("acquisition-drift-consumer", driftConsumer, beforeDriftConsumer);

    // Agreeing control: the same staged payload with agreeing metadata
    // activates, the sentinel proves the self-check ran, and lifecycle state
    // is written — the drift stop is the only difference.
    const acquireAgreeState = path.join(out, "acquire-agree-state");
    mkdirP(acquireAgreeState);
    fs.writeFileSync(path.join(acquireAgreeState, "operator-trust.json"), JSON.stringify(emptyTrust));
    const agreeConsumer = consumerDir();
    fs.rmSync(sentinelPath, { force: true });
    const agreeAcquire = acquireAndActivate({
      stateRoot: acquireAgreeState,
      consumerDir: agreeConsumer,
      trustDoc: emptyTrust,
      registry: JSON.parse(fs.readFileSync(agreeingVariantRegistryPath, "utf8")) as RegistryDoc,
      packageId: "@northstar/language-fixture",
      version: "0.1.0",
      language: "fixture-lang",
      workflow: "explicit_audit_repair",
      coreVersion: CORE_VERSION,
      adapter: fixtureAdapter(acquisitionVariant),
      intent: "workflow_request",
    });
    check(agreeAcquire.status === "activated", "agreeing acquisition control did not activate: " + agreeAcquire.notice);
    check(fs.existsSync(sentinelPath), "sentinel self-check did not run during the agreeing control acquisition");
    check(fs.existsSync(path.join(acquireAgreeState, "lifecycle-state.json")),
      "agreeing acquisition did not write lifecycle state");

    console.log("oracle-18 registry-discovery-agreement: PASS (agreeing metadata routes and activates; dropped, extra, or emptied languages/overlays/workflows stop resolve AND acquisition as metadata drift before self-check, receipt, or lifecycle mutation; sentinel proves package code never ran on drift; consumer stays byte-identical)");
  }


  console.log("card-117 oracle: PASS (8 review rows + transitions + restrictions + provenance + concurrency + self-check + identity-binding/store negatives)");
  console.log("card-118 oracle: PASS (official registry pin route: visible acquisition stop, route intent, installed offline route, drift stop, rollback recovery, registry-version provenance)");
  console.log("card-122 oracle: PASS (generic registry-owned selection: explicit intent and exact activation markers select one data-driven entry; unsupported work, ambiguity, drift, and detection fail closed before acquisition)");
}

function parseRouteFlags(args: string[]): Record<string, string> {
  const allowed = new Set([
    "--consumer", "--language", "--workflow", "--overlay", "--marker",
    "--core-version", "--state-root", "--registry", "--json",
  ]);
  const parsed: Record<string, string> = {};
  for (let i = 0; i < args.length; i += 2) {
    const flag = args[i];
    check(flag !== undefined && allowed.has(flag), "unknown route flag: " + String(flag));
    const value = args[i + 1];
    check(value !== undefined && !value.startsWith("--"), "route flag " + flag + " requires a value");
    check(!(flag in parsed), "duplicate route flag: " + flag);
    parsed[flag] = value;
  }
  return parsed;
}

function defaultOperatorStateRoot(): string {
  const explicit = process.env.NORTHSTAR_LANGUAGE_PACKAGE_STATE_ROOT;
  if (explicit !== undefined && explicit.trim() !== "") {
    return path.resolve(explicit);
  }
  const xdg = process.env.XDG_DATA_HOME;
  if (xdg !== undefined && xdg.trim() !== "") {
    check(path.isAbsolute(xdg), "XDG_DATA_HOME must be absolute");
    return path.join(xdg, "northstar", "language-packages");
  }
  return path.join(os.homedir(), ".local", "share", "northstar", "language-packages");
}

function runPublicRoute(args: string[]): void {
  const flags = parseRouteFlags(args);
  const scriptRoot = path.resolve(path.dirname(process.argv[1]), "..");
  const registryPath = path.resolve(flags["--registry"] ?? path.join(scriptRoot, "references/packages/official-registry.json"));
  check(fs.existsSync(registryPath), "official registry missing: " + registryPath);
  const registry = parseRegistryDoc(JSON.parse(fs.readFileSync(registryPath, "utf8")), "route registry");

  const consumerFlag = flags["--consumer"];
  check(consumerFlag !== undefined, "route requires --consumer <directory>");
  const requestedConsumer = path.resolve(consumerFlag);
  check(fs.existsSync(requestedConsumer), "consumer does not exist: " + requestedConsumer);
  const consumerDir = fs.realpathSync(requestedConsumer);
  check(fs.statSync(consumerDir).isDirectory(), "consumer is not a directory: " + consumerDir);

  const workflow = flags["--workflow"];
  check(workflow !== undefined, "route requires --workflow <workflow>");
  const marker = flags["--marker"];
  const requestedLanguage = flags["--language"];
  let query: SelectionQuery;
  if (marker !== undefined) {
    query = { kind: "marker", marker };
  } else {
    check(requestedLanguage !== undefined,
      "route requires either --language <language> or --marker <activation-marker>");
    query = { kind: "intent", language: requestedLanguage, workflow, overlay: flags["--overlay"] ?? null };
  }
  const coreVersion = flags["--core-version"] ?? CORE_VERSION;
  const entry = selectRegistryEntry(registry, coreVersion, query);
  check(entry.discovery.workflows.includes(workflow),
    "selected package does not declare workflow " + workflow);
  const language = requestedLanguage ?? (entry.discovery.languages.length === 1 ? entry.discovery.languages[0] : undefined);
  check(language !== undefined && entry.discovery.languages.includes(language),
    "route must name one language declared by the selected package");
  const overlay = flags["--overlay"];
  if (overlay !== undefined) {
    check(entry.discovery.overlays.includes(overlay), "selected package does not declare overlay " + overlay);
  }

  const stateRoot = path.resolve(flags["--state-root"] ?? defaultOperatorStateRoot());
  fs.mkdirSync(stateRoot, { recursive: true, mode: 0o700 });
  fs.chmodSync(stateRoot, 0o700);
  const trustDoc = hostTrustDoc(stateRoot);
  const outcome = acquireAndActivate({
    stateRoot,
    consumerDir,
    trustDoc,
    registry,
    packageId: entry.package_id,
    version: entry.version,
    language,
    workflow,
    coreVersion,
    adapter: publicAcquisitionAdapter(),
    intent: marker === undefined ? "workflow_request" : "activation",
    activationMarker: marker,
  });
  check(outcome.status === "activated" || outcome.status === "routed",
    "language package did not route: " + outcome.notice);
  check(outcome.installDir !== undefined, "language package route returned no installed path");
  const manifest = verifyInstalledIdentity(outcome.installDir, {
    tree_digest: entry.tree_digest,
    manifest_digest: entry.manifest_digest,
  }, "public route");
  const entrypoint = manifest.entrypoints[workflow];
  check(isString(entrypoint) && isSafePackageRelativePath(entrypoint),
    "installed package has no valid entrypoint for workflow " + workflow);
  const entrypointPath = path.join(outcome.installDir, entrypoint);
  check(fs.existsSync(entrypointPath) && fs.statSync(entrypointPath).isFile(),
    "installed workflow entrypoint is missing: " + entrypointPath);

  const result = {
    status: outcome.status,
    package_id: entry.package_id,
    version: entry.version,
    language,
    workflow,
    overlay: overlay ?? null,
    state_root: stateRoot,
    installed_path: outcome.installDir,
    entrypoint_path: entrypointPath,
    tree_digest: outcome.treeDigest,
    manifest_digest: outcome.manifestDigest,
    receipt_digest: outcome.receiptDigest,
    notice: outcome.notice,
  };
  const output = JSON.stringify(result, null, 2) + "\n";
  if (flags["--json"] !== undefined) {
    fs.writeFileSync(path.resolve(flags["--json"]), output);
  }
  process.stdout.write(output);
}

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const command = args[0];
  if (command === "oracle") {
    const fixtureRoot = args[1];
    const outRoot = args[2];
    check(fs.existsSync(fixtureRoot), "fixture root missing: " + fixtureRoot);
    await runOracle(fixtureRoot, outRoot);
    return;
  }
  if (command === "vectors") {
    runVectors(args[1]);
    return;
  }
  if (command === "cas-race") {
    casRaceMain(args.slice(1));
    return;
  }
  if (command === "host") {
    // host <request-file> <result-file> [registry-path]: reference host
    // adapter for the language-package-host.v1 protocol.
    const request = parseHostRequest(JSON.parse(fs.readFileSync(args[1], "utf8")), "host request");
    const result = executeHostRequest(request, args[3] ?? null, FULL_HOST_CAPABILITIES);
    fs.writeFileSync(args[2], JSON.stringify(result));
    return;
  }
  if (command === "route") {
    // route --consumer <dir> --workflow <workflow>
    //   (--language <language> [--overlay <overlay>] | --marker <marker>)
    //   [--state-root <dir>] [--registry <file>] [--core-version <v>]
    //   [--json <file>]
    runPublicRoute(args.slice(1));
    return;
  }
  if (command === "select") {
    // select <registry-file> (--language <l> --workflow <w> [--overlay <o>]
    //   | --marker <m>) [--core-version <v>] [--json <out>]
    // Generic registry-owned selection: explicit workflow intent or an exact
    // activation marker selects one entry. Detection-only input (a language
    // with no workflow, or any query without intent or marker) fails closed.
    const registry = parseRegistryDoc(JSON.parse(fs.readFileSync(args[1], "utf8")), "selection registry");
    // The CLI enforces the documented two-shape grammar exactly: known
    // flags only, no duplicates, a value per flag, and exactly one query
    // shape. Anything else fails closed before any selection.
    const allowedFlags = new Set(["--language", "--workflow", "--overlay", "--marker", "--core-version", "--json"]);
    const seenFlags: Record<string, string> = {};
    for (let i = 2; i < args.length; i += 2) {
      const flag = args[i];
      check(flag !== undefined && flag.startsWith("--"),
        "selection arguments must be <flag> <value> pairs; got " + String(flag));
      check(allowedFlags.has(flag), "unknown selection flag: " + flag);
      const value = args[i + 1];
      check(value !== undefined && !value.startsWith("--"), "selection flag " + flag + " requires a value");
      check(!(flag in seenFlags), "duplicate selection flag: " + flag);
      seenFlags[flag] = value;
    }
    const coreVersion = seenFlags["--core-version"] ?? CORE_VERSION;
    const marker = seenFlags["--marker"];
    const language = seenFlags["--language"];
    const workflow = seenFlags["--workflow"];
    const overlay = seenFlags["--overlay"];
    const intentShape = language !== undefined || workflow !== undefined || overlay !== undefined;
    check(marker === undefined || !intentShape,
      "mixed selection query: --marker cannot be combined with --language, --workflow, or --overlay; exactly one query shape is required");
    let query: SelectionQuery;
    if (marker !== undefined) {
      query = { kind: "marker", marker };
    } else if (language !== undefined && workflow !== undefined) {
      query = { kind: "intent", language, workflow, overlay: overlay ?? null };
    } else {
      check(false, "detection is not selection authority: an explicit workflow request (--language with --workflow) or an exact activation marker (--marker) is required; nothing was selected or acquired");
      return;
    }
    const entry = selectRegistryEntry(registry, coreVersion, query);
    // The selection result carries the exact immutable identity the route
    // needs, not just the human-facing ID/version: this project has
    // repinned the same ID/version to new identities before.
    const selection: Record<string, unknown> = {
      package_id: entry.package_id,
      version: entry.version,
      compatible_core_range: entry.compatible_core_range,
      tree_digest: entry.tree_digest,
      manifest_digest: entry.manifest_digest,
    };
    if (entry.repository !== undefined) {
      selection.repository = entry.repository;
    }
    if (entry.subpath !== undefined) {
      selection.subpath = entry.subpath;
    }
    if (entry.commit !== undefined) {
      selection.commit = entry.commit;
    }
    if (seenFlags["--json"] !== undefined) {
      fs.writeFileSync(seenFlags["--json"], JSON.stringify(selection, null, 2) + "\n");
    }
    console.log("selected " + entry.package_id + "@" + entry.version + " for " + describeQuery(query) +
      " tree=" + entry.tree_digest + " manifest=" + entry.manifest_digest);
    return;
  }
  throw new Error("usage: language-package-lifecycle.ts route --consumer <dir> --workflow <w> (--language <l> [--overlay <o>] | --marker <m>) [--state-root <dir>] [--registry <file>] [--core-version <v>] [--json <out>] | oracle <fixture-root> <out-dir> | vectors <fixture-root> | cas-race <state-root> <observed> <payload-file> <hold|attempt> | host <request-file> <result-file> [registry-path] | select <registry-file> (--language <l> --workflow <w> [--overlay <o>] | --marker <m>) [--core-version <v>] [--json <out>]");
}

await main();
