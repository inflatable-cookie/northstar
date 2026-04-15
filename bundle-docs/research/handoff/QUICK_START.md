# Quick Start for Implementation Agent

**Your mission**: Build the changelog parser/formatter library in Rust.

## Read this first (5 minutes)

1. **This brief**: `IMPLEMENTATION_BRIEF.md` - Overview of what to build
2. **Profile spec**: `../specifications/northstar-changelog-profile.md` - The format to parse

## What you're building

A Rust library that can:
- Parse Keep a Changelog + Northstar Profile
- Format (remove empty sections, normalize spacing)
- Validate (strict profile compliance)
- Suggest version bumps

## Where it lives

```
~/Dev/projects/effigy/crates/changelog/
```

**Why Effigy**: Start where it's used, extract if needed later.

## Your first task

1. Create the crate:
   ```bash
   cd ~/Dev/projects/effigy
   cargo new --lib crates/changelog
   ```

2. Look at the test fixture:
   ```bash
   cat ~/Dev/projects/effigy/CHANGELOG.md
   ```

3. Define your AST:
   ```rust
   struct Changelog {
       header: String,
       unreleased: Section,
       releases: Vec<Release>,
   }
   
   struct Section {
       categories: Vec<Category>,
   }
   
   struct Category {
       name: String,      // "Added", "Fixed", etc.
       entries: Vec<String>,
   }
   
   struct Release {
       version: String,   // "0.2.0"
       date: String,      // "2026-03-10"
       section: Section,
   }
   ```

4. Write a parser that can read the fixture.

## Test with this

Your parser should handle this:

```markdown
## [Unreleased]

### Breaking
- Breaking change

### Added
- New feature

### Fixed

## [0.2.0] - 2026-03-09

### Added
- Previous feature
```

Expected:
- `unreleased.categories` has 2 items (Breaking, Added)
- Fixed category is omitted (empty)
- `releases[0].version` = "0.2.0"

## Formatting rules

1. Remove empty sections
2. One blank line between sections
3. No trailing blank lines

Input:
```markdown
## [Unreleased]

### Breaking

### Added
- Feature


### Fixed
```

Output:
```markdown
## [Unreleased]

### Added
- Feature
```

## Version bump logic

```rust
fn suggested_bump(&self, pre_1_0: bool) -> Option<&str> {
    if self.unreleased.is_empty() {
        return None;
    }
    
    if pre_1_0 {
        // v0.x: breaking -> minor, else patch
        if !self.unreleased.breaking.is_empty() {
            Some("minor")
        } else {
            Some("patch")
        }
    } else {
        // v1.x+: breaking -> major, added -> minor, else patch
        if !self.unreleased.breaking.is_empty() {
            Some("major")
        } else if !self.unreleased.added.is_empty() {
            Some("minor")
        } else {
            Some("patch")
        }
    }
}
```

## CLI interface

```bash
# Validate
northstar-changelog validate

# Format (preview)
northstar-changelog format --preview

# Format (apply)
northstar-changelog format --write

# Analyze
northstar-changelog analyze --format=json
```

## Integration target

Replace this in `effigy.toml`:

```toml
[tasks.release]
prepare = "northstar-release prepare"
format = "northstar-changelog format --write"
validate = "northstar-changelog validate"
```

## Questions?

- Format spec: `../specifications/northstar-changelog-profile.md`
- Tool spec: `../specifications/changelog-formatter-spec.md`
- Playbook: `../translation-memos/ai-agent-release-playbook.md`
- Full brief: `IMPLEMENTATION_BRIEF.md`

## Success for first milestone

Parse Effigy's CHANGELOG.md and format it correctly.

```bash
cd ~/Dev/projects/effigy/crates/changelog
cargo test
# All tests pass using Effigy's CHANGELOG as fixture
```

**Go build it!**
