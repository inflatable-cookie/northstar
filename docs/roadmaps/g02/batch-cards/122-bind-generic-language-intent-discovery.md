# 122 - Bind Generic Language Intent Discovery

Status: in review; implementation complete
Owner: repo maintainers
Updated: 2026-09-03
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/contracts/004-language-quality-pack.md`,
`docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`, card 120
Auto-start next card: no

## Ready-State Checks

- [x] both official package identities and consumer canaries are accepted;
- [x] the removal inventory identifies the current hard-coded selection seam;
- [x] contract 004 requires data-driven language/workflow routing and preserves
  existing valid activations;
- [x] no package rule, repair authority, or new language is in scope;
- [x] card 120 remains blocked until this selection layer is reviewed.

## Objective

Let core select one exact official language package from explicit workflow
intent or an existing activation without a package-specific router branch, so
the embedded modes can be deleted without making missing packages
undiscoverable.

## Scope

- extend official-registry entries with data-only supported languages,
  overlays, workflows, and exact activation markers;
- require language/overlay/workflow metadata to agree with the verified
  installed manifest before routing;
- select exactly one compatible registry entry from explicit intent, or from
  an exact registered activation marker already present in the consumer;
- stop on zero, duplicate, ambiguous, incompatible, or metadata-drifted
  matches without acquisition or consumer mutation;
- expose the generic selection procedure to the root router and lifecycle
  checker while leaving the bounded embedded fallback intact for card 120;
- update schemas, fixtures, portable checks, installed-skill parity, contract
  wording, and affected operator documentation.

Do not delete embedded payloads or overlap fallback, change either package's
rules or manifest, add a language, infer acquisition from source detection, or
broaden third-party trust.

## Acceptance Criteria

- [x] the official registry schema carries portable discovery metadata and
  both accepted entries populate it;
- [x] explicit Rust, TypeScript, and Svelte-overlay audit intent selects the
  exact accepted entry without naming that package in selection code;
- [x] Rust everyday-authoring intent selects only the Rust package while
  TypeScript everyday authoring remains unavailable;
- [x] the existing `northstar:rust-quality` and
  `northstar:typescript-quality` activation markers select their registered
  entries without rewriting consumer files;
- [x] registry/manifest metadata drift, duplicate matches, unknown markers,
  unsupported workflows, and detection-only input fail closed before
  acquisition;
- [x] installed local routing, official acquisition authority, revocation,
  offline behavior, and third-party trust remain unchanged;
- [x] core contains one generic selection path and no new per-language branch;
- [x] package lifecycle checks, isolated skill-install parity, full QA, and
  `git diff --check` pass.

## Completion Notes

Registry version advanced `1.4.0` → `1.5.0`. Each official entry now carries
data-only `discovery` metadata (languages, overlays, workflows, exact
activation marker) matching the verified manifests: TypeScript claims
`typescript` with `base`/`svelte`/`sveltekit` overlays and
`explicit_audit_repair`; Rust claims `rust` with `everyday_authoring` and
`explicit_audit_repair`. Pinned identities, digests, and both overlap windows
are byte-unchanged.

`language-package-lifecycle.ts` gained the generic `selectRegistryEntry`
procedure and a `select` CLI: explicit intent (language + workflow +
optional overlay) or an exact activation marker selects one entry; zero,
duplicate, ambiguous, incompatible-core, and detection-only inputs fail
closed before acquisition, and duplicate markers fail at registry parse.
Resolve now stops on registry/manifest discovery drift before routing;
allowlist-only local routing is unchanged. No package name or language
branch exists in the generic surface (portable scan unchanged and passing).

The three package-specific router paragraphs in `references/router.md` and
the route doc now delegate identity selection to the registry-owned
procedure (`packages/installed-package-route.md` § Generic selection);
embedded mode content remains reachable only through the bounded fallback.
Negative fixtures cover duplicate markers and duplicate language/workflow
claims; the checker pins discovery values, exactly-selectable shipped data,
and sixteen selection CLI cases (positives plus fail-closed negatives);
oracle-16/17/18 falsify the card's seven review rows inside the lifecycle
oracle. Evidence: `docs/logs/2026-09/03-123500-bind-generic-language-selection.md`.

## Review Oracle

| Invariant | Smallest counterexample | Expected stop or proof |
| --- | --- | --- |
| Selection is data-driven. | Selection code names Rust or TypeScript package IDs. | Portable scan and dual-entry fixture fail. |
| Intent is explicit. | Cargo, Svelte, or source-file detection is the only input. | No package is selected or acquired. |
| One match means one identity. | Two registry entries claim the same language/workflow or marker. | Stop as ambiguous before host invocation. |
| Registry and package agree. | Verified manifest drops a declared workflow or overlay. | Route stops on metadata drift. |
| Existing activation survives. | Current consumer marker is present but no explicit request names a package. | Exact registered entry is selected without rewriting the block. |
| Unsupported work stays unavailable. | TypeScript everyday authoring is requested. | Stop without substituting Rust or audit mode. |
| Trust stays separate. | Discovery metadata is treated as third-party approval. | Trust gate refuses acquisition. |

## Evidence Required

- before/after registry schema and two-entry fixtures;
- explicit-intent, existing-activation, ambiguity, metadata-drift, detection,
  unsupported-workflow, and trust counterexamples;
- scan showing one package-neutral selection implementation;
- installed local-route and acquisition regression evidence;
- package lifecycle checks, isolated skill-install parity, full QA,
  `git diff --check`, reviewable PR, and exact head.

## Continuation Envelope

- Auto-start next card: no.
- In-bounds next card: 120 after merge and readiness refresh.
- Remaining ready chain after this card: 0.
- Transition proof: reviewed generic selection plus the frozen removal inventory.

## Stop Conditions

- selection needs a package-specific code branch or name inference;
- preserving existing activation requires rewriting consumer files;
- registry metadata cannot be checked against the installed manifest;
- the change alters package policy, workflow availability, or trust authority;
- validation changes the promoted package protocol.

## Next Task

Dispatch one implementation worker. Stop after a review-only PR; do not start
card 120 from that worker.
