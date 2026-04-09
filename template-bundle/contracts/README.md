# Contracts

Use this folder for explicit non-code contracts that constrain behavior.

Examples:
- protocol contracts
- API behavior contracts
- policy contracts
- cross-repo ownership contracts

Template:
- `001-contract-template.md`
- `contract-index.md`
- `001-working-rules-template.md` for stricter repos

Examples:
- `example-contract-index.md`
- `002-example-job-dispatch-contract.md`

## Rule

Contracts should be stable reference artifacts and link to relevant roadmap/log evidence.
Roadmap work should not proceed until the required contract exists and is listed
in the contract index.
Contracts are the hard-definition surface for behavior, interfaces, policies,
and other durable rules that should not live only in provisional specs.
For stricter repos, start with `001-working-rules-template.md` so execution
grammar, done-ness, and autonomy rules are explicit before longer hands-off
delivery starts.

## Next task

Create the contract index, then add the first contract artifact for the
highest-risk boundary that roadmap work depends on. For stricter repos, start
with `001-working-rules-template.md`.
