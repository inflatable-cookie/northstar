# Specimen Dossier: Changesets

Status: Draft  
Specimen: Changesets  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Scope: Release management and changelog generation for monorepos

## 1) Why this specimen matters

Changesets is one of the most prominent tools for managing releases in monorepos. It takes a unique approach compared to semantic-release: instead of deriving changes from commit messages, it uses explicit "changeset" files that developers create alongside their changes. This decouples the developer workflow (commit messages for code review) from the release workflow (changeset entries for end users).

This specimen matters for Northstar because it demonstrates:
- An alternative to commit-driven workflows
- Strong monorepo support
- A "review gate" model via PRs for versioning

## 2) Product and era context

- **First released**: ~2019
- **Primary ecosystem**: JavaScript/TypeScript (npm/pnpm/yarn)
- **Key adopters**: pnpm, mobx, emotion, many modern JS monorepos
- **Era**: Post-Lerna decline, modern monorepo tooling emergence

Changesets emerged as Lerna fell out of maintenance, filling the gap for monorepo versioning without the complexity of Lerna's full package management features.

## 3) Defining bets

**Core bet**: Developers should explicitly declare what changed for end users, separate from how they describe changes for code review.

**Secondary bets**:
- Monorepo packages should version independently by default
- Release coordination should happen through GitHub PRs (the "Version Packages" PR)
- Changeset files are better than editing a single changelog directly (avoids merge conflicts)

## 4) Standout strengths

1. **Decoupled concerns**: Commit messages can be technical; changeset entries can be user-focused
2. **Merge conflict avoidance**: Each change gets its own file; no editing shared files during development
3. **Review-friendly**: Changesets are reviewed as part of the PR that introduces the change
4. **Monorepo-native**: Understands package dependencies and bumps dependents automatically
5. **Flexible publish workflow**: Custom `version` and `publish` commands via GitHub Actions

## 5) Chronic weaknesses and recurring costs

1. **Extra developer step**: Developers must remember to run `changeset` and commit the file
2. **Bot dependency**: Requires the changesets GitHub bot or similar to enforce changeset creation
3. **JavaScript-centric**: Primarily designed for npm-based workflows; polyglot support requires workarounds
4. **Configuration complexity**: `.changeset/config.json`, GitHub Actions workflow, and package.json changes
5. **Abandoned changesets**: Forgotten changeset files that never get consumed

## 6) Between-version corrections

- Added Markdown support (originally RST-focused)
- Added support for snapshot releases
- Improved GitHub Actions integration
- Added `changeset status` for CI checks

## 7) Project-relevant lessons

### Adopt carefully

- The "explicit changeset file" model is powerful but adds friction
- The PR-based release flow (Version Packages PR) provides good visibility and control
- Independent versioning in monorepos may be overkill for some projects

### Reject early

- Don't adopt if you want fully automated releases without human review
- Don't adopt if your project is a simple single-package repo (overkill)
- Don't adopt if you need to support many non-JS ecosystems natively

### Prototype before deciding

- Test the "changeset forgotten" problem with your team
- Evaluate whether independent versioning or unified versioning fits better
- Test the GitHub Actions integration with your CI setup

## 8) Source inventory

| Source | Type | Version/Era | Confidence | Notes |
|--------|------|-------------|------------|-------|
| https://github.com/changesets/changesets | src | current | High | Main repository |
| https://github.com/changesets/action | src | current | High | GitHub Action |
| Frontend Handbook on Changesets | docs | 2025 | Medium | Infinum handbook |
| "Using Changesets in a polyglot monorepo" | blog | 2026 | High | Luke Hsiao's experience |
| "Guide to version management with changesets" | blog | 2022 | Medium | LogRocket guide |

## 9) Open questions

1. Could a simplified changeset-like model work for non-JS ecosystems without JS tooling?
2. How would changesets integrate with Effigy's task system vs being a standalone tool?
3. What would a Northstar "changeset template" look like?

## Next Task

Compare with semantic-release specimen dossier to understand tradeoffs between explicit vs implicit change tracking.
