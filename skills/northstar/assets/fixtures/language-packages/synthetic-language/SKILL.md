---
name: synthetic-language-quality
description: Synthetic unknown-language package fixture for generic routing proof.
metadata:
  internal: true
---

# Synthetic Language Quality Package Fixture

This fixture declares an unknown synthetic language (`quantum-lang`) with a
declared explicit audit-and-repair workflow. It exists to prove that generic
package routing resolves candidates by manifest fields (`supported_languages`,
`available_workflows`, `kind`, `compatible_core_range`) and never by a
hard-coded core language switch.

## Package Structure

- `northstar-package.json`: machine-readable package manifest
- `scripts/self-check.sh`: package-owned self-check entrypoint (executed by the
  declared `sh` runtime command)
