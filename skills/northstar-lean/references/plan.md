# Plan

`docs/plan.md` says what matters next and why. It is intent, not status.

## Shape

```markdown
# Plan

Updated: 2026-09-26

## Now

1. **Mock exam journey** (lane `mock-exams`) — learners can sit a timed mock end
   to end before December. Depends on Farmyard drafts and resume. Open: Q-014.
2. **Private desktop updates** (lane `desktop-updates`) — ...

## Next

- ...

## Not now

- Spreadsheet marking — waits on the Marking Hub design.
```

- Keep **Now** to a handful of items, each with the outcome, why it matters,
  dependencies, and any open question IDs.
- **Not now** records deliberate deferrals, so nobody re-proposes them.
- A standing item that is never finished, such as keeping versions current,
  sits under **Now**, marked "(standing)". Its rules live in a contract, not in
  the plan.
- Remove an item once its outcome is true. Queue keeps the record of what
  landed, so the plan doesn't need a "done" section.
- Never write task status here: no "in review", "merged" or PR numbers.

## Lanes

A plan item being worked can own a Queue lane:

- the lane key appears next to the item;
- the lane's aim restates the item's outcome and why, and grants no authority;
- a lane may span repositories, while each repository keeps its own plan;
- tasks attach through `queue.lane` in their brief.

When the item leaves the plan, close its lane (`done` or `abandoned`, with a
note).

## Changing the plan

The planner changes the plan with the operator. A worker never edits
`docs/plan.md` except to fix a link its own change broke.
