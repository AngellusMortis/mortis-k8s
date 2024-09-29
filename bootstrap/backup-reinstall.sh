#!/usr/bin/env bash

# curl -sL https://files.wl.mort.is/backup-reinstall.sh | reinstall.sh

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --update
nixos-install --no-root-password
