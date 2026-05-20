# Research mode

Synthesize external evidence and promote into architecture and contracts before
roadmap work absorbs decisions implicitly.

## Reads

- `docs/research/master-index.md` when present
- relevant `docs/research/specimen-dossiers/`, `value-tracks/`, `translation-memos/`
- `docs/research/research-to-implementation-playbook.md`
- `docs/architecture/system-architecture.md`
- `docs/contracts/contract-index.md`

## Workflow

1. Frame the project problem and gather research inputs.
2. Synthesize recommendation, tradeoffs, open questions, validation needs.
3. Update or add translation memo when still too raw to promote.
4. Update architecture when system shape changes.
5. Update contracts when behavior, interfaces, or policy boundaries change.
6. Record remaining unknowns as planning gaps—not hidden in roadmap prose.
7. When contracts exist, continue via [`../router.md`](../router.md) →
   `compile-roadmaps.md` or `plan-from-scratch.md` as appropriate.

## Outputs

- translation memo or decision record when needed
- updated architecture and/or contracts and contract index

## Guardrails

- Do not promote raw research straight into roadmap batches.
- Do not skip contracts when research implies a concrete boundary.
