import "scripts/lib/northstar-readiness-map.rhai" as readiness;

fn parse_target_root(default_root, argv) {
    let positional = "";
    if argv.len() > 0 && !str::starts_with(argv[0], "-") {
        positional = argv[0];
    }
    if positional != "" {
        return path::join(repo_root, positional);
    }
    default_root
}

let target_root = parse_target_root(path::join(repo_root, "docs/specs"), args);
let report = readiness::validate_root(repo_root, target_root);
if !report["ok"] {
    let message = "Northstar readiness map checks failed";
    for problem in report["errors"] {
        message += "\n- " + problem;
    }
    throw(message);
}

if report["maps"].len() == 0 {
    log("Northstar readiness map checks: OK (0 maps; frontier empty)");
} else {
    log("Northstar readiness map checks: OK (" + report["maps"].len() + " map(s))");
    for map_report in report["maps"] {
        let frontier = "empty";
        if map_report["frontier"].len() > 0 {
            frontier = "";
            for decision_id in map_report["frontier"] {
                if frontier != "" {
                    frontier += ", ";
                }
                frontier += decision_id;
            }
        }
        log("- " + map_report["destination"] + ": frontier=" + frontier);
    }
}
