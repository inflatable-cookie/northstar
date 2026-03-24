# 08 Planning Gate Sweep

## Goal

Verify that planning is complete enough to authorize execution and that agents
cannot plausibly fill missing system behavior with assumptions.

## Applies When

- the project claims strict planning or contract-first execution
- active roadmap work spans multiple repos, services, or ownership boundaries
- recent delivery drift suggests agents have been inventing missing behavior

## Required Planning Gates

- `docs/architecture/system-architecture.md` defines the current system shape
- `docs/architecture/system-inventory.md` enumerates execution-relevant system
  elements, interfaces, validation surfaces, and planning gaps
- `docs/architecture/repo-authority-map.md` exists when more than one repo or
  authoritative deployable surface is involved
- `docs/contracts/contract-index.md` maps required boundaries to contracts or
  explicit pending items
- active roadmap milestones reference the contracts they depend on
- research-driven bets promote into architecture/contracts before roadmap
  execution

## Drift Patterns

- active roadmap work exists for repos or seams not listed in system inventory
- multi-repo work has no repo authority map
- contract index omits boundaries the roadmap clearly depends on
- milestones look executable but still rely on implied behavior
- planning gaps exist but are buried in prose instead of surfaced as blockers
- research recommendations were promoted straight into roadmap work with no
  contract layer

## Fix Rules

- Add or update the missing planning artifacts before allowing roadmap execution.
- Convert implied boundaries into explicit contracts or mark the milestone
  blocked.
- Add missing planning gaps to the relevant planning surface instead of hiding
  them in a roadmap risk list.
- When a roadmap generation is materially stale because planning changed,
  recompile or roll over the generation rather than patching around drift.

## Fast Checks

```bash
find docs/architecture docs/contracts docs/roadmaps -maxdepth 2 -type f | sort
rg -n "Planning Gaps|Contract refs|Planning state|pending|blocked" docs/architecture docs/contracts docs/roadmaps
rg -n "translation-memo|Promotion target|contract-index|repo-authority-map|system-inventory" docs/research docs/architecture docs/contracts docs/roadmaps
```

## Completion Criteria

- Every active roadmap area is represented in architecture, inventory, and
  contracts.
- Multi-repo authority is explicit wherever execution crosses repo boundaries.
- Missing planning is surfaced as a blocker, not silently bridged by roadmap or
  implementation prose.
