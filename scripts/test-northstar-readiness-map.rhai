import "scripts/lib/northstar-readiness-map.rhai" as readiness;

let fixture_root = path::join(repo_root, "scripts/fixtures/readiness-map");
let cases = [
    ["valid", true],
    ["missing-reference", false],
    ["cycle", false],
    ["orphan", false],
    ["operator-blocked", false],
];

for fixture_case in cases {
    let name = fixture_case[0];
    let expected_ok = fixture_case[1];
    let report = readiness::validate_root(repo_root, path::join(fixture_root, name));
    if report["ok"] != expected_ok {
        if expected_ok {
            throw("fixture " + name + " unexpectedly failed: " + report["errors"]);
        }
        throw("fixture " + name + " unexpectedly passed");
    }

    if expected_ok {
        let frontier = "";
        for map_report in report["maps"] {
            for decision_id in map_report["frontier"] {
                if frontier != "" {
                    frontier += ", ";
                }
                frontier += decision_id;
            }
        }
        if frontier != "choose-runtime, document-task" {
            throw("fixture valid produced unstable frontier: " + frontier);
        }
        log("readiness fixture valid: PASS (frontier=" + frontier + ")");
    } else {
        let reasons = "";
        for problem in report["errors"] {
            if reasons != "" {
                reasons += " | ";
            }
            reasons += problem;
        }
        log("readiness fixture " + name + ": PASS (expected failure: " + reasons + ")");
    }
}

log("Northstar readiness-map fixture tests: OK (5 cases)");
