---
name: zoom-out
description: Find and fix workarounds and stacked narrow fixes that bend around a constraint the project owns, by changing that constraint instead. Use when a fix would patch a repeatedly patched flow or feels like a workaround, when reviewing a diff specifically for local shortcuts, or when auditing a scope for accumulated band-aids.
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
  notice what it avoided touching to stay small. Judge each lead as below; ask
  for Fix verdicts now, before other code depends on the bend, and a proposal
  or tracked follow-up for the rest.
- **Audit**, across a repository, module, or workflow. Find candidates and
  judge them. The audit is a report unless the operator, or a calling
  workflow, asks for fixes.

## Find candidates

Read the seams and call sites across the scope, not just keyword matches. Each
signal is a lead, not a verdict:

- **Stacked special cases:** conditionals, flags, retries, or fallback
  branches piled around one concept or state transition, especially competing
  or order-dependent guards, and history hotspots of repeated "fix X when Y"
  commits on the same flow.
- **Escapes:** casts, type or lint suppressions, swallowed errors, or fallback
  defaults hiding a mismatch between two parts of the project.
- **Near-copies and shims:** a tweaked second version of a function, type, or
  component, or wrappers and mappers between two internal representations of
  the same concept, written to avoid changing the original and its callers.
- **Fixups and lost information:** patching or filtering a producer's result
  after the fact, parsing strings or errors the project produced itself, or
  re-deriving data an upstream layer threw away.
- **Smuggled state and steering flags:** globals, side-channel caches, or
  parallel lookups carrying state an interface should carry, and mode
  parameters added so one caller can alter a shared function.
- **Timing hacks:** sleeps, polling, deferred ticks, or call-order
  dependencies covering a missing event, lock, or lifecycle.
- **Wrong layer:** callers enforcing rules a lower layer should own, UI
  computing domain logic, or tests reaching into internals for lack of a clean
  seam.
- **Admissions:** "workaround", "for now", "temporary", or "avoid touching"
  in comments and commit messages.

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

- **Fix** when the constraint is internal and the straight fix is contained:
  it stays within the owning module and its direct internal callers, without
  changing public APIs, persisted data, or shared state models.
- **Propose** when the straight fix has a wide blast radius or changes a
  shared model, state transition, public behaviour, or an owned contract.
  Pause for operator approval.
- **Contain** when the constraint is external (or a frozen owned contract).
  Keep the workaround in one place with why it exists, an upstream link if
  any, and when it can go; leave it alone if already contained.
- **Leave** when the straight fix costs more than the bends. Explain why in
  the report.

## Fix

When implementing:

- Change the owning side, update every caller, and delete every superseded
  workaround in the same change, so old band-aids cannot coexist with and
  fight the new model. Leave no shim or alias unless the project's
  compatibility rules require one.
- Consolidate scattered **Contain** workarounds into one documented home.
- Pin uncovered behaviour with a test before refactoring across a boundary.
- For a Leave verdict, add a brief code comment only if the bend would
  otherwise look accidental.
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
