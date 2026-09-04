# Economical Orchestrator Coordination

Date: 2026-09-04
Roadmap: `g02.051`
Card: `g02.051/125`
Status: complete; reviewable PR pending

## Result

Implemented spec 036's economical coordinator split across the reusable rule
surfaces. The public orchestrator role keeps its name and all merge-safety
gates; its normal job is now economical coordination: maintain the dependency
frontier, launch every safe ready lane, create and resume parent-attached child
workers and reviewers in separate workspaces, route unresolved product meaning
to operator-facing chatterboxes, promote only operator-confirmed meaning
through a bounded fail-closed projection lane, route substantive exact-head PR
review to independent review children, and verify the coordination gate before
merging.

Decision-ready chatterbox packets: a triage note is decision-ready when it
separates operator-confirmed decisions, recommendations not yet accepted,
evidence and alternatives, unresolved questions, and affected authority
surfaces. Recommendations are never decisions; only explicit operator
confirmation enters a promotion brief, and semantic ambiguity returns to the
operator and the chatterbox.

Independent review children: every worker PR receives one unless the operator
explicitly asks the current thread for a direct review. The reviewer is a
parent-attached child in a dedicated PR-head workspace with finish
notifications enabled, selected from the adequate review pool under the
diversified-routing rule, and receives the PR, canonical refs, and review
oracle — never the worker's private transcript. Its posted provider verdict
names the exact reviewed head. Revisions return to the same worker and the
same reviewer when available; a replacement reviewer starts a fresh complete
review. The coordinator verifies the verdict head, findings, checks, ancestry,
mergeability, and pause state and does not duplicate the full review; stale,
ambiguous, contradictory, or missing review evidence stops merge.

Model posture stays portable: the coordinator's normal route is an economical
coordinator class, review children and chatterboxes select from their own
adequate pools, and frontier effort is an escalation for material
operator-facing discovery, review-oracle design, and residual risk that
settled planning, explicit oracles, tests, and an economical independent
review cannot bound. No local profile, model, price, or allowance entered
reusable policy. Card 126's ten-PR trial remains separate and blocked.

## Changed Surfaces

| Surface | Before | After |
| --- | --- | --- |
| `skills/northstar/references/modes/orchestrator.md` | Orchestrator owns discovery through semantic PR review; projection keeps "frontier orchestrator" framing | Operating posture names economical coordination the default job; `## Independent review children` defines PR-head workspace, parent-attached child launch, notification, identity retention, same-worker/same-reviewer reuse, fresh replacement reviews, and the six-part coordination gate; chatterbox intake adds decision-ready packets and the promotion path; projection section adds the operator-confirmed promotion boundary with a promotion review child; procedure step 11 routes review to the child and step 12 gates merge on the coordination gate; model routing adds the coordinator default, review-child pool, and frontier-escalation conditions; stop conditions add stale/ambiguous evidence and non-attachable reviewer launches |
| `skills/northstar/references/modes/chatterbox.md` | Enough bar required confirmed-vs-tentative separation but named no decision-ready state | Decision-ready definition with the five required separations; still non-authoritative — only operator confirmation routed through the orchestrator promotes |
| `skills/northstar/references/modes/pr-review.md` | Fresh-thread operator review only | Names the review-child launch shape, requires the verdict to name the exact reviewed head, and requires replacement reviewers to start a complete fresh review |
| `skills/northstar/SKILL.md` | Orchestrator outcome listed semantic review as orchestrator-owned | Orchestrator outcome describes coordination, decision-ready packets, review children, and the coordinator gate; chatterbox outcome names decision-ready separation |
| `skills/northstar/references/router.md` | Direct PR review was operator-facing only; orchestrator section implied review ownership | Section 7 routes review children through the same mode; section 8 describes coordination as the normal job |
| `docs/contracts/001-working-rules.md` | Authority split assigned PR review and merge-gate verdicts to the orchestrator thread | Roles table adds review child and decision-ready chatterbox; review-path and planning-path paragraphs define launch shape, reuse, coordination gate, and fail-closed promotion; merge pre-authorization cites an independent verdict naming the exact head; model routing adds the coordinator default and review-child pools |
| `template-bundle/contracts/001-working-rules-template.md` | No review-child doctrine | Adds `### Independent review children`; merge authority, projection, chatterbox, and economical-routing sections carry the split in copy-ready form |
| `bundle-docs/sections/07-delivery-framework-and-autonomy.md` | Frontier effort assigned to the orchestrator by role | New `## Economical orchestrator coordination` section (coordination default, planning path, review path, model posture, trial boundary); merge authority cites the review child; routing section reassigns material review to the lane's reviewer |
| `bundle-docs/protocol-kernel.md` | No canonical home for the coordinator split | Canonical homes table row points at the new doctrine section |
| `bundle-docs/operators/operator-quick-start.md` | "Frontier orchestrator" framing; orchestrator keeps frontier review | Operator paragraphs describe review children, the coordination gate, decision-ready promotion batches, and portable capability classes |
| `docs/architecture/system-architecture.md` | Thread topology and orchestrator ownership included semantic review | Review-child path added to topology; orchestrator ownership narrowed to coordination; chatterbox decision-ready sentence; coordinator route class; two new invariants |
| `docs/architecture/system-inventory.md` | No review child surface | Adds review child surface and Independent review children interface; projection, PR review boundary, chatterbox, and PR review/merge rows updated |
| `docs/specs/026-orchestrator-thread-and-worker-pr-loop.md` | Spec assigned full semantic review to the orchestrator | Header note records that spec 036 narrows the normal orchestrator job while this spec stays the transport/handoff/worker-loop authority |
| `docs/specs/036-economical-orchestrator-coordination.md` | Status planned | Status active; card 125 implemented, card 126 trial pending |
| `docs/contracts/contract-index.md` | 001 boundary list without review children | Register names the independent-review-child boundary |
| Front doors | Spec 036 planned, card 125 ready | `docs/README.md`, `docs/roadmaps/README.md`, `docs/roadmaps/generation-index.md`, `docs/roadmaps/g02/README.md` record implementation, PR-open state, and the still-blocked trial; `docs/logs/README.md` carries this log |
| Card 125 / milestone 051 / handoff | ready / planned / ready-to-launch | implemented / card 125 implemented PR open / implemented; reviewable PR open; card 126 untouched and blocked |

## Oracle Review Evidence

Ten rows from the spec 036 review oracle. Structural rows map to deterministic
checks; semantic rows are exact-head review evidence for the originating
orchestrator.

| Invariant | Smallest adversarial counterexample | Expected response | Required proof |
| --- | --- | --- | --- |
| Coordination is the default orchestrator job. | Orchestrator repeats full planning or semantic review for a settled lane. | Modes, contract, doctrine, and architecture route work to chatterbox/projection/reviewer and retain only the gate. | Exact-head role-boundary review of this PR; `check:model-routing` proves the routing contract wording on the touched surfaces. |
| Recommendations are not decisions. | A chatterbox recommendation is promoted without operator confirmation. | Chatterbox mode, working rules, doctrine, and orchestrator mode stop promotion before canonical mutation without explicit operator confirmation. | Exact-head planning-path review. |
| Promotion is mechanical. | Projection must choose between two plausible product meanings. | Projection stops on semantic ambiguity and returns the question to the operator and chatterbox; never chooses. | Exact-head projection handoff and stop-condition review. |
| Review is independent. | Worker narrative is treated as acceptance, or the reviewer edits the branch. | Orchestrator mode, pr-review mode, working rules, and doctrine require a separate provider verdict and preserve branch ownership. | Exact-head review-mode and orchestrator-flow review. |
| Review head is exact. | Accepted verdict names an older SHA. | Verdict must name the exact reviewed head; stale evidence stops merge; changed head requires re-review. | Exact-head merge-gate review of this PR. |
| Parentage survives workspace isolation. | Reviewer is launched as a detached root thread. | Orchestrator mode and working rules reject detached root/schedule/CLI launches and require a parent-attached child in the dedicated PR-head workspace with finish notifications. | Exact-head Paseo launch-shape review. |
| Economical routes are normal. | Coordinator or ordinary reviewer requires a frontier model by role name alone. | Coordinator default is the economical coordinator class; review children select from the adequate pool; frontier is reserved for residual unbounded risk; `check:model-routing` keeps local names out of the payload. | Model-posture review plus `check:model-routing` PASS. |
| Merge safety is unchanged. | Coordinator merges with missing checks, unresolved findings, or ambiguous state. | The six-part coordination gate is mandatory in modes, contract, doctrine, and architecture; ambiguous/contradictory/missing/stale evidence stops merge. | Exact-head merge-gate review. |
| Failure stays lane-local. | One provider refusal halts unrelated ready work. | Parallel-scheduling doctrine, contract, and template keep provider/profile failures lane-local; unchanged by this batch. | Structural: doctrine 07 and template wording unchanged in that respect; `check:model-routing` failure-isolation row PASS. |
| Trial does not rewrite policy by anecdote. | One successful cheap review is treated as permanent proof. | Doctrine section and spec 036 record the separate ten-PR cohort; card 126 stays blocked and unexecuted. | Structural: card 126 state verified in this diff. |

## Review Remediation

Exact-head review of `2cd1bcb` found four blocking findings; all were repaired
on this branch:

1. **Coordinator self-planning removed (`execution-miss`):** orchestrator mode
   no longer opens as the conversational planning/review owner, teaches
   creative exploration, or runs question-led discovery/promotion/runway
   compilation in procedure steps 3-5. Material discovery now routes to
   chatterbox threads and operator confirmation; only explicitly allowed small
   operational clarifications stay local. SKILL activation, the stronger
   conversation-style rule, router section 8, the working-rules compression
   rule, doctrine 07, the style policy (live and copy-ready), and the setup
   repo-contract guidance no longer instruct a coordinator to plan.
2. **Promotion reached the review/merge topology (`execution-miss`):**
   operator-confirmed canonical promotion is now a bounded
   branch/worktree/PR lane — exact brief, bounded projection worker, fail-
   closed ambiguity, independent review child on the PR head, coordinator
   merge gate — across orchestrator mode, working rules, doctrine 07, the
   copy-ready template, spec 026, architecture, and inventory. The
   same-checkout subagent remains only for genuinely non-semantic mechanical
   edits with orchestrator full-diff review and no review-child claims.
3. **Concrete launch shape and provider-neutral fallback (`execution-miss`):**
   Paseo review launch now names `create_workspace` with `isolation: worktree`
   and `mode: checkout-pr` plus PR number, requires verifying the workspace
   `HEAD` equals the exact PR head SHA before agent-scoped child creation
   with notifications, and adds the manual fallback — a compact direct-review
   launch request (PR URL, canonical refs, review oracle) for an
   operator-started independent reviewer without pretending parentage exists.
   The exact-head verdict gate holds in both routes (orchestrator mode section
   and procedure step 11).
4. **Live authority reconciled (`integration-drift`):** spec 026's target
   operating model, review paragraph, roles table (now with a Review child
   row), and projection scoping; inventory's orchestrator/projection rows and
   a new promotion-lane interface; template delegation/projection/routing
   bullets; doctrine 07 delegation/projection/style sections; quick-start
   mode choice, parallel, and delegate paragraphs; delegate and worker handoff
   templates; and the handoff contract no longer offer the superseded
   ownership model. Historical logs, closed roadmap evidence, and research
   memos are untouched.

### Round 2 (exact head `898d7f6`)

5. **Continuation restores coordination, not the planner (`execution-miss`):**
   the internal continuation marker is now
   `orchestrator_mode: economical-coordination` with no compatibility alias,
   across orchestrator mode, SKILL, router, handoff contract, working rules,
   doctrine 07, the copy-ready template, and spec 026. The continuation
   profile pool now selects for economical coordination — runway state
   tracking, dispatch, revision routing, operator communication, and
   merge-gate verification — instead of planning and review. The
   `check:command-skills` machine contract that pins the settled router
   marker was updated to the new value.
6. **Coordinator triage handling is intake/routing only (`execution-miss`):**
   triage checkpoints keep, route, or flag notes; material promotion and
   removal happen only through the operator-confirmed promotion lane, with
   genuinely administrative cleanup (duplicate or empty notes) handled
   directly. Working-rules delegate closeout assigns triage removal to the
   promotion lane as the brief names.
7. **Delegate closeout uses review child plus confirmation (`integration-drift`):**
   spec 026's planning-delegate closeout and the discovery-delegate template
   now route the packet PR through an independent review child, gate the
   merge on the verdict naming the exact head, and make post-merge promotion
   an operator-confirmed bounded promotion PR lane instead of coordinator
   reconciliation and canonical-home selection. The `planning-promotion`
   state description matches.

### Round 3 (exact head `329eefa`)

8. **Lane ownership wording reconciled (`integration-drift`):** inventory's
   continuation row now transfers a coordination lane and its interface rows
   define Orchestrator coordination (operator-confirmed intent precedes
   promotion/ready cards) and delegate closeout via review child plus
   operator-confirmed promotion; spec 026's continuation passes a
   coordination lane; architecture's transfer sentence, planning-delegate
   invariant, and merge-authority invariant route review through the
   independent review child and promotion through the operator-confirmed
   lane; the handoff contract's delegate lifecycle is the independent-
   review, coordinator-gated merge, and operator-confirmed promotion flow.
   Live sweep for equivalent wording is clean; historical evidence
   untouched.
9. **Drift repair routes through confirmation (`execution-miss`):** procedure
   step 2 no longer orders the coordinator to repair planning state. Drifted
   posture or missing coverage routes material planning repair through a
   chatterbox and the operator-confirmed promotion lane; only non-semantic
   administrative corrections (renames, link fixes, stale status text) are
   direct; no worker launches while drift still governs its lane. This is
   the exact-head evidence that the drift path cannot be read as restoring
   coordinator self-planning: steps 2-5 together leave the coordinator no
   direct semantic planning edits in any posture.

## Validation

- `effigy check:model-routing` — PASS (ten milestone 047 oracle rows)
- `effigy check:repo-contract` — PASS
- `effigy check:command-skills` — PASS (8 adapters, 428 chars)
- `effigy check:skill-install skills/northstar` — PASS (113 files)
- `effigy qa:docs` — PASS (exit 0)
- `effigy validate` — PASS (exit 0; with `effigy qa:docs` this is the full `effigy qa` board)
- `git diff --check` — clean

## Next Task

PR 32 was accepted at exact head `dd09b741` after three review revisions and
merged as `61d4cc2`. The installed Northstar skill was refreshed from the
tracked merge archive; all 113 files match byte-for-byte. The source-checkout
parity task still sees ignored `.DS_Store` and Rust `target/` artifacts in the
primary checkout, so tracked-archive parity is the truthful install result.
Paseo exposes the operator-configured `Luna coordinator` profile.

Publish card 126's observation packet and stop date. The cohort remains
blocked until then.
