# Repair Installed Skill Portability

Roadmap refs: g02.022, cards 065-066

## What changed

- Defined `skills/northstar/` as a self-contained Markdown-link boundary.
- Replaced seven repo-relative links with explicit target/source-repo paths.
- Made missing `bundle-docs/` normal in consumer repos.
- Made bootstrap template copy require an explicitly located Northstar source
  checkout.
- Added a recursive QA guard for escaping and missing local skill links.
- Refreshed `~/.agents/skills/northstar` from the repaired source.

## Evidence

- Pre-sync installed check failed on
  `../../../../bundle-docs/protocol-kernel.md`, reproducing the defect.
- Missing internal-target fixture failed with `broken Markdown link`.
- Repaired source check: `Portable skill links: OK`.
- `effigy qa`: bundle and repo contract checks passed.
- Installed check: `Installed skill links: OK`.
- `diff -qr skills/northstar /Users/tom/.agents/skills/northstar`: no output.
- Source and installed trees: 29 files each.

## Lane State

- g02.022 complete
- continuation envelope exhausted
- lane budget complete
- pause signal: `lane-complete`
