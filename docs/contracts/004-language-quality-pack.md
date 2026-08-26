# 004 - Language Quality Pack

Status: active
Owner: repo maintainers
Updated: 2026-08-25
Depends on: `docs/contracts/001-working-rules.md`,
`docs/contracts/003-agent-instruction-surface.md`
Affects: language-quality catalogues, scoped authoring skills, explicit audit
skills or commands, Effigy selectors, consumer quality profiles, findings,
deviations, and completion evidence

## Purpose

A language quality pack raises code quality through two workflows backed by one
source of truth: compact guidance during normal coding and an explicitly
requested audit-and-repair pass. This contract keeps those workflows aligned,
keeps contextual judgment reviewable, and prevents a detector or style
preference from becoming unsupervised rewrite authority.

The first pack is Rust. Its initial production-valid profile is `strict`.
Ordinary and high-assurance profiles remain modelled catalogue inputs, not
validated production claims.

## Stable workflow names and triggers

The two contract-level workflow names are:

- **everyday authoring**: activates when an agent writes, reviews, or refactors
  in-scope language code. It is normal coding guidance, not permission to audit
  or rewrite the wider repository.
- **explicit audit-and-repair**: activates only when the operator explicitly
  requests a quality audit, no-slop pass, or equivalent audit-and-fix action.
  The request must identify or permit resolution of worktree or repository
  scope.

A product may expose a thin command adapter, but command spelling is an
implementation detail. It must route to these workflows without creating a
third standard or making explicit audit implicit.

## One catalogue, projected views

Each pack has one versioned rule catalogue. Everyday instructions, audit
procedures, mechanical checks, and completion reporting are generated from or
mechanically checked against that catalogue. Hand-maintained parallel rule
lists are forbidden.

Every rule record must carry:

- a stable rule ID, concern, category, applicability, and lifecycle maturity;
- profile-specific enforcement level;
- source provenance and the pinned source revision where available;
- a compact authoring projection and a deliberate audit procedure;
- named mechanical evidence, when any tool can contribute it;
- default remediation authority plus action-specific overrides;
- deviation requirements and completion evidence.

Enforcement levels mean:

- `mandatory`: assess whenever applicable and never silently waive a finding;
  record the effective remediation disposition even when authority is
  report-only;
- `required`: comply or record an accepted, evidenced deviation;
- `evaluation_only`: report and measure only; it cannot fail the workflow or
  authorize mutation.

Lifecycle maturity and enforcement are separate. Only approved normative
rules may fail a production workflow. Prototype or experimental records may
contribute evaluation-only candidates.

## Initial Rust strict catalogue

The first production-valid Rust catalogue contains six approved normative
rules and one experimental input:

| Rule | Strict level | Default remediation authority |
| --- | --- | --- |
| `RUST-READ-001` | required | `review_required` |
| `RUST-API-001` | required | `review_required` |
| `RUST-ERR-001` | required | `review_required` |
| `RUST-UNSAFE-001` | mandatory | `report_only` |
| `RUST-ASYNC-001` | mandatory | `review_required` |
| `RUST-MSRV-001` | required | `review_required` |
| `RUST-SLOP-001` | evaluation only | `report_only` |

`RUST-ERR-001` keeps `review_required` as its default. Defining or changing
foreign error signaling, sentinel values, out-parameters, callbacks, or ABI
status semantics uses action `change_foreign_error_policy` and requires
`operator_decision`.

`RUST-MSRV-001` permits a reviewed, behaviorally equivalent replacement that
supports the repository-declared MSRV. Raising `rust-version`, changing the
edition or toolchain policy, dropping supported compilers, or otherwise
changing compatibility policy requires `operator_decision`.

`RUST-SLOP-001` never supplies independent repair authority. Code it flags may
change only when a separate approved normative rule establishes an actionable
violation and supplies the applicable authority.

Strict unsafe and FFI findings are mandatory to assess and report but remain
report-only. This contract does not activate high-assurance unsafe repair.

The Rust 1.95 benchmark floor is evidence infrastructure, not a Northstar MSRV.
The consumer repository owns its declared compiler floor.

## Profile resolution

The consumer repository owns its selected profile. The initial Rust pack
exposes only `strict` as production-valid, so activation must resolve visibly
to `strict` or stop on an unsupported selection. It must not silently downgrade
to ordinary, upgrade to high assurance, or infer a different profile from the
workflow.

Activating ordinary or high assurance requires its own contract-backed evidence
and catalogue promotion. High assurance also needs risk-selected verification,
traceability, independent review, and pinned operation contracts; stricter
wording or more lints is insufficient.

## Agent-owned activation

Repository activation is part of the installed language pack, not a manual
operator installation procedure. When Northstar is requested for Rust work and
the scoped instruction block, profile, or deviations file is missing, the agent
runs the skill-local setup task before editing or auditing code.

Setup must be deterministic and idempotent. It discovers Cargo manifests and
explicit toolchain files, appends a marked compact activation block without
overwriting existing instructions, creates only missing contract files, and
preserves an existing valid profile or deviations file byte-for-byte. It fails
closed on conflicting or malformed existing setup.

Automation does not transfer repository policy ownership to Northstar. The
agent asks the operator only when policy cannot be recovered from the
repository, such as an undeclared effective MSRV or an uncertain generated or
vendored exclusion. It must not ask the operator to copy templates or fill
mechanically discoverable paths.

## Scope resolution

Worktree scope includes staged, unstaged, and relevant untracked language
source, manifests, build files, tests, and documentation relative to `HEAD`.
Repair may extend only to direct callers, tests, documentation, or contracts
needed to keep an in-scope correction coherent. Every extension is reported.

Repository scope includes every in-scope package, target, feature surface,
public API, and risk-bearing boundary. Generated and vendored code is excluded
only by explicit repository policy.

Both workflows preserve dirty user state. They must not clean, reset, discard,
or overwrite unrelated work. A repository-wide request does not authorize a
blanket rewrite, unrelated formatting, blanket automatic fixing, a breaking
interface change, or architecture replacement based on taste.

## Everyday authoring

Everyday authoring uses a compact path-scoped projection. It re-enters at task
start and again at coherent batch closeout. Detailed rule references load only
for applicable domains.

The closeout check covers the changed tranche and its direct correctness
surface. It records applicable rules, unresolved findings or deviations, and
repository-native validation. It does not scan or mutate unrelated code merely
because the repository contains more Rust.

## Explicit audit-and-repair

Explicit audit first resolves scope and snapshots existing dirty state. It then
runs distinct correctness and assurance, architecture, and human-quality
passes. Mechanical tools provide evidence; they do not replace source review.

Findings are recorded before mutation. Repair proceeds in coherent, reviewable
waves. Each wave stays within the finding's authority, preserves protected
behavior, and validates before the next wave. Missing external error policy,
breaking API decisions, compatibility-policy changes, and unauthorized
architecture decisions stop for the operator.

Audit result construction must be deterministic and case-local: each assessed
unit owns its findings, repair disposition, changed files, and changed-line
evidence. Final assembly derives aggregate scope from those local records and
rejects cross-unit evidence, unattributed mutation, applied repair on an
unchanged unit, or mutation without local repair authority.

## Findings, remediation, and deviations

Every finding must record:

- rule ID and lifecycle maturity;
- severity or enforcement level and confidence;
- exact file plus owning symbol or accepted line span;
- concise evidence and disposition;
- effective remediation authority, including the matched action override;
- changed scope and validation evidence when repaired.

Authority values mean:

- `report_only`: classify and explain; do not mutate for this rule;
- `review_required`: a bounded repair is allowed when the agent can show the
  rule, evidence, preserved behavior, and reviewable diff;
- `operator_decision`: stop before mutation and present the decision and impact.

An action-specific override wins over a rule's default authority. No tool,
detector, profile, or audit request may broaden that authority silently.

A deviation records the rule, exact scope, reason, evidence, accepting owner,
and expiry or recheck trigger. Suppression without that record is not a
deviation. Repository policy may be stricter but may not silently weaken a
mandatory Northstar boundary.

## Ownership boundary

- Northstar owns the reusable schema, catalogue provenance, workflow contract,
  profile model, deviation shape, and copy-ready integration.
- Effigy resolves scope and orchestrates repository-native tasks. It is not a
  second rule authority.
- The consumer repository owns profile selection, MSRV and toolchain,
  generated/vendor exclusions, project architecture, and accepted deviations.
- The agent applies the effective rules, preserves current work, records
  judgment, and stops when repair needs authority it does not hold.

## Completion evidence and claims

A passing result names workflow, profile, resolved scope, catalogue version or
hash, findings and dispositions, deviations, changed scope, repository-native
validation, and remaining limitations. Explicit audit also reports scope
widening, preservation, and repair waves.

The initial Rust evidence validates strict everyday authoring and strict
explicit audit separately. It does not validate the combined workflow as the
default, observable context-compaction resilience, ordinary or high-assurance
activation, certification, NASA compliance, a safety-integrity level, or a
safety case.

Production implementation requires roadmap cards derived from this contract.
The skill and Effigy selectors must not be scaffolded directly from the
prototype or research narrative.
