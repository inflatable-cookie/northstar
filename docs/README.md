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

- Active generation: [`roadmaps/g04/README.md`](./roadmaps/g04/README.md)
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
from this page and the active `g04` runway; archives are provenance only.
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v2 digest=sha256:7b5d17b0bceb075bdacb18273d08eb1ce6c375375e4838c5adebf975b3b24495 -->
| Generation | Disposition | Runway state |
| --- | --- | --- |
| g04 | open | planning_required |
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
<!-- northstar:lifecycle:end -->
