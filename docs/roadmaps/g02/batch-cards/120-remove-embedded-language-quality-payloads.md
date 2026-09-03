# 120 - Remove Embedded Language Quality Payloads

Status: complete; merged through PR 30 as `aa9a005`
Owner: repo maintainers
Updated: 2026-09-03
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/roadmaps/g02/048-extract-modular-language-quality-packages.md`,
`docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`, cards 116-119 and 122
Auto-start next card: no

## Ready-State Checks

- [x] TypeScript and Rust packages pass every overlap-close proof;
- [x] exact embedded catalogues, modes, scripts, tools, adapters, templates,
  fixtures, router branches, parity entries, and fallback paths are inventoried;
- [x] generic intent and existing-activation discovery can select one exact
  registry entry without a language-specific core branch;
- [x] deletion and core-only behavior are governed by architecture and contract;
- [x] no new-language implementation is in scope;
- [x] review oracle covers hidden fallback and core-only operation.

## Objective

Delete the frozen embedded TypeScript and Rust implementations and migration
fallbacks together, leaving a generic core that routes verified installed
packages and remains useful with none installed.

## Lane Runway Context

- Higher-level lane owner: g02.048 Batch D and lane closeout.
- Next likely milestone: Sentrux optional evidence-provider cohort or another
  language only after operator planning.
- Next planning checkpoint: reassess spec 034 retention and the open Sentrux
  triage note after root reduction is proven.

## Scope

- remove embedded language catalogues, modes, scripts, engines, adapters,
  templates, fixtures, fallback branches, and root parity/checker assumptions;
- keep only generic package discovery, registry, trust, lifecycle, and routing
  surfaces in core;
- update installed-skill parity and command/router surfaces to load thin
  adapters from installed packages;
- prove core-only workflows, missing-package containment, installed TypeScript
  and Rust routing, and consumer compatibility;
- close roadmap, spec disposition, front doors, and evidence.

Do not add a new language, broaden Sentrux trust, rewrite valid consumer policy,
or retain compatibility aliases for deleted embedded implementations.

## Acceptance Criteria

- [x] root source and installed payload contain no TypeScript/Rust catalogue,
  engine, workflow mode, setup, fixture, template, thin adapter, or hidden
  fallback implementation;
- [x] generic router recognizes declared workflow intent and activation without
  carrying language policy;
- [x] core planning, docs, orchestration, review, and setup remain usable with
  no language packages installed;
- [x] a missing package stops only that language workflow with the local install
  route;
- [x] installed TypeScript and Rust packages still pass their production and
  real-consumer workflows;
- [x] existing consumer files and evidence remain valid;
- [x] source/install parity reflects the reduced core exactly;
- [x] full QA and negative root-payload inventory pass.

## Review Oracle

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| Embedded removal is complete. | One root mode, rule file, engine, template, adapter, or fallback remains. | Inventory check fails. | Negative path/content scan. |
| Core works alone. | Fresh install has no language packages. | Non-language workflows pass. | Isolated core-only install. |
| Failure remains scoped. | Rust workflow requested without Rust package. | Rust route stops; orchestration still runs. | Dual-route fixture. |
| Installed routes still work. | Both packages installed from shared source repo. | Each routes independently with exact receipt. | Two-package integration proof. |
| Consumer authority survives. | Existing repo activation and evidence predate removal. | No rewrite; workflows remain readable. | Before/after hashes and consumer run. |
| No compatibility theatre remains. | Deleted embedded path is invoked through alias or silent fallback. | Focused check rejects it. | Forbidden-route fixtures. |

## Evidence Required

- exact pre-delete embedded inventory and post-delete negative scan;
- isolated core-only install and non-language workflow board;
- missing-package containment and two-package installed integration;
- TypeScript and Rust production plus real-consumer reruns;
- consumer policy/evidence hashes and reduced source/install parity;
- full QA, `git diff --check`, closeout log, reviewable PR, exact head, and
  explicit spec/triage disposition.

## Continuation Envelope

- Auto-start next card: no.
- In-bounds next card: none; lane closes after review and merge.
- Remaining ready chain after this card: 0.
- Transition proof: accepted root reduction and all roadmap criteria closed.

## Lane Budget

- Current card ends budgeted run: yes.
- Further operator decision required after this card: yes, before Sentrux
  cohort or any new language package.
- Pause signal if run stops here: lane-complete.

## Stop Conditions

- either external package lacks an overlap-close proof;
- deletion breaks core-only workflows or consumer evidence compatibility;
- a hidden core language dependency cannot be removed without redesign;
- implementation proposes an alias, shim, or indefinite embedded fallback;
- validation changes the plan.

## Completion Notes

Cards 116-119 are accepted. Convergence PR 4 supplied the final Rust consumer
proof and merged as `dff19c9`. The exact removal inventory is frozen in
`docs/logs/2026-09/03-095021-refresh-embedded-removal-readiness.md`: 71
embedded package-source files, 17 bounded-fallback files, and 7 root-only Rust
production-harness files are deletion targets; 19 integration surfaces require
replacement or mutation.

The refresh exposed one stop condition: package selection still depended on
three language-specific router branches. Card 122 replaced that seam with
registry-owned language, overlay, workflow, and activation-marker discovery,
closed its three first-review defects, passed exact-head review at `183b55b`,
and merged through PR 28 as `ddaae0d`. The selector now returns the immutable
pin, rejects malformed or ambiguous intent before acquisition, and checks
registry/manifest agreement before package code or lifecycle mutation. All
ready-state checks now pass.

## Closeout

Implemented on `worker/remove-embedded-language-quality-payloads`. The 95-file
frozen inventory was reproduced exactly and deleted with the fallback; the 19
integration surfaces were rewired to the generic installed-package route; the
`rust-package-pin` oracle was replaced by `check:language-package-routes`, the
two-package/core-only proof. Full evidence, including the negative inventory
scan and the serialization caveat on the frozen hashes, is in
`docs/logs/2026-09/03-154324-remove-embedded-language-quality-payloads.md`.
Exact-head review accepted `4f54da0`; PR 30 squash-merged as `aa9a005`. The
installed skill was refreshed from the tracked merge tree and now contains the
111-file generic core.

## Next Task

Card 120's lane is closed. Card 124 is the next ready implementation lane under
`g02.050`; new-language and Sentrux work remain separate operator checkpoints.
