# Rust Quality Tool Bootstrap

The agent owns this installation. Do not ask the operator to install a binary,
edit `PATH`, or add a consumer task.

The crate is `tools/rust-quality/` relative to the installed Northstar skill.
Use a Northstar-owned cache outside the consumer repository:

- macOS: `$HOME/Library/Caches/northstar/rust-quality`
- Linux: `${XDG_CACHE_HOME:-$HOME/.cache}/northstar/rust-quality`
- Windows: `%LOCALAPPDATA%\Northstar\rust-quality`

Resolve those variables to absolute paths before invoking Cargo. Never add the
cache `bin` directory to `PATH`; invoke the binary by its absolute path.

## Ensure the current payload

1. Set `<crate>` to the installed skill's `tools/rust-quality` directory and
   `<cache>` to the host-specific cache above.
2. Ensure `<cache>/probe/bin/northstar-rust-quality` exists. If missing, run:

   ```text
   cargo install --locked --offline --path <crate> --root <cache>/probe
   ```

   Retry without `--offline` only when Cargo reports a missing cached
   dependency and network access is allowed. A compiler, lockfile, or source
   failure is not a reason to drop `--locked`.
3. Run the probe binary with:

   ```text
   <cache>/probe/bin/northstar-rust-quality verify-install \
     --source-root <crate> --receipt <cache>/probe-receipt.json
   ```

   A stale probe exits non-zero but still writes the receipt. Read
   `source_payload_sha256` from that receipt; do not infer it from a version.
4. Select `<payload-root>` as `<cache>/payloads/<source_payload_sha256>`. If its
   binary is missing, run the same locked Cargo install with
   `--root <payload-root>`.
5. Invoke the payload binary's `verify-install` operation and write
   `<payload-root>/install-receipt.json`. Continue only when `current` is true
   and the embedded and source payload hashes match.
6. Use that absolute payload binary for every operation in the audit. Re-run
   this ensure sequence when the skill source changes. Old payload directories
   are inert cache entries; do not delete them during an audit.

The checksum covers `Cargo.toml`, `Cargo.lock`, `build.rs`, the diagnostic
mapping under `assets/`, and all Rust source under `src/`. Tests are
distribution evidence, not runtime payload. The locked crate requires Rust
1.95 or newer.

## Ensure the explicit-audit scanner

This step is audit-only. Everyday authoring does not install or run the scanner.

1. Set `<scanner-root>` to `<cache>/scanners/stopslop-0.5.1`.
2. If `<scanner-root>/bin/stopslop` is missing, run:

   ```text
   cargo install --locked --offline stopslop --version 0.5.1 --root <scanner-root>
   ```

   Retry without `--offline` only when Cargo reports that the pinned crate or a
   locked dependency is absent and network access is allowed. Do not install an
   unpinned version or use a Git branch.
3. Require `<scanner-root>/bin/stopslop --version` to print `stopslop 0.5.1`.
   Invoke that absolute binary path; never add it to `PATH`.
4. If installation or verification is unavailable, record the scanner request
   as `unavailable` with its actual failure stage. Do not replace it with an
   improvised text search or claim a total forwarder candidate ledger.
