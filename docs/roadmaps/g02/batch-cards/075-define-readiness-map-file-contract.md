# 075 - Define Readiness Map File Contract

Status: complete
Owner: repo maintainers
Updated: 2026-08-16
Master spec refs: `docs/specs/027-northstar-native-pre-execution-discovery.md`
Governing refs: `docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`, `docs/specs/README.md`, `g02.026`
Depends on: `g02.025` closeout
Auto-start next card: no

## Ready-State Checks

- [x] Objective is bounded enough to finish without fresh operator-owned design
      choices; destination placement and representation are settled.
- [x] Governing refs point at current canonical surfaces.
- [x] Scope boundaries and stop conditions are explicit.
- [x] Acceptance, validation, and evidence requirements are explicit.
- [x] No unresolved planning gap governs the contract-definition scope.
- [x] No unresolved intent checkpoint governs the contract-definition scope.
- [x] Auto-start is disabled because the dependent checker card must follow the
      promoted contract.

## Objective

Promote the first exact file contract for Northstar readiness mapping and
canonical decision records so deterministic frontier validation can be built
without inventing a second planning database or shadow authority surface.

## Settled Inputs

- Readiness maps and their canonical decision records live in bounded destination
  subdirectories under `docs/specs/`.
- The representation is Markdown with YAML frontmatter and explicit repository
  links.
- The map is an index and summary surface; decision rationale lives once in the
  linked decision record.

## Scope

- define the canonical destination directory and file naming convention;
- define the readiness-map frontmatter and required index sections;
- define decision-record frontmatter, lifecycle states, authority, blocking, and
  resolution/accepted-uncertainty fields;
- define stable decision identifiers and relative-link rules;
- promote durable structural rules into `docs/architecture/` and durable policy
  rules into `docs/contracts/001-working-rules.md`;
- update spec 027 with the resolved placement/representation decisions and
  remaining open questions;
- do not implement the deterministic checker, router procedures, starter
  templates, architecture refocus, reframe, or production code.

## Canonical Contract To Promote

Use this layout for a destination named `<destination-slug>`:

```text
docs/specs/<destination-slug>/README.md
docs/specs/<destination-slug>/decisions/<decision-id>-<slug>.md
```

The map frontmatter must include:

- `kind: readiness-map`;
- stable `id` and human-readable `title`;
- `destination` and `owner`;
- `status: active`, `cleared`, or `paused`;
- links to the governing master spec and current roadmap lane.

Each decision record frontmatter must include:

- stable `id` and `kind: decision|research|prototype|task`;
- `mode: operator|research|prototype|task`;
- `status: open|in-progress|resolved|out-of-scope`;
- `title`, `owner`, and `authority`;
- `blocked_by`, using stable decision IDs;
- either resolution evidence or an explicit accepted-uncertainty note when
  `status: resolved`.

The map may summarise each record and identify the current frontier, but must
link to the canonical record rather than copy its rationale. Relative links must
remain inside the destination subdirectory or point to named canonical docs
surfaces such as the governing spec, architecture, contract, roadmap, or log.

## Steps

1. Read spec 027, the architecture/contract surfaces, the docs-spine guidance,
   and this card.
2. Write the exact layout, frontmatter fields, state vocabulary, ID rules, and
   link boundary into the canonical architecture/contract surfaces.
3. Update spec 027 with the resolved decisions and keep only genuinely open
   questions visible.
4. Add the dependent checker card as queued behind this contract card.
5. Run `git diff --check`, `effigy qa`, and `effigy qa:docs`.
6. Report the changed surfaces, promoted rules, remaining open questions, and
   validation evidence.

## Acceptance Criteria

- the destination-subdirectory layout is explicit and repository-relative;
- map and decision-record schemas are explicit enough for a deterministic
  checker to validate without guessing;
- the map/index versus canonical-rationale boundary is explicit;
- operator, research, prototype, and task authority modes remain distinct;
- architecture and contract surfaces carry the durable rules;
- spec 027 no longer presents the settled placement/format choices as open;
- no checker implementation or execution card is smuggled into this contract
  definition;
- `git diff --check`, `effigy qa`, and `effigy qa:docs` pass.

## Evidence Required

- exact changed-file list;
- architecture and contract excerpts or links;
- updated spec 027 decisions/open questions;
- dependent card reference;
- validation output;
- explicit statement of unresolved questions that remain outside Batch 26.1.

## Stop Conditions

- stop if the proposed schema needs a second planning database;
- stop if a field would silently grant the agent authority over an operator-owned
  decision;
- stop if the map would duplicate canonical decision rationale;
- stop if the layout or format requires another operator-owned choice;
- stop if promotion would contradict the existing docs spine or working rules.

## Resolution

Promoted the readiness-map and decision-record contract into:

- `docs/architecture/system-architecture.md` — destination layout, artifact
  roles, link boundary, stable IDs, and map/record relationship;
- `docs/contracts/001-working-rules.md` — required frontmatter, index sections,
  state vocabulary, dependency references, authority boundary, and plan-only
  gate;
- `docs/specs/027-northstar-native-pre-execution-discovery.md` — exact Batch
  26.1 contract and resolved placement/representation decisions.

The dependent `g02.026/076` checker was then ready to execute through the
worker/PR loop because the contract was reviewed and merged and its exact
command surface was defined. It has since been implemented, reviewed, and
merged. No checker, router, skill, template, or production-code surface changed
in this contract-definition card.

## Validation Evidence

- `git diff --check` — passed.
- `effigy qa` — Northstar bundle checks and repo contract checks passed.
- `effigy qa:docs` — Northstar repo contract checks passed.

## Continuation Envelope

- Auto-start next card: no
- In-bounds next card: none until this card is reviewed and merged
- Remaining ready chain after this card: 0
- Transition proof required before the checker card becomes ready: promoted
  contract and exact validation command

## Next Task

The dependent `g02.026/076` deterministic frontier-check card was subsequently
implemented, reviewed, and merged. Continue at the next `g02.026` planning
checkpoint for Batch 26.2; do not make a new implementation card ready until
its contracts and evidence requirements are explicit.
