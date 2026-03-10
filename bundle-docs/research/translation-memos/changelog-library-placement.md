# Translation Memo: Changelog Library Placement

Status: Draft  
Memo: Where should the changelog parser/formatter library live?  
Owner: Research Initiative  
Last Updated: 2026-03-10  

## 1) The question

> Should the Rust library for parsing/updating the Northstar Changelog Profile live in Northstar or Effigy?

Key factors:
- It's opinionated (implements the Northstar Profile)
- Effigy will be the primary invoker
- It's a library, not just a spec
- Other tools might want to use it

## 2) Option analysis

### Option A: Library lives in Northstar

**Structure**:
```
northstar/
├── bundle-docs/research/          # Profile spec
└── crates/changelog/              # Rust library
    ├── src/lib.rs                 # Parser, formatter
    └── Cargo.toml

effigy/
└── Cargo.toml
    # dependency: northstar-changelog = "1.0"
```

**Pros**:
- Library implements the standard defined in Northstar (clean separation)
- Other projects can use the library without depending on Effigy
- Northstar "owns" the format, so it owns the reference implementation
- Clearer for external adoption ("use this library for Northstar-compliant changelogs")

**Cons**:
- Two repos to coordinate for changes
- Effigy has a dependency on Northstar
- Northstar becomes a code project, not just docs/templates
- Release coordination complexity (library vs spec updates)

**When to choose**: If the library is meant to be a standard tool beyond just Effigy.

---

### Option B: Library lives in Effigy

**Structure**:
```
northstar/
└── bundle-docs/research/specifications/northstar-changelog-profile.md
    # Just the spec

effigy/
├── crates/
│   ├── effigy-core/               # Main effigy code
│   └── changelog/                 # Changelog library
│       ├── src/lib.rs
│       └── Cargo.toml
```

**Pros**:
- Single repo for Effigy's release management
- Library developed alongside the tool that uses it
- Faster iteration (no cross-repo coordination)
- Effigy owns the implementation of its release workflow

**Cons**:
- Other projects need to depend on Effigy to get the library
- Northstar has a spec but no reference implementation
- Potential for spec drift if Effigy extends without updating Northstar

**When to choose**: If the library is primarily an Effigy implementation detail.

---

### Option C: Start in Effigy, extract if needed

**Structure (now)**:
```
effigy/
└── crates/changelog/              # Library inside Effigy
```

**Structure (later, if needed)**:
```
northstar/
└── crates/changelog/              # Extracted library

effigy/
└── Cargo.toml
    # dependency: northstar-changelog = "1.0"
```

**Pros**:
- Immediate pragmatism: build where it's needed
- No premature abstraction
- Can extract if other use cases emerge
- Keeps Northstar lean until there's demand

**Cons**:
- Extraction is work later
- Other projects might want it before extraction happens
- Initial adoption path is less clear

**When to choose**: Uncertain about broader adoption, want to validate first.

---

## 3) Recommendation

**Option C: Start in Effigy, extract if needed.**

### Rationale

1. **YAGNI**: You don't have a second consumer yet. Build for the need you have (Effigy's releases).

2. **Opinionated coupling**: The library implements the Northstar Profile, but it's shaped by how Effigy needs to use it (release gates, version bumping, extraction for GitHub releases).

3. **Iteration speed**: Building inside Effigy lets you evolve the API alongside the release playbook. You'll learn what the library needs to do by building the tool that uses it.

4. **Northstar's role**: Northstar defines the **profile spec** - the contract. Effigy implements the **parser** - the tool. This mirrors standards bodies vs browser implementations.

5. **Extraction path**: If/when another tool needs it, extraction is straightforward:
   - Move `crates/changelog` to Northstar
   - Publish as `northstar-changelog` crate
   - Effigy adds dependency
   - Both use the same library

### Recommended structure

```
effigy/
├── crates/
│   ├── effigy-core/               # Main effigy binary/library
│   ├── effigy-changelog/          # Changelog parser/formatter
│   │   ├── src/
│   │   │   ├── lib.rs             # Public API
│   │   │   ├── parser.rs          # Parse changelog to AST
│   │   │   ├── formatter.rs       # Format AST to string
│   │   │   ├── validator.rs       # Validate against profile
│   │   │   └── bump.rs            # Version bump logic
│   │   └── Cargo.toml
│   └── effigy-release/            # Release orchestration (optional)
│       └── src/lib.rs             # Uses effigy-changelog
```

Northstar stays focused:
```
northstar/
└── bundle-docs/research/specifications/
    └── northstar-changelog-profile.md
    # The spec that effigy-changelog implements
```

## 4) Contract between Northstar and Effigy

**Northstar provides**:
- The profile specification (the "what")
- Format validation requirements
- Version bump semantics

**Effigy provides**:
- The implementation (the "how")
- CLI tools that use the library
- Integration with release workflow

**Synchronization**:
- Effigy changelog library version declares which profile version it implements
- Profile changes in Northstar trigger updates in Effigy
- Both use the same test fixtures for validation

## 5) Migration path to extraction

If/when extraction is needed:

1. **Create `northstar-changelog` crate** in Northstar repo
2. **Copy implementation** from `effigy-changelog`
3. **Publish to crates.io** as `northstar-changelog`
4. **Update Effigy** to depend on `northstar-changelog`
5. **Deprecate `effigy-changelog`** crate
6. **Both share** the same library

Effort: ~1 day of refactoring.

## 6) Why not Option A (library in Northstar now)?

Premature. You'd be:
- Maintaining a crate with one consumer
- Coordinating releases across repos
- Adding complexity before validating the design

Better to prove the library works for Effigy, then extract if demand exists.

## 7) Why not Option B forever?

If the Northstar Profile gains traction outside Effigy, other tools will want the library. At that point, extraction makes sense. Northstar becomes the "standard library" for compliant changelogs.

But that's a future state. Don't optimize for it now.

## 8) Decision

**Start `effigy-changelog` crate inside the Effigy repository.**

It implements the Northstar Changelog Profile as defined in `bundle-docs/research/specifications/northstar-changelog-profile.md`.

If/when another project needs it, extract to Northstar and publish as `northstar-changelog`.

## Next step

Create `crates/changelog` in Effigy repo with:
1. Parser for Northstar Profile
2. Formatter (remove empty sections, normalize spacing)
3. Validator (strict profile compliance)
4. Version bump analyzer

Start with parser tests using Effigy's own CHANGELOG.md as fixtures.
