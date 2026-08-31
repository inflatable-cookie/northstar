# Delegate Conversational Feature Planning

Date: 2026-08-31
Roadmap: `g02.040`
Card: `g02.040/108`
Status: complete

## Result

Northstar now supports an operator-requested conversational planning delegate
with a committed `planning-delegate` handoff, isolated branch/worktree, named
triage/research-only write paths, and orchestrator-owned review, merge,
promotion, readiness, and implementation dispatch. Bounded research helpers are
read-only, cannot contact the operator, and cannot create worktrees, branches,
PRs, or nested lanes.

The role remains provider-neutral. Sol is an explicitly selectable local
frontier profile, not a Northstar dependency. Merge is intake; promotion is a
separate orchestrator batch before readiness or implementation.

## Authority and review corrections

Sol retained all semantic authority. Review caught and corrected three
cross-protocol details: planning delegates may need sibling repositories, so the
handoff lists links or `none` and verifies safe container-directory links;
planning-delegate preflight is distinct from implementation-worker preflight,
with contract 002 covering manual delegated worktrees; and operator
confirmations recorded in the planning packet, rather than private thread
history, are repository authority when ownership is unclear.

The policy was aligned across canonical contract, specification, architecture,
doctrine, operator, source skill, installed skill, and validation surfaces.

## Validation

- `git diff --check` passes;
- `effigy check:repo-contract` passes;
- skill creator quick validation passes;
- source/install skill parity is exact apart from generated `.effigy` and Rust
  `target`;
- full `effigy qa` passes.

No live planning-delegate, Paseo, or PR dogfood was performed.

## Next

The later `g02.038/106` lifecycle proof is complete. Return to generation
planning.
