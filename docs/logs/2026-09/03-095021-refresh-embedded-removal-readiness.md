# Refresh Embedded Removal Readiness

Date: 2026-09-03
Roadmap: `g02.048`
Cards: `120`, `122`
Status: inventory complete; card 122 ready; card 120 blocked

## Exact deletion inventory

The embedded package-source set is 71 tracked files. Its sorted path-list
SHA-256 is `a903af88104c56c78bca8fe098c36a760f7fe3f6fa1e726062c3394ae0f85ee4`;
the SHA-256 of the ordered GNU `sha256sum` rows for those files is
`9e8c3de697a633c5184d16d4ff1a098765bf42de7d397151ef64bfd8300678e9`.

| Closed path set | Files | Disposition |
| --- | ---: | --- |
| `skills/northstar/references/language-quality/rust/**` | 24 | delete |
| Rust audit/authoring modes, check/setup scripts | 4 | delete |
| `skills/northstar/tools/rust-quality/**` excluding runtime `target/` | 22 | delete |
| Rust command adapter and activation templates | 4 | delete |
| `skills/northstar/references/language-quality/typescript/**` | 8 | delete |
| TypeScript audit mode, check/setup/recorder scripts | 4 | delete |
| TypeScript command adapter and activation templates | 5 | delete |

The bounded fallback adds 17 deletion targets:
`references/packages/overlap-windows.{json,schema.json}`, all 13 files under
`assets/fixtures/language-packages/fallback/`, and both files under
`assets/fixtures/language-packages/negative/overlap/`. The root-only
`scripts/tests/rust-quality-production/**` cohort adds 7 package-specific test
files. Total exact deletion set: 95 tracked files.

## Integration surfaces

Nineteen files require mutation or replacement rather than blind deletion:

- routing/instructions: `skills/northstar/SKILL.md`, `agents/openai.yaml`,
  `references/router.md`, `references/modes/normalize-docs.md`, and
  `references/packages/installed-package-route.md`;
- lifecycle/discovery: official registry JSON/schema,
  `scripts/language-package-lifecycle.ts`, and
  `scripts/check-language-packages.rhai`;
- catalogues/checkers: root and skill `effigy.toml`, command-skill checker,
  skill-install checker, repo-contract data/test, and `scripts/README.md`;
- integration proof: both files under `scripts/tests/rust-package-pin/**` must
  be retired or replaced by the two-package/core-only proof;
- operator copy: `template-bundle/README.md` must describe installed packages,
  not skill-embedded setup tasks.

Research/translation history and Northstar's own consumer profiles/deviations
are not deletion targets. Generic package schemas, registry trust, lifecycle,
receipts, host protocol, installed route, and policy-free fixtures remain core.

## Readiness finding

Card 120 cannot start safely. The root currently maps intent to package ID and
version through three package-specific router branches. Official registry
entries bind immutable identity but do not carry supported language, overlay,
workflow, or activation-marker discovery data. If the 71 embedded files and
those branches disappear now, explicit missing-package requests cannot select
an official entry. Existing consumer blocks also contain the valid markers
`northstar:rust-quality` and `northstar:typescript-quality`, but core has no
data-driven mapping from either marker to one exact registry identity.

This hits card 120's stop condition: a hidden core language dependency needs a
design repair before deletion. Card 122 supplies the narrow repair by adding
registry-owned discovery metadata, exact manifest agreement, and fail-closed
generic selection. It changes no package policy and leaves the bounded
fallback in place until card 120.

## Next Task

Dispatch card 122. Stop after its review-only PR; do not start card 120.
