# Repair Language-Package Fallback Notice

Date: 2026-09-02
Roadmap: `g02.048`
Card: `g02.048/118`
Status: core fallback notice repaired; Jetstream forced-fallback rerun serial

## What Was Built

Card 118's missing operational fallback notice is repaired on
`worker/repair-language-package-fallback-notice`. The worker ran from the
launcher-provided clean worktree against pushed `origin/main`, with the tracked
handoff verified before mutation. After exact-head review of PR 24 at
`7a240ca`, this same worker integrated `main` at `9a0e5fc` and repaired the
four classified findings.

- Core fallback decision: `decideFrozenFallback` on the generic lifecycle
  surface consumes a stopped `acquire_activate` request/result pair and
  registered overlap windows, then emits the exact notice naming
  `package-id@version`, the host stop reason, and the frozen embedded payload.
  The host status grammar is unchanged. A host `stopped` result is not the
  fallback notice.
- Request correlation: every host request carries a caller-generated
  `request_id`; every result from both reference hosts echoes it. Fallback
  rejects a mismatched pair before the notice.
- Registered overlap metadata: schema-validated
  `references/packages/overlap-windows.json` pins TypeScript
  `@northstar/typescript-quality` `0.1.0` as `open`. Detection intent and a
  request version outside that exact window fail closed.
- Host catch prose now includes `@version`. It still does not claim overlap
  fallback or embedded policy.
- CLI: `language-package-lifecycle.ts fallback <request> <result> <overlap>
  [notice]`.

## Pre-Fix Failure

Jetstream-shaped `acquire_activate` of `@northstar/typescript-quality` `0.1.0`
through the reference host and official registry returned:

```text
status: stopped
notice: workflow explicit_audit_repair for @northstar/typescript-quality stopped: host transport capability unavailable for source type none; manual or local-path installation route required
```

That result named the package and the manual/local-path route, omitted
`@0.1.0`, and contained no frozen-payload clause. The shipped surface had no
`fallback` command and no `decideFrozenFallback`. Treating that host stop as
fallback evidence was the card-118 oracle miss.

## Falsification

- `oracle-15 frozen-fallback-notice`: the committed Jetstream-shaped pair is
  still not fallback evidence; in-process decision and CLI both emit
  `@northstar/typescript-quality@0.1.0`, the host reason, and `using the frozen
  embedded TypeScript payload during the bounded overlap window`.
- Fail-closed mutations: missing version, wrong identity, mismatched
  `request_id`, detection intent, wrong version, non-stopped result, disagreeing
  operations, closed overlap window, language with no frozen payload.
- Overlap schema: live document validates through the frozen evaluator;
  extra-property and missing-version negatives fail closed.
- Checker independently drives the same CLI against those fixtures and pins
  the overlap window to the accepted TypeScript identity and version.
- `oracle-14` still proves the host acquisition stop, now with `@version` and
  an assertion that the host notice does not contain `frozen embedded`. Both
  hosts echo `request_id`.

## Validation

`effigy check:language-packages` passed, including oracle-15 and the
independent fallback CLI board (nine fail-closed mutations plus overlap-schema
negatives). Isolated skill-install parity passed (194 files). `effigy qa:docs`,
`effigy qa`, and `git diff --check` passed.

## Limits

Jetstream PR 4 stays paused on the existing branch. After this Northstar PR
merges, the retained consumer worker reruns forced fallback and hydrated
editor validation. Cards 119-120 stay closed. This lane does not merge.

## Next Task

Review and merge this Northstar PR, then resume the existing Jetstream PR 4
worker. Do not create a replacement Jetstream lane.
