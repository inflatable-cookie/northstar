# Run Signal Shadow Operator Pilot

Status: complete
Owner: repo maintainers
Date: 2026-04-09
Roadmap refs: g02.001 batch 1.2
Governing refs: docs/contracts/001-working-rules.md, docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md

## Summary

Ran the first real external Northstar pilot as a read-only shadow-operator pass
against `~/Dev/projects/signal`, using the active
`g09.003` VST3 lane as the live target. The run confirmed that Signal is a
better pilot than `monkey` because it has a real active batch chain rather
than only a structurally valid docs spine.

## Pilot Record

### Pilot Context

- Repo: `signal`
- Repo path: `~/Dev/projects/signal`
- Date: `2026-04-09`
- Operator: `codex`
- Starting request: `The thread is currently working through g09.003 around VST3 support. The most recent logs cover the work that thread has been doing.`
- Chosen entry point: `northstar-plan`
- Why this entry point was chosen: planning state in Signal is coherent and the
  task was to identify the valid next batch inside an active lane, not to
  recover drift or reopen planning
- Why this repo was chosen for the pilot: it has a live Northstar docs spine,
  Effigy-first repo posture, active generation `g09`, and a real current
  execution lane in `g09.003`

### Time To First Decision

- Minutes to choose first action: `2`
- Minutes to valid next batch: `7`
- First page opened: `~/Dev/projects/northstar/bundle-docs/operators/operator-quick-start.md`
- Additional pages opened before acting:
  - `~/Dev/projects/signal/README.md`
  - `~/Dev/projects/signal/AGENTS.md`
  - `~/Dev/projects/signal/docs/README.md`
  - `~/Dev/projects/signal/docs/roadmaps/generation-index.md`
  - `~/Dev/projects/signal/docs/roadmaps/g09/README.md`
  - `~/Dev/projects/signal/docs/roadmaps/g09/003-real-vst3-discovery-instantiation-and-lifecycle-proof.md`
  - `~/Dev/projects/signal/docs/logs/2026-04/09-001500-g09-003-vst3-broker-block-execution-tranche.md`
  - `~/Dev/projects/signal/docs/contracts/020-vst3-adapter-baseline-and-runtime-owned-lifecycle-contract.md`
  - `~/Dev/projects/signal/docs/contracts/072-real-plugin-hosting-discovery-and-sandbox-execution-contract.md`
- Pages opened in order:
  1. `bundle-docs/operators/operator-quick-start.md`
  2. `signal/README.md`
  3. `signal/AGENTS.md`
  4. `signal/docs/README.md`
  5. `signal/docs/roadmaps/generation-index.md`
  6. `signal/docs/roadmaps/g09/README.md`
  7. `signal/docs/roadmaps/g09/003-real-vst3-discovery-instantiation-and-lifecycle-proof.md`
  8. `signal/docs/logs/2026-04/09-001500-g09-003-vst3-broker-block-execution-tranche.md`
  9. `signal/docs/contracts/020-vst3-adapter-baseline-and-runtime-owned-lifecycle-contract.md`
  10. `signal/docs/contracts/072-real-plugin-hosting-discovery-and-sandbox-execution-contract.md`

### Decision Path

1. State assessment result: Signal is healthy and actively executing under a
   coherent roadmap lane; no sweep or recovery pass is needed.
2. Selected skill or starter prompt: `northstar-plan`.
3. Whether planning, replan, roadmap compilation, or refocus was required:
   neither broad planning nor recovery; the task was to identify and validate
   the next batch inside the existing roadmap lane.
4. Whether a handoff artifact was produced: no.
5. Whether any false start or wrong entry point had to be corrected: yes; the
   initial pilot target of `monkey` was corrected once it became clear there
   was no live work there, and one stale filename assumption for the Signal
   milestone had to be corrected before reading the active roadmap file.

### Useful Pages

- Page: `bundle-docs/operators/operator-quick-start.md`
  Why it helped: it was enough to confirm this was a `northstar-plan` path, not
  `northstar-recover`.

- Page: `signal/docs/roadmaps/g09/003-real-vst3-discovery-instantiation-and-lifecycle-proof.md`
  Why it helped: it exposed the exact active batch chain, current tranche
  outcomes, and the live next-task boundary.

- Page: `signal/docs/logs/2026-04/09-001500-g09-003-vst3-broker-block-execution-tranche.md`
  Why it helped: it clarified the latest landed tranche and the remaining gap,
  which made the next valid batch materially clearer than roadmap prose alone.

### Redundant Or Low-Value Pages

- Page: `bundle-docs/maintenance/operator-workflow-drill.md`
  Why it felt redundant: once the target repo and active lane were explicit,
  the full drill sequence was broader than the actual decision path required.
  Suggested action: trim

- Page: `bundle-docs/operators/live-project-refocus-specimen.md`
  Why it felt redundant: it is useful for drifted projects, but it was not part
  of the shortest path for a healthy active repo with a clear current lane.
  Suggested action: keep

### Ambiguities

- What was unclear: the operator surfaces still lean heavily toward recovery
  and refocus, while the real healthy-repo path was mostly about getting from
  repo entry surfaces to the active milestone and current tranche log quickly.
- Which page or skill caused the ambiguity: the operator doc cluster overall,
  especially `maintenance/operator-workflow-drill.md`.
- Suggested fix: make the operator front door distinguish healthy active repos
  from drifted repos more aggressively, and push the heavier drill/support
  pages further behind the quick start.

### Outcome

- Was the correct entry point chosen: yes
- Did the operator reach a valid next batch: yes
- Did any doc encourage the wrong action: no, but several docs implied more
  support depth than the healthy repo actually needed
- Which docs or prompts were decisive vs incidental:
  - decisive: `operator-quick-start.md`, Signal `generation-index.md`,
    `g09/README.md`, `g09.003` milestone, latest tranche log
  - incidental: the deeper operator drill/support cluster

## Files Changed

- updated `docs/specs/archive/batch-cards/014-select-consumer-repo-pilot-target.md`
- updated `docs/specs/archive/batch-cards/015-run-consumer-repo-pilot.md`
- updated `docs/specs/archive/004-consumer-repo-pilot-and-consolidation.md`
- updated `docs/roadmaps/g02/001-run-consumer-repo-pilot-and-consolidate.md`
- updated `docs/roadmaps/g02/README.md`
- updated `docs/roadmaps/generation-index.md`
- updated `docs/README.md`
- updated `docs/contracts/001-working-rules.md`

## Validation

- `effigy qa`
- `effigy qa:docs`

## Outcome

- the first external pilot is now grounded in a real active consumer-repo path:
  `~/Dev/projects/signal`
- Northstar now has evidence that the healthy active-repo path is shorter and
  more repo-doc-driven than the current operator support cluster implies
- the next batch should consolidate the operator front door around that finding

## Unresolved

- the operator docs have not yet been consolidated from the pilot evidence
- `g02.001` still needs its consolidation batch to land before the generation
  can close

## Next Task

Start batch 1.3 by consolidating the operator docs around the shorter healthy
active-repo path the Signal pilot exposed.
