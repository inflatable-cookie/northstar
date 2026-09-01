---
name: northstar
description: Northstar planning, PR review, and code QA.
---

# Northstar

Single entry for the Northstar planning and docs system. **Do not** load every
mode up front.

## First step (required)

Open [`references/router.md`](./references/router.md), classify intent, then
open **one** [`references/modes/`](./references/modes/) file and follow it.

| Mode | When |
| --- | --- |
| TypeScript/Svelte explicit audit | User explicitly requests a TypeScript or Svelte quality audit, no-slop pass, or audit-and-fix action |
| Rust explicit audit | User explicitly requests a Rust quality audit, no-slop pass, or audit-and-fix action |
| Handoff | User explicitly asks for a continuation brief / fresh thread |
| Project refresh | User asks for `northstar refresh` or `northstar project refresh` to bring an existing project up to date |
| Architecture refocus | User asks for `northstar architecture refocus` or a bounded codebase architecture improvement review |
| Reframe | User asks for `northstar reframe` or a clearer restatement in project language |
| Planning readiness review | User asks for `northstar planning readiness review` on an existing project |
| Atlas | User asks for `northstar atlas` or discovery-first long-horizon direction |
| Agent instruction review | User asks for a `northstar AGENTS file review`, or to review/optimize `AGENTS.md`/`CLAUDE.md` |
| Rust everyday authoring | Northstar is requested for ordinary Rust work, or an applicable repository instruction already activates Rust quality |
| Pre-execution discovery | Readiness mapping, intent rounds, project language, decision prototypes, questionnaires, or reframe |
| PR review | User asks a thread to review an existing PR |
| Orchestrator | User wants question-led planning plus a separate worker/PR loop, or a committed orchestrator-continuation handoff |
| Docs cleanup | User wants `/docs` files and folders inspected and reworked to fit Northstar |
| Normalize docs | Bootstrap, migrate, or keep docs spine healthy over time |
| Research | Evidence → architecture/contracts |
| Recovery | Drifted or changed planning state |
| Planning | Default: plan, promote, compile roadmaps (sub-modes in router) |

Runtime authority comes from the target repo's `AGENTS.md` and local contracts.
When the target is the Northstar source repo, also read
`bundle-docs/protocol-kernel.md`. Its absence is normal in consumer repos and
is not a contract gap by itself.

Worker mode is explicit, not a default startup step. It is active only when an
orchestrator dispatches a thread with a handoff whose frontmatter declares
`handoff_mode: worker-pr-loop`, `worker_mode: implementation`, and
`dispatch_authority: orchestrator`. Tell the operator that handoff's **absolute
path**; that path is the only dispatch artifact. A repository-relative path is
valid only after the current root is already the owning repository. Normal
planning, review, discovery, readiness, and orchestrator threads do not run a
worktree probe or inspect `.agents.local.env` merely because worker support
exists. Once worker mode is activated, follow the router's lightweight
four-command worktree fast path, verify the committed handoff in the selected
`HEAD` before mutating anything, then verify any sibling worktree links the
tracked handoff lists in the worktree container directory. A launcher lifecycle
creates them before project setup; only the manual fallback worker creates an
absent link after preflight.

A planning delegate is distinct from worker mode. Its handoff declares
`handoff_mode: planning-delegate` and
`planning_mode: conversational-discovery`; it follows that handoff's isolated
planning-worktree preflight, writes only named triage/research paths, and cannot
implement or promote.

A fresh orchestrator continuation is distinct from both. Its handoff declares
`handoff_mode: orchestrator-continuation`,
`orchestrator_mode: planning-and-review`, and
`dispatch_authority: orchestrator`. The successor enters normal orchestrator
mode from that absolute path and does not run worker or planning-delegate
preflight. The source yields the transferred lane after pushed dispatch.

## Outcomes by mode

- **Planning:** coherent architecture/contracts/roadmaps; no invented system
  behavior; ready cards only when rubric satisfied.
- **TypeScript/Svelte explicit audit:** package- and overlay-resolved scope,
  deterministic finding-first records, authority-bounded repair, dirty-state
  preservation, and repository-owned tool evidence. Ordinary coding never
  activates it.
- **Rust explicit audit:** resolved worktree or repository scope, deterministic
  finding-first records, authority-bounded repair waves, preservation proof,
  and repository-native validation. It never activates from ordinary coding.
- **Planning readiness review:** read-only verdict on whether an existing
  project's planning is incomplete, drifted, materially ambiguous, or coherent,
  with one routed next step.
- **Project refresh:** all-facets Northstar audit with bounded documentation
  repair and one routed next step; no worker/worktree startup.
- **Architecture refocus:** bounded, evidence-led architecture improvement
  candidates with explicit promotion routes; no production-code edits.
- **Consumer evidence:** live consumer dogfooding is operator-owned outside
  Northstar's execution loop; Northstar consumes feedback supplied in the
  conversation and does not select, dispatch, or manage consumer runs.
- **Reframe:** a concise, read-only restatement of the current request that
  preserves uncertainty and authority; it does not create a plan or decision.
- **Atlas:** discovery-first, operator-guided, plan-only long-horizon planning
  that connects vision, architecture, contracts, generation runway, and
  strategic horizons; it does not invent the project's direction or authorize
  execution.
- **Pre-execution discovery:** frontier-based intent rounds and bounded
  project-language, prototype, and questionnaire routes; no execution authority.
- **PR review:** independent review of an existing PR with the verdict and every
  required change posted on the provider review surface before chat summary.
- **Research:** promoted decisions in architecture/contracts, not stranded memos.
- **Rust everyday authoring:** agent-installed activation plus strict,
  profile-resolved guidance for the current Rust task and changed tranche; no
  wider audit authority.
- **Recovery:** trustworthy planning surfaces and canonical refs restored.
- **Normalize:** baseline or strict spine installed/maintained; Effigy-first QA.
- **Orchestrator:** question-led planning, parallel-first dispatch of the whole
  safe ready dependency frontier without a global thread budget, lane-local
  provider/profile routing, diversified economical worker routing (adequate
  pool, cheapest adequate tier, recent-use rotation) with frontier workers
  only when both escalation axes hold, optional
  operator-facing frontier planning delegates with orchestrator-owned promotion,
  optional fresh-orchestrator continuation through a pushed seven-section
  handoff and a separate local workspace with `Orchestrator=true`,
  one pushed worker handoff under `docs/handoffs/` per launched lane, optional
  fast/low-cost mechanical documentation projection under frontier semantic
  review, bounded PR review/revision, and accepted-review plus check-gated merge
  without a second operator prompt.
- **Handoff:** a human-friendly seven-section file under `docs/handoffs/`, with
  an absolute path returned to the operator; not a substitute for log/roadmap
  closeout.

## Conversation style

Use a natural, human conversational tone across all Northstar threads. Keep useful
recommendations, trade-offs, and next steps, but do not turn ordinary replies
into dry status reports or bureaucratic protocol recitations.

- be clear, warm, and easy to respond to;
- keep the connective language that makes reasoning understandable;
- stay concise and high-signal without becoming telegraphic;
- use summaries and outcome/state/next structure when they help, not by reflex;
- preserve room for curiosity, tentative ideas, and productive exploration.

Orchestrator threads have a stronger version of this rule: act as a creative,
exploratory thinking partner as well as a planner and reviewer. Ask focused
questions, explore alternatives and edge cases, explain why a question matters,
offer recommendations without pretending they are decisions, and make it easy
for the operator to think aloud and redirect the conversation. Keep the planning
and authority boundaries firm without making the conversation feel like a
workflow form.

When an orchestrator or refresh conversation surfaces a useful observation,
idea, plan, or question that will not be resolved immediately, capture it in a
timestamped `docs/triage/` note before following one branch deeply. Use natural
topic shifts and checkpoints to keep the record current; do not rely on the
final summary to reconstruct every discarded thread.


## Papercuts loop (required during execution)

- Locate the root of the repository that owns the work and read
  `PAPERCUTS.md` if it exists.
- When a small, solvable execution hurdle appears, append a terse entry to that
  file before continuing. If it is missing, create it without asking the
  operator.
- Capture the friction, impact, plausible fix, and affected surface. Do not
  stop the current task, wait for permission, or fix the papercut unless that
  fix is already in scope.
- Do not log ordinary one-off failures, external blockers, sensitive data, or
  duplicate open entries. Papercuts are observations for later triage, not an
  automatic backlog or roadmap commitment.

The starter file is available at `assets/templates/PAPERCUTS.md`. Seed it on
adopt/upgrade before exact-SHA / clean-tree release prep; do not add it during
tag closeout after a green pinned SHA.

## Refactoring posture

When work touches code or automation: no pre-1.0 compat shims; ask the operator
on breaking changes; from v1.0 preserve expected stable behavior. Follow the
target repo's `docs/contracts/001-working-rules.md` when present. In the
Northstar source repo, expanded doctrine lives at
`bundle-docs/sections/07-delivery-framework-and-autonomy.md`.

## Assets

- Setup/templates: [`assets/templates/`](./assets/templates/)
- Optional Paseo project adapter: [`references/setup/paseo-project.md`](./references/setup/paseo-project.md)
- Claude Code bridge: `assets/templates/CLAUDE.md.template` must reference
  `@AGENTS.md`; add Claude-only guidance there only when it cannot live in the
  shared contract.
- Papercuts starter: `assets/templates/PAPERCUTS.md`
- Handoff template: [`assets/templates/northstar-handoff.md.template`](./assets/templates/northstar-handoff.md.template)
- Orchestrator worker handoff extension: [`assets/templates/northstar-orchestrator-run.md.template`](./assets/templates/northstar-orchestrator-run.md.template)
- Orchestrator planning-delegate handoff: [`assets/templates/northstar-discovery-delegate.md.template`](./assets/templates/northstar-discovery-delegate.md.template)
- Orchestrator documentation projection brief: [`assets/templates/northstar-documentation-projection.md.template`](./assets/templates/northstar-documentation-projection.md.template)
- Handoff directory: `docs/handoffs/`
- Triage directory: `docs/triage/`
- Handoff contract: [`references/handoff-contract.md`](./references/handoff-contract.md)

## Do not

- Skip the router.
- Use handoff mode for compaction-only or ordinary `continue`.
- Start roadmap execution to discover missing contracts.
- Mirror Effigy tasks into `package.json` scripts.
- Alias `tasks.health` to `qa` (doctor orientation must stay cheap; full
  validation is `effigy qa` — see `references/setup/repo-contract.md`).
