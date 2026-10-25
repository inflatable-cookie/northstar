# Northstar

Northstar is a small skill and a repository shape that keep a project's
knowledge current and its work well-aimed. This repository is the skill's
source and the reference example of the shape. It must never grow back into
process doctrine: task state belongs in Queue, not in Git.

## Where things live

- Current state: `docs/README.md`
- Knowledge (one owner per fact): `docs/knowledge/README.md`
- Retired concepts, which must not come back: `docs/knowledge/retired.toml`
- Open questions: `docs/knowledge/questions.md`
- The skill: `skills/northstar/SKILL.md`; its starter: `skills/northstar/template/`

The plan (lanes, their documents and their order), leads, briefs, papercuts,
tasks and status live in Queue, never in this repository. Read what's
next with `plan.get` for `inflatable-cookie/northstar`.

## Commands

- `effigy qa` — full validation: skill self-tests, language-package checks,
  retired concepts and links.
- `effigy check:skill-install ~/.agents/skills/northstar` — installed copy
  matches source.
- `effigy skill run --path skills/northstar <task>` — run a skill task from
  source (`retired-concepts`, `cut`, `check-links`, `paseo:worktree`).

General Effigy guidance comes from the maintained
[Effigy skill](https://github.com/inflatable-cookie/effigy/tree/main/skills/effigy),
installed in a supported global skill root. These are Northstar's selectors
and guardrails. If the skill is missing from your agent's catalogue, install
it under `~/.agents/skills/effigy` and start a fresh agent. Install the Effigy
executable separately, using the Effigy project's README.

## Product rules

- Keep `skills/northstar/template/` copy-ready: starter material for another
  project, with no Northstar-specific examples.
- Say a rule once, in the skill. Doctrine a capable agent follows by default is
  removed, not restated.
- The `paseo:worktree` selector and the installed path
  `~/.agents/skills/northstar` are relied on by other repositories'
  `paseo.json`. Don't rename either.
- Before 1.0, update callers and remove superseded surfaces together; no shims.
  If a change breaks callers or documented behaviour, stop with a short impact
  summary and options.
- Write in the house style:
  `docs/knowledge/contracts/internal-writing-style.md`.

## Guardrails

- Don't edit `.github/workflows/` or sync the installed skill without an
  explicit operator request; both affect every project on the machine.
- When a change alters what is true, update the owning knowledge file in the
  same PR.
- An operator ruling given in conversation goes into its owning file before
  the thread ends.

## Papercuts and leads

File small, recurring friction in Queue with `papercut.add`, and unplanned
ideas or observations with `lead.add` (see the `northstar` skill). The
repository holds no papercut file or triage folder.

## Validate

Before a PR, run targeted checks: `effigy qa:docs` for docs, and the self-test
of any skill script you changed. Full `effigy qa` runs at release points.

<!-- oxide:begin -->
<!-- oxide:workspaces: scripts/fixtures/language-package-reruns -->
## Rust commands: use `oxide`

Covers Cargo workspaces `scripts/fixtures/language-package-reruns`, relative to this file's folder.

- Write `oxide` wherever you would write `cargo`: `oxide check`, `oxide test`, `oxide run -- <args>`, `oxide add <crate>`.
- Profiles: `quick` (default), `--profile debug` for a debugger, `--release`. Oxide places build output, so it refuses `--target-dir`.
- A tool that runs Cargo itself (Tauri CLI, npm or bun scripts): `oxide exec -- <command>`.
- A `waiting for …` line means another build holds a slot; let it wait. `oxide status` shows the pool, slots and waits.
- Use `oxide clean`, not `cargo clean`.

Managed by `oxide init`; edits between these markers are replaced.
<!-- oxide:end -->
