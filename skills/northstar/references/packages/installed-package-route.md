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
5. On `stopped` after a failed acquisition attempt: stop only the requested
   language workflow. Report the exact package identity, the stop reason, and
   the local installation route. Core planning, orchestration, review, and
   documentation workflows continue normally. There is no embedded fallback
   and no substitute package.

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

