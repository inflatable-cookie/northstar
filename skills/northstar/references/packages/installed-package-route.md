# Installed Language Package Route

How an explicit language-package workflow request routes through an installed
package. The procedure is generic: it names no language and contains no
per-language branch. Selection and routing are registry-owned: the caller
supplies explicit intent or an existing activation marker, and the official
registry (`official-registry.json`) selects the exact package identity.

Authority: contract 004 (discovery, acquisition, trust) and spec 034
(provider-neutral host protocol). The machine contract is
`language-package-host-v1.schema.json`; `scripts/language-package-lifecycle.ts`
is one reference host adapter, not a prerequisite.

## Generic selection (before any route)

Package identity is selected from registry-owned discovery metadata —
supported languages, overlays, workflows, and the exact activation marker —
never from routing instructions and never from detection. Two query shapes
exist:

- **Explicit intent:** the operator requested one package workflow. Supply the
  language, the workflow (`everyday_authoring` or `explicit_audit_repair`),
  and any requested overlay.
- **Existing activation:** the consumer already carries a registered
  activation marker (for example a `northstar:...-quality` block in its
  instructions). Supply that exact marker string. Existing markers stay valid
  and are never rewritten; marker matching is exact, not prefix or substring.

Selection runs before any host request:

```text
language-package-lifecycle.ts select <official-registry.json> \
  (--language <l> --workflow <w> [--overlay <o>] | --marker <m>) \
  [--core-version <v>] [--json <out>]
```

Selection fails closed without acquiring anything when: no entry supports the
requested work (the workflow stays unavailable — no substitution from another
package or mode); more than one entry claims it (ambiguous); the only claimant
is outside the compatible core range; the marker is unknown or not exact; or
the input names a language without an explicit workflow (detection is not
selection authority). Duplicate activation markers make the registry itself
invalid and fail at registry parse, before any host invocation.

## Route procedure

1. Select the package identity generically (section above) and read that
   official registry entry. A registry entry binds the exact source repository
   and subpath, immutable commit, tree digest, manifest digest, compatible
   core range, and discovery metadata.
2. Send `resolve` (intent `workflow_request`) through a conforming host
   adapter: caller-generated `request_id`, package ID, version, language,
   workflow, core version, optional consumer scope, consumer directory, and the
   host-supplied operator state root. Resolution is local-only; it never
   touches the network. Every result echoes the same `request_id`; mixed pairs
   fail closed.
3. On `routed`: use the package payload at `installed_path`. The result names
   the verified tree and manifest digests and the selected receipt.
4. On `stopped` because no compatible package is installed, and the operator
   explicitly requested this workflow (or a valid consumer activation exists):
   send `acquire_activate`. The host emits the visible notice naming package,
   version, source, target, and workflow, then continues without a
   confirmation pause. Acquisition verifies registry identity and runs the
   declared self-check before anything routes.
5. On `routed` or `activated`, use every absolute path in `tools`. A package
   that declares a buildable tool is built by the lifecycle into the operator
   cache, so no agent runs an install command by hand. The installation
   receipt records the same paths.
6. On `stopped` after a failed acquisition attempt: stop only the requested
   language workflow. Report the exact package identity, the stop reason, and
   the local installation route. Core planning, orchestration, review, and
   documentation workflows continue normally. There is no embedded fallback
   and no substitute package.

## Declared tool builds

A package manifest may declare one `tool`: an `id`, a package-relative
`source_path`, and a `build` recipe of a bare `command`, fixed `argv`, and an
`output` path relative to `{root}`. The command must already appear in
`runtime_capabilities.required_commands`. `argv` may use exactly three
placeholders, each substituted with an absolute path the lifecycle owns:
`{source}` (a throwaway copy of the verified payload), `{target_dir}` (the
explicit build target), and `{root}` (the output prefix). Both `{target_dir}`
and `{root}` are required, so no recipe can default to writing inside the
installed package.

Acquisition runs the recipe with the cache root as the working directory and
publishes the result under the operator state root:

```text
<state-root>/tools/<package-id>@<version>-<recipe-digest>/
  tool-build.json   identity, recipe digest, binary path, binary digest
  source/           throwaway build copy
  target/           explicit target directory
  root/             declared output prefix
```

Nothing is written inside the installed tree; the installed package keeps its
pinned tree digest. The binary is addressed by absolute path and digest, and
an intact cache is reused, never rebuilt. A missing, non-executable, or
digest-drifted binary makes the pack unusable: explicit audit stops, and
everyday authoring degrades (below). A failed build stops acquisition before
the receipt and lifecycle selection are written.

## Everyday authoring opt-in and degradation

The user's repository owns one setting, `everyday_authoring: true`, in
`docs/knowledge/contracts/language-quality-activation.json`. Everyday
authoring is off by default: without that exact boolean the route returns
`unavailable`, attempts no acquisition, and ordinary work is unaffected.
`explicit_audit_repair` never reads the setting and stays available to every
repository.

For an opted-in repository, an unresolvable or unusable pack returns
`degraded` instead of failing: the result names the exact failure and points at
the repository's normal Validate checks. The host protocol adds `degraded` and
`unavailable` result statuses for this. Explicit audit keeps its closed
behaviour and returns `stopped` for the same failure.

## Installed-skill runtime adapter

The installed Northstar skill exposes the complete operator route. Run it from
the consumer repository through `effigy skill run`, which resolves the installed
skill's path; `effigy --repo <installed-skill> northstar/language:route` does
not, and fails to find the lifecycle script:

```text
effigy skill run northstar/language:route -- \
  --consumer <target-repository-or-owning-scope> \
  --language <language> \
  --workflow <workflow> \
  [--overlay <overlay>]
```

For an existing activation, replace `--language` with
`--marker <exact-registered-marker>` and still name the requested workflow. The
consumer path must be the scope whose `AGENTS.md` contains the exact marker
pair. The adapter returns JSON containing the verified `installed_path`, `entrypoint_path`,
and the absolute `tools` paths for a package that declares a buildable tool;
open the entrypoint and follow it as the selected package authority.

The adapter uses `NORTHSTAR_LANGUAGE_PACKAGE_STATE_ROOT` when set, then
`XDG_DATA_HOME/northstar/language-packages`, otherwise
`~/.local/share/northstar/language-packages`. `--state-root <path>` is an
explicit per-call override. It creates the state directory with private
permissions, fetches only the registry-pinned immutable commit, reconstructs
the named package subpath, verifies tree and manifest digests, runs the declared
self-check, writes an immutable receipt, and activates by atomic state update.
Later routes are local-only. A transport, identity, self-check, or state failure
stops only that workflow; for an opted-in everyday-authoring route it is
reported as `degraded` so ordinary work continues.

Detection alone never routes or acquires. A `resolve` or `acquire_activate`
request with detection intent stops without fetching, installing, or loading
package content.

## Route contract

- The package is the task source; the consumer repository stays the target.
  Package-owned tasks, scripts, and references resolve below `installed_path`,
  never from the consumer checkout.
- Run only workflows the installed manifest declares. A workflow the manifest
  does not declare is unavailable; do not synthesize it.
- Registry discovery metadata must agree with the verified installed manifest
  before routing. A manifest that dropped a declared language, overlay, or
  workflow is metadata drift; drift stops the route instead of trusting the
  pin, and exact agreement reopens it without refetching.
- A stopped result scopes the failure to the requested language workflow.
  Planning, orchestration, review, and documentation workflows continue.
- Revocation outranks registry and allowlist trust. A revoked identity stops
  and names the revocation record.
