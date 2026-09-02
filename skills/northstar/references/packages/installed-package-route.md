# Installed Language Package Route

How an explicit language-package workflow request routes through an installed
package. The procedure is generic: it names no language and contains no
per-language branch. The requesting language mode supplies the package ID and
version from the official registry (`official-registry.json`).

Authority: contract 004 (discovery, acquisition, trust) and spec 034
(provider-neutral host protocol). The machine contract is
`language-package-host-v1.schema.json`; `scripts/language-package-lifecycle.ts`
is one reference host adapter, not a prerequisite.

## Route procedure

1. Read the official registry entry for the requested package ID and version.
   A registry entry binds the exact source repository and subpath, immutable
   commit, tree digest, manifest digest, and compatible core range.
2. Send `resolve` (intent `workflow_request`) through a conforming host
   adapter: package ID, version, language, workflow, core version, optional
   consumer scope, consumer directory, and the host-supplied operator state
   root. Resolution is local-only; it never touches the network.
3. On `routed`: use the package payload at `installed_path`. The result names
   the verified tree and manifest digests and the selected receipt.
4. On `stopped` because no compatible package is installed, and the operator
   explicitly requested this workflow (or a valid consumer activation exists):
   send `acquire_activate`. The host emits the visible notice naming package,
   version, source, target, and workflow, then continues without a
   confirmation pause. Acquisition verifies registry identity and runs the
   declared self-check before anything routes.
5. On `stopped` after a failed acquisition attempt: apply the frozen fallback
   rule below.

Detection alone never routes or acquires. A `resolve` or `acquire_activate`
request with detection intent stops without fetching, installing, or loading
package content.

## Route contract

- The package is the task source; the consumer repository stays the target.
  Package-owned tasks, scripts, and references resolve below `installed_path`,
  never from the consumer checkout or from core's embedded payload.
- Run only workflows the installed manifest declares. A workflow the manifest
  does not declare is unavailable; do not synthesize it.
- A stopped result scopes the failure to the requested language workflow.
  Planning, orchestration, review, and documentation workflows continue.
- Revocation outranks registry and allowlist trust. A revoked identity stops
  and names the revocation record.

## Frozen fallback rule (bounded overlap window)

During a language's extraction overlap window, core retains a frozen embedded
payload for that language. When resolve and acquisition both stop, the
requesting mode continues with that frozen embedded payload after emitting one
visible notice that names:

- the failed package identity (ID and version, plus the stop reason),
- that the frozen embedded fallback is in use.

Notice template:

```text
[northstar:language-packages] notice: <package-id>@<version> unavailable (<stop reason>); using the frozen embedded <language> payload during the bounded overlap window
```

A host `stopped` result is not this notice. The requesting mode obtains it by
running the core fallback decision on the stopped `acquire_activate`
request/result pair and the registered overlap windows
(`references/packages/overlap-windows.json`):

```text
language-package-lifecycle.ts fallback <request.json> <result.json> <overlap-windows.json> [notice.txt]
```

The decision binds request/result operations and package identity, then fails
closed when the result is not `stopped`, operations or identities disagree,
required identity is absent, the language has no frozen overlap payload, or
the embedded fallback window is closed. It does not change the host status
or claim the host executed embedded policy.

Never silently prefer, update, refresh, or hide fallback use. The embedded
payload receives no fixes or new rules during the window; a fallback defect
pauses the cutover rather than bending the package. After the overlap closes,
the embedded payload and this fallback rule are removed together.
