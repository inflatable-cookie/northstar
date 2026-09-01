# 048 - Extract Modular Language Quality Packages

Status: active; card 116 ready
Owner: repo maintainers
Created: 2026-09-01
Depends on: `g02.033`, promoted spec 034
Vision tags: `language-quality`, `distribution`, `modularity`, `general-purpose`
Governing refs: `docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`,
`docs/specs/034-modular-language-quality-packages.md`

## Problem

Rust and TypeScript quality remain inside the root Northstar skill. The
promoted package contract now settles how optional packages are identified,
trusted, installed, routed, released, and removed from core, but no machine
protocol or independently installable package exists yet.

## Generation Runway

This milestone advances the g02 goal of keeping language-quality workflows
without making every language implementation part of the root payload. It
keeps the protocol generic, proves it with a policy-free fixture, extracts the
two existing implementations in dependency order, then removes the frozen
embedded copies. The planning checkpoint is after the fixture protocol proof:
TypeScript extraction must be refreshed against the exact shipped protocol
before it becomes ready.

## Goals

- [ ] prove the generic package schema, registry, receipt, trust, lifecycle,
  discovery, and routing boundary with a policy-free fixture;
- [ ] extract TypeScript/Svelte as the first independent official package;
- [ ] extract Rust without weakening its everyday or explicit-audit evidence;
- [ ] remove both embedded implementations and their bounded migration
  fallbacks from the root payload;
- [ ] keep existing consumer activation, profiles, deviations, rule IDs, and
  evidence readable throughout the migration;
- [ ] leave Northstar core useful when no language package is installed.

## Execution Plan

- [ ] **Batch A — fixture protocol:** card 116 freezes machine contracts and
  the policy-free fixture; card 117 implements and falsifies generic discovery,
  verification, installation, activation, rollback, offline, and routing.
- [ ] **Batch B — TypeScript canary:** card 118 publishes, pins, installs, and
  proves the TypeScript/Svelte explicit-audit package under one bounded overlap.
- [ ] **Batch C — Rust extraction:** card 119 publishes, pins, installs, and
  proves Rust everyday authoring plus explicit audit and its Cargo engine.
- [ ] **Batch D — root reduction:** card 120 removes both frozen embedded
  payloads and fallback branches, then proves core-only operation and installed
  package routing.

## Acceptance Criteria

- [ ] all five cards satisfy their review oracles and exact-head gates;
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

Execute ready card `g02.048/116`. Do not start card 117 until card 116 is
reviewed, merged, and its exact machine contracts are used to refresh card 117.
