# Value Track Synthesis: Changelog Formats

Status: Draft  
Track: Changelog Format Standards  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Primary project tags: changelog, formatting, standards, templates

## 1) Problem statement

Changelogs serve different audiences with different needs:
- **End users** want to know what changed that affects them
- **Developers** want to understand what code changes were made
- **Downstream maintainers** want to know about breaking changes
- **Project managers** want to track progress

No single format serves all these needs perfectly. The challenge is defining a flexible standard that can be adapted while remaining consistent enough to be useful.

## 2) Why this track matters

For Northstar's changelog handler system, we need to:
1. Define a baseline format that projects can adopt
2. Support customization without fragmentation
3. Integrate with generation tools (towncrier, conventional-changelog, etc.)
4. Provide templates that guide good practices

## 3) Cross-specimen comparison

| Format/Source | Structure | Categories | Versioning | Best For | Project Signal |
|--------------|-----------|------------|------------|----------|----------------|
| **Keep a Changelog** | Date-versioned sections | Added, Changed, Deprecated, Removed, Fixed, Security | SemVer | Human-readable, general use | Strong baseline |
| **Conventional Changelog** | Type-grouped commits | feat, fix, docs, style, refactor, perf, test, build, ci | SemVer from commits | Automated generation | Good for commit-driven |
| **Towncrier** | Configurable categories | Custom (feature, bugfix, doc, etc.) | External | Fragment-driven | Good for curated entries |
| **Changesets** | Package-grouped | Custom per project | SemVer from changesets | Monorepo releases | Good for multi-package |
| **GitHub Releases** | Freeform or auto-generated | None enforced | Git tags | Quick release notes | Platform integration |

## 4) Repeated patterns

### Pattern 1: Entry Grouping

**By change type** (Keep a Changelog, conventional-changelog):
- Group entries under "Added", "Fixed", etc.
- Consistent structure across versions
- Easy to scan for specific change types

**By scope/component** (some conventional-changelog configs):
- Group by package or module
- Good for monorepos
- Harder to see all breaking changes at once

**Chronological** (minimal):
- Simple list of changes
- Easy to generate, harder to parse

### Pattern 2: Change Categorization

**Standard categories** (Keep a Changelog):
- Added, Changed, Deprecated, Removed, Fixed, Security
- Covers most needs without overwhelming

**Extended categories** (Conventional Commits):
- feat, fix, docs, style, refactor, perf, test, build, ci, chore
- More granular, but some rarely used

**Custom categories** (Towncrier, Changesets):
- Project-defined
- Flexible but inconsistent across projects

### Pattern 3: Version Entry Format

```markdown
## [version] - date
### Category
- Change description
- Another change
```

Most formats follow this pattern with variations in:
- Date format (ISO 8601 recommended)
- Version brackets (with or without links)
- Link to compare view
- Yanked release marking

## 5) Frontier signals

1. **AI-enhanced summaries**: Tools using AI to improve changelog readability
2. **Interactive changelogs**: Web-based changelogs with filtering and search
3. **Machine-readable formats**: JSON/YAML changelogs alongside Markdown
4. **Integration with package managers**: Changelogs shown at install/update time

## 6) Project implications

### Recommended direction

**Adopt Keep a Changelog 1.0.0 as the base standard, but define a strict Northstar Profile for parseability.**

Parseability > flexibility. Rather than supporting custom formats, Northstar enforces a strict subset of Keep a Changelog that can be reliably parsed.

**Northstar Profile adds these constraints**:
- Fixed category set (Breaking, Added, Changed, Deprecated, Removed, Fixed, Security)
- Strict header format: `## [X.Y.Z] - YYYY-MM-DD`
- Entry format: Must be list items (`- description`)
- No empty sections (must be omitted)
- Strict spacing (one blank line between sections)
- No freeform text outside entries

**Rationale**: 
- Line-based parsing (no full Markdown AST needed)
- Deterministic extraction (unambiguous structure)
- Still human-readable (Keep a Changelog is familiar)
- Enables reliable automation (version bump from content)

**Northstar's role**:
- Define the **Northstar Changelog Profile** specification
- Provide validator/formatter tool to enforce the profile
- Define version bump semantics from profile content

**Effigy's role**:
- Invoke validator during `qa` tasks
- Use parser for release note extraction
- Support profile in release automation

### Risks to avoid

1. **Format proliferation**: SOLVED - Single strict profile
2. **Over-prescription**: MITIGATED - Keep a Changelog is familiar, profile just tightens it
3. **Migration pain**: MITIGATED - `fix` command auto-migrates existing changelogs
4. **Too rigid for some projects**: ACCEPTED - 95% fit is good enough, custom formats discouraged

### Evidence or prototype needed

1. Validate profile against Effigy's changelog history
2. Test formatter on existing open-source changelogs
3. Verify parser handles edge cases (links, code in entries)

## 7) Source inventory

| Source | Type | Confidence | Notes |
|--------|------|------------|-------|
| keepachangelog.com | spec | High | Base standard |
| Northstar Changelog Profile | spec | High | Strict profile for parseability |

## 8) Decision state

- `promote to architecture work` - Profile defined, ready to implement
- `continue research` - Need more data on edge cases
- `prototype first` - Build validator/formatter

**Recommended**: `prototype first` - The profile is specified; build the formatter and validate against real data.

## Next Task

Design template structure for changelog formats that balances standardization with flexibility.
