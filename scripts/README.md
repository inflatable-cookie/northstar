# Scripts

Repository-owned checks for the skill's source. Run them through `effigy qa`.

- `check-northstar-skill-install.rhai` — byte parity between
  `skills/northstar/` and an installed copy.
- `tests/language-package-routes/` — the language-package module's routing
  (needs the `northstar-language-packs` sibling checkout, or
  `NORTHSTAR_LANGUAGE_PACKS_ROOT`). `check:language-consumer-reruns` replays
  audits against live sibling consumers and is not part of `qa`; it fails while
  Jetstream has no TypeScript quality marker.
- `tests/lifecycle-core/` — the v1–v4 hook bridge. Removed with the bridge.

The skill's own tests (`retired-concepts`, `cut`, `paseo:worktree`) live beside
their scripts in `skills/northstar/scripts/`.
