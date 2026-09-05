# Readiness-map fixture-local authority

Status: open; non-blocking
Owner: Northstar Chatterbox
Source: `g03.001/132` final lifecycle-retirement correction and PR 40

## Issue

`scripts/lib/northstar-readiness-map.rhai` currently recognizes canonical
`master_spec` targets only under selected `docs/` authority folders. Readiness
fixtures under `scripts/fixtures/readiness-map/` therefore cannot point to a
fixture-local spec without triggering `noncanonical_reference_error`.

## What is known

- Card 132 re-anchored the five fixtures to durable contract 001.
- Valid, missing-reference, cycle, orphan, and operator-blocked fixture behavior
  remains intact.
- Repo-contract, readiness, docs QA, and full QA passed on the accepted PR 40
  head.
- The limitation does not weaken production-project canonical authority and did
  not block `g03.001` closeout.

## Open question

Should readiness-map validation support an explicit fixture-only authority root
or injected test authority, so fixtures can remain self-contained without
teaching production repositories that arbitrary non-`docs/` specs are
canonical?

Do not widen `canonical_prefix` for normal projects merely to simplify tests.
Revisit this when readiness-map validation or fixture infrastructure next
changes. Until then, durable contract 001 is the accepted fixture authority.
