// Policy-free fixture package self-check entrypoint
let manifest_path = path::join(repo_root, "skills/northstar/assets/fixtures/language-packages/policy-free-fixture/northstar-package.json");
if !fs::is_file(manifest_path) {
    throw("[fixture-package:self-check] missing manifest: " + manifest_path);
}
let manifest = json::read_file(manifest_path);
if manifest["kind"] != "language-quality" {
    throw("[fixture-package:self-check] wrong package kind: " + manifest["kind"]);
}
log("fixture package self-check: OK");
