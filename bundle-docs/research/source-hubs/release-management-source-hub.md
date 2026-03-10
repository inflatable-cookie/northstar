# Source Hub: Release Management Systems

Status: Active  
Owner: Research Initiative  
Last Updated: 2026-03-10  

## Primary Sources [src/docs]

### Semantic Release
- **Repository**: https://github.com/semantic-release/semantic-release
- **Language**: JavaScript (Node.js)
- **Confidence**: High
- **Notes**: Fully automated approach. Commit messages drive everything. Plugin-based architecture. Uses conventional commits for version determination.

### Release Please (Google)
- **Repository**: https://github.com/googleapis/release-please
- **Language**: JavaScript (Node.js)
- **Maintainer**: Google
- **Confidence**: High
- **Notes**: PR-based approach. Creates release PRs for human review. Supports multiple languages via release types (node, python, go, rust, etc.).

### Changesets
- **Repository**: https://github.com/changesets/changesets
- **Language**: JavaScript (Node.js)
- **Confidence**: High
- **Notes**: Changeset file approach. Explicit change declaration. Excellent monorepo support. Version Packages PR workflow.

### Release It
- **Repository**: https://github.com/release-it/release-it
- **Language**: JavaScript (Node.js)
- **Confidence**: Medium
- **Notes**: Interactive CLI tool. Configurable hooks at each step. Plugin system. Less opinionated than semantic-release.

### Standard Version (deprecated/archived)
- **Repository**: https://github.com/conventional-changelog/standard-version
- **Status**: Deprecated (maintenance mode)
- **Confidence**: Medium
- **Notes**: Predecessor to release-please and other tools. Still used but not recommended for new projects.

### Python Semantic Release
- **Repository**: https://github.com/python-semantic-release/python-semantic-release
- **Language**: Python
- **Confidence**: Medium
- **Notes**: Python-native semantic release. Parses conventional commits. Integrates with pyproject.toml.

## Secondary Sources [blog/analysis]

- "The Ultimate Guide to NPM Release Automation" - comparison of semantic-release, release-please, changesets
- "Optic - Secure NPM Release Automation" - Nearform's OTP-based approach
- Various CI/CD integration guides for GitHub Actions

## Key Concepts

### Version Bump Strategies
- **Commit-driven**: Version derived from commit message types (feat→minor, fix→patch, BREAKING→major)
- **Changeset-driven**: Version derived from explicit changeset declarations
- **Manual**: Human explicitly specifies version bump

### Release Triggers
- **Push-to-main**: Release on every push to main branch
- **PR-based**: Release PR merged when ready
- **Manual**: Explicit command or API call

### Artifact Publication
- npm, PyPI, GitHub Releases, Docker Hub, etc.

## Key Questions This Source Map Should Answer

1. How much automation vs human control is appropriate?
2. What are the failure modes of fully automated releases?
3. How do different approaches handle pre-releases and feature branches?
4. What is the right boundary between Effigy invocation and Northstar definitions?

## Related Specimen Dossiers

- `../specimen-dossiers/semantic-release.md`
- `../specimen-dossiers/release-please.md`
- `../specimen-dossiers/changesets.md`
- `../specimen-dossiers/release-it.md`
