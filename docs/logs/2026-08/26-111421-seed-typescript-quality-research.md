# Seed TypeScript Quality Research

Date: 2026-08-26
Roadmap: none; research and contract-boundary batch
Card state: no production implementation card opened

## Outcome

Northstar now has a source-backed TypeScript quality translation memo and a
small executable benchmark seed. The proposed system keeps one base TypeScript
catalogue and two conditional framework layers: Svelte and SvelteKit. They use
the same everyday and explicit-audit workflows, findings, authority, profiles,
and evidence. No parallel Svelte skill or command is proposed.

The prototype contains 13 candidate or experimental rules and 14 audit,
control, and authoring cases. Clean controls protect valid `unknown` parsing,
conditional object spread, and pure Svelte-derived state from blanket anti-slop
bans. A read-only scope resolver proves nested package discovery, Svelte and
SvelteKit overlays, framework-version capture, generated-output exclusion, and
visible degraded evidence in a synthetic mixed TypeScript/Svelte/Rust monorepo.

The calibration protocol keeps live repository selection with the operator,
separates audit and everyday evidence, requires independent finding
disposition, and forbids missing tools from becoming false passes.

The operator then selected two live mixed repositories. Read-only calibration A
caught five scope-resolution failures before promotion: ancestor config
inheritance, fixture and dot-resource inclusion, dependency-only Kit activation,
documentation-example activation, and a false Svelte-library config gap. The
resolver now uses root/workspace ownership and semantic framework surfaces.
Rule sampling supported the external-boundary concern, retained assertion
review, and narrowed error/effect wording. No rule was promoted.

Targeted calibration B then ran package-owned compiler, Svelte checker, lint,
and test selectors without repairing either consumer. The shared library was a
clean mechanical control. The mixed repository exposed a zero-exit Svelte check
with 29 reactivity warnings, `.ts`-only lint coverage, two test runners that
failed before collection after running outside their declared container, a
compiler-clean Svelte package with seven Svelte 5 component-API test failures,
and a compiler-clean base client with two behavioural contract failures. The
prototype now treats warnings, execution context, startup failure, compilation,
and behavioural tests as distinct evidence. No rule was promoted.

An independent finding-disposition harness now prepares 11 opaque reviewer
cases with 16 claims, including false-positive probes on all three clean
controls. Reviewer and coordinator packets are separated; rule IDs, case IDs,
defect/control labels, expected dispositions, and prior conclusions stay out of
the reviewer surface. SHA-256 bindings, overwrite refusal, answer-leak checks,
tamper detection, enforced-isolation metadata, and completed-review assessment
are executable. No independent review has run yet.

An optional Codex CLI reviewer adapter now makes the isolation step agent-owned
on macOS. It refuses packets inside Northstar, proves eight Seatbelt read/write
boundaries, ignores user configuration and rules, limits writes to the reviewer
record and private runtime, records launch evidence, and assesses the return.
Its self-test uses a fake CLI that returns only `uncertain`; no reviewer was
launched and no synthetic disposition was counted as evidence.

The operator then authorized the first real isolated review. A fresh
`gpt-5.6-sol` high-reasoning reviewer completed 11 cases and 16 claims in 158
seconds with five command invocations. Seatbelt isolation, packet return, and
assessment validation passed. Eleven claims were supported, two clean probes
were rejected, three toolchain/test claims were uncertain for lack of package
evidence, and one clean-control claim disagreed with the seed. The reviewer was
right: the conditional-spread control wrapped its only property in a redundant
outer spread. Revision `0.2.0-research` corrects that fixture and freezes version
fields; the old run remains immutable against its exact hashes.

The compact 26-file archive retains reviewer/coordinator packets, runtime
launch and event evidence, assessment, Seatbelt profile, and exact hashes. It
excludes authentication, CLI caches, skills, configuration, and runtime
databases. Archive verification passes.

Bounded repair calibration is now open only for the nine independently
supported normative source-local claims. Eight paired fixtures bind defective
baselines and reference repairs to protected behaviour, permitted scope, and
review-required authority. A pinned strict TypeScript/Svelte package proves
each baseline defect and reference behaviour. `TS-SLOP-001` remains an
evaluation-only signal.

The first valid bounded repair trial is now complete. A fresh high-reasoning
subject worked from copied baselines without references or Northstar access. It
changed nine permitted files, preserved six protected files byte-for-byte, and
passed the frozen strict typecheck and hidden behaviour verifier for all eight
cases and nine normative claims. A separate isolated reviewer then accepted all
eight repairs with 32/32 passes across correctness, scope discipline,
readability, and unnecessary churn. It recorded no finding or uncertainty.

Two earlier attempts are invalid evidence, not subject failures. The first
hidden oracle required an unstated `0..65535` port range; the second required
object identity where structural equality met the stated boundary. The contract
and oracle now agree, and prepared trials bind the exact verifier hash. The
successful run used a fresh packet and retained no access to either attempt.

The first paired everyday-authoring pilot is also complete. Baseline and guided
subjects received identical neutral boundary, async, and Svelte tasks; only the
guided arm received the 126-word routed projection. Both passed frozen behavior,
scope, typecheck, and rule-signal checks in 76–78 seconds with six tool calls.
Blind per-task A/B review produced 11 ties, four guided wins, and no baseline
win. Boundary and async outputs were identical. Guided won the Svelte task on
semantic `<label>/<output>` markup, immutable derived state, readability, and
review effort. One earlier paired run was excluded because the oracle required
exact markup and treated guidance signals as mechanical behavior.

Two fresh paired replicates completed the ordinary cohort. Aggregate blind
review across 45 dimensions is 5 guided wins, 5 baseline wins, 35 ties, and no
uncertainty. Guided won two of nine overall tasks, baseline won one, and six
tied. The independently reviewed loss was a guided boundary parser that accepted
arrays carrying the requested fields while baseline explicitly rejected them.
Async outputs tied throughout. Guided Svelte retained semantic/readability wins,
but not a no-regression result. Guided median cost was 78 seconds and six tool
calls versus baseline's 64 seconds and five. Everyday authoring is ineligible at
this revision; the positive repair result remains separate.

The next authoring revision uses primary narrowing evidence rather than tuning
against the failed implementation. TypeScript documents arrays and `null` as
pitfalls of bare object checks; ECMAScript defines the direct array test; Google
guidance supports `unknown` plus runtime narrowing over assertions. The
139-word projection now distinguishes named-field records from arrays only when
the domain requires it.

Benchmark `0.4.0-research` replaces all three authoring tasks. Its visible task
contract owns six requirement IDs; both corpus and frozen arm verifiers exercise
exactly those six. Four code-shape signals are review-only and cannot fail an
arm. Trial preparation freezes the corpus contract beside the oracle. Reference
arms, strict typecheck, Svelte compilation/rendering, file scope, projection
tampering, and contract tampering pass. This qualifies the novel corpus for a
fresh cohort but supplies no new authoring result.

The first fresh pair made the revised projection ineligible. Both arms passed
all mechanical gates. Blind review scored 3 guided wins, 6 baseline wins, and 6
ties; guided won the boundary task by preserving narrowing evidence, while
baseline won async clarity with straight-line `await` and Svelte simplicity by
leaving `items.length` inline. Under the existing no-regression gate, two more
pairs could not rescue a revision with two overall guided losses, so they were
not launched. The valid pair is archived as `authoring-1936faabfdd2`; all
temporary cohort workspaces were moved to macOS Trash. Everyday TypeScript and
Svelte authoring remains research-only and must not be installed. Explicit
repair/audit evidence is unaffected.

## Boundary

Contract 004 now permits framework overlays inside a language pack. Activation
must come from repository-owned dependency, version, package, and path signals.
An overlay may add or tighten a concern but cannot silently weaken base
mandatory rules. Framework upgrades, compiler/runtime policy, module mode,
strictness, public API, and architecture remain operator-owned.

Only Rust strict remains production-valid. TypeScript and Svelte are research
inputs until independent authoring and audit evidence supports promotion
through a contract-backed roadmap card.

## Evidence

- TypeScript compiler and TSConfig references;
- typescript-eslint typed-linting and preset stability guidance;
- Oxlint JavaScript-plugin and type-aware maturity notes;
- Google TypeScript style guidance;
- NASA SWE-061 coding-standard process guidance;
- `dmmulroy/anti-slop` at commit
  `6d538555cb151d4121ed51a27db81890eacf8ae9` plus its large-monorepo adoption
  report and false-positive reports;
- official Svelte compiler, reactivity, testing, state-management, and
  server-only-module guidance.

## Validation

- prototype catalogue check — pass: 13
  rules, 14 benchmark cases, and 8 repair cases;
- scope-discovery self-test
  — pass: ownership, overlays, versions, exclusions, and degraded
  evidence;
- blind-review self-test
  — pass: 11 cases, 16 claims, separation, overwrite refusal, enforced
  isolation, completed assessment, and tamper rejection;
- isolated-reviewer self-test
  — pass: eight Seatbelt paths plus mock launch and assessment;
- blind-review archive verification
  — pass: `packet-f23d78a09201`, 26 files, exact set and hashes, no excluded
  runtime state;
- repair fixture frozen install, strict TypeScript typecheck, and verifier —
  pass: 8 cases, 9 normative claims, protected behaviour proved;
- repair-trial self-test — pass: reference repair, protected-file rejection,
  and frozen-oracle mismatch;
- bounded subject verification — pass: `repair-afbc0a90e9c4`, 8 cases, 9
  claims, 9 editable files changed, 6 protected files unchanged;
- isolated repair review — pass: `packet-6c98dc8d868a`, 32/32 quality
  dimensions and 8/8 accept recommendations;
- repair archive verification — pass: 60 files, exact set and hashes, no auth,
  dependencies, caches, scratch, or runtime databases;
- authoring corpus and trial self-test — pass: 3 tasks, 6 claims, 126-word
  projection, paired reference arms, and projection-tamper rejection;
- paired authoring trial — pass: both arms mechanically valid; 4 guided wins,
  11 ties, 0 baseline wins, 0 uncertain across 15 dimensions;
- authoring archive verification — pass: 62 files, exact set and hashes, no
  auth, dependencies, caches, scratch, or runtime databases;
- three-replicate authoring aggregate — pass: 6 valid arms, 9 tasks, 45 scored
  dimensions; decision ineligible at 5 guided, 5 baseline, and 35 ties;
- revised authoring corpus and trial self-test — pass: 3 novel tasks, 6 declared
  behavior gates, separated review signals, 139-word projection, frozen corpus
  contract, paired references, and tamper rejection;
- revised authoring live pair — mechanically valid; blind review 3 guided, 6
  baseline, and 6 tie dimensions, with 1 guided and 2 baseline overall tasks;
  cohort stopped under the no-regression gate and projection ineligible;
- `jq empty` on the catalogue schema, catalogue, and benchmark manifest — pass;
- `effigy qa` — pass;
- `effigy qa:docs` — pass before closeout log;
- `git diff --check` — pass before closeout log.

Consumer preservation after calibration B:

- `shared-foundation-a`: tracked worktree clean;
- `mixed-product-a`: tracked worktree clean;
- no project dependency installation, formatting, repair, or consumer commit
  occurred; one selected container task provisioned its Effigy runtime inside
  the existing workspace container.

## Friction

Research mode points to a missing
`docs/research/research-to-implementation-playbook.md`. The gap is recorded in
`PAPERCUTS.md`; the batch continued using the active contract and existing Rust
translation-memo precedent.

## Next Task

Keep the ineligible everyday projection out of the installed skill. Advance the
independently positive explicit-audit track: build package-level fixtures for
toolchain/test evidence and confirm revision 0.2's corrected clean control
before opening its production roadmap card. Any later everyday revision needs
new source-backed wording and another genuinely new task set.
