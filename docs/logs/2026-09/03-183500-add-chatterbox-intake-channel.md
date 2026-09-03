# Add Chatterbox Intake Channel

Date: 2026-09-03
Roadmap: `g02.050`
Card: `g02.050/124`
Status: complete; reviewable PR pending

## Result

Added chatterbox as an internal Northstar communication mode and thin
`/northstar-chatterbox` command adapter. Chatterbox provides independent,
conversational problem exploration and triage capture for the operator without
interrupting active orchestrator dispatch or execution.

Chatterboxes share the orchestrator's checkout without worktrees, branches, or
PRs. They write only unique `docs/triage/YYYYMMDD-HHMMSS-<slug>.md` notes,
committed with exact-file `git add`. When Paseo is available, a chatterbox may
send an idle-only intake prompt to an idle `Orchestrator=true` agent; running
orchestrators are not interrupted. The orchestrator treats intake prompts as
non-assignment notifications and inspects notes at its next triage checkpoint.
Chatterboxes refuse implementation, promotion, review, merge, or worker
dispatch. All eight spec-035 review oracle rows are deterministically proven in
`check:command-skills`.

## Changed Surfaces

| Surface | Before | After |
| --- | --- | --- |
| `skills/northstar/references/modes/chatterbox.md` | Non-existent | Canonical mode for warm operator intake, problem identification, unique-file git protocol, idle-only Paseo ping, and authority boundaries |
| `skills/northstar/commands/northstar-chatterbox/SKILL.md` | Non-existent | Thin explicit command adapter routing to chatterbox mode (685 bytes, 48-char description) |
| `skills/northstar/references/router.md` | 14 modes; no chatterbox | Section 15 routes `northstar chatterbox`, `/northstar-chatterbox`, and plain language to `chatterbox.md`; explicit orchestrator/worker/review precedence preserved |
| `skills/northstar/SKILL.md` | 14-entry mode table, no chatterbox outcome | Added chatterbox to mode table and outcome summary |
| `skills/northstar/references/modes/orchestrator.md` | "research subagents or advisors"; no chatterbox spawn | "or advisors" dropped; `## Chatterbox spawn and intake` defines local workspace spawn, `Chatterbox=true`, `notifyOnFinish: false`, conversational routing, and non-assignment intake handling |
| `skills/northstar/assets/templates/northstar-discovery-delegate.md.template` | "spawn bounded read-only research subagents or advisors" | Dropped "or advisors" from research subagent guidance |
| `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md` | "research subagents or advisors"; no chatterbox in role table | Roles table adds Chatterbox; research subagents copy drops "or advisors"; spec 035 reference updated |
| `docs/contracts/001-working-rules.md` | Roles table and delegate/continuation rules | Adds chatterbox role, shared checkout rules, exact-file git add, and idle-only ping handling |
| `template-bundle/contracts/001-working-rules-template.md` | No chatterbox section | Adds `### Chatterbox intake channel` matching canonical working rules |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | No chatterbox section | Adds `## Chatterbox intake channel` covering start, spawn, git protocol, idle ping, and authority |
| `bundle-docs/protocol-kernel.md` | No chatterbox entry | Canonical homes table lists Chatterbox intake channel |
| `docs/architecture/system-inventory.md` | No chatterbox thread or interface | Adds chatterbox thread to surfaces and Chatterbox intake to interfaces |
| `docs/architecture/system-architecture.md` | Topology lacked chatterbox | Thread topology includes chatterbox intake; architecture describes role and git/ping protocol |
| `docs/triage/README.md` & `template-bundle/triage/README.md` | General triage instructions | Adds chatterbox intake rule: shared checkout, unique files only, exact-file git add |
| `bundle-docs/operators/operator-quick-start.md` | No chatterbox routing | Adds chatterbox to mode choices and prompt examples |
| `bundle-docs/glossary.md` | No chatterbox definition | Defines Chatterbox under Agent and Thread Concepts |
| `scripts/lib/northstar-repo-contract-data.rhai` | 6 active authority files, 111 required skill files | Adds spec 035, `chatterbox.md`, and `commands/northstar-chatterbox/SKILL.md` |
| `scripts/check-northstar-command-skills.rhai` | 7 adapters (380 chars), no chatterbox assertions | 8 adapters (428 chars <= 460 budget); deterministically asserts all 8 spec-035 review oracle rows |

## Eight Oracle Rows Proven

| Invariant | Counterexample / Scenario | Result | Proof |
| --- | --- | --- | --- |
| 1. Chatterbox is not another role | Thread routes through orchestrator, worker, planning-delegate, handoff, or `paseo-advisor` | Router and mode refuse and stay in chatterbox or ask operator to start right thread | `check:command-skills` verifies router section 15 and `chatterbox.md` distinct role assertions |
| 2. Capture cannot widen authority | Chatterbox edits a spec, card, or code, or opens a PR | Stops before writing non-triage paths; refuses implementation/promotion/dispatch/review/merge | `check:command-skills` verifies `chatterbox.md` non-triage write refusal and authority boundary |
| 3. Shared checkout stays unique-file-only | Chatterbox runs `git add .` or commits an unrelated dirty file | Commits only with `git add -- <exact-new-file>`; leaves unrelated dirty files unstaged; fail-safe push | `check:command-skills` verifies git protocol assertions in `chatterbox.md` |
| 4. No worktree is required | Spawn uses `branch-off` isolation | Rejects transport plan; uses local workspace on same checkout | `check:command-skills` verifies orchestrator mode transport rejection assertion |
| 5. Long-running chatterboxes do not spam | Spawn enables `notifyOnFinish` | Rejects launch configuration; enforces `notifyOnFinish: false` and `Chatterbox=true` | `check:command-skills` verifies notification and label assertions in `orchestrator.md` |
| 6. Pings do not interrupt live work | Chatterbox `send_agent_prompt`s a running `Orchestrator=true` agent | Skips the ping and tells operator note is ready on disk; pings only when idle | `check:command-skills` verifies idle-only ping assertions in `chatterbox.md` |
| 7. Intake is not a new assignment | Orchestrator starts promotion or dispatch from the ping | Records path only; does not change current work; reads note at next triage checkpoint | `check:command-skills` verifies orchestrator intake prompt handling assertions |
| 8. Notes remain non-authority | Chatterbox triage file treated as ready card | Triage note remains intake buffer; orchestrator promotes through normal spine | `check:command-skills` verifies triage buffer and non-authority assertions |

## Validation

- `effigy check:command-skills` — PASS (8 adapters, aggregate descriptions=428 chars)
- `effigy check:repo-contract` — PASS
- `effigy check:skill-install skills/northstar` — PASS (113 files verified)
- `effigy qa:docs` — PASS (repo-contract machine contracts, repo-contract checks & 11 fixture tests, readiness-map checks & 5 fixture tests, command-skills, model-routing, language-packages machine contracts)
- `effigy qa` — PASS (full validation suite + docs QA)
- `git diff --check` — clean (no whitespace or format errors)

## Next Task

Push branch `worker/add-chatterbox-intake-channel`, create reviewable PR, and
report for orchestrator exact-head review.
