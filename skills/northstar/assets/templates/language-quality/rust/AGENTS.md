# Rust Quality Instructions

Scope: Rust source, Cargo manifests, build files, tests, and directly related
documentation under this directory.

- For ordinary Rust writing, review, or refactoring, use Northstar's Rust
  everyday-authoring route and the repository's strict profile.
- Read `docs/contracts/rust-quality-profile.json` and
  `docs/contracts/rust-quality-deviations.json` before editing.
- Resolve MSRV and toolchain policy from the paths declared by the repository;
  never assume a universal Rust version.
- Re-enter the authoring mode at task start and coherent batch closeout. Review
  the task-attributable changed tranche and direct correctness surface.
- Preserve unrelated work. Ordinary coding does not authorize a worktree or
  repository audit, blanket fixing, or unrelated formatting.
- A requested quality audit, no-slop pass, or audit-and-fix action is explicit
  audit intent; never route it through everyday authoring.
