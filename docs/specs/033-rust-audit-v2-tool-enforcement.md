# 033 - Rust Audit V2 Tool Enforcement

Status: retired-in-place — promoted and distributed
Owner: repo maintainers
Created: 2026-08-26
Updated: 2026-08-27
Depends on: `docs/contracts/003-agent-instruction-surface.md`,
`docs/contracts/004-language-quality-pack.md`
Research refs:
`bundle-docs/research/translation-memos/rust-quality-skills-and-audit.md`,
`bundle-docs/research/prototypes/rust-quality/live-use-report-2026-08-26-convergence.md`
Implementation precedent: [dmmulroy/anti-slop](https://github.com/dmmulroy/anti-slop)
Promotion targets: skill-shipped Rust CLI, Rust quality schemas, recorder,
checked projections, focused tests, production evidence, and installed parity
Roadmap ref: `docs/roadmaps/g02/032-strengthen-rust-audit-tool-enforcement.md`

## Problem

The distributed Rust audit can make useful repairs, but its v1 record does not
prove that every applicable rule or required review pass was assessed.
Convergence also showed that agent-resolved `worktree` scope can silently grow
into repository coverage. More instructions would leave both failures in the
same fallible context.

The TypeScript side supplies the stronger pattern. Northstar's TypeScript
recorder already models richer tool evidence and rejects warning-bearing or
runner-failure evidence as a clean pass. The external `anti-slop` project goes
further for syntactic rules: it vendors tested Oxlint AST rules, uses the skill
as an installer/configuration adapter, and checks source-to-skill asset parity.

## Goal

Move Rust audit v2 enforcement out of prose wherever the decision is
deterministic:

- derive and freeze dirty-anchor worktree scope before source assessment;
- generate the complete unit-by-applicable-rule assessment ledger;
- require explicit three-pass attestations and structured limitations;
- collect repository-native command evidence without converting unavailable
  tooling or warnings into success;
- reject missing verdicts, hidden scope growth, unattributed mutation, and
  summary/result disagreement;
- qualify narrow mechanical detectors with fixtures before they can enter the
  production catalogue.

The agent still judges applicability, architecture, invariants, readability,
and remediation. It supplies evidence into a checked record rather than being
trusted to remember every field.

## Tool boundary

### Deterministic responsibilities

The installed pack should own executable surfaces for:

1. Git-state capture and relevant Rust-anchor discovery;
2. anchor-to-context relation validation and repository-scope claim checks;
3. unit ownership and complete applicable-rule ledger generation;
4. mechanical evidence normalization by class, selector, environment, exit
   status, warnings, diagnostics, and failure stage;
5. record lifecycle, repair-plan authority, file fingerprints, mutation
   attribution, limitation derivation, and finalization;
6. catalogue/projection/schema checks, negative fixtures, and source/install
   parity.

These surfaces live in one locked Rust binary crate shipped inside the skill.
The skill installs it automatically into a payload-addressed Northstar cache and
invokes the absolute binary path. The engine uses Git and Cargo's versioned CLI
interfaces; it does not link Cargo internals, alter global PATH, or require a
consumer Effigy catalogue. Repository-owned selectors and applicable Effigy
graph/scanner evidence remain optional adapters. The engine must not invent one
universal Cargo command graph or install a consumer dependency silently.

### Judgment responsibilities

The agent remains responsible for:

- selecting `pass`, `finding`, `not_applicable`, or `degraded` from inspected
  source and call-path evidence;
- explaining architecture and human-quality conclusions;
- deciding whether a mechanical diagnostic is relevant to a catalogue rule;
- proposing the smallest authorized repair and protected behavior;
- stopping when policy or authority is unresolved.

A tool-generated candidate is evidence, not automatically a finding. An empty
candidate set is not automatically a pass for a partially decidable rule.

## Mechanical detector policy

Prefer stable upstream compiler and Clippy diagnostics when they express the
rule precisely. Do not enable `clippy::restriction` wholesale. Map individual
diagnostics through checked adapters and retain the original diagnostic.

A custom detector is eligible only when its pattern is syntactic, its false-
positive boundary is explicit, and fixtures cover valid, invalid, and exception
cases. Vendor its source into the installed skill or target repository, keep one
canonical copy, and mechanically check the distributed asset. Do not add a
custom lint for architecture quality, error semantics, cancellation safety, or
other meaning-dependent judgments merely to make them look deterministic.

Card 097 froze 14 candidates. Unsafe-structure and await-held-guard diagnostics
are promoted enforcement signals under existing rules. Public `Debug`, MSRV
item use, and broken rustdoc links are promoted evidence signals. Failure docs,
complexity, forwarder residue, and unfinished macros remain evaluation-only;
panic/invariant, cancellation, documentation completeness, and test adequacy
remain manual. Architecture/cohesion is rejected as a detector. No disposition
creates a rule, finding, plan, or repair authority.

## Context and routing

The main Northstar router stays a thin mode selector. Everyday Rust authoring
continues to load only applicable compact rule references. Shared scope and
evidence tools may support everyday changed-tranche closeout, but the explicit
audit procedure, full ledger, and repository-wide authority remain on-demand.

No new top-level Rust skill is introduced. Installation and upgrades remain
agent-owned through the existing Northstar setup/distribution path.

## Evidence gate

Before v2 distribution:

- focused fixtures must reject anchorless worktree scope, unowned context,
  missing or duplicate rule verdicts, empty attestations, degraded-as-clean
  claims, hidden mutation, and limitation drift;
- evidence adapters must preserve raw diagnostics and distinguish source
  failure from routing, configuration, startup, and collection failure;
- at least three fresh isolated production subjects and blind reviewers must
  pass the frozen primary-finding, authority, preservation, churn, and
  completeness gates;
- the exact evidenced payload must match source and installed skill copies.

Convergence is design evidence, not one of the fresh v2 production subjects.
Northstar does not dispatch or mutate an operator consumer repository.

## Non-goals

- no larger always-loaded prompt or duplicated rule list;
- no blanket `cargo fix`, repository formatting, or Clippy restriction group;
- no automatic architecture or semantic rewrite from heuristic output;
- no candidate-rule promotion inside the recorder implementation batch;
- no ordinary or high-assurance profile claim;
- no certification, NASA-compliance, safety-case, release, or consumer-repo
  mutation claim.

## Lane runway

- [x] prove the portable executable boundary and freeze command/record shapes;
- [x] implement scope provenance and assessment completeness;
- [x] add checked mechanical evidence adapters shared with changed-tranche closeout;
- [x] qualify candidate detectors and promote only evidence-backed signals;
- [x] run fresh isolated v2 production evidence;
- [x] distribute the exact passing payload and close the lane.

Card 094 first proved and then rejected a three-task Effigy/Rhai split after
operator review exposed its cross-root execution mismatch. The corrected card
freezes a Cargo-native, skill-shipped binary, managed bootstrap, semantic record
shapes, failure codes, and context budgets. The governing evidence report is
`bundle-docs/research/prototypes/rust-quality/rust-v2-boundary-report-2026-08-26-b.md`;
report A is retained as superseded research.
