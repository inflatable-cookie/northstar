# Accepted closeout-convergence adapter revision

Date: 2026-09-21
Task: `g03.021` — Converge terminal closeout authority (Queue task
`75ad3bd6-5d74-44e0-a3e8-35b2a30d2fe6`, PR #60)

## Accepted revision

- Merge commit: `e95338a7ed9cc17d097bf77a9446ac14a4ab8b70` (PR #60, merged).
- Final reviewed head: `a822e18ebe78ac7974608d00`.
- Terminal lifecycle record: `846cd3b`.
- Review: five `changes_required` rounds and five revisions; the accepted head
  closes duplicate generated blocks, committed-block provenance, uncommitted
  task-file bytes, exact planning-byte drift, chain-scoped record hygiene, and
  the earlier false refusal of a lawful prior lifecycle write.

## Installed interface identity

Refreshed from the merge commit and proved with
`effigy check:skill-install` (OK, 137 files) against both installed roots:

- `/Users/tom/.agents/skills/northstar`
- `/Users/tom/.pi/agent/skills/northstar`

| Artifact | Digest |
| --- | --- |
| `scripts/lifecycle-queue-hook.ts` | `sha256:07b2de1347e7b14be21d61940447ec76e171877ee400fda346b6b4e1305f352a` |
| `scripts/lifecycle-core.ts` | `sha256:5847df231f374a9372f23c17799b9490d1d8cee6c0d12548524f956a1e67674f` |
| `references/lifecycle/README.md` | `sha256:125a87e8b117e7eefe21bbc593b00593cd84637cc59cfef3cbc72ef3ee2f3937` |
| `effigy.toml` | `sha256:afa3dc295b6d2608b85a83064024753da10eae59d5509851b92181148e0b7e01` |

Entry point and event contract are unchanged: `effigy` runs
`northstar/queue:hook` with the frozen trusted-runner argv
(`skill run northstar/queue:hook --stdio passthrough`), and the required
integration-write closeout event remains `task.closeout`.

## What Queue's lane then does

Queue `g01.019` records this commit and identity, adds its generic integration
fixture, and proves the trusted-runner path end to end. Northstar owes that lane
only this record: the accepted behavior is documented in the lifecycle
reference's closeout section, including the one-block rule and the prospective
currentness gate.
