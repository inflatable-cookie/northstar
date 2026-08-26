# TypeScript Quality And Svelte Overlay

Status: research recommendation
Updated: 2026-08-26
Evidence pinned: 2026-08-26

## 1. Problem

Northstar needs the same two quality tracks for TypeScript that it proved for
Rust: compact everyday guidance that survives routing, and an explicit
worktree or repository audit that records findings before bounded repair.
TypeScript adds two complications. Its strongest checks are split across the
compiler, type-aware linting, dependency analysis, tests, and human review.
Framework code also carries lifecycle and server-boundary rules that do not
apply to ordinary `.ts` files.

The design question is whether Svelte should become a separate skill. It
should not. Svelte is a conditional overlay in the TypeScript quality pack.
SvelteKit is a narrower sub-overlay. A separate visual-design or copy-quality
system may be justified later, but that is not a coding-quality pack.

## 2. Evidence

### TypeScript baseline

- TypeScript's [`strict`](https://www.typescriptlang.org/tsconfig/strict.html)
  family is the compiler baseline, not the whole quality system. Options such
  as
  [`exactOptionalPropertyTypes`](https://www.typescriptlang.org/tsconfig/exactOptionalPropertyTypes.html),
  [`noUncheckedIndexedAccess`](https://www.typescriptlang.org/tsconfig/noUncheckedIndexedAccess.html),
  [`noImplicitOverride`](https://www.typescriptlang.org/tsconfig/noImplicitOverride.html),
  and
  [`noFallthroughCasesInSwitch`](https://www.typescriptlang.org/tsconfig/noFallthroughCasesInSwitch.html)
  close distinct evidence gaps. Northstar must honour repository-owned config,
  not rewrite it as taste.
- typescript-eslint documents
  [typed linting](https://typescript-eslint.io/getting-started/typed-linting/)
  as a separate, more expensive layer. Its
  [strict type-checked preset](https://typescript-eslint.io/users/configs/)
  is explicitly opinionated and not semver-stable. Presets are evidence inputs,
  not Northstar's rule authority.
- Oxlint's
  [JavaScript plugins](https://oxc.rs/docs/guide/usage/linter/js-plugins.html)
  are alpha and lack type-aware rule APIs. Its native
  [type-aware linting](https://oxc.rs/docs/guide/usage/linter/type-aware.html)
  requires TypeScript 7 and remains incomplete. A production pack cannot
  depend on either surface without repository-specific qualification.
- Google's
  [TypeScript style guide](https://google.github.io/styleguide/tsguide.html)
  treats assertions and non-null assertions as unsafe, prefers `unknown` over
  `any`, and favours automation for rules that prevent real defects rather than
  arbitrary stylistic uniformity.
- [NASA SWE-061](https://swehb.nasa.gov/spaces/SWEHBVD/pages/102695445/SWE-061+-+Coding+Standards)
  supports a tailored standard, aligned static analysis, resolved findings,
  review, deviations, and objective evidence. It does not make a coding skill
  NASA-certified.

### Anti-slop specimen

[`dmmulroy/anti-slop`](https://github.com/dmmulroy/anti-slop) was audited at
commit `6d538555cb151d4121ed51a27db81890eacf8ae9` (2026-08-18). Its checks passed
locally at that revision. It is a useful detector specimen: compact, testable,
vendored, and installer-owned. It is not a standards authority or a complete
workflow.

The strongest calibration evidence is the project's
[large-monorepo adoption report](https://github.com/dmmulroy/anti-slop/issues/21).
Only six rules were adopted unchanged across 568,443 lines and 4,421 TypeScript
files. Other rules were deferred, narrowed, or rejected because context changed
their meaning. Open reports show false positives around
[type predicates](https://github.com/dmmulroy/anti-slop/issues/15),
[closed-key records](https://github.com/dmmulroy/anti-slop/issues/18), and
[alias resolution](https://github.com/dmmulroy/anti-slop/issues/25).

Disposition for the prototype:

| Upstream idea | Northstar disposition |
| --- | --- |
| chained or widening assertions | adopt as evidence-laundering candidate |
| broad object parameters | evaluate as readability and API-shape evidence |
| `unknown` at parsers, guards, catch, or external boundaries | explicitly allow; require narrowing |
| blanket unknown-parameter/return bans | do not adopt globally |
| blanket module-mocking ban | do not adopt; assess owned seams and behaviour |
| conditional empty-object spread | do not adopt globally |
| shape-member name bans | reject as a general standard |
| `SAFETY` comment presence | harden before use; presence alone proves nothing |

### Svelte and SvelteKit

- The official
  [Svelte ESLint plugin](https://github.com/sveltejs/eslint-plugin-svelte)
  separates compiler, security, best-practice, SvelteKit, stylistic, and
  experimental rules. Its `all` preset is explicitly unstable and not
  recommended. Northstar should select evidence by concern, not inherit the
  preset wholesale.
- Svelte 5 says
  [`$derived`](https://svelte.dev/docs/svelte/$derived) expressions should be
  side-effect free. [`$effect`](https://svelte.dev/docs/svelte/$effect) runs
  only in the browser, should not normally update state, needs resource
  teardown, and does not track asynchronous reads after an `await` or timer.
- Svelte's
  [compiler warnings](https://svelte.dev/docs/svelte/compiler-warnings)
  include substantial accessibility evidence. Suppression needs the same
  deviation discipline as other findings.
- SvelteKit's
  [state guidance](https://svelte.dev/docs/kit/state-management) forbids shared
  server state and asks load functions to remain free of stateful side effects.
  Its
  [server-only module protection](https://svelte.dev/docs/kit/server-only-modules)
  is disabled when `TEST=true`, so a passing test run alone does not prove the
  import boundary.
- Official
  [testing guidance](https://svelte.dev/docs/svelte/testing) supports unit,
  component, and end-to-end layers through repository-selected tooling. The
  quality pack should require behavioural evidence, not prescribe one test
  library beyond the repository's established stack.

## 3. Recommendation

Build one TypeScript pack with one versioned catalogue and one explicit audit.
Rules carry `applicability` and an optional `overlay` value:

- `typescript`: all in-scope TypeScript and JavaScript selected by repository
  policy;
- `svelte`: `.svelte`, Svelte modules, and directly owning tests/config when
  Svelte is a declared dependency;
- `sveltekit`: SvelteKit routes, hooks, server modules, load functions, and
  directly owning tests/config when Kit signals are present.

Everyday routing loads the small TypeScript projection, then only the overlay
needed by the file and repository. Explicit audit resolves all applicable
overlays once and records them in its scope. Base mandatory rules remain in
force; an overlay may tighten applicability but cannot silently replace them.

Repository versions control semantics. Svelte 3/4 code must not be judged as
Svelte 5 runes code. Framework, compiler, module-mode, runtime, and strictness
upgrades remain operator decisions.

The initial catalogue should cover evidence integrity, boundary parsing,
promise ownership, error handling, package boundaries, toolchain fidelity,
behavioural testing, and proportionate design. Svelte adds derived/effect
semantics, SSR state isolation, compiler accessibility evidence, and component
behaviour. Anti-slop detectors remain inputs to those concerns, not a parallel
law book.

## 4. Tradeoffs

- One pack avoids duplicate TypeScript rules and keeps mixed `.ts`/`.svelte`
  audits coherent. It needs precise activation fields and scoped projections.
- Typed linting finds defects syntax-only tools cannot, but costs more and
  depends on project configuration. The audit must report degraded evidence.
- Human-quality rules can catch generated-looking indirection and needless
  wrappers. They are noisy and must stay review-required or evaluation-only
  until benchmarked.
- Framework guidance ages faster than language rules. Pinned provenance and
  version applicability are required.

## 5. Adoption gates

Do not promote a production TypeScript or Svelte surface until all are true:

1. clean controls and seeded defects exercise every candidate rule;
2. everyday and audit tracks are scored independently;
3. mixed monorepo scope, dirty-state preservation, and nested package discovery
   are tested;
4. at least one base-only TypeScript package and one SvelteKit package across
   two repository boundaries provide blind review evidence;
5. typed-tool absence and partial configuration produce visible degradation,
   not false success;
6. operator-owned changes remain explicit: dependencies, compiler/framework
   versions, module mode, strictness, public API, and architecture;
7. source and installed skill artifacts pass exact parity checks.

## 6. Prototype work

The adjacent
[`typescript-quality`](../prototypes/typescript-quality/README.md) seed contains
a catalogue schema, candidate catalogue, mixed TypeScript/Svelte benchmark
manifest, defect fixtures, clean controls, authoring starters, a nested-package
scope resolver, and local integrity checks. Its
[calibration protocol](../prototypes/typescript-quality/calibration-protocol.md)
keeps live target selection operator-owned and scores audit and everyday tracks
separately. The seed validates research shape only. It is not a production
skill, lint preset, benchmark result, or promotion decision.

The first operator-selected calibration showed that dependency presence alone
is too broad. Framework overlays also need an owned semantic surface such as
Svelte source, Kit routes, hooks, or server modules. Root and workspace
ownership must prevent ancestor configs from leaking into fixtures,
documentation examples, generated output, or vendored resources.

Targeted mechanical calibration then showed that process exit status is not a
quality verdict. One Svelte check exited zero with 29 reactivity warnings, two
package test routes failed before collection after bypassing their declared
container context, and a compiler-clean Svelte package still had seven tests
using an API removed by Svelte 5. The audit must preserve diagnostics, resolve
selectors through the owning workspace, record the actual execution
environment, and keep compiler, lint, and test evidence distinct.

The next prototype revision adds an opaque independent-review packet for all 11
audit cases and 16 candidate claims. Three clean controls carry deliberate
false-positive probes. The reviewer sees source, concerns, and audit prompts,
but not rule IDs, case identity, defect/control status, expected disposition,
or prior results. Preparation refuses overwrite, binds source and coordinator
snapshots by SHA-256, rejects answer leakage, and detects source tampering.
Completed review assessment requires enforced isolation and treats comparison
with the seed as agreement, not correctness.

An optional Codex CLI adapter now automates that reviewer boundary on macOS.
It requires the packet outside Northstar, proves eight Seatbelt read/write
constraints before launch, ignores user configuration and rules, permits writes
only to the reviewer record and private runtime, captures runtime/tool-use
evidence, and runs the packet assessor after return. The provider-neutral
protocol does not depend on this adapter. A mock-only launch test proves the
complete path without creating review evidence.

The first real isolated review assessed 11 cases and 16 claims: 11 supported,
two unsupported, and three uncertain, with one determinate seed disagreement.
The narrowing and `$derived` clean controls held. The conditional-spread control
did not: its outer spread was genuinely redundant, so the control was corrected
in a new frozen benchmark revision. Toolchain and testing claims were uncertain
because source-only packets lacked effective config, runner, and test evidence;
they now require package-level fixtures. The archived result remains bound to
the old hashes and is not retroactively rescored.

The nine supported normative source-local claims now have eight paired repair
fixtures. Each pair binds a defective baseline and reference repair to explicit
protected behaviour, permitted edit scope, and review-required authority. A
strict pinned TypeScript/Svelte package proves baseline defects and reference
behaviour, including SSR rendering, compiler accessibility diagnostics, and
concurrent request isolation. Evaluation-only `TS-SLOP-001` remains a signal,
not repair authority. This qualifies a repair corpus; it is not a subject trial
or promotion result.

A fresh filesystem-isolated subject then repaired all eight hidden-reference
cases. The frozen verifier accepted all nine normative claims, all protected
behaviour, strict typecheck, and the declared edit boundary. A separate isolated
reviewer accepted all eight before/after pairs across correctness, scope,
readability, and unnecessary churn: 32 passes, no failure or uncertainty. Two
earlier runs were excluded because hidden checks enforced an unstated port range
and object identity. The corrected packet now states the range, accepts
structural equality, and binds the exact verifier hash. This is one positive
synthetic repair trial, not promotion.

The first paired everyday-authoring pilot then compared identical neutral tasks
with and without a 126-word routed TypeScript/Svelte projection. Both isolated
arms passed behavior, scope, typecheck, and rule-signal capture with equal tool
cost. Blind per-task review scored 11 ties, four guided wins, and no baseline
win. TypeScript boundary and async results were identical; the guided Svelte arm
won on semantic output markup, immutability, readability, and review effort.
This supports the compact overlay shape without proving repeatability or context
survival.

Two fresh paired replicates reversed the first-pilot conclusion. Across three
replicates and 45 dimensions, guided and baseline each won five; 35 tied. Guided
won two of nine overall tasks, baseline won one, and six tied. The baseline
boundary parser's explicit array rejection earned the only TypeScript
preference. Guided Svelte retained two overall wins, but one reviewer preferred
baseline churn and review effort. Guided median execution also rose to 78
seconds and six tool calls versus baseline's 64 seconds and five. Everyday
authoring is ineligible at this revision. Repair evidence remains positive and
separate.

The next projection revision is source-backed and narrow. JavaScript arrays
survive an object-type check, so a boundary that expects a named-field record
must distinguish arrays and `null`; list domains remain unaffected. The compact
surface is now 139 words. A fully new release-parser, audit-publisher, and
Svelte availability-summary corpus binds six visible requirement IDs to exactly
six mechanical gates. Quality signals are review-only. This qualifies the
revised corpus for a fresh cohort; it is not authoring evidence or promotion.

The first fresh pair then failed the unchanged no-regression gate. Guided won
the boundary parser by avoiding an assertion, but baseline won async clarity
with straight-line `await` and Svelte simplicity by leaving `items.length`
inline. Blind dimensions were 3 guided, 6 baseline, and 6 ties; overall tasks
were 1 guided and 2 baseline. The remaining pairs were not launched because
they could not erase reviewed regressions. Everyday authoring remains
ineligible. Explicit repair/audit evidence remains positive and separate.

A fresh precision review then confirmed the corrected conditional-spread
control: 13 determinate agreements, no disagreement, and the same three
package-context claims uncertain. Two more isolated repair pairs repeated the
first result. Across three pairs, all 27 normative claims, 96 review dimensions,
and 24 repair recommendations passed. The nine source-local rules are eligible
for explicit-audit-only contract promotion; slop remains evaluation-only.
Production distribution still requires a portable payload, fresh production
evidence, and installed parity.

## 7. Promotion path

Promote the nine evidenced rules through an explicit-audit-only contract and
roadmap lane. Prove the portable production boundary before scaffolding the
mode, then require fresh production-payload evidence and installed parity.
Keep everyday guidance out of the skill. Package-level toolchain/test fixtures
remain a separate research gap; failed candidates do not vanish into an
undocumented allow-list.

## 8. Open evidence gaps

- Which TypeScript rules improve human review scores without merely increasing
  lint count?
- Which checks remain reliable across npm, pnpm, Bun, Deno, Node, browser, and
  mixed-runtime repositories?
- What minimum evidence distinguishes a useful Svelte effect from state
  synchronization that should be derived?
- How should `.js`, generated clients, declaration files, and framework output
  enter or leave scope?
- Does one mixed-pack audit remain understandable at monorepo scale?
