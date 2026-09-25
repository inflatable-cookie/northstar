# Specs

Specs hold material planning until durable meaning is promoted into
architecture, contracts, and executable roadmaps.

## Active planning

- [`041-project-knowledge-currentness.md`](./041-project-knowledge-currentness.md)
  — discovery only; no execution authority. It explains why consumer knowledge
  goes stale and which mechanisms would catch it.

The portable task lifecycle spec (040) is implementation-complete and has been
removed after promotion. Retirement inventory:

- Exact schemas, reducer, envelope/digest framing, standalone write protocol,
  projection grammar, hook adapter behavior, and the proof matrix →
  [`skills/northstar/references/lifecycle/README.md`](../../skills/northstar/references/lifecycle/README.md)
  and the lifecycle self-tests (`check:lifecycle-core`,
  `check:lifecycle-adoption`).
- State model, authority boundaries, durable checkpoints, and the currentness
  rules → `docs/contracts/001-working-rules.md` and
  `bundle-docs/sections/12-portable-task-lifecycle.md`.
- System shape and the hook-owned closeout publication →
  `docs/architecture/system-architecture.md`.
- Non-goals (no runtime history in Git, no repository-wide ledger, no
  automated semantic priority, no second permanent closeout route) → the
  section 12 boundary and contract 001 mechanical-lifecycle rules.
- Queue-side closeout-prompt retirement note → section 12.
- Historical delivery sequencing → Git history; complete and non-authoritative.

Lasting UI-design delivery rules live in
`docs/architecture/system-architecture.md`, `docs/contracts/001-working-rules.md`,
and `bundle-docs/sections/11-ui-design-delivery.md`.

## Lifecycle

- Use a spec only when a goal needs material discovery or crosses several
  execution tasks.
- Promote lasting system shape to architecture and lasting behavior to
  contracts before implementation depends on it.
- Remove a fully promoted spec after current links and unique meaning have been
  checked. Keep a non-procedural tombstone only for a real stable-reference
  requirement.
- Historical and superseded procedure is not authority. Git retains full
  provenance.

Pre-`g03` specs, specs 038–039, and spec 040 have been promoted into
architecture, contracts, bundle doctrine, skill references, and Git history.
Only active planning specs belong here when active work requires one.
