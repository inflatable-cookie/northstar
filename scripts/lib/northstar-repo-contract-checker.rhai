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

fn check_required_paths(repo_root, required_files) {
    for file in required_files {
        let full_path = path::join(repo_root, file);
        if !fs::is_file(full_path) {
            throw("missing required Northstar repo contract path: " + file);
        }
    }
}

fn check_links(markdown_files) {
    try {
        let link_report = docs::check_links(#{ paths: markdown_files });
        check_ok(link_report, "broken Markdown link in skills/northstar");
    } catch (error) {
        let message = "broken Markdown link in skills/northstar: ";
        message += error.to_string();
        throw(message);
    }
}

fn check(repo_root, required_files, identical_file_pairs) {
    check_required_paths(repo_root, required_files);

    let portable_root = path::join(repo_root, "skills/northstar");
    let markdown_files = [];
    for file in fs::list_recursive(portable_root) {
        if str::ends_with(file, ".md") {
            markdown_files.push(file);
            check_portable_links(portable_root, file);
        }
    }

    check_links(markdown_files);

    for pair in identical_file_pairs {
        let canonical = path::join(repo_root, pair[0]);
        let mirror = path::join(repo_root, pair[1]);
        let description = pair[2];
        if fs::sha256(canonical) != fs::sha256(mirror) {
            let message = description;
            message += ": ";
            message += pair[0];
            message += " != ";
            message += pair[1];
            throw(message);
        }
    }
}
