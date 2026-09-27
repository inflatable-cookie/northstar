# Architecture

Northstar is one installable skill plus the repository shape it maintains. The
skill's source is `skills/northstar/` in this repository.

## The split

| Home | Holds |
| --- | --- |
| Repository | Knowledge (`docs/knowledge/`) and code |
| Orchestrator (Queue, later Nucleus) | The plan (lanes, lane documents, each project's lane order), leads (including briefs), papercuts, tasks, status, review, closeout, permanent outcome records, per-repository settings such as the pre-merge validation command |

Task and planning state live in the orchestrator because, stored in Git, it needs digests,
hooks, guards, audits and compaction to stay honest. Most of Northstar's old
machinery existed for that reason; removing the state removed the machinery.

A repository carries no Queue files. Without a `.paseo/queue.json`, Queue uses
its own closeout (which writes nothing to the repository) and accepts briefs
stored in Queue. Per-repository settings go through Queue's CLI
(`repository.set`). The v1–v4 manifests and the hook bridge that served them
are retired; every Northstar repository is on the lean shape.

Vocabulary follows Queue: a **lane** is a durable group of work with an aim, a
working document and a set of repositories; a **task** is one unit of work; a
**lead** is an unresolved idea or observation, or a brief waiting for approval
and promotion to a task. A project's plan is its ordering of lanes (Queue Spec 026, Nucleus
contract 002). Planning left repositories on 2026-09-27, the way papercuts did
the day before.

## Repository shape

| Surface | Purpose |
| --- | --- |
| `AGENTS.md` | Orientation in one screen: what the project is, where things live, guardrails, the validation command. `CLAUDE.md` contains only `@AGENTS.md`. |
| `docs/README.md` | Current state in a page, linking knowledge by topic. |
| `docs/knowledge/` | Current truth, one owner per fact: vision, architecture, contracts (including `release.md`), domain. |
| `docs/knowledge/retired.toml` | Retired terms, paths and config keys, with their replacement and owner. A check fails on live references. |
| `docs/knowledge/questions.md` | Addressable open questions; an answer closes one by pointing at its owning file. |

Product documentation for a project's users stays where it is and is linked
from the knowledge index. Evidence that current knowledge cites line by line,
and executable proofs, stay frozen and are listed in `retired.toml`.

## The skill

`skills/northstar/`:

- `SKILL.md`: roles (planner, reviewer, worker), the knowledge rules, and
  pointers to references.
- `references/`: `plan`, `brief`, `review`, `knowledge`, `adopt`, `handover`.
- `template/`: the copy-ready starter for a new or migrating repository.
- `scripts/`, run through the skill's Effigy catalog (alias `northstar`):
  - `retired-concepts`: checks code, config and docs against `retired.toml`,
    including untracked files.
  - `cut`: applies a migration plan (moves, removals, link rewrites) and
    `check-links` verifies links and anchors afterwards.
  - `paseo:worktree`: prepares and links sibling checkouts for Paseo
    worktrees. Projects call it from `paseo.json` setup and teardown through
    the installed skill, so its selector must not change.
- Optional modules, loaded only when a repository opts in:
  - UI design delivery: the nested `northstar-ui` skill (`ui/`,
    `references/ui/`).
  - Language quality packages: `references/packages/`, the
    `language:route` task and its lifecycle script. Their contract is
    [contracts/language-quality-pack.md](contracts/language-quality-pack.md).

The installed copy lives at `~/.agents/skills/northstar`; harness skill folders
(Claude, pi) symlink to it. See [contracts/release.md](contracts/release.md).

## Knowledge mechanisms

The part of Northstar that still earns tooling, in order:

1. Retired concepts that name what they retire, checked across code, config
   and docs (built).
2. Addressable open questions that an answer closes (built as
   `questions.md`).
3. Rulings that land in their owning file before a Chatterbox thread ends
   (skill guidance).
4. Later, possibly in Nucleus: a knowledge manifest with typed links and
   suspect-link detection.
