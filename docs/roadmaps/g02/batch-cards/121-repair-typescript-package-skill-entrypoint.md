# 121 - Repair TypeScript Package Skill Entrypoint

Status: complete; merged as `69e4d5d`
Owner: repo maintainers
Updated: 2026-09-03
Master spec refs: `docs/specs/034-modular-language-quality-packages.md`
Governing refs: `docs/contracts/004-language-quality-pack.md`, card 118,
`docs/roadmaps/g02/batch-cards/119-extract-rust-language-package.md`
Auto-start next card: no

## Ready-State Checks

- [x] the accepted package and registry identities are known;
- [x] the missing package-relative reference reproduces from the merged source;
- [x] workflow policy, evidence, and consumer mutation are out of scope;
- [x] the source repository owns the package repair;
- [x] Northstar owns the replacement registry pin.

## Objective

Make the TypeScript package's advertised agent-facing skill independently
usable, then pin the reviewed replacement identity before Rust extraction.

## Scope

1. In `northstar-language-packs`, replace the `SKILL.md` dependency on the
   absent main-Northstar router with package-local routing to its declared
   explicit-audit entrypoint.
2. Add a deterministic installed-copy proof that every path loaded by the
   agent-facing adapter exists inside the package and no main Northstar skill
   is required.
3. Preserve package policy, version, manifest meaning, Effigy workflows,
   consumer files, and explicit-audit-only behavior.
4. Merge the reviewed source repair and record its immutable commit, tree
   digest, and manifest digest.
5. In Northstar, repin only that replacement identity and prove the installed
   adapter remains package-local before merge.

Do not start Rust extraction, reopen the Jetstream audit, add TypeScript
everyday authoring, or change the generic package protocol.

## Acceptance Criteria

- [x] the installed TypeScript `SKILL.md` references only files present inside
  its own package;
- [x] direct `$northstar-typescript-audit` metadata points to that same
  package-local authority;
- [x] a missing or escaping adapter path fails package QA;
- [x] the package version and manifest semantics remain unchanged;
- [x] source/install parity and existing setup/record proofs still pass;
- [x] Northstar's official registry pins the reviewed replacement commit and
  exact digests;
- [x] package QA, Northstar QA, skill-install parity, and `git diff --check`
  pass.

## Review Oracle

| Invariant | Counterexample | Expected stop | Required proof |
| --- | --- | --- | --- |
| The adapter is standalone. | `SKILL.md` loads a file absent from the package. | Package check fails before release evidence. | Materialized installed-copy path closure. |
| Authority stays single. | Adapter restates audit policy instead of loading the declared mode. | Review rejects duplication. | Adapter-to-manifest entrypoint comparison. |
| Workflow stays narrow. | Repair exposes everyday authoring. | Manifest/package check rejects it. | Existing workflow negative. |
| Identity is exact. | Core keeps the old tree digest after source repair. | Registry check fails before routing. | Independent digest reproduction. |
| Consumer proof is preserved. | Repair changes setup, recorder, rules, or consumer files. | Parity or existing operational proof fails. | Before/after inventory and package QA. |

## Stop Conditions

- repair needs a new workflow, package version, protocol, or consumer-policy
  decision;
- an agent-facing package cannot load its declared local mode without the root
  Northstar router;
- replacement pinning changes fallback or lifecycle semantics;
- validation changes the plan.

## Completion Notes

Northstar registry version `1.3.0` now pins package-source merge
`c9ef2a2e3b70dc68de670767048f26b01b08f929` with independently reproduced tree
digest
`sha256:259cccdbacd7e2e293389efaf72cab005d0c275bd7cb600c99f30bfbfe071843`
and unchanged manifest digest
`sha256:e5e32f2baeda2e901b8c327436adf0bfd5955a9de080887660684ad4583185ca`.
The superseded `d18dc33b` tree is no longer routable. Installed adapter,
mode, and `$northstar-typescript-audit` agree on the package-local
entrypoint. Card 119 stays blocked for a separate post-merge readiness
refresh.

## Next Task

Merged after exact-head review as `69e4d5d`. Card 119's separate readiness
refresh is complete and the Rust source lane is ready.
