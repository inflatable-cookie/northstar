# Scripts

Repository-owned checks for the skill's source. Run them through `effigy qa`.

- `check-skill-install.py [<root>]` — byte parity between each skill under
  `skills/` and its installed copy (default root `~/.agents/skills`).

The skill's own tests (`retired-concepts`, `cut`, `changelog`) live beside
their scripts in `skills/northstar/scripts/`.
