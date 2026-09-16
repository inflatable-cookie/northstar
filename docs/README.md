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
<!-- northstar:lifecycle:begin schema=northstar.lifecycle.projection.v2 digest=sha256:c0c57e5803d263d233a97fd875d59b1be02b8a37d33109b9253adebad4d627e4 -->
| Generation | Disposition | Runway state |
| --- | --- | --- |
| g03 | open | planning_required |
| Task | Status | Stage | Revision | Record digest |
| --- | --- | --- | --- | --- |
| g03.006 | complete | none | 8 | sha256:025066786b2d9af4821307a2b06b15b6cab8bf47a4a816db22bed66b9faa8c9b |
| g03.007 | complete | none | 8 | sha256:a5b8006f700e791ff4bb68f504746a9f2431bb1711abd70292673e536a80b9ad |
| g03.008 | complete | none | 8 | sha256:888d75786d747f9965efa51b4b492c005aaf967a8f6504715e3b6be0f2760099 |
| g03.009 | complete | none | 8 | sha256:c8a09f2d3daad05e3b90235bc50f256c3932eeddaee668adecd9dad1183ac8e2 |
| g03.010 | complete | none | 8 | sha256:109f4252bc5259b1cc87938aed24095f99dcf687d9236c93b32d1bd5e7ce537d |
| g03.011 | complete | none | 8 | sha256:b006beb373606185905bfa5b56fd4a1f87dc3accb80141a82be312efdd5206dc |
| g03.012 | complete | none | 8 | sha256:2ea341f845521a3162fc405e6528fb40d08b4e30b555b3de3af819f3c8bfc649 |
| g03.013 | complete | none | 8 | sha256:b04543c372ffeb75b3fd0813e7f541f216d22f3c6bd3cb03dcd5e175ea225374 |
| g03.014 | complete | none | 8 | sha256:625cb1913c3e02eedff7bfde13b7739bab45ac45d5017c550df775b210ab95dd |
| g03.015 | complete | none | 8 | sha256:c1035ad4e0adc5dec9a9723c622acadf1e2ab689883f1711e4f2c435ac519df8 |
| g03.016 | complete | none | 8 | sha256:a841a07bb97a64cf4d2bc3f5d3fb4f76c990d07c46d47fded5db68aa6c9c16be |
| g03.017 | complete | none | 8 | sha256:4fc88cc4206d2d2427a825759ee29a12540285a0816248e2d3feda85207cf988 |
| g03.018 | complete | none | 8 | sha256:f2d73b780dd1f0701b02c078dd8a255629f16a647d90d1d7ddea9138c07f58c3 |
| g03.019 | complete | none | 8 | sha256:76d6a4c9b2956db2e27f351809da4cc0222eeac31ef4d4789468b76ce198bc30 |
| g03.020 | complete | none | 8 | sha256:da733286412d8cdf4c1e56ba0e48ea434e92539dd6da3f84b642da8ad809e3be |
<!-- northstar:lifecycle:end -->
