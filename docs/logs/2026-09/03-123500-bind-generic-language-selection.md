# Bind Generic Language Selection

Date: 2026-09-03
Roadmap: `g02.048`
Card: `g02.048/122`
Status: implemented; awaiting exact-head review

## Outcome

Core now selects one exact official language package from explicit workflow
intent or from an existing activation marker without any package-specific
router branch. Registry version advanced `1.4.0` → `1.5.0`: each official
entry carries data-only discovery metadata (languages, overlays, workflows,
exact activation marker) bound to the same pinned identities. The three
package-specific paragraphs that mapped intent to `@northstar/rust-quality`
and `@northstar/typescript-quality` are gone from routing; identity selection
is registry-owned. Nothing was deleted from the embedded payload, no package
policy changed, and card 120 remains blocked.

## Registry discovery binding

`official-registry.schema.json` requires a closed `discovery` object per
entry (`languages`, `overlays`, `workflows`, `activation_marker`; lowercase
token patterns, nonempty languages/workflows). `official-registry.json`
populates both accepted entries exactly as their verified manifests declare:

- `@northstar/typescript-quality` `0.1.0`: languages `typescript`, overlays
  `base`/`svelte`/`sveltekit`, workflow `explicit_audit_repair`, marker
  `northstar:typescript-quality`;
- `@northstar/rust-quality` `0.1.0`: languages `rust`, overlays none,
  workflows `everyday_authoring` + `explicit_audit_repair`, marker
  `northstar:rust-quality`.

Commits, tree digests, manifest digests, core ranges, and
`overlap-windows.json` are byte-unchanged. Discovery metadata was verified
against the pinned manifests (TypeScript working tree; Rust read from the
pinned sibling commit `56b2e11`); the package-source sibling was only read.

## Generic selection surface

`skills/northstar/scripts/language-package-lifecycle.ts` (inside the
portable-scan markers) gained:

- `selectRegistryEntry`: two query shapes — explicit intent (language +
  workflow + optional overlay) or an exact activation marker — select one
  entry. Zero matches ("stays unavailable"), multiple matches ("ambiguous"),
  and a single claimant outside the compatible core range all stop before any
  acquisition. Detection-only input is not a query shape at all.
- `parseRegistryDiscovery` plus duplicate-marker rejection at registry parse,
  so ambiguous shipped data fails before any host invocation.
- `discoveryAgrees` wired into `resolve`: a registry entry whose languages,
  overlays, or workflows disagree with the verified installed manifest is
  metadata drift and stops the route; exact agreement reopens it without
  refetching. Allowlist-only local routing is unchanged.
- A `select` CLI exposing the procedure to the root router and lifecycle
  checker; it refuses detection-only input ("detection is not selection
  authority").

The selection code names no package, language ecosystem, or acquisition path;
the existing `require_surface_clean` portable scan passes unchanged.

## Router and route integration

`references/router.md`: all three language sections now state that package
selection is registry-owned and generic, supply intent
(`rust`/`typescript` + workflow + overlays), and point to the selection
procedure. `references/packages/installed-package-route.md` gained
"Generic selection (before any route)" documenting the two query shapes, the
fail-closed rules, and the marker path for existing consumer activations
(exact match, never rewritten), plus a route-contract clause for
registry/manifest drift. Embedded mode content stays reachable only through
the bounded frozen-fallback path; contract 004's registry paragraph now
specifies discovery metadata, generic selection, and drift behavior.

## Negative proofs and review-oracle falsification

All seven card-122 oracle rows are falsified by committed, replayable
evidence (`effigy check:language-packages`):

| Invariant | Falsified by |
| --- | --- |
| Selection is data-driven | `require_surface_clean` scan over the selection implementation plus dual-entry policy-free fixture selections through the same CLI (`selection/two-entry-registry.json`) |
| Intent is explicit | `detection-only-language` CLI case fails closed; oracle-16 asserts detection is not a query shape; host-side detection stops remain (oracle-1/14) |
| One match means one identity | `duplicate-marker-parse` (parse-time rejection) and `duplicate-claim-ambiguous` (selection-time ambiguity) fixtures; oracle-16 ambiguity stops |
| Registry and package agree | oracle-18: manifests dropping/adding languages, overlays, or workflows stop as metadata drift; exact agreement routes; consumer byte-identical |
| Existing activation survives | `typescript-activation-marker` and `rust-activation-marker` CLI cases select registered entries from markers alone; oracle-17 proves exact-match semantics (prefix/unknown fail) |
| Unsupported work stays unavailable | `typescript-everyday-unavailable` and `cross-package-overlay-unavailable` CLI cases; oracle-16 unsupported-workflow/undeclared-overlay stops |
| Trust stays separate | Discovery is data-only in schema and parser; acquisition authority still flows exclusively through registry pins/allowlist trust (oracle-9/14 unchanged and passing) |

New fixtures: `selection/two-entry-registry.json` (policy-free generic
positives), `negative/ambiguous-discovery/duplicate-marker-registry.json`,
and `negative/ambiguous-discovery/duplicate-claim-registry.json`; existing
mutable-source and duplicate-registry negatives gained discovery metadata so
they still fail for their intended reasons. The checker pins registry
`1.5.0`, both discovery bindings, exactly-selectable shipped data, and
sixteen selection CLI cases; lifecycle oracle-16/17/18 cover the same
invariants in-process.

## Validation

- `effigy check:language-packages`
- isolated `effigy check:skill-install skills/northstar`
- `effigy qa:docs`
- `effigy qa`
- `git diff --check`

All passed at the exact head recorded in the PR description.

## Limits

Card 120 is untouched: embedded payloads, the three mode files, and both
overlap windows remain until the bounded-removal card. No package manifest,
rule, workflow availability, or trust authority changed. The sibling
package-source repository was read-only.
