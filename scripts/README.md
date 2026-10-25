# Scripts

Repository-owned checks for the skill's source. Run them through `effigy qa`.

- `check-northstar-skill-install.rhai` — byte parity between
  `skills/northstar/` and an installed copy.
- `tests/language-package-routes/` — the language-package module's routing
  (needs the `northstar-language-packs` source checkout, or
  `NORTHSTAR_LANGUAGE_PACKS_ROOT`). `check:language-consumer-reruns` replays
  Rust and TypeScript audits against the self-contained fixture in
  `scripts/fixtures/language-package-reruns/`; it reads no sibling consumer
  repository and runs as part of `qa`. Its Rust Cargo steps run under
  `oxide exec` against the throwaway consumer copy, so the fixture keeps its
  offline Cargo arguments and evidence format while Oxide holds the slot. The
  private final target is chosen inside the command after `--`, with an `env
  CARGO_TARGET_DIR=<dir>` override in the tool's own child environment,
  because `oxide exec` replaces an inherited `CARGO_TARGET_DIR` with
  `<workspace>/target`. The check hands `oxide exec` a decoy outer target and
  keeps the copy's `target/` a real empty directory, which holds Oxide in
  permanent-drive mode instead of converting it to an owned outputs link; it
  then proves normal placement, placement after a failed command, preserved
  pre-existing content and an untouched decoy. The private target sits in the
  check's own throwaway root, removed with it, so this proof needs no scratch
  mount.

The skill's own tests (`retired-concepts`, `cut`, `paseo:worktree`) live beside
their scripts in `skills/northstar/scripts/`.
