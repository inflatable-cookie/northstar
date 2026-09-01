import "scripts/lib/northstar-repo-contract-data.rhai" as contract;
import "scripts/lib/northstar-repo-contract-checker.rhai" as checker;

checker::check(
    repo_root,
    contract::required_files(),
    contract::identical_file_pairs(),
    contract::stable_machine_contracts(),
);

log("Northstar repo contract checks: OK");
