#!/usr/bin/env bash
# Committed Queue hook launcher for the Northstar lifecycle adapter.
#
# Queue executes this pinned repository file with literal argv and no shell.
# The complete lifecycle runtime — adapter, reducer, and schemas — is committed
# beside it in northstar-lifecycle.runtime/. This launcher resolves only those
# repository bytes: never $HOME, a globally installed skill, PATH, the network,
# or the Northstar source checkout. The adapter reads the generic event JSON on
# stdin; event data never reaches this script's arguments or environment beyond
# Queue's own contract variables.
set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
runtime="$here/northstar-lifecycle.runtime"
adapter="$runtime/scripts/lifecycle-queue-hook.ts"

if [ ! -f "$adapter" ]; then
  echo "northstar lifecycle hook: committed runtime missing at $adapter" >&2
  exit 1
fi

exec bun run "$adapter"
