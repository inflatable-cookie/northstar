# 048 - Extract Modular Language Quality Packages

Status: active; Batch B.1 pin awaiting review; Batch C still blocked
Owner: repo maintainers
Created: 2026-09-01
Depends on: `g02.033`, promoted spec 034
Vision tags: `language-quality`, `distribution`, `modularity`, `general-purpose`
Governing refs: `docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`,
`docs/specs/034-modular-language-quality-packages.md`

## Problem

Rust quality and the remaining embedded language payloads remain inside the
root Northstar skill. TypeScript/Svelte now has an independently installable
package under the promoted machine protocol; the remaining Rust extraction and
root reduction are still sequenced behind it.

## Generation Runway

This milestone advances the g02 goal of keeping language-quality workflows
without making every language implementation part of the root payload. It
keeps the protocol generic, proves it with a policy-free fixture, extracts the
two existing implementations in dependency order, then removes the frozen
embedded copies. The planning checkpoint is after the fixture protocol proof:
TypeScript extraction must be refreshed against the exact shipped protocol
before it becomes ready.

## Goals

- [x] prove the generic package schema, registry, receipt, trust, lifecycle,
  discovery, and routing boundary with a policy-free fixture;
- [x] extract TypeScript/Svelte as the first independent official package;
- [x] make the TypeScript package's advertised agent-facing skill standalone
  and repin its replacement identity;
- [ ] extract Rust without weakening its everyday or explicit-audit evidence;
- [ ] remove both embedded implementations and their bounded migration
  fallbacks from the root payload;
- [ ] keep existing consumer activation, profiles, deviations, rule IDs, and
  evidence readable throughout the migration;
- [ ] leave Northstar core useful when no language package is installed.

## Execution Plan

- [x] **Batch A — fixture protocol:** card 116 freezes machine contracts and
  the policy-free fixture; card 117 implements and falsifies generic discovery,
  verification, installation, activation, rollback, offline, and routing.
- [x] **Batch B — TypeScript canary:** card 118 published, pinned, installed,
  and proved the TypeScript/Svelte explicit-audit package under one bounded
  overlap. Registry/routing merged in core PR 23 as `5951dfb` after the
  installed-invocation repair (`d18dc33b`, registry version `1.2.0`). The
  retained Jetstream PR 4 then passed exact-head review at
  `177b75c80e5310d84fdd227d0229b261d59d6271` and squash-merged as
  `dbf7561d3845bf344f9ae4fae3296d1601b074bf`. Its bounded fallback,
  installed-audit, byte-preservation, and hydrated-build evidence is accepted;
  four pre-existing editor failures and current-Poodle API drift remain
  recorded limits. Batch C stays behind a separate operator checkpoint.
- [x] **Batch B.1 — standalone adapter repair:** package-source PR 3 repaired
  the missing local router reference and merged as `c9ef2a2`; card 121 pins
  that accepted identity at registry version `1.3.0` and proves installed
  adapter path closure without changing policy.
- [ ] **Batch C — Rust extraction:** card 119 publishes, pins, installs, and
  proves Rust everyday authoring plus explicit audit and its Cargo engine.
- [ ] **Batch D — root reduction:** card 120 removes both frozen embedded
  payloads and fallback branches, then proves core-only operation and installed
  package routing.

## Acceptance Criteria

- [ ] all six cards satisfy their review oracles and exact-head gates;
- [ ] official packages use immutable registry identities and independently
  addressable installed payloads;
- [ ] package discovery and execution do not require Effigy;
- [ ] file detection never authorizes acquisition;
- [ ] third-party trust remains operator-owned and exact;
- [ ] failed install, update, rollback, or offline acquisition changes neither
  active package selection nor consumer files;
- [ ] installing one official language never installs or loads another;
- [ ] existing consumer policy and evidence remain valid across extraction;
- [ ] no new language starts before TypeScript and Rust leave the root payload;
- [ ] full Northstar QA and package-scoped source/install parity pass.

## Review Oracle

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Package identity is immutable and exact. | Registry names a moving tag or installed bytes differ from the receipt. | Reject before package code runs. | Cards 116-117 identity fixtures. |
| Core remains general-purpose. | No language package is installed. | Planning, docs, orchestration, and review still route normally. | Card 120 core-only proof. |
| Acquisition follows intent, not detection. | A repo contains Cargo or Svelte files without language-workflow intent or activation. | Do not fetch or install. | Card 117 negative route. |
| Package units stay independent. | Rust and TypeScript share one source repo. | Installing either retains only the named package payload. | Cards 118-119 install inventories. |
| Migration preserves consumer authority. | A consumer has valid profiles, deviations, and activation before extraction. | Reuse them byte-for-byte. | Consumer migration fixtures. |
| Fallback is bounded and visible. | External acquisition fails during overlap. | Name the failed identity and frozen fallback; never hide the route. | Cards 118-119 fallback proof. |
| Removal is real. | Root still carries a language catalogue, engine, or hidden fallback after card 120. | Fail root-payload inventory. | Negative source/install scan. |

## Stop Conditions

- the fixture needs language-specific core routing or an Effigy dependency;
- implementation needs a mutable official source identity or package-owned
  trust decision;
- extraction changes consumer policy, rule meaning, evidence format, or repair
  authority without a new operator decision;
- package parity cannot be proved independently of the root payload;
- TypeScript or Rust production evidence cannot be preserved;
- validation changes the promoted architecture or contract.

## Next Task

After card 121's replacement pin merges, refresh card 119 against that
identity and the frozen 54-file Rust inventory. Do not start Rust extraction
before that dependency clears.
