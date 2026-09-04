# 2026-09-04 11:35:00 Implement Chatterbox-Led Planning

- **Roadmap lane:** `g02.053`
- **Batch card:** `docs/roadmaps/g02/batch-cards/128-implement-chatterbox-led-planning.md`
- **Governing spec:** `docs/specs/037-chatterbox-led-planning-and-mechanical-coordination.md`
- **Governing contract:** `docs/contracts/001-working-rules.md`

## What Changed

1. **Chatterbox as primary planning authority:** Chatterbox owns material
   discovery, research direction, triage reconciliation, canonical planning
   promotion on the integration branch after operator confirmation, lane graph
   design, and approved parallel frontiers.
2. **Same-workspace planning delegates:** Rebuilt planning delegate as an
   optional same-workspace, unique-triage-only conversation reporting directly
   to Chatterbox with no planning PRs or coordinator interaction.
3. **Mechanical coordinator:** Coordinator performs factual preflight from
   canonical dispatch manifests, launches the complete approved ready
   frontier, operates in event-bounded turns, yields immediately post-dispatch,
   and avoids polling and wait calls.
4. **Coordinator direction channel:** Added typed Chatterbox-to-coordinator
   direction with `operator-confirmed direction`, `Chatterbox recommendation`,
   and `administrative notice` provenance.
5. **Review child in worker workspace:** Placed parent-attached review children
   in the existing worker workspace under a serial clean exact-head lease
   (`notifyOnFinish: true`). Removed review-only workspace creation.
6. **Context-complete operator escalations:** Added 10-part self-contained
   operator escalation capsule standard.
7. **Obsolete surface removal:** Removed `northstar-discovery-delegate.md.template`
   and `northstar-documentation-projection.md.template`. Updated repo-contract
   data and command-skill assertions.
8. **Installed skill parity:** Synchronized `skills/northstar/` to
   `/Users/tom/.claude/skills/northstar/` with verified 111-file exact parity.

## Exact Token & Surface Inventory

- **Removed/Replaced Tokens & Patterns:**
  - `handoff_mode: planning-delegate` & `planning_mode: conversational-discovery`
    in active handoff contracts -> replaced by same-workspace conversation;
  - `northstar-discovery-delegate.md.template` -> deleted;
  - `northstar-documentation-projection.md.template` -> deleted;
  - Promotion-only worker dispatch from triage -> removed;
  - Dedicated PR-head review workspace creation -> replaced by worker workspace
    serial lease;
  - Coordinator dependency graph compilation & discretionary frontier subsetting ->
    replaced by canonical dispatch manifest consumption;
  - Coordinator polling and waiting loops -> replaced by event-bounded turns and
    post-dispatch yield.

## Validation & Verification

- `git diff --check`: passed (clean whitespace and boundaries)
- `effigy check:chatterbox-git`: passed (15/15 assertions)
- `effigy check:command-skills`: passed (8 adapters, aggregate descriptions=431 chars, all structural & negative fixtures passed)
- `effigy check:repo-contract`: passed
- `effigy check:model-routing`: passed (10/10 milestone 047 oracle rows)
- `effigy check:skill-install /Users/tom/.claude/skills/northstar`: passed (111 files, 100% parity)
- `effigy check:skill-install skills/northstar`: passed (111 files, 100% parity)
- `effigy qa:docs`: passed
- `effigy qa`: passed
