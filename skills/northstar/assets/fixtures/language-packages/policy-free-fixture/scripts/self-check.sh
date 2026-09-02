#!/bin/sh
# Policy-free fixture package self-check entrypoint.
# Executed by the runtime through the declared required command `sh`:
#   sh <package-root>/scripts/self-check.sh <package-root>
# Exits non-zero on any declared condition failure.
set -eu
root="${1:?usage: self-check.sh <package-root>}"
manifest="$root/northstar-package.json"
if [ ! -f "$manifest" ]; then
    echo "[fixture-package:self-check] missing manifest: $manifest" >&2
    exit 1
fi
kind=$(sed -n 's/.*"kind"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$manifest" | head -n 1)
if [ "$kind" != "language-quality" ]; then
    echo "[fixture-package:self-check] wrong package kind: $kind" >&2
    exit 1
fi
echo "[fixture-package:self-check] OK"
