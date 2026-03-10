# Source Hub: Changelog Formats and Generation Tools

Status: Active  
Owner: Research Initiative  
Last Updated: 2026-03-10  

## Primary Sources [spec/docs]

### Keep a Changelog
- **URL**: https://keepachangelog.com/en/1.0.0/
- **Type**: Community specification
- **Version**: 1.0.0 (2019)
- **Confidence**: High
- **Notes**: De facto standard format for human-readable changelogs. Defines categories: Added, Changed, Deprecated, Removed, Fixed, Security.

### Conventional Commits
- **URL**: https://www.conventionalcommits.org/en/v1.0.0/
- **Type**: Specification
- **Version**: 1.0.0
- **Confidence**: High
- **Notes**: Commit message convention that dovetails with SemVer. Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.

### Semantic Versioning
- **URL**: https://semver.org/spec/v2.0.0.html
- **Type**: Specification
- **Version**: 2.0.0
- **Confidence**: High
- **Notes**: MAJOR.MINOR.PATCH format. Essential context for changelog version entries.

## Tools [src]

### Towncrier
- **Repository**: https://github.com/twisted/towncrier
- **Language**: Python
- **Used by**: Twisted, pytest, pip, BuildBot, attrs
- **Confidence**: High
- **Notes**: News fragment approach. Decouples developer log from user-facing changelog. Language-agnostic when not using Python-specific features.

### Conventional Changelog
- **Repository**: https://github.com/conventional-changelog/conventional-changelog
- **Language**: JavaScript (Node.js)
- **Confidence**: High
- **Notes**: Generates changelogs from conventional commits. Multiple presets (angular, conventionalcommits, atom, ember, eslint, express, jquery, jshint).

### Changesets
- **Repository**: https://github.com/changesets/changesets
- **Language**: JavaScript (Node.js)
- **Confidence**: High
- **Notes**: Changeset file approach. Excellent monorepo support. Decouples versioning from commit messages.

### Changelogen (unjs)
- **Repository**: https://github.com/unjs/changelogen
- **Language**: JavaScript (TypeScript)
- **Confidence**: Medium
- **Notes**: Modern TypeScript-focused tool. Generates from conventional commits with GitHub integration.

### GitHub Releases
- **URL**: https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases
- **Type**: Platform feature
- **Confidence**: High
- **Notes**: Non-portable changelog tied to GitHub. Can auto-generate from tags or manual notes.

## Secondary Sources [blog/analysis]

- "Don't let your friends dump git logs into changelogs" - Keep a Changelog philosophy
- Python Packaging Guide on changelogs - practical guidance
- Various comparisons of towncrier vs changesets vs conventional changelog

## Key Questions This Source Map Should Answer

1. What are the tradeoffs between commit-driven vs fragment-driven changelog generation?
2. How do different formats handle breaking changes and deprecations?
3. What level of human curation vs automation is appropriate?
4. How do these systems handle monorepos vs single packages?

## Related Specimen Dossiers

- `../specimen-dossiers/towncrier.md`
- `../specimen-dossiers/conventional-changelog.md`
- `../specimen-dossiers/changesets.md`
- `../specimen-dossiers/semantic-release.md`
