# 069 - Run Consumer Papercuts Proof

Status: complete
Owner: repo maintainers
Updated: 2026-08-06
Master spec refs: `docs/specs/025-skill-distribution-and-consumer-papercut-proof.md`
Governing refs: `bundle-docs/papercuts.md`, `g02.024`
Auto-start next card: no

## Objective

Exercise the papercuts contract in a clean Northstar consumer repository and
leave any observation in that repository's own root queue.

## Scope

- use Longhorn as the clean consumer target
- run bounded orientation checks
- record only observed, solvable friction
- do not modify consumer implementation code or auto-promote the note

## Acceptance criteria

- the consumer already has a root `PAPERCUTS.md`
- an actual execution hurdle is recorded there
- the note names a plausible improvement surface
- unrelated consumer work remains untouched

## Evidence

- Longhorn `PAPERCUTS.md` records that `effigy doctor` expands `health` to full
  `qa`
- Longhorn remained otherwise clean before the queue-only change
- the broad doctor execution was interrupted before it became an unintended
  full-suite run

## Closeout

The queue contract works in a real consumer. The first consumer item remains an
observation for Longhorn maintenance; Northstar does not silently change the
consumer's Effigy configuration.
