# 031 - Rust Quality Authoring And Audit

Status: retired-in-place — promoted and distributed
Owner: repo maintainers
Created: 2026-08-24
Updated: 2026-08-26
Depends on: `docs/contracts/003-agent-instruction-surface.md`
Research ref: `bundle-docs/research/translation-memos/rust-quality-skills-and-audit.md`
Prototype ref: `bundle-docs/research/prototypes/rust-quality/README.md`
Promotion targets: `docs/architecture/system-architecture.md`,
`docs/contracts/004-language-quality-pack.md`, Rust quality skill pack, and
Effigy selectors
Roadmap ref: `docs/roadmaps/g02/030-ship-rust-quality-authoring-and-audit.md`

## Problem

Northstar does not yet provide a source-backed coding-quality standard that can
guide an agent during ordinary Rust work and later audit and repair either the
current uncommitted tranche or an entire repository. Prompt-only standards lose
salience during long sessions, while large always-loaded rule sets crowd out the
system context needed to make good engineering decisions.

## Goal

Define and prove one Rust quality pack with:

- a compact everyday authoring track that re-enters at task start and batch
  closeout;
- an explicitly triggered audit-and-repair track for worktree and repository
  scopes;
- one versioned rule catalogue and repository-selected assurance profile shared
  by both tracks;
- a Northstar/Effigy boundary that keeps policy, orchestration, and local
  repository authority distinct;
- benchmark evidence that the system improves correctness, architecture, and
  human readability without unacceptable false positives or churn.

## Settled design boundaries

### Two workflow tracks

Everyday authoring and explicit audit-and-repair are different workflows. They
must not become different standards.

The everyday track applies to Rust writing, review, and refactoring. A short
path-scoped instruction activates the skill and repository profile. The skill
loads detailed references only for relevant domains. A changed-tranche Effigy
check plus final diff review re-anchors the standard before completion.

The audit-and-repair track runs only after explicit operator intent. It resolves
scope, inventories risk-bearing Rust surfaces, runs deterministic and manual
review passes, records source-backed findings, repairs them in coherent batches,
and revalidates the final result.

### Workflow and assurance are separate axes

The repository chooses an ordinary, strict, or high-assurance profile. Either
workflow can run under any selected profile. Audit mode does not silently raise
the repository's assurance requirements, and everyday mode does not weaken
them.

### Shared catalogue

Every rule has one canonical record with stable identity, category,
applicability, provenance, maturity, authoring projection, audit procedure,
mechanical enforcement, remediation policy, deviation semantics, and evidence
requirements. Skill and audit views are generated or mechanically checked from
that record.

### Authority split

- Northstar owns the reusable rule and workflow contracts.
- Effigy resolves scope and orchestrates repository-native tools.
- The consumer repository owns its profile, toolchain/MSRV, project-specific
  architecture, exclusions, and deviations.
- The agent applies rules and repairs only within existing authority.

## Required scope semantics

### Worktree scope

The minimum worktree scope includes staged, unstaged, and relevant untracked
Rust source, manifests, build files, tests, and documentation relative to
`HEAD`. Repair may extend to direct callers, tests, documentation, or contracts
required to keep an in-scope correction coherent. Any extension is reported.

The workflow preserves dirty user state. It must not clean, reset, discard, or
replace unrelated changes.

### Repository scope

Repository scope covers every in-scope Rust crate, workspace member, target,
feature surface, public API, and risk-bearing boundary. Generated and vendored
code is excluded only through explicit repository policy.

Repair proceeds in reviewable waves. A whole-repository request does not
authorize an unbounded rewrite, a breaking interface decision, or replacement
of working architecture based only on taste.

## Required review dimensions

The audit keeps three passes distinct:

1. **Correctness and assurance:** fallibility, panic reachability, unsafe/FFI,
   overflow, cancellation, concurrency, input trust, resource bounds, and
   proportionate verification.
2. **Architecture:** ownership, dependency direction, cohesion, public
   contracts, abstraction justification, invariants, and change containment.
3. **Human quality:** naming, cognitive load, control flow, explanatory
   structure, unnecessary machinery, agent residue, and diff readability.

Mechanical tools provide evidence for these passes but cannot replace them.

## Non-goals

- copying an existing public Rust skill wholesale;
- loading a complete coding standard on every Rust turn;
- enabling every Clippy restriction or nursery lint;
- making performance changes without measurements;
- blanket `cargo fix`, unrelated formatting, or silent large-scale rewrites;
- claiming certification, NASA compliance, or a safety integrity level;
- creating separate hand-maintained authoring and audit rule lists;
- adding implementations or roadmap cards before the rule contract and
  benchmark gate are ready.

## Rule catalogue prototype

The prototype must prove the schema on a deliberately small cross-section:

- one general readability/complexity rule;
- one public API rule;
- one failure-handling rule;
- one unsafe/FFI rule;
- one async or concurrency rule;
- one rule requiring project-specific applicability or deviation;
- one experimental slop-detection rule that may be rejected after evaluation.

Each prototype rule must cite a pinned source where available and distinguish
official, approved, draft, independent, and experimental provenance.

## Benchmark and evaluation

The benchmark corpus must include ordinary applications, libraries, unsafe/FFI,
async/concurrency, parsers, deliberately over-engineered agent code, justified
deviations, and strong human code that should remain unchanged.

Measure:

- defects and architecture issues found;
- false positives and unnecessary rewrites;
- regressions introduced during repair;
- diff size and unrelated churn;
- blind reviewer comprehension and preference;
- deterministic evidence coverage;
- behaviour after long context or compaction;
- runtime and review cost by assurance profile.

The everyday track, audit track, and combined sequence must be evaluated
separately.

The prototype runner now generates all three views from the shared catalogue,
initializes hash-bound result records, rejects malformed or stale evidence, and
scores detection, repair, preservation, scope, review, context, and cost gates.
It does not perform the agent judgment or repair itself.

The first strict explicit-audit author calibration recovered all 11 seeded
findings, made seven scoped repairs with no current-toolchain compile regression,
and preserved both clean controls. It is not adoption evidence: the subject
helped author the catalogue and harness, saw expected labels, and had no blind
reviewer. The run also showed that the FFI fixture's original repair expectation
would require an unauthorized C ABI decision. The benchmark now expects that
case to stop as blocked.

The harness now materializes separate subject and coordinator packets for all
three tracks. Subject packets randomize opaque case IDs and order, preserve
immutable baselines, expose the selected rule projection and declared
constraints, and omit expected labels. Authoring subjects also see task and
acceptance criteria because those are requirements. Coordinator packets retain
the mapping and answer key; authoring coordinators also retain references and
expected rule outcomes. Unblinding restores canonical case and changed-file
scope before validation and scoring.
This boundary still depends on coordinator process isolation and honest trial
provenance; it does not make a source checkout blind.

Calibration of the packet protocol exposed and closed a track-validity gap: the
seeded-defect corpus measures explicit audit, while everyday and combined use
separate authoring tasks. The runner now routes them through distinct result
contracts and scorers rather than treating authoring obligations as findings.

The authoring seed now contains five compileable task/reference pairs with
focused current-toolchain behavior tests, covering
recoverable parsing and public API traits, async lock lifetime, Rust 1.95
compatibility and direct flow, an explicitly specified non-panicking C ABI, and
preservation of a justified public facade. Authoring and combined trials share
these inputs. They are graded on task acceptance and residual violations, not
audit finding recall. Blinded packet tests keep references and expected rule
outcomes coordinator-only while leaving requirements visible to the subject.

Rust 1.95 is a representative contemporary benchmark floor, not a Northstar
default. The target repository remains authoritative for its declared MSRV. The
live seed proves that distinction with `u64::bit_width`: the API stabilized in
Rust 1.97, so it compiles on the current development compiler but the 1.95
matrix rejects it. The earlier author calibration remains immutable and records
its obsolete 1.64/1.65 inputs as historical evidence only.

Independent trials follow the prototype's `independent-trial-protocol.md`.
Passing provenance requires an opaque subject ID, exact runtime/version and
configuration, a named isolation method, packet-only repository access, and
blind review. The isolation method must enforce the filesystem, container, or
remote-workspace boundary; procedural instructions alone cannot pass. Ordinary
quality runs cannot stand in for long-context and
compaction evidence; the evidence stage must include a controlled stress cohort.
The smoke preparer creates all three arms atomically, keeps launch facts unset
until observed, and refuses overwrite rather than merging trial state.

The first independent smoke used filesystem-enforced packet isolation and
separate blind reviewers. Everyday authoring passed all gates. Combined
authoring failed an external C-symbol link check despite a clean self-audit and
used more time and tool calls. Explicit audit produced clean repairs but failed
the frozen policy expectations: it overreached on evaluation-only slop, chose an
FFI policy that required an operator decision, missed two expected
classifications, and returned a structurally invalid result record. That audit
arm is retained but excluded from quality aggregation. The harness now ships
the immutable result schema in every subject packet and mechanically checks the
reference FFI export.

The first ordinary cohort completed nine isolated subjects and six fresh blind
reviews. It is diagnostic, not adoption evidence. Blind review found that the
authoring async reference never suspends despite a yield-before-increment
contract, and that its poison and overflow behavior conflicts with the strict
error rule. The audit manifest also omits the poisoned-lock panic-path question.
The frozen stop policy halted benchmark revision `2026-08-24-b` before stress.

Independent of those oracle defects, every explicit-audit subject repaired an
evaluation-only slop finding and missed the separate required readability
classification. Across the other four authoring cases, all six everyday and
combined subjects passed blind acceptance. The archived result therefore gives
useful revision input but no track or rule is eligible for production promotion.

Revision `2026-08-25-c` repaired those corpus defects and completed nine fresh
isolated subjects. Its first blind review then exposed an unpublished validator
condition: the packet schema allowed integer or null necessary-line judgments,
but the hidden predicate required null for unchanged cases. The reviewer used
the natural numeric value `0`. The stop policy halted the cohort before
unblinding or scoring; five reviews did not start.

Revision D defines reviewer necessity as a non-negative integer everywhere,
with `0` for unchanged cases. Packet schemas, prose, exact validation, negative
tests, finalized result evidence, and scoring agree. This is harness readiness,
not quality evidence.

Its fresh cohort completed all nine subjects and six reviews. Finalization then
showed that the audit answer key contradicted the packet again: it demanded a
non-report-only facade disposition despite the evaluation-only instruction,
silently reserved the FFI error convention for an operator, and unnecessarily
blocked independent unsafe documentation. Revision D is diagnostic only.

Revision E aligns those dispositions and exposes the operator-owned error
policy in the subject packet. Local packet and scoring tests prove the split
authority. This remains harness readiness, not quality evidence.

Its fresh cohort completed all subjects and reviews, then exposed missing
executable gates. All three combined runs exceeded the frozen churn ceiling but
the scorer marked them passed; audit reviewer minima and cohort selection also
lacked explicit decision output. Revision E is diagnostic only.

Revision F gates churn and audit review scores directly. Its finalizer emits
separate correctness/readability medians, paired quality dominance, cost ratios,
track eligibility, and a recommended ordinary track. A replay against frozen E
evidence correctly produced everyday `2/3`, combined `0/3`, audit `0/3`, and no
eligible track.

The fresh revision F cohort completed nine filesystem-isolated subjects and six
fresh blind reviews without a harness defect. Everyday authoring passed `3/3`
and is eligible. Combined passed `3/3`, stayed within cost ceilings, and improved
only one of three paired results, so it is not justified as the ordinary
default. Explicit audit failed `0/3`. Every audit missed the required
`RUST-READ-001` classification on the unnecessary wrapper; two also changed the
protected clean control, and one blind review found an incomplete
`CStr::from_ptr` safety contract. The frozen decision recommends
`everyday_authoring`.

This is valid ordinary evidence, not permission to scaffold the production
pack. It makes the compact everyday projection eligible for operator review and
keeps explicit audit, stress, the language-quality-pack contract, and
implementation planning blocked.

Revision G repeated only the explicit audit cell with the same rules, cases,
answer key, thresholds, runtime, and repair authority. It made cross-rule
classification explicit, required evidence of trait usefulness, and required
exact unsafe API contracts. Three isolated subjects and three fresh blind
reviewers completed without a harness defect.

Every subject recovered 12/12 expected findings with no false positive,
preserved the clean controls, and passed churn, scope, toolchain, and repair
authority gates. The frozen scorer passed `2/3`; one run failed reviewer
acceptance after omitting `CStr::from_ptr`'s no-mutation lifetime obligation.
Post-unblind inspection found the same omission in another passing run whose
reviewer missed it. Only one of three final FFI contracts was demonstrably
complete. Explicit audit remains ineligible.

The operator selected the revision H boundary. Ordinary and strict audits must
report and classify unsafe/FFI findings but must not repair those boundaries.
High-assurance audit may repair them only when the operation's official safety
contract is pinned and independent review evidence is required. Revision H
tests only the strict report-only path; it cannot authorize high-assurance
repair.

Revision H executed that policy correctly but is invalid adoption evidence.
Its answer key conflated a justified candidate's `retain` outcome with the
rule's `report_only` remediation authority. Its review contract also allowed a
reviewer to reject a subject finding while awarding accepting correctness.
Revision I corrects those two protocol defects without changing the unsafe
policy, rule set, finding keys, fixtures, thresholds, runtime, or Rust 1.95
floor.

Revision I then exposed a missing executable precision gate: the scorer's
decision passed two runs with one answer-key false positive each despite the
frozen `1.0` threshold. Required-rule wording also encouraged agents to record
compliant abstraction assessments as findings. Revision J makes precision a
hard gate and clarifies that a compliant `RUST-READ-001` assessment is not a
finding.

Revision J supplied the first valid cohort for the selected report-only unsafe
policy. All three subjects recovered 12/12 expected findings with precision
`1.0`, preserved all protected properties, and left every unsafe/FFI boundary
unchanged. Two runs passed. One blind reviewer rejected a `RUST-SLOP-001`
finding whose evidence named `fetch_user` as the pass-through even though
`get_user` was the exact-forwarding function. The corrected review contract
capped that case at `3/5` and made the second pass non-credible. Explicit audit
remains ineligible at `2/3`.

The operator selected exact finding locality for revision K. Every finding must
name its source file and either the owning symbol or a valid line span; the
hidden answer key pins the expected file and symbol. This keeps
`RUST-SLOP-001` experimental and evaluation-only while making J's wrong-function
failure machine-checkable.

Revision K exposed a singular-oracle defect: the relationship-level
`RUST-READ-001` finding can be located precisely at either function in the
unjustified layer. Revision L keeps the hard locality gate but uses a finite
non-empty set of accepted exact locations. The experimental slop finding still
accepts only the actual forwarding symbol.

Revision L produced valid `2/3` evidence. Two runs achieved recall, precision,
and exact locality `1.0` with `5/5` reviews. The third shifted findings and
changed-file bookkeeping across the clean library, parser, and nested-control
cases. Scoring and blind review independently rejected the cross-case drift.
Exact locality is validated; complete explicit-audit reliability is not.

The operator selected deterministic case-local result construction for revision
M. Each fixture now owns one result record. A packet-local recorder assembles
the final result in packet order, derives changed-file and changed-line
bookkeeping from the actual fixture pair, and rejects findings located in a
different case. It also rejects applied repairs on unchanged cases and changed
cases with no local repair authority. Rules, oracles, thresholds, and runtime
remain fixed so the cohort tests the result boundary rather than a tuned prompt.

Revision M passed `3/3`. Every run recovered all 12 findings with recall,
precision, locality, clean preservation, scope discipline, and churn `1.0`;
introduced no regression or protected-property change; and received blind
`5/5` correctness and readability. The result boundary eliminated L's clerical
failure without changing the audit standard. Explicit audit-and-repair became
eligible alongside everyday authoring; the operator accepted both evidence
tracks and the initial catalogue decision.

## Contract gate

The accepted initial catalogue decision is recorded in
`bundle-docs/research/prototypes/rust-quality/catalogue-promotion-review-2026-08-25.md`.
It promotes six normative rules, retains evaluation-only `RUST-SLOP-001`, and
selects the validated strict profile. The catalogue now has action-specific
MSRV remediation authority and report-only slop remediation.

Contract `docs/contracts/004-language-quality-pack.md` settles:

- public trigger and naming;
- mandatory rule schema and provenance requirements;
- worktree/repository scope resolution;
- audit mutation and scope-widening authority;
- deviation and suppression semantics;
- profile selection and inheritance;
- required evidence and completion reporting;
- Northstar/Effigy/consumer-repository ownership.

Both gates have passed. Production implementation still requires roadmap cards
derived from the contract; the prototype is not an implementation authority.

## Open decisions

- final implementation names for the skill and any thin command adapter;
- whether the explicit audit gets a thin command adapter or remains a skill mode;
- exact Effigy selectors and non-Effigy adaptation;
- machine-readable finding and deviation formats;
- whether future evidence promotes any `stopslop`-derived rule beyond evaluation;
- risk classes that trigger Miri, fuzzing, Loom, coverage, mutation testing, or
  formal methods.

## Acceptance criteria

- [x] external sources and existing skills are assessed in a translation memo;
- [x] everyday authoring and explicit audit-and-repair are separate tracks;
- [x] both tracks share one catalogue and selected assurance profile;
- [x] worktree and repository scope semantics are defined provisionally;
- [x] the Northstar/Effigy/repository authority split is explicit;
- [x] a representative rule-catalogue prototype exists;
- [x] benchmark seed corpus and scoring procedure exist;
- [x] one runner projects both workflows and records comparable results;
- [x] both tracks and the combined sequence have independent smoke coverage;
- [x] the first ordinary cohort and blind reviews are archived with invalidation reasons;
- [x] a corrected benchmark revision yields valid replicated ordinary evidence;
- [x] the everyday authoring projection passes the ordinary gate;
- [x] the explicit audit-and-repair projection passes the ordinary gate;
- [x] operator reviews the benchmark result and selected rule set;
- [x] the language-quality-pack contract is active;
- [x] implementation cards are compiled only after the contract gate passes.

## Implementation boundary

Roadmap `g02.030` owns implementation sequencing. Card 083 selected the
Effigy-native boundary; card 084 promoted the strict-only catalogue, schemas,
checked projections, and package validator without changing default skill
context. Card 085 added repository-activated everyday routing, selective rule
loads, and start/closeout re-entry. Card 086 added explicit audit routing,
finding-first repair waves, and deterministic dirty-state-preserving records.
Card 087 is complete: production revision K passes explicit audit 3/3 and
production revision M passes everyday authoring 3/3 under frozen blind-review
and churn gates. Card 088 distributed the payload, then incorporated
operator feedback by making repository activation an agent-owned idempotent
setup task. The resulting 76-file published install matches source. Compaction
resilience, ordinary-profile validation, and high-assurance validation remain
outside the production claim.
