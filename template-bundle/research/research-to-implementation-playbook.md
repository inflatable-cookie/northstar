# Research-to-Implementation Playbook

Status: Draft
Owner:
Last updated:
Purpose: Ensure research findings actively inform implementation instead of remaining isolated in the research corpus.

## The Problem

Research without application creates drift.
This playbook keeps architecture, implementation, validation, and review tied back to evidence.

## Workflow

### Phase 1: Discovery

1. Identify the architecture area or contract the task belongs to.
2. Check `master-index.md` for the relevant memo, value track, dossiers, source hubs, and prototypes.
3. Read the translation memo before making implementation choices.
4. Confirm whether any prototype or validation work is still required.

### Phase 2: Decision

Before coding, record:
- which research artifacts were consulted
- which decisions follow directly from the research
- which recommendations were intentionally rejected or deferred
- which risks still require prototype or validation work

Use `templates/implementation-decision-record-template.md` when the decision should remain durable.

### Phase 3: Implementation

- Reference the research artifact in code comments when the implementation encodes a research-driven behavior.
- If research is missing, capture the gap in `gaps-found-during-implementation.md`.
- If the implementation reveals a conflict with the research, document the deviation and rationale instead of silently drifting.

### Phase 4: Validation

- Derive tests from the behaviors the research claims matter.
- Validate prototype-gated recommendations before treating them as settled.
- Record what was checked in the roadmap batch log.

### Phase 5: Review

Reviewers should check:
- the implementation consulted the relevant research
- deviations are documented and justified
- missing research was captured as a gap instead of ignored
- required prototypes were completed or explicitly left open

## Lightweight PR Checklist

- [ ] I checked `master-index.md` for relevant research.
- [ ] I read the translation memo for this area.
- [ ] I documented any major implementation decisions or deviations.
- [ ] I captured any missing research in `gaps-found-during-implementation.md`.
- [ ] I added tests or validation steps that reflect the research basis.

## When Research Is Missing

1. Do a quick targeted scan if the answer is likely to be cheap to find.
2. Record the gap if the answer is still missing.
3. Make the provisional decision explicit.
4. Queue deeper research or prototype work if the risk is material.

## Next Task

Adapt this playbook to the project's actual architecture doc names, review flow, and prototype naming scheme once research starts shaping active delivery.
