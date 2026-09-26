# Questions

Questions that block or shape work. Reference them by ID from the plan and from
briefs. An answered question keeps only its pointer to where the answer lives.

## Q-001 — How is Northstar versioned and tagged?

Status: open
Needed for: the first tagged release (see [contracts/release.md](contracts/release.md)).

## Q-002 — Where do language-package consumer files live in the lean shape?

Status: open
The language module still reads and writes `docs/contracts/language-quality-*.json`
in consumer repositories. Lean repositories keep internal rules under
`docs/knowledge/contracts/`. Decide the path when the module is reshaped.
