# 065 - Repair Portable Skill Boundary

Status: complete
Owner: repo maintainers
Updated: 2026-07-28
Master spec refs: none
Governing refs: `docs/contracts/001-working-rules.md`, `README.md`,
`bundle-docs/skills/README.md`, `g02.022`
Auto-start next card: yes

## Ready-State Checks

- [x] Objective is bounded enough to finish without fresh planning decisions.
- [x] Governing refs point at current canonical surfaces.
- [x] Scope boundaries and stop conditions are explicit.
- [x] Acceptance criteria, validation, and evidence requirements are explicit.
- [x] No unresolved planning or intent gap governs this card.
- [x] Card 066 is defined and may auto-start after this card passes review.

## Objective

Make every installed-skill Markdown reference self-contained while keeping
Northstar doctrine and target-repo files in their canonical homes.

## Lane Runway Context

- Higher-level lane owner: g02 reusable bundle/skill hardening runway
- Next transition: card 066
- Next planning checkpoint: detached validation

## Scope

- define the portable reference boundary in skill architecture doctrine
- repair the seven escaping links in the skill, router, and affected modes
- do not copy `bundle-docs/` or `template-bundle/` into the skill
- do not change mode selection or consumer repo contents

## Steps

1. State the difference between skill-owned links and runtime repo paths.
2. Make source doctrine optional outside the Northstar source repo.
3. Require an explicit Northstar source checkout for bootstrap template copy.
4. Confirm no Markdown link escapes the skill folder.

## Acceptance Criteria

- zero escaping local Markdown links under `skills/northstar/`
- absence of `bundle-docs/` is normal in consumer repos
- bootstrap mode no longer infers a sibling `template-bundle/`

## Evidence Required

- recursive local-link audit
- focused diff review

## Continuation Envelope

- Auto-start next card: yes
- In-bounds next card: 066
- Remaining ready chain after this card: 1
- Transition proof required before auto-start: zero escaping links

## Lane Budget

- Current card ends budgeted run: no
- Further operator decision required after this card: no
- Pause signal if run stops here: stop-signal-fired

## Stop Conditions

- Stop if portability requires duplicating canonical doctrine.
- Ask for operator intent if bootstrap must gain a new distribution mechanism.

## Completion Notes

Defined the one-folder link boundary in skill doctrine; converted all seven
escaping links into explicit target/source-repo paths; made missing
`bundle-docs/` normal in consumer repos; made bootstrap require an explicitly
located Northstar source checkout. Recursive audit: zero escaping or missing
local links.

## Next Task

Execute card 066.
