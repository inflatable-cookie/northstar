# Make Rust Activation Agent-Owned

Date: 2026-08-26
Roadmap: `g02.030`
Card state: post-closeout correction to `g02.030/088`; milestone remains complete

## Outcome

Operator feedback exposed a bad ownership boundary in card 088: documentation
required a human to copy and configure Rust activation files. The installed
Northstar skill now owns that work.

When Northstar is requested for ordinary Rust work or explicit audit and the
activation block, profile, or deviations contract is missing, the agent runs
`northstar/rust-quality:setup`. The setup task discovers Cargo manifests and
explicit toolchain files, installs missing contracts, and appends a compact
marked instruction block without replacing existing `AGENTS.md` content.

The setup is byte-idempotent. Existing valid profiles and deviations remain
unchanged. Partial markers, malformed contracts, non-Rust targets, and paths
outside the requested repository scope fail closed. The operator is asked only
when repository policy cannot be recovered, such as an undeclared effective
MSRV or uncertain generated/vendor exclusions.

## Context Boundary

The correction does not load the catalogue globally. Northstar's entrypoint
remains a small router; setup enters only after a Rust route is selected. The
installed activation block is shorter than the previous copy-ready template,
and individual rule files still load only when their authoring triggers apply.

No catalogue, projection, remediation authority, assurance profile, or
production-evidence claim changed.

## Distribution Evidence

- installed payload: 76 files with exact source parity;
- installed selectors:
  `northstar/check:agent-instructions`,
  `northstar/check:rust-quality`,
  `northstar/rust-quality:setup`,
  `northstar/test:rust-quality-setup`,
  `northstar/rust-quality:record`, and
  `northstar/test:rust-quality-recorder`;
- setup self-test: installation, existing-instruction preservation,
  repeat-run idempotency, missing-Cargo rejection, and partial-marker rejection;
- routing fixtures: eight cases, including Northstar-requested activation in an
  unconfigured Rust repository;
- authoring workflow fixtures: seven cases, including install-before-edit.

## Validation

- isolated 76-file skill parity — pass;
- installed 76-file skill parity — pass;
- installed `northstar/check:rust-quality` — pass;
- installed `northstar/test:rust-quality-setup` — pass;
- installed `northstar/test:rust-quality-recorder` — pass;
- skill-creator structural validation — pass;
- `effigy check:command-skills` — pass: eight adapters, 428 aggregate
  description characters;
- `effigy check:agent-instructions` — advisory complete; no files changed;
- `effigy check:posture-advisory` — pass with zero warnings;
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- `git diff --check` — pass.

## Next Task

Use Northstar in a real Rust repository. The agent should activate the pack
itself and ask only for unresolved repository policy.
