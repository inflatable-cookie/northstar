# Skill Architecture

Northstar exposes **one installable agent skill**: `northstar`.

Human operators use [`protocol-kernel.md`](../protocol-kernel.md), the
[visual map](../visual-map.md), and [operator quick start](../operators/operator-quick-start.md).
Agents use `skills/northstar/SKILL.md` and **must** run
[`skills/northstar/references/router.md`](../../skills/northstar/references/router.md)
before loading a mode.

## Public surface

| Install | Role |
| --- | --- |
| `skills/northstar/` | Single front door for all Northstar agent work |

Retired top-level skills (`northstar-setup`, `northstar-plan`,
`northstar-recover`, `northstar-research`, `northstar-handoff`) were merged
into internal **modes** under `skills/northstar/references/modes/`. No
compatibility aliases.

## Modes (internal, not separate installs)

| Mode file | Use when |
| --- | --- |
| `normalize-docs.md` | Bootstrap, migrate, or ongoing docs-spine hygiene |
| `plan-from-scratch.md` | Planning coverage still missing |
| `shape-with-specs-and-promote.md` | Provisional spec lane before promotion |
| `compile-roadmaps.md` | Canonical surfaces exist; compile milestones/cards |
| `research.md` | Evidence → architecture/contracts |
| `replan-after-change.md` | Valid plan, changed boundary |
| `refocus-drifted-project.md` | Broad drift or untrustworthy state |
| `sweep-audit-repair.md` | Structured sweep pass |
| `handoff.md` | User **explicitly** asks for handoff / fresh thread |

Setup references live under `skills/northstar/references/setup/`.
Templates live under `skills/northstar/assets/templates/`.

## Activation rules

- **Implicit (auto-invoke):** plan, research, recover, normalize language in the
  user message — covered by the `northstar` skill description.
- **Handoff:** only when the user clearly wants a continuation brief or fresh
  thread. The router and handoff mode forbid compaction-only or bare
  `continue`.

## Structural rules

- Keep the public skill count at **one**.
- Put procedures in `references/modes/` and load **one** mode per invocation.
- Point at doctrine via `bundle-docs/protocol-kernel.md`; do not duplicate
  long enumerations inside the skill body.
- Operator starter prompts stay under `bundle-docs/operators/`; not every
  prompt becomes a skill.
