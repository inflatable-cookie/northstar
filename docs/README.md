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
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v2 digest=sha256:dd0d09bfe955233aa0b32f9414a29aeede9f66f097a01c15189e235ac25bb518 -->
| Generation | Disposition | Runway state |
| --- | --- | --- |
| g03 | open | planning_required |
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
| g03.006 | complete | none | 8 | sha256:025066786b2d9af4821307a2b06b15b6cab8bf47a4a816db22bed66b9faa8c9b |
| g03.007 | complete | none | 8 | sha256:a5b8006f700e791ff4bb68f504746a9f2431bb1711abd70292673e536a80b9ad |
| g03.008 | complete | none | 8 | sha256:888d75786d747f9965efa51b4b492c005aaf967a8f6504715e3b6be0f2760099 |
| g03.009 | complete | none | 8 | sha256:c8a09f2d3daad05e3b90235bc50f256c3932eeddaee668adecd9dad1183ac8e2 |
<!-- northstar:lifecycle:end -->
