import "scripts/lib/northstar-repo-contract-data.rhai" as contract;
import "scripts/lib/northstar-repo-contract-checker.rhai" as checker;

checker::check_machine_contracts(repo_root, contract::stable_machine_contracts());

log("Northstar repo-contract machine contracts: OK");
