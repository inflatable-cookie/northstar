# Papercuts

Small, actionable friction found during agent work. Agents append entries when
they hit a solvable hurdle; they do not stop the current task to fix one.

## Open

<!-- Keep entries short. Append newest entries at the top. Do not include secrets. -->

### [ ] Graph orientation is noisy when the index is stale — 2026-08-06
- Friction: `effigy graph explore --json` returned a large stale-index path listing instead of useful excerpts; a separate index command was needed before graph output became useful.
- Impact: adds discovery work and floods the agent context during repository orientation.
- Possible fix: make stale-index graph output concise and emit one clear `effigy graph index` next action by default.
- Surface: Effigy graph / Northstar agent workflow
