#! /bin/sh

COMMAND="$1"
 
if [ -z "$COMMAND" ]; then
  echo "Expected a command like 'build' or 'switch' but received an empty string"
  exit 1
fi

if [ "$COMMAND" != "build" ] && [ "$COMMAND" != "switch" ]; then
  echo "Expected a command like 'build' or 'switch' but received '$COMMAND'"
  exit 1
fi

sudo nixos-rebuild "$1" --flake ~/.dotfiles
