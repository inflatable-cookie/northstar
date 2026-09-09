# g01 Tasks

**Type: REQUIRED** -- One README per active generation.

Task files in this generation use:

- `001-<slug>.md`
- `002-<slug>.md`
- `003-<slug>.md`

References must include generation key: `g01.001`, `g01.002`, `g01.003`.

## Generation Runway

| Goal | State | Governing refs | Next task |
| --- | --- | --- | --- |
| Establish the first contract-backed execution lane. | active | `<contract refs>` | `g01.001` |
| Prove the first task can close with evidence and front-door currentness intact. | next | `<contract refs>` | pending |

Update this runway only when generation-level intent changes, a task
materially advances or closes a goal, or rollover is being considered. Do not
rewrite it as a per-turn task list. The runway does not need to pre-plan every
future task, but it should keep the generation moving as a significant
20-to-50-task sequence.

## Seed files

- `001-example-foundation-batch.md`
- `002-example-analytics-export.md`
- `templates/task-template.md`

## Next task

Create `001-<slug>.md` from `templates/task-template.md` and ensure it ends with `## Next task`.
