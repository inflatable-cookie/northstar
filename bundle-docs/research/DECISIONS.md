# Northstar Active Systems - Key Decisions

Status: Active  
Last Updated: 2026-03-10  

## Decision 1: Format Standard

**Decision**: Adopt Keep a Changelog 1.0.0 with a strict Northstar Profile.

**Rationale**: 
- Keep a Changelog is the de facto standard (widely recognized)
- Strict profile ensures parseability (critical for automation)
- Parseability > flexibility (consistent ecosystem > custom formats)

**Northstar Profile constraints**:
- Fixed category set: Breaking, Added, Changed, Deprecated, Removed, Fixed, Security
- Strict headers: `## [X.Y.Z] - YYYY-MM-DD`
- Entry format: List items only (`- description`)
- No empty sections
- Strict spacing

**Consequence**: 
- Projects must follow strict format or validation fails
- Formatter tool can auto-fix most issues
- 95% fit is acceptable; custom formats discouraged

---

## Decision 2: AI Agent Playbook

**Decision**: Define a clear, deterministic playbook for AI agents with human decision points.

**Playbook structure**:
1. `northstar release prepare` - Validate, analyze, format, validate gates
2. Human approves version and formatting
3. `northstar release execute` - Commit, tag, monitor
4. Human confirms execution

**Rationale**:
- Humans maintain control at key decision points
- Agents handle tedious validation and formatting
- Clear steps prevent "autonomous release" accidents
- Fits Effigy's existing human-gated approach

**Consequence**:
- Agent needs explicit human approval for version and execution
- Playbook is deterministic and testable
- Safety rules prevent accidental releases

---

## Decision 3: Changelog-First Versioning

**Decision**: Version bump is computed from changelog content, not commit messages.

**Algorithm**:
```
IF pre_1_0:
  Breaking entries → minor bump
  Other entries → patch bump
ELSE:
  Breaking → major
  Added → minor  
  Other → patch
```

**Rationale**:
- Changelog is curated for end users (better than commit messages)
- Single source of truth (changelog drives version)
- Human controls what gets released via changelog curation

**Consequence**:
- Must maintain changelog discipline
- Formatter/validator enforce format
- Version is proposed, not automatically applied

---

## Decision 4: Tool Architecture

**Decision**: Build focused tools rather than monolithic system.

**Tools**:
1. `northstar-changelog` - Validate, format, analyze, extract
2. `northstar-release` - Prepare, execute, status (orchestration)

**Rationale**:
- Unix philosophy: do one thing well
- Composable (can be used independently)
- Easier to test and maintain
- Integrates with existing scripts

**Consequence**:
- Multiple binaries instead of one
- Clear separation of concerns
- Can replace individual components

---

## Decision 5: Northstar/Effigy Boundary

**Decision**: Northstar defines contracts and formats; Effigy implements orchestration.

**Northstar**:
- Changelog Profile specification
- Validation and formatting tools
- Release phase contracts

**Effigy**:
- Task invocation (`effigy release prepare`)
- Integration with CI/CD
- Custom gate scripts

**Rationale**:
- Northstar is the "standard library" for project docs/releases
- Effigy is the "task runner" that invokes tools
- Separation allows independent evolution

**Consequence**:
- Effigy may need to adapt to Northstar contracts
- Northstar tools designed for Effigy integration
- Clear ownership of each layer

---

## Pending Decisions

### Library Placement
- **Options**: Northstar (standard library), Effigy (implementation detail), Start in Effigy extract later
- **Current thinking**: Start in Effigy, extract if needed (see changelog-library-placement.md)
- **Decision needed**: Confirm and create crate

### CI Integration
- **Options**: GitHub Actions only (start there), multiple platforms (broader)
- **Current thinking**: GitHub Actions first, design for extensibility
- **Decision needed**: Before workflow templates

### Monorepo Support
- **Options**: Single changelog (unified), per-package changelogs (changesets-style)
- **Current thinking**: Single changelog first, consider monorepo later
- **Decision needed**: After initial implementation

---

## Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-03-10 | Adopt strict Keep a Changelog profile | Parseability > flexibility |
| 2026-03-10 | AI agent playbook with human gates | Safety + automation balance |
| 2026-03-10 | Changelog-first versioning | Curated > commit-driven |
| 2026-03-10 | Focused tools over monolith | Unix philosophy |
| 2026-03-10 | Northstar contracts, Effigy orchestration | Clear separation |

---

## Next Decision Needed

**Implementation language and timeline**.

Options:
1. Rust (efficient, fits Effigy, longer dev time)
2. Python (faster dev, broader compatibility)
3. Start with Python for prototyping, port to Rust

Recommendation: Rust for production tool, given Effigy is Rust and performance matters for CLI tools.
