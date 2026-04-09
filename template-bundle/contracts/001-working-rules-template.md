# 001 - Working Rules

Status: active
Owner: <owner>
Updated: YYYY-MM-DD
Depends on: <docs/architecture/system-architecture.md>
Authority owners: <owners>
Affects: <surfaces>

## Problem

State why this repo needs an explicit execution grammar rather than relying on
informal habits.

## Contract

### Delivery grammar

- Material work should follow this chain:
  `vision -> research/specs -> architecture + contracts -> roadmap milestone -> execution -> evidence -> closeout`.
- Use separate contracts for stable seams, important boundaries, or durable
  rules that need their own authority surface.
- Use specs only while shaping material changes; promote durable outcomes into
  architecture and contracts before roadmap execution depends on them.
- Once those outcomes are promoted, treat specs as provisional planning history
  rather than canonical authority; keep, archive, or remove them based on
  whether they still help the active lane.
- A ready batch card should define scope, steps, governing refs, acceptance
  criteria, evidence requirements, stop conditions, and whether
  auto-continuation is allowed.

### Execution guardrail pack

- prefer real integrated behavior over mockups, placeholders, or token
  scaffolding
- prefer simplicity over decorative or architectural complexity that the
  governing refs do not require
- prefer end-to-end follow-through over convenient partial closure when a batch
  promised a working path
- prefer explicit incompleteness over implied completion when a path is still
  scaffolded or unproven
- treat disconnected gesture work as incomplete unless the batch was explicitly
  scoped as bounded substrate-only work

### Definition of done

- Do not call work done while it is still a mockup, placeholder, or partial
  token implementation.
- Update dependent refs, roadmap state, and logs so they match reality.
- Run the required validation commands and record them in a log.
- Name unresolved blockers or limits explicitly instead of hiding them inside a
  completion claim.

### Execution autonomy

- Agents may continue across consecutive ready batch cards without waiting for
  a manual prompt.
- Auto-continuation is allowed only when the cards stay inside the same active
  lane, the governing refs still match, and the prior card's evidence gate
  passed.
- Set a local upper bound for uninterrupted runs, such as a card limit or time
  limit, so autonomy remains bounded.

### Automation runtime policy

- Prefer `effigy` when it already covers the repo operation.
- When repo-owned script logic is still needed, default to `TypeScript` run
  with `bun`.
- Use `bash` only for thin glue or compatibility boundaries that Effigy or
  Bun/TypeScript cannot own cleanly.
- Use `python` or another runtime only when a concrete technical requirement
  justifies it.

### Generation posture

- Treat roadmap generations as substantial sequencing eras, not one-or-two-file
  buckets.
- Keep one generation active across many milestones until the sequencing
  baseline itself needs a reset.

### Stop conditions

- stop on planning gaps, contradictions, or missing authority
- stop when user-facing ambiguity exceeds the project guardrails
- stop when validation fails in a way that changes the plan
- stop when the current card is complete and the next one is not already ready

## Validation

- <validation command>

## Roadmap Impact

- <gNN.NNN>

## Planning Notes

Record the practical reason these working rules exist in this repo.

## Next Task

Name the next batch that should use or tighten these rules.
