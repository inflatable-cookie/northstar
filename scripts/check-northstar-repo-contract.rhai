import "scripts/lib/northstar-repo-contract-data.rhai" as contract;

fn check_ok(report, message) {
    if !report["ok"] {
        throw(message);
    }
}

fn check_portable_links(portable_root, markdown_file) {
    let text = fs::read_file(markdown_file);
    let remaining = text;
    let link_pattern = "^(?:.*?)\\]\\(([^)]+)\\)(?:.*)$";
    let remove_first_link_pattern = "^(.*?)\\]\\([^)]+\\)(.*)$";

    while regex::is_match(link_pattern, remaining) {
        let raw_target = regex::replace(link_pattern, remaining, "$1");
        let target = str::trim(raw_target);
        let target = regex::replace("^<([^>]+)>.*$", target, "$1");
        let target = regex::replace("^([^[:space:]]+).*$", target, "$1");

        if target != "" && !regex::is_match("^(?:[a-z][a-z0-9+.-]*:|#|//)", target) {
            let file_target = regex::replace("[?#].*$", target, "");
            let resolved_target = path::join(path::parent(markdown_file), file_target);
            let portable_prefix = portable_root + "/";
            if resolved_target != portable_root && !str::starts_with(resolved_target, portable_prefix) {
                let message = "non-portable Markdown link in ";
                message += markdown_file;
                message += ": ";
                message += target;
                throw(message);
            }
        }

        remaining = regex::replace(remove_first_link_pattern, remaining, "$1$2");
    }
}

let required_files = contract::required_files();
let path_report = docs::check_paths(#{ paths: required_files });
check_ok(path_report, "missing required Northstar repo contract path");

let portable_root = path::join(repo_root, "skills/northstar");
let markdown_files = [];
for file in fs::list_recursive(portable_root) {
    if str::ends_with(file, ".md") {
        markdown_files.push(file);
        check_portable_links(portable_root, file);
    }
}

let link_report = docs::check_links(#{ paths: markdown_files });
check_ok(link_report, "broken Markdown link in skills/northstar");

for assertion in contract::required_content() {
    let file = assertion[0];
    let pattern = assertion[1];
    let description = assertion[2];
    let report = docs::check_contains(#{ paths: [file], required: [pattern] });
    if !report["ok"] {
        throw("missing " + description + " in " + file + ": " + pattern);
    }
}

for assertion in contract::forbidden_content() {
    let file = assertion[0];
    let pattern = assertion[1];
    let description = assertion[2];
    let report = docs::check_forbidden(#{ paths: [file], forbidden: [pattern] });
    if !report["ok"] {
        throw("forbidden " + description + " in " + file + ": " + pattern);
    }
}

log("Northstar repo contract checks: OK");
