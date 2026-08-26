# Add TypeScript And Svelte Explicit Audit

Date: 2026-08-26
Roadmap: `g02.031`
Card state: `g02.031/091` complete; `g02.031/092` ready

## Outcome

Northstar now has an explicit-only TypeScript/Svelte audit route backed by
package-aware agent setup and a case-local deterministic recorder. Ordinary
coding remains outside the route, and detailed audit content stays on-demand.

Setup handles declared workspaces and rootless mixed repositories, scopes
activation to the selected owner, records TypeScript evidence, and activates
Svelte 5/SvelteKit 2 overlays only with owned semantic source. It preserves
valid existing state and installs no dependencies.

The recorder enforces finding-before-mutation, disjoint units, pre-mutation
extension, action authority, exact changed-file attribution, dirty-state
preservation, and typed tool evidence. Warning-bearing zero-exit evidence is
not clean; pre-source tool failures remain unavailable with diagnostics.

## Evidence

- `production-route-report-2026-08-26-m.md`;
- setup: mixed workspace, rootless packages, overlay locality, preservation,
  idempotency, and two negative paths;
- recorder: four positive and eleven negative paths;
- copied standalone skill with `PATH=/bin`: package check, setup, and recorder
  selectors all pass;
- temporary copied payloads moved to Trash after validation.

## Next task

Execute `g02.031/092`. Freeze the production payload and run three fresh
isolated subjects plus blind reviewers. Do not tune the cohort after launch.
