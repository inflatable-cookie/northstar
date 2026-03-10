# Value Track Synthesis: Release Management Spectrum

Status: Draft  
Track: Release Management Approaches  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Primary project tags: release-management, automation, northstar-effigy-boundary

## 1) Problem statement

Projects need to release new versions consistently and reliably. The challenge is balancing automation (for speed and consistency) with control (for safety and appropriateness). Different tools make different tradeoffs on this spectrum, from fully automatic (semantic-release) to fully manual (traditional versioning).

The core questions are:
- How much should be automated vs human-controlled?
- Where should change descriptions come from (commits vs explicit files)?
- When should versions be determined (at commit time vs at release time)?
- How do we support different ecosystems without multiplying complexity?

## 2) Why this track matters

For Northstar's evolution into active tooling, we need to understand:
1. What release management patterns should Northstar define (standards)?
2. What should Effigy implement (invocation mechanisms)?
3. How can templates provide flexibility without becoming unmaintainable?

## 3) Cross-specimen comparison

| Specimen | Approach | Automation Level | Control Point | Best For | Project Signal |
|----------|----------|------------------|---------------|----------|----------------|
| **Semantic Release** | Commit-driven | Maximum | None (automatic) | Disciplined teams, libraries | Good for zero-touch libraries |
| **Release Please** | Commit-driven | High | PR merge | Teams wanting review | Good for Google's workflow |
| **Changesets** | Fragment-driven | Medium | PR merge + changeset | Monorepos, explicit control | Good for complex monorepos |
| **Towncrier** | Fragment-driven | Low | Manual compilation | Changelog only | Good for language-agnostic projects |
| **Release It** | Manual + hooks | Configurable | Interactive | Custom workflows | Good for special requirements |

## 4) Repeated patterns

### Pattern 1: Commit-driven vs Fragment-driven

**Commit-driven** (Semantic Release, Release Please):
- Pros: No extra steps for developers, automatic from git history
- Cons: Commits must be well-formed, less user-focused wording
- Best when: Team has good commit discipline, library projects

**Fragment-driven** (Changesets, Towncrier):
- Pros: User-focused wording, no commit format requirements
- Cons: Extra step to create fragment, risk of forgetting
- Best when: End-user experience matters, complex changes need explanation

### Pattern 2: Zero-touch vs Review Gate

**Zero-touch** (Semantic Release):
- Every merge to main triggers a release
- Fastest iteration, but no human oversight
- Risk: Accidental releases

**Review Gate** (Release Please, Changesets):
- Releases are prepared but need human approval
- Slower iteration, but safer
- Natural fit with GitHub PR workflows

### Pattern 3: Single-package vs Monorepo

**Single-package** (Semantic Release, Towncrier):
- Simpler configuration
- One version line
- Best for focused libraries

**Monorepo** (Changesets, Release Please):
- Complex dependency management
- Independent or unified versioning
- Best for product suites, related packages

## 5) Frontier signals

1. **Polyglot support**: Tools are increasingly expected to work across ecosystems (Changesets' custom version command, Release Please's multi-language support)

2. **AI-assisted changelogs**: Emerging use of AI to summarize commits into user-friendly language (changelogen's direction)

3. **Release previews**: Tools showing what would be released before it happens

4. **Platform integration**: Deep integration with GitHub (Actions, PRs, Releases) becoming standard

## 6) Project implications

### Recommended direction

Northstar should define **release management contracts** (what needs to happen) while Effigy provides **invocation mechanisms** (how to make it happen).

**Northstar's role (definitions)**:
- Define standard release phases (prepare, review, publish, notify)
- Define changelog formats (Keep a Changelog + extensions)
- Provide template structures for different approaches
- Define validation criteria for releases

**Effigy's role (invocation)**:
- Discover and invoke appropriate tools
- Orchestrate multi-phase releases
- Provide hooks for custom steps
- Integrate with CI/CD systems

### Risks to avoid

1. **Don't build a new release tool**: The ecosystem has good tools; focus on integration
2. **Don't mandate a single approach**: Different projects need different levels of control
3. **Don't ignore non-JS ecosystems**: Python, Rust, Go projects have different conventions
4. **Don't conflate versioning with changelogging**: These can be separate concerns

### Evidence or prototype needed

1. Test a "review gate" workflow with a real project
2. Evaluate how well existing tools integrate with Effigy's task system
3. Design the Northstar-Effigy interface for release contracts

## 7) Source inventory

| Source | Type | Confidence | Notes |
|--------|------|------------|-------|
| Semantic Release docs | docs | High | Full automation approach |
| Release Please docs | docs | High | Google PR-based approach |
| Changesets docs | docs | High | Explicit changeset approach |
| Towncrier docs | docs | High | Fragment-based changelog |
| "Ultimate Guide to NPM Release Automation" | blog | High | Comparative analysis |

## 8) Decision state

- `promote to architecture work` - Ready to define Northstar release contracts
- `continue research` - Need more analysis of specific integrations
- `prototype first` - Build proof-of-concept with Effigy

**Recommended**: `prototype first` - Build a small integration between Northstar templates and an existing tool to test the boundary assumptions.

## Next Task

Write translation memo with concrete recommendations for Northstar/Effigy boundary.
