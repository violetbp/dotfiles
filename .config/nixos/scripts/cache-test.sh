#!/usr/bin/env bash
# Usage: ./scripts/cache-test.sh <nixpkgs-attr>   e.g. htop, git, neovim
set -euo pipefail

PACKAGE="${1:?Usage: $0 <nixpkgs-attr>}"

echo "Resolving store path for nixpkgs#${PACKAGE}..."
STORE_PATH=$(nix build "nixpkgs#${PACKAGE}" --print-out-paths --no-link 2>/dev/null)
echo "Store path: ${STORE_PATH}"

echo "Deleting from local nix store..."
nix store delete "${STORE_PATH}" 2>/dev/null \
  && echo "Deleted." \
  || echo "Could not delete (path has live references — try a leaf package like htop)."

echo "Rebuilding (should fetch from kerrigan:5000 if cache is warm)..."
time nix build "nixpkgs#${PACKAGE}" --no-link -v 2>&1 | grep -E "copying|fetching|building|real"

echo "Done: ${STORE_PATH}"
