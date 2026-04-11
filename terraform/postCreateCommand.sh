#!/bin/bash
set -euo pipefail

# Install misc commands
aqua install --config "${DEVCONTAINER_NAME}/aqua.yaml"

# Setup starship config
mkdir -p "${HOME}/.config"
cp "${DEVCONTAINER_NAME}/starship.toml" "${HOME}/.config/starship.toml"
