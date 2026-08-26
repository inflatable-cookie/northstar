# 092 - Run TypeScript Audit Production Evidence

Status: completed
Owner: repo maintainers
Updated: 2026-08-26
Master spec refs: `docs/specs/032-typescript-svelte-explicit-audit.md`
Roadmap ref: `g02.031`
Governing refs: `docs/contracts/004-language-quality-pack.md`, card 091,
`bundle-docs/research/prototypes/typescript-quality/independent-audit-protocol.md`
Auto-start next card: no

## Objective

Prove the installed-like production payload across three fresh isolated
explicit-audit subjects and blind reviewers before distribution.

## Scope

- production payload only for subject instructions and recording;
- frozen cases, rules, authority, locality, preservation, churn, and review
  gates;
- three valid replicates with fresh reviewers;
- no everyday, combined, toolchain/testing, or compaction claim.

## Acceptance criteria

- [x] `3/3` exact primary-defect recall and locality, no finding outside the
      frozen primary-plus-admissible-corroborating set, and protected behavior;
- [x] no clean-control mutation, cross-unit evidence, or unauthorized repair;
- [x] blind correctness/readability/scope/churn gates pass;
- [x] runtime cell and packet hashes remain stable;
- [x] valid evidence is archived without private runtime state.

## Validation

Run production packet checks, finalizers, archive verification, catalogue and
recorder checks, full QA, and diff validation.

## Evidence

Record provenance, scores, costs, hashes, failures, and bounded supported claims
in one production cohort report.

## Stop conditions

- halt on the first harness, authority, preservation, regression, or review
  failure;
- do not tune a frozen cohort or substitute research-payload evidence;
- do not start distribution without a complete passing cohort.

## Paused attempt — revision N

The deterministic harness qualifier passed, but replicate 1 halted at the exact
precision gate. The subject reported `TS-BOUNDARY-001` and `TS-READ-001` in the
error fixture in addition to its seeded `TS-ERR-001`. Both additions match the
production catalogue, the fixture's protected behavior, and its frozen
reference repair. The answer key was incomplete across applicable rules.

No review or later replicate ran. Revision N is unscored and must not be tuned
or reused. See `production-evidence-report-2026-08-26-n.md`. Card 093 remains
pending. Resume only with an explicit new revision after cross-rule answer-key
qualification.

## Paused attempt — revision O

Revision O dispositioned all 10 rules across all 12 units, hardened the parser
reference/control, froze the full runtime cell, and passed deterministic
qualification. O1 then repaired every physical defect but classified case C's
ineffective parser control flow only under `TS-BOUNDARY-001`, not also under
`TS-READ-001`. Revision N had used both valid labels for the same repair.

The exact occurrence gate cannot currently distinguish missed defect coverage
from bounded overlapping classification. No review or later replicate ran.
Revision O is unscored and must not be tuned or reused. Resume only after an
operator decision on primary-defect recall plus admissible corroborating labels.
See `production-evidence-report-2026-08-26-o.md`.

## Paused attempt — revision P

The operator approved a fresh revision using exact primary-defect recall plus a
bounded admissible corroborating-label set. Every corroborating rule/file entry
must name a same-file primary prerequisite. It is optional, cannot replace the
primary finding, and receives no authority beyond its own catalogue rule. Any
finding outside the two frozen sets still fails precision. Scope, locality,
repair attribution, controls, behavior, runtime cell, and blind review remain
unchanged gates.

P1 passed those normative gates: all 10 primary findings and the one admissible
corroborating finding were present, with the exact intended repairs, controls,
and behavior. The verifier then failed because it exact-compared the
evaluation-only `TS-SLOP-001` candidate ledger. The subject reported five valid
report-only candidates where the seed listed one. That comparison contradicted
the frozen catalogue and contract: evaluation-only evidence cannot fail an
audit. No reviewer or later replicate ran. Revision P is unscored and must not
be tuned or reused.

## Paused attempt — revision Q

Revision Q retains P's normative scoring and all mechanical, authority, and
blind-review gates. Evaluation-only candidate identity and count are recorded
as measurement. They are not answer-key precision or recall gates. An unknown
evaluation rule, or a repair authorized by evaluation-only evidence, still
fails. The deterministic qualifier accepted the seed candidate set, extra valid
candidates, and no evaluation candidates before launch.

Q1 passed normative scoring, exact repair scope, controls, behavior, and
evaluation measurement, then failed because the oracle required generated
`subject-notes.md` in the discovery-time input scope. The file did not exist at
discovery. The deterministic self-test masked the defect by creating the note
before recorder initialization. No reviewer or later replicate ran. Revision Q
is unscored and must not be tuned or reused. See
`production-evidence-report-2026-08-26-q.md`.

## Paused attempt — revision R

Revision R separates discovery-time repository inputs from required audit
outputs. `subject-notes.md` is absent from the answer-key and initial scope
oracle, but remains required, non-empty, and present in the exact final file
set. The qualifier must create the note only after recorder initialization. All
revision-Q normative, evaluation, authority, preservation, runtime, and blind-
review gates remain unchanged.

R1 created the note before recorder initialization and legitimately included it
in the discovered repository scope. The verifier rejected that additional
ownership even though every frozen input was covered. Inspection also exposed
normal Effigy graph and doctor-report state not represented in the exact final-
file oracle. No reviewer or later replicate ran. Revision R is unscored and must
not be tuned or reused. See `production-evidence-report-2026-08-26-r.md`.

## Revision S gate

Revision S requires every frozen discovery input exactly once and permits
`subject-notes.md` as the sole additional owned file when it exists at recorder
initialization. The note remains mandatory and non-empty in the final file set.
Known `.effigy/graph` and `.effigy/reports` runtime state is excluded as tooling;
audit records remain exact evidence. The qualifier must cover note creation
both before and after initialization. All other revision-R gates remain frozen.

## Revision S result

Passed `3/3`: `30/30` primary findings, exact normative precision, `9/9` clean
controls, protected behavior, exact repair scope, `96/96` blind review
dimensions, and `24/24` accepted repairs. Three exact 181-file archives exclude
private and disposable runtime state. See
`production-evidence-report-2026-08-26-s.md`.

## Next task

Card 093 subsequently distributed the exact revision-S payload and proved
93-file source/install parity. The lane is complete.
