# 042 — Lean Northstar

Status: approved design
Owner: operator + Northstar Chatterbox
Created: 2026-09-25
Execution authority: Tom approved this design on 2026-09-25. It governs `g04`,
supersedes `g04`'s original first slice and absorbs spec 041. Work still
executes only through approved `g04` lanes and the Queue Chatterbox's own
planning.

## Why

Northstar was built for agents that needed heavy scaffolding. Current agents
need less instruction and better knowledge, and Northstar now spends more
effort recording work than doing it.

- **Northstar itself** has a 1,398-line working-rules contract, a 276-file
  skill (6,000 lines of Markdown, 9,700 of TypeScript), 19 modes and 11,600
  lines of bundle doctrine.
- **One lane, bughunt `g01.005`**, fixed about two lines of README. Around it
  sat an 89-line card, a 69-line handoff, a lifecycle record, three projection
  updates, four commits, a worker, a reviewer and a hook closeout.
- **Acowtancy**, the largest consumer, has 170,000 lines of process record
  (1,155 logs, 307 retained "transient" handoffs, 243 roadmap files) against
  62,000 lines of contracts and architecture. Over the last 30 days it had
  1,645 `docs:` commits and 747 code commits. Its `g05` runway is a 990-line
  hand-written status mirror. Its agents re-asked settled questions and planned
  work against a concept retired five weeks earlier (spec 041, F1 and F2).

The root cause is that **task state lives in the repository**. Status, stages,
handoffs, closeout records, frontier prose and projections are orchestration
runtime state. Stored in Git, they need digests, hooks, guards, audits and
compaction to stay honest, and most of Northstar's machinery exists for that
reason. `g03` automated that bookkeeping instead of removing it.

## Principles

1. **The repository holds knowledge and code, not process.** Task state,
   briefs, review and closeout live in the orchestrator.
2. **One home per fact.** Current truth is organised by topic, with each fact
   owned in one place, and it is the thing Northstar actually maintains.
3. **Say it once, briefly.** Doctrine a capable agent already follows by
   default is removed, not restated.
4. **Write only what a future reader needs.** A record exists because someone
   will need it later, not because a step happened.
5. **Checks guard knowledge, not bookkeeping.** Validation proves that code
   works and that knowledge matches what runs.

## Target repository shape

| Surface | Purpose | Replaces |
| --- | --- | --- |
| `AGENTS.md` | Orientation: what the project is, the doc map, guardrails, the validation command. One screen. | Long agent instructions and the mode routing inside them |
| `docs/README.md` | Current state in a page: what's true now, links by topic. | Front doors with projections and runway pointers |
| `docs/knowledge/` (vision, architecture, contracts, domain) | Current truth, one owner per fact, with retired concepts and closable questions (spec 041). | Scattered rulings, decision registers, rulings buried in task cards |
| `docs/plan.md` | Intent: what matters next and why, a short prioritised list with no status mirror. | Generations, runways, `WORKSTREAMS`, per-task cards |
| `docs/triage/` | Intake for unresolved leads. | Unchanged |
| `PAPERCUTS.md` | Friction notes. | Unchanged |

Removed from repositories: `.northstar/lifecycle/**`, generated projection
blocks, committed handoffs, per-task roadmap cards, generation rollovers and
roll-ups, and routine delivery logs. A log survives only as a record of an
incident or a material ruling, and a ruling should be promoted into the
knowledge doc it changes.

Confirmed by Tom on 2026-09-25: a human reading the repository on GitHub sees
intent in `docs/plan.md`, and live task status in the Queue/Paseo UI (and later
Nucleus hosts), not in Git.

## Orchestration: pilot on Queue, port to Nucleus

The Paseo Queue plugin stays the task system. Nucleus, a formal
reimplementation of Queue that can run in several host front ends with BB as
its first, is not ready yet. So these changes are piloted on Queue and then
ported to Nucleus core.

What Queue needs to take on, in the order agreed with the Queue Chatterbox on
2026-09-25:

1. **A closeout that writes nothing to the repository, plus a permanent
   outcome record.** Queue records the terminal outcome (PR, merge commit,
   review, validation, brief) in a record that retention never deletes. Today
   `store.purgeOldTasks` deletes finished tasks 14 days after they end, keeping
   only a tombstone. That is harmless while repositories keep the record; under
   this design Queue is the only record. The outcome record (4a) is one
   host-neutral row per terminal task, written in the same transaction as the
   terminal transition. It holds the task, submission, title, repository,
   outcome, PR, reviewed head, merge and synced commits, review summary,
   validation result, brief digest and brief text, and finish time. Today a repository without a closeout hook
   also falls back to `agent` closeout, which is heavier still.
2. **Briefs stored in Queue.** A new submission mode (brief content plus
   digest) sits alongside the committed-handoff path and never replaces it.
3. **Pre-merge checks as plain repository validation.** The manifest runs the
   repository's own command (for example `effigy qa`) at the prospective merge,
   not a Northstar adapter. Exit code 0 passes; non-zero refuses with a bounded
   output excerpt. For acowtancy this needs Effigy to validate a given
   disposable checkout with prepared dependencies, which it does not yet do, so
   Queue proves item 3 on a simple repository first.
4. **The outcome query (4b).** "What landed for X, and in which PR" is answered
   from the 4a records through an RPC, a CLI command and skill wording, so
   repositories need no delivery log.

**No Queue files in repositories** (Tom, 2026-09-26). A repository with no
`.paseo/queue.json` gets Queue closeout and brief mode by default, and project
settings such as the pre-merge validation command live in Queue's own store,
set through the CLI. So item 3 is a per-project validation command held by
Queue, not a manifest field. Manifests remain only for repositories still on
v1–v4. Migrated repositories delete theirs once Queue ships the default; until
then they keep the v5 manifest below.

Migrated repositories declare a new manifest version, `paseo.queue.control.v5`.
It keeps v4's hook definitions with hooks optional, and adds
`closeout: "queue" | "hooks"` (default `hooks`, the v4 behaviour) and
`validation`. Repositories on v1–v4 are untouched. Queue Specs 006, 007 and 015 do not
conflict: 006 stops applying to migrated repositories, and 007 and 015 carry
over. The Queue-to-repository contract shrinks to the manifest and the
repository's validation command. The Northstar hook adapter, lifecycle
records, backlink guard and compaction become unnecessary for a repository once
it migrates.

## Plan items and Queue lanes

Queue Spec 019 (`g01.050`) adds lanes: a durable, global group with a grounded
aim and an explicit list of participating repositories. A lane never gates
dispatch, and its aim is context, not authority. A `docs/plan.md` item that is
being worked maps to a lane, which gives tasks their intent from the same
source. Briefs (Queue Spec 020, `g01.051`) carry `queue.lane`, and brief mode is
allowed only for v5 manifests or no manifest.

Vocabulary follows Queue: a **lane** is the group, and a **task** is one unit of
work. The lean skill and doctrine use those terms; Northstar's older use of
"lane" for a single task retires with the old surfaces.

## Skill shape

A core skill of under about 200 lines of guidance that covers orientation,
planning into `docs/plan.md`, writing a brief, review, and knowledge upkeep
(promote rulings, retire concepts, close questions). Specialised flows, such as
UI design delivery and language quality packages, become optional modules. The
contract, bundle doctrine and template all shrink to match, each saying a rule
once.

## Draft and cut inventory

The draft lives on branch `lean-northstar` at `skills/northstar-lean/`: a
100-line `SKILL.md`, five references, the retired-concepts check, and the
copy-ready starter under `template/`. Since 2026-09-26 it is installed
alongside the current skill as `northstar-lean`, so trial repositories can use
it while the `northstar` skill that Queue pins stays untouched. It replaces the
current surfaces only at the cut.

Rollout (Tom, 2026-09-26): trial on nightfire, then underlay, then acowtancy.
A repository with a live Chatterbox migrates through that Chatterbox after a
direct refresh onto `northstar-lean`. The Northstar Chatterbox migrates
repositories that have none.

| Surface today | At the cut |
| --- | --- |
| `skills/northstar/SKILL.md`, `references/router.md`, the 19 `references/modes/`, `handoff-contract.md`, `lifecycle-maintenance.md`, `setup/` | Replaced by `skills/northstar-lean/`, which moves to `skills/northstar/` |
| `skills/northstar/commands/*` except `come-again` | Removed; their jobs are in the lean skill or retired |
| `scripts/lifecycle-*.ts`, `references/lifecycle/`, the `queue:hook` Effigy task, `scripts/tests/lifecycle-adoption/` | Kept as the migration bridge until the last v1–v4 manifest migrates, then removed |
| `ui/`, `references/ui/`, `references/packages/`, language-package scripts, `check-agent-instructions.rhai` | Kept as optional modules, reshaped later |
| `scripts/paseo-worktree.rhai` | Removed; Queue owns worktrees |
| `bundle-docs/` (11,600 lines) | Removed; lasting guidance lives in the skill's references |
| `template-bundle/` | Replaced by the skill's `template/` |
| Repository checks for the old bundle (bundle, command skills, model routing, posture advisory, readiness map, repo contract, UI protocol) | Removed; replaced by the retired-concepts check and a small check of the new shape |
| Northstar's own `docs/` (contract 001, roadmaps, logs, handoffs, lifecycle records) | Migrated by the same cut as any consumer |

## Knowledge mechanisms (from spec 041)

In order: retired concepts that name what they retire, with a check across
code, config and docs; addressable open questions that an answer closes;
rulings that must land before a Chatterbox hands off; and later a knowledge
manifest with typed links. These are the part of Northstar that still earns
tooling.

## Migration

The shared interface is the hazard. All 31 adopted repositories resolve one
installed skill through `northstar/queue:hook`, and Queue reads each
repository's manifest at every event's base commit, not per task. So:

1. **Queue first.** Ship the no-write closeout, briefs stored in Queue, and
   plain-validation pre-merge checks, alongside the current contract.
2. **Keep the hook entrypoint alive.** The redesigned skill keeps
   `northstar/queue:hook` working for repositories still on the old manifest.
   This is a bounded migration bridge, and it is removed when the last manifest
   migrates.
3. **Acowtancy is the pilot, and it must not break.** Its in-flight tasks keep
   their pinned briefs and finish normally:
   - switch its manifest to `{ v5, closeout: "queue", hooks: [] }` once item 1
     exists; the drain means nothing is
     in flight at the switch;
   - release held work or submit new work only after items 2 and 3, because
     today's Northstar pre-dispatch and pre-merge hooks assume committed
     handoffs and would refuse it;
   - then make one deliberate cut: move logs, handoffs, lifecycle records and
     roadmap cards out of the live tree (Git keeps them); fold rulings into
     `docs/knowledge/`; and replace the `g05` runway with `docs/plan.md`.
4. **Northstar itself** follows the same cut and becomes the reference example.
5. **The rest of the portfolio** migrates per repository once the pilot holds,
   then the bridge is removed.
6. **Nucleus** takes the proven Queue behaviour as its core contract.

## Acowtancy drain (Tom, 2026-09-25)

Acowtancy's queued tasks are held and its running workers drain. Blocked tasks
are resolved individually rather than left pinned. The cut happens once no
acowtancy task is in flight and Queue's no-write closeout exists. Held tasks
are then replanned in the new shape, or released unchanged if they still fit.

## Operator rulings on the acowtancy drain (Tom, 2026-09-25)

- Interim accepted: until item 3 works for acowtancy, new-shape acowtancy work
  merges on independent review and GitHub's merge checks, with no prospective
  pre-merge validation.
- The pre-merge validation command is acowtancy's concern, not Effigy's. The
  repository defines a command that validates a fresh checkout. Effigy is
  consulted only if that command needs container-backed checks.
- Blocked tasks: `g05.227` resumed under an approved local-only review policy;
  `g05.222` cancelled, to be replanned after the cut; `g05.180` split, merging
  PR #330 on what is proven, with the live A→B matrix as a follow-up once an
  isolated macOS VM exists.
