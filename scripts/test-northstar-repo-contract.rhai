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

fn fixture_required_files_with_active_authority() {
    let files = fixture_required_files();
    files.push("docs/specs/038-compact-default-lifecycle-and-generation-rollup.md");
    files
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
    fs::create_dir(path::join(root, "docs/specs"));
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

fn new_authority_fixture(label, include_authority) {
    let root = new_fixture(
        label,
        true,
        "references/mode.md",
        "canonical\n",
        "# Docs\n",
    );
    if include_authority {
        write_fixture_file(root,
            "docs/specs/038-compact-default-lifecycle-and-generation-rollup.md",
            "# Active authority\n");
    }
    root
}

fn new_machine_fixture(label, claude_contents, effigy_contents) {
    let root = fs::make_temp_dir("northstar-repo-contract-" + label);
    fs::create_dir(path::join(root, "scripts"));
    fs::create_dir(path::join(root, "scripts/lib"));
    fs::create_dir(path::join(root, "skills"));
    fs::create_dir(path::join(root, "skills/northstar"));
    fs::create_dir(path::join(root, "skills/northstar/assets"));
    fs::create_dir(path::join(root, "skills/northstar/assets/templates"));
    write_fixture_file(root,
        "scripts/check-northstar-repo-contract-wiring.rhai",
        fs::read_file(path::join(repo_root, "scripts/check-northstar-repo-contract-wiring.rhai")));
    write_fixture_file(root,
        "scripts/lib/northstar-repo-contract-data.rhai",
        fs::read_file(path::join(repo_root, "scripts/lib/northstar-repo-contract-data.rhai")));
    write_fixture_file(root,
        "scripts/lib/northstar-repo-contract-checker.rhai",
        fs::read_file(path::join(repo_root, "scripts/lib/northstar-repo-contract-checker.rhai")));
    write_fixture_file(root,
        "scripts/lib/northstar-lifecycle-checker.rhai",
        fs::read_file(path::join(repo_root, "scripts/lib/northstar-lifecycle-checker.rhai")));
    write_fixture_file(root, "scripts/noop.rhai", "log(\"fixture no-op\");\n");
    write_fixture_file(root, "CLAUDE.md", claude_contents);
    write_fixture_file(root, "effigy.toml", effigy_contents);
    write_fixture_file(root, "skills/northstar/assets/templates/CLAUDE.md.template", "@AGENTS.md\n");
    write_fixture_file(root,
        "skills/northstar/effigy.toml",
        "alias = \"northstar\"\n\"paseo:worktree\" = [{ rhai = \"scripts/paseo-worktree.rhai\" }]\n");
    write_fixture_file(root,
        "paseo.json",
        "paseo:worktree -- prepare\npaseo:worktree -- link\npaseo:worktree -- unlink\n");
    write_fixture_file(root,
        "skills/northstar/assets/templates/paseo.json.template",
        "paseo:worktree -- link\n");
    root
}

fn run_effigy(root, selector) {
    effigy::run(["--repo", root, selector])
}

fn expect_effigy_pass(label, root, selector) {
    let report = run_effigy(root, selector);
    require(report["success"],
        "fixture " + label + " unexpectedly failed: " + report["error"]);
    log("repo-contract fixture " + label + ": PASS (selector " + selector + " executed)");
}

fn expect_effigy_failure(label, root, selector, expected_reason) {
    let report = run_effigy(root, selector);
    require(!report["success"],
        "fixture " + label + " unexpectedly passed through Effigy " + selector);
    let output = report["error"] + "\n" + report["output"] + "\n" + report["rendered_output"];
    require(output.contains(expected_reason),
        "fixture " + label + " failed for the wrong reason: " + output);
    log("repo-contract fixture " + label + ": PASS (expected failure: " + expected_reason + ")");
}

fn run_check(root) {
    checker::check(root, fixture_required_files(), fixture_file_pairs(), []);
}

fn run_authority_check(root) {
    checker::check(
        root,
        fixture_required_files_with_active_authority(),
        fixture_file_pairs(),
        [],
    );
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

let authority_path = "docs/specs/038-compact-default-lifecycle-and-generation-rollup.md";
for authority in contract::current_active_authority_files() {
    require(contract::required_files().contains(authority),
        "current active authority is missing from the live required-path list: " + authority);
}
let missing_active_authority = new_authority_fixture("missing-active-authority", false);
expect_failure(
    "missing-active-authority",
    || run_authority_check(missing_active_authority),
    authority_path,
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

let full_qa_docs = "[{ task = \"check:repo-contract-wiring\" }, { task = \"check:repo-contract\" }, { task = \"test:repo-contract\" }, { task = \"check:readiness-map\" }, { task = \"test:readiness-map\" }, { task = \"check:command-skills\" }, { task = \"check:model-routing\" }, { task = \"check:language-packages\" }]";
let machine_effigy = "[manifest]\nminimum_effigy_version = \"0.8.4\"\n\n";
machine_effigy += "[catalog]\nalias = \"northstar\"\n\n[tasks]\n";
machine_effigy += "\"check:repo-contract-wiring\" = [{ rhai = \"scripts/check-northstar-repo-contract-wiring.rhai\" }]\n";
machine_effigy += "\"check:repo-contract\" = [{ rhai = \"scripts/check-northstar-repo-contract.rhai\" }]\n";
machine_effigy += "\"test:repo-contract\" = [{ rhai = \"scripts/test-northstar-repo-contract.rhai\" }]\n";
machine_effigy += "\"check:readiness-map\" = [{ rhai = \"scripts/noop.rhai\" }]\n\"test:readiness-map\" = [{ rhai = \"scripts/noop.rhai\" }]\n\"check:command-skills\" = [{ rhai = \"scripts/noop.rhai\" }]\n\"check:model-routing\" = [{ rhai = \"scripts/noop.rhai\" }]\n\"check:language-packages\" = [{ rhai = \"scripts/noop.rhai\" }]\n\"check:bundle\" = [{ rhai = \"scripts/noop.rhai\" }]\n\"check:language-package-routes\" = \"scripts/noop.sh\"\n\"test:paseo-worktree\" = [{ rhai = \"scripts/noop.rhai\" }]\n";
machine_effigy += "\"qa:docs\" = " + full_qa_docs + "\n";
machine_effigy += "validate = [{ task = \"check:repo-contract-wiring\" }, { task = \"check:bundle\" }, { task = \"check:language-packages\" }, { task = \"check:language-package-routes\" }, { task = \"test:paseo-worktree\" }]\n";
machine_effigy += "qa = [{ task = \"validate\" }, { task = \"qa:docs\" }]\n";
let missing_claude_bridge = new_machine_fixture(
    "missing-claude-bridge",
    "A different Claude instruction\n",
    machine_effigy,
);
expect_effigy_failure(
    "missing-claude-bridge-selector",
    missing_claude_bridge,
    "check:repo-contract-wiring",
    "root Claude Code bridge",
);

let missing_qa_docs = "[{ task = \"check:readiness-map\" }, { task = \"test:readiness-map\" }, { task = \"check:command-skills\" }]";
let missing_qa_wiring_effigy = str::replace(machine_effigy, full_qa_docs, missing_qa_docs);
let missing_qa_wiring = new_machine_fixture(
    "missing-qa-wiring",
    "@AGENTS.md\n",
    missing_qa_wiring_effigy,
);
expect_effigy_pass("missing-qa-wiring-qa-docs-bypass", missing_qa_wiring, "qa:docs");
expect_effigy_failure("missing-qa-wiring-outer-board", missing_qa_wiring, "qa", "docs QA repo-contract wiring");

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
let closed_g02_front_door = "docs/roadmaps/g02/README.md";
require(!contract::required_files().contains(closed_g02_front_door),
    "closed g02 front door is still in the live required-path list");
let closed_spec_034 = "docs/specs/034-modular-language-quality-packages.md";
require(!contract::required_files().contains(closed_spec_034),
    "closed spec 034 is still in the live required-path list");
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

let lifecycle_fixture_root = path::join(repo_root, "scripts/fixtures/lifecycle");
expect_failure(
    "archive-executable",
    || checker::check_lifecycle(path::join(lifecycle_fixture_root, "archive-executable")),
    "archive roll-up g01.md must not contain runnable execution procedure",
);
expect_failure(
    "archive-expanded-collision",
    || checker::check_lifecycle(path::join(lifecycle_fixture_root, "archive-expanded-collision")),
    "archived generation g01 must not remain expanded",
);
expect_failure(
    "multiple-expanded",
    || checker::check_lifecycle(path::join(lifecycle_fixture_root, "multiple-expanded")),
    "more than one expanded sequential generation in roadmaps: g01",
);
expect_pass("lifecycle-valid", || checker::check_lifecycle(path::join(lifecycle_fixture_root, "valid")));

log("Northstar repo-contract fixture tests: OK (15 fixture cases; 9 expected failures, 6 benign passes, Effigy selector/outer-board proof, source reduction proof)");
