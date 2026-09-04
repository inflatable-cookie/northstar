# Contracts

**Type: REQUIRED** -- Every Northstar project needs this folder.

Use this folder for explicit non-code contracts that constrain behavior.

Examples:
- protocol contracts
- API behavior contracts
- policy contracts
- cross-repo ownership contracts

Template:
- `001-contract-template.md`
- `contract-index.md`
- `001-working-rules-template.md` for explicit execution grammar
- `002-agent-local-paths-template.md` for ignored local path settings and
  manual worktree placement
- `003-agent-instruction-surface-template.md` for compact always-loaded agent
  instructions and scoped/on-demand guidance

Examples:
- `example-contract-index.md`
- `002-example-job-dispatch-contract.md`

## Rule

Contracts should be stable reference artifacts and link to relevant roadmap/log evidence.
Roadmap work should not proceed until the required contract exists and is listed
in the contract index.
Contracts are the hard-definition surface for behavior, interfaces, policies,
and other durable rules that should not live only in provisional specs.
Start with `001-working-rules-template.md` so execution grammar, done-ness, and
autonomy rules are explicit before longer hands-off delivery starts.
