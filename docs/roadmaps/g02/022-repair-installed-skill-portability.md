# 022 - Repair Installed Skill Portability

Status: complete
Owner: repo maintainers
Created: 2026-07-28
Depends on: g02.020
Vision tags: `skills`, `portability`, `validation`, `consumer-repos`
Contract refs: `docs/contracts/001-working-rules.md`
Planning state: complete

## Problem

`skills/northstar/` is documented as a one-folder install, but seven Markdown
links escape that folder. They resolve in the Northstar source tree and fail
after a normal detached install. Agents then improvise fallback behavior from
the target repo, and bootstrap mode also loses its `template-bundle/` source.

## Goals

- [x] define the portable skill boundary without copying doctrine into the skill
- [x] distinguish skill-owned references from optional target/source-repo paths
- [x] reject escaping or broken skill Markdown links in normal QA
- [x] refresh and prove the detached installed skill

## Non-Goals

- [ ] vendor `bundle-docs/` or `template-bundle/` into the skill
- [ ] redesign mode routing or activation
- [ ] add an online installer or compatibility fallback

## Contract Coverage

- [x] One-folder portability is already required by `README.md` and the skill
      architecture rules.
- [x] Repo-local authority and pre-1.0 clean migration rules are covered by
      `docs/contracts/001-working-rules.md`.
- [x] This is a single-repo repair with no cross-repo write dependency.

## Execution Plan

### Batch 22.1 - Repair The Portable Boundary

- [x] document which references must stay inside the installed folder
- [x] convert Northstar-source and target-repo dependencies into explicit,
      optional runtime paths
- [x] remove all seven escaping Markdown links

### Batch 22.2 - Enforce And Prove Portability

- [x] add a recursive skill-link guard to the repo contract checker
- [x] run source QA and a detached-copy audit
- [x] refresh the installed `northstar` skill and verify source/install parity

## Acceptance Criteria

- [x] every local Markdown link under `skills/northstar/` resolves inside that
      folder
- [x] missing `bundle-docs/` is explicitly normal in consumer repos
- [x] bootstrap work requires an explicit Northstar source checkout instead of
      assuming one beside the installed skill
- [x] `effigy qa` catches a future escaping or missing skill link
- [x] installed and source skill trees match after validation

## Risks and Mitigations

- Risk: removing source-relative links weakens navigation for Northstar
  maintainers.
- Mitigation: keep source-repo paths explicit as code literals and retain
  clickable doctrine links in repo-owned docs.

## Planning Gaps

- none

## Evidence Requirements

- [x] `effigy qa`
- [x] detached-copy link audit
- [x] source/install tree comparison
- [x] `docs/logs/2026-07/28-101319-repair-installed-skill-portability.md`

## Runway Notes

- Higher-level lane owner: g02 reusable bundle/skill hardening runway
- Immediate ready card: none; lane complete
- Next likely transition: next contract-backed g02 milestone
- Next planning checkpoint: when new runway work is queued

## Next Task

No remaining work in g02.022. Queue the next contract-backed g02 milestone when
new work is ready.
