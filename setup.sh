#!/bin/sh
set -e

export MIGMA_INSTALL_DRY_RUN="${MIGMA_INSTALL_DRY_RUN:-0}"

MIGMA_SETUP_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

for installer in install-cli.sh install.sh; do
  if [ ! -f "$MIGMA_SETUP_DIR/$installer" ]; then
    echo "Error: run setup.sh from a complete Migma skills checkout. See https://docs.migma.ai/agent-setup for registry install commands." >&2
    exit 1
  fi
done

if [ ! -d "$MIGMA_SETUP_DIR/skills" ]; then
  echo "Error: the Migma skills directory is missing from this checkout." >&2
  exit 1
fi

sh "$MIGMA_SETUP_DIR/install-cli.sh"
sh "$MIGMA_SETUP_DIR/install.sh"
