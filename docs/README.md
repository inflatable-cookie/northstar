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
- Last completed task: `g03.005` portable lifecycle core
- Active task: [`g03.006` portable lifecycle adoption](./roadmaps/g03/006-adopt-portable-lifecycle.md)
- Approved frontier: `g03.006`; explicit execution authorization required
- Active spec: [`040-portable-task-lifecycle.md`](./specs/040-portable-task-lifecycle.md)
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
- `handoffs/` is transient transport and is pruned after consumption.

Closed generations and superseded procedure are not current authority. Start
from this page and the active `g03` runway; archives are provenance only.
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v1 digest=sha256:b61aa082aa7612cc3d8848350f8e5de1ab59472b2c4f7b4c6cba74ae9d93228a -->
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
| g03.006 | complete | none | 8 | sha256:025066786b2d9af4821307a2b06b15b6cab8bf47a4a816db22bed66b9faa8c9b |
<!-- northstar:lifecycle:end -->
