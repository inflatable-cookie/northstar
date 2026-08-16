# 073 - Refresh And Prove Orchestrator Skill Distribution

Status: blocked
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
Governing refs: `bundle-docs/skills/README.md`, `scripts/check-northstar-skill-install.rhai`, `g02.025`
Auto-start next card: no

## Objective

Make the source `northstar` skill's new orchestrator mode available in the
installed skill copy and prove source/install parity before dogfood.

## Scope

- repair or adapt the parity checker to the supported Effigy runtime;
- refresh the installed skill from the source tree through the documented path;
- verify the new mode, packet template, router, and skill metadata are present;
- record exact source/install comparison evidence;
- do not change the orchestrator protocol or add provider-specific automation.

## Blocker

`effigy check:skill-install /Users/tom/.agents/skills/northstar` currently fails
before comparison because the runtime does not provide `join(array, ...)`. The
source tree and installed tree are therefore not parity-proven.

## Acceptance Criteria

- the parity command exits successfully;
- source and installed file sets and contents match;
- the installed copy contains `references/modes/orchestrator.md` and
  `assets/templates/northstar-orchestrator-run.md.template`;
- a fresh Hermes/consumer session can load the updated router and mode;
- no unrelated installed-skill changes are introduced.

## Evidence Required

- parity checker command and output;
- direct source/install comparison if the checker remains limited;
- installed skill file list or hashes;
- confirmation that a fresh session is required to reload the skill.

## Continuation Envelope

- Auto-start next card: no
- In-bounds next card: none
- Remaining ready chain after this card: 0
- Transition proof required before auto-start: parity passes

## Lane Budget

- Current card ends budgeted run: yes
- Further operator decision required after this card: yes
- Pause signal if run stops here: handoff-required

## Stop Conditions

- stop if refreshing the installed skill requires mutating a different profile or
  distribution source without operator authorisation;
- stop if the checker semantics cannot be repaired without a separate Effigy
  contract change;
- stop if source/install content differs outside the orchestrator feature.

## Next Task

Repair the parity-checker runtime path, refresh the installed skill, and prove
parity before running `g02.025/072`.
