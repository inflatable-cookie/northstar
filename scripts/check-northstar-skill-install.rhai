if args.len() != 1 {
    throw("usage: effigy check:skill-install <installed-northstar-path>");
}

let source_root = path::join(repo_root, "skills/northstar");
let target_root = path::join(repo_root, args[0]);

if !fs::is_dir(source_root) {
    throw("Northstar source skill directory not found: " + source_root);
}
if !fs::is_dir(target_root) {
    throw("installed Northstar skill directory not found: " + target_root);
}

let source_prefix = source_root + "/";
let target_prefix = target_root + "/";
let source_files = [];
let target_files = [];
let source_digests = #{};
let target_digests = #{};

for file in fs::list_recursive(source_root) {
    let relative = str::replace(file, source_prefix, "");
    source_files.push(relative);
    source_digests[relative] = fs::sha256(file);
}

for file in fs::list_recursive(target_root) {
    let relative = str::replace(file, target_prefix, "");
    target_files.push(relative);
    target_digests[relative] = fs::sha256(file);
}

source_files.sort();
target_files.sort();

let problems = [];
for relative in source_files {
    if !target_files.contains(relative) {
        problems.push("missing: " + relative);
    } else if source_digests[relative] != target_digests[relative] {
        problems.push("differing: " + relative);
    }
}
for relative in target_files {
    if !source_files.contains(relative) {
        problems.push("unexpected: " + relative);
    }
}

if problems.len() > 0 {
    let message = "";
    for problem in problems {
        if message != "" {
            message += ", ";
        }
        message += problem;
    }
    throw(message);
}

log("Northstar skill install parity: OK (" + source_files.len() + " files)");
