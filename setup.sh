#!/usr/bin/env bash
# Shim: default to the lightweight initializer.
# Use `./setup_full.sh <project-name>` for the full, opinionated workflow.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/setup_light.sh" "$@"
