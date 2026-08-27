use northstar_rust_quality::{
    AssessmentInput, CompletionInput, DiscoveryRecord, EvidencePlan, ExtensionInput, Scope,
    ScopePlan, ScopePlanInput, StrictProjection, assess_unit, build_scope_plan,
    collect_audit_evidence, complete_unit, extend_unit, finalize_audit, initialize_audit, inspect,
    install_receipt, validate_assessment,
};
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::PathBuf;
use std::process::Command;

#[derive(Serialize)]
struct ErrorRecord<'a> {
    schema_version: &'static str,
    error: &'a str,
}

#[derive(Deserialize)]
struct CloseoutInput {
    applicable_rules: Vec<String>,
    evidence_plan: EvidencePlan,
}

fn main() {
    if let Err(error) = run() {
        let record = ErrorRecord {
            schema_version: "northstar.rust-quality.error.v1",
            error: &error,
        };
        eprintln!(
            "{}",
            serde_json::to_string_pretty(&record).expect("error record serializes")
        );
        std::process::exit(2);
    }
}

fn run() -> Result<(), String> {
    let mut arguments = std::env::args().skip(1);
    let operation = arguments.next().ok_or_else(usage)?;
    if operation == "--version" || operation == "version" {
        println!("northstar-rust-quality {}", env!("CARGO_PKG_VERSION"));
        return Ok(());
    }
    if operation == "verify-install" {
        return verify_install(arguments);
    }
    if operation == "plan" {
        return plan(arguments);
    }
    if operation == "validate-ledger" {
        return validate_ledger(arguments);
    }
    if operation == "init" {
        return init(arguments);
    }
    if matches!(operation.as_str(), "assess" | "extend" | "complete") {
        return update_unit(&operation, arguments);
    }
    if operation == "finalize" {
        return finalize(arguments);
    }
    if operation == "collect" {
        return collect(arguments);
    }
    if operation == "closeout" {
        return closeout(arguments);
    }
    if operation != "inspect" {
        return Err(usage());
    }

    let mut repository = None;
    let mut scope = None;
    let mut output = None;
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--repo" => repository = arguments.next().map(PathBuf::from),
            "--scope" => scope = arguments.next(),
            "--output" => output = arguments.next().map(PathBuf::from),
            _ => return Err(format!("unknown argument `{argument}`\n{}", usage())),
        }
    }

    let repository = repository.ok_or_else(|| "missing --repo".to_owned())?;
    let scope = Scope::parse(
        scope
            .as_deref()
            .ok_or_else(|| "missing --scope".to_owned())?,
    )?;
    let record = inspect(&repository, scope)?;
    let json = serde_json::to_string_pretty(&record).map_err(|error| error.to_string())?;
    if let Some(path) = output {
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).map_err(|error| error.to_string())?;
        }
        fs::write(path, format!("{json}\n")).map_err(|error| error.to_string())?;
    } else {
        println!("{json}");
    }
    Ok(())
}

fn init(mut arguments: impl Iterator<Item = String>) -> Result<(), String> {
    let mut repository = None;
    let mut discovery_path = None;
    let mut plan_path = None;
    let mut rules_path = None;
    let mut profile_path = None;
    let mut deviations_path = None;
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--repo" => repository = arguments.next().map(PathBuf::from),
            "--discovery" => discovery_path = arguments.next().map(PathBuf::from),
            "--plan" => plan_path = arguments.next().map(PathBuf::from),
            "--rules" => rules_path = arguments.next().map(PathBuf::from),
            "--profile" => profile_path = arguments.next().map(PathBuf::from),
            "--deviations" => deviations_path = arguments.next().map(PathBuf::from),
            _ => return Err(format!("unknown argument `{argument}`\n{}", usage())),
        }
    }
    let repository = repository.ok_or_else(|| "missing --repo".to_owned())?;
    let discovery: DiscoveryRecord =
        read_json(&discovery_path.ok_or_else(|| "missing --discovery".to_owned())?)?;
    let plan: ScopePlan = read_json(&plan_path.ok_or_else(|| "missing --plan".to_owned())?)?;
    let rules_path = rules_path.ok_or_else(|| "missing --rules".to_owned())?;
    let profile_path = profile_path.ok_or_else(|| "missing --profile".to_owned())?;
    let deviations_path = deviations_path.ok_or_else(|| "missing --deviations".to_owned())?;
    write_json(
        &initialize_audit(
            &repository,
            &discovery,
            &plan,
            &rules_path,
            &profile_path,
            &deviations_path,
        )?,
        None,
    )
}

fn update_unit(operation: &str, mut arguments: impl Iterator<Item = String>) -> Result<(), String> {
    let mut repository = None;
    let mut audit_id = None;
    let mut input_path = None;
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--repo" => repository = arguments.next().map(PathBuf::from),
            "--audit" => audit_id = arguments.next(),
            "--input" => input_path = arguments.next().map(PathBuf::from),
            _ => return Err(format!("unknown argument `{argument}`\n{}", usage())),
        }
    }
    let repository = repository.ok_or_else(|| "missing --repo".to_owned())?;
    let audit_id = audit_id.ok_or_else(|| "missing --audit".to_owned())?;
    let input_path = input_path.ok_or_else(|| "missing --input".to_owned())?;
    match operation {
        "assess" => write_json(
            &assess_unit(&repository, &audit_id, read_json(&input_path)?)?,
            None,
        ),
        "extend" => write_json(
            &extend_unit(
                &repository,
                &audit_id,
                read_json::<ExtensionInput>(&input_path)?,
            )?,
            None,
        ),
        "complete" => {
            let input: CompletionInput = read_json(&input_path)?;
            write_json(&complete_unit(&repository, &audit_id, &input)?, None)
        }
        _ => Err(usage()),
    }
}

fn finalize(mut arguments: impl Iterator<Item = String>) -> Result<(), String> {
    let mut repository = None;
    let mut audit_id = None;
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--repo" => repository = arguments.next().map(PathBuf::from),
            "--audit" => audit_id = arguments.next(),
            _ => return Err(format!("unknown argument `{argument}`\n{}", usage())),
        }
    }
    let repository = repository.ok_or_else(|| "missing --repo".to_owned())?;
    let audit_id = audit_id.ok_or_else(|| "missing --audit".to_owned())?;
    write_json(&finalize_audit(&repository, &audit_id)?, None)
}

fn collect(mut arguments: impl Iterator<Item = String>) -> Result<(), String> {
    let mut repository = None;
    let mut audit_id = None;
    let mut input_path = None;
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--repo" => repository = arguments.next().map(PathBuf::from),
            "--audit" => audit_id = arguments.next(),
            "--input" => input_path = arguments.next().map(PathBuf::from),
            _ => return Err(format!("unknown argument `{argument}`\n{}", usage())),
        }
    }
    let repository = repository.ok_or_else(|| "missing --repo".to_owned())?;
    let audit_id = audit_id.ok_or_else(|| "missing --audit".to_owned())?;
    let input: EvidencePlan = read_json(&input_path.ok_or_else(|| "missing --input".to_owned())?)?;
    write_json(
        &collect_audit_evidence(&repository, &audit_id, input)?,
        None,
    )
}

fn closeout(mut arguments: impl Iterator<Item = String>) -> Result<(), String> {
    let mut repository = None;
    let mut input_path = None;
    let mut output_path = None;
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--repo" => repository = arguments.next().map(PathBuf::from),
            "--input" => input_path = arguments.next().map(PathBuf::from),
            "--output" => output_path = arguments.next().map(PathBuf::from),
            _ => return Err(format!("unknown argument `{argument}`\n{}", usage())),
        }
    }
    let repository = repository.ok_or_else(|| "missing --repo".to_owned())?;
    let input: CloseoutInput = read_json(&input_path.ok_or_else(|| "missing --input".to_owned())?)?;
    let artifact_root = git_metadata_path(&repository, "northstar/rust-quality/closeouts")?;
    let record = northstar_rust_quality::closeout(
        &repository,
        input.applicable_rules,
        input.evidence_plan,
        &artifact_root,
    )?;
    write_json(&record, output_path.as_deref())
}

fn git_metadata_path(repository: &std::path::Path, relative: &str) -> Result<PathBuf, String> {
    let output = Command::new("git")
        .arg("-C")
        .arg(repository)
        .args(["rev-parse", "--git-path", relative])
        .output()
        .map_err(|error| format!("git metadata startup: {error}"))?;
    if !output.status.success() {
        return Err(format!(
            "git metadata failed: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        ));
    }
    let path = PathBuf::from(String::from_utf8_lossy(&output.stdout).trim());
    if path.is_absolute() {
        Ok(path)
    } else {
        Ok(repository.join(path))
    }
}

fn validate_ledger(mut arguments: impl Iterator<Item = String>) -> Result<(), String> {
    let mut rules_path = None;
    let mut input_path = None;
    let mut output_path = None;
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--rules" => rules_path = arguments.next().map(PathBuf::from),
            "--input" => input_path = arguments.next().map(PathBuf::from),
            "--output" => output_path = arguments.next().map(PathBuf::from),
            _ => return Err(format!("unknown argument `{argument}`\n{}", usage())),
        }
    }
    let rules_path = rules_path.ok_or_else(|| "missing --rules".to_owned())?;
    let input_path = input_path.ok_or_else(|| "missing --input".to_owned())?;
    let projection: StrictProjection = read_json(&rules_path)?;
    let input: AssessmentInput = read_json(&input_path)?;
    let assessment = validate_assessment(&projection, input)?;
    write_json(&assessment, output_path.as_deref())
}

fn plan(mut arguments: impl Iterator<Item = String>) -> Result<(), String> {
    let mut discovery_path = None;
    let mut input_path = None;
    let mut output_path = None;
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--discovery" => discovery_path = arguments.next().map(PathBuf::from),
            "--input" => input_path = arguments.next().map(PathBuf::from),
            "--output" => output_path = arguments.next().map(PathBuf::from),
            _ => return Err(format!("unknown argument `{argument}`\n{}", usage())),
        }
    }
    let discovery_path = discovery_path.ok_or_else(|| "missing --discovery".to_owned())?;
    let input_path = input_path.ok_or_else(|| "missing --input".to_owned())?;
    let discovery: DiscoveryRecord = read_json(&discovery_path)?;
    let input: ScopePlanInput = read_json(&input_path)?;
    let plan = build_scope_plan(&discovery, input)?;
    write_json(&plan, output_path.as_deref())
}

fn verify_install(mut arguments: impl Iterator<Item = String>) -> Result<(), String> {
    let mut source_root = None;
    let mut receipt_path = None;
    while let Some(argument) = arguments.next() {
        match argument.as_str() {
            "--source-root" => source_root = arguments.next().map(PathBuf::from),
            "--receipt" => receipt_path = arguments.next().map(PathBuf::from),
            _ => return Err(format!("unknown argument `{argument}`\n{}", usage())),
        }
    }
    let source_root = source_root.ok_or_else(|| "missing --source-root".to_owned())?;
    let receipt = install_receipt(&source_root)?;
    let current = receipt.current;
    let json = serde_json::to_string_pretty(&receipt).map_err(|error| error.to_string())?;
    if let Some(path) = receipt_path {
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).map_err(|error| error.to_string())?;
        }
        fs::write(path, format!("{json}\n")).map_err(|error| error.to_string())?;
    } else {
        println!("{json}");
    }
    if current {
        Ok(())
    } else {
        Err("install.payload_mismatch: installed binary does not match skill source".to_owned())
    }
}

fn usage() -> String {
    "usage: northstar-rust-quality inspect --repo <path> --scope <worktree|repository> [--output <path>] | plan --discovery <record.json> --input <plan-input.json> [--output <plan.json>] | validate-ledger --rules <strict-audit.json> --input <assessment.json> [--output <assessment.json>] | init --repo <path> --discovery <record.json> --plan <plan.json> --rules <strict-audit.json> --profile <rust-quality-profile.json> --deviations <rust-quality-deviations.json> | collect --repo <path> --audit <id> --input <evidence-plan.json> | <assess|extend|complete> --repo <path> --audit <id> --input <record.json> | finalize --repo <path> --audit <id> | closeout --repo <path> --input <closeout.json> [--output <result.json>] | verify-install --source-root <crate-root> [--receipt <path>]".to_owned()
}

fn read_json<T: serde::de::DeserializeOwned>(path: &std::path::Path) -> Result<T, String> {
    let contents = fs::read(path).map_err(|error| format!("read {}: {error}", path.display()))?;
    serde_json::from_slice(&contents).map_err(|error| format!("parse {}: {error}", path.display()))
}

fn write_json<T: Serialize>(value: &T, output: Option<&std::path::Path>) -> Result<(), String> {
    let json = serde_json::to_string_pretty(value).map_err(|error| error.to_string())?;
    if let Some(path) = output {
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).map_err(|error| error.to_string())?;
        }
        fs::write(path, format!("{json}\n")).map_err(|error| error.to_string())?;
    } else {
        println!("{json}");
    }
    Ok(())
}
