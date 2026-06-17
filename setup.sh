#!/bin/sh
set -e

export MIGMA_INSTALL_DRY_RUN="${MIGMA_INSTALL_DRY_RUN:-0}"

if ! command -v curl >/dev/null 2>&1; then
  echo "Error: curl is required but was not found on your PATH." >&2
  exit 1
fi

if [ -n "${MIGMA_INSTALL_BASE_URL:-}" ]; then
  BASE_URL="${MIGMA_INSTALL_BASE_URL%/}"
  CLI_INSTALL_URL="${BASE_URL}/cli"
  SKILLS_INSTALL_URL="${BASE_URL}/skills"
else
  CLI_INSTALL_URL="${MIGMA_CLI_INSTALL_URL:-https://raw.githubusercontent.com/MigmaAI/migma-skills/main/install-cli.sh}"
  SKILLS_INSTALL_URL="${MIGMA_SKILLS_INSTALL_URL:-https://raw.githubusercontent.com/MigmaAI/migma-skills/main/install.sh}"
fi

run_install() {
  url="$1"
  tmp="$(mktemp)"
  if ! curl -fsSL "$url" -o "$tmp"; then
    rm -f "$tmp"
    return 1
  fi
  if ! sh "$tmp"; then
    rm -f "$tmp"
    return 1
  fi
  rm -f "$tmp"
}

if [ "$MIGMA_INSTALL_DRY_RUN" = "1" ]; then
  echo "Dry run: install CLI from $CLI_INSTALL_URL"
  echo "Dry run: install skills from $SKILLS_INSTALL_URL"
  exit 0
fi

run_install "$CLI_INSTALL_URL"
run_install "$SKILLS_INSTALL_URL"
