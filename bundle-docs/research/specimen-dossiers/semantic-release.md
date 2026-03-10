# Specimen Dossier: Semantic Release

Status: Draft  
Specimen: Semantic Release  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Scope: Fully automated release management

## 1) Why this specimen matters

Semantic Release is the poster child for fully automated release management. It pioneered the idea that commit messages alone should drive the entire release process—version bumps, changelog generation, git tagging, and package publishing. It has the largest ecosystem of plugins and the most mindshare in the JavaScript community.

This specimen matters for Northstar because it represents the "maximum automation" end of the spectrum, contrasting with the "explicit control" approach of changesets.

## 2) Product and era context

- **First released**: ~2014
- **Primary ecosystem**: JavaScript/TypeScript (npm)
- **Key adopters**: Thousands of npm packages, many open-source libraries
- **Era**: Early conventional commits adoption, CI/CD maturation

Semantic Release emerged when Travis CI was dominant and GitHub Actions didn't exist. It helped establish the conventional commits specification as a de facto standard.

## 3) Defining bets

**Core bet**: If developers write conventional commits, the release process can be fully automated with zero human intervention.

**Secondary bets**:
- Version numbers should be derived, not decided
- Every commit to main should be releasable
- Changelogs should be generated from commits
- Plugin architecture allows customization without forking

## 4) Standout strengths

1. **Zero-touch releases**: Once configured, releases happen automatically
2. **Plugin ecosystem**: Extensive plugin library for different platforms and workflows
3. **Conventional commits**: Encourages good commit hygiene
4. **Pre-release support**: Excellent support for alpha, beta, and feature branch releases
5. **Battle-tested**: Used by thousands of projects over many years
6. **Multi-branch releases**: Can publish pre-releases from non-main branches

## 5) Chronic weaknesses and recurring costs

1. **Commit discipline required**: Bad commit messages = bad releases
2. **No human review gate**: Releases happen automatically; no PR to review
3. **Configuration complexity**: `.releaserc` files can be complex
4. **Debugging difficulty**: When releases fail, debugging can be challenging
5. **Monorepo limitations**: No native monorepo support (needs separate tooling)
6. **Accidental releases**: Easy to accidentally trigger releases with incorrect commits

## 6) Between-version corrections

- Added support for GitHub Actions (originally Travis CI focused)
- Added dry-run mode for testing
- Improved plugin API
- Added support for sharing configurations via packages

## 7) Project-relevant lessons

### Adopt carefully

- The "commit-driven" model works well for libraries with disciplined maintainers
- Plugin architecture is a good pattern for extensibility
- The "zero human intervention" goal may be too extreme for many projects
- Consider a hybrid: conventional commits for changelog, but manual release approval

### Reject early

- Don't adopt if your team won't consistently write conventional commits
- Don't adopt if you need human approval before every release
- Don't adopt if you need native monorepo support
- Don't adopt if you want to decouple commit messages from release notes

### Prototype before deciding

- Test commit linting in your workflow first
- Evaluate whether your commits are already conventional-ish
- Test the failure modes (bad commit message, failed publish, etc.)

## 8) Source inventory

| Source | Type | Version/Era | Confidence | Notes |
|--------|------|-------------|------------|-------|
| https://github.com/semantic-release/semantic-release | src | current | High | Main repository |
| https://semantic-release.gitbook.io/ | docs | current | High | Official documentation |
| "The Ultimate Guide to NPM Release Automation" | blog | 2025 | High | Comparison with alternatives |
| "Using semantic-release to automate releases" | blog | 2024 | Medium | GitLab-focused guide |

## 9) Open questions

1. How much of semantic-release's plugin model could be adapted to an Effigy-native approach?
2. Could Effigy provide a "review gate" wrapper around semantic-release?
3. What would a Northstar "conventional commit template" look like?

## Next Task

Compare with changesets specimen dossier and document the explicit vs implicit tradeoffs in a value track synthesis.
