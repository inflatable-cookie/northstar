# Translation Memo: Rust Quality Authoring And Audit

Status: promoted — contract 004 active; roadmap `g02.030` complete
Owner: repo maintainers
Last updated: 2026-08-26
Related track: language-specific coding quality packs
Promotion targets: `docs/architecture/system-architecture.md`,
`docs/specs/031-rust-quality-authoring-and-audit.md`, and
`docs/contracts/004-language-quality-pack.md`

## 1) Project problem statement

Northstar has strong planning and delivery guardrails, but it does not yet give
agents a source-backed language standard for producing and repairing code. The
first target is Rust: dependable architecture, explicit invariants, readable
control flow, disciplined failure handling, and evidence proportionate to risk.

The problem has two distinct operational forms:

1. During ordinary Rust work, the agent should apply a compact standard while it
   designs, edits, tests, and reviews the current change.
2. On explicit request, the agent should audit either the current uncommitted
   tranche or the full Rust codebase, repair findings in coherent batches, and
   prove the result.

Long coding sessions and context compaction make prompt-only standards
unreliable. A large rule dump also consumes the context needed to understand the
actual system. The standard therefore needs short re-entry points, selective
reference loading, and executable closeout checks. The explicit audit must use
the same rules rather than inventing a stricter second standard.

## 2) External evidence summary

### Existing agent skills

`leonardomso/rust-skills` is the strongest broad public candidate found. At the
audited commit it contains 265 indexed rules across 26 categories, progressive
rule loading, structural validation, and compile checks for example code. Its
Skills directory entry reported about 4,300 installs during this research.

It is useful as a source quarry, not as Northstar's authority. It mixes
correctness and API guidance with dependency preferences and performance advice
that require workload evidence. Universal recommendations for containers,
allocation strategies, atomics, inlining, LTO, or codegen units can create
complexity and slower builds without improving the target system.

Trail of Bits' `rust-review` provides a much stronger adversarial review model.
It inventories capabilities and runs focused passes for unsafe boundaries, FFI,
memory safety, concurrency, panic denial-of-service, async behaviour, resource
handling, and logic correctness. It produces structured findings and SARIF. It
is a valuable high-risk review input, but it is security-focused, large, and not
an everyday clean-code or architecture standard.

Smaller strict-Rust skills were rejected as foundations. Their common failure
mode is impressive-sounding absolutes backed by project-specific preferences:
blanket bans, framework assumptions, unexplained dependency choices, or rules
that optimize before measurement.

### Engineering and assurance sources

Microsoft's Pragmatic Rust Guidelines provide the best broad foundation found
for ordinary engineering. They cover universal code rules, libraries,
applications, FFI, correctness, performance, project structure, documentation,
and an explicit agent/LLM consumption surface. They recommend standard static
verification tools and curated lint configuration rather than relying on prose
alone.

The official Rust API Guidelines remain the strongest public-API checklist for
naming, conversions, documentation, predictability, type safety, dependability,
debuggability, and future proofing. Official Clippy guidance is also a necessary
constraint: `clippy::restriction` must not be enabled wholesale because its
lints can be situational or contradictory.

ANSSI's Secure Rust Guidelines add security, reliability, peer-review
readability, and maintainability guidance from the French national
cybersecurity agency. High Assurance Rust contributes the more important
assurance model: confidence comes from evidence such as fuzzing, dynamic
analysis, deductive verification, portability work, and explicit failure
behaviour, not from stylistic strictness alone.

The Safety-Critical Rust Consortium has the best emerging rule shape. Its rules
carry stable identifiers, requirement categories, lifecycle status, Rust
release applicability, scope, decidability, FLS links, rationale, examples, and
deviation semantics. The current 0.1 material is still immature: the audited
tree contained 26 guideline sources, most marked draft, and no approved rules.
It should be tracked and selectively piloted, not presented as settled
authority.

NASA-STD-8739.8 and SAE JA1020 reinforce a key boundary. High-integrity software
depends on lifecycle assurance, traceability, risk classification, independent
review, controlled change, and acceptable evidence. A Northstar skill can
support those practices; it cannot certify a product or make "NASA-grade" a
truthful label by enabling more lints.

`stopslop` is an experimental deterministic linter worth evaluating. It targets
generation residue that ordinary language linters often miss, including omitted
"rest unchanged" comments, leaked chat text, stubs, swallowed errors,
pass-through wrappers, and speculative abstractions. Its low adoption and
heuristic rules make benchmark evidence mandatory before Northstar relies on it.

## 3) Recommendation

Create one Rust quality pack with two internal workflow tracks backed by one
versioned rule catalogue.

### Track A: everyday authoring

This track applies whenever an agent writes, reviews, or refactors Rust. It is
compact and re-enters at three points:

1. **Entry:** a short path-scoped instruction tells the agent to load the Rust
   quality pack and the repository's selected assurance profile for Rust work.
2. **Work:** the skill keeps a small authoring loop in immediate context and
   loads domain references only when the change touches their triggers.
3. **Exit:** an Effigy selector checks the changed tranche and prompts a final
   human-quality diff review before completion.

The compact authoring loop should require the agent to:

- locate system boundaries and state the invariants affected by the change;
- choose the simplest sufficient design and resist speculative abstraction;
- make failure and resource behaviour explicit at external boundaries;
- keep control flow, naming, and ownership legible to a human reviewer;
- add tests and analysis proportionate to the changed risk;
- review the final diff for churn, unnecessary machinery, and missing evidence.

Specialized references load only when relevant: public APIs, unsafe/FFI,
async/concurrency, parsers and untrusted input, persistence, performance, macros,
or high-assurance work.

The exit selector is the primary defence against context decay. The working name
is `effigy rust:changed`; the final selector name remains an implementation
decision. It should combine deterministic tools with a rule-based diff review,
not pretend that tool success proves architectural quality.

### Track B: explicit audit and repair

This track runs only after an explicit audit-and-repair request. It must resolve
its scope before inspection:

- **worktree:** staged, unstaged, and relevant untracked Rust source, manifests,
  build files, tests, and documentation relative to `HEAD`;
- **repository:** every in-scope Rust crate and workspace surface, excluding
  generated or vendored code only through explicit repository policy;
- later extensions may add a commit range, crate, or named subsystem without
  weakening the two required scopes.

The audit-and-repair workflow should:

1. read repository architecture, contracts, toolchain/MSRV policy, deviations,
   and assurance profile;
2. inventory crates, targets, features, public APIs, unsafe/FFI, async,
   concurrency, generated code, and risk-bearing boundaries;
3. run deterministic formatting, compiler, lint, documentation, dependency,
   test, and profile-specific checks;
4. inspect correctness and assurance, architecture, and human readability as
   separate passes;
5. record each finding with rule ID, severity, evidence, affected location,
   proposed correction, and deviation route;
6. repair findings in coherent batches without discarding user changes;
7. widen repair scope only to direct callers, tests, documentation, or contracts
   required to keep the original repair coherent, and report that widening;
8. stop for operator direction when a fix requires a breaking interface or
   architectural decision not already authorized;
9. rerun affected checks and review the final diff for regressions and churn;
10. report repairs, justified deviations, blockers, and evidence.

The mode must not run blanket `cargo fix`, reformat unrelated code, replace
working abstractions only to satisfy taste, or optimize without measurements.
For a repository-wide scope it should continue through bounded repair waves
rather than produce one unreviewable rewrite.

### Shared rule authority

Workflow track and assurance strength are separate axes. Both tracks consume
the repository-selected profile from the same catalogue:

- **ordinary:** dependable general engineering and readable code;
- **strict:** stronger safety, API, dependency, concurrency, and validation
  rules for production libraries and services;
- **high assurance:** traceability, independent review, evidence retention,
  qualified or pinned tooling, and risk-selected advanced verification.

Each rule needs enough structure to generate both projections:

| Field | Purpose |
| --- | --- |
| stable ID and title | durable references across skills, findings, and deviations |
| category | mandatory, required with deviation, or advisory |
| domains and applicability | language version, crate type, boundary, and assurance profile |
| rationale and source provenance | why the rule exists and which source/revision supports it |
| upstream maturity | official, approved, draft, independent, or experimental |
| authoring projection | short instruction used during ordinary work |
| audit procedure | how to inspect the rule deliberately |
| mechanical enforcement | rustc, Clippy, rustfmt, Effigy, or another named tool |
| remediation policy | safe automatic fix, review-required fix, or operator decision |
| exceptions and deviation evidence | legitimate non-compliance without silent suppression |
| completion evidence | what proves the rule was assessed or satisfied |

The authoring and audit views should be generated or mechanically checked from
this catalogue. They must not become hand-maintained copies.

### Northstar, Effigy, and repository authority

- **Northstar** defines the rule schema, source-provenance requirements,
  workflow contracts, assurance-profile model, deviation shape, and copy-ready
  repository contract.
- **Effigy** resolves scope and orchestrates the repository's actual tools and
  selectors. Northstar must not hard-code one universal Cargo command graph when
  the target repository already owns a validated task surface.
- **The target repository** selects its assurance profile, generated/vendor
  exclusions, MSRV/toolchain, permitted deviations, and project-specific
  architecture rules.
- **The agent** applies the selected rules, explains non-mechanical judgments,
  preserves user changes, and stops when remediation needs new authority.

## 4) Tradeoffs the project would accept

- Everyday mode will not load the full standard into every Rust turn.
- Some quality judgments remain manual and explainable rather than falsely
  deterministic.
- Strict and high-assurance profiles cost more build and review time.
- An explicit audit may widen a small diff to its direct correctness surface,
  but must name the widened files and reason.
- A curated source-backed standard will initially cover fewer rules than a
  265-rule public checklist.
- Draft consortium rules may be piloted but cannot silently become mandatory.

## 5) What must be true before adoption

- The two tracks read one catalogue and one repository-selected profile.
- Everyday entry and exit anchors survive long sessions and context compaction.
- Worktree and repository scope resolution is deterministic and preserves dirty
  user state.
- Every mandatory or required rule names enforcement or an explicit manual
  review procedure.
- Suppressions and deviations carry a reason and do not silently become stale.
- Audit repair cannot make breaking or architectural decisions without existing
  authority.
- Tool success is reported as evidence, not as proof of overall code quality.
- Northstar does not claim certification, NASA compliance, or safety integrity
  from skill use alone.

## 6) Required prototype or validation work

Build a benchmark corpus before implementing the complete skill:

- ordinary application changes;
- public library APIs;
- deliberately over-engineered agent code;
- unsafe and FFI boundaries;
- async services and subtle concurrency;
- parsers and attacker-controlled input;
- code with intentional, justified deviations;
- strong human-written Rust that a noisy standard must not degrade.

Evaluate both tracks independently and together:

- defects and architectural problems detected;
- false-positive and unnecessary-rewrite rate;
- regressions introduced by automated remediation;
- diff size and unrelated churn;
- reviewer comprehension and readability preference;
- proportion of findings backed by deterministic evidence;
- behaviour after a long session or context compaction;
- time and tool cost by assurance profile.

Use blind human comparison where practical. Compare unchanged baseline code,
the everyday-authoring result, and the audit-repaired result without telling the
reviewer which path produced each version.

Do not score everyday authoring as defect detection. Everyday and combined
trials should share bounded coding tasks and be compared on task acceptance,
residual violations, preservation, churn, review, and cost. The explicit audit
track separately measures detection and repair against seeded defects.

Pilot `stopslop`, Trail of Bits review prompts, and selected
`leonardomso/rust-skills` rules as independent inputs. Promote only rules that
improve the corpus without unacceptable false positives or code churn.

Revision F supplied the first valid replicated ordinary result. The compact
everyday projection passed all three runs. The combined sequence also passed but
improved only one paired result, so the frozen selector rejected it as the
default. Explicit audit failed all three runs through repeated cross-rule misses,
two noisy public-trait changes to the clean control, and one incomplete unsafe
contract. This supports everyday authoring as an operator-review candidate and
keeps audit, stress, contract, and implementation work blocked.

Revision G closed the audit projection's repeated cross-rule miss and noisy
trait additions: all three runs reached full finding recall and precision while
preserving clean controls. It did not make unsafe repair dependable. Two final
`CStr::from_ptr` contracts omitted a lifetime no-mutation obligation, and one
blind reviewer missed the omission. The next decision is policy, not prompt
tuning: supply pinned official operation contracts and evidence, or keep unsafe
repair out of the ordinary automated audit path.

The operator chose the report-only boundary for ordinary and strict audit.
Unsafe and FFI findings remain mandatory, but those profiles may not mutate the
boundary. High-assurance repair is a separate authority: it requires pinned
official operation-specific contracts and independent review evidence. Revision
H tests the strict report-only path without weakening recall, preservation, or
review thresholds.

Revision H then exposed two protocol defects rather than usable adoption
evidence: the answer key confused report-only authority with a justified
candidate's retain outcome, and reviewer rejection was not executable in the
score. Revision I corrects those contracts while leaving the selected unsafe
boundary and all quality thresholds unchanged.

Revision I's nominal pass was also invalid: the scorer measured precision but
did not enforce the frozen `1.0` gate. Revision J makes that threshold
executable and distinguishes assessing a compliant required-rule candidate
from recording a violation.

Revision J produced valid evidence for the selected unsafe policy. All three
runs achieved full key recall and precision while keeping unsafe/FFI findings
report-only and preserving those fixtures. Explicit audit still passed only
`2/3`: one subject attached the expected experimental slop finding to the wrong
function, and the corrected blind-review contract rejected the inaccurate
evidence. The next decision is whether exact evidence locality becomes part of
the finding contract or the experimental slop candidate leaves the
promotion-critical set.

The operator chose exact finding locality. Revision K keeps the experimental
slop rule report-only but requires each finding to identify its file and owning
symbol or span, with hidden answer-key verification. A correct rule/case label
attached to the wrong function can no longer pass mechanical scoring.

Revision K showed that relationship-level rules may have more than one valid
exact symbol. Revision L replaces singular hidden locations with finite
accepted sets while retaining exact matching; the slop candidate remains pinned
only to the actual forwarding function.

Revision L validated that design but passed only `2/3`. One subject shifted
three case records while producing reasonable final code; exact locality and
blind review rejected the evidence drift. The remaining decision is whether
case-local result construction becomes deterministic infrastructure or the
audit remains prototype-only.

The operator selected deterministic infrastructure. Revision M gives every
opaque fixture its own record, derives identity and change bookkeeping during
assembly, and rejects cross-case locality or unattributed mutation before a
result can be returned. It changes no rule, oracle, threshold, repair authority,
or runtime setting.

Revision M passed all three isolated runs. Each recovered all 12 findings with
recall, precision, exact locality, clean preservation, scope, and churn `1.0`;
all three blind reviewers scored correctness and readability `5/5`. Everyday
authoring and explicit audit now both have valid replicated evidence. The
operator accepted the initial rule promotion and contract 004 is active.

## 7) Promotion target

- `architecture` — promoted shared catalogue, two workflow tracks, assurance
  profile axis, and Northstar/Effigy/repository authority split;
- `retired spec` — source curation, rule schema, benchmark, scope resolver,
  and prototype behaviour retained for evidence history;
- `contract 004` — active mandatory behaviour, explicit triggers, repair
  authority, profile, deviation, and evidence semantics;
- `roadmap g02.030` — completed production-boundary, implementation, evidence,
  and distribution sequence;
- `watch only` — changing consortium drafts, upcoming Clippy safety-critical
  lints, and certification-tooling claims.

## 8) Remaining evidence gaps

- Future ordinary and high-assurance rule membership and validation.
- Non-Effigy consumer adaptation; the production path requires Effigy.
- Whether future evidence promotes any `stopslop`-derived rule beyond
  evaluation-only/report-only.
- Observable context-compaction resilience and operator-provided live-use
  feedback.
- How audit findings and accepted deviations are serialized for machine use.
- Which high-assurance techniques are required by risk class rather than merely
  available.

## 9) Sources

Sources were reviewed on 2026-08-24. Repository sources are pinned to the
audited commit for reproducibility.

| Source | Audited revision | Confidence | Use |
| --- | --- | --- | --- |
| [Rust Skills](https://github.com/leonardomso/rust-skills/tree/fd2a861ab0406a4ac536a55274d14ea6fd1ca9c9) | `fd2a861` | medium | broad candidate-rule inventory and progressive disclosure |
| [Trail of Bits Rust Review](https://github.com/trailofbits/skills/tree/293fb74c3151cceda32a85a545fe8acd67f8f5c6/plugins/rust-review) | `293fb74` | high for security review | adversarial audit workflow and structured findings |
| [Microsoft Pragmatic Rust Guidelines](https://github.com/microsoft/rust-guidelines/tree/c1d2efc4692630d5d2143b4ca446790005a714c9) | `c1d2efc` | high | general engineering, architecture, tools, and LLM projection |
| [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/checklist.html) | live on review date | high | public API quality |
| [Clippy documentation](https://doc.rust-lang.org/stable/clippy/index.html) | stable docs on review date | high | lint categories and restriction-group boundary |
| [Cargo `rust-version`](https://doc.rust-lang.org/stable/cargo/reference/rust-version.html) | stable docs on review date | high | repository-owned minimum compiler contract |
| [Rust release notes](https://doc.rust-lang.org/stable/releases.html) | stable docs on review date | high | feature stabilization evidence for MSRV fixtures |
| [Rust releases](https://blog.rust-lang.org/releases/) | live on review date | high | contemporary stable-release context |
| [ANSSI Secure Rust Guidelines](https://github.com/ANSSI-FR/rust-guide/tree/3f9e2e28095d0eeb35ed61e212a82be12fde4884) | `3f9e2e2` | high for secure-development guidance | security, reliability, review readability, and maintainability |
| [Safety-Critical Rust Coding Guidelines](https://github.com/Safety-Critical-Rust-Consortium/safety-critical-rust-coding-guidelines/tree/83978c4c8e947b0044dc5d182d298ab793ba14c4) | `83978c4` | high provenance, low maturity | rule schema, lifecycle, FLS mapping, and deviation model |
| [Rust 2026 safety-critical roadmap](https://rust-lang.github.io/goals/2026/roadmap-safety-critical-rust.html) | live on review date | high | evidence-first direction and standard-tool integration |
| [High Assurance Rust](https://github.com/tnballo/high-assurance-rust/tree/bd59fb1562affebb88c2d24f34a4b5d930ad3fa0) | `bd59fb1` | medium-high | assurance techniques and failure-oriented design |
| [SAE JA1020](https://saemobilus.sae.org/standards/ja1020_202603-safety-cybersecurity-recommendations-use-rust-language-critical-systems) | issued 2026-03-25 | high, access-limited | Rust safety argument context |
| [NASA-STD-8739.8B](https://standards.nasa.gov/standard/NASA/NASA-STD-87398) | Revision B | high | lifecycle assurance and independent verification boundary |
| [stopslop](https://github.com/mgiovani/stopslop/tree/bf31fd107d48028033dd869dd3ad2de2e040741a) | `bf31fd1` | experimental | deterministic agent-residue and structural heuristics |
