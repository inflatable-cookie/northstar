# Specification: Northstar Changelog Formatter

Status: Draft  
Spec: Changelog formatting and validation tool  
Owner: Research Initiative  
Last Updated: 2026-03-10  

## 1) Purpose

Implement the **Northstar Changelog Profile** - a strict, parseable Keep a Changelog format.

Implements:
- Parsing and validation of the profile
- Formatting (remove empty sections, normalize spacing)
- Analysis (version bump suggestion)
- Extraction (release notes)

See: [Northstar Changelog Profile](northstar-changelog-profile.md)

## 2) Input format

Valid Keep a Changelog with potential formatting issues:

```markdown
# Changelog

All notable changes...

## [Unreleased]

### Breaking

### Added
- Something new


### Changed

### Fixed
- Bug fix

## [0.2.0] - 2026-03-09

### Added
- Previous feature
```

Issues present:
- Empty ### Breaking section
- Empty ### Changed section
- Extra blank line after ### Added
- Inconsistent spacing

## 3) Output format

Clean, normalized changelog:

```markdown
# Changelog

All notable changes...

## [Unreleased]

### Added
- Something new

### Fixed
- Bug fix

## [0.2.0] - 2026-03-09

### Added
- Previous feature
```

## 4) Formatting rules

### Rule: Remove empty sections

A section is empty if it has no list items (`- ` or `* `) before the next `### ` or `## `.

```markdown
### Breaking      ← Remove (no entries)

### Added         ← Keep (has entries)
- Feature 1

### Changed       ← Remove (no entries)
```

### Rule: Normalize spacing

- Exactly one blank line between sections
- No blank lines at end of file (single newline)
- No leading blank lines after `## [Version]`

```markdown
## [Unreleased]

### Added
- Entry

### Fixed       ← One blank line before
- Entry
```

### Rule: Preserve content

- Keep all list items exactly as written
- Keep link references
- Keep freeform text in entries
- Keep sub-lists and formatting

### Rule: Category ordering

Standard order (configurable):
1. Breaking
2. Added
3. Changed
4. Deprecated
5. Removed
6. Fixed
7. Security

Categories present but empty → removed  
Categories not present → not added  
Categories with entries → kept in order

## 5) CLI interface

```bash
northstar-changelog validate [file]
  Exit 0: Valid changelog
  Exit 1: Format errors (print to stderr)
  Checks:
    - Has [Unreleased] section
    - Known categories only
    - Entries follow list format
    - Version headers follow pattern ## [X.Y.Z] - YYYY-MM-DD

northstar-changelog format [file] [--write|--preview]
  --preview: Print formatted version to stdout
  --write: Update file in place (with backup)
  Default: --preview

northstar-changelog analyze [file]
  Output JSON:
  {
    "unreleased": {
      "breaking": ["entry1", "entry2"],
      "added": ["entry3"],
      "changed": [],
      "fixed": ["entry4"]
    },
    "counts": {
      "breaking": 2,
      "added": 1,
      "changed": 0,
      "fixed": 1
    },
    "suggested_bump": "minor",
    "is_empty": false
  }

northstar-changelog extract [file] --version X.Y.Z
  Output markdown for that version section
  (for GitHub release notes)
```

## 6) Implementation notes

### Parser approach

Line-based state machine:

```rust
enum State {
    Header,           // # Changelog
    UnreleasedHeader, // ## [Unreleased]
    VersionHeader,    // ## [X.Y.Z] - date
    CategoryHeader,   // ### Category
    Entry,            // - entry text
    Blank,            // empty line
}
```

### Data structure

```rust
struct Changelog {
    header: String,           // Prologue text
    unreleased: Section,
    releases: Vec<Release>,
}

struct Section {
    categories: Vec<Category>,
}

struct Category {
    name: String,             // "Added", "Fixed", etc.
    entries: Vec<String>,     // Raw entry text (without "- ")
}

struct Release {
    version: String,
    date: String,
    section: Section,
}
```

### Formatting algorithm

```rust
fn format_changelog(changelog: Changelog) -> String {
    let mut output = String::new();
    
    // Header
    output.push_str(&changelog.header);
    output.push_str("\n\n");
    
    // Unreleased
    output.push_str("## [Unreleased]\n");
    output.push_str(&format_section(&changelog.unreleased));
    
    // Releases
    for release in &changelog.releases {
        output.push_str("\n## [");
        output.push_str(&release.version);
        output.push_str("] - ");
        output.push_str(&release.date);
        output.push('\n');
        output.push_str(&format_section(&release.section));
    }
    
    output
}

fn format_section(section: &Section) -> String {
    let mut output = String::new();
    
    for category in &section.categories {
        // Skip empty categories
        if category.entries.is_empty() {
            continue;
        }
        
        output.push('\n');
        output.push_str("### ");
        output.push_str(&category.name);
        output.push('\n');
        
        for entry in &category.entries {
            output.push_str("- ");
            output.push_str(entry);
            output.push('\n');
        }
    }
    
    output
}
```

## 7) Error handling

### Validation errors

```
Error: Invalid changelog format

 Line 12: Unknown category "### Misc"
          Expected: Breaking, Added, Changed, Fixed

 Line 23: Malformed version header
          Expected: ## [X.Y.Z] - YYYY-MM-DD
          Got: ## 0.2.0 - March 9, 2026
```

### Recovery

On format error:
1. Report specific line and issue
2. Suggest fix
3. Exit 1 (don't write partial output)

## 8) Testing

### Test cases

1. **Empty sections removed**: Input with empty ### Breaking → output without it
2. **Spacing normalized**: Multiple blank lines → single blank line
3. **Content preserved**: Complex entries with links/code unchanged
4. **Order maintained**: Categories stay in standard order
5. **Validation catches**: Unknown categories, malformed headers

### Example test

```rust
#[test]
fn removes_empty_sections() {
    let input = r#"## [Unreleased]

### Breaking

### Added
- Feature
"#;

    let expected = r#"## [Unreleased]

### Added
- Feature
"#;

    let changelog = parse(input).unwrap();
    let formatted = format(&changelog);
    assert_eq!(formatted, expected);
}
```

## 9) Integration

### With prepare-release flow

```bash
# Before: update version and move section
# After: format the result

northstar-changelog format CHANGELOG.md --write
```

### With CI

```yaml
- name: Validate changelog
  run: northstar-changelog validate

- name: Check formatting
  run: |
    northstar-changelog format --preview > formatted.md
    diff -u CHANGELOG.md formatted.md || {
      echo "Changelog needs formatting. Run: northstar-changelog format --write"
      exit 1
    }
```

## 10) Next steps

1. Implement parser (Rust or Python)
2. Add comprehensive tests
3. Integrate with Effigy's prepare-release.sh
4. Validate against Effigy's CHANGELOG.md history

## Appendix: Full example

### Input

```markdown
# Changelog

All notable changes...

## [Unreleased]

### Breaking

### Added
- New feature


### Changed

### Fixed
- Fixed bug

## [0.2.0] - 2026-03-09

### Added
- Old feature
```

### Output

```markdown
# Changelog

All notable changes...

## [Unreleased]

### Added
- New feature

### Fixed
- Fixed bug

## [0.2.0] - 2026-03-09

### Added
- Old feature
```
