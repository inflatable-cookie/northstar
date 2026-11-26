---
name: zoom-out
description: Find and fix narrow fixes and workarounds that bend around a constraint the project owns — stacked special cases, shims, near-copies, type or lint escapes, post-hoc fixups, timing hacks, wrong-layer logic — by changing the owning invariant, type, interface, or boundary instead. Use when triaging a bug or blocker before a fix is written, reviewing a diff for local shortcuts before it lands, or auditing a scope for accumulated band-aids and awkward compromises left by a zoomed-in implementer.
---

# Zoom out

A workaround leaves a constraint in place and bends the code around it. When
the project owns the constraint — an invariant, state model, function
signature, data model, module boundary, or config shape — the better fix
changes that constraint and deletes the bends. Implementers zoomed into one
call site tend to treat surrounding code as fixed; this skill steps back and
asks what the code would look like if the requirement had been known from the
start.

## Modes

- **Triage**, before planning or writing a fix for a bug, blocker, or stuck
  state transition. Read the surrounding code and recent history for the
  affected flow, and trace the failure down to the owning invariant rather
  than stopping at the failing call site. Take a narrow fix only for a
  genuinely isolated local bug (a typo, wrong bound, or single-site logic
  error with no surrounding workarounds), or an urgent stopgap the operator
  approves with the real fix recorded alongside it. Otherwise scope the task
  at the owning constraint, including the band-aids it supersedes.
- **Review a change**, before a diff lands. Check it for the signals below and
  notice what it avoided touching to stay small. Ask whether the implementer
  changed the right side of the boundary. Ask for a contained straight fix
  now, before other code depends on the bend; for a wider or contract-touching
  fix, require an approved proposal or tracked follow-up; for an external
  constraint, require it to be contained and documented.
- **Audit**, across a repository, module, or workflow. Find candidates, judge
  them, and fix or propose as below.

## Find candidates

Read the seams and call sites across the scope, not just keyword matches. Each
signal is a lead, not a verdict:

- **Stacked special cases:** conditionals, flags, retries, or fallback branches
  piled around the same concept or state transition, especially competing or
  order-dependent guards.
- **History hotspots:** repeated "fix X when Y" or "handle Z edge case"
  commits on the same flow.
- **Escapes:** casts, `any`, `unwrap`, non-null assertions, lint or type
  suppressions, and swallowed errors or fallback defaults hiding a mismatch
  between two parts of the project.
- **Near-copies:** a second version of a function, type, or component with a
  small tweak, written to avoid updating the original and its callers.
- **Internal shims and translation:** forwarding aliases, wrappers, or mappers
  between two internal representations of the same concept, especially
  round-trips or old signatures no external caller needs.
- **Post-hoc fixups:** calling a function or query and then filtering,
  mutating, or undoing its result because the producer returned the wrong
  shape.
- **Lost information:** parsing strings or error messages the project produced
  itself, re-deriving data an upstream layer threw away, or sniffing types at
  runtime.
- **Smuggled context and shadow state:** globals, singletons, side-channel
  caches, ad-hoc optional parameters, or parallel lookup structures holding
  state the primary model or interface should carry.
- **Steering flags:** boolean or mode parameters added so one caller can
  bypass or alter a shared function's behaviour.
- **Timing hacks:** sleeps, polling, deferred ticks, or call-order
  dependencies covering a missing event, lock, or lifecycle.
- **Wrong layer:** callers enforcing rules or duplicating values a lower layer
  should own, UI computing domain logic, or tests and test-only branches
  reaching into internals for lack of a clean seam.
- **Admissions:** `HACK`, `XXX`, `TODO`, "workaround", "for now", "temporary",
  or "avoid touching" in comments and commit messages.

## Judge each candidate

Drop leads that are intentional boundaries (validating untrusted input,
isolating a wire format) or separate concepts that only look similar. For the
rest:

1. **Name the constraint** precisely (such as "`Order` has no currency field"
   or "`load()` returns before the cache is warm"). Group bends dodging the
   same constraint before weighing cost, since one change often removes
   several.
2. **Identify the owner:** *internal* (the project owns both sides), *owned
   contract* (owned here, but external callers, persisted data, or downstream
   repos depend on it), or *external* (a third-party library, platform, or
   vendor API).
3. **Design the straight solution** that makes the bends unnecessary, and
   check every caller, dependent, and contract it touches.
4. **Weigh the cost** of the bends (bugs, confusion, duplicated effort,
   blocked changes) against the blast radius of the straight fix.

Give one verdict per constraint:

- **Fix** when the constraint is internal and the straight fix is contained.
- **Propose** when the straight fix has a wide blast radius or changes a
  shared model, state transition, public behaviour, or an owned contract.
  Pause for operator approval.
- **Contain** when the constraint is external (or a frozen owned contract).
  Keep the workaround in one place with why it exists, an upstream link if
  any, and when it can go; leave it alone if already contained.
- **Leave** when the straight fix costs more than the bends. Explain why in
  the report, and add a brief code comment only if the bend would otherwise
  look accidental.

## Fix

- Change the owning side, update every caller, and delete every superseded
  workaround in the same change, so old band-aids cannot coexist with and
  fight the new model. Leave no shim or alias unless the project's
  compatibility rules require one.
- Consolidate scattered **Contain** workarounds into one documented home.
- Pin uncovered behaviour with a test before refactoring across a boundary.
- Land each constraint's fix in its own commit or batch, and run targeted
  checks after each.

## Report

- **Triage:** whether the issue is isolated or part of a pattern, the
  recommended fix level, and the workarounds to remove with it.
- **Review and audit:** constraints ordered by friction removed. For each,
  give the bends (`file:line`, plus git evidence where it applies), the
  constraint and owner, the straight solution, the verdict with a short
  reason, and caller or migration impact. For landed changes, say which bends
  were deleted or consolidated.
