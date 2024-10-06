#!/usr/bin/env bash

# curl -sL https://files.wl.mort.is/backup-reinstall.sh | bash

nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --add https://github.com/Mic92/sops-nix/archive/master.tar.gz sops-nix
nix-channel --update
nixos-install --no-root-password
