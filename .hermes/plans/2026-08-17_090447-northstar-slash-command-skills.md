# Northstar Slash-Command Skills Implementation Plan

> **For Hermes:** Use this plan task-by-task; keep the canonical Northstar router and mode files as the only procedure authority.

**Goal:** Publish a small set of explicit slash-command entrypoints, including standalone `/come-again` and specific `/northstar-*` routes, that select canonical routes without duplicating the router, inflating the always-loaded skill index, or loading unrelated modes.

**Architecture:** Keep one published Northstar skill artifact at `skills/northstar/`. Add thin nested command adapters under `skills/northstar/commands/<command>/SKILL.md`. Hermes recursively discovers `SKILL.md` files outside support directories, so these adapters become native slash skills while remaining inside the existing parity/distribution boundary. Each adapter loads the canonical Northstar router first and exactly one mode file second; it contains no copied mode procedure.

**Context budget:** Hermes truncates each visible skill description to 60 characters and loads the full skill body only when a slash skill is invoked. The six command descriptions plus the main description remain within the measured command-surface budget, while the full router/mode content is paid only for the selected command.

---

## Current assessment

Northstar currently has one natural-language front door and one canonical router:

- `skills/northstar/SKILL.md`
- `skills/northstar/references/router.md`
- `skills/northstar/references/modes/*.md`

Hermes already supports the required mechanism. A directory containing a nested
`SKILL.md` is discovered by `agent.skill_commands`; its normalized frontmatter
name becomes a slash command. The invoked skill body is injected only for that
turn. `/reload-skills` refreshes the command map without invalidating the prompt
cache.

This means no Hermes core change, new model tool, or custom command registry is
needed.

## Scope correction: readiness is not long-horizon planning

The existing `planning-readiness-review.md` route is useful but deliberately
small. It audits the planning that already exists, identifies the first material
gap, and routes to one next mode. It does not perform the larger-scale work that
made Matt Pocock's Wayfinder distinctive.

Northstar already has ingredients for that larger scale — vision, strategic
constraints, architecture, generation runways, and a 20-to-50-milestone horizon —
but no single route currently synthesizes them through a question-led,
long-horizon planning process.

Do not rename the readiness audit as if it were that capability. Publish
`/northstar-readiness-review` as a compact utility, and shape a separate iconic
route before publishing its slash adapter.

### Long-horizon route to design first

Working name: **Atlas** (`/northstar-atlas`). The name is provisional; the
contract matters more than the label.

Atlas should:

- establish or challenge the project's long-horizon destination and strategic
  constraints;
- inspect the relationship between vision, architecture, contracts, active
  generation runway, and the portfolio of meaningful roadmap horizons;
- ask breadth-first strategy questions rather than implementation questions;
- identify strategic bets, domains, dependencies, sequencing, non-goals,
  accepted uncertainty, and rollover conditions;
- synthesize a durable multi-horizon runway, not merely report documentation
  gaps;
- promote durable outcomes through vision, architecture, contracts, specs, and
  roadmaps in that order;
- use readiness review as a subordinate health check, not as the main output;
- remain plan-only and operator-owned: no production code, workers, worktrees,
  or execution authority.

The Atlas contract must be shaped and validated before its slash adapter is
published. Otherwise the first wave would expose a memorable name for a route
that does not yet exist.

### First wave — implement after the route contract is settled

| Slash skill | Canonical route | Why it earns an explicit command | Cost / boundary |
| --- | --- | --- | --- |
| `/come-again` | `pre-execution-discovery.md` → Reframe route | Standalone, frequent, tiny, highly predictable, and useful when natural-language intent is unclear | Read-only; lowest context and side-effect risk |
| `/northstar-agents-review` | `agent-instruction-review.md` | A distinct, repeatable audit with a clear target and output contract | Read-only docs audit; no production code or worker setup |
| `/northstar-readiness-review` | `planning-readiness-review.md` | A useful planning-health gate, explicitly smaller than Atlas | Read-only; routes onward but does not authorize execution |
| `/northstar-architecture-refocus` | `architecture-refocus.md` | Named bounded architecture review; explicit scope helps prevent a broad codebase scan | Read-only; requires one subsystem, seam, lane, or package |
| `/northstar-refresh` | `project-refresh.md` | Broad maintenance pass is materially different from a narrow review | Read-only-first; bounded docs repair only where the mode allows it |
| `/northstar-atlas` | `atlas.md` | The genuinely iconic, strategic planning entrypoint | Plan-only; internal scale validation passed, broader validation remains |

Use the `northstar-` prefix for Northstar-specific commands. Keep `/come-again` standalone because the capability is generic, while retaining natural-language triggers in the main skill as fallback.

### Second wave — consider after first-wave evidence

| Slash skill | Reason to defer |
| --- | --- |
| `/northstar-discover` | Useful for readiness maps, intent rounds, project language, prototypes, and questionnaires, but it is an umbrella over several distinct routes and may need a small argument contract first |
| `/northstar-handoff` | Valuable because handoff writes a durable artifact, but it must remain clearly separate from Hermes core `/handoff <platform>` and needs explicit file/closeout tests |
| `/northstar-orchestrator` | Explicitly naming the worker/PR loop could prevent accidental escalation, but it carries the highest side-effect and authority risk; design it only after the adapter pattern is proven |

### Do not add initially

Do not create slash adapters for `research`, `recovery`, `normalize`, `plan`,
`contracts`, `spec`, or `roadmap` yet. These are broad planning routes, have
multiple internal submodes, or overlap heavily with natural-language routing.
Adding them now would increase slash completion noise without providing a stable
narrow contract. Reassess them after first-wave usage shows a recurring ambiguity.

---

## Implementation plan

### Task 1: Establish the command-adapter contract

**Files:**
- Modify: `bundle-docs/skills/README.md`
- Modify: `scripts/lib/northstar-repo-contract-data.rhai`
- Modify: `skills/northstar/SKILL.md`
- Modify: `skills/northstar/references/router.md`

Define these invariants:

1. `skills/northstar/` remains the one published Northstar artifact.
2. Nested command adapters are public slash entrypoints, not independent
   planning authorities.
3. Every adapter must load `references/router.md` first and one exact mode file
   second.
4. Adapters must not copy mode procedures, roadmap state, current project facts,
   or user-specific examples.
5. Adapter bodies should target 20–35 lines and descriptions must stay within
   Hermes's 60-character prompt-index budget.
6. A bare command must use the current repository/message context; arguments are
   passed as the user instruction and must not be silently interpreted as
   authorization for execution.

Shorten the main `northstar` frontmatter description to a compact capability
statement under 60 characters; keep detailed natural-language triggers in the
body/router rather than paying for them in the visible skill index.

### Task 2: Shape the long-horizon Atlas route before publishing it

**Create:** `skills/northstar/references/modes/atlas.md`

**Modify:**
- `skills/northstar/SKILL.md`
- `skills/northstar/references/router.md`
- `bundle-docs/skills/README.md`
- the active discovery spec/roadmap surfaces

Define Atlas as a genuinely long-horizon, question-led planning mode rather than
another review. Its contract must cover:

- destination and strategic-constraint discovery;
- vision-to-architecture-to-contract alignment;
- multiple meaningful horizons and generation runway synthesis;
- strategic bets, dependencies, sequencing, non-goals, and accepted uncertainty;
- breadth-first operator questions;
- durable promotion into vision, architecture, contracts, specs, and roadmaps;
- readiness review as a subordinate diagnostic;
- a strict plan-only boundary.

Do not add `/northstar-atlas` until the mode can produce that outcome from a real
large-scale planning scenario. The Northstar scenario now demonstrates that
contract provisionally; a non-Northstar scenario and operator confirmation remain
open validation work.

### Task 3: Add the thin command adapters

**Create:**
- `skills/northstar/commands/come-again/SKILL.md`
- `skills/northstar/commands/northstar-agents-review/SKILL.md`
- `skills/northstar/commands/northstar-readiness-review/SKILL.md`
- `skills/northstar/commands/northstar-architecture-refocus/SKILL.md`
- `skills/northstar/commands/northstar-refresh/SKILL.md`
- `skills/northstar/commands/northstar-atlas/SKILL.md` after the provisional Atlas
  scenario passes

Each adapter should contain only:

- valid frontmatter with a short description and the `northstar` relationship;
- one sentence explaining that it is an explicit Northstar entrypoint;
- a fixed procedure:
  1. load `northstar`'s `references/router.md` with `skill_view`;
  2. classify the command to the named route;
  3. load the one named mode file with `skill_view`;
  4. follow that mode and its target-repository authority rules;
  5. do not load unrelated modes or duplicate the router;
- the command-specific scope/argument rule;
- a short non-goals boundary.

Suggested descriptions, all within the 60-character budget:

- `Reframe a Northstar request without changing scope.`
- `Audit AGENTS.md and CLAUDE.md instruction surfaces.`
- `Review planning readiness before continuing work.`
- `Review one codebase area for architecture improvements.`
- `Refresh a project's Northstar planning and docs state.`
- `Shape long-horizon Northstar planning and strategic runway.`

The adapter should refer to canonical files by skill-relative paths, not absolute
machine paths. It should not link to `bundle-docs/` or target-repository files,
because those may not exist in consumer installations.

### Task 4: Add deterministic command-surface validation

**Create:** `scripts/check-northstar-command-skills.rhai`

**Modify:** `effigy.toml`

The checker should fail closed on:

- missing expected adapter directories/files;
- invalid or duplicate frontmatter names;
- names that do not normalize to the expected `/northstar-*` command;
- descriptions longer than 60 characters;
- an adapter missing `references/router.md` or its exact mode reference;
- copied procedure markers that indicate a mode body was inlined;
- adapters that mention worker/worktree/production mutation outside their
  explicitly bounded command contract.

Keep the checker static and cheap. It should not invoke a model or inspect a
consumer repository.

Add the command to the repo contract/QA path as one focused check, rather than
adding separate checks for each adapter.

### Task 5: Add source and runtime-facing tests

The focused `scripts/check-northstar-command-skills.rhai` checker doubles as the
deterministic source test; no model or consumer repository is required.

Test the source contract:

- all six command names are present now that the Atlas mode contract passed;
- each enabled command maps to a unique mode file;
- no adapter contains a second router or a duplicated mode heading;
- all descriptions fit the prompt budget.

Add a documented local E2E verification path using the installed Hermes runtime:

1. update or mirror the Northstar artifact into a temporary/profile skill home;
2. run `/reload-skills`;
3. verify the six commands — `/come-again`,
   `/northstar-agents-review`, `/northstar-readiness-review`,
   `/northstar-architecture-refocus`, `/northstar-refresh`, and
   `/northstar-atlas` — appear in slash completion;
4. invoke one command with an inline instruction and verify the user instruction
   is preserved while only the adapter and selected mode are loaded;
5. confirm the main prompt cache is not rebuilt merely by `/reload-skills`.

Do not make the Northstar repository depend on Hermes internals for its normal
QA; keep the E2E check as a documented integration verification and use the
static checker for portable CI.

### Task 6: Update distribution and operator documentation

**Modify:**
- `bundle-docs/skills/README.md`
- `bundle-docs/operators/operator-quick-start.md`
- `scripts/README.md`
- `docs/architecture/system-inventory.md`
- `docs/specs/028-agent-instruction-surface-optimization.md` only if the new
  visible command-index footprint needs measurement

Document that:

- the main `northstar` skill remains the canonical planning authority;
- the six slash adapters are thin explicit entrypoints inside that artifact;
- published skill updates distribute adapters with the main artifact;
- local development must mirror/check the whole `skills/northstar/` tree;
- a new session or `/reload-skills` is required before command discovery updates;
- natural-language routing remains supported and is not deprecated.

### Task 7: Validate distribution and close out

Run, independently and capture exact results:

```text
effigy qa
effigy qa:docs
effigy check:repo-contract
effigy check:command-skills
effigy check:skill-install /path/to/installed/northstar
effigy check:agent-instructions
effigy doctor
git diff --check
```

Refresh both local installed copies only after source validation:

```text
rsync -a --delete skills/northstar/ /Users/tom/.agents/skills/northstar/
rsync -a --delete skills/northstar/ /Users/tom/.hermes/skills/northstar/
```

Then rerun both parity checks, record the command-surface validation in a dated
log under `docs/logs/2026-08/`, commit, push, and verify `HEAD == origin/main`
with a clean tree.

---

## Risks and mitigations

- **Slash-index noise:** limit the first wave to six commands, keep descriptions
  under 60 characters, and measure the visible index before/after.
- **Procedure drift:** adapters contain only fixed route references; the router
  and mode files remain the sole authority.
- **Distribution mismatch:** keep adapters under `skills/northstar/` so the
  existing artifact parity check covers them; add an explicit command-surface
  checker as a second guard.
- **Core-command collision:** use the `northstar-` prefix and verify Hermes's
  core command registry does not already claim each slug.
- **Accidental escalation:** keep read-only/readiness/architecture boundaries in
  the selected mode; defer orchestrator and handoff adapters until explicit
  argument and authority tests exist.
- **Current-session cache confusion:** document `/reload-skills` and a new
  session requirement; do not mutate the cached system prompt from the adapter.
- **Nested-skill discoverability change:** prove that Hermes's recursive scanner
  discovers `commands/` while still excluding `references/`, `assets/`,
  `templates/`, and `scripts/` as support directories.

## Open decisions for implementation

1. Use `/northstar-readiness-review` as the canonical readiness command. It
   says exactly what the route does, aligns with the existing planning-readiness
   mode, and avoids the unrelated `wayfinder` association. Retire the existing
   previously proposed `northstar wayfinder` alias; retain
   `northstar planning readiness review` as the natural-language trigger.
2. Should adapters use `related_skills: [northstar]` in frontmatter? Recommendation:
   yes, if the runtime resolves the nested main skill reliably; otherwise omit
   the optional relation rather than creating a broken catalog reference.
3. Should `/northstar-discover` join the first wave? Recommendation: no; wait until
   the distinct discovery subroutes have a clearer argument contract.

## Success criteria
- Five utility Northstar slash commands appear in Hermes completion after
  `/reload-skills`; Atlas appears only when its long-horizon contract is ready.
- Each command loads only its adapter, the canonical router, and one selected
  mode; no mode procedure is duplicated.
- Natural-language `$northstar` routing still works unchanged.
- The always-loaded skill index grows only by short descriptions, not full mode
  bodies.
- Source and both installed copies remain parity-clean.
- No production code, worker, worktree, or consumer dogfood activity is started
  by this change.
