# Shared knowledge retrieval pilot

Status: open; pilot evidence complete, next implementation ownership undecided
Owner: Chatterbox and operator
Created: 2026-09-05

## Confirmed direction

The operator prioritizes knowledge sharing over dependency/artifact caching and
approved a small retrieval pilot. Keep project authority in its owning Git
repository; centralize discovery, not competing copies of decisions. No hosted
knowledge service, vector database, package registry, runtime implementation,
or cross-repository documentation rewrite is approved by this note.

Default pilot repositories are Northstar, Effigy, and Underlay, offered to the
operator because they share tooling and documentation dependencies. Scope is
explicit local documentation/skill paths, not the whole projects directory,
conversation histories, credentials, dependencies, or generated artifacts.

## Existing capability and boundary

Effigy already owns repository-local exact-section retrieval. Its contract 041
and guide 079 specify provenance, bounded output, repository-defined authority
and currentness, and a rebuildable shared graph. No repository profile means
unknown currentness and zero authority; a central caller must not invent them.
A query does not generate an answer. Cross-repository discovery must preserve
that contract, and authority weights from different repositories are not a
shared ranking scale.

Sources: Effigy `docs/contracts/041-documentation-graph-profile-contract.md`,
`docs/guides/079-documentation-graph-profiles-and-context.md`, and
`docs/architecture/024-repository-defined-documentation-graph.md`.

The first orientation probe, before the case set below, ran
`effigy docs context "Which authority governs cross-project documentation retrieval and knowledge sharing?" --max-sections 4`
in Northstar. It failed with `effigy.graph.timeout.v1` at the default 120000 ms
refresh budget. Health reported a 207888384-byte graph and refresh in progress.
This is observed workspace behavior, not evidence that a new service is needed
or that the repository's tracked content is large.

## Frozen five-case reference set

Frozen before the targeted query probes. Cases come from recorded friction;
not every incident was solely a retrieval failure, and improved search cannot
repair a missing source or enforce execution behavior.

| ID | Recorded incident | User-shaped question | Expected evidence and rejection |
| --- | --- | --- | --- |
| K1 | Northstar PAPERCUTS, 2026-08-17 harness path mismatch: 59 tool calls and duplicate checkout | Should I reuse this launcher-provided worktree? | Northstar router's Worker startup fast path and worker template: clean registered non-main checkout is authoritative; reject placeholder-path matching as a reason to create another checkout. |
| K2 | Northstar PAPERCUTS, 2026-08-17 installed-skill AGENTS audit required searching the source checkout | Where is the AGENTS review workflow? | Northstar router's Agent instruction review route, agent-instruction-review mode, and contract 003; reject treating worker startup as universal normal-mode audit preflight. |
| K3 | Underlay PAPERCUTS, 2026-08-26 missing batch-card template, resolved 2026-08-28 | Where does a consumer get the batch-card template? | Northstar compile-roadmaps mode and skill-shipped assets/templates/docs/specs/templates/batch-card-template.md; Underlay's resolved incident explains why no consumer-local copy is required. Missing source must be reported, never reconstructed as if authoritative. |
| K4 | Underlay PAPERCUTS, 2026-08-26 stale task JSON path; Northstar PAPERCUTS, 2026-08-28 stale vendored tasks path | Which JSON field lists Effigy tasks? | Effigy guide 026's task payload and skill json-envelope reference: result.catalog_tasks[].task; preserve installed/source version identity and reject stale payload examples. |
| K5 | Underlay PAPERCUTS, 2026-08-27 execute omitted expected GitHub Release, resolved 2026-08-28 | Does release execute publish a GitHub Release? | Effigy guide 051 defines commit/tag/push; Underlay's local release guidance and incident describe its publication obligation. Do not turn Effigy's binary-only workflow into a universal consumer command. No release command is executed in this pilot. |

These are retrieval/reuse candidates with observed historical costs, not five
newly measured repetitions or proof that every historical defect still exists.

## Measurement protocol

1. Record tool version and each repository HEAD. Sources may be read from the
   working tree; identify dirty/untracked candidate sources separately from
   committed evidence. Never label working-tree excerpts as exact commit bytes.
2. Check the existing retrieval route once per repository with one relevant
   frozen query, at most three sections/6000 bytes, a 5000 ms graph budget, and
   a 10-second outer process limit. A failed route stops that repository's query
   round; do not spend five cold rebuilds to repeat one failure.
3. Recover the reference sources with explicit text search and reads. This
   establishes answerability; it is not a blind retrieval-quality or speed test.
4. Do not claim top-three recall, stale-answer avoidance, or task speedup from
   guided source recovery. A later blind replay must freeze expected sources,
   give the same questions and scope to each retrieval route, and measure time
   to usable evidence, source correctness, and bytes returned.
5. Required controls before a product claim: missing source; retired source
   versus current authority; same term in different repositories; dirty/stale
   checkout identity; disallowed repository; no relevant answer. Abstention is
   correct when the evidence cannot support an answer.

## Results and next check

The five cases are answerable from current local sources recovered by guided
search and reads. This is an answerability finding, not a retrieval-quality
score. K1/K2 are primarily guidance discovery/adherence; K3 needed a real asset
repair before retrieval could help; K4 is an observed cross-project repeat of
stale tooling knowledge; K5 requires separating tool behavior from a consumer's
release/publication obligation.

All three bounded existing-tool probes failed during stale graph refresh:

| Repository | Probe query | Elapsed | Result |
| --- | --- | --- | --- |
| Northstar | `launcher provided worktree` | 5.029 s | typed graph timeout at 5000 ms; no evidence |
| Effigy | `catalog_tasks` | 5.025 s | typed graph timeout at 5000 ms; no evidence |
| Underlay | `release execute GitHub Release` | 5.026 s | typed graph timeout at 5000 ms; no evidence |

The executable identified itself as `v0.12.1+local.aafbd93`. All probes used
`effigy --json docs context <query> --max-sections 3 --max-bytes 6000`, with
`--repo` for the two sibling repositories and `EFFIGY_GRAPH_TIMEOUT_MS=5000`.
The 10-second outer limit did not fire. The graph sizes reported during these
probes were 207888384, 242491392, and 119029760 bytes respectively. Those are
derived indexes, not Git checkout sizes. No lock, index, or repository content
was deleted or reset. Queries may refresh ignored derived graph state.

No ranked evidence was returned, so top-three recall and stale-answer avoidance
remain unmeasured. Warm-query performance is unmeasured. The short-budget runs
alone do not diagnose a broken engine; Northstar's separate 120-second timeout
shows a cold/stale availability problem worth investigating. No root cause or
speedup is claimed. Do not simply raise every agent's timeout as the product
answer.

## Source snapshots

- Northstar: `429429e3e58a9ec16f480e82a5911ea4a39578e4`.
- Effigy: `af2a96ea96007b67fa07914a952dcef9911f6f03`.
- Underlay: `7adaaf2e1b138ec0d7fc6dc30a85ec2a19918e5f`.

All fourteen selected reference files were verified byte-for-byte against their
repository HEAD, including the explicitly selected vendored skill references.
Effigy advanced from `bc7a36f` during collection; the files were rechecked at the
snapshot above. This is why results need per-source identity, not one ambient
"portfolio version". No tracked source modifications existed during the probes.

The recoverable source set is the five-case table plus Effigy guide 079,
contract 041, the three PAPERCUTS files, and Effigy's
`.agents/skills/effigy/references/json-envelope.md`. Raw local probe JSON and
source digests are at `/tmp/northstar-knowledge-pilot-20260905-093742/`; they are
disposable diagnostics. The commands, outcomes, source paths, and Git identities
in this note are the durable evidence needed to reproduce the pilot.

## Recommendation and unresolved boundary

Prefer an explicit portfolio source directory and a bounded query route over a
new central knowledge database. The directory should name repository identity,
allowed documentation/skill roots, canonical front doors, and the local query
route. Return source excerpts with repository/path/span, commit or dirty-content
identity, and declared authority/currentness. Preserve missing/unknown state and
report a partially unavailable repository rather than blocking all results.
Keep query routing independent of runtime agent notification/coordination.

First implementation candidate: make existing repository-local docs retrieval
usable within an agent-sized latency budget, then test a thin cross-repository
caller using the frozen cases. That likely belongs to Effigy because its
contract already owns extraction, freshness, and ranking. Northstar should own
authority/lifecycle guidance and any explicitly adopted profile, not another
retrieval engine. This ownership is a recommendation, not a ready dispatch.
A bounded exact-text fallback may be useful, but it must identify itself as
unranked/unknown-authority evidence, not silently impersonate semantic results.

Before implementation, settle with the operator whether to promote this work
into Effigy or another existing portfolio tool. Then freeze the caller's API,
latency/output budget, partial-failure behavior, per-repository access scope,
and source-identity requirements. Compare against ordinary source search with
the same task questions; success requires usable sources faster, preserved
current/historical distinction, and correct abstention on the negative controls.
No MCP server or embeddings are justified by the current evidence. No agent
may autonomously promote shared memory into another project's authority.
