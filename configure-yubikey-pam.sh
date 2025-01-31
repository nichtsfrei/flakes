#!/bin/sh


mkdir -p ~/.config/Yubico
nix-shell -p pam_u2f --command "pamu2fcfg > ~/.config/Yubico/u2f_keys"
