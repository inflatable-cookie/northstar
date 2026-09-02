// Synthetic unknown-language fixture package self-check entrypoint
let manifest_path = path::join(repo_root, "skills/northstar/assets/fixtures/language-packages/synthetic-language/northstar-package.json");
if !fs::is_file(manifest_path) {
    throw("[synthetic-package:self-check] missing manifest: " + manifest_path);
}
let manifest = json::read_file(manifest_path);
if manifest["package_id"] != "@northstar/synthetic-language" {
    throw("[synthetic-package:self-check] wrong package identity: " + manifest["package_id"]);
}
if manifest["kind"] != "language-quality" {
    throw("[synthetic-package:self-check] wrong package kind: " + manifest["kind"]);
}
log("synthetic package self-check: OK");
