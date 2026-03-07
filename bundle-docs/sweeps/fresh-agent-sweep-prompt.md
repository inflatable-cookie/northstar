# Fresh Agent Sweep Prompt

Use this prompt in a new agent thread to run a full Northstar drift repair.

## Copy/Paste Prompt

```text
Run the full Northstar docs sweep on this project and repair any drift.

Northstar sweep source of truth:
- bundle-docs/sweeps/README.md
- bundle-docs/sweeps/01-structure-sweep.md
- bundle-docs/sweeps/02-naming-and-keys-sweep.md
- bundle-docs/sweeps/03-format-and-sections-sweep.md
- bundle-docs/sweeps/04-roadmap-and-backlog-sweep.md
- bundle-docs/sweeps/05-logs-and-traceability-sweep.md
- bundle-docs/sweeps/06-deprecation-and-clean-migration-sweep.md
- bundle-docs/sweeps/07-research-sweep.md

Execution requirements:
1. Audit first, then list drift findings with exact file paths.
2. Fix in meaningful batches, not tiny edits.
3. Re-run checks after each batch and close findings.
4. Enforce clean migrations only: no compatibility shim docs.
5. Update references in the same batch as moves/renames.
6. Keep canonical structure, naming, and content contracts compliant.
7. Keep optional add-on folders (`research`, `schemas`, `templates`, `diagrams`, `specs`) absent unless explicitly needed by current project docs; if `docs/research/` is canonical, keep it Northstar-compliant instead of deleting it.
8. Add one batch log in docs/logs/YYYY-MM/ summarizing the sweep work.

Output requirements:
- files changed
- drift fixed
- validation checks run
- unresolved items (if any)
- next task
```
