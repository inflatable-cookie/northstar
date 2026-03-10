# Specimen Dossier: Effigy Release System (Internal Reference)

Status: Draft  
Specimen: Effigy's Custom Release Management  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Scope: Changelog-driven, human-gated release flow with multi-channel distribution

## 1) Why this specimen matters

Effigy has implemented a **custom release management system** that doesn't map directly to any of the popular tools (semantic-release, release-please, changesets). Understanding this internal approach is crucial because:

1. It represents a real-world, production-tested release flow
2. It demonstrates the "human-gated" approach with extensive automation
3. It shows how changelog-first versioning works in practice
4. It informs how Northstar should define contracts that support this kind of custom flow

## 2) Product and era context

- **First implemented**: 2025-03 (v0.2.x era)
- **Context**: Rust CLI tool with multi-platform binary distribution
- **Key constraints**: 
  - Must support Homebrew, GitHub Releases, and crates.io
  - Cross-compilation for 4 target platforms
  - Human must approve releases (no fully automated publishing)
  - Evidence-based validation required

## 3) Defining bets

**Core bet**: A changelog-first, human-gated approach provides the right balance of automation and control for a CLI tool.

**Secondary bets**:
- Version should be determined by changelog entries, not commit messages
- Release gates should be script-based and reusable
- Multi-channel distribution requires coordinated validation
- Evidence logs provide auditability
- Tag-triggered CI is cleaner than CI-triggered releases

## 4) Architecture

### Phase Flow

```
[Prepare] → [Validate] → [Commit] → [Tag] → [CI Pipeline] → [Verify]
```

### Key Components

| Component | Purpose | Tool/Script |
|-----------|---------|-------------|
| `prepare-release.sh` | Analyze CHANGELOG, compute version, update files | Custom bash |
| `check-release-gates.sh` | Consolidated validation before release | Custom bash |
| `check-distribution-*.sh` | Channel-specific validation | Custom bash |
| `generate-distribution-closeout-log.sh` | Evidence logging | Custom bash |
| `release-binaries.yml` | CI pipeline triggered by tags | GitHub Actions |
| `setup-effigy` action | Consumer CI install helper | GitHub Action |

### Changelog Structure

```markdown
## [Unreleased]

### Breaking

### Added

### Changed

### Fixed

## [0.2.4] - 2026-03-10

### Breaking

### Added
- Feature description
```

**Version determination logic**:
- Breaking entries → MINOR bump (v0.x policy)
- Otherwise → PATCH bump

### Release Execution Protocol

1. **Determine version**: Run `prepare-release.sh` (dry-run)
2. **Prepare changes**: Run `prepare-release.sh --apply`
3. **Draft notes**: Create release notes log
4. **Run gates**: Execute `cargo qa-release`
5. **Commit**: Single commit `release: vX.Y.Z`
6. **Tag**: `git tag vX.Y.Z && git push --tags`
7. **Verify**: Monitor CI pipeline

## 5) Standout strengths

1. **Human control**: Explicit human decision for every release
2. **Changelog-first**: Version derived from curated changelog, not commits
3. **Comprehensive gates**: Multiple validation layers before and during release
4. **Multi-channel**: Coordinated release to Homebrew, GitHub, crates.io
5. **Evidence-based**: Closeout logs and artifact validation
6. **Consumer-friendly**: Setup action for CI consumers
7. **Documented**: Extensive runbooks and checklists

## 6) Chronic weaknesses and costs

1. **Custom maintenance**: All scripts maintained in-house
2. **No ecosystem reuse**: Doesn't leverage semantic-release, changesets, etc.
3. **Manual changelog**: No enforcement that changelog entries are created with PRs
4. **Human-dependent**: Releases blocked if human not available
5. **No pre-release automation**: Alpha/beta releases require manual steps
6. **Platform-specific**: Tightly coupled to GitHub Actions

## 7) Comparison with researched tools

| Aspect | Effigy Approach | Semantic Release | Release Please | Changesets |
|--------|-----------------|------------------|----------------|------------|
| **Trigger** | Human + tag push | Commit to main | PR merge | PR merge |
| **Version source** | Changelog analysis | Commit messages | Commit messages | Changeset files |
| **Review gate** | Human checklist | None | PR review | PR review |
| **Changelog** | Manual, curated | Auto-generated | Auto-generated | Fragment-based |
| **Multi-channel** | Custom scripts | Plugins | Limited | Limited |
| **Evidence** | Closeout logs | Git tags | Git tags | Git tags |

## 8) Project-relevant lessons

### For Northstar

1. **Contract-first design**: Effigy's approach could be generalized into a contract
   - "Changelog-first" as a release policy option
   - "Human-gated" as a control point
   - "Multi-channel" as a distribution requirement

2. **Template flexibility**: Effigy's approach shows the need for:
   - Custom validation scripts
   - Project-specific gate definitions
   - Flexible changelog categories

3. **Documentation as code**: The extensive runbooks (guides 014, 036, 044, 049) show that release processes need documentation, not just automation.

### For Effigy

1. **Potential integration**: Could Effigy invoke `prepare-release.sh` as a task?
2. **Standardization**: Could Effigy's approach inform a Northstar "release contract"?
3. **Cross-pollination**: Some of Effigy's validation scripts could become Northstar templates.

## 9) Open questions

1. Should Northstar support "custom script" release flows or only standard tools?
2. How can Effigy's changelog-first approach be generalized?
3. What parts of Effigy's system are reusable vs project-specific?
4. Could Effigy's scripts be refactored to use a Northstar release contract?

## 10) Source inventory

| Source | Type | Location | Notes |
|--------|------|----------|-------|
| `prepare-release.sh` | src | `scripts/prepare-release.sh` | Version/changelog logic |
| `check-release-gates.sh` | src | `scripts/check-release-gates.sh` | Validation orchestration |
| `release-binaries.yml` | src | `.github/workflows/release-binaries.yml` | CI pipeline |
| Guide 014 | docs | `docs/guides/014-release-checklist-template.md` | Checklist template |
| Guide 049 | docs | `docs/guides/049-ci-binary-distribution-and-release-protocol.md` | Protocol |
| CHANGELOG.md | data | `CHANGELOG.md` | Format example |

## Next Task

Synthesize lessons from Effigy's approach with the researched tools to define Northstar's release contract options.
