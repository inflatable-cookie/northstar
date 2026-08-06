# Papercuts

Small, actionable friction found during agent work. Agents append entries when
they hit a solvable hurdle; they do not stop the current task to fix one.

## Open

<!-- Keep entries short. Append newest entries at the top. Do not include secrets. -->

### [x] Inline Effigy Rhai task shape was unclear — 2026-08-06
- Friction: the first inline `effigy.toml` declaration used a table-valued `run`, but this manifest surface expects a run-step array for `{ rhai = ... }`.
- Impact: the task failed Effigy doctor before the script could run.
- Possible fix: make the supported inline Rhai task shape more prominent in the local Effigy adoption guidance.
- Surface: `effigy.toml` task declaration / Effigy manifest schema
- Resolution: changed the task to `[{ rhai = "scripts/check-northstar-skill-install.rhai" }]` and verified the task end to end.

### [x] Rhai expression complexity penalizes nested values and diagnostics — 2026-08-06
- Friction: the TypeScript-to-Rhai translations initially used nested regex values and multi-part diagnostic expressions that Effigy rejected before execution.
- Impact: the posture and repo-contract tasks could not start until those expressions were simplified.
- Possible fix: keep Rhai checks on scalar string operations, assign intermediate values, and avoid nested capture access in diagnostics.
- Surface: `scripts/check-northstar-posture-advisory.rhai`, `scripts/check-northstar-repo-contract.rhai` / Effigy Rhai expression limits
- Resolution: normalized values before matching and assembled diagnostics incrementally; both tasks now run end to end.

### [x] Effigy reserves `--repo` before task arguments — 2026-08-06
- Friction: the TypeScript checker accepted `--repo <path>`, but Effigy consumes `--repo` globally to select the catalog before the Rhai task receives arguments.
- Impact: the converted task routed into the target repository and failed when that repository did not define Northstar's task.
- Possible fix: document task-specific target paths separately from Effigy's global catalog selector.
- Surface: `effigy check:posture-advisory` invocation contract
- Resolution: use a positional target path, or the explicit `northstar/check:posture-advisory` catalog selector plus a positional path.

### [x] Repo contract checker trips a god-file warning — 2026-08-06
- Friction: `effigy doctor` flags `scripts/check-northstar-repo-contract.ts` at 281 code lines / 292 total because its required-file manifest and content assertions live in one checker.
- Impact: the validation surface is harder to navigate and every new canonical surface increases the warning pressure.
- Possible fix: split the manifest/assertion groups into focused check modules while keeping one bounded `qa:docs` entry point.
- Surface: `scripts/check-northstar-repo-contract.ts` / Effigy doctor
- Resolution: extracted the manifest, then migrated the checker to `scripts/check-northstar-repo-contract.rhai` with native Effigy docs checks; the doctor warning is gone.

### [x] Canonical published-skill update path is undocumented — 2026-08-06
- Friction: propagation guidance initially fell back to manual `rsync` before checking the installed `npx skills update` workflow and its global agent fan-out.
- Impact: makes a routine multi-harness refresh look more manual and error-prone than necessary.
- Possible fix: document `npx skills update northstar -g -y` after publishing, with local `rsync` marked as development-only.
- Surface: skill distribution / setup docs
- Resolution: published and local-development paths are now documented in
  `bundle-docs/skills/README.md` and `scripts/README.md`; source/install parity
  has a repeatable checker.

### [ ] Graph orientation is noisy when the index is stale — 2026-08-06
- Friction: `effigy graph explore --json` returned a large stale-index path listing instead of useful excerpts; a separate index command was needed before graph output became useful.
- Impact: adds discovery work and floods the agent context during repository orientation.
- Possible fix: make stale-index graph output concise and emit one clear `effigy graph index` next action by default.
- Surface: Effigy graph / Northstar agent workflow
