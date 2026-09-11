# g03.004 UI Design Planning And Delivery

Status: complete
Owner: repo maintainers
Created: 2026-09-11
Governing refs: section 11, contract 001, system architecture; promoted from spec 039
Depends on: `g03.003` complete

## Outcome

Make UI quality a planned and reviewable part of Northstar delivery. Chatterbox
must settle the user workflow and material design direction before dispatch;
workers receive a self-contained brief and provider-neutral UI skill; reviewers
inspect the running exact PR head.

## Dispatch manifest

- **State:** ready after this planning commit is pushed to `main`; one lane, no
  concurrent siblings, no automatic successor.
- **Completion:** durable doctrine, source and installed skills, templates,
  structural fixtures, and exact-head review guidance implement spec 039;
  independent review accepts the exact head; PR merges; local `main` is
  synchronized; this task and front doors close.
- **Owned mutable paths:** `bundle-docs/**`, `template-bundle/**`,
  `skills/northstar/**`, the new UI skill source/install surfaces, relevant
  `scripts/**` and `effigy.toml` wiring, `docs/architecture/system-architecture.md`,
  `docs/contracts/001-working-rules.md`, `docs/specs/039-ui-design-planning-and-delivery.md`,
  this task, and its committed worker handoff.
- **Reserved closeout surfaces:** this task, `docs/roadmaps/g03/README.md`,
  `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`,
  `docs/README.md`, `docs/specs/README.md`, spec 039, and any justified compact
  evidence record.
- **Worker:** automatic adequate implementation pool. Spec 039 governs this
  skill-building lane; reviewer must use an independent provider/model identity.
- **Excluded:** consumer-product UI changes, a Northstar-owned renderer,
  mandatory external design tooling, aesthetic scoring, `.github/workflows/`,
  releases, new generation, history rewrites, and unrelated protocol cleanup.
- **Escalation:** Chatterbox owns scope, authority, and compatibility decisions.
  Stop if the implementation needs another canonical design document or weakens
  the operator prototype gate.

## Work

1. Promote spec 039's durable UI classification, brief, readiness, prototype,
   handoff, evidence, and exact-head review rules into the existing reusable
   doctrine, system architecture, working-rules contract, and copy-ready
   templates. Keep consumer product and design-system authority intact.
2. Update Chatterbox and pre-execution discovery so UI planning starts from the
   running current workflow, defines the ideal workflow, chooses the appropriate
   depth, and stops before dispatch when a material design choice remains open.
   Define the planning-only design delegate and operator selection boundary.
3. Extend the worker handoff contract and template with a self-contained
   `UI Design Brief` subsection under `Important Context`. Do not add or reorder
   top-level sections. Bind the copy back to its canonical spec or task.
4. Add the provider-neutral `northstar-ui` skill with build and review routes.
   Cover hierarchy, layout, typography, color, icons, copy, feedback,
   accessibility, responsiveness, states, realistic content, motion, bounded
   render-and-repair, and common model-generated UI failures without imposing a
   house aesthetic.
   Detect whether the consumer already has an adequate run-inspect-capture
   feedback loop. For substantial UI work, recommend a compatible companion
   when it does not; name Impeccable as one option without requiring it.
5. Route UI-marked implementation and review through the skill. Require the
   worker to exercise the scenario oracle and attach exact-head rendered
   evidence. Require the independent reviewer to run the exact head and treat
   material experience misses as blocking.
6. Add focused positive and negative fixtures for refinement, workflow change,
   substantial redesign, prototype selection, handoff placement, and false
   test-only or screenshot-only completion. Treat deterministic checks as a
   structural floor only.
7. Verify source/install and starter parity. Run focused fixture checks,
   `effigy qa:docs`, `effigy qa`, and `git diff --check` on the complete change.

## Acceptance and review oracle

| Invariant | Failing counterexample | Required proof |
| --- | --- | --- |
| Design precedes coding | A ready workflow-changing task leaves navigation, hierarchy, or states for the worker to choose | Full task brief and negative readiness fixture |
| Small work stays small | A local established-pattern correction is blocked on a prototype | Refinement fixture passes with its compact brief and no prototype |
| Substantial work has an operator checkpoint | A redesign becomes ready with only an agent-selected mockup | Negative fixture fails until operator-selected concept evidence is recorded |
| Handoff is executable transport | The worker must search planning history to reconstruct the approved experience | Seven-section fixture contains a self-contained brief under `Important Context` and canonical link |
| Product authority stays local | The UI skill overrides consumer tokens, components, or platform conventions | Skill and adversarial review preserve consumer design authority |
| Rendered behavior is reviewed | Tests pass while the workflow, empty state, keyboard path, or responsive layout is broken | Independent exact-head running review exercises named scenarios, states, and viewports |
| Automation stays a floor | A lint or screenshot score grants design acceptance | Negative fixture rejects deterministic-only completion language |
| Distribution stays coherent | Source skill differs from installed or starter guidance | Exact parity checks plus full QA |

## Stop conditions

Stop if the seven-section handoff cannot carry the brief cleanly, if current
skill routing cannot distinguish build from review without a new public
authority conflict, if qualitative review is being converted into a score, or
if the fixture design would claim visual-quality proof it cannot supply.

## Closeout

- UI design decisions now precede dispatch: spec 039's classification, brief,
  prototype gate, planning-only design delegate, handoff transport, and
  exact-head rendered review are promoted into reusable doctrine
  (`bundle-docs/sections/11-ui-design-delivery.md`), system architecture,
  contract 001, copy-ready templates, the provider-neutral `northstar-ui`
  skill with build and review routes, and structural fixtures.
- PR [#43](https://github.com/inflatable-cookie/northstar/pull/43) was accepted
  at exact head `571b0cde6e477736482dba18aea2095c8e7f7c1b` by the independent
  review in [comment 5636020236](https://github.com/inflatable-cookie/northstar/pull/43#issuecomment-5636020236)
  and merged as `d4245b18031f1589208a6babe2f49c2a62c4a18c`.
- The final review recorded `effigy qa` passing (exit 0),
  `effigy check:ui-protocol` OK, `effigy test:ui-protocol` with all 9 fixtures
  passing, and `git diff --check` clean on the accepted head. The round-1
  finding (restored readiness-rubric invariant in both task-template mirrors,
  hardened by a structural assertion) was resolved and re-validated. The
  integration `main` checkout was clean and synchronized with `origin/main`
  at the merge commit before this closeout, and `effigy qa:docs` passes there.
- Non-blocking notes carried forward: the handoff-template brief-ownership
  phrasing reads oddly once filled, and the skills-README payload count is
  declared non-contractual and fragile. Deterministic fixtures remain a
  structural floor only; live consumer evidence awaits the first natural
  operator-supplied lanes. No acceptance failure remains.
- Final Chatterbox reconciliation refreshed the stale `docs/README.md` pointers,
  removed fully promoted spec 039, and consumed this lane's transient handoff.
  Durable authority remains in section 11, contract 001, architecture, and the
  installed skill; Git and this closeout retain provenance.

## Next task

After merge, return to Chatterbox. Record the first natural refinement and
substantial consumer UI lanes as operator-supplied evidence before tightening
the protocol further; do not dispatch consumer dogfood automatically.
