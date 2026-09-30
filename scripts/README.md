# Scripts

Repository-owned checks for the skill's source. Run them through `effigy qa`.

- `check-northstar-skill-install.rhai` — byte parity between
  `skills/northstar/` and an installed copy.
- `tests/language-package-routes/` — the language-package module's routing
  (needs the `northstar-language-packs` source checkout, or
  `NORTHSTAR_LANGUAGE_PACKS_ROOT`). `check:language-consumer-reruns` replays
  Rust and TypeScript audits against the self-contained fixture in
  `scripts/fixtures/language-package-reruns/`; it reads no sibling consumer
  repository and runs as part of `qa`.

The skill's own tests (`retired-concepts`, `cut`, `paseo:worktree`) live beside
their scripts in `skills/northstar/scripts/`.
