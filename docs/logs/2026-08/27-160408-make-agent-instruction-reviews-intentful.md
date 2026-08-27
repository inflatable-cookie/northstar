# Make Agent Instruction Reviews Intentful

Date: 2026-08-27
Roadmap: `g02.027`
Card: `g02.027/101`
Status: complete

## Result

Northstar now reviews an `AGENTS.md` as a human decision surface before it
reviews it as context inventory. The contract and routed review ask what each
section helps an agent understand, preserve, avoid, decide, or verify; how the
sections create a reader journey; and whether hard boundaries, defaults, taste,
and user-overridable guidance are distinguishable.

The deterministic task remains deliberately narrower. It reports measurements,
section headings, bridge health, and transparent placement, procedure, or
freshness leads. It no longer flags conversational guidance as presumptively
misplaced and explicitly declines to judge prose.

## Source translation

The operator supplied T3 Code's `AGENTS.md` as the live-use correction. The
review found this section-level flow:

| Surface role | Effect on the reader | Northstar translation |
| --- | --- | --- |
| product identity and differentiators | establishes stakes and preservation intent before commands | orientation plus project invariants |
| maintainer note and glossary | transfers taste and aligns local language | local judgment and shared vocabulary |
| named failure modes | makes a few costly hazards causal and memorable | sharp edges, not a generic prohibition dump |
| cross-surface checklist | defines conscious completeness, including explicit non-support | project-specific completion lens |
| development, data, verification, and PR guidance | gives reliable mechanics after intent is understood | verified common workflow with detailed procedures on demand |
| architecture, code map, and taste | connects responsibilities to local engineering decisions | compact responsibility map and clearly labelled taste |

Northstar copied none of the source prose or product-specific headings. The
translation memo records the design lesson and the contract makes its sequence
adaptable rather than mandatory.

## Worked surfaces

The Northstar source file now moves through project identity, preservation
invariants, work flow, sharp edges, navigation, and completion. It retains the
existing compatibility, worker-mode, release, triage, Effigy, validation,
papercut, and stop boundaries.

The copy-ready template now prompts adoption agents to supply real project
identity, invariants, hazards, and completion coverage, then remove the prompts.
Its setup guidance says to merge Northstar boundaries into an existing useful
voice rather than replacing that voice with boilerplate.

## Context evidence

The earlier compacted source measured 43 non-blank lines / 2,619 bytes; the
template measured 35 / 1,707. The intentful source measures 62 / 3,800 and the
template 50 / 3,065. Both remain comfortably inside the 100-line / 12 KiB soft
budget. The deliberate increase buys identity, causal explanation, human flow,
and adaptation prompts; it is not treated as regression or quality score.

## Validation

- `effigy check:agent-instructions` — pass; both Claude bridges resolve and
  mechanical leads are informational;
- `effigy qa:docs` — pass;
- `effigy qa` — pass;
- skill-creator validation — source and installed payload pass;
- `effigy check:skill-install /Users/tom/.agents/skills/northstar` — pass,
  120 source-identical files after the documented local development sync;
- `git diff --check` — pass.

## Lane state

Card 101 completes Batch 27.3 and closes `g02.027`. The continuation envelope
and lane budget are exhausted with pause signal `lane-complete`.

## Next

Accept further operator-provided instruction-surface feedback when it appears.
No blocking instruction-surface work remains.
