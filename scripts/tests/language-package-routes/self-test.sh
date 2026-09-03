#!/usr/bin/env bash

set -euo pipefail

harness_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)

exec python3 "$harness_dir/validate_language_package_routes.py"
