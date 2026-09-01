import "scripts/lib/northstar-repo-contract-data.rhai" as contract;
import "scripts/lib/northstar-repo-contract-checker.rhai" as checker;

fn require(condition, message) {
    if !condition {
        throw("[northstar:repo-contract-fixtures] " + message);
    }
}

fn fixture_required_files() {
    [
        "README.md",
        "docs/README.md",
        "skills/northstar/SKILL.md",
        "skills/northstar/references/mode.md",
        "template-bundle/specs/templates/batch-card-template.md",
        "skills/northstar/assets/templates/docs/specs/templates/batch-card-template.md",
    ]
}

fn fixture_file_pairs() {
    [
        [
            "template-bundle/specs/templates/batch-card-template.md",
            "skills/northstar/assets/templates/docs/specs/templates/batch-card-template.md",
            "fixture template parity",
        ],
    ]
}

fn write_fixture_file(root, relative, contents) {
    fs::write_file(path::join(root, relative), contents);
}

fn new_fixture(label, include_docs_front_door, skill_target, mirror_contents, docs_contents) {
    let root = fs::make_temp_dir("northstar-repo-contract-" + label);
    fs::create_dir(path::join(root, "docs"));
    fs::create_dir(path::join(root, "skills/northstar/references"));
    fs::create_dir(path::join(root, "skills/northstar/assets/templates/docs/specs/templates"));
    fs::create_dir(path::join(root, "template-bundle/specs/templates"));

    write_fixture_file(root, "README.md", "# Fixture\n");
    if include_docs_front_door {
        write_fixture_file(root, "docs/README.md", docs_contents);
    }
    write_fixture_file(root, "skills/northstar/SKILL.md", "[mode](" + skill_target + ")\n");
    write_fixture_file(root, "skills/northstar/references/mode.md", "# Mode\n");
    write_fixture_file(root, "template-bundle/specs/templates/batch-card-template.md", "canonical\n");
    write_fixture_file(root,
        "skills/northstar/assets/templates/docs/specs/templates/batch-card-template.md",
        mirror_contents);
    root
}

fn run_check(root) {
    checker::check(root, fixture_required_files(), fixture_file_pairs());
}

fn expect_pass(label, action) {
    try {
        call(action);
    } catch (error) {
        throw("fixture " + label + " unexpectedly failed: " + error);
    }
    log("repo-contract fixture " + label + ": PASS");
}

fn expect_failure(label, action, expected_reason) {
    let rejected = false;
    try {
        call(action);
    } catch (error) {
        rejected = true;
        let message = error.to_string();
        require(message.contains(expected_reason),
            "fixture " + label + " failed for the wrong reason: " + message);
        log("repo-contract fixture " + label + ": PASS (expected failure: " + expected_reason + ")");
    }
    require(rejected, "fixture " + label + " unexpectedly passed");
}

fn prove_source_reduction() {
    let data = fs::read_file(path::join(repo_root, "scripts/lib/northstar-repo-contract-data.rhai"));
    let checker_source = fs::read_file(path::join(repo_root, "scripts/check-northstar-repo-contract.rhai"));
    let checker_library = fs::read_file(path::join(repo_root, "scripts/lib/northstar-repo-contract-checker.rhai"));
    let removed_required_assertions = "required_" + "content";
    let removed_forbidden_assertions = "forbidden_" + "content";
    let removed_contains_call = "docs::check_" + "contains";
    let removed_forbidden_call = "docs::check_" + "forbidden";

    require(!data.contains(removed_required_assertions) &&
        !data.contains(removed_forbidden_assertions),
        "prose assertion data remains in the contract data");
    require(!checker_source.contains(removed_required_assertions) &&
        !checker_source.contains(removed_forbidden_assertions) &&
        !checker_source.contains(removed_contains_call) &&
        !checker_source.contains(removed_forbidden_call),
        "prose assertion path remains in the entrypoint");
    require(!checker_library.contains(removed_required_assertions) &&
        !checker_library.contains(removed_forbidden_assertions) &&
        !checker_library.contains(removed_contains_call) &&
        !checker_library.contains(removed_forbidden_call),
        "prose assertion path remains in the checker library");
}

let missing_front_door = new_fixture(
    "missing-front-door",
    false,
    "references/mode.md",
    "canonical\n",
    "# Docs\n",
);
expect_failure(
    "missing-front-door",
    || run_check(missing_front_door),
    "missing required Northstar repo contract path",
);

let broken_link = new_fixture(
    "broken-link",
    true,
    "references/missing.md",
    "canonical\n",
    "# Docs\n",
);
expect_failure(
    "broken-link",
    || run_check(broken_link),
    "broken Markdown link in skills/northstar",
);

let parity_drift = new_fixture(
    "parity-drift",
    true,
    "references/mode.md",
    "drifted\n",
    "# Docs\n",
);
expect_failure("parity-drift", || run_check(parity_drift), "fixture template parity");

let token_like_prose = new_fixture(
    "token-like-prose",
    true,
    "references/mode.md",
    "canonical\n",
    "mask-plus-translated-highlight\n",
);
expect_pass("token-like-prose", || run_check(token_like_prose));

let editorial_rewording = new_fixture(
    "editorial-rewording",
    true,
    "references/mode.md",
    "canonical\n",
    "## Next Task\nA reworded supersession paragraph.\n",
);
expect_pass("editorial-rewording", || run_check(editorial_rewording));

let papercut_closeout = new_fixture(
    "papercut-closeout",
    true,
    "references/mode.md",
    "canonical\n",
    "## Papercuts\n- resolved the one-off setup friction.\n",
);
expect_pass("papercut-closeout", || run_check(papercut_closeout));

let historical_path = "docs/roadmaps/g02/batch-cards/082-reprove-triage-and-docs-cleanup-surface.md";
require(!contract::required_files().contains(historical_path),
    "historical card is still in the live required-path list");
let closed_spec_path = "docs/specs/024-papercuts-feedback-loop.md";
require(!contract::required_files().contains(closed_spec_path),
    "closed spec is still in the live required-path list");
let historical_evidence = new_fixture(
    "historical-path",
    true,
    "references/mode.md",
    "canonical\n",
    "# Current docs\nHistorical evidence can move freely.\n",
);
expect_pass("historical-path", || run_check(historical_evidence));

let source_preserving_partition = new_fixture(
    "source-preserving-partition",
    true,
    "references/mode.md",
    "canonical\n",
    "## Tests\nThe source-preserving partition keeps behavior unchanged.\n",
);
expect_pass("source-preserving-partition", || run_check(source_preserving_partition));

prove_source_reduction();
log("repo-contract fixture source-reduction: PASS");
log("Northstar repo-contract fixture tests: OK (7 oracle rows; 3 retained failures, 5 benign passes, source reduction proof)");
