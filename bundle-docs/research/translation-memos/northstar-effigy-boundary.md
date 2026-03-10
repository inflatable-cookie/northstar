# Translation Memo: Northstar-Effigy Boundary for Active Systems

Status: Draft  
Memo: Architecture Recommendations for Release Management, Changelogs, README Generation, and Doc Coverage  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Related track: Release Management Spectrum, Changelog Formats

## 1) Project problem statement

Northstar is evolving from a static documentation template system to an "active stance" with tooling for:
- Reusable release management
- Changelog handling
- Documentation coverage checks
- Standardised README generation

The fundamental architectural question is: **What belongs in Northstar (definitions/templates) vs what belongs in Effigy (implementation/invocation)?**

Depending on context, there's an argument for implementing features in either project. We need clear boundaries that:
- Keep Northstar focused on standards and templates
- Let Effigy handle orchestration and tool invocation
- Allow flexibility without fragmentation

## 2) External evidence summary

From the specimen dossiers and value tracks:

1. **Release management tools** (semantic-release, release-please, changesets) each solve different problems on the automation spectrum. None are perfect fits for all projects.

2. **Changelog formats** have converged on Keep a Changelog as a baseline, with variations for specific needs.

3. **Successful tools separate concerns**: Towncrier does changelog generation, not versioning. Changesets does versioning, not publishing. Semantic-release does everything but requires commit discipline.

4. **Template-driven approaches** (changesets' config, towncrier's types) provide flexibility while maintaining structure.

5. **Platform integration** (GitHub Actions, PRs) is increasingly central to workflows.

## 3) Recommendation

### Core principle: Northstar defines contracts, Effigy implements orchestration

**Northstar's responsibilities**:
1. Define release phase contracts (what needs to happen, not how)
2. Provide template structures for changelogs, READMEs, release configurations
3. Define validation criteria for documentation coverage
4. Specify format standards (Keep a Changelog baseline)

**Effigy's responsibilities**:
1. Discover and invoke appropriate tools for each phase
2. Orchestrate multi-phase workflows
3. Integrate with CI/CD systems
4. Provide hooks for custom steps

### Specific boundaries

| Feature | Northstar | Effigy | Notes |
|---------|-----------|--------|-------|
| **Changelog format** | Define baseline (Keep a Changelog) | Validate format | Templates in Northstar |
| **Changelog generation** | Template for tool configs | Invoke towncrier/conventional-changelog | Config in project |
| **Release phases** | Define standard phases | Orchestrate execution | Contract between them |
| **Version bumping** | Template for approach | Invoke appropriate tool | Could be changesets, release-please, etc. |
| **README structure** | Define standard sections | Generate from template | Templates customizable |
| **README badges** | Define badge categories | Fetch/generate badges | Shields.io integration |
| **Doc coverage** | Define coverage dimensions | Run coverage checks | Integration with vale, etc. |
| **Validation rules** | Define what to check | Execute checks | Contract-based |

### Template flexibility model

To avoid "a mess of configuration" while supporting flexibility:

1. **Tiered templates**:
   - **Core templates**: Required sections, minimal configuration
   - **Extended templates**: Additional sections for common patterns
   - **Custom templates**: Project-defined, must declare base format version

2. **Template composition**:
   - Templates can include/extend other templates
   - Variables for project-specific values
   - Conditional sections based on project type

3. **Validation**:
   - Northstar validates template structure
   - Effigy validates template execution
   - Both can warn on drift from standards

### Release flow flexibility

The release system should be "rigid at certain points, flexible at others":

**Rigid (standardized)**:
- Phase ordering (prepare → review → publish → notify)
- Changelog format compliance
- Version scheme (SemVer)

**Flexible (project-defined)**:
- Which tools perform each phase
- Human review gates (required or not)
- Pre-release channels
- Notification targets

This is achieved through a **release contract** defined in Northstar format but implemented via Effigy tasks.

## 4) Tradeoffs the project would accept

1. **Integration complexity over feature duplication**: Rather than building new tools, accept the complexity of integrating existing ones.

2. **Configuration verbosity over magic**: Explicit configuration is better than implicit behavior that's hard to debug.

3. **Opinionated defaults over infinite flexibility**: Provide strong defaults that work for 80% of projects.

4. **GitHub-centric initial support over universal support**: Focus on GitHub integration first, design for extensibility to other platforms.

## 5) What must be true before adoption

1. **Prototype validation**: Build proof-of-concept integrations with:
   - One commit-driven tool (release-please)
   - One fragment-driven tool (towncrier)
   - One hybrid approach (changesets)

2. **Template design**: Design and test the template structure for:
   - Changelog formats
   - README generation
   - Release configuration

3. **Boundary testing**: Verify the Northstar/Effigy contract works in practice

4. **Documentation**: Document the boundaries clearly for contributors

## 6) Required prototype or validation work

### Prototype 1: Changelog template system
- Design template structure for Keep a Changelog + custom sections
- Implement validation in Effigy
- Test with 2-3 real projects

### Prototype 2: Release phase contract
- Define release phase contract in Northstar format
- Implement phase orchestration in Effigy
- Integrate with one existing tool (towncrier or release-please)

### Prototype 3: README generation
- Design README template with standard sections
- Implement badge generation
- Test flexibility with different project types

## 7) Promotion target

- `architecture work` - Define contracts and boundaries
- `roadmap planning` - Schedule prototypes
- `watch only` - Continue observing ecosystem
- `reject` - Don't pursue this direction

**Recommendation**: `roadmap planning` - The direction is sound, now plan the prototypes.

## 8) Sources

| Source | Confidence | Notes |
|--------|------------|-------|
| Release Management Spectrum value track | High | Comparison of approaches |
| Changelog Formats value track | High | Format analysis |
| Changesets specimen dossier | High | Explicit control approach |
| Semantic Release specimen dossier | High | Automated approach |
| Release Please specimen dossier | High | Review gate approach |
| Towncrier specimen dossier | High | Fragment-driven approach |

## Next Task

Present these recommendations to stakeholders and, if approved, create roadmap milestones for the three prototypes.
