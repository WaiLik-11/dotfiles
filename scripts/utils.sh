#!/usr/bin/env bash

command_exists() { command -v "$1" >/dev/null 2>&1; }

prompt_yesno() {
  local q="$1" def="${2:-true}" ans
  if [ "$def" = true ]; then
    read -r -p "$q [Y/n]: " ans
    ans="${ans:-Y}"
  else
    read -r -p "$q [y/N]: " ans
    ans="${ans:-N}"
  fi
  [[ "$ans" =~ ^[Yy]$ ]]
}
