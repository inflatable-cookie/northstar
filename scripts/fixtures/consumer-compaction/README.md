# Consumer compaction fixtures

Disposable Northstar consumers for card 133. Not live projects.

| Directory | Role |
| --- | --- |
| `happy-before/` | Two closed expanded generations, one active generation, stale front-door links, unique rule, deferred commitment, PR/commit evidence |
| `unresolved-before/` | Contested UNIQUE-ORPHAN-RULE with no safe destination |
| `active-conflict-before/` | Sequential `g01` marked both active and closed |

Replay after-trees and provenance live under
`scripts/tests/consumer-compaction/evidence/`.
