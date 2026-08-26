# Compile Rust Quality Production Roadmap

Date: 2026-08-25
Roadmap: `g02.030`
Card state: `g02.030/083` ready; cards 084-088 pending

## Outcome

- compiled one four-batch, six-card runway from contract 004;
- kept `northstar` as the single installable skill;
- selected two internal modes and a thin `/northstar-rust-audit` adapter as the
  planned public shape;
- made recorder/runtime portability a mandatory proof before production
  scaffolding;
- separated shared catalogue, everyday authoring, explicit audit, fresh blinded
  evidence, and distribution work;
- aligned architecture, inventory, contract, spec, research, and roadmap front
  doors to the new active lane.

## Readiness Decision

Card 083 is ready. Its scope is bounded to a disposable production-boundary
proof and a durable runtime/path decision. Cards 084 through 088 are deliberately
pending: they need the exact recorder runtime, payload paths, and commands from
that proof before they can satisfy the strict ready-state rubric.

The continuation envelope contains card 083 only. Its clean pause signal is
`budget-exhausted`; it must not auto-start implementation.

## Evidence

- contract 004 and revision F/M evidence are current;
- the active `g02` generation runway now includes language quality;
- all six cards name governing refs, scope, acceptance, validation, evidence,
  stop conditions, and next transition;
- currentness surfaces point to `g02.030/083` as the active Northstar-owned
  task;
- the stale docs contains-check workaround is recorded in `PAPERCUTS.md`.

## Validation

- `effigy qa:docs` — passed after preserving the superseded literal required by
  the currentness contains-check;
- `effigy qa` — passed;
- `git diff --check` — passed before log creation and rerun at final closeout.

## Remaining Limits

- no production Rust quality mode, catalogue payload, recorder, command, or
  selector exists yet;
- recorder runtime portability is unproven;
- ordinary, high-assurance, combined-default, and observable-compaction claims
  remain unsupported;
- no release or consumer-repository mutation was performed.

## Next Task

Execute `g02.030/083`. Freeze the production boundary or report the blocker;
do not scaffold cards 084-088 first.
