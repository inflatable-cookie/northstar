# Translation Memo: AI Agent Release Playbook

Status: Draft  
Memo: Human-in-the-loop release playbook for AI agents  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Related: Effigy Release System, Northstar-Effigy Integration

## 1) Project problem statement

Enable an AI agent to execute a release following the changelog-first, human-gated approach that Effigy uses. The agent needs:

1. A clear, deterministic playbook to follow
2. Tools that do the heavy lifting (version computation, validation, formatting)
3. Human decision points (approval to proceed)
4. Recovery paths when things fail

The changelog serves as both:
- The **source of truth** for what changed (determines version bump)
- The **user-facing release notes** (extracted for GitHub releases)

## 2) Current pain points

### Changelog formatting issues
- Empty sections (### Breaking with no entries) aren't filtered
- Inconsistent spacing between sections
- Manual cleanup needed before release
- No validation that changelog follows format

### Agent friction
- No single command to "prepare release"
- Multiple scripts to remember and sequence
- No clear "are we ready to release?" check
- Unclear what requires human approval vs automation

## 3) Recommended playbook

### Playbook: `northstar release prepare`

**Purpose**: Prepare repository for release, compute version, validate readiness.

**Steps**:

```
1. VALIDATE changelog format
   ├─ Check [Unreleased] section exists
   ├─ Check required categories present (Breaking, Added, Changed, Fixed)
   ├─ Check entries follow format ("- Description [optional link]")
   └─ FAIL if format errors found → report to human

2. ANALYZE [Unreleased] content
   ├─ Count entries per category
   ├─ Determine version bump:
   │   ├─ Breaking entries → MINOR (v0.x policy)
   │   └─ Otherwise → PATCH
   ├─ PROPOSE version to human
   └─ Human approves/revises version

3. FORMAT changelog
   ├─ Remove empty categories
   ├─ Normalize spacing
   ├─ Sort entries (optional: by significance)
   └─ Preview formatted version to human

4. PREPARE release artifacts
   ├─ Update version in package files (Cargo.toml, package.json, etc.)
   ├─ Move [Unreleased] to versioned section with date
   ├─ Create fresh [Unreleased] template
   └─ Sync lockfiles if needed

5. VALIDATE release gates
   ├─ Run test suite
   ├─ Run lint/format checks
   ├─ Run distribution checks
   └─ Report any failures

6. PRESENT summary to human
   ├─ Proposed version
   ├─ Changes being released
   ├─ Validation results
   └─ "Proceed with release?" → Y/N
```

### Playbook: `northstar release execute`

**Purpose**: Execute the release after human approval.

**Prerequisites**: `northstar release prepare` completed and approved.

**Steps**:

```
1. COMMIT changes
   ├─ Stage version bumps and changelog
   ├─ Commit: "release: vX.Y.Z"
   └─ Push to main

2. CREATE TAG
   ├─ Tag: vX.Y.Z
   ├─ Push tags
   └─ Verify CI pipeline triggered

3. MONITOR pipeline (async)
   ├─ Watch CI status
   ├─ Report progress to human
   └─ On failure: alert human with logs

4. POST-RELEASE verification
   ├─ Verify GitHub Release created
   ├─ Verify artifacts attached
   ├─ Verify distribution channels updated
   └─ Generate closeout log
```

## 4) Tools specification

### Tool: `northstar-changelog`

**Purpose**: Changelog formatting and validation.

**Commands**:

```bash
# Validate changelog format
northstar-changelog validate
# Exit 0 if valid, exit 1 with error details if invalid

# Format changelog (dry-run)
northstar-changelog format --preview
# Show what would change, don't write

# Format changelog (apply)
northstar-changelog format --write
# - Remove empty sections
# - Normalize spacing
# - Preserve content

# Extract release notes for version
northstar-changelog extract --version 0.2.4
# Output markdown for GitHub release

# Analyze unreleased changes
northstar-changelog analyze
# Output: { breaking: N, added: N, changed: N, fixed: N, suggested_bump: "minor" }
```

**Formatting rules**:

```markdown
## [Unreleased]

### Breaking
- Entry here

### Added
- Entry here

### Changed

### Fixed
- Entry here
```

Becomes:

```markdown
## [Unreleased]

### Breaking
- Entry here

### Added
- Entry here

### Fixed
- Entry here
```

(Rules: Remove empty ### Changed, normalize blank lines)

### Tool: `northstar-release`

**Purpose**: Release orchestration.

**Commands**:

```bash
# Check if ready to release
northstar-release status
# Output: { ready: true|false, blockers: [...] }

# Prepare release (interactive)
northstar-release prepare
# Runs the prepare playbook

# Execute release (after prepare approval)
northstar-release execute
# Runs the execute playbook

# Dry-run entire process
northstar-release simulate
# Show what would happen without doing it
```

## 5) Integration with Effigy

### Current Effigy scripts → Northstar tools

| Current Script | Northstar Tool | Notes |
|----------------|----------------|-------|
| `prepare-release.sh` | `northstar-release prepare` + `northstar-changelog format` | Unified command |
| `check-release-gates.sh` | `northstar-release status` | With --strict flag |
| Manual CHANGELOG editing | `northstar-changelog validate` | Prevent bad formatting |
| `generate-distribution-closeout-log.sh` | `northstar-release closeout` | Standardized output |

### Effigy task integration

```toml
# effigy.toml
[tasks.release]
# Interactive prepare
prepare = "northstar-release prepare"

# Check if ready
status = "northstar-release status"

# Execute (after prepare approved)
execute = "northstar-release execute"

# Full simulation
simulate = "northstar-release simulate"
```

## 6) AI agent instructions

### When asked to "do a release":

```
1. Run: northstar-release status
   If not ready: report blockers, stop

2. Run: northstar-changelog validate
   If invalid: report errors, stop

3. Run: northstar-changelog analyze
   Present: "Based on changelog, I recommend vX.Y.Z bump (reason)"

4. Ask human: "Proceed with vX.Y.Z? (or specify different version)"

5. Run: northstar-changelog format --preview
   Show human: "Changelog will be formatted like this..."

6. Ask human: "Format looks good? Proceed with prepare?"

7. Run: northstar-release prepare
   (Formats changelog, updates version, runs gates)

8. Present summary: changes, tests passed, commit ready

9. Ask human: "Execute release now? (creates tag vX.Y.Z)"

10. If yes: northstar-release execute
    Monitor and report progress
```

### Safety rules:

- NEVER create tag without explicit human approval
- NEVER push without showing what will be pushed
- ALWAYS validate before formatting
- ALWAYS run gates before presenting for approval
- On any failure: stop, report, ask for guidance

## 7) Template structure

### Changelog template (Northstar provides)

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).
During v0.x, MINOR bumps may include breaking changes.

## [Unreleased]

### Breaking

### Added

### Changed

### Fixed

<!-- northstar-release-notes-start -->
```

### Release config template

```toml
# northstar-release.toml
[release]
versioning = "semver"
version_source = "changelog"
control_gate = "human"

[release.version_policy]
# For v0.x: breaking -> minor, otherwise patch
# For v1.x+: breaking -> major, feat -> minor, fix -> patch
pre_1_0 = true

[release.changelog]
# Northstar Profile - strict Keep a Changelog 1.0.0
profile = "northstar"  # or "keep-a-changelog-loose" (not recommended)
categories = ["Breaking", "Added", "Changed", "Deprecated", "Removed", "Fixed", "Security"]
# Profile enforces:
# - Strict header format (## [X.Y.Z] - YYYY-MM-DD)
# - Entry format ("- description")
# - No empty sections
# - Normalized spacing

[release.gates]
scripts = [
  "cargo test",
  "cargo fmt --check",
  "./scripts/check-distribution-metadata.sh"
]

[release.channels]
github_releases = true
homebrew = { tap = "org/tap" }
crates_io = true
```

## 8) Implementation phases

### Phase 1: Changelog tool
- `northstar-changelog validate`
- `northstar-changelog format`
- `northstar-changelog analyze`

### Phase 2: Release orchestration
- `northstar-release status`
- `northstar-release prepare`
- `northstar-release execute` (manual tag for now)

### Phase 3: CI integration
- GitHub Actions workflow templates
- Auto-tag creation (optional, behind flag)
- Pipeline monitoring

### Phase 4: Advanced features
- Pre-release channels (alpha, beta)
- Multiple package support (monorepo)
- Plugin architecture for custom gates

## 9) Success criteria

- AI agent can execute full release with 3-5 human prompts (version confirm, format confirm, execute confirm)
- Empty changelog sections automatically filtered
- Changelog formatting is consistent without manual cleanup
- All existing Effigy release functionality preserved
- Migration path from current scripts to Northstar tools

## Next Task

Design the `northstar-changelog` CLI interface and data structures, then prototype the formatter that addresses the empty section and spacing issues.
