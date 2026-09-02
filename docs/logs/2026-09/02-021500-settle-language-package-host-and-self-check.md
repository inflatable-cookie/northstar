# Settle Language Package Host And Self-Check

Date: 2026-09-02
Roadmap: `g02.048`
Card: `g02.048/117`
Status: planning promoted; worker revision required

## Decision

PR 22 review proved the package identity, store, and lifecycle mechanics but
found two missing contracts. The operator accepted the orchestrator's
recommended boundaries.

- `language-package-host.v1` is the provider-neutral JSON operational protocol.
  Hosts adapt catalogue, filesystem, atomic state, transport, and execution
  capabilities. Effigy, Bun, Node, Python, POSIX shell, and provider APIs are
  optional implementations, not consumer prerequisites.
- V1 exposes `resolve`, `acquire_activate`, and `rollback`. Messages bind intent,
  identity, workflow, compatibility, consumer scope, operator state, exact
  result identity, and visible notice as specified in spec 034.
- Self-check invocation is explicit. `direct` executes the verified entrypoint
  with the package root. `command` names a required command and receives the
  entrypoint plus package root. Both use the package root as working directory;
  capability order and shell interpolation have no semantics.

## Promotion

The decisions are promoted into system architecture, contract 004, spec 034,
card 117, and the active worker handoff. Card 117 remains the only execution
edge. The worker must integrate this main commit, implement the machine
contracts and operational proof on PR 22, and keep card 118 blocked.

## Validation

`effigy qa:docs` passed and `git diff --check` was clean. Runtime/schema proof
remains worker-owned on PR 22.
