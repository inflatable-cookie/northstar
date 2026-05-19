# Bundle Docs

This directory explains how Northstar is supposed to work.

If you are:

- trying to understand the system, start here
- looking for operator-facing guidance, go to [`operators/README.md`](./operators/README.md)
- maintaining the operator stack itself, go to [`maintenance/README.md`](./maintenance/README.md)
- looking for copy-ready docs, go to [`../template-bundle/README.md`](../template-bundle/README.md)

The doctrine itself lives in `sections/`.
The main current sections are vision, architecture, roadmaps, logs, research,
strict planning gates, the delivery/autonomy layer, the specs-promotion
model, the standard docs spine, and the automation runtime policy.

## Effigy-First Loop

From the repo root:

```bash
effigy tasks
effigy doctor
effigy qa
```

Northstar is a docs/template repo, so the default Effigy surface is bundle-integrity validation rather than runtime build orchestration.

Use `--repo <PATH>` only when you intentionally want to operate on another
repository.

## Refactoring posture (agents)

Agents often add compatibility shims during refactors. Northstar’s stance is
**maturity-dependent**:

- **Before v1.0:** no opportunistic compatibility aliases, shims, wrappers, or
  silent fallbacks. Prefer clean migrations. If work would be **breaking**, stop
  and ask the project owner—do not invent a compat layer to dodge the decision.
- **From v1.0 onward:** default to **preserving expected behavior** for stable,
  user-visible, or externally depended surfaces. Material breaks need explicit
  owner policy, not silent removal.

Full doctrine: [`sections/07-delivery-framework-and-autonomy.md`](./sections/07-delivery-framework-and-autonomy.md) (heading *Refactoring posture by release maturity*). Stricter repos should also encode the same rules in `docs/contracts/001-working-rules.md` (start from [`../template-bundle/contracts/001-working-rules-template.md`](../template-bundle/contracts/001-working-rules-template.md)). This repo’s live contract: [`../docs/contracts/001-working-rules.md`](../docs/contracts/001-working-rules.md).

## What Lives Here

- `sections/` defines the doctrine
- `sweeps/` defines audit and cleanup passes
- `operators/` holds the human-facing operator workflow docs
- `maintenance/` holds pilot, pruning, and maintenance-only operator-stack docs
- `skills/` explains how the public skill surface should stay small and stable
- the remaining files at this level are migration or maintenance guidance

## Useful Entry Points

- New to the system: [`visual-map.md`](./visual-map.md) → [`glossary.md`](./glossary.md) → [`cheat-sheet.md`](./cheat-sheet.md)
- Audit or migration work: [`sweeps/README.md`](./sweeps/README.md)
- Operator workflow: [`operators/README.md`](./operators/README.md)
- Operator-stack maintenance: [`maintenance/README.md`](./maintenance/README.md)
- Agent skills (installable): [`skills/README.md`](./skills/README.md)
- Deprecated `meta/` migration: [`meta-folder-migration.md`](./meta-folder-migration.md)

## Agent Skills

Five public skills that agents can install and invoke:

| Skill | Use when |
|-------|----------|
| `northstar-setup` | Bootstrap or migrate a repo |
| `northstar-plan` | Plan from scratch or compile roadmaps |
| `northstar-recover` | Drifted plans, replanning, sweeps |
| `northstar-research` | Research intake and promotion |
| `northstar-handoff` | Thread continuation briefs |

Each skill lives in `../skills/<skill-name>/` and routes to internal modes.

## Quick reference

- [Visual map](visual-map.md) -- one-page overview
- [Glossary](glossary.md) -- terminology
- [Cheat sheet](cheat-sheet.md) -- naming, formats, commands

## Governance posture

Northstar intentionally favors lean governance over heavy operational overhead.
Use scripts/checkers selectively, and default to concise batch-level logs with concrete evidence.
When research exists, keep it source-backed, problem-led, and explicitly promoted into specs, architecture, or roadmaps only after synthesis.
When the research corpus starts driving implementation repeatedly, add navigation and promotion-tracking artifacts instead of relying on tribal memory.
When delivery spans multiple repos or high-risk boundaries, tighten execution:
planning coverage must be explicit, contracts must exist before roadmap work,
and agents must stop on planning gaps instead of inferring missing system
behavior.
