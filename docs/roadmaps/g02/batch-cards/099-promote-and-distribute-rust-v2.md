# 099 - Promote And Distribute Rust V2

Status: complete
Owner: repo maintainers
Updated: 2026-08-27
Master spec refs: `docs/specs/033-rust-audit-v2-tool-enforcement.md`
Roadmap ref: `g02.032`
Governing refs: `docs/contracts/004-language-quality-pack.md`, card 098,
`bundle-docs/skills/README.md`
Auto-start next card: no

## Objective

Distribute the exact passing Rust v2 payload and close the lane without
overstating detector coverage or assurance.

## Scope

- source and configured install parity;
- router, modes, setup, tasks, schemas, recorder, evidence adapters, catalogue,
  projections, tests, and operator documentation;
- architecture, contract, spec, roadmap, index, and log closeout;
- no release mutation or consumer-repository change.

## Acceptance criteria

- [x] source and installed skill payloads match exactly;
- [x] one Northstar skill exposes the existing two Rust tracks with no new
  top-level skill;
- [x] ordinary Northstar context remains lean and explicit audit remains
  on-demand;
- [x] deterministic checks reject route, schema, catalogue, task, detector,
  evidence, and parity drift;
- [x] full QA and install verification pass;
- [x] unsupported profiles, rules, tools, and assurance claims remain explicit.

## Validation

Run package, setup, scope, recorder, adapter, command, install-parity,
agent-instruction, bundle, docs, posture, full QA, and diff checks.

## Evidence

Revision E is distributed unchanged as one 120-file skill payload. Source and
configured install share aggregate SHA-256
`5fae235aafd890a22d77ae51b96896b4855a41ed24e5adb517450a3c07795dea`;
the embedded/source engine payload remains
`dab44a149ee02bc17777e575f42b8857685031a2e0ee21cbc66a981624ff471f`.
See `docs/logs/2026-08/27-091043-promote-and-distribute-rust-v2.md`.

## Stop conditions

- stop if distribution differs from the evidenced payload;
- stop if installed automation expands always-loaded context or audit authority;
- stop before release mutation or consumer-repository changes.

## Next task

Lane complete. Accept operator-provided live-use feedback; Northstar does not
dispatch consumer audits.
