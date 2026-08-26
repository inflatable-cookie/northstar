# Prove Rust Quality Production Boundary

Date: 2026-08-25
Roadmap: `g02.030`
Card state: `g02.030/083` complete; `g02.030/084` ready

## Outcome

- selected Effigy-native Rhai as the production recorder runtime;
- rejected Bun/TypeScript and Bash/`jq` because neither is a declared portable
  consumer prerequisite;
- proved the recorder from a copied standalone skill root against a sibling
  consumer repository with Bun, `jq`, Git, and the Northstar checkout hidden;
- froze one installable-skill boundary, exact payload paths, public selectors,
  profile/deviation locations, and `/northstar-rust-audit`;
- strengthened the lifecycle to `init -> assess -> mutate -> complete ->
  finalize`, so a repair plan cannot be invented after mutation;
- kept Rust `1.95` confined to evidence fixtures. Production resolves MSRV from
  repository Cargo/toolchain policy and stops when that policy is unsettled.

## Runtime Decision

| Candidate | Required consumer runtime | Result |
| --- | --- | --- |
| Effigy-native Rhai | Effigy `>=0.8.4` | selected; JSON, file, SHA-256, and temporary-directory support are built in |
| Bun + TypeScript | Effigy and Bun | rejected; Bun is not a Northstar consumer prerequisite |
| Bash + `jq` | Effigy, POSIX shell, `jq`, platform utilities | rejected; platform-specific and exposed prior shell/Seatbelt friction |

The production recorder is
`skills/northstar/scripts/rust-quality-recorder.rhai`. It is dispatched from
the installed skill with
`effigy --repo <installed-northstar> northstar/rust-quality:record <operation>`
and launches no subprocess. The package minimum Effigy version becomes `0.8.4`
when card 084 materializes the production task.

## Frozen Product Shape

- catalogue, schemas, and strict projections:
  `skills/northstar/references/language-quality/rust/`;
- modes: `skills/northstar/references/modes/rust-quality-authoring.md` and
  `rust-quality-audit.md`;
- scripts: `rust-quality-recorder.rhai` and `check-rust-quality.rhai`;
- adapter: `skills/northstar/commands/northstar-rust-audit/SKILL.md`;
- copy-ready profile surface:
  `skills/northstar/assets/templates/language-quality/rust/`;
- consumer authority:
  `docs/contracts/rust-quality-profile.json` and
  `docs/contracts/rust-quality-deviations.json`;
- audit evidence:
  `<target>/.effigy/rust-quality/audits/<audit-id>/`;
- selectors: `northstar/check:rust-quality`,
  `northstar/test:rust-quality-recorder`, and
  `northstar/rust-quality:record`.

An assessed production unit will own a non-empty, disjoint file set. Findings
must locate inside that set; changes must remain a subset. Card 086 owns the
production `extend` operation for justified scope widening before mutation.

## Evidence

`bundle-docs/research/prototypes/rust-quality/production-boundary/` contains the
candidate matrix, standalone fixture, Rhai recorder probe, and shell
orchestration. The probe passed one positive and seven negative paths:

- unsupported profile;
- cross-unit evidence;
- report-only unsafe repair;
- slop-only repair;
- MSRV policy mutation;
- unattributed mutation;
- applied repair without local validation evidence;
- one reviewed repair with derived changed-file, authority, and validation
  evidence.

The CLI path separately passed `init`, `assess`, `complete`, and `finalize` from
the installed-skill copy and emitted a non-empty aggregate result.

## Validation

- `bash -n .../production-boundary/self-test.sh` — passed;
- `shellcheck .../production-boundary/self-test.sh` — passed;
- `.../production-boundary/self-test.sh` — passed;
- prototype `trial-runner.sh check` — passed, including the Rust `1.95` evidence
  matrix and current-toolchain compilation;
- prototype `trial-runner.sh self-test` — passed;
- `git diff --check` — passed;
- `effigy qa:docs` — passed;
- `effigy qa` — passed;
- `effigy check:posture-advisory` — passed with zero warnings;
- `effigy check:agent-instructions` — completed with only the existing advisory
  classifications; no files changed.

## Remaining Limits

- the proof uses one owned file per unit; production generalization and scope
  extension belong to card 086;
- no production catalogue, mode, adapter, or recorder exists yet;
- ordinary, high-assurance, combined-default, observable-compaction, and
  certification claims remain unsupported.

## Continuation State

Card 083's one-card envelope and Batch 30.1 lane budget are exhausted at a clean
checkpoint. Card 084 is ready with exact paths and commands. Do not auto-start
it in this run.
