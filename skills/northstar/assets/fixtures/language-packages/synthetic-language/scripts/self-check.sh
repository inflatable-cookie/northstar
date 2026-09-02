#!/bin/sh
# Synthetic unknown-language fixture package self-check entrypoint.
# Executed by the runtime through the declared required command `sh`:
#   sh <package-root>/scripts/self-check.sh <package-root>
set -eu
root="${1:?usage: self-check.sh <package-root>}"
manifest="$root/northstar-package.json"
if [ ! -f "$manifest" ]; then
    echo "[synthetic-package:self-check] missing manifest: $manifest" >&2
    exit 1
fi
kind=$(sed -n 's/.*"kind"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$manifest" | head -n 1)
if [ "$kind" != "language-quality" ]; then
    echo "[synthetic-package:self-check] wrong package kind: $kind" >&2
    exit 1
fi
echo "[synthetic-package:self-check] OK"
