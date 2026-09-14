# g03.016 — Economical Chatterbox and frontier Oracle

Owner: repo maintainers
Created: 2026-09-14
Governing refs: contract 001, section 07, Northstar skill architecture
Depends on: `g03.015` complete at `1b84042`
UI classification: none

## Outcome

Northstar uses an economical persistent Chatterbox for ordinary operator-facing
planning and an optional, bounded frontier Oracle for difficult planning,
without creating a second planning authority or spending frontier capacity on
routine conversation.

## Ready-State Rubric

- [x] The operator has chosen the economical-Chatterbox/frontier-Oracle split.
- [x] Oracle authority, escalation triggers, and return path are settled.
- [x] The existing planning delegate has a clean successor rather than a
  parallel overlapping role.
- [x] Coordinator portability and Queue's on-demand recovery path are preserved.
- [x] Existing Chatterbox threads and workspaces have an explicit preservation
  boundary.
- [x] UI classification is `none`.

## Decisions

- Keep Chatterbox as the sole persistent operator-facing planning authority. It
  owns ordinary discovery, repository inspection, triage reconciliation,
  canonical promotion, frontier design, and approved Queue dispatch.
- Route Chatterbox through an economical conversational-planning capability by
  default. It must still be adequate for sustained operator dialogue, planning
  synthesis, repository tools, and exact canonical promotion; a cheap worker
  profile does not qualify merely because it uses the preferred model.
- Replace the planning-delegate role with **Oracle**. Oracle is an optional,
  issue-scoped frontier planning consultation. It may converse with the
  operator, inspect evidence, challenge assumptions, compare options, design a
  workflow or UI concept, and strengthen acceptance oracles. It returns a
  bounded dossier or one unique triage note to Chatterbox.
- Oracle never becomes a second planning authority. It cannot promote canonical
  planning, declare readiness, dispatch or supervise workers, review or merge
  implementation PRs, or contact the Coordinator directly.
- Invoke Oracle only for a material unresolved architecture/product choice,
  substantial UI workflow, conflicting authority, costly-to-reverse decision,
  difficult acceptance oracle, or explicit operator request. Scope, duration,
  documentation volume, and worker failure are not sufficient triggers.
- Do not rely on Chatterbox to estimate its own intelligence or confidence. A
  mandatory decision-risk gate runs before canonical readiness, dispatch, or a
  decision-changing ruling. It tests observable task properties and planning
  completeness.
- The gate requires Oracle planning when a material decision touches security,
  authentication or authorization, permissions, secrets, cryptography,
  privacy or sensitive information, destructive data handling, a trust
  boundary, irreversible migration, cross-system architecture, distributed or
  concurrent state, or another high-blast-radius feature. A fully settled
  mechanical change in one of those areas may proceed only when canonical
  authority and an exact acceptance oracle leave no material decision to the
  worker.
- The gate also requires Oracle when Chatterbox cannot cite the owning
  authority, name the decision owner, distinguish evidence from assumptions,
  explain plausible alternatives and their trade-offs, identify irreversible
  effects, or state a falsifiable acceptance oracle. Conflicting evidence or a
  novel domain fails the gate rather than being papered over with confidence
  language.
- Every ready task records `Oracle gate` in its dispatch manifest as either
  `not required` with the concrete settled reason, or `satisfied` with the
  Oracle dossier identity and the decision Chatterbox promoted. Absence or a
  generic low-risk claim blocks readiness.
- Give Oracle the smallest useful dossier: exact question, authority and
  evidence, known assumptions, constraints and non-goals, options already
  considered, risk trigger, operator-owned decisions, and requested output.
  Redact secrets and raw sensitive payloads. Oracle advice never substitutes
  for required specialist evidence or independent security-sensitive review.
- Use provider-neutral capability names in Northstar. Local Paseo profiles map
  economical conversational planning to DeepSeek Flash or another adequate
  route, and frontier Oracle work to Astra, Fable, or another explicitly
  suitable frontier route.
- Standardize the delivery role as **Coordinator**. Orchestration is the
  activity, not a parallel role name. Rename the internal Orchestrator mode and
  current templates/callers together, with no compatibility alias. Historical
  evidence and existing thread titles need not be rewritten.
- Queue uses Coordinator capacity only for unresolved delivery exceptions and
  standalone Northstar retains the Coordinator role for portable delivery.
  Lifecycle hooks, agent closeout fallback, and mechanical verification are
  mechanisms rather than operator-facing roles.
- Atlas, readiness review, refresh, cleanup, architecture refocus, and UI design
  remain workflows routed through Chatterbox or Oracle, not new agent
  authorities.
- Migration never archives, deletes, renames, detaches, stops, or replaces an
  existing Chatterbox, Coordinator, worker, reviewer, or workspace. Operators
  may retain a current thread, change its model where the harness supports it,
  or start a new economical Chatterbox from an explicit context handoff.

## UI Design Brief

Not applicable.

## Dispatch manifest

- **State:** ready; one protocol-reduction lane.
- **Owned mutable paths:** current reusable role doctrine under `bundle-docs/`,
  `skills/northstar/`, and `template-bundle/`; matching Northstar contracts and
  focused role-routing checks; this task and g03 indexes.
- **Reserved closeout surfaces:** g03.016 lifecycle record, declared generated
  projections, and deletion of the submitted handoff belong to the repository
  hook.
- **Worker:** automatic general pool; independent exact-head review required.
- **Oracle gate:** not required — the operator has already settled the role
  topology, mandatory escalation classes, authority split, and migration
  boundary; the worker owns a provider-neutral documentation and routing
  migration with explicit structural oracles.
- **Serial edges:** none after g03.015. No consumer rollout is part of this task.
- **Excluded:** Paseo profile mutation, Queue source, Effigy source, consumer
  repository edits, provider/model names in reusable routing policy, product
  implementation, releases, and all existing thread/workspace disposition.

## Work

1. Replace planning-delegate doctrine and routing with the bounded Oracle role,
   including its dossier, authority, escalation, operator interaction, and
   Chatterbox return path.
2. Make economical conversational planning the Chatterbox default and frontier
   planning explicitly Oracle-only except for an operator-selected override.
3. Add the mandatory decision-risk gate, ready-task manifest declaration, and
   bounded redacted Oracle dossier contract. Cover material security, privacy,
   sensitive-data, trust-boundary, irreversible, and complex cross-system
   decisions without escalating settled mechanical work by keyword alone.
4. Rename the current internal Orchestrator mode and live reusable delivery
   surfaces to Coordinator, updating callers and links atomically without an
   alias or rewriting historical evidence.
5. Present the minimal live role topology: Chatterbox, optional Oracle,
   Coordinator, implementation Worker, and independent Reviewer. Describe
   lifecycle execution and verification as mechanisms.
6. Add focused routing and structural checks for cheap-profile inadequacy,
   decision-risk gate completeness, valid/invalid Oracle escalation, sensitive
   dossier redaction, Oracle authority refusal, Coordinator fallback
   portability, provider neutrality, and thread preservation.
7. Run docs QA, full QA, installed-skill parity, link checks, and
   `git diff --check`.

## Acceptance and review oracle

- A routine operator planning request stays with an economical Chatterbox and
  does not request frontier capacity.
- Each settled Oracle trigger can produce one bounded frontier consultation;
  broad scope, long duration, or worker failure alone cannot.
- A material security, sensitive-information, trust-boundary, irreversible, or
  complex cross-system decision cannot become ready without a satisfied Oracle
  gate. A settled mechanical control proves why escalation is unnecessary.
- A ready dispatch manifest without a concrete `Oracle gate` disposition fails
  structurally, and the smallest valid Oracle dossier carries every required
  decision field without raw secrets.
- Oracle output is advisory intake returned to Chatterbox and cannot promote,
  dispatch, review, merge, or direct the Coordinator.
- No current authoritative surface retains planning delegate as a live role or
  Orchestrator and Coordinator as two names for the same delivery role.
- Standalone delivery still has a Coordinator path and Queue may keep
  coordinatorless routine automation plus on-demand recovery.
- Reusable policy contains capability classes rather than DeepSeek, Astra,
  Fable, provider, price, or allowance configuration.
- Migration instructions explicitly preserve all existing agent threads and
  workspaces.

## Stop conditions

Stop if the change would make Oracle a second planning authority, treat model
self-confidence as a gate, send secrets or raw sensitive payloads to an Oracle,
remove standalone delivery, require Queue or one provider, weaken independent
or specialist review, change live Paseo profiles, rewrite historical evidence,
or dispose of an existing thread/workspace.

## Evidence

The operator reports that frontier Chatterbox sessions consume the OpenAI
weekly allowance too quickly. The current doctrine already routes Chatterbox
through a conversational pool and planning delegates through a frontier pool,
but planning delegates overlap the proposed Oracle while Orchestrator mode and
Coordinator name the same delivery function. Queue now performs routine
coordination and creates recovery coordination only when automation cannot
settle an exception.

## Next task

After closeout, return to Chatterbox to configure or pilot local conversational
and Oracle profiles. Consumer refresh is a separate operator decision; no
automatic rollout is approved.
