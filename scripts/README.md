# Scripts

Place repo-owned helper logic here when Effigy does not already cover the job.

Use Effigy from the repo root for the default maintenance loop:

```bash
effigy tasks
effigy doctor
effigy qa
```

## Runtime Policy

- prefer `effigy` when it already covers the operation
- when repo-owned script logic is still needed, use Effigy-native `Rhai`
- use TypeScript run with `bun` only for a concrete technical reason
- use `bash` only for thin glue or compatibility boundaries
- use `python` or another runtime only with a concrete technical reason

## Working Rule

Scripts remain implementation detail until the helper flow is stable enough to
expose as a first-class Effigy task.

## Installed skill parity

Install the package so the `northstar` front door becomes an activatable skill
entry:

```bash
npx skills add https://github.com/inflatable-cookie/northstar/tree/main/skills/northstar \
  --full-depth --skill '*' --agent codex -g -y
npx skills list -g --json
```

Replace `codex` with the current harness's Skills CLI agent ID, or pass several
IDs after `--agent`. `--all` is intentionally absent because it targets every
supported harness.

An install is complete when `skills list` includes `northstar`. The front door
is the single distributable skill entry.
```bash
npx skills add https://github.com/inflatable-cookie/northstar/tree/main/skills/northstar \
  --full-depth --skill '*' --agent codex -g -y
npx skills list -g --json
effigy check:skill-install /path/to/installed/northstar
```

The Skills CLI follows the configured published source. It cannot see
uncommitted or unpushed changes in this checkout. During local skill
development, a direct sync is appropriate; keep it out of the published
operator path:

```bash
rsync -a --delete skills/northstar/ /path/to/installed/northstar/
```

Restart agent sessions after updating an installed skill so they reload the
new instructions.

Install parity ignores only skill-local runtime state: `.effigy/` receipts.

The published skill also carries a minimal Effigy catalog for the consumer-safe
agent-instruction audit. When the target repository has no local task, select the
installed skill directory explicitly:

```bash
effigy --repo /path/to/installed/northstar northstar/check:agent-instructions /path/to/project
```

This catalog is intentionally narrower than the Northstar source repository's
full QA catalog. It exists so the audit helper resolves from the installed skill
rather than incorrectly depending on the Northstar source checkout.

Language quality activation is not a skill-local setup task. Language
catalogues, modes, engines, and templates live in installed packages, and the
generic route in the installed skill (`references/packages/installed-package-route.md`)
selects and runs them from explicit workflow intent or an existing consumer
activation marker. With no compatible package installed, only the requested
language workflow stops; it names the exact identity and the local
installation route.

The installed skill exposes the real operator adapter:

```bash
effigy --repo /path/to/installed/northstar northstar/language:route \
  --consumer /path/to/consumer \
  --language typescript \
  --workflow explicit_audit_repair \
  --overlay svelte
```

It returns the verified package `entrypoint_path`. The default store is
`$XDG_DATA_HOME/northstar/language-packages` when XDG data is configured, or
the operator's `.local/share/northstar/language-packages` directory otherwise.
`NORTHSTAR_LANGUAGE_PACKAGE_STATE_ROOT` and `--state-root` provide explicit
overrides. First use fetches and verifies the registry-pinned Git commit;
subsequent routes are local-only.

## Repo contract (`qa:docs`)

`check:repo-contract-wiring` validates the small machine-facing contract around
the docs QA route: the Claude `@AGENTS.md` bridge, repo-contract task
declarations, the complete `qa:docs` and outer `validate` sequences, and the
Paseo/Effigy hook identifiers. `check:repo-contract` validates the retained
Northstar structure: stable entry points, current active-authority surfaces,
executable validation surfaces, and declared source/mirror parity. Every local
Markdown link under `skills/northstar/` must resolve inside that folder; escaping
or missing targets fail QA. Editorial wording and individual historical
artifacts are not repo-contract schema.

The root `validate` board retains the wiring task, and `qa` runs `validate`
before `qa:docs`. `qa:docs` alone cannot protect its own task list; the full
`qa` board rejects removal of the repo-contract tasks from `qa:docs` through the
independent outer path. The focused negative fixture executes both selectors on
a temporary Effigy board: it observes the mutated `qa:docs` bypass and then
requires the outer `qa` board to fail.

The machine checks cover configuration and bridge identifiers only. They do not
restore generic prose assertions. Run `effigy check:repo-contract-wiring` or
`effigy check:repo-contract` directly, and run
`effigy test:repo-contract` through either `effigy qa:docs` or directly to
exercise isolated structural failures, execution-contract failures, and benign
changes.

## Explicit command surface (`check:command-skills`)

Run `effigy check:command-skills` directly or through `effigy qa:docs`.

The command-surface checker validates the seven thin adapters under
`skills/northstar/commands/`: their names, description budgets, router and mode
references and ordering, one-mode wiring, aggregate prompt footprint,
retired-alias removal, thin-body/procedure guards, authority boundaries, and
exact adapter count. It also asserts the eight fresh-orchestrator continuation
oracle rows against the installable router, handoff contract, orchestrator
mode, generic template, and skill outcome. The set includes
`/northstar-cleanup` for safe inspection and reworking of `/docs` drift.
Language quality commands are not adapters: explicit audit-and-repair and
everyday authoring route through installed language packages via the generic
installed-package route. It is included in `effigy qa:docs`.

## Readiness-map frontier (`check:readiness-map`)

The readiness-map checker is read-only and fail-closed. It scans live readiness
maps under `docs/specs/` by default, or one positional destination/fixture root.
It reports missing references, orphan records, dependency cycles, invalid states,
and a deterministic open frontier without resolving operator-owned decisions.

```bash
effigy check:readiness-map
effigy check:readiness-map scripts/fixtures/readiness-map/valid
effigy test:readiness-map
effigy qa:docs
```

The fixture test covers valid, missing-reference, cycle, orphan, and
operator-blocked cases without network, database, provider, or external tracker
access. A repository with no live readiness maps passes with deterministic
zero-map output.

## Consumer compaction replay (`check:consumer-compaction`)

Inspect recorded installed-skill compaction replays. The task does not re-run
the agent. It asserts preservation, link, and stop properties on the actual
before/after trees plus retained provenance.

```bash
effigy check:consumer-compaction
```

Recorded scenarios live under `scripts/tests/consumer-compaction/evidence/`.
Input fixtures live under `scripts/fixtures/consumer-compaction/`. A missing
replay or a handcrafted after-tree that does not match retained provenance
fails. Included in `effigy validate` / `effigy qa`.

## Language package machine contracts (`check:language-packages`)

Validate the generic machine contracts and review-oracle invariants for
modular language quality packages:

```bash
effigy check:language-packages
effigy qa:docs
```

The checker validates:
1. `package-manifest.schema.json`, `official-registry.schema.json`, and
   `installation-receipt.schema.json` structure (JSON Schema Draft 2020-12 dialect);
2. bounded schema-instance evaluation for package manifests, official registry, and
   installation receipts across all trust variants (`official`, `operator_allowlist`,
   `interactive_approval`) and source variants (`git`, `local_path`, `archive`),
   recursively failing closed on any unsupported schema keywords;
3. schema mutation discrimination proofs verifying that modifying supported constraints
   (e.g., `schema_version.const` or `package_id.pattern`) rejects instances and
   introducing unsupported keywords (e.g., `maxLength`) fails closed;
4. exact semantic-version parsing and numeric range compatibility evaluation
   (disallowing lexicographical comparison bugs, supporting exact, caret, bounded,
   and open ranges);
5. package-relative path containment (strictly rejecting parent traversal, escaping,
   empty segments, and absolute paths in entrypoints, subpaths, and self-checks);
6. initial core-owned `official-registry.json` document;
7. deep recursive policy-free fixture verification across all files and directories
   (asserting zero production language rules, profiles, overlays, engines, or catalogues);
8. independent package addressing and staging materialization boundary from multi-package
   repository sources (asserting isolated package payloads and broad-selection capture);
9. mandatory negative review-oracle invariant suite (digest drift, self-authorizing rejection,
   immutable hex commit sources, independent staging isolation, exact core ranges,
   path traversal rejection, malformed manifests, duplicate registry packages, and
   ambiguous receipts);
10. portable contracts (scanning for forbidden LLM provider dependencies).

Card 117 extends the same checker with the generic installed-package runtime:
11. canonical byte-exact `sha256:` digest vectors: manifest identity over exact
    file bytes and the package-tree identity over the sorted length-framed
    regular-file stream, with the executable bit taken from the permission
    bits and fixed external vectors for NUL, non-UTF-8, and multibyte content
    and for `0600`/`0444`/`0755` modes, expected digests from an independent
    reference;
12. `operator-trust.schema.json` (exact allowlist entries and revocations) and
    `lifecycle-state.schema.json` (revisioned state with immutable receipt
    references and at most one selected receipt per package), including
    duplicate/stale-selection rejection and fail-closed vocabulary proofs;
13. identity-bound and receipt-bound discovery and routing by manifest fields
    with no language-specific core branch and no Effigy dependency: the
    resolver loads and digest-checks the immutable receipt and cross-checks
    receipt/reference/installed manifest before routing;
14. transactional acquisition and rollback with atomic compare-and-swap
    lifecycle replacement (lock-file serialization, stale-owner recovery,
    fail-closed ambiguous-write handling, unique staging identities), trust
    restrictions enforced before transport and route, truthful receipt
    provenance, immutable full-digest install store with exclusive
    verify-or-fail publishing, truthful pre-selection receipts, and byte-exact
    preservation of selection and consumer files on every failure;
15. the `language-package-host.v1` request/result machine contract
    (`language-package-host-v1.schema.json`) with operational
    resolve/acquire_activate/rollback entrypoints exercised from an installed
    skill: the reference adapter implements all three operations, and a
    resolve-bound stdlib-only python3 host stops the others as missing
    capability; capability-denied hosts and unsupported protocol versions
    return scoped `stopped`; the request consumer scope binds trust
    restrictions at the host boundary; result messages are discriminated by
    operation and status so incomplete or operation-incoherent results are
    rejected;
16. explicit `self_check.invocation` (`direct` executes the entrypoint with
    `[package_root]`; `command` executes a declared command with
    `[entrypoint, package_root]`; both use the package root as cwd, no shell
    interpolation, no order semantics) with both positive variants and
    undeclared-runner, unavailable-runner, and non-executable-permission
    negatives. The candidate executes on a byte-identical throwaway copy of
    the staged root, so a self-check that writes receipts into its package
    root cannot mutate the verified payload; the installed tree keeps the
    pinned identity for selection re-verification.
17. review-oracle falsifications: detection is not authority, canonical
    content identity, transactional activation, operator-owned compare-and-swap
    state, offline local routing, scoped failure, revocable trust, generic
    routing, host-protocol portability, and self-check invocation, plus
    restricted-workflow/consumer, provenance, overlapping-writer,
    interrupted-write, and identity/store negatives.
18. card 118 official registry pin and route: the shipped registry carries
    exactly the accepted `@northstar/typescript-quality` `0.1.0` canary
    identity (replacement commit `c9ef2a2` from the reviewed standalone-adapter
    repair) and official receipts record the actual authorizing registry
    version and entry digest. The oracle proves the official-pin route:
    visible acquisition stop on failure, detection never acquires, installed
    offline routing, drift stops instead of silently routing, rollback reopens
    the route without fetching, and the official pin outranks the operator
    allowlist. Every host request/result shares a caller-generated
    `request_id`, and mixed pairs fail closed; a stopped host result is the
    scoped workflow stop itself — core has no frozen-payload fallback decision
    behind it. The package's own reviewed `prove-installed-invocation.sh`
    (pinned in the package) supplies the non-vacuous installed setup/record
    proof through the public `effigy skill run --path <installed_path>`
    surface against a decoy consumer.
19. card 119 Rust registry pin: the shipped registry carries the accepted
    `@northstar/rust-quality` `0.1.0` identity (language-packs PR 4, commit
    `56b2e11`) beside the TypeScript canary, with exact-value assertions for
    both entries and no per-language branch anywhere in the checker.

The exact same surface is exercised with Effigy absent
(`bun run skills/northstar/scripts/language-package-lifecycle.ts oracle
<fixture-root> <out-dir>`) and from `effigy check:language-packages`, which
also schema-validates every receipt and every host request/result message the
surface writes.

## Language package routes oracle (`check:language-package-routes`)

The two accepted registry pins are replayed deterministically against the real
packages. `scripts/tests/language-package-routes/validate_language_package_routes.py`
resolves the read-only package-source sibling (override with
`NORTHSTAR_LANGUAGE_PACKS_ROOT`; default `../northstar-language-packs` beside
the repository root), materializes pinned merges `c9ef2a2` (TypeScript) and
`56b2e11` (Rust), reproduces all four spec-034 digests with an independent
framing implementation, and proves the reduced core end to end: with no
package installed, each language workflow stops visibly with the manual
installation route and never claims the other language; with both packages
installed into one shared state root, each activates and resolves through its
exact pinned identity at an independent address, receipts record truthful
provenance, installed payloads carry no foreign-language files, a drift stop
on one package leaves the other routable, and each package's reviewed
`prove-installed-invocation.sh` passes on its installed payload. The oracle
lives under `scripts/`, so the installed core skill never depends on the
package source sibling; wired into `qa` through `validate`. Runtime is roughly
half a minute (cargo builds inside the Rust package prover).

```bash
effigy check:language-package-routes
```

## Agent-instruction audit (`check:agent-instructions`)

The read-only agent-instruction checker measures root or supplied `AGENTS.md`
files and prints line, byte, approximate-token, section, link, and code-block
evidence. It also exposes transparent placement, procedure, freshness, and
budget leads. These are inputs to the Northstar review mode, which assesses
meaning, reader flow, tone, force, and decision usefulness. The checker does
not judge prose and never edits files.

```bash
effigy check:agent-instructions
effigy check:agent-instructions AGENTS.md
effigy check:agent-instructions skills/northstar/assets/templates/AGENTS.md
# from an installed Northstar skill, audit a consumer repository instead:
effigy --repo /path/to/installed/northstar northstar/check:agent-instructions /path/to/project
```

## Posture advisory (`check:posture-advisory`)

Non-blocking checks for common **declared vs actual** drift in Northstar-shaped
`docs/` trees (active generation paths, specs archive surface, empty batch-card
folders). Always exits `0`; warnings print as `[northstar:advisory] …`.

```bash
effigy check:posture-advisory
# or target another repo root with a positional path:
effigy check:posture-advisory /path/to/project
# from a different discovered catalog:
effigy northstar/check:posture-advisory /path/to/project
```

`--repo` is reserved by Effigy for selecting the catalog repository, so it is
not a pass-through option for this task.

Smoke examples (expect one advisory line each):

- point `docs/roadmaps/generation-index.md` at a generation folder that does not
  exist
- add `docs/specs/001-any.md` without `docs/specs/archive/README.md`

This task is **not** part of `effigy qa` / `effigy qa:docs` so baseline repos stay
quiet until operators opt in.
