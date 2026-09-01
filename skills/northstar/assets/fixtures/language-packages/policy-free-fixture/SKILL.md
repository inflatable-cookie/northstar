---
name: fixture-language-quality
description: Policy-free language quality package fixture for machine contracts.
metadata:
  internal: true
---

# Policy-Free Language Quality Package Fixture

This fixture is a policy-free language quality package used to prove generic
Northstar package discovery, verification, compatibility, installation,
activation, and routing contracts without carrying production language rules.

## Package Structure

- `northstar-package.json`: machine-readable package manifest
- `references/modes/fixture-audit.md`: explicit audit-and-repair workflow reference
- `scripts/self-check.rhai`: package-owned self-check entrypoint
