# 025 - Skill Distribution And Consumer Papercut Proof

Status: retired-in-place  
Owner: repo maintainers  
Updated: 2026-08-06  
Vision refs: docs/vision/001-northstar-delivery-vision.md  
Governing refs: docs/contracts/001-working-rules.md, bundle-docs/papercuts.md  
Roadmap refs: g02.024

## Problem

Northstar's installed skill can fan out to several agent harnesses, but the
published update path and local source/install parity check were implicit. The
papercuts contract also needed proof in a real consumer repository.

## Target state

- published updates use `npx skills update northstar -g -y`
- `npx skills list -g --json` is the operator inspection path
- source checkouts can compare an installed skill tree with one deterministic
  read-only checker
- at least one consumer queue contains a real, actionable observation from the
  proof run

## Goals

- [x] document published versus local-development skill propagation
- [x] add a source-repo install-parity checker
- [x] run the papercuts loop in a clean consumer repository
- [x] triage the proof result without promoting it automatically into product
      work

## Non-goals

- [x] publish or release a new Northstar version from this batch
- [x] change the Skills CLI or Effigy behavior
- [x] automatically triage, issue, or prioritize papercuts
- [x] run a consumer repository's full validation suite as Northstar proof

## Artifact set

- `bundle-docs/skills/README.md`
- `scripts/check-northstar-skill-install.rhai`
- `scripts/README.md`
- `/Users/tom/Dev/projects/longhorn/PAPERCUTS.md` consumer evidence

## Validation

- global source/install parity checked after the prior published update
- the source-repo `effigy check:skill-install` task passes against `/Users/tom/.agents/skills/northstar`
- Longhorn `effigy tasks` and the bounded orientation attempt were observed
- the Longhorn queue gained one actionable entry; no automatic promotion occurred

## Closeout

The published update path is now explicit, local development is clearly
separated from published propagation, and one clean consumer repository has
proved that agents can record a papercut without operator intervention. The
consumer entry remains in Longhorn for normal maintenance triage.
