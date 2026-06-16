# Normalize docs posture

Keep the repo's Northstar-shaped `docs/` tree correct over time—not only on
first bootstrap. Use for greenfield setup, migration, and periodic spine
hygiene when front doors, generation index, or strict surfaces drift.

## References (load as needed)

- [`../setup/repo-contract.md`](../setup/repo-contract.md)
- [`../setup/adoption-modes.md`](../setup/adoption-modes.md)
- [`../setup/delivery-layer-adoption.md`](../setup/delivery-layer-adoption.md)
- [`../setup/workspace-container-example.md`](../setup/workspace-container-example.md)
- [`../setup/monkey-example.md`](../setup/monkey-example.md)
- Templates: [`../../assets/templates/`](../../assets/templates/)
- Doctrine: [`../../../../bundle-docs/protocol-kernel.md`](../../../../bundle-docs/protocol-kernel.md)

## Quick start

```sh
effigy tasks
effigy doctor
effigy test --plan
```

Read `README.md`, `AGENTS.md`, `docs/README.md`, `docs/roadmaps/generation-index.md`.
Optional: `effigy check:posture-advisory` after structural edits.

## Workflow

1. Classify posture: baseline vs strict vs lane-first migration vs full strict
   target; record blocking gaps in an active spec/milestone when migrating.
2. Choose adoption mode (single repo, workspace container + docs authority, or
   compatibility only when the installed Effigy binary lacks needed surfaces).
3. Apply spine from [`../../../../template-bundle`](../../../../template-bundle)—
   baseline or strict deliberately, not a permanent mixed posture.
4. When strict: install `product-guardrails`, `contract-index`,
   `001-working-rules`, `specs/`, `specs/archive/README.md`, batch-cards as
   warranted. Explain specs as provisional; archive when canonical surfaces
   carry truth.
5. Select templates from `assets/templates/` (Effigy native vs docs-authority
   vs compat). Verify native Effigy with `effigy docs --help` before assuming
   compat mode.
6. Runtime stack: Effigy first; TypeScript+Bun for repo scripts; bash/python
   only by exception.
7. Validate: `effigy qa`, `effigy qa:docs`, project-specific checks.
8. Keep the live `Next Task` pointer in the roadmap front doors. Other front
   doors may summarize state or dependencies, but should not each own the
   active thread pointer.

## Required outputs (when applicable)

- `README.md`, `AGENTS.md`, `effigy.toml`, `docs/README.md`, vision/roadmaps/logs
  front doors, `docs/policy/internal-writing-style.md`
- Strict: guardrails, contract index, working rules, specs README + archive,
  batch-card templates under active `gNN/`

## Guardrails

- No pre-1.0 compat shims on code/automation without operator approval.
- No `--repo .` in docs examples for current-repo use.
- No invented docs tree when template-bundle covers the need.
- No routine bash/python when Effigy or TS covers the job.
- Do not treat one strict lane as full-repo compliance without a migration plan.

## After normalize

If the next job is planning or milestones, switch via
[`../router.md`](../router.md) to a planning or recovery mode—not a separate
skill.
