# Northstar Active Systems Research - Complete Index

**Status**: Release/changelog research ready; later translation tracks active
**Location**: `bundle-docs/research/`

---

## Release and changelog implementation (start here)

| Document | Purpose | Read Time |
|----------|---------|-----------|
| `handoff/QUICK_START.md` | 5-minute primer for implementation agent | 5 min |
| `handoff/IMPLEMENTATION_BRIEF.md` | Complete implementation guide | 20 min |

**After reading handoff**:
| Document | Purpose |
|----------|---------|
| `specifications/northstar-changelog-profile.md` | The format to implement |
| `specifications/changelog-formatter-spec.md` | Tool specification |

---

## All Documents

### Handoff (for implementation agent)
- `handoff/QUICK_START.md` - Quick primer
- `handoff/IMPLEMENTATION_BRIEF.md` - Full implementation guide

### Specifications
- `specifications/northstar-changelog-profile.md` - Strict Keep a Changelog profile
- `specifications/changelog-formatter-spec.md` - Formatter tool spec

### Research Source Hubs
- `source-hubs/README.md` - Source hub guide
- `source-hubs/changelog-source-hub.md` - Changelog tools and formats
- `source-hubs/release-management-source-hub.md` - Release automation systems
- `source-hubs/readme-generation-source-hub.md` - README standards
- `source-hubs/documentation-coverage-source-hub.md` - Doc coverage tools

### Specimen Dossiers (tool analysis)
- `specimen-dossiers/changesets.md` - Fragment-driven monorepo tool
- `specimen-dossiers/semantic-release.md` - Fully automated releases
- `specimen-dossiers/release-please.md` - Google's PR-based approach
- `specimen-dossiers/towncrier.md` - Language-agnostic fragments
- `specimen-dossiers/effigy-release-system.md` - Effigy's custom approach

### Value Tracks (cross-specimen synthesis)
- `value-tracks/release-management-spectrum.md` - Automation vs control
- `value-tracks/changelog-formats.md` - Format standards analysis

### Translation Memos (recommendations)
- `translation-memos/northstar-effigy-boundary.md` - Architecture boundary
- `translation-memos/northstar-effigy-integration.md` - Integration strategy
- `translation-memos/ai-agent-release-playbook.md` - AI agent playbook
- `translation-memos/changelog-library-placement.md` - Library placement
- `translation-memos/northstar-orchestrator-thread.md` - Orchestrator, worker, and PR boundary
- `translation-memos/agent-instruction-surface-optimization.md` - Compact instruction-surface evidence
- `translation-memos/matt-pocock-skills-audit-to-northstar.md` - External skill-design translation
- `translation-memos/rust-quality-skills-and-audit.md` - Two-track Rust coding-quality model

### Prototypes
- `prototypes/rust-quality/README.md` - Rust rule catalogue, benchmark corpus, and scoring protocol

### Meta
- `README.md` - Research overview and scope
- `master-index.md` - Navigation and quick answers
- `DECISIONS.md` - Key decisions log
- `INDEX.md` - This file

---

## Key Decisions Summary

1. **Format**: Keep a Changelog 1.0.0 + strict Northstar Profile
2. **Versioning**: Changelog-first (analyze content to suggest bump)
3. **Control**: Human-gated (AI proposes, human approves)
4. **Library**: Start in Effigy, extract if needed
5. **Language**: Rust (fits Effigy ecosystem)

---

## What to Build

### Phase 1: Changelog Library
Location: `effigy/crates/changelog/`

**Features**:
- Parse Northstar Profile
- Format (remove empty sections, normalize spacing)
- Validate (strict compliance)
- Analyze (version bump suggestion)

**CLI**:
```bash
northstar-changelog validate
northstar-changelog format [--write|--preview]
northstar-changelog analyze --format=json
northstar-changelog extract --version X.Y.Z
```

### Phase 2: Release Orchestration
Location: `effigy/crates/release/` (optional)

**Features**:
- Prepare release (validate, analyze, format, gates)
- Execute release (commit, tag, monitor)

**CLI**:
```bash
northstar-release status
northstar-release prepare  # Interactive
northstar-release execute
```

---

## Test Fixtures

Primary test data:
- `~/Dev/projects/effigy/CHANGELOG.md` - Real changelog
- `~/Dev/projects/effigy/scripts/prepare-release.sh` - Current flow

---

## File Count Summary

| Category | Count |
|----------|-------|
| Handoff | 2 |
| Specifications | 2 |
| Source hubs | 5 |
| Specimen dossiers | 5 |
| Value tracks | 2 |
| Translation memos | 8 |
| Prototype documentation/data/fixtures/results | 4771 |
| Meta | 4 |
| **Total** | **4799** |

---

## Release and changelog next step

1. Read `handoff/QUICK_START.md` (5 minutes)
2. Create `effigy/crates/changelog/`
3. Start with parser
4. Test against `effigy/CHANGELOG.md`

**Ready for implementation.**

## Active translation tracks

Rust quality implementation is evidenced but not yet distributed. Research
revision F made everyday authoring eligible and research revision M made strict
explicit audit eligible. Production revision K then passed explicit audit 3/3;
production revision M passed everyday authoring 3/3 with all churn ratios below
the frozen ceiling. Strict unsafe findings remain report-only. Contract 004 and
roadmap `g02.030` are active; cards 083-087 are complete and card 088 is ready.
Compaction resilience remains unproven.
