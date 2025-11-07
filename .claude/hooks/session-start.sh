#!/bin/bash
set -euo pipefail

# Only run in remote environments (Claude Code on the web)
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

echo "Installing dependencies for Quoncierge development..."

# Install ShellCheck for bash script linting
# Using apt-get since this runs in a Debian/Ubuntu-based container
if ! command -v shellcheck &> /dev/null; then
  echo "Installing ShellCheck..."
  apt-get install -y -qq shellcheck > /dev/null 2>&1
  echo "✓ ShellCheck installed"
else
  echo "✓ ShellCheck already installed"
fi

echo "Dependencies installed successfully!"
