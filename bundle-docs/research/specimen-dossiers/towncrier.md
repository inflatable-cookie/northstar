# Specimen Dossier: Towncrier

Status: Draft  
Specimen: Towncrier  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Scope: Changelog generation via news fragments

## 1) Why this specimen matters

Towncrier takes a unique "news fragment" approach to changelog management. Instead of editing a single CHANGELOG file (which causes merge conflicts), developers create small files that get compiled into the changelog at release time. Unlike changesets, towncrier is language-agnostic and has been used by major Python projects for years.

This specimen matters for Northstar because:
- It demonstrates language-agnostic changelog generation
- It's simpler than changesets (no versioning logic, just changelog compilation)
- It's battle-tested by projects like pytest and pip
- It separates "what changed for users" from "how the code changed"

## 2) Product and era context

- **First released**: ~2015 (Twisted project)
- **Primary ecosystem**: Python (but language-agnostic)
- **Key adopters**: Twisted, pytest, pip, BuildBot, attrs, and many others
- **Era**: Pre-conventional commits dominance, mature Python packaging

Towncrier predates the conventional commits specification and takes a different approach: rather than parsing commits, it relies on developers explicitly writing user-facing change descriptions.

## 3) Defining bets

**Core bet**: A changelog should be curated for end users, not auto-generated from developer commits.

**Secondary bets**:
- News fragments (small files) avoid merge conflicts better than editing shared files
- Changelog compilation should be a separate step from version bumping
- The same tool can work for any language ecosystem
- Developer-facing commit history and user-facing changelog serve different audiences

## 4) Standout strengths

1. **Language agnostic**: Works with any project type (though written in Python)
2. **Merge conflict avoidance**: Fragment files eliminate CHANGELOG merge conflicts
3. **User-focused output**: Encourages writing for end users, not developers
4. **Simple scope**: Just handles changelog generation, not versioning or publishing
5. **Category support**: Built-in support for categories (feature, bugfix, doc, etc.)
6. **Markdown and RST support**: Works with both major documentation formats

## 5) Chronic weaknesses and recurring costs

1. **Python dependency**: Even for non-Python projects, Python is required to run towncrier
2. **Extra developer step**: Developers must remember to create fragment files
3. **Fragment accumulation**: Unused fragment files can accumulate if not cleaned up
4. **No versioning integration**: Must be combined with other tools for version management
5. **Configuration required**: Needs towncrier.toml or pyproject.toml configuration
6. **Bot/check needed**: Needs CI check to ensure fragments are created

## 6) Between-version corrections

- Added Markdown support (originally RST-only)
- Added custom fragment types
- Added `towncrier check` for CI validation
- Added pre-commit hooks
- Improved monorepo support (multiple projects sharing config)

## 7) Project-relevant lessons

### Adopt carefully

- The fragment approach is excellent for avoiding merge conflicts
- Separation of concerns (changelog only) allows flexible integration
- Language-agnostic design is valuable for cross-ecosystem tools
- User-focused changelogs are often better than commit-driven ones

### Reject early

- Don't adopt if you don't want to add Python as a dependency
- Don't adopt if you want integrated versioning and publishing
- Don't adopt if your team won't remember to create fragments

### Prototype before deciding

- Test with a small project first
- Evaluate CI integration (fragment checking)
- Compare output quality with commit-driven alternatives

## 8) Source inventory

| Source | Type | Version/Era | Confidence | Notes |
|--------|------|-------------|------------|-------|
| https://github.com/twisted/towncrier | src | current | High | Main repository |
| https://towncrier.readthedocs.io/ | docs | current | High | Official docs |
| "Towncrier is a cleaner changelog utility" | blog | 2025 | Medium | Personal experience |
| "How to Keep a Changelog in Markdown" | docs | 2022 | High | Towncrier guide |

## 9) Open questions

1. Could a Rust/Go implementation provide the same functionality without Python dependency?
2. How would towncrier integrate with an Effigy task workflow?
3. Could Northstar define standard fragment types that work across ecosystems?

## Next Task

Compare with conventional-changelog specimen dossier to understand the tradeoffs between fragment-driven and commit-driven approaches.
