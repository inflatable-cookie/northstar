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

## What Lives Here

- `sections/` defines the doctrine
- `sweeps/` defines audit and cleanup passes
- `operators/` holds the human-facing operator workflow docs
- `maintenance/` holds pilot, pruning, and maintenance-only operator-stack docs
- `skills/` explains how the public skill surface should stay small and stable
- the remaining files at this level are migration or maintenance guidance

## Useful Entry Points

- Audit or migration work: [`sweeps/README.md`](./sweeps/README.md)
- Operator workflow: [`operators/README.md`](./operators/README.md)
- Operator-stack maintenance: [`maintenance/README.md`](./maintenance/README.md)
- Skill architecture: [`skills/README.md`](./skills/README.md)
- Deprecated `meta/` migration: [`meta-folder-migration.md`](./meta-folder-migration.md)

## Governance posture

Northstar intentionally favors lean governance over heavy operational overhead.
Use scripts/checkers selectively, and default to concise batch-level logs with concrete evidence.
When research exists, keep it source-backed, problem-led, and explicitly promoted into specs, architecture, or roadmaps only after synthesis.
When the research corpus starts driving implementation repeatedly, add navigation and promotion-tracking artifacts instead of relying on tribal memory.
When delivery spans multiple repos or high-risk boundaries, tighten execution:
planning coverage must be explicit, contracts must exist before roadmap work,
and agents must stop on planning gaps instead of inferring missing system
behavior.
