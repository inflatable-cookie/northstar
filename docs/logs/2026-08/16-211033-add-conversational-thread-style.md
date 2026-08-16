# Add Conversational Thread Style

- Date: 2026-08-16
- Change: make conversational tone a Northstar-wide requirement
- Related spec: `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md`
- Governing contract: `docs/contracts/001-working-rules.md`
- Skill surfaces: `skills/northstar/SKILL.md`, `skills/northstar/references/modes/orchestrator.md`

## Decision

Northstar thread replies should use a natural, human conversational tone while
retaining useful recommendations, trade-offs, and next steps. Structured
outcome/state/validation/next summaries remain available for meaningful
checkpoints, but are not the default shape for every reply.

Orchestrator threads have a stronger requirement: they should be creative,
exploratory, and easy to converse with. The orchestrator asks focused questions,
explores alternatives and edge cases, welcomes tentative ideas, explains
trade-offs, and makes redirection easy without weakening scope, authority, or
evidence boundaries.

## Surfaces changed

- primary Northstar skill and OpenAI default prompt;
- orchestrator mode and orchestrator spec;
- internal writing policy and active-thread reset prompt;
- working-rules contract and delivery-framework doctrine;
- consumer-facing AGENTS/CLAUDE templates and template-bundle copies.

Artifact surfaces such as cards, roadmaps, logs, and contracts remain compact
and high-signal. That compression no longer governs normal thread conversation.

## Validation

- source/install parity passed for `/Users/tom/.agents/skills/northstar`;
- source/install parity passed for `/Users/tom/.hermes/skills/northstar`;
- `diff -qr` matched both installed copies to `skills/northstar/`;
- `git diff --check` passed;
- `effigy qa:docs` passed;
- `effigy doctor` was refreshed after the documentation edits and returned no
  findings.
