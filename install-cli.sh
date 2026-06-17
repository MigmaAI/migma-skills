#!/bin/sh
set -e

PACKAGE_NAME="@migma/cli"
VERSION="${1:-latest}"

if ! command -v npm >/dev/null 2>&1; then
  echo "Error: npm is required but was not found on your PATH." >&2
  echo "npm ships with Node.js. Install Node.js 18+ from https://nodejs.org or your package manager, then rerun this script." >&2
  exit 1
fi

case "$VERSION" in
  "" | "latest")
    PACKAGE="${PACKAGE_NAME}@latest"
    ;;
  @migma/cli*)
    PACKAGE="$VERSION"
    ;;
  *)
    PACKAGE="${PACKAGE_NAME}@${VERSION}"
    ;;
esac

echo "Installing ${PACKAGE}..."

if [ "${MIGMA_INSTALL_DRY_RUN:-0}" = "1" ]; then
  echo "Dry run: npm install -g ${PACKAGE}"
  exit 0
fi

npm install -g "$PACKAGE"

echo "Done!"
if command -v migma >/dev/null 2>&1; then
  migma --version
else
  echo "Installed ${PACKAGE}, but 'migma' was not found on PATH." >&2
  echo "Check your npm global bin directory." >&2
fi
