# Northstar Active Systems Research - Master Index

Status: Active
Last Updated: 2026-08-26

## Research Overview

This research initiative explores evolving Northstar from a static documentation template system to a more "active stance" with reusable tooling for:

1. **Reusable Release Management** - Systems for automating version bumps, releases, and publication
2. **Changelog Handler System** - Tools for updating, formatting, and maintaining changelogs
3. **Documentation Coverage Checks** - Validating completeness and consistency of documentation
4. **Standardised README Generation** - Template-driven README creation and maintenance
5. **Language-Specific Coding Quality** - Source-backed authoring and explicit audit-and-repair workflows

## Key Architectural Question

> Where should functionality live between Northstar (definitions/templates) and Effigy (implementation/invocation)?

The research follows the principle: **Northstar defines contracts, Effigy implements orchestration**.

## Navigation

### Source Hubs
Curated source maps for each feature area:
- [Changelog Source Hub](source-hubs/changelog-source-hub.md) - Changelog formats and generation tools
- [Release Management Source Hub](source-hubs/release-management-source-hub.md) - Release automation systems
- [README Generation Source Hub](source-hubs/readme-generation-source-hub.md) - README standards and generators
- [Documentation Coverage Source Hub](source-hubs/documentation-coverage-source-hub.md) - Doc coverage and validation tools

### Specimen Dossiers
Detailed studies of specific tools and systems:
- [Changesets](specimen-dossiers/changesets.md) - Fragment-driven release management for monorepos
- [Semantic Release](specimen-dossiers/semantic-release.md) - Fully automated commit-driven releases
- [Release Please](specimen-dossiers/release-please.md) - Google's PR-based release automation
- [Towncrier](specimen-dossiers/towncrier.md) - Language-agnostic changelog generation via fragments
- [Effigy Release System](specimen-dossiers/effigy-release-system.md) - Custom changelog-first, human-gated approach (internal reference)

### Value Track Syntheses
Cross-specimen syntheses by problem area:
- [Release Management Spectrum](value-tracks/release-management-spectrum.md) - Comparing automation vs control approaches
- [Changelog Formats](value-tracks/changelog-formats.md) - Analyzing format standards and variations

### Translation Memos
Project-facing recommendations:
- [Northstar-Effigy Boundary](translation-memos/northstar-effigy-boundary.md) - Architecture recommendations for dividing responsibilities
- [Northstar-Effigy Integration](translation-memos/northstar-effigy-integration.md) - How Effigy's existing system informs Northstar's design
- [AI Agent Release Playbook](translation-memos/ai-agent-release-playbook.md) - Human-in-the-loop release playbook for AI agents
- [Changelog Library Placement](translation-memos/changelog-library-placement.md) - Where the changelog parser library should live
- [Northstar Orchestrator Thread](translation-memos/northstar-orchestrator-thread.md) - Evidence-backed split between conversational planning, worker execution, and PR review
- [Agent Instruction Surface Optimization](translation-memos/agent-instruction-surface-optimization.md) - Evidence-backed rules for compact always-loaded agent instructions
- [Matt Pocock Skills Audit To Northstar](translation-memos/matt-pocock-skills-audit-to-northstar.md) - Translation of external skill-design evidence into Northstar constraints
- [Rust Quality Authoring And Audit](translation-memos/rust-quality-skills-and-audit.md) - Source-backed two-track Rust quality model
- [TypeScript Quality And Svelte Overlay](translation-memos/typescript-quality-and-svelte-overlay.md) - Source-backed TypeScript pack with conditional Svelte and SvelteKit rules

### Specifications
Technical specifications for tools and formats:
- [Northstar Changelog Profile](specifications/northstar-changelog-profile.md) - Strict, parseable Keep a Changelog profile
- [Changelog Formatter](specifications/changelog-formatter-spec.md) - Changelog formatting and validation tool spec

### Prototypes

- [Rust Quality Prototype](prototypes/rust-quality/README.md) - Seven-rule shared catalogue, ten-case seed corpus, generated workflow views, and executable scorer
- [TypeScript Quality Prototype](prototypes/typescript-quality/README.md) - Thirteen-rule research catalogue with TypeScript, Svelte, and SvelteKit benchmark seeds

## Quick Answers

### Which release management approach is best?

It depends on your needs:
- **Maximum automation**: Semantic Release (but requires commit discipline)
- **Review gate + automation**: Release Please (Google's approach)
- **Explicit control + monorepo**: Changesets (best for complex monorepos)
- **Changelog only**: Towncrier (language-agnostic, simple)
- **Changelog-first + human gate**: Effigy's custom approach (see specimen dossier)

### What changelog format should we use?

[Keep a Changelog](https://keepachangelog.com/) 1.0.0 is the de facto standard. Categories: Added, Changed, Deprecated, Removed, Fixed, Security.

### What's the Northstar/Effigy boundary?

- **Northstar**: Define contracts, templates, and validation criteria
- **Effigy**: Discover tools, orchestrate workflows, integrate with CI/CD

See the [translation memo](translation-memos/northstar-effigy-boundary.md) for details.

### How should coding-quality guidance survive context decay?

Use two workflow tracks backed by one catalogue. Everyday authoring gets a
compact scoped activation, selective rule loading, and a changed-tranche exit
check. Explicit audit-and-repair resolves worktree or repository scope and runs
deeper review and bounded repair. The repository-selected assurance profile is
independent of workflow choice.

See the [Rust quality translation memo](translation-memos/rust-quality-skills-and-audit.md).

For TypeScript, keep Svelte and SvelteKit as conditional overlays in the same
catalogue and audit. Route them by dependency, version, package, and file
ownership. Do not duplicate the base TypeScript standard in a separate skill.

See the [TypeScript and Svelte translation memo](translation-memos/typescript-quality-and-svelte-overlay.md).

## Release and changelog research status

| Phase | Status | Notes |
|-------|--------|-------|
| Source gathering | Complete | Primary sources collected |
| Specimen analysis | Complete | 4 major tools analyzed |
| Cross-specimen synthesis | Complete | 2 value tracks written |
| Translation memo | Complete | Architecture recommendations ready |
| Prototype planning | Complete | See handoff documents |
| **Implementation** | **Ready** | See `handoff/` directory |

## Rust quality research status

| Phase | Status | Notes |
| --- | --- | --- |
| Source gathering | Complete | Skills, engineering guidance, assurance sources, and experimental tooling reviewed |
| Translation memo | Complete | Two-track model and authority split promoted |
| Rule prototype | Seed ready | Seven sourced rules exercise authoring, audit, provenance, profiles, remediation, and deviation fields |
| Benchmark | Required tracks eligible | Production K makes explicit audit eligible at `3/3`; production M makes everyday authoring eligible at `3/3` with frozen churn and blind-review gates |
| Contract | Complete | Six normative rules promoted; strict selected; `004-language-quality-pack` active |
| Implementation | Complete | `g02.030/083-088` proved the boundary, production foundation, routed workflows, both production tracks, and exact published-install parity |

## TypeScript quality research status

| Phase | Status | Notes |
| --- | --- | --- |
| Source gathering | Initial complete | TypeScript, typed linting, Oxlint, anti-slop, NASA, Svelte, and SvelteKit sources reviewed |
| Translation memo | Seed ready | One TypeScript pack with conditional Svelte and SvelteKit overlays recommended |
| Rule prototype | Promoted subset | Nine source-local rules are normative for explicit audit; one slop signal is evaluation-only; three package-context candidates remain research-only |
| Benchmark | Explicit audit eligible; everyday authoring ineligible | Three repair pairs passed 27/27 claims, 96/96 review dimensions, and 24/24 accept decisions; authoring revision 2 stopped after two overall guided losses |
| Contract | Explicit audit promoted | Contract 004 owns nine strict source-local rules plus one evaluation-only signal; everyday, toolchain, and testing remain unavailable |
| Implementation | Distributed | Revision S passed `3/3` copied-payload subjects and blind reviewers; card 093 distributed the exact payload with 93-file source/install parity |

## Handoff to Implementation

**Status**: Ready for implementation agent

**Start here**:
- `handoff/QUICK_START.md` - 5-minute primer
- `handoff/IMPLEMENTATION_BRIEF.md` - Full implementation guide

**Then read**:
- `specifications/northstar-changelog-profile.md` - The format to implement
- `specifications/changelog-formatter-spec.md` - Tool specification

**Reference as needed**:
- `translation-memos/ai-agent-release-playbook.md` - How it fits in release flow
- `DECISIONS.md` - Why decisions were made

## Contributing to This Research

When adding new specimens:
1. Create a new dossier in `specimen-dossiers/`
2. Update relevant source hubs
3. Consider if a new value track is needed
4. Update this master index

When synthesizing:
1. Compare at least 2-3 specimens
2. Identify patterns, not just differences
3. Connect to the Northstar/Effigy boundary question
4. Write clear recommendations

## Open Questions

1. How would the release phase contract be defined in practice?
2. What would Northstar templates for each tool look like?
3. How do we handle non-GitHub platforms (GitLab, etc.)?
4. What's the minimum viable implementation to validate the boundary?
5. Which Rust rules improve benchmark code without noisy rewrites?
6. Which rules belong in ordinary, strict, and high-assurance profiles?
7. Which TypeScript rules improve human review outcomes without type-lint noise?
8. How should mixed TypeScript, Svelte, and SvelteKit packages resolve overlays at monorepo scale?

## Next Tasks

See the [translation memo](translation-memos/northstar-effigy-boundary.md) for recommended prototype work:
1. Changelog template system prototype
2. Release phase contract prototype
3. README generation prototype

For Rust quality, collect operator-provided live-use feedback. Observable
compaction remains a separate evidence gap; Northstar does not dispatch a
consumer run.

For TypeScript quality, accept operator-provided live-use feedback. The
explicit-only route is distributed; everyday authoring remains unavailable.
Treat package-backed toolchain/test evidence as a separate later research lane.
Northstar does not dispatch a consumer audit.
