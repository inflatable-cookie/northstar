# 002 - Example Analytics Export Refocus

**Type: EXAMPLE** -- Illustrates a blocked task and planning gap. Remove from your project after reading.

Status: blocked
Owner: Core Team
Created: YYYY-MM-DD
Governing refs: `003-analytics-export-contract.md`
Depends on: g01.001

## Outcome

The product gets a contract-backed downstream analytics export slice, but execution drifted ahead of planning and the seam now crosses an unresolved repo boundary. No export implementation runs while ownership is unresolved.

## Decisions

None yet; seam ownership is the open planning gap.

## Dispatch manifest

- **State:** blocked on planning; resumes when the seam contract exists
- **Completion:** repo ownership explicit, seam covered by an active contract, and this task either recompiled as `ready` or explicitly deferred
- **Owned mutable paths:** `docs/roadmaps/g01/002-<slug>.md`
- **Reserved closeout surfaces:** none
- **Worker:** none until unblocked
- **Excluded:** export implementation work while seam ownership is unresolved; worker or API-side guesswork about the downstream sink contract
- **Escalation:** repo maintainers for the ownership decision

## Work

1. Audit current export assumptions in architecture, contracts, and roadmap files.
2. Resolve whether `analytics-export` is first-party, vendor-owned, or out of scope.
3. Create the seam contract or defer the export work from active scope.
4. Recompile this task with the new contract refs, then execute the first implementation step only after status becomes `ready`.

## Acceptance and review oracle

| Invariant | Adversarial counterexample | Required proof |
| --- | --- | --- |
| Repo ownership for analytics export is explicit | Roadmap prose hides a missing cross-repo contract | `repo-authority-map.md` entry |
| The seam is covered by an active contract | Implementation starts on prose promises | `003-analytics-export-contract.md` exists |
| This task is either recompiled as `ready` or explicitly deferred | A half-alive blocked task lingers | Status field says `ready` or `deferred` |

## Stop conditions

- Remains stopped: `analytics-export` ownership unresolved; `003-analytics-export-contract.md` missing.

## Evidence

Log the planning-gap discovery for `g01.002`; on unblock, log the seam-contract creation and the recompile from blocked to ready or deferred.

## Next task

Close the analytics seam planning gap and either create
`003-analytics-export-contract.md` or remove export work from the active queue.
