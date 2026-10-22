#!/bin/sh
set -e

MIGMA_SKILLS_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ ! -d "$MIGMA_SKILLS_DIR/skills" ]; then
  echo "Error: run install.sh from a complete Migma skills checkout. See https://docs.migma.ai/skills for registry install commands." >&2
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required but was not found on your PATH." >&2
  echo "npx ships with Node.js (npm). Install Node.js from https://nodejs.org/ or your package manager, then rerun this script." >&2
  exit 1
fi

if [ "${MIGMA_INSTALL_DRY_RUN:-0}" = "1" ]; then
  echo "Dry run: install bundled skills from $MIGMA_SKILLS_DIR"
  exit 0
fi

npx --yes skills add --all --global --yes "$MIGMA_SKILLS_DIR"
