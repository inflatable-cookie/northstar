# Queue generic hook planning relay

Created: 2026-09-12 18:39 Europe/London
From: Northstar Chatterbox
To: Paseo Northstar Queue planning authority

## What This Thread Was Doing

Northstar completed its provider-neutral lifecycle core in `g03.005`. The next
Northstar adoption task is planned as `g03.006` and deliberately blocked until
Queue ships a document-system-agnostic repository hook contract.

## Why It Matters

Queue currently owns excellent live orchestration state, but its committed
instruction and closeout assumptions still know Northstar concepts. Northstar
must remain usable without Queue, and Queue should be able to drive any
repository-defined lifecycle without importing a document protocol.

## Current State

- Northstar spec 040 owns the settled cross-product boundary.
- The portable reducer, standalone adapter, records, evidence levels,
  deterministic renderer, CAS/locking, and offline oracle are shipped.
- `g03.006` is planned, not ready, and depends on this Queue-owned prerequisite.
- Queue repair `g01.006` is complete; root `docs/README.md` is accepted by the
  current closeout verifier. That narrow repair does not implement generic
  hooks.

## Boundaries

Queue owns its control-manifest, event/result, transaction, execution,
publication, and recovery contracts. Keep them generic. Do not import
Northstar, parse Northstar Markdown, know `gNN.NNN`, embed Northstar commands or
paths, change Northstar state vocabulary, or edit the Northstar repository.
Preserve current Queue scheduling, leases, profiles, callbacks, review, merge,
attention routing, notification budgets, live settings, and task identities.

## Important Context

Freeze and implement:

- optional `.paseo/queue.json` using Queue-owned
  `paseo.queue.control.v1`;
- a generic committed instruction artifact identified by path, commit, blob
  digest, and media type, with the Northstar submitter as one adapter;
- `paseo.queue.event.v1` on standard input and
  `paseo.queue.hook-result.v1` on standard output;
- read-only gate and integration-write modes, required/advisory delivery,
  fixed executable/argv, clean-base requirements, time/output limits, allowed
  changed paths, and bounded commit-subject policy;
- transactional event intent before execution, stable event IDs, idempotent
  retry, and reconciliation of uncertain hook commits or pushes;
- clean synchronized integration publication: pin manifest commit/blob, run a
  minimal environment without shell interpolation, validate declared and
  actual paths, stage only allowed paths, commit, push, and verify remote state.

Absence of the manifest must preserve current behavior. Keep the existing
Northstar-specific closeout route until Northstar later proves terminal receipt
parity, then remove it with its callers rather than retaining two permanent
routes.

## Suggested Next Move

Promote one Queue-owned strict spec and executable task for the generic control
manifest and hook runner. Include a non-Northstar fixture so repository
agnosticism is proven rather than asserted.

## Completion Protocol

This is a planning relay, not implementation authority. Reconcile it against
Queue's current architecture and contracts, resolve Queue-local schema and
migration decisions, then return the promoted Queue planning commit and task
reference to Northstar Chatterbox. Do not dispatch implementation from this
file alone.
