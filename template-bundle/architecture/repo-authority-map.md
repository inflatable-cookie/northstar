# Repo Authority Map

**Type: REQUIRED** (multi-repo) -- Define repo ownership and authority boundaries.

Status: draft
Owner: <owner>
Updated: YYYY-MM-DD
Architecture refs: <system-architecture.md, system-inventory.md>

## Topology

Describe the participating repos, deployable units, and the boundaries between
them.

## Repo Authorities

| Repo | Owns | Consumes | Authoritative decisions | Notes |
| --- | --- | --- | --- | --- |
| <repo> | <surfaces> | <dependencies> | <state/workflows/contracts> | <notes> |

## Cross-Repo Contracts

| Seam | Source repo | Consumer repo | Contract | Status |
| --- | --- | --- | --- | --- |
| <seam> | <repo> | <repo> | <contract id or pending> | <ready/gap> |

## Conflict Resolution Rules

- When sources disagree, <repo/system> is authoritative for <surface>.
- If a seam lacks a contract, execution stops until the contract exists.
- If ownership changes, update this file, the contract index, and affected
  roadmap milestones before further execution.

## Planning Gaps

- <missing repo contract, authority rule, or integration seam>
