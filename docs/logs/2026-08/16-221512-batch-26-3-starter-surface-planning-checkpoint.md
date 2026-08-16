# Batch 26.3 Starter-Surface Planning Checkpoint

- Date: 2026-08-16
- Milestone: `g02.026`
- Batch: `26.3`
- Planning card: `g02.026/078`
- Governing spec: `docs/specs/027-northstar-native-pre-execution-discovery.md`
- Status: implementation card ready; no worker dispatched yet

## Decision

Batch 26.3 will add copy-ready discovery starter surfaces, a worked
project-language example, and a cleared-map promotion record. The worked example
will model the first dogfood target: Poodle's current ready card
`g15.006 — React Mirror Implementation and Gallery Closure`.

The example is a Northstar template-bundle specimen, not a change to Poodle. The
actual Poodle dogfood remains a separate later handoff after card 078 is merged
and closed out.

## Why Poodle `g15.006`

Poodle is clean and synchronized at `81fbbf5`, and its active generation `g15`
identifies `g15.006` as the next ready dispatch. The card is bounded by measured
React gaps and existing Svelte contracts, with explicit scope, acceptance,
validation, and stop conditions. It is a better first dogfood target than
Figmatic while Tom is doing direct one-to-one interactive bug fixing there.

Source facts for the worked example are limited to:

- Poodle `docs/roadmaps/g15/README.md`;
- Poodle `docs/roadmaps/g15/006-react-mirror-closure.md`;
- Poodle `docs/roadmaps/g15/release-baseline-roster.md`;
- Poodle `docs/roadmaps/g15/release-gap-register.md`;
- Poodle `docs/architecture/001-poodle-system-shape.md`;
- Poodle `docs/contracts/001-working-rules.md`.

## Poodle project language seed

The example will keep these terms destination-local rather than promoting them
to Northstar's global glossary:

| Preferred term | Meaning / boundary |
| --- | --- |
| release denominator | The 175 public Svelte component exports used for the v0.2.0 release baseline; not an assertion that every runtime is complete. |
| measured gap | A missing surface observed directly in the repository and recorded in the release register; not an inferred absence. |
| React mirror | A React implementation, export, gallery specimen, or focused test paired to the Svelte-defined contract; not a cross-runtime certification claim. |
| focused evidence | A named test case beyond the anatomy smoke that asserts contract behaviour. |
| gallery specimen | Human-facing component documentation in the React preview; not a substitute for focused tests. |
| active cohort | Svelte, React, GPUI, and renderer-neutral Rust declaration/node output; Jetstream remains deferred. |
| deferred backend | A backend excluded from the active completion cohort until its own admission evidence passes; not a passing or accepted-parity state. |

Each entry will include aliases, authority, status, and rejected ambiguity in the
copy-ready project-language surface.

## Promotion path

The Batch 26.3 starter surfaces will demonstrate this non-automatic path:

1. inspect the destination repository and existing canonical docs;
2. create or repair the destination-local readiness map and linked decisions;
3. resolve repository-answerable facts, route operator decisions, and record
   bounded prototype evidence without granting execution authority;
4. recompute a deterministic frontier and stop when the map is genuinely clear
   or uncertainty is explicitly accepted;
5. write a promotion record linking the cleared map, decision records, master
   spec target, roadmap target, and required operator gate;
6. promote durable structural or policy outcomes through the destination's
   normal architecture/contracts/spec surfaces;
7. update the roadmap/card only after normal validation and explicit operator
   authorization; and
8. leave the map as evidence rather than a second execution authority.

The example must show the promotion record without applying it to Poodle.

## Baseline posture and limits

Poodle's `effigy doctor` reports pre-existing findings in generated-in-source,
god-file, stale-suppression, and comment-ratio scans. The release gap register
explicitly labels these as board-health findings rather than component gaps. The
Batch 26.3 worker must report them as baseline and must not silently claim that
Poodle is doctor-clean.

No Poodle or Figmatic files are changed by the planning checkpoint. Figmatic is
not the immediate dogfood target and remains deferred until its interactive
bug-fixing work returns to the orchestrator flow.

## Implementation card

`g02.026/078` is ready to run through the isolated worker/PR loop. Its bounded
scope, exact template/example surfaces, validation, stop conditions, and separate
Poodle handoff boundary are recorded in:

`docs/roadmaps/g02/batch-cards/078-add-discovery-starter-surfaces-and-poodle-example.md`

## Next task

Dispatch card 078 from synchronized `main`. After its reviewed merge and
closeout, prepare a separate Poodle dogfood handoff for `g15.006`.
