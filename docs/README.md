# Northstar Project Docs

This tree governs Northstar itself. It uses the same compact strict lifecycle
that Northstar provides to consumer projects.

## Current authority

- Direction: [`vision/001-northstar-delivery-vision.md`](./vision/001-northstar-delivery-vision.md)
- Architecture: [`architecture/system-architecture.md`](./architecture/system-architecture.md)
- Guardrails: [`architecture/product-guardrails.md`](./architecture/product-guardrails.md)
- Delivery contract: [`contracts/001-working-rules.md`](./contracts/001-working-rules.md)
- Agent surfaces: [`contracts/003-agent-instruction-surface.md`](./contracts/003-agent-instruction-surface.md)
- Language packages: [`contracts/004-language-quality-pack.md`](./contracts/004-language-quality-pack.md)

## Current work

- Active generation: [`roadmaps/g03/README.md`](./roadmaps/g03/README.md)
- Mechanical task state and delivery evidence: projected in the generated
  lifecycle block below and the roadmaps front doors, refreshed by the
  closeout hook at publication. Prose here stays semantic and is not
  hand-updated at closeout.
- Dispatch authorization for an open lane: that task's committed handoff and
  its dispatch manifest.
- Intake: [`triage/README.md`](./triage/README.md)
- Execution friction: [`../PAPERCUTS.md`](../PAPERCUTS.md)

## Authority chain

- `vision/` gives direction.
- `architecture/` defines system shape and guardrails.
- `contracts/` owns durable operating rules.
- `specs/` holds material planning before durable promotion.
- `roadmaps/` owns sequencing, dependencies, and ready execution.
- `triage/` holds unresolved mutable intake only.
- `logs/` retains exceptional evidence; normal delivery evidence closes on its
  task until generation roll-up.
- `handoffs/` is transient transport. The required closeout hook removes the
  consumed handoff when it publishes the terminal record; Git retains the
  blob.

Closed generations and superseded procedure are not current authority. Start
from this page and the active `g03` runway; archives are provenance only.
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v1 digest=sha256:85d2e348b9b559258f98662942025ccbce7e7f3aa9f56f39acb1fdf207bd6d2a -->
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
| g03.006 | complete | none | 8 | sha256:025066786b2d9af4821307a2b06b15b6cab8bf47a4a816db22bed66b9faa8c9b |
| g03.007 | complete | none | 8 | sha256:a5b8006f700e791ff4bb68f504746a9f2431bb1711abd70292673e536a80b9ad |
<!-- northstar:lifecycle:end -->
