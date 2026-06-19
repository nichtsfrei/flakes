#!/bin/sh

echo "Deleting previous generations before the last 7:"
sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system
echo
echo "Garbage collecting older than 30d:"
sudo nix-collect-garbage --delete-older-than 30d
echo
echo "Hard linking duplicates:"
nix store optimise
