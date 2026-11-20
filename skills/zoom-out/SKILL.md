---
name: zoom-out
description: Identify and replace narrow symptom fixes with cleaner, lower-level solutions, and prevent planners or workers from stacking brittle workarounds. Use when triaging or dispatching a bug, blocker, or stuck state transition, or when auditing a codebase for accumulated special cases, flags, and competing conditionals.
---

# Zoom out

Stop stacking narrow fixes on top of symptoms. Either catch a narrow fix before
it is planned or written, or audit an area where band-aids have accumulated
and replace them with a cleaner lower-level model.

## Before planning or fixing an issue (triage mode)

Run this check before writing or dispatching a fix for a bug, blocker, or
stuck state transition:

1. **Check the neighbourhood.** Read the surrounding code and recent git
   history for the affected flow. Look for prior edge-case patches, flags, or
   guards touching the same state or boundary.
2. **Trace why the state is possible.** Follow the failure down to the owning
   invariant, state machine, or data model rather than stopping at the failing
   call site.
3. **Check the failure class.** Ask whether a cleaner lower-level rule or
   invariant solves this case and its siblings together, without adding
   another special-case branch or flag.
4. **Choose the fix level.**
   - Take a **narrow fix** only for a genuinely isolated local bug (a typo,
     wrong bound, or single-site logic error with no surrounding workarounds)
     or an urgent stopgap explicitly approved by the operator — if it is a
     stopgap, record the real underlying fix alongside it.
   - Otherwise, scope the task at the lower-level invariant and include
     removing any band-aids it supersedes. Never stack a new conditional on top
     of old workarounds that fight it.

## Auditing and refactoring an existing scope

When reviewing a repository, module, or workflow for accumulated symptom
fixes:

1. **Find band-aid clusters.** Inspect both code and git history for:
   - stacked special-case conditionals, flags, retries, or fallback branches
     around the same concept or state transition;
   - hotspots in git log with repeated "fix X when Y" or "handle Z edge case"
     commits on the same flow;
   - defensive workarounds pushed onto callers because a lower layer does not
     enforce its own invariant;
   - competing or order-dependent guards that contradict each other or make
     the product unpredictable.
2. **Group by underlying invariant.** Cluster related workarounds around the
   product rule, state model, or boundary they are papering over.
3. **Design the broader replacement.** Step back to the product and domain
   level: what simpler lower-level model or invariant makes the whole cluster
   unnecessary? Check contracts, callers, and dependents before proposing a
   change.
4. **Propose or implement cleanly.**
   - For changes that alter shared models, state transitions, or public
     behaviour, present the proposal for operator approval before rewriting.
   - When implementing, delete every superseded workaround in the same change
     so old band-aids cannot coexist and fight the new model.

## Report

- **Triage mode:** whether the issue is isolated or part of a pattern, the
  recommended fix level (narrow vs lower-level invariant), and any existing
  workarounds to remove with it.
- **Audit / refactor mode:** each cluster ordered by friction removed — the
  band-aids (`file:line` and git evidence), the missing invariant, the
  broader replacement (proposed or landed), caller or migration impact, and
  which workarounds disappear.
