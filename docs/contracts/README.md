# Contracts

Use this folder for explicit non-code contracts that constrain Northstar's own
development behavior.

Examples:

- compact working-rules contracts
- seam-specific or authority contracts when needed
- other durable rules that must stand apart from architecture/specs

## Rule

Use this folder sparingly. Keep the general delivery rules compact, and add a
separate contract only when a seam or boundary genuinely needs an independent
reference surface.

`rust-quality-profile.json` and `rust-quality-deviations.json` are consumer
configuration governed by contract 004, not separate contracts. Their
copy-ready source is under
`skills/northstar/assets/templates/language-quality/rust/`.
