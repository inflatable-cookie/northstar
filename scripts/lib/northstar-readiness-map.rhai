fn trim_quotes(value) {
    let result = str::trim(value);
    if regex::is_match("^\".*\"$", result) {
        result = regex::replace("^\"(.*)\"$", result, "$1");
    } else if regex::is_match("^'.*'$", result) {
        result = regex::replace("^'(.*)'$", result, "$1");
    }
    result
}

fn parse_inline_list(value) {
    let result = [];
    let trimmed = str::trim(value);
    if trimmed == "[]" {
        return result;
    }
    if !regex::is_match("^\\[.*\\]$", trimmed) {
        result.push(trim_quotes(trimmed));
        return result;
    }

    let inner = regex::replace("^\\[(.*)\\]$", trimmed, "$1");
    let items = str::split_lines(str::replace(inner, ",", "\n"));
    for item in items {
        let candidate = trim_quotes(str::trim(item));
        if candidate != "" {
            result.push(candidate);
        }
    }
    result
}

fn parse_document(file) {
    let result = #{ frontmatter: #{}, body: "", errors: [] };
    if !fs::is_file(file) {
        result["errors"].push("missing file: " + file);
        return result;
    }

    let lines = str::split_lines(fs::read_file(file));
    if lines.len() < 2 || lines[0] != "---" {
        result["errors"].push("missing YAML frontmatter in " + file);
        return result;
    }

    let closing = -1;
    for index in 1..lines.len() {
        if lines[index] == "---" {
            closing = index;
            break;
        }
    }
    if closing < 0 {
        result["errors"].push("unterminated YAML frontmatter in " + file);
        return result;
    }

    for index in 1..closing {
        let line = str::trim(lines[index]);
        if line == "" {
            continue;
        }
        if !regex::is_match("^[A-Za-z0-9_-]+:", line) {
            result["errors"].push("invalid frontmatter line in " + file + ": " + line);
            continue;
        }
        let key = regex::replace("^([^:]+):.*$", line, "$1");
        let raw_value = regex::replace("^[^:]+:\\s*(.*)$", line, "$1");
        if result["frontmatter"].contains(key) {
            result["errors"].push("duplicate frontmatter field in " + file + ": " + key);
            continue;
        }
        if key == "blocked_by" {
            result["frontmatter"][key] = parse_inline_list(raw_value);
        } else {
            result["frontmatter"][key] = trim_quotes(raw_value);
        }
    }

    let body = "";
    for index in (closing + 1)..lines.len() {
        body += lines[index];
        body += "\n";
    }
    result["body"] = body;
    result
}

fn required_fields(frontmatter, fields, context) {
    let errors = [];
    for field in fields {
        if !frontmatter.contains(field) {
            errors.push(context + ": missing frontmatter field '" + field + "'");
        }
    }
    errors
}

fn allowed_field(frontmatter, field, allowed, context) {
    let errors = [];
    if !frontmatter.contains(field) {
        return errors;
    }
    let value = frontmatter[field];
    if !has_array_item(allowed, value) {
        errors.push(context + ": invalid " + field + " '" + value + "'");
    }
    errors
}

fn valid_id(value) {
    regex::is_match("^[a-z0-9]+(?:-[a-z0-9]+)*$", value)
}

fn merge_arrays(first, second) {
    let result = [];
    for item in first {
        result.push(item);
    }
    for item in second {
        result.push(item);
    }
    result
}

fn has_map_key(map, key) {
    for existing_key in map.keys() {
        if existing_key == key {
            return true;
        }
    }
    false
}

fn has_array_item(items, value) {
    for item in items {
        if item == value {
            return true;
        }
    }
    false
}

fn duplicate_id_error(record_id) {
    let message = "duplicate decision id '";
    message += record_id;
    message += "'";
    message
}

fn detect_duplicate_ids(record_ids) {
    let sorted_ids = [];
    for record_id in record_ids {
        sorted_ids.push(record_id);
    }
    sorted_ids.sort();
    let errors = [];
    let previous = "";
    for record_id in sorted_ids {
        if record_id == previous {
            errors.push(duplicate_id_error(record_id));
        }
        previous = record_id;
    }
    errors
}

fn extract_links(text) {
    let links = [];
    let link_pattern = "^(?:.*?)\\]\\(([^)]+)\\)(?:.*)$";
    let remove_first_link_pattern = "^(.*?)\\]\\([^)]+\\)(.*)$";
    for line in str::split_lines(text) {
        let remaining = line;
        let has_link = regex::is_match(link_pattern, remaining);
        while has_link {
            let extracted = regex::replace(link_pattern, remaining, "$1");
            links.push(str::trim(extracted));
            remaining = regex::replace(remove_first_link_pattern, remaining, "$1$2");
            has_link = regex::is_match(link_pattern, remaining);
        }
    }
    links
}

fn is_external_link(target) {
    regex::is_match("^(?:[a-z][a-z0-9+.-]*:|#|//)", target)
}

fn canonical_prefix(repo_root, target) {
    let prefixes = [
        repo_root + "/docs/specs/",
        repo_root + "/docs/architecture/",
        repo_root + "/docs/contracts/",
        repo_root + "/docs/roadmaps/",
        repo_root + "/docs/logs/",
    ];
    for prefix in prefixes {
        if str::starts_with(target, prefix) {
            return true;
        }
    }
    false
}

fn inside(root, target) {
    target == root || str::starts_with(target, root + "/")
}

fn resolve_link(repo_root, destination_root, source_file, raw_target) {
    let target = trim_quotes(str::trim(raw_target));
    target = regex::replace("^<([^>]+)>.*$", target, "$1");
    target = regex::replace("[?#].*$", target, "");
    if target == "" {
        return "";
    }
    if str::starts_with(target, "docs/") {
        return path::join(repo_root, target);
    }
    path::join(path::parent(source_file), target)
}

fn validate_links(repo_root, destination_root, file, text) {
    let errors = [];
    for raw_target in extract_links(text) {
        if is_external_link(raw_target) {
            continue;
        }
        let resolved = resolve_link(repo_root, destination_root, file, raw_target);
        if resolved == "" {
            continue;
        }
        if !inside(destination_root, resolved) && !canonical_prefix(repo_root, resolved) {
            errors.push(file + ": link escapes readiness-map or canonical docs boundary: " + raw_target);
        } else if !fs::is_file(resolved) {
            errors.push(file + ": missing linked reference: " + raw_target);
        }
    }
    errors
}

fn resolve_frontmatter_reference(repo_root, destination_root, field, value) {
    if str::starts_with(value, "docs/") {
        return path::join(repo_root, value);
    }
    path::join(destination_root, value)
}

fn noncanonical_reference_error(map_file, field, value) {
    let message = map_file;
    message += ": ";
    message += field;
    message += " must target a canonical docs surface: ";
    message += value;
    message
}

fn missing_reference_error(map_file, field, value) {
    let message = map_file;
    message += ": missing ";
    message += field;
    message += " reference: ";
    message += value;
    message
}

fn validate_map_links(repo_root, destination_root, map_file, map_frontmatter) {
    let errors = [];
    for field in ["master_spec", "roadmap"] {
        if map_frontmatter.contains(field) {
            let value = map_frontmatter[field];
            let resolved = resolve_frontmatter_reference(repo_root, destination_root, field, value);
            let canonical = canonical_prefix(repo_root, resolved);
            if !canonical {
                let error = noncanonical_reference_error(map_file, field, value);
                errors.push(error);
                continue;
            }
            let present = fs::is_file(resolved);
            if !present {
                let error = missing_reference_error(map_file, field, value);
                errors.push(error);
            }
        }
    }
    errors
}

fn is_readiness_map_file(file) {
    if !fs::is_file(file) {
        return false;
    }
    let document = parse_document(file);
    let frontmatter = document["frontmatter"];
    if !frontmatter.contains("kind") {
        return false;
    }
    frontmatter["kind"] == "readiness-map"
}

fn list_map_roots(repo_root, target_root) {
    let roots = [];
    let direct_map = path::join(target_root, "README.md");
    if is_readiness_map_file(direct_map) {
        roots.push(target_root);
        return roots;
    }
    if !fs::is_dir(target_root) {
        return roots;
    }
    for entry in fs::list(target_root) {
        let entry_map = path::join(entry, "README.md");
        if !fs::is_dir(entry) || !is_readiness_map_file(entry_map) {
            continue;
        }
        if path::file_name(entry) == "archive" && str::ends_with(target_root, "/docs/specs") {
            continue;
        }
        roots.push(entry);
    }
    roots.sort();
    roots
}

fn validate_record(repo_root, destination_root, file) {
    let errors = [];
    let document = parse_document(file);
    errors = merge_arrays(errors, document["errors"]);
    let frontmatter = document["frontmatter"];
    let context = "decision record " + file;
    errors = merge_arrays(errors, required_fields(frontmatter, ["id", "kind", "mode", "status", "title", "owner", "authority", "blocked_by"], context));
    errors = merge_arrays(errors, allowed_field(frontmatter, "kind", ["decision", "research", "prototype", "task"], context));
    errors = merge_arrays(errors, allowed_field(frontmatter, "mode", ["operator", "research", "prototype", "task"], context));
    errors = merge_arrays(errors, allowed_field(frontmatter, "status", ["open", "in-progress", "resolved", "out-of-scope"], context));

    let record_id = "";
    if frontmatter.contains("id") {
        record_id = frontmatter["id"];
        if !valid_id(record_id) {
            let message = context;
            message += ": id must be lowercase kebab-case: ";
            message += record_id;
            errors.push(message);
        }
        let filename = path::file_name(file);
        let filename_pattern = "^" + record_id + "-.+[.]md$";
        if !regex::is_match(filename_pattern, filename) {
            let message = context;
            message += ": filename must begin with exact id '";
            message += record_id;
            message += "': ";
            message += filename;
            errors.push(message);
        }
    }

    if frontmatter.contains("blocked_by") {
        if type_of(frontmatter["blocked_by"]) != "array" {
            errors.push(context + ": blocked_by must be a YAML list");
        }
    }
    if frontmatter.contains("status") && frontmatter["status"] == "resolved" {
        let has_evidence = frontmatter.contains("resolution_evidence");
        let has_uncertainty = frontmatter.contains("accepted_uncertainty");
        if has_evidence == has_uncertainty {
            errors.push(context + ": resolved records must expose exactly one of resolution_evidence or accepted_uncertainty");
        }
    } else if frontmatter.contains("resolution_evidence") || frontmatter.contains("accepted_uncertainty") {
        errors.push(context + ": resolution_evidence and accepted_uncertainty are only valid for resolved records");
    }

    errors = merge_arrays(errors, validate_links(repo_root, destination_root, file, document["body"]));
    #{ errors: errors, id: record_id, frontmatter: frontmatter }
}

fn has_remaining_dependency(record, remaining) {
    if !record.contains("blocked_by") {
        return false;
    }
    let dependencies = record["blocked_by"];
    for dependency in dependencies {
        if has_array_item(remaining, dependency) {
            return true;
        }
    }
    false
}

fn frontier_ready(records_by_id, record) {
    let dependencies = record["blocked_by"];
    for dependency in dependencies {
        if !has_map_key(records_by_id, dependency) {
            return false;
        }
        let dependency_record = records_by_id[dependency];
        if dependency_record["status"] != "resolved" {
            return false;
        }
    }
    true
}

fn detect_cycles(records_by_id, record_ids) {
    let remaining = [];
    for record_id in record_ids {
        remaining.push(record_id);
    }

    let changed = true;
    while changed {
        changed = false;
        let next = [];
        for record_id in remaining {
            let record = records_by_id[record_id];
            if has_remaining_dependency(record, remaining) {
                next.push(record_id);
            } else {
                changed = true;
            }
        }
        remaining = next;
    }

    let errors = [];
    if remaining.len() > 0 {
        remaining.sort();
        let cycle = "";
        for record_id in remaining {
            if cycle != "" {
                cycle += ", ";
            }
            cycle += record_id;
        }
        errors.push("dependency cycle detected among: " + cycle);
    }
    errors
}

fn validate_destination(repo_root, destination_root) {
    let result = #{ ok: true, destination: path::file_name(destination_root), frontier: [], errors: [] };
    let map_file = path::join(destination_root, "README.md");
    if !fs::is_file(map_file) {
        result["errors"].push("missing readiness map: " + map_file);
        result["ok"] = false;
        return result;
    }

    let map_document = parse_document(map_file);
    result["errors"] = merge_arrays(result["errors"], map_document["errors"]);
    let map_frontmatter = map_document["frontmatter"];
    let map_context = "readiness map " + map_file;
    result["errors"] = merge_arrays(result["errors"], required_fields(map_frontmatter, ["kind", "id", "title", "destination", "owner", "status", "master_spec", "roadmap"], map_context));
    result["errors"] = merge_arrays(result["errors"], allowed_field(map_frontmatter, "kind", ["readiness-map"], map_context));
    result["errors"] = merge_arrays(result["errors"], allowed_field(map_frontmatter, "status", ["active", "cleared", "paused"], map_context));
    if map_frontmatter.contains("id") && !valid_id(map_frontmatter["id"]) {
        result["errors"].push(map_context + ": id must be lowercase kebab-case: " + map_frontmatter["id"]);
    }
    if map_frontmatter.contains("destination") && map_frontmatter["destination"] != result["destination"] {
        result["errors"].push(map_context + ": destination must match directory name '" + result["destination"] + "'");
    }
    let required_sections = ["Destination", "Decision index", "Current frontier", "Readiness gate"];
    for heading in required_sections {
        if !str::split_lines(map_document["body"]).contains("## " + heading) {
            result["errors"].push(map_context + ": missing required section '## " + heading + "'");
        }
    }
    result["errors"] = merge_arrays(result["errors"], validate_map_links(repo_root, destination_root, map_file, map_frontmatter));
    result["errors"] = merge_arrays(result["errors"], validate_links(repo_root, destination_root, map_file, map_document["body"]));

    let records_dir = path::join(destination_root, "decisions");
    let records_by_id = #{};
    let record_ids = [];
    let record_files = [];
    if !fs::is_dir(records_dir) {
        result["errors"].push(map_context + ": missing decisions directory");
    } else {
        for file in fs::list_recursive(records_dir) {
            if fs::is_file(file) && str::ends_with(file, ".md") {
                record_files.push(file);
            }
        }
        record_files.sort();
        for file in record_files {
            if path::parent(file) != records_dir {
                let message = "decision record must be directly under decisions/: ";
                message += file;
                result["errors"].push(message);
            }
            let record_report = validate_record(repo_root, destination_root, file);
            result["errors"] = merge_arrays(result["errors"], record_report["errors"]);
            let record_id = record_report["id"];
            if record_id != "" {
                records_by_id[record_id] = record_report["frontmatter"];
                record_ids.push(record_id);
            }
        }
    }

    result["errors"] = merge_arrays(result["errors"], detect_duplicate_ids(record_ids));

    if map_frontmatter.contains("id") && has_map_key(records_by_id, map_frontmatter["id"]) {
        result["errors"].push(map_context + ": map id duplicates decision id '" + map_frontmatter["id"] + "'");
    }

    let linked_records = [];
    for raw_target in extract_links(map_document["body"]) {
        if is_external_link(raw_target) {
            continue;
        }
        let target = trim_quotes(str::trim(raw_target));
        target = regex::replace("^<([^>]+)>.*$", target, "$1");
        target = regex::replace("[?#].*$", target, "");
        if str::starts_with(target, "decisions/") {
            let linked_file = path::join(destination_root, target);
            if !fs::is_file(linked_file) {
                let message = map_context;
                message += ": missing decision-index reference: ";
                message += target;
                result["errors"].push(message);
            } else {
                linked_records.push(linked_file);
            }
        }
    }
    for file in record_files {
        if !has_array_item(linked_records, file) {
            let message = "orphan decision record not linked from Decision index: ";
            message += file;
            result["errors"].push(message);
        }
    }

    for record_id in record_ids {
        let record = records_by_id[record_id];
        let dependencies = record["blocked_by"];
        for dependency in dependencies {
            if !has_map_key(records_by_id, dependency) {
                let message = "missing blocked_by reference '";
                message += dependency;
                message += "' from decision '";
                message += record_id;
                message += "'";
                result["errors"].push(message);
            }
        }
    }
    result["errors"] = merge_arrays(result["errors"], detect_cycles(records_by_id, record_ids));

    for record_id in record_ids {
        let record = records_by_id[record_id];
        let status = record["status"];
        if status == "open" || status == "in-progress" {
            if frontier_ready(records_by_id, record) {
                result["frontier"].push(record_id);
            }
        }
    }
    result["frontier"].sort();

    if map_frontmatter.contains("status") && map_frontmatter["status"] == "cleared" && result["frontier"].len() > 0 {
        for record_id in result["frontier"] {
            let record = records_by_id[record_id];
            if record["mode"] == "operator" || record["authority"] == "operator" {
                let message = "operator-blocked: cleared map still has unresolved operator-owned decision '";
                message += record_id;
                message += "'";
                result["errors"].push(message);
            } else {
                let message = "invalid state: cleared map has open frontier decision '";
                message += record_id;
                message += "'";
                result["errors"].push(message);
            }
        }
    }

    if result["errors"].len() > 0 {
        result["ok"] = false;
    }
    result
}

fn validate_root(repo_root, target_root) {
    let result = #{ ok: true, maps: [], errors: [] };
    if !fs::is_dir(target_root) {
        result["ok"] = false;
        result["errors"].push("readiness-map root is not a directory: " + target_root);
        return result;
    }
    let roots = list_map_roots(repo_root, target_root);
    for destination_root in roots {
        let map_result = validate_destination(repo_root, destination_root);
        result["maps"].push(map_result);
        result["errors"] = merge_arrays(result["errors"], map_result["errors"]);
    }
    if result["errors"].len() > 0 {
        result["ok"] = false;
    }
    result
}
