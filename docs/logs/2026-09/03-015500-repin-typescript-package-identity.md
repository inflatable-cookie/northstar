# Repin TypeScript Package Identity

Date: 2026-09-03
Roadmap: `g02.048`
Card: `g02.048/121`
Status: implemented; awaiting exact-head review

## Outcome

Card 121's Northstar half is implemented on
`worker/repin-typescript-skill-entrypoint`. The official registry now pins the
accepted standalone-adapter identity. Card 119 is unchanged except for
blocked-dependency wording and stays not ready.

## Registry pin

Registry version advanced from `1.2.0` to `1.3.0`. The canary entry is still
`@northstar/typescript-quality` `0.1.0` at
`inflatable-cookie/northstar-language-packs` subpath `packages/typescript`,
core range `>=0.2.0 <1.0.0`:

- commit `c9ef2a2e3b70dc68de670767048f26b01b08f929`
- tree `sha256:259cccdbacd7e2e293389efaf72cab005d0c275bd7cb600c99f30bfbfe071843`
- manifest `sha256:e5e32f2baeda2e901b8c327436adf0bfd5955a9de080887660684ad4583185ca`

The superseded `d18dc33b` tree is no longer named or routable. Checker
exact-pin assertions and oracle-14's receipt provenance follow the new
registry version.

## Independent identity proof

The accepted commit was materialized with `git archive` from the read-only
package-source sibling. An independent Python implementation of spec-034
framing reproduced:

- the previous pin on `d18dc33b` (`sha256:76767132...334a`, 21 files)
- the replacement pin on `c9ef2a2` (`sha256:259cccdb...1843`, 21 files)
- the unchanged manifest digest on both trees

The two executable files remain `scripts/self-check.sh` and
`scripts/prove-installed-invocation.sh`.

## Lifecycle and installed-adapter proof

Through the public `language-package-host.v1` surface:

- official git-source acquire stops visibly, names
  `@northstar/typescript-quality@0.1.0`, and names the manual/local-path route;
- detection does not acquire;
- the official pin outranks a local-path allowlist for the exact identity;
- operator local-path trust for the replacement identity activates, including
  the real package self-check;
- offline resolve through the official registry selects only
  `sha256:259cccdb...1843`;
- drifted installed bytes stop; exact restore reopens the route;
- staging the superseded `d18dc33b` tree against the replacement digest fails
  closed before acceptance (`staged tree identity does not match pin`).

The installed payload stays free of `.effigy` pollution. Installed
`SKILL.md`, manifest entrypoint
`references/modes/typescript-quality-audit.md`, and
`$northstar-typescript-audit` agree exactly and stay package-local.

Package QA on that `installed_path` reports the closed adapter grammar (7
grammar, 1 existence, 1 exact-command negatives). The package's
`prove-installed-invocation.sh` then proves public setup/record, relay
sentinels, decoy-catalogue isolation, missing/escaping adapter authority, and
a suffixed command identity. Lifecycle consumer `package.json` and `src.ts`
hashes were unchanged; the only extra consumer files were Effigy task reports
from the explicit `--repo` package-QA invocation, not from acquire/resolve.

`northstar-language-packs` was not modified.

## Validation

- `effigy check:language-packages`
- `effigy check:skill-install skills/northstar` (194 files)
- `effigy qa:docs`
- `effigy qa`
- `git diff --check`

All passed.

## Limits

Card 119 is not refreshed and not started. Merge belongs to the orchestrator
after exact-head review.
