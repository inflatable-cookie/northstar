# Operator Doc Pruning Rubric

Use this rubric after an operator pilot to decide whether a page should stay,
merge, or be removed.

## Keep A Page When

- it changes the operator's decision faster or more accurately
- it covers a distinct job that another page does not
- operators refer to it directly during a real workflow

## Merge A Page When

- operators consistently open it together with another page
- it repeats the same routing or examples with only minor variation
- the distinction between the two pages does not change operator behavior

## Trim A Page When

- its useful content fits as one section inside a stronger page
- operators only read one small part of it
- it mostly restates nearby docs without adding a new decision or example

## Remove A Page When

- operators do not need it during a real drill or pilot
- its content is fully covered by another page
- it introduces more navigation overhead than clarity

## Recommended First Review Targets

After the first pilot, compare these clusters:

- `operator-quick-start.md` vs any remaining support page the operator opened
- prompt surfaces vs direct skill invocation
- operator docs vs skill metadata when routing still felt ambiguous

## Output Format

For each reviewed page, record:

- decision: keep / merge / trim / remove
- reason:
- destination page if merging:

## Next task

Run the first consumer-repo pilot and apply this rubric to the operator docs
cluster as one pruning batch instead of piecemeal edits.
