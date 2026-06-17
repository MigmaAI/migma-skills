#!/bin/sh
set -e

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required but was not found on your PATH." >&2
  echo "npx ships with Node.js (npm). Install Node.js from https://nodejs.org/ or your package manager, then rerun this script." >&2
  exit 1
fi

if [ "${MIGMA_INSTALL_DRY_RUN:-0}" = "1" ]; then
  echo "Dry run: npx --yes skills add --all --global --yes https://github.com/MigmaAI/migma-skills"
  exit 0
fi

npx --yes skills add --all --global --yes https://github.com/MigmaAI/migma-skills
