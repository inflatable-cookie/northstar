# Translation Memo: Northstar-Effigy Integration Analysis

Status: Draft  
Memo: How Effigy's Existing Release System Informs Northstar's Design  
Owner: Research Initiative  
Last Updated: 2026-03-10  
Related track: Release Management Spectrum, Changelog Formats

## 1) Problem statement

Effigy already has a sophisticated, custom release management system that:
- Uses changelog-first versioning (not commit-driven)
- Requires human approval (not fully automated)
- Has extensive validation gates
- Supports multi-channel distribution
- Is documented with runbooks and checklists

The question is: **How should Northstar's generic release management definitions relate to Effigy's existing system?**

Options:
1. Ignore Effigy's custom system, design Northstar around standard tools only
2. Generalize Effigy's approach into Northstar contracts
3. Treat Effigy as a special case that bypasses Northstar abstractions
4. Refactor Effigy to use Northstar contracts once defined

## 2) External evidence summary

### What Effigy's system demonstrates

**Working patterns**:
- `prepare-release.sh` analyzes CHANGELOG and computes version → **state-based versioning**
- `check-release-gates.sh` provides reusable validation → **gate pattern**
- Tag-triggered CI with multi-platform builds → **artifact pipeline**
- Closeout logs for evidence → **audit trail**
- Setup action for consumers → **distribution helper**

**Pain points**:
- Custom scripts maintained in-house
- No ecosystem reuse (not using semantic-release, changesets, etc.)
- Manual changelog discipline (no bot enforcement)
- GitHub Actions specific

### What researched tools offer

| Tool | Effigy Could Use For | Barrier |
|------|---------------------|---------|
| **Changesets** | Fragment-based changelog entries | Extra workflow step, JS ecosystem |
| **Release Please** | PR-based release automation | Less control over multi-channel flow |
| **Semantic Release** | Fully automated | No human gate, commit discipline |
| **Towncrier** | Language-agnostic changelog | Python dependency, extra step |

### Gap analysis

None of the researched tools directly support Effigy's exact workflow:
- Changelog-first versioning (not commit-driven or fragment-driven)
- Multi-channel distribution with custom validation
- Human-gated with extensive pre-release checks

## 3) Recommendation

### Core insight

Effigy's approach represents a **valid but distinct pattern** that Northstar should support as a first-class option: **"Changelog-first, human-gated release flow"**.

### Integration strategy

**Phase 1: Define Northstar contracts that encompass Effigy's approach**

Northstar should define release contracts at three levels:

1. **Policy level** (what):
   - Versioning policy: SemVer, changelog-first
   - Control policy: Human-gated, automated
   - Distribution policy: Multi-channel (GitHub, Homebrew, crates.io)

2. **Phase level** (when):
   - Prepare → Validate → Commit → Tag → Distribute → Verify
   - Each phase has entry/exit criteria

3. **Implementation level** (how):
   - Tool-agnostic: Could use scripts, existing tools, or hybrid
   - Northstar provides templates for common patterns

**Phase 2: Refactor Effigy to use Northstar contracts**

Once Northstar defines:
- `northstar/release-policy.toml` template
- `northstar/changelog-format.toml` template
- `northstar/release-gates.schema.json`

Effigy could:
- Adopt the policy templates
- Map existing scripts to the phase contracts
- Become a reference implementation for "custom script" approach

**Phase 3: Effigy as tool orchestrator**

Effigy could invoke Northstar-defined release flows:

```toml
# effigy.toml
[release]
policy = "northstar/release-policy@v1"
changelog = "northstar/changelog-keep-a-changelog@v1"
gates = [
  "check-release-gates.sh",
  "check-distribution-metadata.sh --tag {version}"
]
channels = ["github-releases", "homebrew", "crates-io"]
```

### Northstar contract design

**Release Policy Contract** (Northstar defines):

```toml
[northstar.release.policy]
versioning = "semver"  # semver, calver, etc.
version_source = "changelog"  # changelog, commits, changesets, manual
control_gate = "human"  # human, pr-review, automated

[northstar.release.phases]
prepare = { required = true, tool = "optional" }
validate = { required = true, gates = [] }
commit = { required = true, message_template = "release: v{version}" }
tag = { required = true, prefix = "v" }
distribute = { channels = [] }
verify = { required = true }
```

**Effigy's mapping**:

```toml
# Effigy's northstar-compatible config
[northstar.release.policy]
versioning = "semver"
version_source = "changelog"  # Effigy's custom script
control_gate = "human"

[northstar.release.phases.prepare]
script = "./scripts/prepare-release.sh --apply"

[northstar.release.phases.validate]
scripts = [
  "./scripts/check-release-gates.sh",
  "./scripts/check-distribution-metadata.sh"
]
```

## 4) Tradeoffs

### Accepted tradeoffs

1. **More abstraction complexity**: Supporting both standard tools and custom scripts adds complexity to Northstar contracts.

2. **Template proliferation**: Supporting Effigy's approach means more templates to maintain.

3. **Slower initial delivery**: Generalizing Effigy's approach takes more time than just wrapping semantic-release.

### Rejected alternatives

1. **Mandate that Effigy switch to changesets**: Too disruptive, loses hard-won distribution automation.

2. **Ignore Effigy's approach as "non-standard"**: Misses opportunity to learn from real-world usage.

3. **Build new tool that replaces Effigy's scripts**: Not justified; existing scripts work well.

## 5) What must be true before adoption

1. **Effigy team buy-in**: Confirm Effigy wants to align with Northstar contracts.

2. **Prototype**: Build proof-of-concept showing Effigy's scripts wrapped in Northstar contract.

3. **Validation**: Verify the abstraction doesn't make Effigy's workflow worse.

## 6) Required work

### Northstar side

1. Define `release-policy` contract schema
2. Define `changelog-format` contract schema
3. Create templates for:
   - Changelog-first, human-gated (Effigy's pattern)
   - Commit-driven, automated (semantic-release pattern)
   - Fragment-driven, PR-gated (changesets pattern)

### Effigy side

1. Map existing scripts to Northstar phase contracts
2. Create `northstar.toml` or similar declaring compliance
3. Test that Northstar validation passes on Effigy repo

## 7) Promotion target

- `architecture work` - Design the release contract schema
- `roadmap planning` - Schedule integration work
- `watch only` - Continue observing Effigy's evolution
- `reject` - Keep systems separate

**Recommendation**: `architecture work` → `roadmap planning`

Northstar should design contracts that can accommodate Effigy's approach as a valid pattern, then work with Effigy to align implementations.

## 8) Sources

| Source | Confidence | Notes |
|--------|------------|-------|
| Effigy specimen dossier | High | Internal analysis |
| Release Management Spectrum | High | Tool comparison |
| Changelog Formats | High | Format standards |
| Effigy source code | High | Real implementation |

## Next Task

Present this analysis to both Northstar and Effigy stakeholders to confirm the integration approach before proceeding with contract design.
