# Skill Architecture

Northstar ships **one distributable skill package**: the `northstar` front
door. Language quality lives in independently installed packages, not in this
skill.

Human operators use [`protocol-kernel.md`](../protocol-kernel.md), the
[visual map](../visual-map.md), and [operator quick start](../operators/operator-quick-start.md).
Agents use `skills/northstar/SKILL.md` and **must** run
[`skills/northstar/references/router.md`](../../skills/northstar/references/router.md)
before loading a mode.

## Public surface

| Source | Role |
| --- | --- |
| `skills/northstar/` | One package containing the front door and generic mode routing |

The package exposes thin explicit command adapters under `commands/`:

| Command | Scope |
| --- | --- |
| `/northstar-atlas` | User-guided long-horizon discovery, options, and multi-horizon planning |
| `/come-again` | Standalone request restatement |
| `/northstar-agents-review` | AGENTS/CLAUDE instruction-surface review |
| `/northstar-readiness-review` | Existing planning-state readiness review |
| `/northstar-architecture-refocus` | Bounded architecture refocus |
| `/northstar-refresh` | Broad project planning/docs refresh |
| `/northstar-cleanup` | Inspect and safely rework `/docs` drift |

Language quality workflows are not commands in this package. Explicit
audit-and-repair and everyday authoring route through installed language
packages via the generic installed-package route in
`skills/northstar/references/packages/installed-package-route.md`.

## Distribution and update

Install the published package so the `northstar` front door is activatable:

```bash
npx skills add https://github.com/inflatable-cookie/northstar/tree/main/skills/northstar \
  --full-depth --skill '*' --agent codex -g -y
npx skills list -g --json
```

Replace `codex` with the current harness's Skills CLI agent ID, or pass several
IDs after `--agent`. Do not use `--all`: that targets every supported harness,
not every skill in this package.

```bash
npx skills add https://github.com/inflatable-cookie/northstar/tree/main/skills/northstar \
  --full-depth --skill '*' --agent codex -g -y
npx skills list -g --json
```

The first list must include `northstar`; a missing front door is an
incomplete install. `skills list` also shows the configured source and
installed agent targets. A source checkout can verify the payload with:

```bash
effigy check:skill-install /path/to/installed/northstar
```

The parity checker compares the distributable skill payload and ignores
Effigy receipts under `.effigy/`; they are not part of the installed skill. A
direct `rsync -a --delete` from `skills/northstar/` is reserved for local
development before the change is published. Restart agent sessions after an
update.

The current source package contains 111 distributable files. Installed copies
remain separate parity targets and may lag until an explicit update. This
count is evidence for the current payload, not a stable public contract.

The installed skill also carries a minimal Effigy catalog for consumer-safe
checks. It validates the agent-instruction surface and the generic
language-package machine contracts. When a consumer repository has no local
`check:agent-instructions` task, select the installed skill explicitly:

```bash
effigy --repo /path/to/installed/northstar northstar/check:agent-instructions /path/to/project
```

This is an execution surface inside the one package, not a second standards
authority or a replacement for the source repository's full QA catalog.


### Language quality packages

Rust and TypeScript/Svelte quality live in independently installed official
packages, not in this skill. Explicit audit-and-repair intent or an existing
consumer activation marker routes through the generic installed-package route
(`skills/northstar/references/packages/installed-package-route.md`): generic
registry-owned selection, a visible acquisition notice, and execution of the
package's declared entrypoint from its installed path. Consumer repositories
keep owning their profiles, deviations, toolchains, and exclusions.

With no compatible package installed, only the requested language workflow
stops, naming the exact identity and the local installation route; all other
Northstar workflows continue. Core carries no embedded language payload and no
compatibility alias for one.

Retired top-level skills (`northstar-setup`, `northstar-plan`,
`northstar-recover`, `northstar-research`, `northstar-handoff`) were merged
into internal **modes** under `skills/northstar/references/modes/`. No
compatibility aliases.

## Modes (internal, not separate installs)

| Mode file | Use when |
| --- | --- |
| `pr-review.md` | Review an existing PR and post every required change on the provider review surface |
| `orchestrator.md` | Question-led planning, one pushed worker handoff under `docs/handoffs/`, bounded PR review loop |
| `cleanup-docs.md` | Inventory `/docs`, rehome clear drift, and disposition triage notes without blind deletion |
| `normalize-docs.md` | Bootstrap, migrate, or ongoing docs-spine hygiene |
| `plan-from-scratch.md` | Planning coverage still missing |
| `shape-with-specs-and-promote.md` | Provisional spec lane before promotion |
| `compile-roadmaps.md` | Canonical surfaces exist; compile milestones/cards |
| `research.md` | Evidence → architecture/contracts |
| `replan-after-change.md` | Valid plan, changed boundary |
| `refocus-drifted-project.md` | Broad drift or untrustworthy state |
| `sweep-audit-repair.md` | Structured sweep pass |
| `handoff.md` | User **explicitly** asks for handoff / fresh thread |
| `atlas.md` | User-guided long-horizon direction and a coarse strategic runway |

Setup references live under `skills/northstar/references/setup/`.
Templates live under `skills/northstar/assets/templates/`.

## Activation rules

- **Implicit (auto-invoke):** plan, research, recover, normalize, direct PR
  review, explicit orchestrator-thread, or long-horizon strategic-planning
  language in the user message — covered by the `northstar` skill description.
- **Handoff:** only when the user clearly wants a continuation brief or fresh
  thread. The router and handoff mode forbid compaction-only or bare `continue`.
- **Language quality:** explicit audit-and-repair or everyday authoring
  intent — or an exact registered activation marker in the consumer — routes
  through installed language packages. Detection of a language alone never
  installs or activates anything.
- **Triage:** orchestrator and refresh conversations capture unresolved useful
  threads in `docs/triage/YYYYMMDD-HHMMSS-<slug>.md`; cleanup and refresh promote,
  merge, or remove them over time.

## Structural rules

- Keep the public skill count at **one**.
- Put procedures in `references/modes/` and load **one** mode per invocation.
- Keep every local Markdown link inside `skills/northstar/`; the installed
  skill is a one-folder artifact.
- Write target-repo and Northstar-source paths as code literals, not links
  relative to the installed skill. Resolve them from the target workspace or
  an explicitly located Northstar source checkout.
- `bundle-docs/` and `template-bundle/` are source-repo surfaces, not skill
  payload. Their absence is normal in consumer repos and does not by itself
  indicate a contract gap.
- Point at doctrine when a Northstar source checkout is available; do not
  duplicate long enumerations inside the skill body.
- Operator starter prompts stay under `bundle-docs/operators/`; not every
  prompt becomes a skill.
