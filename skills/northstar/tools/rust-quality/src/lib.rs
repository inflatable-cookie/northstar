use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::{BTreeMap, BTreeSet};
use std::ffi::OsStr;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

mod evidence;
mod ledger;
mod lifecycle;
mod plan;

pub use evidence::{Closeout, CollectionReceipt, EvidencePlan, closeout, collect};

pub use ledger::{Assessment, AssessmentInput, StrictProjection, validate_assessment};
pub use lifecycle::{
    CompletionInput, ExtensionInput, assess_unit, collect_audit_evidence, complete_unit,
    extend_unit, finalize_audit, initialize_audit,
};
pub use plan::{ScopePlan, ScopePlanInput, build_scope_plan};

pub const SCHEMA_VERSION: &str = "northstar.rust-quality.discovery.v1";
pub const PAYLOAD_SHA256: &str = env!("NORTHSTAR_RUST_QUALITY_PAYLOAD_SHA256");

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum Scope {
    Worktree,
    Repository,
}

impl Scope {
    /// Parses a supported audit scope.
    ///
    /// # Errors
    ///
    /// Returns an error when `value` is neither `worktree` nor `repository`.
    pub fn parse(value: &str) -> Result<Self, String> {
        match value {
            "worktree" => Ok(Self::Worktree),
            "repository" => Ok(Self::Repository),
            _ => Err(format!("unsupported scope `{value}`")),
        }
    }
}

#[derive(Debug, Deserialize, Serialize)]
pub struct DiscoveryRecord {
    pub schema_version: String,
    pub tool_version: String,
    pub repository_root: String,
    pub scope: Scope,
    pub cargo_version: String,
    pub dirty_files: Vec<DirtyFile>,
    pub rust_anchors: Vec<RustAnchor>,
    pub workspaces: Vec<CargoWorkspace>,
    pub snapshot_sha256: String,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct DirtyFile {
    pub path: String,
    pub status: String,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct RustAnchor {
    pub path: String,
    pub kind: String,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct CargoWorkspace {
    pub root: String,
    pub manifest_path: String,
    pub packages: Vec<CargoPackage>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct CargoPackage {
    pub name: String,
    pub manifest_path: String,
    pub rust_version: Option<String>,
    pub features: Vec<String>,
    pub targets: Vec<CargoTarget>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct CargoTarget {
    pub name: String,
    pub kinds: Vec<String>,
    pub source_path: String,
}

#[derive(Debug, Serialize)]
pub struct InstallReceipt {
    pub schema_version: &'static str,
    pub tool_version: &'static str,
    pub embedded_payload_sha256: &'static str,
    pub source_payload_sha256: String,
    pub source_root: String,
    pub binary_path: String,
    pub current: bool,
}

#[derive(Debug, Deserialize)]
struct Metadata {
    packages: Vec<MetadataPackage>,
    workspace_members: Vec<String>,
    workspace_root: String,
}

#[derive(Debug, Deserialize)]
struct MetadataPackage {
    id: String,
    name: String,
    manifest_path: String,
    rust_version: Option<String>,
    features: BTreeMap<String, Vec<String>>,
    targets: Vec<MetadataTarget>,
}

#[derive(Debug, Deserialize)]
struct MetadataTarget {
    name: String,
    kind: Vec<String>,
    src_path: String,
}

/// Discovers Git scope and Cargo workspaces beneath a repository root.
///
/// # Errors
///
/// Returns a structured error string when Git or Cargo cannot be inspected, a
/// worktree has no dirty Rust anchor, or no Cargo manifest is present.
pub fn inspect(repository: &Path, scope: Scope) -> Result<DiscoveryRecord, String> {
    let repository_root = git_root(repository)?;
    let dirty_files = git_status(&repository_root)?;
    let rust_anchors = anchors(&dirty_files);
    if scope == Scope::Worktree && rust_anchors.is_empty() {
        return Err("scope.no_worktree_anchor: no dirty Rust anchor found".to_owned());
    }

    let manifests = discover_manifests(&repository_root)?;
    if manifests.is_empty() {
        return Err("cargo.no_manifest: no Cargo.toml found beneath repository root".to_owned());
    }
    let workspaces = inspect_workspaces(&repository_root, &manifests)?;
    let cargo_version = command_text(Command::new(cargo()).arg("--version"), "cargo.version")?;

    let mut record = DiscoveryRecord {
        schema_version: SCHEMA_VERSION.to_owned(),
        tool_version: env!("CARGO_PKG_VERSION").to_owned(),
        repository_root: slash(&repository_root),
        scope,
        cargo_version,
        dirty_files,
        rust_anchors,
        workspaces,
        snapshot_sha256: String::new(),
    };
    let canonical = serde_json::to_vec(&record).map_err(|error| error.to_string())?;
    record.snapshot_sha256 = format!("{:x}", Sha256::digest(canonical));
    Ok(record)
}

/// Compares the binary's embedded payload hash with a skill source tree.
///
/// # Errors
///
/// Returns an error when the payload cannot be enumerated or read.
pub fn install_receipt(source_root: &Path) -> Result<InstallReceipt, String> {
    let source_root =
        fs::canonicalize(source_root).map_err(|error| format!("install.source_root: {error}"))?;
    let source_payload_sha256 = source_payload_digest(&source_root)?;
    let binary_path =
        std::env::current_exe().map_err(|error| format!("install.binary: {error}"))?;
    Ok(InstallReceipt {
        schema_version: "northstar.rust-quality.install.v1",
        tool_version: env!("CARGO_PKG_VERSION"),
        embedded_payload_sha256: PAYLOAD_SHA256,
        current: source_payload_sha256 == PAYLOAD_SHA256,
        source_payload_sha256,
        source_root: slash(&source_root),
        binary_path: slash(&binary_path),
    })
}

fn cargo() -> String {
    std::env::var("CARGO").unwrap_or_else(|_| "cargo".to_owned())
}

fn git_root(repository: &Path) -> Result<PathBuf, String> {
    let output = command_text(
        Command::new("git")
            .arg("-C")
            .arg(repository)
            .args(["rev-parse", "--show-toplevel"]),
        "git.root",
    )?;
    fs::canonicalize(output).map_err(|error| format!("git.root: {error}"))
}

fn git_status(repository_root: &Path) -> Result<Vec<DirtyFile>, String> {
    let output = Command::new("git")
        .arg("-C")
        .arg(repository_root)
        .args(["status", "--porcelain=v1", "-z", "--untracked-files=all"])
        .output()
        .map_err(|error| format!("git.status.startup: {error}"))?;
    if !output.status.success() {
        return Err(format!(
            "git.status.failed: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        ));
    }

    let fields = output
        .stdout
        .split(|byte| *byte == 0)
        .filter(|field| !field.is_empty());
    let mut dirty = Vec::new();
    let mut skip_rename_source = false;
    for field in fields {
        if skip_rename_source {
            skip_rename_source = false;
            continue;
        }
        if field.len() < 4 || field[2] != b' ' {
            return Err("git.status.parse: invalid porcelain record".to_owned());
        }
        let status = String::from_utf8_lossy(&field[..2]).into_owned();
        let path = String::from_utf8_lossy(&field[3..]).into_owned();
        skip_rename_source = status.contains('R') || status.contains('C');
        dirty.push(DirtyFile { path, status });
    }
    dirty.sort_by(|left, right| left.path.cmp(&right.path));
    Ok(dirty)
}

fn anchors(dirty_files: &[DirtyFile]) -> Vec<RustAnchor> {
    dirty_files
        .iter()
        .filter_map(|file| {
            anchor_kind(Path::new(&file.path)).map(|kind| RustAnchor {
                path: file.path.clone(),
                kind: kind.to_owned(),
            })
        })
        .collect()
}

fn anchor_kind(path: &Path) -> Option<&'static str> {
    let name = path.file_name()?.to_str()?;
    if path.extension() == Some(OsStr::new("rs")) {
        return Some("rust_source");
    }
    match name {
        "Cargo.toml" => Some("cargo_manifest"),
        "Cargo.lock" => Some("cargo_lock"),
        "rust-toolchain" | "rust-toolchain.toml" => Some("rust_toolchain"),
        "rustfmt.toml" | ".rustfmt.toml" => Some("rustfmt_configuration"),
        "clippy.toml" | ".clippy.toml" => Some("clippy_configuration"),
        "config" | "config.toml"
            if path.parent().and_then(Path::file_name) == Some(OsStr::new(".cargo")) =>
        {
            Some("cargo_configuration")
        }
        _ => None,
    }
}

fn discover_manifests(repository_root: &Path) -> Result<Vec<PathBuf>, String> {
    let mut manifests = Vec::new();
    let mut pending = vec![repository_root.to_path_buf()];
    while let Some(directory) = pending.pop() {
        let mut entries = fs::read_dir(&directory)
            .map_err(|error| format!("cargo.scan {}: {error}", directory.display()))?
            .collect::<Result<Vec<_>, _>>()
            .map_err(|error| format!("cargo.scan {}: {error}", directory.display()))?;
        entries.sort_by_key(std::fs::DirEntry::file_name);
        for entry in entries.into_iter().rev() {
            let path = entry.path();
            let file_type = entry
                .file_type()
                .map_err(|error| format!("cargo.scan {}: {error}", path.display()))?;
            if file_type.is_symlink() {
                continue;
            }
            if file_type.is_dir() {
                if !ignored_directory(&entry.file_name()) {
                    pending.push(path);
                }
            } else if entry.file_name() == OsStr::new("Cargo.toml") {
                manifests.push(path);
            }
        }
    }
    manifests.sort();
    Ok(manifests)
}

fn source_payload_digest(root: &Path) -> Result<String, String> {
    let mut files = vec![
        root.join("Cargo.lock"),
        root.join("Cargo.toml"),
        root.join("build.rs"),
        root.join("assets/diagnostic-mapping.json"),
    ];
    collect_rust_sources(&root.join("src"), &mut files)?;
    files.sort();

    let mut digest = Sha256::new();
    for file in files {
        let relative = file
            .strip_prefix(root)
            .map_err(|error| format!("install.payload_path: {error}"))?;
        let relative = slash(relative);
        let contents = fs::read(&file)
            .map_err(|error| format!("install.payload_read {}: {error}", file.display()))?;
        digest.update(relative.len().to_le_bytes());
        digest.update(relative.as_bytes());
        digest.update(contents.len().to_le_bytes());
        digest.update(contents);
    }
    Ok(format!("{:x}", digest.finalize()))
}

fn collect_rust_sources(directory: &Path, files: &mut Vec<PathBuf>) -> Result<(), String> {
    let mut entries = fs::read_dir(directory)
        .map_err(|error| format!("install.payload_scan {}: {error}", directory.display()))?
        .collect::<Result<Vec<_>, _>>()
        .map_err(|error| format!("install.payload_scan {}: {error}", directory.display()))?;
    entries.sort_by_key(std::fs::DirEntry::file_name);
    for entry in entries {
        let path = entry.path();
        let file_type = entry
            .file_type()
            .map_err(|error| format!("install.payload_scan {}: {error}", path.display()))?;
        if file_type.is_dir() {
            collect_rust_sources(&path, files)?;
        } else if path.extension() == Some(OsStr::new("rs")) {
            files.push(path);
        }
    }
    Ok(())
}

fn ignored_directory(name: &OsStr) -> bool {
    matches!(
        name.to_str(),
        Some(".git" | ".effigy" | "node_modules" | "target")
    )
}

fn inspect_workspaces(
    repository_root: &Path,
    manifests: &[PathBuf],
) -> Result<Vec<CargoWorkspace>, String> {
    let mut by_root = BTreeMap::new();
    for manifest in manifests {
        let output = Command::new(cargo())
            .current_dir(repository_root)
            .args([
                "metadata",
                "--format-version",
                "1",
                "--no-deps",
                "--manifest-path",
            ])
            .arg(manifest)
            .output()
            .map_err(|error| format!("cargo.metadata.startup {}: {error}", manifest.display()))?;
        if !output.status.success() {
            return Err(format!(
                "cargo.metadata.failed {}: {}",
                manifest.display(),
                String::from_utf8_lossy(&output.stderr).trim()
            ));
        }
        let metadata: Metadata = serde_json::from_slice(&output.stdout)
            .map_err(|error| format!("cargo.metadata.parse {}: {error}", manifest.display()))?;
        by_root
            .entry(metadata.workspace_root.clone())
            .or_insert(metadata);
    }

    by_root
        .into_values()
        .map(|metadata| workspace_from_metadata(repository_root, metadata))
        .collect()
}

fn workspace_from_metadata(
    repository_root: &Path,
    metadata: Metadata,
) -> Result<CargoWorkspace, String> {
    let members: BTreeSet<_> = metadata.workspace_members.into_iter().collect();
    let mut packages = metadata
        .packages
        .into_iter()
        .filter(|package| members.contains(&package.id))
        .map(|package| {
            Ok(CargoPackage {
                name: package.name,
                manifest_path: repository_relative(
                    repository_root,
                    Path::new(&package.manifest_path),
                )?,
                rust_version: package.rust_version,
                features: package.features.into_keys().collect(),
                targets: package
                    .targets
                    .into_iter()
                    .map(|target| {
                        Ok(CargoTarget {
                            name: target.name,
                            kinds: target.kind,
                            source_path: repository_relative(
                                repository_root,
                                Path::new(&target.src_path),
                            )?,
                        })
                    })
                    .collect::<Result<Vec<_>, String>>()?,
            })
        })
        .collect::<Result<Vec<_>, String>>()?;
    packages.sort_by(|left, right| left.manifest_path.cmp(&right.manifest_path));
    let root = PathBuf::from(metadata.workspace_root);
    Ok(CargoWorkspace {
        manifest_path: repository_relative(repository_root, &root.join("Cargo.toml"))?,
        root: repository_relative(repository_root, &root)?,
        packages,
    })
}

fn command_text(command: &mut Command, code: &str) -> Result<String, String> {
    let output = command
        .output()
        .map_err(|error| format!("{code}.startup: {error}"))?;
    if !output.status.success() {
        return Err(format!(
            "{code}.failed: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        ));
    }
    Ok(String::from_utf8_lossy(&output.stdout).trim().to_owned())
}

fn slash(path: &Path) -> String {
    path.to_string_lossy().replace('\\', "/")
}

fn repository_relative(repository_root: &Path, path: &Path) -> Result<String, String> {
    let relative = path.strip_prefix(repository_root).map_err(|_| {
        format!(
            "cargo.path_outside_repository: {} is outside {}",
            path.display(),
            repository_root.display()
        )
    })?;
    let value = slash(relative);
    Ok(if value.is_empty() {
        ".".to_owned()
    } else {
        value
    })
}
