# 121 - Repair TypeScript Package Skill Entrypoint

Status: ready
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

- [ ] the installed TypeScript `SKILL.md` references only files present inside
  its own package;
- [ ] direct `$northstar-typescript-audit` metadata points to that same
  package-local authority;
- [ ] a missing or escaping adapter path fails package QA;
- [ ] the package version and manifest semantics remain unchanged;
- [ ] source/install parity and existing setup/record proofs still pass;
- [ ] Northstar's official registry pins the reviewed replacement commit and
  exact digests;
- [ ] package QA, Northstar QA, skill-install parity, and `git diff --check`
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

## Next Task

Dispatch the package-source repair first. After its accepted merge, repin the
replacement identity in Northstar. Stop before card 119 readiness refresh.
