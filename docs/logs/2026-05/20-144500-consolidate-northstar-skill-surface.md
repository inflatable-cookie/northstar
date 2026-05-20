# Consolidate Northstar Skill Surface

Roadmap refs: (g02 hygiene — skill consolidation batch)

## What changed

- Replaced five installable skills with one **`skills/northstar/`** skill and a
  required [`references/router.md`](../../skills/northstar/references/router.md).
- Merged former setup/plan/recover/research/handoff procedures into
  `references/modes/` plus `references/setup/` and shared `assets/templates/`.
- Reframed setup as **`normalize-docs`** (ongoing spine hygiene, not one-shot only).
- Gated **handoff** behind explicit user language in the router; not for bare
  `continue` or compaction alone.
- Removed `skills/northstar-{setup,plan,recover,research,handoff}/` (no aliases).
- Updated `README.md`, `bundle-docs/` operator + skill docs, `AGENTS.md`, and
  `scripts/check-northstar-repo-contract.ts`.

## Validation

```text
$ effigy qa
Northstar bundle checks: OK
Northstar repo contract checks: OK
```

## Next task

Re-install `skills/northstar/` in agent skill homes that still point at the
retired five-skill paths; run one implicit planning thread and one explicit
handoff thread to confirm router classification.
