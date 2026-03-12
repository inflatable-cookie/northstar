# Monkey Example

`monkey` is the first concrete example for this skill.

## Compatibility Pass

The first pass proved the shared agent loop works even when a consuming repo
still needs repo-owned validation scripts.

What it taught:

- the contract is teachable
- native and compatibility modes must be explicit
- `PATH` can silently point at an older Effigy binary

## Native Pass

The follow-on pass moved `monkey` onto the native current-Effigy surface.

What changed:

- native `effigy docs` tasks replaced the temporary repo-owned checks
- `[docs_policy]` and `[release]` moved into `effigy.toml`
- docs and AGENTS switched to `effigy release ...` for release readiness

Use `monkey` as the baseline example when tightening the skill wording,
templates, and validation flow.
