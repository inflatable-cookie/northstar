# <NNN> - <Batch Card Title>

**Type: TEMPLATE** -- Copy and fill in for each execution batch.

Status: draft
Owner: <owner>
Created: YYYY-MM-DD
Master roadmap: <gNN.NNN>
Governing refs: <architecture files>, <contract files>
Auto-start next card: <yes/no/conditional>

## Ready-State Rubric

- [ ] Objective is bounded enough to finish without fresh planning decisions.
- [ ] Governing refs point at current canonical surfaces.
- [ ] Scope, acceptance criteria, validation, evidence, and stop conditions are explicit.
- [ ] Review oracle is present when acceptance is high-risk, universal, exact, or negative; otherwise explicitly noted as not required.
- [ ] Continuation envelope is explicit; next card is ready if auto-start is enabled.
- [ ] No unresolved planning gaps or operator intent checkpoints.

## Objective

State the exact bounded outcome for this card.

## Lane Runway Context

- Higher-level lane owner: <what this card serves beyond itself>
- Next likely cards or milestone transitions: <refs or none>
- Next planning checkpoint: <when strategy/intent must be reconsidered>

## Scope

- <in scope>
- Do not <out of scope>

## Steps

1. <step>
2. <step>

## Acceptance Criteria

- <criterion>

## Review Oracle

Use for concurrency, lifecycle, identity, persistence, security, public API, deployment, multi-version, or universal/exact/negative acceptance. Otherwise write `Not required` and why.

| Invariant | Adversarial counterexample | Expected failure or stop point | Required proof |
| --- | --- | --- | --- |
| <claim> | <smallest falsifying case> | <rejection/containment point> | <test/check/evidence> |

## Evidence Required

- <command/check/log actually run>

## Stop Conditions

- Stop on planning gaps, contract contradictions, or failed evidence gates.
- Ask for operator intent if an unresolved planning branch or milestone choice appears.

## Completion Notes and Artifact Lifecycle

- Outcome: <shipped outcome summary>
- Validation: <checks run and result>
- PR / Commit: <PR link, merge commit, or local commit>
- Limits / Blockers: <residual limits or none>
- Disposition trigger: active during execution; retains delivery evidence on completion; rolls up into `docs/roadmaps/archive/gNN.md` on generation rollover or during maintenance of an already-closed generation.

## Next Task

State the next ready card or promotion step unlocked by this card.
