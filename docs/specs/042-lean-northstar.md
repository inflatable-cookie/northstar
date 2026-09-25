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

What Queue needs to take on:

1. **A closeout that writes nothing to the repository.** Queue records the
   terminal outcome (PR, merge commit, review, validation) in its own store.
   Today a repository without a closeout hook falls back to `agent` closeout,
   which is heavier still.
2. **Briefs stored in Queue.** A brief is submitted as content and pinned by
   digest in Queue, not committed to the repository and later deleted by a
   hook.
3. **Pre-merge checks as plain repository validation.** The manifest runs the
   repository's own command (for example `effigy qa`) at the prospective merge,
   and not a Northstar adapter.
4. **Queryable outcomes.** "What landed for X, and in which PR" comes from
   Queue, so the repository needs no delivery log.

The Queue-to-repository contract shrinks to the `.paseo/queue.json` manifest
and the repository's validation command. The Northstar hook adapter, lifecycle
records, backlink guard and compaction become unnecessary for a repository once
it migrates.

## Skill shape

A core skill of under about 200 lines of guidance that covers orientation,
planning into `docs/plan.md`, writing a brief, review, and knowledge upkeep
(promote rulings, retire concepts, close questions). Specialised flows, such as
UI design delivery and language quality packages, become optional modules. The
contract, bundle doctrine and template all shrink to match, each saying a rule
once.

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
   - switch its manifest only once Queue's no-write closeout exists, so a task
     closing after the switch gets a clean Queue-owned closeout rather than
     `agent` closeout;
   - submit new work in the new shape only after the switch;
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

## Open questions

1. The Queue work items 1–4 need Queue Chatterbox agreement on scope and
   order.
