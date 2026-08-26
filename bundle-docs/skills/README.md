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

The one installable skill also exposes thin explicit command adapters under
`skills/northstar/commands/`:

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

These adapters are discoverability surfaces, not separate installs or planning
authorities. Each loads the central router and one canonical mode. Atlas is
strategic and plan-only; readiness review is intentionally smaller and audits
planning that already exists.

## Distribution and update

The published skill is distributed through the Skills CLI. After a Northstar
release or published source update:

```bash
npx skills update northstar -g -y
npx skills list -g --json
```

`skills list` shows the configured source and installed agent targets. A
source checkout can verify a specific install with:

```bash
effigy check:skill-install /path/to/installed/northstar
```

The parity checker compares the distributable skill payload and ignores Effigy's
runtime receipts under `.effigy/`; those receipts are not part of the installed
skill. A direct `rsync -a --delete` from `skills/northstar/` is reserved for local
development before the change is published. Restart agent sessions after an
update.

The installed skill also carries a minimal Effigy catalog for consumer-safe
checks and Rust activation/recording. It validates the agent-instruction surface
and inert Rust quality package. When a consumer repository has no local
`check:agent-instructions` task, select the installed skill explicitly:

```bash
effigy --repo /path/to/installed/northstar northstar/check:agent-instructions /path/to/project
```

This is an execution surface inside the one skill artifact, not a second public
install or a replacement for the source repository's full QA catalog.

Rust catalogue and projection parity is checked without loading those files as
agent instructions:

```bash
effigy --repo /path/to/installed/northstar northstar/check:rust-quality
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
