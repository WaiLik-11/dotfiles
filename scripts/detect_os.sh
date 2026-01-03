#!/usr/bin/env bash

OS="unknown"

if [[ "$(uname -s)" == "Darwin" ]]; then
  OS="macos"
elif [[ "$(uname -s)" == "Linux" ]]; then
  grep -qi microsoft /proc/version 2>/dev/null && OS="wsl" || OS="linux"
fi

export OS

require_macos_linux() {
  if [[ "$OS" == "unknown" ]]; then
    echo "X Unsupported OS"
    exit 1
  fi
}
