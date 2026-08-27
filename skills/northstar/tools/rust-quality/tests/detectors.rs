use serde_json::Value;
use std::collections::BTreeSet;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::{Command, Output};
use std::sync::Mutex;
use std::sync::atomic::{AtomicU64, Ordering};

static NEXT_ID: AtomicU64 = AtomicU64::new(0);
static TEST_LOCK: Mutex<()> = Mutex::new(());

struct TargetDir(PathBuf);

impl TargetDir {
    fn new(label: &str, toolchain: &str) -> Self {
        let id = NEXT_ID.fetch_add(1, Ordering::Relaxed);
        let path = std::env::temp_dir().join(format!(
            "northstar-rust-detectors-{label}-{toolchain}-{}-{id}",
            std::process::id()
        ));
        fs::create_dir_all(&path).expect("create detector target");
        Self(path)
    }
}

impl Drop for TargetDir {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.0);
    }
}

#[test]
fn qualifies_precise_upstream_diagnostics_on_supported_toolchains() {
    let _guard = TEST_LOCK.lock().expect("detector test lock");
    let expected = BTreeSet::from([
        "clippy::await_holding_lock",
        "clippy::await_holding_refcell_ref",
        "clippy::incompatible_msrv",
        "clippy::missing_errors_doc",
        "clippy::missing_panics_doc",
        "clippy::missing_safety_doc",
        "clippy::undocumented_unsafe_blocks",
        "missing_debug_implementations",
        "E0133",
    ])
    .into_iter()
    .map(str::to_owned)
    .collect::<BTreeSet<_>>();
    for toolchain in ["1.95.0", "1.97.1"] {
        let output = clippy("invalid", toolchain);
        assert!(
            output.status.success(),
            "invalid fixture failed: {}",
            stderr(&output)
        );
        let actual = diagnostic_ids(&output);
        assert!(
            expected.is_subset(&actual),
            "{toolchain} missing diagnostics: {:?}",
            expected.difference(&actual).collect::<Vec<_>>()
        );

        let valid = clippy("valid", toolchain);
        assert!(
            valid.status.success(),
            "valid fixture failed: {}",
            stderr(&valid)
        );
        let unexpected = diagnostic_ids(&valid)
            .intersection(&expected)
            .cloned()
            .collect::<Vec<_>>();
        assert!(
            unexpected.is_empty(),
            "{toolchain} valid fixture warned: {unexpected:?}"
        );

        let invalid_docs = docs("invalid", toolchain);
        assert!(
            invalid_docs.status.success(),
            "invalid docs fixture failed: {}",
            stderr(&invalid_docs)
        );
        assert!(
            diagnostic_ids(&invalid_docs).contains("rustdoc::broken_intra_doc_links"),
            "{toolchain} did not emit broken link diagnostic"
        );
        let valid_docs = docs("valid", toolchain);
        assert!(
            valid_docs.status.success(),
            "valid docs fixture failed: {}",
            stderr(&valid_docs)
        );
        assert!(
            !diagnostic_ids(&valid_docs).contains("rustdoc::broken_intra_doc_links"),
            "{toolchain} emitted broken link diagnostic for valid docs"
        );
    }
}

#[test]
fn proves_contextual_lints_are_candidates_not_verdicts() {
    let _guard = TEST_LOCK.lock().expect("detector test lock");
    let contextual = BTreeSet::from([
        "clippy::cognitive_complexity",
        "clippy::expect_used",
        "clippy::indexing_slicing",
        "clippy::too_many_lines",
        "clippy::type_complexity",
        "clippy::unwrap_used",
    ])
    .into_iter()
    .map(str::to_owned)
    .collect::<BTreeSet<_>>();
    for toolchain in ["1.95.0", "1.97.1"] {
        let output = clippy("exceptions", toolchain);
        assert!(
            output.status.success(),
            "exception fixture failed: {}",
            stderr(&output)
        );
        let actual = diagnostic_ids(&output);
        assert!(
            contextual.is_subset(&actual),
            "{toolchain} missing contextual leads: {:?}",
            contextual.difference(&actual).collect::<Vec<_>>()
        );
    }
}

fn clippy(fixture: &str, toolchain: &str) -> Output {
    let manifest = fixture_root(fixture).join("Cargo.toml");
    let target = TargetDir::new(fixture, toolchain);
    Command::new("rustup")
        .args(["run", toolchain, "cargo", "clippy", "--all-targets"])
        .args(["--message-format=json"])
        .args(["--manifest-path"])
        .arg(manifest)
        .env("CARGO_TARGET_DIR", &target.0)
        .output()
        .expect("run detector fixture")
}

fn docs(fixture: &str, toolchain: &str) -> Output {
    let manifest = fixture_root(fixture).join("Cargo.toml");
    let target = TargetDir::new(fixture, toolchain);
    Command::new("rustup")
        .args(["run", toolchain, "cargo", "doc", "--no-deps"])
        .args(["--message-format=json"])
        .args(["--manifest-path"])
        .arg(manifest)
        .env("CARGO_TARGET_DIR", &target.0)
        .output()
        .expect("run documentation detector fixture")
}

fn diagnostic_ids(output: &Output) -> BTreeSet<String> {
    String::from_utf8_lossy(&output.stdout)
        .lines()
        .filter_map(|line| serde_json::from_str::<Value>(line).ok())
        .filter(|value| value["reason"] == "compiler-message")
        .filter_map(|value| value["message"]["code"]["code"].as_str().map(str::to_owned))
        .collect()
}

fn fixture_root(fixture: &str) -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("tests/fixtures/detectors")
        .join(fixture)
}

fn stderr(output: &Output) -> String {
    String::from_utf8_lossy(&output.stderr).into_owned()
}
