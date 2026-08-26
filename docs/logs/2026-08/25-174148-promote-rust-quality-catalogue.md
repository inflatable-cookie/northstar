# Promote Rust Quality Catalogue

Date: 2026-08-25
Roadmap: `g02.030`
Card state: `g02.030/084` complete; `g02.030/085` ready

## Outcome

- promoted one seven-rule production catalogue under the existing installable
  `northstar` skill;
- retained six approved normative rules and one prototype,
  evaluation-only/report-only slop input;
- made `strict` the only production-valid profile while retaining ordinary and
  high-assurance values as unvalidated model inputs;
- added catalogue, consumer-profile, audit-manifest, audit-unit, and
  audit-result schemas;
- materialized strict authoring and audit views and mechanically compare both
  against the canonical record;
- added one Effigy-native package check with six negative authority, maturity,
  profile, and provenance regressions;
- raised source and skill-local minimum Effigy versions to `0.8.4`.

## Payload And Context

The production data and check occupy 90,053 bytes:

- eight JSON files under
  `skills/northstar/references/language-quality/rust/`: 77,052 bytes;
- `skills/northstar/scripts/check-rust-quality.rhai`: 13,001 bytes.

`skills/northstar/SKILL.md` and `references/router.md` did not change, so this
batch adds zero bytes to default agent context. The 15,327-byte authoring view
and 18,055-byte audit view are inert references. Card 085 will add a compact
Rust route and load the authoring view only for applicable work; explicit audit
will remain a separate on-demand route.

## Production Identity

- catalogue SHA-256:
  `7949fd7238d1a374b577164fea5a780a1c048015d5efd3617afd1c2c9e7853bd`;
- authoring projection SHA-256:
  `329353ba0a02449c5498f3aa4222614139b18b840205a9856a7bf9fb104d75a3`;
- audit projection SHA-256:
  `fe1d301774f2f52c143feee6d0e8fb44ab614130120eb64c2330e5f91630ca93`;
- projected rules: seven in each view;
- isolated installed-like payload: 58 files.

The payload contains no benchmark answer key, expected finding, fixture, or
hardcoded Rust `1.95` policy. MSRV applicability remains repository-derived.

## Boundary Correction

Card 084 initially named `northstar/test:rust-quality-recorder`, but card 086
owns the production recorder and pre-mutation `extend` lifecycle. The validation
step was removed from card 084 instead of creating a disconnected recorder
partial. Its future selector remains frozen in cards 086 and 088.

## Validation

- `jq empty` over all production JSON — passed;
- skill-creator `quick_validate.py skills/northstar` — passed;
- `effigy check:rust-quality` — passed: seven rules, strict-only, six negative
  paths;
- standalone skill copy with `PATH=/bin` — passed under Effigy `0.8.17`;
- `effigy check:skill-install <isolated-copy>` — passed for 58 files;
- `git diff --check` — passed;
- `effigy qa:docs` — passed;
- `effigy qa` — passed with the Rust package check in the normal validation
  path;
- `effigy check:posture-advisory` — passed with zero warnings;
- `effigy check:agent-instructions` — completed with unchanged root/template
  measurements and only the existing advisory classifications.

## Remaining Limits

- no Rust routing, authoring mode, consumer activation, audit mode, command, or
  production recorder exists yet;
- schemas describe the future audit records, but card 086 owns temporal recorder
  enforcement;
- ordinary, high-assurance, combined-default, observable-compaction, and
  certification claims remain unsupported.

## Continuation State

Card 084's lane budget is exhausted at a clean shared-foundation checkpoint.
Card 085 is ready, but its everyday-routing work does not auto-start in this
run. Pause signal: `budget-exhausted`.
