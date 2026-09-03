# Add Chatterbox Intake Channel

Date: 2026-09-03
Roadmap: `g02.050`
Card: `g02.050/124`
Status: in review; revision 1 pending planning resolution on Paseo ping

## Result

Added chatterbox as an internal Northstar communication mode and thin
`/northstar-chatterbox` command adapter. Chatterbox provides independent,
conversational problem exploration and triage capture for the operator without
interrupting active orchestrator dispatch or execution.

Chatterboxes share the orchestrator's checkout without worktrees, branches, or
PRs. They write only unique `docs/triage/YYYYMMDD-HHMMSS-<slug>.md` notes.
Exact-path commit isolation (`git commit -- <exact-file>`) and pre-stage index
checks (`git diff --cached --name-only`) ensure that pre-existing staged or
dirty files are never committed and remain untouched. This isolation is proven
via a temporary-repository fixture with 15 passing assertions.

Automated idle-only Paseo pings are paused at planning: status inspection plus
`send_agent_prompt` is non-atomic and cannot guarantee that a running
orchestrator is never prompted. Chatterbox v1 uses durable file-on-disk intake
with chat reporting. The orchestrator inspects `docs/triage/` at normal triage
checkpoints and treats intake notifications as non-assignments. Chatterboxes
refuse implementation, promotion, review, merge, or worker dispatch.

Prose-coupled substring assertions were removed from `check:command-skills` in
favor of stable structural/wiring checks and executable fixtures.

## Changed Surfaces

| Surface | Before | After |
| --- | --- | --- |
| `skills/northstar/references/modes/chatterbox.md` | Non-existent | Canonical mode for warm operator intake, problem identification, exact-path git commit isolation, paused Paseo ping, and authority boundaries |
| `skills/northstar/commands/northstar-chatterbox/SKILL.md` | Non-existent | Thin explicit command adapter routing to chatterbox mode (680 bytes, 48-char description) |
| `skills/northstar/references/router.md` | 14 modes; no chatterbox | Section 15 routes `northstar chatterbox`, `/northstar-chatterbox`, and plain language to `chatterbox.md`; explicit orchestrator/worker/review precedence preserved |
| `skills/northstar/SKILL.md` | 14-entry mode table, no chatterbox outcome | Added chatterbox to mode table and outcome summary |
| `skills/northstar/references/modes/orchestrator.md` | "research subagents or advisors"; no chatterbox spawn | "or advisors" dropped; `## Chatterbox spawn and intake` defines local workspace spawn, `Chatterbox=true`, `notifyOnFinish: false`, conversational routing, and non-assignment intake handling |
| `skills/northstar/assets/templates/northstar-discovery-delegate.md.template` | "spawn bounded read-only research subagents or advisors" | Dropped "or advisors" from research subagent guidance |
| `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md` | "research subagents or advisors"; no chatterbox in role table | Roles table adds Chatterbox; research subagents copy drops "or advisors"; spec 035 reference updated |
| `docs/contracts/001-working-rules.md` | Roles table and delegate/continuation rules | Adds chatterbox role, shared checkout exact-path git isolation, and intake handling |
| `template-bundle/contracts/001-working-rules-template.md` | No chatterbox section | Adds `### Chatterbox intake channel` matching canonical working rules |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | No chatterbox section | Adds `## Chatterbox intake channel` covering start, spawn, git isolation, paused ping, and authority |
| `bundle-docs/protocol-kernel.md` | No chatterbox entry | Canonical homes table lists Chatterbox intake channel |
| `docs/architecture/system-inventory.md` | No chatterbox thread or interface | Adds chatterbox thread to surfaces and Chatterbox intake to interfaces |
| `docs/architecture/system-architecture.md` | Topology lacked chatterbox | Thread topology includes chatterbox intake; architecture describes role and git/intake protocol |
| `docs/triage/README.md` & `template-bundle/triage/README.md` | General triage instructions | Adds chatterbox intake rule: shared checkout, unique files only, exact-path git isolation |
| `bundle-docs/operators/operator-quick-start.md` | No chatterbox routing | Adds chatterbox to mode choices and prompt examples |
| `bundle-docs/glossary.md` | No chatterbox definition | Defines Chatterbox under Agent and Thread Concepts |
| `scripts/lib/northstar-repo-contract-data.rhai` | 6 active authority files, 111 required skill files | Adds spec 035, `chatterbox.md`, `commands/northstar-chatterbox/SKILL.md`, and chatterbox git isolation test fixtures |
| `scripts/check-northstar-command-skills.rhai` | 7 adapters (380 chars) | 8 adapters (428 chars <= 460 budget); structural, description budget, and identifier checks; prose-mirror assertions removed |
| `scripts/tests/chatterbox-git-isolation/validate_chatterbox_git_isolation.py` | Non-existent | Executable test proving exact-path commit isolation against pre-existing staged and dirty working tree files, and fail-closed index protection |
| `scripts/tests/chatterbox-git-isolation/self-test.sh` | Non-existent | Test harness entry point wired into `effigy check:chatterbox-git` |
| `effigy.toml` | Task list without chatterbox test | Declares `check:chatterbox-git` |

## Review Remediation (Revision 1)

1. **Shared-Index Commit Isolation (`execution-miss`):**
   - Added pre-staging check `git diff --cached --name-only` to fail closed if pre-existing staged files are present.
   - Stage exact path: `git add -- <exact-new-file>`.
   - Commit exact path: `git commit -m "docs(triage): ..." -- <exact-new-file>`.
   - Added temporary-repository test `scripts/tests/chatterbox-git-isolation/validate_chatterbox_git_isolation.py` proving that an unrelated dirty *and already-staged* file remains uncommitted in index, an untracked file remains untracked, an unstaged dirty modification remains unstaged, and the commit contains only the triage note.
2. **Paseo Ping Planning Pause (`planning-change`):**
   - Paused automated idle-only Paseo pings at planning pending an atomic non-interrupting queue API.
   - Explained non-atomic race between status inspection and prompt dispatch.
   - Chatterbox v1 uses durable file-on-disk intake with operator chat reporting.
   - Card 124 and milestone 050 marked in-review pending planning resolution.
3. **Prose-Coupled Oracle Removal (`oracle-gap`):**
   - Removed 67 lines of prose-substring assertions from `scripts/check-northstar-command-skills.rhai`.
   - Maintained stable structural, adapter, description budget, and identifier checks.
   - Executable behavior backed by git isolation fixture.

## Oracle Review Evidence

| Invariant | Scenario | Evidence / Handling |
| --- | --- | --- |
| 1. Chatterbox is not another role | Operator routes request through worker, planning-delegate, or `paseo-advisor` | Router section 15 and `chatterbox.md` reject execution authority and direct operator to correct thread. |
| 2. Capture cannot widen authority | Chatterbox asked to edit non-triage paths or open PR | `chatterbox.md` specifies failing closed before writing non-triage paths; refuses PR creation. |
| 3. Shared checkout stays unique-file-only | Unrelated files are modified or pre-staged in index | `validate_chatterbox_git_isolation.py` proves exact-path commit isolation and fail-closed index protection across 4 scenarios. |
| 4. No worktree is required | Spawn requested with worktree isolation | Orchestrator mode requires `local` workspace on same checkout; rejects `branch-off`. |
| 5. Long-running chatterboxes do not spam | Chatterbox agent spawned in Paseo | Orchestrator mode enforces `notifyOnFinish: false` and capitalized `Chatterbox=true` label. |
| 6. Pings do not interrupt live work | Automated ping attempted | Paused at planning: non-atomic race cannot guarantee non-interruption; deferred pending atomic queue. |
| 7. Intake is not a new assignment | Orchestrator receives intake notification or reads triage note | Orchestrator records path only; does not promote or change current task; inspects at triage checkpoint. |
| 8. Notes remain non-authority | Triage note captured | Triage note is intake buffer only; orchestrator promotes through normal planning spine. |

## Validation

- `effigy check:command-skills` — PASS (8 adapters, aggregate descriptions=428 chars)
- `effigy check:chatterbox-git` — PASS (15 assertions, 0 failures)
- `effigy check:repo-contract` — PASS
- `effigy check:repo-contract-wiring` — PASS
- `effigy check:skill-install skills/northstar` — PASS (113 files verified)
- `effigy qa:docs` — PASS
- `effigy qa` — PASS
- `git diff --check` — clean

## Next Task

Report revision 1 exact head for PR 31. Card 124 remains in-review pending
operator/orchestrator planning resolution on Paseo ping.
