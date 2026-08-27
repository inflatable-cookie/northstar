# Skill Architecture

Northstar ships **one distributable skill package**. It installs the `northstar`
front door plus thin named adapters so explicit commands are activatable across
agent harnesses.

Human operators use [`protocol-kernel.md`](../protocol-kernel.md), the
[visual map](../visual-map.md), and [operator quick start](../operators/operator-quick-start.md).
Agents use `skills/northstar/SKILL.md` and **must** run
[`skills/northstar/references/router.md`](../../skills/northstar/references/router.md)
before loading a mode.

## Public surface

| Source | Role |
| --- | --- |
| `skills/northstar/` | One package containing the front door, modes, tools, and adapters |

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
| `/northstar-rust-audit` | Explicit worktree or repository Rust quality audit-and-repair |
| `/northstar-typescript-audit` | Explicit worktree or repository TypeScript/Svelte audit-and-repair |

The Skills CLI installs each adapter as a named skill entry because nested files
inside `northstar` are not independently activatable. They remain adapters, not
separate standards or planning authorities. Each loads the central router and
one canonical mode. Atlas is strategic and plan-only; readiness review is
intentionally smaller and audits planning that already exists.

## Distribution and update

Install the published package at full depth so every named adapter is surfaced:

```bash
npx skills add https://github.com/inflatable-cookie/northstar/tree/main/skills/northstar \
  --full-depth --skill '*' --agent codex -g -y
npx skills list -g --json
```

Replace `codex` with the current harness's Skills CLI agent ID, or pass several
IDs after `--agent`. Do not use `--all`: that targets every supported harness,
not every skill in this package.

After a published source update, rerun the same full-depth command. Updating
only `northstar` leaves separately installed adapters stale.

```bash
npx skills add https://github.com/inflatable-cookie/northstar/tree/main/skills/northstar \
  --full-depth --skill '*' --agent codex -g -y
npx skills list -g --json
```

The first list must include `northstar`, `northstar-rust-audit`, and
`northstar-typescript-audit`; a top-level-only install is incomplete. `skills
list` also shows the configured source and installed agent targets. A source
checkout can verify the main payload with:

```bash
effigy check:skill-install /path/to/installed/northstar
```

The parity checker compares the distributable skill payload and ignores Effigy's
runtime receipts under `.effigy/`; those receipts are not part of the installed
skill. A direct `rsync -a --delete` from `skills/northstar/` is reserved for local
development before the change is published. Restart agent sessions after an
update.

The current configured development install contains 120 source-identical files.
Rust v2 replaces the skill-local Rhai recorder with the Cargo-native engine;
TypeScript retains its Rhai recorder. This count is evidence for the current
payload, not a stable public contract.

The installed skill also carries a minimal Effigy catalog for consumer-safe
checks plus Rust and TypeScript quality activation/recording. It validates the
agent-instruction surface and inert language-quality packages. When a consumer repository has no local
`check:agent-instructions` task, select the installed skill explicitly:

```bash
effigy --repo /path/to/installed/northstar northstar/check:agent-instructions /path/to/project
```

This is an execution surface inside the one package, not a second standards
authority or a replacement for the source repository's full QA catalog.

Rust catalogue and projection parity is checked without loading those files as
agent instructions:

```bash
effigy --repo /path/to/installed/northstar northstar/check:rust-quality
```

TypeScript catalogue and strict-audit parity is checked the same way:

```bash
effigy --repo /path/to/installed/northstar northstar/check:typescript-quality
```

### Agent-owned strict Rust activation

The operator does not copy or configure template files. When Northstar is
requested for Rust work, the agent checks the target repository and runs:

```bash
effigy --repo /path/to/installed/northstar \
  northstar/rust-quality:setup apply /absolute/path/to/project [scope-directory]
```

The agent chooses the narrowest Rust-owning scope. The setup task discovers
Cargo manifests and explicit toolchain files, appends a marked compact block to
an existing `AGENTS.md` without replacing it, creates only missing profile and
deviation contracts, and is byte-idempotent. Existing valid contracts remain
unchanged. Conflicts fail closed.

Only `strict` is production-valid. The repository owns its MSRV, exclusions,
architecture, and accepted deviations; Northstar does not infer or replace
them. The agent asks only when that policy is not recoverable from repository
state. Ordinary Rust work then routes through the compact authoring mode. An
explicit whole-codebase or current-worktree audit uses:

```text
/northstar-rust-audit repository
/northstar-rust-audit worktree
```

The audit records findings before mutation and preserves unrelated dirty state.
It does not authorize ordinary or high-assurance profiles, unsafe/FFI repair,
blanket fixing, or certification claims.

### Agent-owned TypeScript/Svelte explicit audit activation

TypeScript and Svelte activate only for an explicit quality audit, no-slop pass,
or audit-and-fix request. Ordinary TypeScript coding does not load the catalogue
or audit procedure. The agent chooses the narrowest package-owning scope and
runs:

```bash
effigy --repo /path/to/installed/northstar \
  northstar/typescript-quality:setup apply /absolute/path/to/project [scope-directory]
```

Setup discovers root packages, declared workspaces, independent nested packages,
and package-local Svelte 5/SvelteKit 2 evidence. It installs no dependencies,
preserves valid instructions and contracts, and fails closed on malformed or
conflicting setup. Explicit audit then uses:

```text
/northstar-typescript-audit repository
/northstar-typescript-audit worktree
```

Only strict explicit audit is production-valid. Everyday TypeScript authoring,
older or unresolved framework overlays, Deno-only/source-only roots, deferred
toolchain/testing rules, slop-only mutation, and certification claims remain
unavailable.

Retired top-level skills (`northstar-setup`, `northstar-plan`,
`northstar-recover`, `northstar-research`, `northstar-handoff`) were merged
into internal **modes** under `skills/northstar/references/modes/`. No
compatibility aliases.

## Modes (internal, not separate installs)

| Mode file | Use when |
| --- | --- |
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
| `rust-quality-authoring.md` | Self-activating ordinary Rust writing, review, or refactoring |
| `rust-quality-audit.md` | Explicit Rust worktree or repository audit-and-repair |
| `typescript-quality-audit.md` | Explicit TypeScript/Svelte worktree or repository audit-and-repair |

Setup references live under `skills/northstar/references/setup/`.
Templates live under `skills/northstar/assets/templates/`.

## Activation rules

- **Implicit (auto-invoke):** plan, research, recover, normalize, explicit
  orchestrator-thread, or long-horizon strategic-planning language in the user
  message — covered by the `northstar` skill description.
- **Handoff:** only when the user clearly wants a continuation brief or fresh
  thread. The router and handoff mode forbid compaction-only or bare `continue`.
- **Rust everyday authoring:** only when applicable repository instructions
  activate the strict Rust profile and the task writes, reviews, or refactors
  Rust. The mode loads individual rule references by trigger. Explicit audit or
  no-slop intent is reserved for the audit route and cannot fall back here.
- **Rust explicit audit:** only for an explicit quality audit, no-slop pass, or
  audit-and-fix request. It loads the audit projection and deterministic record
  contract on demand, resolves worktree or repository scope, and cannot
  activate from ordinary coding.
- **TypeScript/Svelte explicit audit:** only for an explicit quality audit,
  no-slop pass, or audit-and-fix request. It resolves package-local overlays and
  cannot activate from ordinary coding; no everyday TypeScript projection ships.
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
