# Northstar Active Systems Research

Purpose: research the evolution of Northstar from a static documentation template system to a more active stance with reusable tooling for release management, changelog handling, documentation coverage, and README generation.

## Scope

This research initiative covers four feature areas:

1. **Reusable Release Management** - Systems for automating version bumps, releases, and publication
2. **Changelog Handler System** - Tools for updating, formatting, and maintaining changelogs
3. **Documentation Coverage Checks** - Validating completeness and consistency of documentation
4. **Standardised README Generation** - Template-driven README creation and maintenance

## Refined Direction

Based on analysis of Effigy's existing system and researched tools:

**Primary use case**: AI agent executes releases following a changelog-first, human-gated playbook.

**Key principles**:
- **Adopt a common, parseable standard** - Keep a Changelog 1.0.0 + Northstar Profile
- Changelog is source of truth for version bumps
- Human approves at key decision points (version, formatting, execution)
- Tools do the heavy lifting (validation, formatting, computation)
- Simple playbook that agents can follow deterministically

**Format decision**: Adopt Keep a Changelog 1.0.0 with a strict Northstar Profile that ensures parseability. Parseability > flexibility.

**Immediate priorities**:
1. Northstar Changelog Profile spec (strict Keep a Changelog subset)
2. Changelog formatter tool (enforce profile, fix formatting)
3. Release preparation tool (analyze changes, propose version)
4. AI agent playbook (clear steps with human decision points)

## Key Questions

- Where should functionality live between Northstar (definitions/templates) and Effigy (implementation/invocation)?
- How can we support user-defined templates without becoming a mess of configuration?
- What tooling is needed to support AI agent release execution?
- How do we preserve human control while automating the tedious parts?

## Structure

- `source-hubs/` - Curated source maps for each feature area
- `specimen-dossiers/` - Detailed studies of specific tools and systems
- `value-tracks/` - Cross-specimen syntheses by problem area
- `translation-memos/` - Project-facing recommendations

## Research Principles

1. Start with problems, not product wishlists
2. Gather primary sources before secondary commentary
3. Record strengths, chronic failures, and between-version corrections
4. Convert findings into project implications only after cross-specimen comparison
5. Promote stable conclusions into architecture or roadmaps only when specific enough to constrain design

## Operating Model

See `template-bundle/research/README.md` for the base research workflow.

This research uses the same promotion rules but adds a specific constraint:
- Any recommendation must explicitly address the Northstar/Effigy boundary question
- Template flexibility must be demonstrated with concrete examples, not assumed

## Next Task

Read the source hubs to understand the landscape, then review specimen dossiers for detailed comparisons.
