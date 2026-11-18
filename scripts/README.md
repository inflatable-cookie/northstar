# Scripts

Repository-owned checks for the skill's source. Run them through `effigy qa`.

- `check-skill-install.py [<root>]` — byte parity between each skill under
  `skills/` and its installed copy (default root `~/.agents/skills`).

The docs skill's own tests (`check-links`, `changelog`) live beside
their scripts in `skills/northstar-docs/scripts/`.
