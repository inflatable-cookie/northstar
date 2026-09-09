# g03.003 Flatten Execution Tasks

Status: ready
Owner: repo maintainers
Created: 2026-09-09
Governing refs: contract 001, system architecture
Depends on: `g03.002` complete

## Outcome

Replace the milestone-plus-batch-card hierarchy with one executable Northstar
task at `docs/roadmaps/gNN/NNN-<slug>.md`. Keep `docs/roadmaps/` and generation
IDs: the generation README is the roadmap; task files carry implementation and
closeout detail. This follows observed use, where agents execute cards directly
and milestone wrappers duplicate state without governing longer work.

## Decisions

- Call the unit a **task** and reference it as `gNN.NNN`.
- Keep `docs/roadmaps/`; do not rename it to `docs/tasks/`.
- Remove `batch-cards/` and milestone/card indirection in one pre-1.0 change.
- Model long work as dependency-linked meaningful tasks in the generation
  runway. Keep specs only when shared provisional design warrants them.
- A queue task transports one Northstar task. An Effigy task is a command
  selector. Neither becomes canonical planning authority.
- Do not rewrite archived generation roll-ups merely to modernize nouns.

## Dispatch manifest

- **State:** ready after this planning commit is pushed to `main`; one lane,
  no concurrent siblings, no automatic successor.
- **Completion:** reusable doctrine, source and installed skills, templates,
  checks, fixtures, current Northstar planning, and handoff/queue wording expose
  one task level; independent exact-head review accepts the result; PR merges;
  local `main` is synchronized; this task and front doors close.
- **Owned mutable paths:** `README.md`, `bundle-docs/**`, `template-bundle/**`,
  `skills/northstar/**`, relevant `scripts/**` and `effigy.toml` task wiring,
  `docs/contracts/001-working-rules.md`, current `docs/roadmaps/**`,
  `docs/README.md`, and this task's committed worker handoff.
- **Reserved closeout surfaces:** this task, `docs/roadmaps/g03/README.md`,
  `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`,
  `docs/README.md`, and any justified compact evidence record.
- **Worker:** automatic adequate implementation pool; frontier justification:
  none. Reviewer must use an independent provider/model identity.
- **Excluded:** product runtime features, queue-plugin implementation,
  `.github/workflows/`, releases, new generation, history rewrites, consumer-
  repository migrations, and unrelated mode consolidation.
- **Escalation:** Chatterbox owns semantic or compatibility decisions. Stop
  before adding aliases or retaining two supported execution hierarchies.

## Work

1. Replace the active doctrine with the generation-plus-task model. Remove
   rules that require multiple cards per milestone, dual status updates, or a
   `batch-cards/` directory. Preserve readiness, bounded autonomy, ownership,
   stop conditions, exact-head review, evidence, and generation compaction.
2. Update the compile, refresh, cleanup, Chatterbox, handoff, worker, review,
   and orchestration/queue-facing skill surfaces so they create, consume,
   close, and link one `gNN.NNN` task. A worker handoff remains transport and
   must resolve the owning task.
3. Flatten reusable starter/template structure. New consumers get
   `roadmaps/g01/001-<slug>.md`; no empty or optional `batch-cards/` scaffold.
4. Rework deterministic checkers and fixtures to accept only the flattened
   active shape. Reject nested executable cards, duplicate task IDs, a ready
   task outside the approved frontier, and front doors naming different tasks.
   Preserve closed-generation roll-up checks and realistic negative fixtures.
5. Reconcile current Northstar `g03`: absorb unique completion evidence from
   cards 130–133 into tasks 001–002, delete the consumed card files/directory,
   and keep this file as task 003. Do not rewrite `g01`/`g02` roll-ups.
6. Verify source/install parity and run focused structural/fixture checks,
   `effigy qa:docs`, `effigy qa`, and `git diff --check` on the complete change.

## Acceptance and review oracle

| Invariant | Failing counterexample | Required proof |
| --- | --- | --- |
| One execution level | A ready roadmap points to a nested card for its steps or status | Repository-wide current-source search plus valid fixture has no active `batch-cards/` dependency |
| Task remains turnkey | Flattening drops acceptance, owned paths, stop rules, review, evidence, or closeout | Task template and fixture exercise every readiness field formerly required of a card |
| Long work stays legible | One task becomes a vague multi-month bucket because the wrapper vanished | Generation runway shows meaningful dependency-linked tasks and a planning checkpoint |
| IDs are unambiguous | Two files claim `g05.003`, or filename/frontmatter/front doors disagree | Positive and negative deterministic fixtures |
| Tool nouns remain distinct | Queue state or `effigy tasks` silently becomes planning authority | Doctrine and handoff checks bind execution back to a committed `gNN.NNN` path |
| Migration is direct | A compatibility alias, empty card directory, dual checker path, or deprecated card template remains | Exact deletion/caller inventory and adversarial review |
| Evidence survives | Deleting cards 130–133 loses their PR, head, merge, validation, or material limitation evidence | Before/after preservation map into g03 tasks 001–002 |
| Consumers have one starter | New template still scaffolds milestone plus card | Copy-ready template inventory and consumer fixture |

## Stop conditions

Stop if a supported external contract demonstrably requires nested card paths,
if preserving current evidence has no canonical task destination, if queue
transport cannot resolve a flattened task without a queue-plugin change, or if
validation reveals a material lifecycle regression. Bring the exact impact and
options to Chatterbox; do not add a shim.

## Next task

Execute `g03.003`. On closeout, return to Chatterbox; no successor is approved.
