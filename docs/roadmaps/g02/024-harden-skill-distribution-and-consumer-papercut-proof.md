# 024 - Harden Skill Distribution And Consumer Papercut Proof

Status: complete
Owner: repo maintainers
Created: 2026-08-06
Depends on: g02.023
Vision tags: `skills`, `distribution`, `consumer-proof`, `agent-feedback`
Governing refs: `docs/specs/025-skill-distribution-and-consumer-papercut-proof.md`,
`bundle-docs/papercuts.md`
Planning state: complete

## Problem

The skill update path was less explicit than the installed multi-harness setup,
and the new papercuts queue had not yet been exercised outside Northstar.

## Goals

- [x] make the published Skills CLI path canonical
- [x] add a repeatable local source/install parity check
- [x] run the papercuts loop in one clean consumer repository
- [x] keep triage manual and bounded

## Execution plan

### Batch 24.1 - Document And Prove Skill Distribution

- [x] document `npx skills update northstar -g -y`
- [x] document `npx skills list -g --json` inspection
- [x] add the source-repo parity checker and contract coverage

### Batch 24.2 - Run Consumer Papercuts Proof

- [x] select clean Longhorn checkout as the consumer proof target
- [x] observe the standard Effigy orientation path
- [x] append the real health-task papercut to Longhorn's root queue
- [x] leave the item in the queue for normal maintenance triage

## Acceptance criteria

- [x] an operator has one canonical published update command
- [x] source/install drift can be detected without network access
- [x] a real consumer queue records a solvable execution hurdle
- [x] the proof does not modify consumer code or create automatic backlog work

## Evidence

- `scripts/check-northstar-skill-install.rhai`
- `/Users/tom/.agents/skills/northstar` matches `skills/northstar/`
- Longhorn `PAPERCUTS.md` contains the Effigy doctor/full-QA observation
- `docs/logs/2026-08/06-120000-harden-skill-distribution-and-consumer-proof.md`

## Next task

Compile the next g02 milestone from the consumer evidence. Keep the Longhorn
papercut in normal maintenance triage until it repeats or earns promotion.
