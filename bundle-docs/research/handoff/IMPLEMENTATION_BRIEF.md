# Northstar Active Systems - Implementation Handoff Brief

**Status**: Ready for implementation  
**Research completed**: 2026-03-10  
**Handoff to**: Implementation agent  

---

## Executive Summary

This research initiative defined a **changelog-first, human-gated release management system** for the Northstar/Effigy ecosystem. The goal is to enable AI agents to execute releases with human approval at key decision points.

**Key outcome**: A strict, parseable Keep a Changelog profile and Rust library specification.

---

## What Was Researched

### 1. Existing Release Management Tools

Analyzed 4 major approaches:

| Tool | Approach | Automation | Best For |
|------|----------|------------|----------|
| **Semantic Release** | Commit-driven | Maximum | Disciplined teams |
| **Release Please** | Commit-driven | High | Review-gated teams |
| **Changesets** | Fragment-driven | Medium | Complex monorepos |
| **Towncrier** | Fragment-driven | Low | Language-agnostic |

**Finding**: None fit Effigy's existing workflow well. Effigy uses a custom **changelog-first, human-gated** approach.

### 2. Effigy's Current System

Analyzed Effigy's production release flow:
- `prepare-release.sh` - Analyzes CHANGELOG, computes version, updates files
- `check-release-gates.sh` - Comprehensive validation
- `release-binaries.yml` - CI pipeline (tag-triggered)
- Multi-channel: GitHub Releases, Homebrew, crates.io
- Human checklist with evidence logging

**Key insight**: This is a valid third pattern that should be supported.

### 3. Changelog Formats

**Decision**: Adopt Keep a Changelog 1.0.0 with a **strict Northstar Profile** for parseability.

**Parseability > flexibility** - consistent ecosystem beats custom formats.

---

## Key Decisions

### Decision 1: Northstar Changelog Profile

Strict subset of Keep a Changelog:
- Fixed categories: Breaking, Added, Changed, Deprecated, Removed, Fixed, Security
- Strict headers: `## [X.Y.Z] - YYYY-MM-DD`
- Entry format: List items only (`- description`)
- No empty sections (must be omitted)
- Strict spacing

**Why**: Enables reliable parsing without NLP. Line-based parser sufficient.

### Decision 2: AI Agent Playbook

Human-in-the-loop with clear decision points:
1. Agent proposes version based on changelog analysis
2. Human approves version
3. Agent shows formatted changelog
4. Human approves formatting
5. Agent runs gates
6. Human confirms "execute release"
7. Agent commits, tags, monitors

**Safety**: Never create tag without explicit approval.

### Decision 3: Library Placement

**Start in Effigy, extract if needed.**

Create `effigy/crates/effigy-changelog` (or `crates/changelog`).

If other projects need it later, extract to Northstar as `northstar-changelog`.

**Rationale**: YAGNI. Build for one consumer, extract when demand exists.

---

## What Needs to Be Built

### Component 1: Changelog Library (`effigy-changelog`)

**Location**: `effigy/crates/changelog/` or `effigy/crates/effigy-changelog/`

**Responsibilities**:
- Parse Keep a Changelog + Northstar Profile
- Format (remove empty sections, normalize spacing)
- Validate (strict profile compliance)
- Analyze (suggest version bump)
- Extract (release notes for specific version)

**Public API** (suggested):

```rust
// Parse
let changelog = Changelog::parse(content)?;

// Validate
changelog.validate()?; // Returns Vec<ValidationError>

// Format
let formatted = changelog.format();

// Analyze
let analysis = changelog.analyze(); // { breaking: 2, added: 1, suggested_bump: "minor" }

// Extract version
let notes = changelog.extract_version("0.2.0");

// Version bump suggestion
let bump = changelog.suggested_bump(pre_1_0: true); // "minor" | "patch" | "none"
```

**CLI interface**:

```bash
# Validate
northstar-changelog validate [file]
# Exit 0: Compliant, Exit 1: Violations with line numbers

# Format
northstar-changelog format [file] [--write|--preview]
# --preview: Print to stdout, --write: Update in place

# Analyze
northstar-changelog analyze [file] --format=json
# { "unreleased": {...}, "suggested_bump": "minor", "is_empty": false }

# Extract
northstar-changelog extract [file] --version 0.2.0
# Outputs markdown for that version
```

### Component 2: Release Orchestration

**Location**: `effigy/crates/effigy-release/` (optional) or integrate into main effigy

**Responsibilities**:
- Prepare release (validate, analyze, format, run gates)
- Execute release (commit, tag, monitor)
- Status check (are we ready?)

**CLI interface**:

```bash
# Check if ready
northstar-release status
# { ready: true, blockers: [] }

# Prepare (interactive)
northstar-release prepare
# 1. Validate changelog
# 2. Analyze changes, propose version
# 3. Ask human for version approval
# 4. Format changelog
# 5. Ask human for formatting approval
# 6. Run gates
# 7. Present summary, ask "execute?"

# Execute (after prepare approved)
northstar-release execute
# 1. Commit changes
# 2. Create tag
# 3. Push
# 4. Monitor CI

# Dry run
northstar-release simulate
# Show what would happen
```

### Component 3: Effigy Integration

**Tasks in `effigy.toml`**:

```toml
[tasks]
# Check if ready to release
"release:status" = "northstar-release status"

# Prepare release (interactive)
"release:prepare" = "northstar-release prepare"

# Execute release (after prepare)
"release:execute" = "northstar-release execute"

# Full simulation
"release:simulate" = "northstar-release simulate"

# Format changelog
"changelog:format" = "northstar-changelog format --write"

# Validate changelog
"changelog:check" = "northstar-changelog validate"
```

---

## Implementation Order

### Phase 1: Changelog Parser (Week 1)

1. Create `crates/changelog` in Effigy repo
2. Define AST types (Changelog, Release, Category, Entry)
3. Implement line-based parser
4. Add tests using Effigy's CHANGELOG.md as fixtures
5. Implement `parse()` and `to_string()` roundtrip

**Success criteria**:
- Parses Effigy's entire CHANGELOG.md history
- Roundtrip: parse → to_string produces equivalent content
- Handles all edge cases (links, code blocks in entries)

### Phase 2: Formatter (Week 1-2)

1. Implement formatting rules
2. Remove empty sections
3. Normalize spacing
4. Add `--preview` and `--write` modes
5. Backup original on `--write`

**Success criteria**:
- `northstar-changelog format --write` cleans up Effigy's CHANGELOG
- Empty sections removed
- Spacing normalized
- No content lost

### Phase 3: Validator (Week 2)

1. Implement profile validation
2. Check category names
3. Check header formats
4. Check spacing
5. Report errors with line numbers

**Success criteria**:
- Catches malformed changelogs
- Clear error messages
- Exit codes for CI use

### Phase 4: Analyzer (Week 2)

1. Count entries per category
2. Implement version bump logic
3. JSON output for scripting

**Success criteria**:
- Correctly suggests bump from Effigy changelogs
- JSON output parseable by CI

### Phase 5: Integration (Week 3)

1. Add to `effigy.toml` tasks
2. Integrate into `prepare-release.sh` (or replace it)
3. Add to CI (validate changelog format)
4. Update release playbook documentation

**Success criteria**:
- `effigy changelog:format` works
- `effigy release:prepare` uses the library
- CI validates changelog on PRs

### Phase 6: Release Orchestration (Week 4+)

1. Build `northstar-release` CLI
2. Implement prepare/execute workflow
3. Human prompts and safety checks
4. Integration with existing gate scripts

**Success criteria**:
- AI agent can execute full playbook
- Human approval at each decision point
- No accidental releases

---

## Reference Documents

### Specifications
- `specifications/northstar-changelog-profile.md` - Strict Keep a Changelog profile
- `specifications/changelog-formatter-spec.md` - Formatter tool specification

### Research
- `specimen-dossiers/effigy-release-system.md` - Analysis of Effigy's current approach
- `value-tracks/release-management-spectrum.md` - Comparison of tools
- `value-tracks/changelog-formats.md` - Format analysis and decision

### Memos
- `translation-memos/ai-agent-release-playbook.md` - Agent playbook with human gates
- `translation-memos/changelog-library-placement.md` - Library placement decision
- `translation-memos/northstar-effigy-boundary.md` - General boundary recommendations
- `translation-memos/northstar-effigy-integration.md` - Integration strategy

### Quick Reference
- `DECISIONS.md` - Key decisions log
- `master-index.md` - Full navigation

---

## Getting Started

### 1. Read the profile spec

Start with: `specifications/northstar-changelog-profile.md`

This defines the format the library must parse.

### 2. Look at Effigy's changelog

```bash
cat /Users/betterthanclay/Dev/projects/effigy/CHANGELOG.md
```

This is your primary test fixture.

### 3. Understand current scripts

```bash
# Read these scripts
cat /Users/betterthanclay/Dev/projects/effigy/scripts/prepare-release.sh
cat /Users/betterthanclay/Dev/projects/effigy/scripts/check-release-gates.sh
```

These show the current flow the library will support.

### 4. Create the crate

```bash
cd /Users/betterthanclay/Dev/projects/effigy
cargo new --lib crates/changelog
```

### 5. First test

Parse Effigy's CHANGELOG.md and print the unreleased entries.

---

## Open Questions for Implementation

1. **Crate name**: `changelog`, `effigy-changelog`, or `northstar-changelog`?
   - Suggestion: `changelog` (simple, clear)

2. **CLI binary name**: `northstar-changelog` or `effigy-changelog`?
   - Suggestion: `northstar-changelog` (follows profile name)

3. **Error handling**: `thiserror` or custom?
   - Suggestion: `thiserror` for library, `anyhow` for CLI

4. **CLI framework**: `clap` derive or builder?
   - Suggestion: `clap` derive (standard, maintainable)

5. **Parser**: hand-written state machine or parser combinator?
   - Suggestion: hand-written (simple format, better error messages)

---

## Success Criteria

### Minimum Viable
- [ ] Parser handles all of Effigy's changelog history
- [ ] Formatter removes empty sections and fixes spacing
- [ ] Validator catches format errors
- [ ] Integrated into `effigy.toml` tasks

### Full Implementation
- [ ] AI agent can run `effigy release:prepare` end-to-end
- [ ] Human approval at each decision point
- [ ] No accidental releases possible
- [ ] CI validates changelog on PRs
- [ ] Documentation updated

---

## Contact

Research completed by: Northstar Research Initiative  
Questions about spec: See `specifications/northstar-changelog-profile.md`  
Questions about decisions: See `DECISIONS.md`  
Questions about playbook: See `translation-memos/ai-agent-release-playbook.md`

---

**Next step**: Create the `crates/changelog` directory and start with the parser.
