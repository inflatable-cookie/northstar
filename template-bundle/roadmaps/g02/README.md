# g02 Milestones

**Type: EXAMPLE** -- Shows a second generation. Remove from your project after reading.

Milestone files in this generation use:

- `001-<slug>.md`
- `002-<slug>.md`
- `003-<slug>.md`

References must include generation key: `g02.001`, `g02.002`, `g02.003`.

## Generation Runway

| Goal | State | Governing refs | Next milestone |
| --- | --- | --- | --- |
| Reset sequencing around the new generation boundary. | active | `<contract refs>` | `g02.001` |
| Rehome or close any stale prior-generation work before new execution outruns the rollover reason. | next | `generation-index.md` | pending |

Update this runway only when generation-level intent changes, a milestone
materially advances or closes a goal, or rollover is being considered. Do not
rewrite it as a per-turn task list. The runway does not need to pre-plan every
future milestone, but it should keep the generation moving as a significant
20-to-50-roadmap sequence.

## Seed files

- `001-example-platform-reset.md`
- `batch-cards/README.md` (when batch cards are used)

## Next task

Create `001-<slug>.md` only after the rollover reason is recorded in
`generation-index.md` and stale `g01` work is explicitly superseded.
