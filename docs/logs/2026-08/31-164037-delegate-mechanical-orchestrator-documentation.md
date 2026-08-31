# Delegate Mechanical Orchestrator Documentation

Date: 2026-08-31
Roadmap: `g02.039`
Card: `g02.039/107`
Status: complete

## Result

Northstar now has a copy-ready brief for serial, profile-driven mechanical
documentation projection. The role is provider-neutral; `gpt-5.6-luna` was the
local fast/low-cost example, not a Northstar dependency.

Sol retains discovery, planning, architecture and contract decisions,
canonical-home selection, promotion, acceptance, readiness/completion judgment,
review-oracle design, PR review, merge, and final semantic diff review. The
projection subagent receives exact settled meaning, named paths, evidence,
validation, and stop conditions. It does not use worker mode or a worktree.

The first projection changed exactly six allowed files. Sol reviewed the full
diff and corrected the roadmap dependency to `g02.037` rather than waiting
`g02.038`, and required explicit `Forbidden judgments` and `Stop conditions`
fields in the template. Sol then promoted the policy through the canonical
contract, specification, architecture, doctrine, operator, and skill surfaces
and synced the installed skill.

## Evidence and validation

- `git diff --check` passed for the projection batch;
- skill creator quick validation passed;
- source/install parity passed apart from generated `.effigy` and Rust `target`;
- full `effigy qa` passed;
- Figmatic `git diff --check` and `effigy qa:docs` passed after its adopted
  contract and `AGENTS.md` were aligned;
- unrelated dirty changes and unlisted paths were preserved;
- no worker worktree, commit, or push was performed by the projection role.

## Next

The later `g02.038/106` lifecycle proof is complete. Return to generation
planning.
