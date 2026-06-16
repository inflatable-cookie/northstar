# 018 - Consumer-Repo Follow-Up Queue And Underlay Recovery

Status: retired-in-place
Owner: repo maintainers
Updated: 2026-04-09
Vision refs: docs/vision/001-northstar-delivery-vision.md
Governing refs: docs/contracts/001-working-rules.md
Roadmap refs: g02.015

## Problem

Northstar has now proven meaningful strict-lane behavior in Signal and useful
lane-first adoption in Jetstream and Loophole, but the consumer-repo queue is
starting to drift in two ways:

- Jetstream and Loophole both need future return passes toward fuller strict
  compliance, but those follow-ups are currently only in conversation memory.
- Underlay is now the next meaningful target, and it appears to have drifted
  away from its own roadmap/currentness posture while a broader Poodle-led
  component overhaul is happening across multiple consuming apps.

If this state is not recorded explicitly, Northstar will keep repeating old
work or lose the next honest target.

## Target Operating Model

Northstar should keep an explicit queue of consumer-repo follow-ups:

- repos that proved a narrower lane-first or planning-layer recovery and should
  be revisited later
- the one active next target that needs immediate recovery or planning repair

That queue should be lightweight but real, so “return later” does not become
“forgotten entirely.”

## Deferred Follow-Up Queue

### Jetstream

- Current status: lane-first strict tranche is in place around the active
  physics lane and behaving acceptably.
- Why it is deferred:
  the current physics work is still exploratory and architecture-sensitive, so
  broader strict migration would likely add drag before the active cycle
  settles.
- Return trigger:
  when the current physics lane stabilizes into more repeatable implementation
  work, or when another Jetstream lane clearly needs the same tighter execution
  model.

### Loophole

- Current status: Chorus is back on a credible Northstar planning/control path
  and `g10.001` opened a real planning gate for the wider rebuild.
- Why it is deferred:
  the current value is in letting the recovered Chorus control path prove
  itself while `g10.002` and the broader runway start moving.
- Return trigger:
  when the active Loophole execution lane either drifts again or clearly needs
  Signal-style strict ready-card execution instead of planning-layer control
  alone.

## Active Next Target

### Underlay

- Current status:
  Underlay has a healthy Northstar-shaped docs spine and strong repo-local
  validation, but its roadmap/front-door posture currently says the major
  contraction and Poodle translation wave is complete.
- Why it is active now:
  the real work has moved into a broader shared-surface overhaul across
  Underlay and at least six consuming apps
  (`acowtancy`, `compli-me`, `contact-patch`, `underlay-reference`,
  `loophole/composer`, and `songsprout`), so the docs authority is likely
  under-describing the live queue again.
- Immediate goal:
  audit Underlay’s current planning/currentness surfaces and recover the live
  next lane before more broad cross-repo work outruns the authority chain.

## Evidence To Close Current Tranche

- [x] Northstar explicitly records Jetstream and Loophole as deferred return
      targets.
- [x] Underlay is explicitly recorded as the active next recovery target.
- [x] The next roadmap lane and batch card are aligned to that target.

## Risks

- Risk: Jetstream and Loophole get silently forgotten because they are “good
  enough for now.”
- Mitigation: keep them in an explicit deferred follow-up queue with clear
  return triggers.

- Risk: Underlay gets treated like a full strict-migration target before its
  real drift pattern is understood.
- Mitigation: start with a recovery audit of currentness and planning state,
  not a blind doctrine install.

## Stop Conditions

- the lane starts migrating Underlay execution behavior before its current
  authority drift is diagnosed
- the deferred follow-up queue turns into vague prose with no practical return
  triggers
