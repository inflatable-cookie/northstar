# Specification: Northstar Changelog Profile

Status: Draft  
Spec: Strict, parseable Keep a Changelog profile  
Owner: Research Initiative  
Last Updated: 2026-03-10  

## 1) Design principle

**Adopt a common standard, enforce strict parseability.**

Rather than supporting custom formats that fragment the ecosystem, Northstar adopts **Keep a Changelog 1.0.0** as the base standard and defines a **strict profile** that ensures consistent parsing.

The profile adds constraints to Keep a Changelog that make it machine-parseable while remaining human-readable and widely recognized.

## 2) Base standard

**Keep a Changelog 1.0.0** (https://keepachangelog.com/en/1.0.0/)

Principles we keep:
- Changelogs are for humans, not machines
- One entry per version
- Group changes by type (Added, Changed, Deprecated, Removed, Fixed, Security)
- Versions and sections should be linkable
- Latest version comes first

## 3) Northstar profile constraints

To ensure parseability, the Northstar profile adds these constraints:

### C1: Fixed category set

Only these categories are allowed (case-sensitive):
- `Breaking` (Northstar addition - treated as "Changed" for Keep a Changelog compatibility)
- `Added`
- `Changed`
- `Deprecated`
- `Removed`
- `Fixed`
- `Security`

Rationale: Fixed set enables reliable parsing without natural language processing.

### C2: Strict header format

Unreleased header:
```markdown
## [Unreleased]
```

Version headers:
```markdown
## [MAJOR.MINOR.PATCH] - YYYY-MM-DD
```

Date must be ISO 8601 (`YYYY-MM-DD`). No variations.

Rationale: Strict regex-parsable format.

### C3: Entry format

Entries must be list items:
```markdown
- Description of change
- Another change with [link](url)
```

- Must start with `- ` or `* `
- One entry per line (no wrapping - long lines OK)
- Freeform text allowed after `- `

Rationale: Unambiguous entry boundaries.

### C4: No empty sections

Categories with no entries must be omitted.

```markdown
## [Unreleased]

### Added
- New feature

### Fixed
- Bug fix
```

Not:
```markdown
## [Unreleased]

### Breaking

### Added
- New feature

### Changed

### Fixed
- Bug fix
```

Rationale: Empty sections add noise and complicate parsing.

### C5: Strict spacing

- Exactly one blank line between category sections
- No blank lines between entries within a category
- No trailing blank lines at end of file

```markdown
## [Unreleased]

### Added
- First feature
- Second feature

### Fixed
- Bug fix

## [0.2.0] - 2026-03-09
```

Rationale: Consistent structure enables simple line-based parsing.

### C6: Forbidden content

Not allowed in the changelog:
- Freeform text outside of list entries
- Nested headers (### beyond categories)
- HTML comments (except at top for tools)
- Multiple changelogs in one file

Rationale: Prevents ambiguity in parsing.

## 4) Complete example

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Breaking
- Shell execution now uses non-login shell (`sh -c`) instead of login shell (`sh -lc`)

### Added
- New GitHub Action `setup-effigy` for CI installation
- ARM Linux support for AWS Graviton and Docker on Apple Silicon

### Fixed
- PATH clobbering on Linux with login shells
- Release pipeline failure from secrets context usage

## [0.2.0] - 2026-03-09

### Breaking
- Change process spawn from login shell to non-login shell

### Added
- CI workflow with format, clippy, and test jobs
- Release binaries workflow for cross-platform distribution

### Changed
- Rename test fixture catalogs to generic names

### Fixed
- Resolve 5 pre-existing clippy warnings

## [0.1.0] - 2026-02-26

### Added
- Initial release with task runner core
- Built-in commands: tasks, doctor, test, watch
```

## 5) Parser requirements

A compliant parser must be able to:

1. **Extract unreleased changes by category**
   ```rust
   changelog.unreleased.added // Vec<String>
   changelog.unreleased.fixed // Vec<String>
   ```

2. **List all versions in order**
   ```rust
   changelog.versions[0].version // "0.2.0"
   changelog.versions[0].date    // "2026-03-09"
   ```

3. **Extract specific version's changes**
   ```rust
   changelog.get_version("0.2.0").added
   ```

4. **Determine version bump from unreleased**
   ```rust
   changelog.suggested_bump() // "major", "minor", or "patch"
   ```

5. **Format consistently**
   ```rust
   changelog.to_string() // Normalized output
   ```

## 6) CLI tool specification

```bash
# Validate against Northstar profile
northstar-changelog validate
# Exit 0: Compliant
# Exit 1: Violations with line numbers

# Format (normalize spacing, remove empty sections)
northstar-changelog format [--write|--preview]

# Analyze for version bump
northstar-changelog analyze --format=json
# {
#   "unreleased": {
#     "breaking": ["..."],
#     "added": ["..."],
#     "fixed": ["..."]
#   },
#   "suggested_bump": "minor",
#   "is_empty": false
# }

# Extract version for release notes
northstar-changelog extract --version 0.2.0
# Outputs markdown for that version only

# Fix common issues automatically
northstar-changelog fix [--write|--preview]
# - Removes empty sections
# - Normalizes spacing
# - Sorts categories to standard order
```

## 7) Migration from loose Keep a Changelog

The `northstar-changelog fix` command migrates existing changelogs:

| Issue | Fix |
|-------|-----|
| Empty sections | Remove |
| Extra spacing | Normalize |
| Wrong date format | Convert to YYYY-MM-DD |
| Unknown categories | Warn (require manual fix) |
| Freeform text | Warn (require manual fix) |
| Wrong case (### ADDED) | Convert to ### Added |

## 8) Version bump semantics

For SemVer with the Northstar profile:

```
IF pre_1_0:
  IF unreleased.breaking NOT empty → minor
  ELSE IF any other entries → patch
  ELSE → none (no release needed)
ELSE (post 1.0):
  IF unreleased.breaking NOT empty → major
  ELSE IF unreleased.added NOT empty → minor
  ELSE IF any entries → patch
  ELSE → none
```

This is deterministic and parseable.

## 9) Validation rules summary

```rust
enum ValidationError {
    MissingUnreleasedSection,
    InvalidVersionHeader { line: usize, found: String },
    InvalidDateFormat { line: usize, found: String },
    UnknownCategory { line: usize, found: String },
    EmptyCategory { line: usize, category: String },
    MalformedEntry { line: usize },
    InvalidSpacing { line: usize, issue: String },
    TrailingBlankLines,
}
```

## 10) Why this profile?

### Parseability benefits

- **Line-based parsing**: No need for full Markdown AST
- **Regex-extractable headers**: `^## \[([\d.]+)\] - (\d{4}-\d{2}-\d{2})$`
- **Deterministic categories**: Fixed set, no NLP needed
- **Clear entry boundaries**: Start with `- `, end at next `- ` or `###` or `##`

### Human benefits

- **Familiar**: Keep a Changelog is widely known
- **Clean**: No empty sections, consistent spacing
- **Readable**: Standard category order
- **Writable**: Simple format, no special syntax

### Tool benefits

- **Reliable extraction**: Get release notes programmatically
- **Version automation**: Compute bump from content
- **CI validation**: Fail build if format wrong
- **Formatting**: Auto-fix common issues

## 11) Comparison with alternatives

| Format | Parseability | Familiarity | Flexibility | Northstar Choice |
|--------|-------------|-------------|-------------|------------------|
| Keep a Changelog (loose) | Poor | High | High | Base only |
| **Keep a Changelog + Northstar Profile** | **Excellent** | **High** | **Constrained** | **✓ Adopted** |
| Conventional Changelog | Good | Medium | Low | Supported as input |
| Changeset fragments | Excellent | Low | Medium | Supported as source |
| Custom formats | Variable | Low | High | Not supported |

## 12) Adoption path

1. **Define the profile** (this document) ✓
2. **Implement validator/formatter** (tool spec)
3. **Test against real changelogs** (Effigy's history)
4. **Document for users** (migration guide)
5. **CI enforcement** (format check in CI)

## 13) Exceptions and escapes

For projects that absolutely need different formats:

```toml
# northstar.toml
[changelog]
profile = "custom"
parser = "./custom-changelog-parser.py"
```

But this is discouraged. The profile is designed to work for 95% of projects.

## Next step

Implement the validator/formatter tool against this profile specification.
