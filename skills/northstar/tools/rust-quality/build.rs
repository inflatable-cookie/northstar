use sha2::{Digest, Sha256};
use std::fs;
use std::path::{Path, PathBuf};

fn main() {
    let root = PathBuf::from(std::env::var("CARGO_MANIFEST_DIR").expect("manifest directory"));
    let files = payload_files(&root).expect("enumerate Rust quality payload");
    for file in &files {
        println!("cargo:rerun-if-changed={}", file.display());
    }
    let digest = payload_digest(&root, &files).expect("hash Rust quality payload");
    println!("cargo:rustc-env=NORTHSTAR_RUST_QUALITY_PAYLOAD_SHA256={digest}");
}

fn payload_files(root: &Path) -> Result<Vec<PathBuf>, std::io::Error> {
    let mut files = vec![
        root.join("Cargo.lock"),
        root.join("Cargo.toml"),
        root.join("build.rs"),
        root.join("assets/diagnostic-mapping.json"),
    ];
    collect_rs(&root.join("src"), &mut files)?;
    files.sort();
    Ok(files)
}

fn collect_rs(directory: &Path, files: &mut Vec<PathBuf>) -> Result<(), std::io::Error> {
    let mut entries = fs::read_dir(directory)?.collect::<Result<Vec<_>, _>>()?;
    entries.sort_by_key(std::fs::DirEntry::file_name);
    for entry in entries {
        let path = entry.path();
        if entry.file_type()?.is_dir() {
            collect_rs(&path, files)?;
        } else if path.extension().and_then(|value| value.to_str()) == Some("rs") {
            files.push(path);
        }
    }
    Ok(())
}

fn payload_digest(root: &Path, files: &[PathBuf]) -> Result<String, std::io::Error> {
    let mut digest = Sha256::new();
    for file in files {
        let relative = file.strip_prefix(root).expect("payload file beneath root");
        let relative = relative.to_string_lossy().replace('\\', "/");
        let contents = fs::read(file)?;
        digest.update(relative.len().to_le_bytes());
        digest.update(relative.as_bytes());
        digest.update(contents.len().to_le_bytes());
        digest.update(contents);
    }
    Ok(format!("{:x}", digest.finalize()))
}
