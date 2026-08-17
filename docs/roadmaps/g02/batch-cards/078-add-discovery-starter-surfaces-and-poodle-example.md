# 078 - Add Discovery Starter Surfaces and Poodle Worked Example

Status: ready
Owner: repo maintainers
Updated: 2026-08-17
Master spec refs: `docs/specs/027-northstar-native-pre-execution-discovery.md`
Governing refs: `docs/contracts/001-working-rules.md`,
`skills/northstar/references/modes/pre-execution-discovery.md`,
`template-bundle/README.md`,
`scripts/README.md`
Auto-start next card: no

## Ready-State Checks

- [x] Objective is bounded enough to finish without fresh planning decisions.
- [x] Governing refs point at current canonical surfaces.
- [x] Scope boundaries and stop conditions are explicit.
- [x] Acceptance criteria, validation, and evidence requirements are explicit.
- [x] No unresolved planning gap still governs this card.
- [x] No unresolved intent checkpoint still governs this card.
- [x] The next transition is deliberately not auto-started: live consumer use is
      operator-owned and Northstar does not dispatch a consumer run.

## Objective

Add copy-ready starter surfaces for the Batch 26.2 discovery routes, a
self-contained docs-native worked example for Poodle destination `g15.006`, and
the explicit promotion record that turns a cleared readiness map into normal
spec and roadmap work without granting the map execution authority.

## Lane Runway Context

- Higher-level lane owner: `g02.026` Northstar-native pre-execution discovery.
- Next likely cards or milestone transitions after this one: consume
  operator-provided feedback from live use of the complete discovery flow;
  architecture refocus is now implemented, while reframe remains pending.
- Next planning checkpoint: after the operator supplies feedback, review planning revisions,
  reopened decisions, implementation rework, and operator correction burden
  before Batch 26.4.

## Scope

- Add section-local copy-ready templates under `template-bundle/specs/templates/`
  for:
  - readiness maps;
  - canonical decision records;
  - destination-local project language;
  - cleared-map promotion records.
- Add a `template-bundle/specs/templates/README.md` index explaining which
  template is copied, which fields are authoritative, and which fields cannot
  grant execution authority.
- Add a self-contained worked example under
  `template-bundle/specs/examples/poodle-g15-006/` showing:
  - the bounded destination `g15.006 — React Mirror Implementation and Gallery
    Closure`;
  - Poodle-local project language for release denominator, measured gap, React
    mirror, focused evidence, gallery specimen, active cohort, and deferred
    backend;
  - linked decision records and a deterministic frontier;
  - a cleared-map promotion record targeting a normal Poodle spec/roadmap path;
  - an explicit example-only warning so the bundle cannot be mistaken for a
    live Poodle-repository change.
- Add a copy-ready validation fixture or equivalent deterministic coverage for
  the example map and its decision links, without making the example a live map
  in the Northstar repository.
- Update template-bundle, operator/setup, and pre-execution-discovery guidance
  so the starter surfaces are discoverable from the existing single public
  `northstar` skill and docs spine.
- Record any operator-provided consumer feedback and the baseline posture
  observed during planning; do not select a consumer target or modify
  `/Users/tom/Dev/projects/poodle` in this card.

### Explicitly out of scope

- no changes to Poodle source, contracts, roadmap status, or readiness state;
- no consumer-dogfood dispatch or Figmatic repository changes;
- no architecture refocus or reframe route;
- no second public skill or external tracker;
- no automatic map clearing, spec promotion, card readiness, or worker dispatch;
- no new provider-specific API, network service, or production-code prototype;
- no redesign of the deterministic readiness checker beyond the narrow fixture
  coverage required to prove the starter example.

## Steps

1. Add the four section-local templates and their index, preserving the existing
   Markdown/YAML-frontmatter contract and Northstar vocabulary.
2. Build the Poodle `g15.006` example from repository facts in the release
   baseline roster, gap register, generation README, and card 006. Keep the
   example internally linked and clearly non-live.
3. Add deterministic fixture coverage proving the example's map, links,
   dependency direction, and cleared frontier are valid.
4. Update the operator/setup and route references to point at the starter
   surfaces without duplicating their field lists.
5. Run the narrow fixture/checker commands, then the full docs/bundle QA and
   installed-skill parity checks where the touched surfaces require them.
6. Record the exact changed files, validation, remaining baseline findings, and
   any operator-provided consumer feedback in the batch log.

## Acceptance Criteria

- all four templates are copy-ready, have explicit authority boundaries, and do
  not introduce a second decision or question store;
- the example includes the Poodle-local terms with aliases, meanings, authority,
  status, and rejected ambiguities;
- the example map has no missing links, orphan decisions, cycles, or false
  readiness claims;
- the promotion record distinguishes map evidence from operator approval and
  names the normal spec/roadmap targets without mutating them;
- the example is discoverable from the relevant template-bundle and operator
  guidance surfaces;
- existing readiness fixtures still pass and the new example coverage passes;
- no Poodle or Figmatic repository files changed;
- `git diff --check`, `effigy qa:docs`, `effigy check:readiness-map`,
  `effigy test:readiness-map`, and `effigy doctor` pass for Northstar, with any
  pre-existing findings explicitly recorded rather than silently attributed;
- the worker/PR loop remains available for this docs-and-fixture implementation.

## Evidence Required

- exact changed-file list and `git diff --check`;
- readiness checker/test output including the starter example;
- docs QA and bundle QA output;
- installed-skill parity output if skill references are touched;
- `effigy doctor` output and a note separating baseline findings from new work;
- a batch log with the Poodle source paths used and the no-consumer-repo-change
  boundary;
- a reviewable PR; no merge by the worker.

## Continuation Envelope

- Auto-start next card: no
- In-bounds next card: none; consumer use is operator-owned and any feedback
  returns here as evidence rather than a Northstar-managed handoff
- Remaining ready chain after this card: 0
- Transition proof required before the next task: merged starter surfaces,
  example validation, and an operator-provided feedback intake point

## Lane Budget

- Current card ends budgeted run: yes
- Further operator decision required after this card: yes — which supplied
  feedback, if any, should be promoted into the planning spine
- Pause signal if run stops here: operator-feedback-required

## Stop Conditions

- the example requires inventing Poodle behavior not present in the cited source
  docs;
- a template would make a readiness map, decision record, or promotion record
  authoritative without an operator gate;
- the fixture requires changing the live readiness checker contract beyond the
  bounded example case;
- the work touches Poodle or Figmatic repositories;
- the implementation expands into architecture refocus, reframe, or worker/PR
  contract changes;
- a new planning branch appears that is not settled in the governing refs.

## Completion Notes

To be filled after the isolated worker/PR loop. The completed card must state
whether the example remained copy-ready, whether the checker proved its map
state, and which baseline findings were pre-existing.

## Closeout Sequence

- [ ] Update this card's status and completion notes first.
- [ ] Update the active roadmap milestone if progress, readiness, or the next
      batch changed.
- [ ] Update front-door currentness surfaces that name the active lane, ready
      card, or recent evidence chain.
- [ ] Write the batch log with evidence, validation actually run, and unresolved
      blockers or limits.
- [ ] Record whether the continuation envelope still holds or the handoff pause
      signal fired.
- [ ] Record operator-provided consumer feedback after this card is merged;
      Northstar does not create a dogfood handoff or select the consumer target.
- [ ] Leave one explicit next task in the highest-authority active surface.

## Next Task

Run card 078 through the isolated worker/PR loop. After its merge and closeout,
consume any operator-provided live feedback through the normal planning surfaces;
do not create a consumer dogfood handoff or dispatch Figmatic.
