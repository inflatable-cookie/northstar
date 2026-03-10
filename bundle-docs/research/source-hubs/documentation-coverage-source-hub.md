# Source Hub: Documentation Coverage and Validation Tools

Status: Active  
Owner: Research Initiative  
Last Updated: 2026-03-10  

## Code Documentation Coverage

### Coverage.py
- **Repository**: https://github.com/nedbat/coveragepy
- **Language**: Python
- **Confidence**: High
- **Notes**: Line and branch coverage measurement. Multiple output formats (text, HTML, XML, JSON, LCOV). Can produce badges.

### JaCoCo
- **Repository**: https://github.com/jacoco/jacoco
- **Language**: Java
- **Confidence**: High
- **Notes**: Standard Java code coverage. Integrates with Maven/Gradle.

### Istanbul/nyc
- **Repository**: https://github.com/istanbuljs/nyc
- **Language**: JavaScript
- **Confidence**: High
- **Notes**: JavaScript code coverage. Integrates with most test runners.

## Documentation-Specific Tools

### Vale
- **Repository**: https://github.com/errata-ai/vale
- **Language**: Go
- **Confidence**: High
- **Notes**: Prose linter for documentation. Style guide enforcement. Highly configurable.

### Markdownlint
- **Repository**: https://github.com/DavidAnson/markdownlint
- **Language**: JavaScript
- **Confidence**: High
- **Notes**: Markdown linting. Enforces consistent formatting.

### linkchecker
- **Repository**: https://github.com/linkchecker/linkchecker
- **Language**: Python
- **Confidence**: Medium
- **Notes**: Checks for broken links in documentation.

### lychee
- **Repository**: https://github.com/lycheeverse/lychee
- **Language**: Rust
- **Confidence**: Medium
- **Notes**: Fast link checker. GitHub Actions integration.

## Documentation Generators with Coverage

### Sphinx
- **URL**: https://www.sphinx-doc.org/
- **Language**: Python
- **Confidence**: High
- **Notes**: ext.autodoc for API docs. coverage extension for docstring coverage.

### MkDocs
- **URL**: https://www.mkdocs.org/
- **Language**: Python
- **Confidence**: High
- **Notes**: Markdown-based. Plugins for validation.

### TypeDoc
- **URL**: https://typedoc.org/
- **Language**: TypeScript
- **Confidence**: High
- **Notes**: TypeScript documentation generator.

## What "Documentation Coverage" Means

1. **API Coverage**: Are all public functions/classes documented?
2. **Code Coverage**: Are there tests covering the code?
3. **Link Validity**: Are all internal/external links working?
4. **Style Consistency**: Does documentation follow style guides?
5. **Structural Completeness**: Are required sections present?

## Key Questions This Source Map Should Answer

1. What aspects of documentation should Northstar validate?
2. How can coverage be measured without being overly prescriptive?
3. What is the relationship between code coverage and documentation coverage?
4. How do we integrate with existing tools vs build new ones?

## Related Specimen Dossiers

- `../specimen-dossiers/vale.md`
- `../specimen-dossiers/sphinx-coverage.md`
