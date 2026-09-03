---
title: Repin TypeScript package skill entrypoint worker handoff
status: awaiting-review
handoff_mode: worker
branch: worker/repin-typescript-skill-entrypoint
worktree_slug: repin-typescript-skill-entrypoint
base_branch: main
handoff_path: /Users/tom/Dev/projects/northstar/docs/handoffs/20260903-014833-repin-typescript-skill-entrypoint.md
---

# Repin TypeScript Package Skill Entrypoint

## Outcome

Complete the Northstar half of card `g02.048/121`: repin the accepted repaired
TypeScript package identity, prove the installed agent-facing adapter remains
package-local, and return a review-only PR. Stop before card 119 readiness.

## Accepted Source Evidence

- Package-source PR 3 passed exact-head review at
  `1b4b098543d7966554fea85468f0216228fe1d52` and squash-merged as
  `c9ef2a2e3b70dc68de670767048f26b01b08f929`.
- Package ID/version remain `@northstar/typescript-quality` `0.1.0`.
- Replacement package-tree digest:
  `sha256:259cccdbacd7e2e293389efaf72cab005d0c275bd7cb600c99f30bfbfe071843`.
- Manifest digest is unchanged:
  `sha256:e5e32f2baeda2e901b8c327436adf0bfd5955a9de080887660684ad4583185ca`.
- The source package's fresh-archive QA passed. Independent canonical framing
  reproduced both digests. Its closed adapter grammar rejects missing,
  escaping, external, spaced, and extra authority references; its closed agent
  policy rejects a suffixed command identity.

## Scope

- Update only the official TypeScript registry pin and exact checker/oracle
  expectations that bind the superseded commit or tree digest.
- Advance registry provenance truthfully; do not invent a compatibility shim
  or keep the old identity routable.
- Materialize the accepted package commit independently and reproduce the
  package-tree and manifest digests before trusting the pin.
- Exercise acquisition, installed routing, package QA, setup/record proof, and
  adapter path/command closure through the existing public package lifecycle.
- Prove a missing package-local adapter authority and suffixed command fail
  closed before the package is accepted or routed.
- Reconcile card 121, roadmap 048, current front doors, one dated closeout log,
  and this handoff. Preserve historical logs and prior handoffs.

## Boundaries

- Do not edit `northstar-language-packs`; use it read-only at accepted merge
  `c9ef2a2`.
- Do not change package policy, version, manifest meaning, lifecycle, fallback,
  host protocol, TypeScript audit rules, or consumer files.
- Do not start Rust extraction or edit cards 119-120 beyond accurate blocked
  dependency wording. Card 119 gets a separate post-merge readiness refresh.
- Worker does not merge.

## Review Oracle

1. The registry pins exactly merge `c9ef2a2`, tree `sha256:259cccdb...1843`,
   and unchanged manifest `sha256:e5e32f2b...5ca`.
2. Independent spec-034 framing reproduces both identities from that commit.
3. Acquisition and offline installed routing select only the replacement
   identity; the superseded tree is rejected.
4. The installed `SKILL.md`, declared mode, and agent command remain wholly
   package-local and agree exactly.
5. Missing/escaping adapter authority and suffixed command counterexamples
   fail closed through the installed package proof.
6. Existing setup/record operational proof and consumer-byte preservation
   remain green.
7. No lifecycle, fallback, host, policy, package version, or Rust surface
   changes.
8. Card 121 closes only after package QA, language-package checks, isolated
   skill-install parity, full Northstar QA, and diff check pass.

## Validation

- `effigy check:language-packages`
- `effigy check:skill-install skills/northstar`
- `effigy qa:docs`
- `effigy qa`
- `git diff --check`

## Completion Protocol

Northstar half of card `g02.048/121` is implemented on
`worker/repin-typescript-skill-entrypoint`. Registry version `1.3.0` pins
merge `c9ef2a2` with independently reproduced tree
`sha256:259cccdbacd7e2e293389efaf72cab005d0c275bd7cb600c99f30bfbfe071843`
and unchanged manifest
`sha256:e5e32f2baeda2e901b8c327436adf0bfd5955a9de080887660684ad4583185ca`.
The superseded tree is rejected before acceptance. Installed adapter, mode,
and command remain package-local. Commit, push, and open a review-only PR
against `main`. Stop for orchestrator exact-head review. Do not merge or
start card 119.
