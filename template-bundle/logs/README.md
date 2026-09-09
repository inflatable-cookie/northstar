# Logs

**Type: REQUIRED** -- Every Northstar project needs this folder.

Logs capture dated evidence and assessments.

## Segmentation model

- Group logs by month directory: `YYYY-MM/`
- Name each log: `DD-HHMMSS-<slug>.md`

## Cadence rule

- Create logs only for exceptional evidence or a material update cycle.
- Record normal delivery evidence on the completed roadmap task.

## Closeout rule

Use logs only after the task and currentness surfaces are settled:

1. update the current roadmap task
2. update the generation runway if its state changed
3. update currentness surfaces that still name the active lane, ready task, or
   recent evidence chain
4. record evidence and validation actually run on the task
5. write a log only when material evidence needs a durable separate record
6. record whether the continuation envelope still holds or a stop signal
   exhausted it
7. record the lane budget state and pause signal when the run paused cleanly
7. create or update a handoff under `docs/handoffs/` only if another thread
   genuinely needs to continue
8. refresh the roadmap front doors with one explicit next-task pointer

## Continuation note

- When a task ends inside a ready chain, say whether another in-bounds task
  remains.
- When continuation stops, name the stop signal instead of implying that the
  next thread should simply keep going.
- When the run paused cleanly, name the pause signal and whether more autonomy
  budget remains for the lane.

## Operator-facing summary

- In the human-facing closeout message, lead with the achieved result and the
  current lane state before listing validation.
- Keep protocol detail present but compressed.
- A short useful pattern is:
  - achieved result
  - current lane state
  - validation only when it failed or materially affects confidence
  - next move

Use that pattern for the end-of-turn closeout message, not every short reply.

## Writing style

- Logs are internal execution evidence. Default to compressed, glue-light
  writing.
- Prefer dense factual bullets over polished narrative.
- Keep enough context for later traceability, but remove filler and repeated
  framing.

## Lean evidence rule

- Manual validation notes and commands run are the default evidence format.
- Add checker scripts only when recurring pain justifies automation.
- If a checker is added, include an automation adoption note with owner/cadence/sunset trigger.

## Decision policy

- Do not maintain a separate `decisions/` folder by default.
- Capture major decisions as dedicated decision logs in this folder.
- For legacy migrations, rewrite references and remove old `decisions/` files in the same task (no compatibility shim files).

## Seed file

- `YYYY-MM/01-090000-example-roadmap-g01-001-task-closeout.md`
- `YYYY-MM/02-100000-example-planning-gap-g01-002-analytics-export.md`
- `YYYY-MM/03-110000-example-contract-delta-g01-002-analytics-export.md`
- `YYYY-MM/04-120000-example-roadmap-recompile-g01-002.md`
- `YYYY-MM/05-130000-example-rollover-decision-g02.md`
- `YYYY-MM/06-140000-example-contract-delta-g02-platform-reset.md`
- `YYYY-MM/07-150000-example-first-task-g02-001.md`

## Handoff convention

When a fresh thread needs to take over, write the note under
`docs/handoffs/YYYYMMDD-HHMMSS-<slug>.md`. Keep logs for evidence and handoffs
for human-friendly re-entry.

## Templates

- `templates/roadmap-contract-delta-template.md`
- `templates/roadmap-gate-log-template.md`
- `templates/decision-log-template.md`
- `templates/thread-handoff-template.md` (optional)
- `templates/automation-adoption-note-template.md` (optional)
- `templates/roadmap-currentness-triage-template.md` (optional)

## Currentness support

- keep `docs/logs/README.md` aligned with the recent evidence chain for the
  active lane
- keep any surface that names the current ready card or active lane aligned
  with closeout so a finished card is never still presented as the active one
- keep a bounded evidence window there, usually the most recent 5 logs for the
  active lane plus any still-governing rollover or decision log needed to
  explain the current state
- use `templates/roadmap-currentness-triage-template.md` only when currentness
  cleanup is itself the task, or when multiple stale front-door/evidence
  surfaces need a short explicit cleanup pass beyond ordinary closeout
