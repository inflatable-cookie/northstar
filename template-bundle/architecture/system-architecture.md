# System Architecture

**Type: REQUIRED** -- Every Northstar project needs this file.

Status: draft
Owner: <owner>
Updated: YYYY-MM-DD
Vision refs: <docs/vision/001-...>

## Top-Level Stack

Describe core layers and responsibilities.

## Data and Authority Flow

Describe how data moves and where authoritative decisions are made.

For a project that ships a user interface, the consumer repository owns design
authority: product truth, components, tokens, platform conventions, and visual
language. Planning owns UI classification, the design brief, readiness, and the
rendered-evidence and review protocol described in `docs/contracts/001`. Do not
let tooling create a competing design authority or treat a deterministic check
as design approval.

## Invariants

List non-negotiable rules implementation must preserve.

## Performance and Reliability Constraints

Document key constraints and budgets.

## Interfaces With Roadmaps

List the roadmap tasks this architecture currently unlocks or constrains.
