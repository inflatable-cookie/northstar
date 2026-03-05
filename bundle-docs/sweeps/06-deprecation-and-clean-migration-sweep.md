# 06 Deprecation and Clean Migration Sweep

## Goal

Enforce clean migration policy: deprecate legacy folders without shim clutter and keep references consistent.

## Deprecated-by-Default Patterns

- `docs/meta/` as active per-project process source
- Root `decisions/` as canonical decision location
- Root `backlog/` outside `docs/roadmaps/backlog/`
- Compatibility shim docs kept in deprecated folders

## Rules

- Extract useful content into canonical folders.
- Rewrite references in the same batch.
- Remove deprecated files/folders once replacements are in place.
- No compatibility shim docs unless explicitly required by the user.

## Drift Patterns

- "Moved" placeholder docs left behind in deprecated paths
- Mixed references to both old and new paths
- Partial migrations that keep duplicate sources of truth

## Fix Rules

- Perform migrations as atomic doc batches:
  1. move content
  2. rewrite refs
  3. delete legacy artifacts
  4. log migration outcome

## Fast Checks

```bash
find docs -maxdepth 3 -type d | sort
rg -n "meta/|decisions/|backlog/|moved to|deprecated" docs
```

## Completion Criteria

- Canonical source-of-truth paths only.
- No deprecated-folder shim residue.
