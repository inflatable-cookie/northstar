# Scripts

Run `effigy check:skill-install` to compare each skill under `skills/` with
its installed copy. The underlying command is
`python3 scripts/check-skill-install.py [<root>]`, which defaults to
`~/.agents/skills`.

`effigy qa` runs the source checks, including the docs skill's self-tests
in `skills/northstar-docs/scripts/`.
