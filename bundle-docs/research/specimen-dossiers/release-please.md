# Specimen Dossier: Release Please

Status: Draft  
Specimen: Release Please  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Scope: PR-based release automation (Google)

## 1) Why this specimen matters

Release Please is Google's approach to release automation. It sits between the fully automated semantic-release and the manually-driven changesets. It creates and maintains "release PRs" that accumulate changes until a human merges them, providing a natural review gate while still automating the tedious parts.

This specimen matters for Northstar because:
- It demonstrates the "review gate" pattern using GitHub-native PRs
- It supports multiple languages (not just JavaScript)
- It balances automation with human control
- It comes from Google's experience with large-scale monorepos

## 2) Product and era context

- **First released**: ~2018
- **Maintainer**: Google (googleapis organization)
- **Primary ecosystems**: Multi-language (Node, Python, Go, Ruby, Rust, Java, .NET)
- **Key adopters**: Google Cloud client libraries, Firebase, and many others
- **Era**: GitHub Actions rise, Google Cloud expansion

Release Please was created to automate releases across Google's many open-source client libraries, which span multiple languages and need consistent release practices.

## 3) Defining bets

**Core bet**: Releases should have human review, but the preparation should be fully automated.

**Secondary bets**:
- Release PRs provide the right balance of automation and control
- Manifest files should track released versions
- Conventional commits are good for parsing, but releases need human approval
- Multi-ecosystem support is essential for large organizations

## 4) Standout strengths

1. **Human review gate**: Releases happen via PR merge, providing natural approval point
2. **Multi-language support**: Native support for many ecosystems
3. **GitHub-native**: Uses GitHub PRs and releases as the core workflow
4. **Split repositories**: Can handle releasing multiple packages from one repo
5. **No credential complexity**: Uses GitHub Actions permissions, not complex bot tokens
6. **Google backing**: Well-maintained by a dedicated team

## 5) Chronic weaknesses and recurring costs

1. **GitHub-centric**: Tightly coupled to GitHub (Actions, PRs, Releases)
2. **Configuration files**: Requires `release-please-config.json` and `.release-please-manifest.json`
3. **Release accumulation**: Multiple changes accumulate in one release PR
4. **No pre-release channels**: Less mature support for alpha/beta releases
5. **Rigid workflow**: Less flexible than semantic-release's plugin model
6. **JavaScript implementation**: Despite multi-language output, requires Node.js to run

## 6) Between-version corrections

- Added manifest-based versioning (originally git tag based)
- Added GitHub Actions integration (originally CLI-only)
- Added component-based releases for monorepos
- Improved support for breaking change detection

## 7) Project-relevant lessons

### Adopt carefully

- The "release PR" pattern is excellent for teams that want visibility into upcoming releases
- Multi-language support is valuable for cross-ecosystem standards
- GitHub-native workflows reduce tooling complexity
- The manifest approach provides clear version tracking

### Reject early

- Don't adopt if you're not using GitHub
- Don't adopt if you need highly customized release workflows
- Don't adopt if you want per-change releases (accumulates multiple changes)
- Don't adopt if you need sophisticated pre-release channel management

### Prototype before deciding

- Test the "release accumulation" behavior—will your team want more frequent releases?
- Evaluate the configuration overhead
- Test with your specific language ecosystem

## 8) Source inventory

| Source | Type | Version/Era | Confidence | Notes |
|--------|------|-------------|------------|-------|
| https://github.com/googleapis/release-please | src | current | High | Main repository |
| https://github.com/googleapis/release-please-action | src | current | High | GitHub Action |
| "The Ultimate Guide to NPM Release Automation" | blog | 2025 | High | Comparison with alternatives |
| "Automated Semantic Releases on GitHub" | blog | 2025 | Medium | Setup guide |

## 9) Open questions

1. Could the "release PR" concept be adapted to non-GitHub workflows?
2. How would Release Please integrate with Effigy's task system?
3. Could Northstar define standard release-please configurations per ecosystem?

## Next Task

Compare with semantic-release and changesets specimen dossiers to document the control spectrum.
