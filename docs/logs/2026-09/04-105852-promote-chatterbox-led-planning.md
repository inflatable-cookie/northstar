# Promote Chatterbox-Led Planning

Date: 2026-09-04
Roadmap: `g02.053`
Card: `g02.053/128`
Status: canonical planning promoted; implementation ready

## Result

Live operator dogfood rejected the first economical-coordinator topology after
roughly twenty minutes of promotion preparation, coordinator polling, an opaque
operator question, a fail-closed promotion worker, and a pending repeated loop
before actual-worker dispatch. The operator stopped the coordinator and worker.

Spec 037 now makes Chatterbox the primary human-facing planning authority. It
owns triage reconciliation, direct canonical promotion, dependency design, and
the approved parallel frontier. Small planning delegates remain available for
same-workspace operator conversations but write only unique triage notes and
report to Chatterbox. The coordinator consumes the promoted manifest
mechanically, dispatches actual workers and visible reviewer tabs, applies the
merge gate, reports, and yields.

The promotion also freezes direct provenance-labelled Chatterbox direction,
worker-workspace serial reviewer leases, and context-complete operator
escalations. Specs 026, 035, and 036 remain as superseded implementation
history. Resolved triage packets and the abandoned promotion handoff were
removed; Git history preserves them.

Card 128 contains the exact single-lane dispatch manifest, allowed mutable
surfaces, worker class, escalation owner, validation, and stop conditions. No
promotion worker is required before implementation.

The first implementation dispatch exposed an ambiguous worker-class phrase:
the coordinator selected the slow Luna audit/documentation-grind profile because
the lane touched many documentation surfaces. The operator rejected that
routing before edits began. Spec 037 and card 128 now require role-first profile
selection and exclude auditor-style profiles from implementation lanes.

## Workspace disposition

Paseo workspace `wks_9a7941e458c92da3` and agent
`54d6b7c6-6e41-42ef-9f37-30fa7d7baf9a` were archived at operator request.
Paseo removed the managed worktree directory. The worker branch had no commits
beyond its main-base handoff state, so no committed implementation was lost.

## Validation

- `git diff --check` — clean
- `effigy qa:docs` — PASS
- `effigy qa` — PASS

## Next task

Dispatch `g02.053/128` directly to one implementation worker. After accepted
exact-head review and merge, refresh the installed skill and begin card 126's
corrected observation window.
